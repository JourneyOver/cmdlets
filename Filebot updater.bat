@echo OFF

:://////////////////////////
:: Main Settings start
::////////////////////////

	set logfile="%tmp%\filebot_automatic_updater.txt"
	set FBpath=C:\Users\JourneyOver\Dropbox\Public\Folders\Filebot

:://////////////////////////
:: Main Settings end
::////////////////////////

GOTO EndComment
	FileBot Automatic file Updater v1.6.2

	Written by CapriciousSage (Ithiel)
	Fixed up by JourneyOver
	With assistance from rednoah and Akkifokkusu
	Requires 7zip to be installed
	This file requires Administrative Privileges

	FileBot written by rednoah (Reinhard Pointner)
	FileBot: http://www.filebot.net

	Help Support FileBot!
	Please Donate via PayPal to reinhard.pointner@gmail.com

	No warranty given or implied, use at your own risk.
	Last Updated: 2/04/2017
:EndComment

:ADMIN-CHECK

	:: BatchGotAdmin
	:-------------------------------------
	REM  --> Check for permissions
	>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

	REM --> If error flag set, we do not have admin.
	if '%errorlevel%' NEQ '0' (
	    echo Requesting administrative privileges...
	    GOTO DirCheck1
	) else ( GOTO gotAdmin )

	:DirCheck1

		copy /Y NUL "%~dp0\.writable" > NUL 2>&1 && set WRITEOK=1
		IF DEFINED WRITEOK (
			del "%~dp0\.writable"
			GOTO UACPrompt1
		 ) else (
			echo Checking profile instead...
			GOTO DirCheck2
		)

	:DirCheck2

		copy /Y NUL "%USERPROFILE%\.writable" > NUL 2>&1 && set WRITEOK=1
		IF DEFINED WRITEOK (
			del "%USERPROFILE%\.writable"
			GOTO UACPrompt2
		 ) else (
			echo Checking temp instead...
			GOTO DirCheck3
		)

	:DirCheck3

		copy /Y NUL "%tmp%\.writable" > NUL 2>&1 && set WRITEOK=1
		IF DEFINED WRITEOK (
			del "%tmp%\.writable"
			GOTO UACPrompt3
		 ) else (
			GOTO UACFailed
		)

	:UACPrompt1

		echo Set UAC = CreateObject^("Shell.Application"^) > "%~dp0\getadmin.vbs"
		set params = %*:"=""
		echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%~dp0\getadmin.vbs"

		"%~dp0\getadmin.vbs"

		if '%errorlevel%' NEQ '0' (
			del "%~dp0\getadmin.vbs"
			GOTO DirCheck2
		) else ( GOTO UACPrompt1Complete )

		:UACPrompt1Complete
			del "%~dp0\getadmin.vbs"
			exit /b
			GOTO gotAdmin

	:UACPrompt2

		echo Set UAC = CreateObject^("Shell.Application"^) > "%USERPROFILE%\getadmin.vbs"
		set params = %*:"=""
		echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%USERPROFILE%\getadmin.vbs"

		"%USERPROFILE%\getadmin.vbs"

		if '%errorlevel%' NEQ '0' (
			del "%USERPROFILE%\getadmin.vbs"
			GOTO DirCheck3
		) else ( GOTO UACPrompt2Complete )

		:UACPrompt2Complete
			del "%USERPROFILE%\getadmin.vbs"
			exit /b
			GOTO gotAdmin

	:UACPrompt3

		echo Set UAC = CreateObject^("Shell.Application"^) > "%tmp%\getadmin.vbs"
		set params = %*:"=""
		echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%tmp%\getadmin.vbs"

		"%tmp%\getadmin.vbs"

		if '%errorlevel%' NEQ '0' (
			del "%tmp%\getadmin.vbs"
			GOTO UACFailed
		) else ( GOTO UACPrompt3Complete )

		:UACPrompt3Complete
			del "%tmp%\getadmin.vbs"
			exit /b
			GOTO gotAdmin

	:UACFailed
		echo Upgrading to admin privliages failed.
		echo Please right click the file and run as administrator.
		echo PAUSE
		GOTO FINISH

	:gotAdmin
		pushd "%CD%"
		CD /D "%~dp0"
	:--------------------------------------

GOTO DOWNLOAD

:DOWNLOAD

	echo --------------------------- >> %logfile%
	echo FileBot Automatic File Updater >> %logfile%
	echo Date: %date% %time% >> %logfile%
	echo --------------------------- >> %logfile%
	echo. >> %logfile%

	echo Downloading Latest Filebot files >> %logfile%
	start /wait PowerShell -windowstyle hidden -NoProfile -ExecutionPolicy Bypass -Command "& 'C:\Users\JourneyOver\Desktop\Github\cmdlets\filebot_downloads.ps1'"

	echo Download successful. >> %logfile%

GOTO OLDBACKUPS

:OLDBACKUPS

	echo Deleting backups that are older than 2 weeks >> %logfile%
	FORFILES /P "%FBpath%\Backups" /M *.* /D -14 /C "cmd /c del @file"

GOTO EXTRACTION_RENAMING

:EXTRACTION_RENAMING

	IF EXIST "C:\Program Files\7-Zip\7z.exe" (
	echo setting "C:\Program Files\7-Zip\" >> %logfile%
	set path="C:\Program Files\7-Zip\"
	) ELSE (
	echo setting "C:\Program Files (x86)\7-Zip" >> %logfile%
	set path="C:\Program Files (x86)\7-Zip"
	)

	echo Renaming current "FileBot.jar" to "FileBot_old.jar" >> %logfile%
	ren "%FBpath%\FileBot.jar" "FileBot_old.jar"
	echo Renaming current "FileBot.cmd" to "FileBot_old.cmd" >> %logfile%
	ren "%FBpath%\FileBot.cmd" "FileBot_old.cmd"
	echo Renaming current "FileBot.Portable.Launcher.exe" to "FileBot.Portable.Launcher_old.exe" >> %logfile%
	ren "%FBpath%\FileBot.Portable.Launcher.exe" "FileBot.Portable.Launcher_old.exe"
	echo Renaming current "FileBot.Portable.Launcher.l4j.ini" to "FileBot.Portable.Launcher.l4j_old.ini" >> %logfile%
	ren "%FBpath%\FileBot.Portable.Launcher.l4j.ini" "FileBot.Portable.Launcher.l4j_old.ini"
	echo Renaming current "FileBot.sh" to "FileBot_old.sh" >> %logfile%
	ren "%FBpath%\FileBot.sh" "FileBot_old.sh"
	echo Renaming current "FileBot-Portable-Launch4j.xml" to "FileBot-Portable-Launch4j_old.xml" >> %logfile%
	ren "%FBpath%\FileBot-Portable-Launch4j.xml" "FileBot-Portable-Launch4j_old.xml"
	echo Renaming current "update-filebot.sh" to "update-filebot_old.sh" >> %logfile%
	ren "%FBpath%\update-filebot.sh" "update-filebot_old.sh"
	echo Renaming current "7-Zip-JBinding.dll" to "7-Zip-JBinding_old.dll" >> %logfile%
	ren "%FBpath%\7-Zip-JBinding.dll" "7-Zip-JBinding_old.dll"
	echo Renaming current "fpcalc.exe" to "fpcalc_old.exe" >> %logfile%
	ren "%FBpath%\fpcalc.exe" "fpcalc_old.exe"
	echo Renaming current "gcc_s_seh-1.dll" to "gcc_s_seh-1_old.dll" >> %logfile%
	ren "%FBpath%\gcc_s_seh-1.dll" "gcc_s_seh-1_old.dll"
	echo Renaming current "jnidispatch.dll" to "jnidispatch_old.dll" >> %logfile%
	ren "%FBpath%\jnidispatch.dll" "jnidispatch_old.dll"
	echo Renaming current "MediaInfo.dll" to "MediaInfo_old.dll" >> %logfile%
	ren "%FBpath%\MediaInfo.dll" "MediaInfo_old.dll"


	echo Extracting filebot.jar.xz >> %logfile%
	cd "%tmp%
	7z x "%tmp%\FileBot.jar.xz" -y

	echo Extracting filebot-master.zip >> %logfile%
	7z x "%tmp%\filebot-master.zip" -y

	echo Renaming_Extracting successful. >> %logfile%

GOTO MOVEMENT&CLEANUP

:MOVEMENT&CLEANUP

	echo moving _old files to backup folder >> %logfile%
	move "%FBpath%\*_old.*" "%FBpath%\Backups\"

	echo Installing new Filebot.jar >> %logfile%
	move "%tmp%\FileBot.jar" "%FBpath%\FileBot.jar"
	echo Installing other Filebot Files >> %logfile%
	cd "%tmp%\filebot-master\installer\portable"
	move "%tmp%\filebot-master\installer\portable\*.*" "%FBpath%\"
	cd "%tmp%\filebot-master\lib\native\win32-x64"
	move "%tmp%\filebot-master\lib\native\win32-x64\*.*" "%FBpath%\"

	echo Deleting filebot.jar.xz >> %logfile%
	cd "%tmp%
	del "%tmp%\FileBot.jar.xz"
	echo Deleting filebot-master >> %logfile%
	RD /S /Q "%tmp%\filebot-master"
	del "%tmp%\filebot-master.zip"

	set hh=%time:~0,2%
	if "%time:~0,1%"==" " set hh=0%hh:~1,1%

	set dt=%date:~4,2%-%date:~7,2%-%date:~10,4%_%hh:~0,2%_%time:~3,2%_%time:~6,2%

	echo Backing up _old files >> %logfile%
	cd "%FBpath%\Backups"
	7z a "backup-%dt%.zip" *_old.* -sdel

	echo FileBot Update Complete >> %logfile%

GOTO ALLOK

:ERR1
	echo **** Warning: Something Didn't Work. Please Confirm Settings **** >> %logfile%
	echo. >> %logfile%
GOTO FINISH

:ALLOK
	echo ****** Job completed successfully at %date%-%time% ***** >> %logfile%
	echo. >> %logfile%
GOTO FINISH

:FINISH
EXIT /B