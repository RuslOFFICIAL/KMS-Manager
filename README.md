KMS-Manager - Activate Windows by KMS key.
It's recommended to change "KMS_Server" variable in "Variables.conf" to your own KMS Server, follow up with "Variables.conf.example" file.

To make your own KMS Server you need to use Linux or WSL, be in the same network as a Windows client, and run next command in repository directory:
sudo bash "vlmcsd.sh"
