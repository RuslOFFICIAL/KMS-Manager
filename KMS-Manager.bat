@echo off
cd /d "%~dp0"
setlocal

REM Admin check.
net session >nul 2>&1
if %errorlevel% equ 0 (
	goto GetReady
) else (
	echo Failure: This script must be run as an Administrator.& echo.
	pause& exit
)

REM Get ready.
:GetReady

REM Variables.
set "Version=1.0"
set "KeysFileName=KMS-Keys.conf"
set "KeysFile=%KeysFileName%"

REM Configs.
if exist "%KeysFile%" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("%KeysFile%") do set "%%A=%%~B"
) else (
	echo [FATAL]: File not found at '%KeysFile%'! & echo Check if you have that file or download it from GitHub repository! & echo.
	pause& echo.& exit
)

REM GVLK Key.
:GVLK
echo.&echo KMS-Manager %Version%& echo.
echo For which Windows Edition do you need the GVLK Key?
echo [1] Windows Client& echo [2] Windows Server
echo.

choice /c 12 /n /m "Enter your choice (1, 2): "
if %errorlevel%==2 goto WinServer
if %errorlevel%==1 goto WinClient

:WinClient
echo.
echo [1] Windows 11/10& echo [2] Windows Enterprise LTSC/LTSB& echo [3] Windows Enterprise IoT LTSC 2024/2021& echo [4] Windows Client Earlier Versions (8.1, 8, 7, Vista)
echo.

choice /c 1234 /n /m "Enter your choice (1, 2, 3, 4): "
if %errorlevel%==4 goto WinClientEarly
if %errorlevel%==3 set "GVLKKey=%Client_Enterprise_IoT_LTSClient_2024_2021%"& goto KMS
if %errorlevel%==2 goto WinClientEnterpriseLTSCB
if %errorlevel%==1 goto WinClient1110

:WinClientEnterpriseLTSCB
echo.
echo [1] Windows 11 LTSC 2024 / Windows 10 LTSC 2021, 2019& echo [2] Windows 10 LTSB 2016 & echo [3] Windows 10 LTSB 2015
echo.

choice /c 123456 /n /m "Enter your choice (1, 2, 3, 4, 5, 6): "
if %errorlevel%==3 goto WinClient102015
if %errorlevel%==2 goto WinClient102016
if %errorlevel%==1 goto WinClient1110LTSC

:WinClientEarly
echo.
echo [1] Windows 8.1& echo [2] Windows 8&echo [3] Windows 7& echo [4] Windows Vista
echo.

choice /c 123456 /n /m "Enter your choice (1, 2, 3, 4, 5, 6): "
if %errorlevel%==4 goto WinClientVista
if %errorlevel%==3 goto WinClient7
if %errorlevel%==2 goto WinClient8
if %errorlevel%==1 goto WinClient81

:WinClientVista
echo.
echo [1] Windows Vista Business& echo [2] Windows Vista Business N&echo [3] Windows Vista Enterprise& echo [4] Windows Vista Enterprise N
echo.

choice /c 1234 /n /m "Enter your choice (1, 2, 3, 4): "
if %errorlevel%==4 set "GVLKKey=%Client_Enterprise_N_Vista%"& goto KMS
if %errorlevel%==3 set "GVLKKey=%Client_Enterprise_Vista%"& goto KMS
if %errorlevel%==2 set "GVLKKey=%Client_BusinesServer_N_Vista%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Client_BusinesServer_Vista%"& goto KMS

:WinClient7
echo.
echo [1] Windows 7 Professional& echo [2] Windows 7 Professional N&echo [3] Windows 7 Professional E&echo [4] Windows 7 Enterprise& echo [5] Windows 7 Enterprise N& echo [6] Windows 7 Enterprise E
echo.

choice /c 123456 /n /m "Enter your choice (1, 2, 3, 4, 5, 6): "
if %errorlevel%==6 set "GVLKKey=%Client_Enterprise_E_7%"& goto KMS
if %errorlevel%==5 set "GVLKKey=%Client_Enterprise_N_7%"& goto KMS
if %errorlevel%==4 set "GVLKKey=%Client_Enterprise_7%"& goto KMS
if %errorlevel%==3 set "GVLKKey=%Client_Professional_E_7%"& goto KMS
if %errorlevel%==2 set "GVLKKey=%Client_Professional_N_7%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Client_Professional_7%"& goto KMS

:WinClient8
echo.
echo [1] Windows 8 Pro& echo [2] Windows 8 Pro N&echo [3] Windows 8 Enterprise& echo [4] Windows 8 Enterprise N
echo.

choice /c 1234 /n /m "Enter your choice (1, 2, 3, 4): "
if %errorlevel%==4 set "GVLKKey=%Client_Enterprise_N_8%"& goto KMS
if %errorlevel%==3 set "GVLKKey=%Client_Enterprise_8%"& goto KMS
if %errorlevel%==2 set "GVLKKey=%Client_Pro_N_8%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Client_Pro_8%"& goto KMS

:WinClient81
echo.
echo [1] Windows 8.1 Pro& echo [2] Windows 8.1 Pro N&echo [3] Windows 8.1 Enterprise& echo [4] Windows 8.1 Enterprise N
echo.

choice /c 1234 /n /m "Enter your choice (1, 2, 3, 4): "
if %errorlevel%==4 set "GVLKKey=%Client_Enterprise_N_81%"& goto KMS
if %errorlevel%==3 set "GVLKKey=%Client_Enterprise_81%"& goto KMS
if %errorlevel%==2 set "GVLKKey=%Client_Pro_N_81%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Client_Pro_81%"& goto KMS

:WinClient102015
echo.
echo [1] Windows 10 Enterprise LTSB 2015& echo [2] Windows 10 Enterprise N LTSB 2015
echo.

choice /c 12 /n /m "Enter your choice (1, 2): "
if %errorlevel%==2 set "GVLKKey=%Client_Enterprise_LTSB_N_10_2015%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Client_Enterprise_LTSB_10_2015%"& goto KMS

:WinClient102016
echo.
echo [1] Windows 10 Enterprise LTSB 2016& echo [2] Windows 10 Enterprise N LTSB 2016
echo.

choice /c 12 /n /m "Enter your choice (1, 2): "
if %errorlevel%==2 set "GVLKKey=%Client_Enterprise_LTSB_N_10_2016%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Client_Enterprise_LTSB_10_2016%"& goto KMS

:WinClient1110LTSC
echo.
echo [1] Windows 11 Enterprise LTSC 2024 / Windows 10 Enterprise LTSC 2021/2019& echo [2] Windows 11 Enterprise N LTSC 2024 / Windows 10 Enterprise N LTSC 2021/2019
echo.

choice /c 12 /n /m "Enter your choice (1, 2): "
if %errorlevel%==2 set "GVLKKey=%Client_Enterprise_LTSClient_N_11_2024_10_2021_2019%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Client_Enterprise_LTSClient_11_2024_10_2021_2019%"& goto KMS

:WinClient1110
echo.
echo [1] Windows 11/10 Pro& echo [2] Windows 11/10 Pro N& echo [3] Windows 11/10 Pro for Workstations& echo [4] Windows 11/10 Pro for Workstations N& echo [5] Windows 11/10 Pro Education& echo [6] Windows 11/10 Pro Education N& echo [7] Windows 11/10 Education& echo [8] Windows 11/10 Education N& echo [9] Windows 11/10 Enterprise& echo [a] Windows 11/10 Enterprise N& echo [b] Windows 11/10 Enterprise G& echo [c] Windows 11/10 Enterprise G N
echo.

choice /c 123456789abc /n /m "Enter your choice (1, 2, 3, 4, 5, 6, 7, 8, 9, a, b, c): "
if %errorlevel%==12 set "GVLKKey=%Client_Enterprise_G_N_11_10%"& goto KMS
if %errorlevel%==11 set "GVLKKey=%Client_Enterprise_G_11_10%"& goto KMS
if %errorlevel%==10 set "GVLKKey=%Client_Enterprise_N_11_10%"& goto KMS
if %errorlevel%==9 set "GVLKKey=%Client_Enterprise_11_10%"& goto KMS
if %errorlevel%==8 set "GVLKKey=%Client_Education_N_11_10%"& goto KMS
if %errorlevel%==7 set "GVLKKey=%Client_Education_11_10%"& goto KMS
if %errorlevel%==6 set "GVLKKey=%Client_Pro_Education_N_11_10%"& goto KMS
if %errorlevel%==5 set "GVLKKey=%Client_Pro_Education_11_10%"& goto KMS
if %errorlevel%==4 set "GVLKKey=%Client_Pro_Workstation_N_11_10%"& goto KMS
if %errorlevel%==3 set "GVLKKey=%Client_Pro_Workstation_11_10%"& goto KMS
if %errorlevel%==2 set "GVLKKey=%Client_Pro_N_11_10%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Client_Pro_11_10%"& goto KMS



:WinServer
echo.
echo [1] Windows Server 2025& echo [2] Windows Server 2022& echo [3] Windows Server 2019& echo [4] Windows Server 2016& echo [5] Windows Server Semi-Annual Channel (20H2, 2004, 1909, 1903, 1809)& echo [6] Windows Server Earlier Versions (1803, 1709, 2012 R2, 2012, 2008 R2, 2008)
echo.

choice /c 123456 /n /m "Enter your choice (1, 2, 3, 4, 5, 6): "
if %errorlevel%==6 goto WinServerEarly
if %errorlevel%==5 goto WinServerSA
if %errorlevel%==4 goto WinServer2016
if %errorlevel%==3 goto WinServer2019
if %errorlevel%==2 goto WinServer2022
if %errorlevel%==1 goto WinServer2025

:WinServerEarly
echo.
echo [1] Windows Server 1803& echo [2] Windows Server 1709&echo [3] Windows Server 2012 R2& echo [4] Windows Server 2012& echo [5] Windows Server 2008 R2& echo [6] Windows Server 2008 
echo.

choice /c 123456 /n /m "Enter your choice (1, 2, 3, 4, 5, 6): "
if %errorlevel%==6 goto WinServer2008
if %errorlevel%==5 goto WinServer2008R2
if %errorlevel%==4 goto WinServer2012
if %errorlevel%==3 goto WinServer2012R2
if %errorlevel%==2 goto WinServer1709
if %errorlevel%==1 goto WinServer1803

:WinServerSA
echo.
echo [1] Windows Server Standard& echo [2] Windows Server Datacenter
echo.

choice /c 12 /n /m "Enter your choice (1, 2): "
if %errorlevel%==2 set "GVLKKey=%Server_SA_Datacenter%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Server_SA_Standard%"& goto KMS

:WinServer2008
echo.
echo [1] Windows Web Server 2008& echo [2] Windows Server 2008 Standard& echo [3] Windows Server 2008 Standard without Hyper-V& echo [4] Windows Server 2008 Enterprise& echo [5] Windows Server 2008 Enterprise without Hyper-V& echo [6] Windows Server 2008 HPC& echo [7] Windows Server 2008 Datacenter& echo [8] Windows Server 2008 Datacenter without Hyper-V& echo [9] Windows Server 2008 for Itanium-based Systems
echo.

choice /c 123456789 /n /m "Enter your choice (1, 2, 3, 4, 5, 6, 7, 8, 9): "
if %errorlevel%==9 set "GVLKKey=%Server_Itanium_2008%"& goto KMS
if %errorlevel%==8 set "GVLKKey=%Server_Datacenter_WHV_2008%"& goto KMS
if %errorlevel%==7 set "GVLKKey=%Server_Datacenter_2008%"& goto KMS
if %errorlevel%==6 set "GVLKKey=%Server_HPC_2008%"& goto KMS
if %errorlevel%==5 set "GVLKKey=%Server_Enterprise_WHV_2008%"& goto KMS
if %errorlevel%==4 set "GVLKKey=%Server_Enterprise_2008%"& goto KMS
if %errorlevel%==3 set "GVLKKey=%Server_Standard_WHV_2008%"& goto KMS
if %errorlevel%==2 set "GVLKKey=%Server_Standard_2008%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Server_2008%"& goto KMS

:WinServer2008R2
echo.
echo [1] Windows Server 2008 R2 Web& echo [2] Windows Server 2008 R2 HPC Edition& echo [3] Windows Server 2008 R2 Standard& echo [4] Windows Server 2008 R2 Enterprise& echo [5] Windows Server 2008 R2 Datacenter& echo [6] Windows Server 2008 R2 for Itanium-based Systems
echo.

choice /c 123456 /n /m "Enter your choice (1, 2, 3, 4, 5, 6): "
if %errorlevel%==6 set "GVLKKey=%Server_Itanium_R2_2008%"& goto KMS
if %errorlevel%==5 set "GVLKKey=%Server_Datacenter_R2_2008%"& goto KMS
if %errorlevel%==4 set "GVLKKey=%Server_Enterprise_R2_2008%"& goto KMS
if %errorlevel%==3 set "GVLKKey=%Server_Standard_R2_2008%"& goto KMS
if %errorlevel%==2 set "GVLKKey=%Server_HPC_R2_2008%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Server_Web_R2_2008%"& goto KMS

:WinServer2012
echo.
echo [1] Windows Server 2012& echo [2] Windows Server 2012 N& echo [3] Windows Server 2012 Single Language& echo [4] Windows Server 2012 Country Specific& echo [5] Windows Server 2012 Standard& echo [6] Windows Server 2012 MultiPoint Standard& echo [7] Windows Server 2012 MultiPoint Premium& echo [8] Windows Server 2012 Datacenter& echo [9] Windows Server 2012 Essentials
echo.

choice /c 123456789 /n /m "Enter your choice (1, 2, 3, 4, 5, 6, 7, 8, 9): "
if %errorlevel%==9 set "GVLKKey=%Server_Essentials_2012%"& goto KMS
if %errorlevel%==8 set "GVLKKey=%Server_Datacenter_2012%"& goto KMS
if %errorlevel%==7 set "GVLKKey=%Server_MP_Premium_2012%"& goto KMS
if %errorlevel%==6 set "GVLKKey=%Server_MP_Standard_2012%"& goto KMS
if %errorlevel%==5 set "GVLKKey=%Server_Standard_2012%"& goto KMS
if %errorlevel%==4 set "GVLKKey=%Server_CS_2012%"& goto KMS
if %errorlevel%==3 set "GVLKKey=%Server_SL_2012%"& goto KMS
if %errorlevel%==2 set "GVLKKey=%Server_N_2012%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Server_2012%"& goto KMS

:WinServer2012R2
echo.
echo [1] Windows Server 2012 R2 Standard& echo [2] Windows Server 2012 R2 Datacenter& echo [3] Windows Server 2012 R2 Essentials
echo.

choice /c 123 /n /m "Enter your choice (1, 2, 3): "
if %errorlevel%==3 set "GVLKKey=%Server_Essentials_R2_2012%"& goto KMS
if %errorlevel%==2 set "GVLKKey=%Server_Datacenter_R2_2012%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Server_Standard_R2_2012%"& goto KMS

:WinServer1709
echo.
echo [1] Windows Server Standard& echo [2] Windows Server Datacenter
echo.

choice /c 12 /n /m "Enter your choice (1, 2): "
if %errorlevel%==2 set "GVLKKey=%Server_Datacenter_1709%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Server_Standard_1709%"& goto KMS

:WinServer1803
echo.
echo [1] Windows Server Standard& echo [2] Windows Server Datacenter
echo.

choice /c 12 /n /m "Enter your choice (1, 2): "
if %errorlevel%==2 set "GVLKKey=%Server_Datacenter_1803%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Server_Standard_1803%"& goto KMS

:WinServer2016
echo.
echo [1] Windows Server 2016 Standard& echo [2] Windows Server 2016 Datacenter& echo [3] Windows Server 2016 Essentials
echo.

choice /c 123 /n /m "Enter your choice (1, 2, 3): "
if %errorlevel%==3 set "GVLKKey=%Server_Essentials_2016%"& goto KMS
if %errorlevel%==2 set "GVLKKey=%Server_Datacenter_2016%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Server_Standard_2016%"& goto KMS

:WinServer2019
echo.
echo [1] Windows Server 2019 Standard& echo [2] Windows Server 2019 Datacenter& echo [3] Windows Server 2019 Essentials
echo.

choice /c 123 /n /m "Enter your choice (1, 2, 3): "
if %errorlevel%==3 set "GVLKKey=%Server_Essentials_2019%"& goto KMS
if %errorlevel%==2 set "GVLKKey=%Server_Datacenter_2019%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Server_Standard_2019%"& goto KMS

:WinServer2022
echo.
echo [1] Windows Server 2022 Standard& echo [2] Windows Server 2022 Datacenter& echo [3] Windows Server 2022 Datacenter: Azure Edition
echo.

choice /c 123 /n /m "Enter your choice (1, 2, 3): "
if %errorlevel%==3 set "GVLKKey=%Server_Essentials_2022%"& goto KMS
if %errorlevel%==2 set "GVLKKey=%Server_Datacenter_2022%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Server_Standard_2022%"& goto KMS

:WinServer2025
echo.
echo [1] Windows Server 2025 Standard& echo [2] Windows Server 2025 Datacenter& echo [3] Windows Server 2025 Datacenter: Azure Edition
echo.

choice /c 123 /n /m "Enter your choice (1, 2, 3): "
if %errorlevel%==3 set "GVLKKey=%Server_Essentials_2025%"& goto KMS
if %errorlevel%==2 set "GVLKKey=%Server_Datacenter_2025%"& goto KMS
if %errorlevel%==1 set "GVLKKey=%Server_Standard_2025%"& goto KMS



REM KMS.
:KMS
echo.

echo Uninstalling the current Product Key...
slmgr /upk
echo Clearing the KMS Server Adress...
slmgr /ckms
echo Clearing the Activation Cache...
slmgr /cpky
echo.
echo Installing the GVLK Key...
slmgr /ipk %GVLKKey%
echo Setting the KMS Server Adress...
slmgr /skms %KMS_Server%
echo Triggering Activation...
slmgr /ato

echo.& echo Done!
pause& echo.& exit
