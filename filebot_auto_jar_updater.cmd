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
	FileBot Automatic jar file Updater v1.5.0

	Written by CapriciousSage (Ithiel)
	Fixed up by JourneyOver
	With assistance from rednoah and Akkifokkusu
	Requires 7zip to be installed
	This file requires Administrative Privileges
	Note: The only file that this tool updates is FileBot.jar

	FileBot written by rednoah (Reinhard Pointner)
	FileBot: http://www.filebot.net

	Help Support FileBot!
	Please Donate via PayPal to reinhard.pointner@gmail.com

	No warranty given or implied, use at your own risk.
	Last Updated: 12/07/2016
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

  set downloadURL="http://downloads.sourceforge.net/project/filebot/filebot/HEAD/FileBot.jar.xz"

  echo --------------------------- >> %logfile%
	echo FileBot Automatic Jar File Updater >> %logfile%
	echo Date: %date% >> %logfile%
	echo --------------------------- >> %logfile%
	echo. >> %logfile%

  echo Downloading Latest Filebot.jar from %downloadURL% >> %logfile%
	bitsadmin.exe /transfer "Download_FileBot" /priority foreground %downloadURL% "%tmp%\FileBot.jar.xz"

  if not errorlevel 0 GOTO ERR1

	echo Download successful. >> %logfile%

  	IF EXIST "C:\Program Files\7-Zip\7z.exe" (
		echo setting "C:\Program Files\7-Zip\" >> %logfile%
		set path="C:\Program Files\7-Zip\"
	) ELSE (
		echo setting "C:\Program Files (x86)\7-Zip" >> %logfile%
		set path="C:\Program Files (x86)\7-Zip"
	)

	IF EXIST "%FBpath%\FileBot_old.jar" (
		echo Deleting "%FBpath%\FileBot_old.jar" >> %logfile%
		del "%FBpath%\FileBot_old.jar"
	) ELSE (
		echo No FileBot_old.jar file to Delete >> %logfile%
	)

	echo Renaming current FileBot.jar to FileBot_old.jar >> %logfile%
	ren "%FBpath%\FileBot.jar" FileBot_old.jar

  echo Extracting filebot.jar.xz >> %logfile%
	cd "%tmp%
	7z e "%tmp%\FileBot.jar.xz"

	echo Installing new Filebot.jar >> %logfile%
  move "%tmp%\FileBot.jar" "%FBpath%\FileBot.jar"

	echo FileBot Update Complete >> %logfile%

  echo Deleting filebot.jar.xz >> %logfile%
	cd "%tmp%
	del "%tmp%\FileBot.jar.xz"

GOTO ALLOK

:ERR1
	echo **** Warning: Something Didn't Work. Please Confirm Settings **** >> %logfile%
	echo. >> %logfile%
	echo Press any key to terminate install ...
	pause>nul
GOTO FINISH

:ALLOK
	echo ****** Job completed successfully ***** >> %logfile%
	echo. >> %logfile%
GOTO FINISH

:FINISH
EXIT /B