#!/bin/bash
[ -n "$BASH_VERSION" ] && set +H
cd "$(dirname "$0")" || exit

# Variables.
VARIABLES_FILE_NAME="Variables.conf"
VARIABLES_FILE="../Configs/$VARIABLES_FILE_NAME"
ENV_FILE_NAME=".env"
ENV_FILE="../Configs/$ENV_FILE_NAME"

# Configs.
if [ -f "$VARIABLES_FILE" ]; then
	while IFS='=' read -r key value; do
		[[ "$key" =~ ^#.* ]] || [[ -z "$key" ]] && continue
		clean_value="${value%$'\r'}"
		export "$key=$clean_value"
	done < "$VARIABLES_FILE"
else
	echo "[WARNING]: File not found at '$VARIABLES_FILE'!" && echo -e "Check if there is that file or download it from the repository!\n"
fi

# Admin check.
if [ "$EUID" -ne 0 ]; then
	echo "Failure: This script must be run as an Administrator (sudo)."
	echo "Try running command: sudo bash \"vlmcsd.sh\""
	read -s -p "Press [Enter] to continue..." && exit 1
fi

echo -e "vlmcsd $vlmcsd_Version\n"

# Confirmation.
while true; do
	read -r -e -p "Run this script? (Y/N) " confirmation
	case "$confirmation" in
		[Yy]* ) echo; break ;;
		[Nn]* ) echo -e "\nOperation cancelled by user.\n"; read -s -p "Press [Enter] to continue..."; exit 0 ;;
		* ) echo -e "Please answer Y or n.\n" ;;
	esac
done

echo "Starting KMS Server Setup..."

# Check if build dependencies are already installed
if command -v git &>/dev/null && command -v make &>/dev/null && command -v gcc &>/dev/null; then
	echo -e "\nDependencies ('git', 'make', 'gcc') are already installed. Skipping package manager installation."
else
	# Detect distribution and install dependencies
	if [ -f /etc/os-release ]; then
		. /etc/os-release
		OS=$ID
	elif [ -f /etc/debian_version ]; then
		OS="debian"
	elif [ -f /etc/redhat-release ]; then
		OS="rhel"
	else
		echo "Could not detect the operating system. Please install 'git' and 'build-essential' manually."
		read -s -p "Press [Enter] to continue..." && exit 1
	fi

	echo -e "\nDetected OS: $OS"

	case "$OS" in
		ubuntu|debian|linuxmint|pop)
			apt update
			apt install git build-essential -y
			;;
		arch|manjaro|endeavouros)
			pacman -Syu --needed git base-devel --noconfirm
			;;
		fedora|rhel|centos)
			dnf install git @development-tools -y
			;;
		opensuse*|sles)
			zypper refresh
			zypper install -t pattern devel_C_C++ -y
			zypper install git -y
			;;
		*)
			echo "Unsupported distribution family: $OS. Please install 'git', 'make', and a C compiler manually."
			exit 1
			;;
	esac
fi

# Automatically update config file.
cd "$(dirname "$0")" || exit

if [ -f "$ENV_FILE" ]; then
	KMS_IP=$(hostname -I | awk '{print $1}')
	if [ -n "$KMS_IP" ]; then
		if grep -q "^KMS_Server=" "$ENV_FILE"; then
			sed -i "s/^KMS_Server=.*/KMS_Server=$KMS_IP/" "$ENV_FILE"
		else
			echo "KMS_Server=$KMS_IP" >> "$ENV_FILE"
		fi
		echo -e "\nSuccessfully updated $ENV_FILE with 'KMS_Server=$KMS_IP'"
	fi
else
	echo -e "\nWARNING: $ENV_FILE not found in this directory, skipping config update."
fi

# Check if vlmcsd is already installed
if command -v vlmcsd &>/dev/null; then
	echo -e "\nvlmcsd is already installed. Skipping compilation and installation."
else
	# Install vlmcsd.
	echo -e "\nInstalling vlmcsd..."
	cd /tmp
	pkill -x vlmcsd || true
	rm -rf vlmcsd
	git clone "https://github.com/Wind4/vlmcsd.git"
	cd vlmcsd
	make
	cp bin/vlmcsd /usr/local/bin/vlmcsd
	cd /tmp
	rm -rf vlmcsd
fi

# Check if vlmcsd is already running before starting it.
if pgrep -x vlmcsd &>/dev/null; then
	echo -e "\nvlmcsd daemon is already running. Skipping startup."
else
	echo -e "\nStarting vlmcsd daemon..."
	vlmcsd
fi

echo -e "\nKMS Server has been successfully set up and started!"
echo -e "\nYour KMS IPv4 is: $(hostname -I | awk '{print $1}')"

read -s -p $'Press [Enter] to continue...\n' && exit 0
