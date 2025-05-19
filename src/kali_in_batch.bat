@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

rem Color Definitions
set "COLOR_RESET=[0m"
set "COLOR_BLACK=[30m"
set "COLOR_RED=[31m"
set "COLOR_GREEN=[32m"
set "COLOR_YELLOW=[33m"
set "COLOR_BLUE=[34m"
set "COLOR_MAGENTA=[35m"
set "COLOR_CYAN=[36m"
set "COLOR_WHITE=[37m"
set "COLOR_BRIGHT_BLACK=[90m"
set "COLOR_BRIGHT_RED=[91m"
set "COLOR_BRIGHT_GREEN=[92m"
set "COLOR_BRIGHT_YELLOW=[93m"
set "COLOR_BRIGHT_BLUE=[94m"
set "COLOR_BRIGHT_MAGENTA=[95m"
set "COLOR_BRIGHT_CYAN=[96m"
set "COLOR_BRIGHT_WHITE=[97m"

rem Background Colors
set "COLOR_BG_BLACK=[40m"
set "COLOR_BG_RED=[41m"
set "COLOR_BG_GREEN=[42m"
set "COLOR_BG_YELLOW=[43m"
set "COLOR_BG_BLUE=[44m"
set "COLOR_BG_MAGENTA=[45m"
set "COLOR_BG_CYAN=[46m"
set "COLOR_BG_WHITE=[47m"
set "COLOR_BG_BRIGHT_BLACK=[100m"
set "COLOR_BG_BRIGHT_RED=[101m"
set "COLOR_BG_BRIGHT_GREEN=[102m"
set "COLOR_BG_BRIGHT_YELLOW=[103m"
set "COLOR_BG_BRIGHT_BLUE=[104m"
set "COLOR_BG_BRIGHT_MAGENTA=[105m"
set "COLOR_BG_BRIGHT_CYAN=[106m"
set "COLOR_BG_BRIGHT_WHITE=[107m"

rem Text Styles
set "COLOR_BOLD=[1m"
set "COLOR_DIM=[2m"
set "COLOR_ITALIC=[3m"
set "COLOR_UNDERLINE=[4m"
set "COLOR_BLINK=[5m"
set "COLOR_REVERSE=[7m"
set "COLOR_HIDDEN=[8m"
set "COLOR_STRIKETHROUGH=[9m"

rem Combined Styles
set "COLOR_ERROR=!COLOR_BRIGHT_RED!!COLOR_BOLD!"
set "COLOR_WARNING=!COLOR_BRIGHT_YELLOW!!COLOR_BOLD!"
set "COLOR_SUCCESS=!COLOR_BRIGHT_GREEN!!COLOR_BOLD!"
set "COLOR_INFO=!COLOR_BRIGHT_CYAN!"
set "COLOR_DEBUG=!COLOR_BRIGHT_MAGENTA!"
set "COLOR_PROMPT=!COLOR_BRIGHT_BLUE!!COLOR_BOLD!"

cls
set "username=%USERNAME%"
title Kali Linux in Batch
if not exist "%APPDATA%\kali_in_batch" (
    
    echo                           ---------------------------------------------------
    echo                          {                                                   }
    echo                          {            KALI IN BATCH INSTALLER                }
    echo                          {                                                   }
    echo                          {                                                   }
    echo                          {---------------------------------------------------}
    echo                          {                   1. Install                      }
    echo                          {                   2. Exit                         }
    echo                          {                                                   }
    echo                           ---------------------------------------------------
    echo.
    choice /c 12 /n /m ""
    if errorlevel 2 exit
    if errorlevel 1 (
        cls
        set /p "install_part=Choose a partitition or USB drive to install Kali in Batch on. Drive must be empty. Type the drive letter (e.g. E:) > "

        echo Testing if it exists...
        timeout /t 1 /nobreak >nul
        if not exist "!install_part!\" (
            echo !COLOR_ERROR!Error: Drive does not exist. Please try again.!COLOR_RESET!
            pause >nul
            exit
        )
        echo Testing if it is empty...
        timeout /t 1 /nobreak >nul
        rem Check if it is empty
        dir "!install_part!\" >nul 2>nul
        if !errorlevel! neq 1 (
            echo !COLOR_ERROR!Error: Drive is not empty. Please try again.!COLOR_RESET!
            pause >nul
            exit
        )
        timeout /t 1 /nobreak >nul
        echo Creating directories...
        mkdir "!install_part!\home" >nul 2>nul
        mkdir "!install_part!\home\!username!" >nul 2>nul
        mkdir "!install_part!\bin" >nul 2>nul
        mkdir "!install_part!\tmp" >nul 2>nul
        timeout /t 1 /nobreak >nul
        echo Creating files...
        timeout /t 1 /nobreak >nul
        echo Checking dependencies...
        timeout /t 1 /nobreak >nul
    )
    where nmap >nul 2>nul
    if !errorlevel! neq 0 (
        echo Press any key to go to https://nmap.org/download.html#windows and download Nmap for Windows...
        pause >nul
        start https://nmap.org/download.html#windows
    )
    where vim >nul 2>nul
    if !errorlevel! neq 0 (
        echo Press any key to go to https://www.vim.org/download.php and download Vim...
        pause >nul
        start https://www.vim.org/download.php
    )
    where powershell >nul 2>nul
    if !errorlevel! neq 0 (
        echo !COLOR_ERROR!CRITICAL ERROR: Powershell is not found. Please repair Windows installation. Your Windows installation may not be genuine.!COLOR_RESET!
        echo You can install a genuine Windows 11 from https://www.microsoft.com/en-us/software-download/windows11 or Windows 10 from https://www.microsoft.com/en-us/software-download/windows10.
        pause >nul
        exit
    )
    where ping >nul 2>nul
    if !errorlevel! neq 0 (
        echo !COLOR_ERROR!CRITICAL ERROR: Ping is not found. Please repair Windows installation. Your Windows installation may not be genuine.!COLOR_RESET!
        echo You can install a genuine Windows 11 from https://www.microsoft.com/en-us/software-download/windows11 or Windows 10 from https://www.microsoft.com/en-us/software-download/windows10.
        pause >nul
        exit
    )
    for /f "tokens=2,*" %%a in ('reg query "HKCU\Software\GitForWindows" /v InstallPath 2^>nul') do set GIT_PATH=%%b
    if not defined GIT_PATH (
        for /f "tokens=2,*" %%a in ('reg query "HKLM\Software\GitForWindows" /v InstallPath 2^>nul') do set GIT_PATH=%%b
    )
    if not defined GIT_PATH (
        echo Press any key to go to https://git-scm.com/downloads/win and download Git for Windows, also ensure you get Git Bash too...
        pause >nul
        start https://git-scm.com/downloads/win
    )
    mkdir "%APPDATA%\kali_in_batch" >nul 2>nul
    @echo on
    echo !install_part!>"%APPDATA%\kali_in_batch\install_part.txt"
    @echo off
	choice /c 12 /m "Done. Press 1 to continue booting, or press 2 to delete your kali rootfs and exit."
	if errorlevel 2 goto wipe
)
rem Set install part to the txt file created in installer
set /p install_part=<"%APPDATA%\kali_in_batch\install_part.txt"
echo DEBUG: install_part=!install_part!
pause
cls
goto boot

:wipe
echo Wiping kali rootfs...
echo.
rmdir /s /q "!install_part!\home\!username!"
rmdir /s /q "!install_part!\bin"
rmdir /s /q "!install_part!\tmp"
rmdir /s /q "!install_part!\home"
rmdir /s /q "%APPDATA%\kali_in_batch"
echo Done, press any key to exit...
pause >nul
cls
exit


:boot
rem Check if VERSION.txt exists and delete it if it does
if exist "%APPDATA%\kali_in_batch\VERSION.txt" (
    del "%APPDATA%\kali_in_batch\VERSION.txt"
)
rem Create VERSION.txt
echo 1.2.0>"%APPDATA%\kali_in_batch\VERSION.txt"
echo Starting services...
timeout /t 1 /nobreak >nul
where nmap >nul 2>nul
if !errorlevel! neq 0 (
    echo !COLOR_ERROR!Error: Failed to start Nmap service: Nmap not found.!COLOR_RESET!
    echo Please install Nmap from https://nmap.org/download.html
    pause
    exit
)
where vim >nul 2>nul
if !errorlevel! neq 0 (
    echo !COLOR_WARNING!Warning: Failed to start Vim service: Vim not found. While this is not critical, it is recommended to install it for better text editing experience.!COLOR_RESET!
    echo You can install it from https://www.vim.org/download.php
)

rem Registry interactions in a batch file may make your Antivirus flag it.
for /f "tokens=2,*" %%a in ('reg query "HKCU\Software\GitForWindows" /v InstallPath 2^>nul') do set GIT_PATH=%%b

if not defined GIT_PATH (
    for /f "tokens=2,*" %%a in ('reg query "HKLM\Software\GitForWindows" /v InstallPath 2^>nul') do set GIT_PATH=%%b
)

if defined GIT_PATH (
    set bash_path=!GIT_PATH!\bin\bash.exe
) else (
    echo !COLOR_ERROR!Error: Failed to start Git Bash service: Git for Windows not found.!COLOR_RESET!
    echo Please install Git for Windows from https://git-scm.com/downloads/win
)
where powershell >nul 2>nul
if !errorlevel! neq 0 (
    echo !COLOR_ERROR!CRITICAL ERROR: Powershell is not found. Please repair Windows installation. Your Windows installation may not be genuine.!COLOR_RESET!
    echo You can install a genuine Windows 11 from https://www.microsoft.com/en-us/software-download/windows11 or Windows 10 from https://www.microsoft.com/en-us/software-download/windows10.
    pause 
    exit
)
echo Checking for updates...
curl -s https://codeberg.org/Kali-in-Batch/kali-in-batch/raw/branch/master/VERSION.txt >"!install_part!\tmp\VERSION.txt"
rem Check if the version is the same
set /p remote_version=<"!install_part!\tmp\VERSION.txt"
set /p local_version=<"%APPDATA%\kali_in_batch\VERSION.txt"
if !remote_version! neq !local_version! (
    echo !COLOR_WARNING!New version available!!COLOR_RESET!
    echo !COLOR_WARNING!Remote version: !remote_version!!COLOR_RESET!
    echo !COLOR_WARNING!Local version: !local_version!!COLOR_RESET!
    echo Please run git pull in your cloned repository to update.
) else (
    echo !COLOR_SUCCESS!You are running the latest version.!COLOR_RESET!
    echo !COLOR_SUCCESS!Remote version: !remote_version!!COLOR_RESET!
    echo !COLOR_SUCCESS!Local version: !local_version!!COLOR_RESET!
)
rem DEV BRANCH FIX: Delete VERSION.txt in tmp folder
del "!install_part!\tmp\VERSION.txt"
echo Done.
timeout /t 1 /nobreak >nul
echo.
cls
echo.
goto startup

:startup
rem Navigate to home directory
cd /d "!install_part!\home\!username!"
if %errorlevel% neq 0 (
    echo error
    pause >nul
    exit
)
set "kalirc=!cd!\.kalirc"
set "home_dir=!cd!"
if exist !kalirc! (
    set bash_current_dir=!cd! >nul 2>&1
    set bash_current_dir=!cd:\=/! >nul 2>&1
    set bash_current_dir=!bash_current_dir:C:=/c! >nul 2>&1
    set bash_current_dir=!bash_current_dir:D:=/d! >nul 2>&1
    set bash_current_dir=!bash_current_dir:E:=/e! >nul 2>&1
    set bash_current_dir=!bash_current_dir:F:=/f! >nul 2>&1
    set bash_current_dir=!bash_current_dir:G:=/g! >nul 2>&1
    set bash_current_dir=!bash_current_dir:H:=/h! >nul 2>&1
    set bash_current_dir=!bash_current_dir:I:=/i! >nul 2>&1
    set bash_current_dir=!bash_current_dir:J:=/j! >nul 2>&1
    set bash_current_dir=!bash_current_dir:K:=/k! >nul 2>&1
    set bash_current_dir=!bash_current_dir:L:=/l! >nul 2>&1
    set bash_current_dir=!bash_current_dir:M:=/m! >nul 2>&1
    set bash_current_dir=!bash_current_dir:N:=/n! >nul 2>&1
    set bash_current_dir=!bash_current_dir:O:=/o! >nul 2>&1
    set bash_current_dir=!bash_current_dir:P:=/p! >nul 2>&1
    set bash_current_dir=!bash_current_dir:Q:=/q! >nul 2>&1
    set bash_current_dir=!bash_current_dir:R:=/r! >nul 2>&1
    set bash_current_dir=!bash_current_dir:S:=/s! >nul 2>&1
    set bash_current_dir=!bash_current_dir:T:=/t! >nul 2>&1
    set bash_current_dir=!bash_current_dir:U:=/u! >nul 2>&1
    set bash_current_dir=!bash_current_dir:V:=/v! >nul 2>&1
    set bash_current_dir=!bash_current_dir:W:=/w! >nul 2>&1
    set bash_current_dir=!bash_current_dir:X:=/x! >nul 2>&1
    set bash_current_dir=!bash_current_dir:Y:=/y! >nul 2>&1
    set bash_current_dir=!bash_current_dir:Z:=/z! >nul 2>&1
    !bash_path! -c "cd !bash_current_dir!; source .kalirc" 2>&1
    echo.
    if not exist "!home_dir!\.no_help_startup" (
        echo Hello !username!, type 'help' for a list of commands.
        echo If you want to disable this message, create a file called .no_help_startup in your home directory.
        echo.
    )
    goto shell
) else (
    echo No .kalirc file found. Try creating one, it is a bash script that runs on startup.
    echo.
    echo Hello !username!, type 'help' for a list of commands.
    goto shell
)

:shell
set current_dir=!cd!
if !current_dir!==!home_dir! (
    set current_dir=~
) else (
    set current_dir=!cd!
)
rem Replace backslashes with forward slashes in !current_dir!
set current_dir=!current_dir:\=/!
rem Replace drive letters with nothing in !current_dir!
set current_dir=!current_dir:C:=!
set current_dir=!current_dir:D:=!
set current_dir=!current_dir:E:=!
set current_dir=!current_dir:F:=!
set current_dir=!current_dir:G:=!
set current_dir=!current_dir:H:=!
set current_dir=!current_dir:I:=!
set current_dir=!current_dir:J:=!
set current_dir=!current_dir:K:=!
set current_dir=!current_dir:L:=!
set current_dir=!current_dir:M:=!
set current_dir=!current_dir:N:=!
set current_dir=!current_dir:O:=!
set current_dir=!current_dir:P:=!
set current_dir=!current_dir:Q:=!
set current_dir=!current_dir:R:=!
set current_dir=!current_dir:S:=!
set current_dir=!current_dir:T:=!
set current_dir=!current_dir:U:=!
set current_dir=!current_dir:V:=!
set current_dir=!current_dir:W:=!
set current_dir=!current_dir:X:=!
set current_dir=!current_dir:Y:=!
set current_dir=!current_dir:Z:=!

echo !COLOR_GREEN!╔══(!COLOR_BLUE!!username!@!COMPUTERNAME!!COLOR_RESET!!COLOR_GREEN!)-[!current_dir!] !COLOR_RESET!
set /p command=!COLOR_GREEN!╚══!COLOR_BLUE!$ !COLOR_RESET!!COLOR_RESET!

rem Useful for later
for /f "tokens=1* delims= " %%a in ("!command!") do (
    set "command=%%a"
    set "remaining=%%b"
)
set "args="
set "args2="
set "args3="
set "args4="
set "args5="
set "args6="
set "args7="
set "args8="
set "args9="
set "args10="
set "args11="
set "args12="
set "args13="
set "args14="
set "args15="
set "args16="
set "args17="
set "args18="
set "args19="
set "args20="
set "args21="
set "args22="
set "args23="
set "args24="
set "args25="
set "args26="
for /f "tokens=1-26 delims= " %%a in ("!remaining!") do (
    set "args=%%a"
    set "args2=%%b"
    set "args3=%%c"
    set "args4=%%d"
    set "args5=%%e"
    set "args6=%%f"
    set "args7=%%g"
    set "args8=%%h"
    set "args9=%%i"
    set "args10=%%j"
    set "args11=%%k"
    set "args12=%%l"
    set "args13=%%m"
    set "args14=%%n"
    set "args15=%%o"
    set "args16=%%p"
    set "args17=%%q"
    set "args18=%%r"
    set "args19=%%s"
    set "args20=%%t"
    set "args21=%%u"
    set "args22=%%v"
    set "args23=%%w"
    set "args24=%%x"
    set "args25=%%y"
    set "args26=%%z"
)

if "!command!"=="" (
    echo.
    goto shell
) else if "!command!"=="cd" (
    if "!args!"=="" (
        cd /d "!home_dir!"
    ) else if exist "!args!" (
        rem Only allow Linux paths for cd for better emulation.
        if "!args:~1,1!"==":" (
            echo Possible Linux file system escape attempt blocked.
            goto shell
        )
        set "args=!args:\=/!"
        if "!args:~0,1!"=="/" (
            set "args=!install_part!\!args:~1!"
        )
        set "args=!args:/=\!"
        cd /d "!args!"
    ) else if "!args!"=="~" (
        cd /d "!home_dir!"
    ) else (
        echo Invalid directory.
    )
    goto shell
) else if "!command!"=="cat" (
    if "!args!"=="" (
        echo No file specified.
    ) else if exist "!args!" (
        rem Only allow Linux paths for better emulation.
        if "!args:~1,1!"==":" (
            echo Possible Linux file system escape attempt blocked.
            goto shell
        )
        set "args=!args:\=/!"
        if "!args:~0,1!"=="/" (
            set "args=!install_part!\!args:~1!"
        )
        set "args=!args:/=\!"
        type "!args!"
        echo.
    ) else (
        echo Invalid file.
    )
    goto shell
) else if "!command!"=="pwd" (
    echo !current_dir!
) else if "!command!"=="uname" (
    rem Get version info from %APPDATA%%\kali_in_batch\VERSION.txt
    for /f "tokens=1* delims= " %%a in ('type "%APPDATA%\kali_in_batch\VERSION.txt"') do (
        set "kib_ver=%%a"
    )
    if "!args!"=="-a" (
        echo OS: Kali in Batch v%kib_ver%
        echo Kernel: !os!
        echo Architecture: !PROCESSOR_ARCHITECTURE!
    ) else if "!args!"=="--help" (
        echo Usage: uname [OPTION]
        echo Options:
        echo -a, --all    print all information
        echo --help      display this help message
        echo -p, --processor  display processor type
        echo -o, --operating-system  display operating system name
        echo {no option}    print kernel name
    ) else if "!args!"=="-o" (
        echo Kali in Batch v%kib_ver%
    ) else if "!args!"=="-p" (
        echo !PROCESSOR_ARCHITECTURE!
    ) else (
        echo !os!
    )
) else if "!command!"=="whoami" (
    echo !username!
) else if "!command!"=="pkg" (
    if "!args!"=="" (
        echo Usage: pkg (install/remove/upgrade/search/list^)
    ) else if "!args!"=="install" (
        if "!args2!"=="" (
            echo Usage: pkg install package
        ) else (
            echo Checking if package !args2! is installed...
            if exist "!install_part!\bin\!args2!.sh" (
                echo Package !args2! is already installed.
            ) else (
                echo Checking databases...
                rem Check if https://codeberg.org/Kali-in-Batch/pkg/src/branch/main/packages/!args2! exists
                curl -# https://codeberg.org/Kali-in-Batch/pkg/src/branch/main/packages/!args2! >nul 2>&1
                rem Check if output of https://codeberg.org/Kali-in-Batch/pkg/raw/branch/main/packages/!args2!/!args2!.sh is "Not found."
                curl -# https://codeberg.org/Kali-in-Batch/pkg/raw/branch/main/packages/!args2!/!args2!.sh >"!install_part!\tmp\output.txt"
                set /p output=<"!install_part!\tmp\output.txt"
                if "!output!"=="Not found." (
                    echo Package !args2! is not available.
                    del "!install_part!\tmp\output.txt"
                    goto shell
                )
                echo Package !args2! is available.
                rem Download package
                curl -# https://codeberg.org/Kali-in-Batch/pkg/raw/branch/main/packages/!args2!/!args2!.sh >"!install_part!\bin\!args2!.sh"
                echo Package !args2! installed. Execute it by running: exec !args2!
                del "!install_part!\tmp\output.txt"
            )
        )
    ) else if "!args!"=="remove" (
        if "!args2!"=="" (
            echo Usage: pkg remove package
        ) else (
            echo Checking if package !args2! is installed...
            if exist "!install_part!\bin\!args2!.sh" (
                echo Package !args2! is installed.
                echo Removing package...
                del "!install_part!\bin\!args2!.sh"
                echo Package !args2! removed.
            ) else (
                echo Package !args2! is not installed.
            )
        )
    ) else if "!args!"=="upgrade" (
        if "!args2!"=="" (
            echo Usage: pkg upgrade package
        ) else (
            echo Checking if package !args2! is installed...
            if exist "!install_part!\bin\!args2!.sh" (
                echo Package !args2! is installed.
                echo Checking if package is not up to date...
                rem Put the output of https://codeberg.org/Kali-in-Batch/pkg/raw/branch/main/packages/!args2!/!args2!.sh in /tmp/output.txt
                if exist "!install_part!\tmp\output.txt" (
                    del "!install_part!\tmp\output.txt"
                )
                curl -# https://codeberg.org/Kali-in-Batch/pkg/raw/branch/main/packages/!args2!/!args2!.sh >"!install_part!\tmp\output.txt"
                set /p output=<"!install_part!\tmp\output.txt"
                set /p local_package_code=<"!install_part!\bin\!args2!.sh"
                rem Check if current package code is the same as the latest version
                if "!output!"=="!local_package_code!" (
                    echo Package !args2! is up to date.
                    goto shell
                ) else (
                    echo Upgrading package...
                    curl -# https://codeberg.org/Kali-in-Batch/pkg/raw/branch/main/packages/!args2!/!args2!.sh >"!install_part!\bin\!args2!.sh"
                    echo Package !args2! upgraded.
                    del "!install_part!\tmp\output.txt"
                )
            ) else (
                echo Package !args2! is not installed.
            )
        )
    ) else if "!args!"=="search" (
        echo Press any key to open the package database...
        pause >nul
        start https://codeberg.org/Kali-in-Batch/pkg/src/branch/main/packages/
    ) else if "!args!"=="list" (
        for /f "delims= " %%a in ('dir "!install_part!\bin" /b') do (
            set "filename=%%a"
            set "filename=!filename:.sh=!"
            echo !filename!
        )
    )
    goto shell
) else if "!command!"=="new-session" (
    cls
    goto startup
) else if "!command!"=="wget" (
    powershell -Command "Invoke-WebRequest \"!args!\" -OutFile \"!args2!\""
) else if "!command!"=="bash" (
	if "!args!"=="" (
		echo Usage:
		echo 	-- bash yourscript.sh
	) else if exist "!args!" (
        call :run_bash_fallback 2>&1
	)
) else if "!command!"=="exit" (
    exit
) else if "!command!"=="help" (
    goto help
) else if  "!command!"=="wipe-rootfs" (
    set /p confirmation=Are you sure you want to wipe the rootfs? THIS WILL DELETE ALL YOUR KALI IN BATCH DATA! (y/N^)
    if "!confirmation!"=="y" (
        goto wipe
    ) else (
        echo Operation cancelled.
        goto shell
    )
) else if "!command!"=="exec" (
    if "!args!"=="" (
        echo Usage: exec package
    ) else (
        if exist "!install_part!\bin\!args!.sh" (
            rem Convert !install_part!\bin\!args!.sh to a unix path
            set unix_bin_path=!install_part!\bin\!args!.sh
            set unix_bin_path=!unix_bin_path:\=/!
            set unix_bin_path=!unix_bin_path:C:=/c!
            set unix_bin_path=!unix_bin_path:D:=/d!
            set unix_bin_path=!unix_bin_path:E:=/e!
            set unix_bin_path=!unix_bin_path:F:=/f!
            set unix_bin_path=!unix_bin_path:G:=/g!
            set unix_bin_path=!unix_bin_path:H:=/h!
            set unix_bin_path=!unix_bin_path:I:=/i!
            set unix_bin_path=!unix_bin_path:J:=/j!
            set unix_bin_path=!unix_bin_path:K:=/k!
            set unix_bin_path=!unix_bin_path:L:=/l!
            set unix_bin_path=!unix_bin_path:M:=/m!
            set unix_bin_path=!unix_bin_path:N:=/n!
            set unix_bin_path=!unix_bin_path:O:=/o!
            set unix_bin_path=!unix_bin_path:P:=/p!
            set unix_bin_path=!unix_bin_path:Q:=/q!
            set unix_bin_path=!unix_bin_path:R:=/r!
            set unix_bin_path=!unix_bin_path:S:=/s!
            set unix_bin_path=!unix_bin_path:T:=/t!
            set unix_bin_path=!unix_bin_path:U:=/u!
            set unix_bin_path=!unix_bin_path:V:=/v!
            set unix_bin_path=!unix_bin_path:W:=/w!
            set unix_bin_path=!unix_bin_path:X:=/x!
            set unix_bin_path=!unix_bin_path:Y:=/y!
            set unix_bin_path=!unix_bin_path:Z:=/z!
            rem Run the script
            !bash_path! -c "source !unix_bin_path!"
        ) else (
            echo Package !args! is not installed.
        )
    )
) else if "!command!"=="vim" (
    if "!args!"=="" (
        echo Usage: vim yourfile
    ) else (
        rem Block Windows paths
        if "!args:~1,1!"==":" (
            echo Possible Linux file system escape attempt blocked.
            goto shell
        )
        rem Check if vim is installed
        where vim >nul 2>&1
        if !errorlevel!==0 (
            echo Vim is installed.
            rem Convert Linux path to Windows path
            set linux_path=!args!
            rem Check if the path starts with a slash
            if "!linux_path:~0,1!"=="/" (
                rem Replace it with the drive letter
            )
            set "args=!install_part!\!args:~1!"
            rem Replace back slashes with forward slashes
            set "args=!args:/=\!"
            rem Replace forward slashes with backslashes
            set "args=!args:\=/!"
            rem Run vim
            vim !args!
        ) else (
            echo Vim is not installed. Checking for neovim...
            rem Check if neovim is installed
            where nvim >nul 2>&1
            if !errorlevel!==0 (
                echo Neovim is installed.
                rem Convert Linux path to Windows path
                set linux_path=!args!
                rem Check if the path starts with a slash
                if "!linux_path:~0,1!"=="/" (
                    rem Replace it with the drive letter
                    set "args=!install_part!\!args:~1!"
                )
                rem Replace back slashes with forward slashes
                set "args=!args:/=\!"
                rem Replace forward slashes with backslashes
                set "args=!args:\=/!"
                rem Run neovim
                nvim !args!
            ) else (
                echo Neither vim nor neovim is installed!!
                goto shell
            )
        )
    )
) else (
    cd !cd! >nul 2>&1
    call :run_bash_fallback 2>&1
)
goto shell

:help
echo Available commands:
echo pwd - print working directory
echo    -- pwd usage: pwd
echo ls - list files and directories
echo    -- ls usage: ls
echo cat - display file contents
echo    -- cat usage: cat yourfile
echo echo - print text to the console
echo    -- echo usage: echo your text
echo cd - change directory
echo    -- cd usage: cd yourdirectory
echo clear - clear the screen
echo    -- clear usage: clear
echo exit - exit the shell
echo    -- exit usage: exit
echo nmap - scan a target for open ports
echo    -- nmap usage: nmap -yourflag yourtarget
echo ping - ping a target
echo    -- ping usage: ping yourtarget
echo whoami - display current user
echo    -- whoami usage: whoami
echo pkg - package manager
echo    -- pkg usage: pkg yourcommand yourargs
echo mv - move a file or directory
echo    -- mv usage: mv yourfile yourdestination
echo cp - copy a file or directory
echo    -- cp usage: cp yourfile yourdestination
echo mkdir - create a new directory
echo    -- mkdir usage: mkdir yourdirectory
echo rm - remove a file or directory
echo    -- rm usage: rm yourfile
echo grep - search for a pattern in a file
echo    -- grep usage: grep yourfile yourpattern
echo touch - create a new empty file
echo    -- touch usage: touch yourfile
echo vim - open a file in vim
echo    -- vim usage: vim yourfile
echo uname - display system information
echo    -- uname usage: uname
echo new-session - start a new session
echo    -- new-session usage: new-session
echo wget - download a file from the internet
echo   -- wget usage: wget yoururl yourfile
echo bash - run a bash/sh script
echo    -- bash usage: bash yourscript.sh
echo git - run git commands
echo    -- git usage: git yourargs
echo help - display this help message
echo    -- help usage: help
goto shell

:run_bash_fallback
rem Make a Bash current dir variable, which is the Windows path converted to a Unix path.
set bash_current_dir=!cd! >nul 2>&1
set bash_current_dir=!cd:\=/! >nul 2>&1
set bash_current_dir=!bash_current_dir:C:=/c! >nul 2>&1
set bash_current_dir=!bash_current_dir:D:=/d! >nul 2>&1
set bash_current_dir=!bash_current_dir:E:=/e! >nul 2>&1
set bash_current_dir=!bash_current_dir:F:=/f! >nul 2>&1
set bash_current_dir=!bash_current_dir:G:=/g! >nul 2>&1
set bash_current_dir=!bash_current_dir:H:=/h! >nul 2>&1
set bash_current_dir=!bash_current_dir:I:=/i! >nul 2>&1
set bash_current_dir=!bash_current_dir:J:=/j! >nul 2>&1
set bash_current_dir=!bash_current_dir:K:=/k! >nul 2>&1
set bash_current_dir=!bash_current_dir:L:=/l! >nul 2>&1
set bash_current_dir=!bash_current_dir:M:=/m! >nul 2>&1
set bash_current_dir=!bash_current_dir:N:=/n! >nul 2>&1
set bash_current_dir=!bash_current_dir:O:=/o! >nul 2>&1
set bash_current_dir=!bash_current_dir:P:=/p! >nul 2>&1
set bash_current_dir=!bash_current_dir:Q:=/q! >nul 2>&1
set bash_current_dir=!bash_current_dir:R:=/r! >nul 2>&1
set bash_current_dir=!bash_current_dir:S:=/s! >nul 2>&1
set bash_current_dir=!bash_current_dir:T:=/t! >nul 2>&1
set bash_current_dir=!bash_current_dir:U:=/u! >nul 2>&1
set bash_current_dir=!bash_current_dir:V:=/v! >nul 2>&1
set bash_current_dir=!bash_current_dir:W:=/w! >nul 2>&1
set bash_current_dir=!bash_current_dir:X:=/x! >nul 2>&1
set bash_current_dir=!bash_current_dir:Y:=/y! >nul 2>&1
set bash_current_dir=!bash_current_dir:Z:=/z! >nul 2>&1
rem Check if command is ls or dir
if !command!==ls (
    rem Check if args starts with /
    if "!args:~0,1!"=="/" (
        rem Replace that with drive letter
        set "args=!install_part!\!args:~1!"
        rem Convert drive letter to git bash path
        set "args=!args:C:=/c/!"
        set "args=!args:D:=/d/!"
        set "args=!args:E:=/e/!"
        set "args=!args:F:=/f/!"
        set "args=!args:G:=/g/!"
        set "args=!args:H:=/h/!"
        set "args=!args:I:=/i/!"
        set "args=!args:J:=/j/!"
        set "args=!args:K:=/k/!"
        set "args=!args:L:=/l/!"
        set "args=!args:M:=/m/!"
        set "args=!args:N:=/n/!"
        set "args=!args:O:=/o/!"
        set "args=!args:P:=/p/!"
        set "args=!args:Q:=/q/!"
        set "args=!args:R:=/r/!"
        set "args=!args:S:=/s/!"
        set "args=!args:T:=/t/!"
        set "args=!args:U:=/u/!"
        set "args=!args:V:=/v/!"
        set "args=!args:W:=/w/!"
        set "args=!args:X:=/x/!"
        set "args=!args:Y:=/y/!"
        set "args=!args:Z:=/z/!"
    )
    rem Check if args2 starts with /
    if "!args2:~0,1!"=="/" (
        rem Replace that with drive letter
        set "args2=!install_part!\!args2:~1!"
        rem Convert drive letter to git bash path
        set "args2=!args2:C:=/c/!"
        set "args2=!args2:D:=/d/!"
        set "args2=!args2:E:=/e/!"
        set "args2=!args2:F:=/f/!"
        set "args2=!args2:G:=/g/!"
        set "args2=!args2:H:=/h/!"
        set "args2=!args2:I:=/i/!"
        set "args2=!args2:J:=/j/!"
        set "args2=!args2:K:=/k/!"
        set "args2=!args2:L:=/l/!"
        set "args2=!args2:M:=/m/!"
        set "args2=!args2:N:=/n/!"
        set "args2=!args2:O:=/o/!"
        set "args2=!args2:P:=/p/!"
        set "args2=!args2:Q:=/q/!"
        set "args2=!args2:R:=/r/!"
        set "args2=!args2:S:=/s/!"
        set "args2=!args2:T:=/t/!"
        set "args2=!args2:U:=/u/!"
        set "args2=!args2:V:=/v/!"
        set "args2=!args2:W:=/w/!"
        set "args2=!args2:X:=/x/!"
        set "args2=!args2:Y:=/y/!"
        set "args2=!args2:Z:=/z/!"
    )
    rem Check if args3 starts with /
    if "!args3:~0,1!"=="/" (
        rem Replace that with drive letter
        set "args3=!install_part!\!args3:~1!"
        rem Convert drive letter to git bash path
        set "args3=!args3:C:=/c/!"
        set "args3=!args3:D:=/d/!"   
        set "args3=!args3:E:=/e/!"
        set "args3=!args3:F:=/f/!"
        set "args3=!args3:G:=/g/!"
        set "args3=!args3:H:=/h/!"
        set "args3=!args3:I:=/i/!"
        set "args3=!args3:J:=/j/!"
        set "args3=!args3:K:=/k/!"
        set "args3=!args3:L:=/l/!"
        set "args3=!args3:M:=/m/!"
        set "args3=!args3:N:=/n/!"
        set "args3=!args3:O:=/o/!"
        set "args3=!args3:P:=/p/!"
        set "args3=!args3:Q:=/q/!"
        set "args3=!args3:R:=/r/!"
        set "args3=!args3:S:=/s/!"
        set "args3=!args3:T:=/t/!"
        set "args3=!args3:U:=/u/!"
        set "args3=!args3:V:=/v/!"
        set "args3=!args3:W:=/w/!"
        set "args3=!args3:X:=/x/!"
        set "args3=!args3:Y:=/y/!"
        set "args3=!args3:Z:=/z/!"
    )
    rem Check if args4 starts with /
    if "!args4:~0,1!"=="/" (
        rem Replace that with drive letter
        set "args4=!install_part!\!args4:~1!"
        rem Convert drive letter to git bash path
        set "args4=!args4:C:=/c/!"
        set "args4=!args4:D:=/d/!"
        set "args4=!args4:E:=/e/!"
        set "args4=!args4:F:=/f/!"
        set "args4=!args4:G:=/g/!"
        set "args4=!args4:H:=/h/!"
        set "args4=!args4:I:=/i/!"
        set "args4=!args4:J:=/j/!"
        set "args4=!args4:K:=/k/!"
        set "args4=!args4:L:=/l/!"
        set "args4=!args4:M:=/m/!"
        set "args4=!args4:N:=/n/!"
        set "args4=!args4:O:=/o/!"
        set "args4=!args4:P:=/p/!"
        set "args4=!args4:Q:=/q/!"
        set "args4=!args4:R:=/r/!"
        set "args4=!args4:S:=/s/!"
        set "args4=!args4:T:=/t/!"
        set "args4=!args4:U:=/u/!"
        set "args4=!args4:V:=/v/!"
        set "args4=!args4:W:=/w/!"
        set "args4=!args4:X:=/x/!"
        set "args4=!args4:Y:=/y/!"
        set "args4=!args4:Z:=/z/!"
    )
    rem Check if args5 starts with /
    if "!args5:~0,1!"=="/" (
        rem Replace that with drive letter
        set "args5=!install_part!\!args5:~1!"
        rem Convert drive letter to git bash path
        set "args5=!args5:C:=/c/!"
        set "args5=!args5:D:=/d/!"
        set "args5=!args5:E:=/e/!"
        set "args5=!args5:F:=/f/!"
        set "args5=!args5:G:=/g/!"
        set "args5=!args5:H:=/h/!"
        set "args5=!args5:I:=/i/!"
        set "args5=!args5:J:=/j/!"
        set "args5=!args5:K:=/k/!"
        set "args5=!args5:L:=/l/!"
        set "args5=!args5:M:=/m/!"
        set "args5=!args5:N:=/n/!"
        set "args5=!args5:O:=/o/!"
        set "args5=!args5:P:=/p/!"
        set "args5=!args5:Q:=/q/!"
        set "args5=!args5:R:=/r/!"
        set "args5=!args5:S:=/s/!"
        set "args5=!args5:T:=/t/!"
        set "args5=!args5:U:=/u/!"
        set "args5=!args5:V:=/v/!"
        set "args5=!args5:W:=/w/!"
        set "args5=!args5:X:=/x/!"
        set "args5=!args5:Y:=/y/!"
        set "args5=!args5:Z:=/z/!"
    )

    rem Check if any args contain ~ and if so, display the message Not supported
    for /f "tokens=* delims=*" %%a in ("!args!") do (
        if "%%a"=="~" (
            echo Not supported
            goto shell
        )
    )
    for /f "tokens=* delims=*" %%a in ("!args2!") do (
        if "%%a"=="~" (
            echo Not supported
            goto shell
        )
    )
    for /f "tokens=* delims=*" %%a in ("!args3!") do (
        if "%%a"=="~" (
            echo Not supported
            goto shell
        )
    )
    for /f "tokens=* delims=*" %%a in ("!args4!") do (
        if "%%a"=="~" (
            echo Not supported
            goto shell
        )
    )
    for /f "tokens=* delims=*" %%a in ("!args5!") do (
        if "%%a"=="~" (
            echo Not supported
            goto shell
        )
    )

    rem Remove $RECYCLE.BIN and System\ Volume\ Information from the output
    !bash_path! -c "cd !bash_current_dir!; ls !args! !args2! !args3! !args4! !args5! | grep -v '$RECYCLE.BIN' | grep -v 'System\ Volume\ Information'" 2>&1
) else if !command!==dir (
    rem Check if args starts with /
    if "!args:~0,1!"=="/" (
        rem Replace that with drive letter
        set "args=!install_part!\!args:~1!"
        rem Convert drive letter to git bash path
        set "args=!args:C:=/c/!"
        set "args=!args:D:=/d/!"
        set "args=!args:E:=/e/!"
        set "args=!args:F:=/f/!"
        set "args=!args:G:=/g/!"
        set "args=!args:H:=/h/!"
        set "args=!args:I:=/i/!"
        set "args=!args:J:=/j/!"
        set "args=!args:K:=/k/!"
        set "args=!args:L:=/l/!"
        set "args=!args:M:=/m/!"
        set "args=!args:N:=/n/!"
        set "args=!args:O:=/o/!"
        set "args=!args:P:=/p/!"
        set "args=!args:Q:=/q/!"
        set "args=!args:R:=/r/!"
        set "args=!args:S:=/s/!"
        set "args=!args:T:=/t/!"
        set "args=!args:U:=/u/!"
        set "args=!args:V:=/v/!"
        set "args=!args:W:=/w/!"
        set "args=!args:X:=/x/!"
        set "args=!args:Y:=/y/!"
        set "args=!args:Z:=/z/!"
    )
    rem Check if args2 starts with /
    if "!args2:~0,1!"=="/" (
        rem Replace that with drive letter
        set "args2=!install_part!\!args2:~1!"
        rem Convert drive letter to git bash path
        set "args2=!args2:C:=/c/!"
        set "args2=!args2:D:=/d/!"
        set "args2=!args2:E:=/e/!"
        set "args2=!args2:F:=/f/!"
        set "args2=!args2:G:=/g/!"
        set "args2=!args2:H:=/h/!"
        set "args2=!args2:I:=/i/!"
        set "args2=!args2:J:=/j/!"
        set "args2=!args2:K:=/k/!"
        set "args2=!args2:L:=/l/!"
        set "args2=!args2:M:=/m/!"
        set "args2=!args2:N:=/n/!"
        set "args2=!args2:O:=/o/!"
        set "args2=!args2:P:=/p/!"
        set "args2=!args2:Q:=/q/!"
        set "args2=!args2:R:=/r/!"
        set "args2=!args2:S:=/s/!"
        set "args2=!args2:T:=/t/!"
        set "args2=!args2:U:=/u/!"
        set "args2=!args2:V:=/v/!"
        set "args2=!args2:W:=/w/!"
        set "args2=!args2:X:=/x/!"
        set "args2=!args2:Y:=/y/!"
        set "args2=!args2:Z:=/z/!"
    )
    rem Check if args3 starts with /
    if "!args3:~0,1!"=="/" (
        rem Replace that with drive letter
        set "args3=!install_part!\!args3:~1!"
        rem Convert drive letter to git bash path
        set "args3=!args3:C:=/c/!"
        set "args3=!args3:D:=/d/!"   
        set "args3=!args3:E:=/e/!"
        set "args3=!args3:F:=/f/!"
        set "args3=!args3:G:=/g/!"
        set "args3=!args3:H:=/h/!"
        set "args3=!args3:I:=/i/!"
        set "args3=!args3:J:=/j/!"
        set "args3=!args3:K:=/k/!"
        set "args3=!args3:L:=/l/!"
        set "args3=!args3:M:=/m/!"
        set "args3=!args3:N:=/n/!"
        set "args3=!args3:O:=/o/!"
        set "args3=!args3:P:=/p/!"
        set "args3=!args3:Q:=/q/!"
        set "args3=!args3:R:=/r/!"
        set "args3=!args3:S:=/s/!"
        set "args3=!args3:T:=/t/!"
        set "args3=!args3:U:=/u/!"
        set "args3=!args3:V:=/v/!"
        set "args3=!args3:W:=/w/!"
        set "args3=!args3:X:=/x/!"
        set "args3=!args3:Y:=/y/!"
        set "args3=!args3:Z:=/z/!"
    )
    rem Check if args4 starts with /
    if "!args4:~0,1!"=="/" (
        rem Replace that with drive letter
        set "args4=!install_part!\!args4:~1!"
        rem Convert drive letter to git bash path
        set "args4=!args4:C:=/c/!"
        set "args4=!args4:D:=/d/!"
        set "args4=!args4:E:=/e/!"
        set "args4=!args4:F:=/f/!"
        set "args4=!args4:G:=/g/!"
        set "args4=!args4:H:=/h/!"
        set "args4=!args4:I:=/i/!"
        set "args4=!args4:J:=/j/!"
        set "args4=!args4:K:=/k/!"
        set "args4=!args4:L:=/l/!"
        set "args4=!args4:M:=/m/!"
        set "args4=!args4:N:=/n/!"
        set "args4=!args4:O:=/o/!"
        set "args4=!args4:P:=/p/!"
        set "args4=!args4:Q:=/q/!"
        set "args4=!args4:R:=/r/!"
        set "args4=!args4:S:=/s/!"
        set "args4=!args4:T:=/t/!"
        set "args4=!args4:U:=/u/!"
        set "args4=!args4:V:=/v/!"
        set "args4=!args4:W:=/w/!"
        set "args4=!args4:X:=/x/!"
        set "args4=!args4:Y:=/y/!"
        set "args4=!args4:Z:=/z/!"
    )
    rem Check if args5 starts with /
    if "!args5:~0,1!"=="/" (
        rem Replace that with drive letter
        set "args5=!install_part!\!args5:~1!"
        rem Convert drive letter to git bash path
        set "args5=!args5:C:=/c/!"
        set "args5=!args5:D:=/d/!"
        set "args5=!args5:E:=/e/!"
        set "args5=!args5:F:=/f/!"
        set "args5=!args5:G:=/g/!"
        set "args5=!args5:H:=/h/!"
        set "args5=!args5:I:=/i/!"
        set "args5=!args5:J:=/j/!"
        set "args5=!args5:K:=/k/!"
        set "args5=!args5:L:=/l/!"
        set "args5=!args5:M:=/m/!"
        set "args5=!args5:N:=/n/!"
        set "args5=!args5:O:=/o/!"
        set "args5=!args5:P:=/p/!"
        set "args5=!args5:Q:=/q/!"
        set "args5=!args5:R:=/r/!"
        set "args5=!args5:S:=/s/!"
        set "args5=!args5:T:=/t/!"
        set "args5=!args5:U:=/u/!"
        set "args5=!args5:V:=/v/!"
        set "args5=!args5:W:=/w/!"
        set "args5=!args5:X:=/x/!"
        set "args5=!args5:Y:=/y/!"
        set "args5=!args5:Z:=/z/!"
    )

    rem Check if any args contain ~ and if so, display the message Not supported
    for /f "tokens=* delims=*" %%a in ("!args!") do (
        if "%%a"=="~" (
            echo Not supported
            goto shell
        )
    )
    for /f "tokens=* delims=*" %%a in ("!args2!") do (
        if "%%a"=="~" (
            echo Not supported
            goto shell
        )
    )
    for /f "tokens=* delims=*" %%a in ("!args3!") do (
        if "%%a"=="~" (
            echo Not supported
            goto shell
        )
    )
    for /f "tokens=* delims=*" %%a in ("!args4!") do (
        if "%%a"=="~" (
            echo Not supported
            goto shell
        )
    )
    for /f "tokens=* delims=*" %%a in ("!args5!") do (
        if "%%a"=="~" (
            echo Not supported
            goto shell
        )
    )

    rem Remove $RECYCLE.BIN and System\ Volume\ Information from the output
    !bash_path! -c "cd !bash_current_dir!; ls !args! !args2! !args3! !args4! !args5! | grep -v '$RECYCLE.BIN' | grep -v 'System\ Volume\ Information'" 2>&1
) else if !command!==nvim (
    echo If you have neovim installed and don't have vim installed, please use the vim command instead.
) else (
    rem It is any other command
    !bash_path! -c "cd !bash_current_dir!; !command! !args! !args2! !args3! !args4! !args5! !args6! !args7! !args8! !args9! !args10! !args11! !args12! !args13! !args14! !args15! !args16! !args17! !args18! !args19! !args20! !args21! !args22! !args23! !args24! !args25! !args26!" 2>&1
)