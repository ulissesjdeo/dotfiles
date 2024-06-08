@echo off
REM Change directory to the user's home directory
cd %HOMEPATH%

REM Set the filename with the current date and time
for /f "tokens=1-5 delims=/-: " %%d in ("%date% %time%") do (
    set FILENAME=%%d_%%e_%%f_%%g_%%h
)

REM Create a zip file of the specified directory with maximum compression
"C:\Program Files\7-Zip\7z.exe" a -mx9 "%FILENAME%.zip" "C:\Program Files (x86)\Steam\userdata\318452227\631510\"

REM Move the zip file to the specified directory
move "%FILENAME%.zip" "%HOMEPATH%\OneDrive\Documentos\saves\dmc"

:: .sh
:: cd $HOME
:: export FILENAME=`date +%d_%m_%Y_%H_%M_%S`
:: 7z a -mx9 $FILENAME.zip /c/Program\ Files\ \(x86\)/Steam/userdata/318452227/631510/
:: mv $FILENAME.zip OneDrive/Documentos/saves/dmc
