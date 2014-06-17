@echo off
SET FILENAME=vMYC_FamiliarFaces
SET ZEXE=c:\Program Files\7-Zip\7z.exe

for /f "tokens=1,2,3,4 delims=^/ " %%W in ('@echo %date%') DO SET NEWTIME=%%Z-%%X-%%Y
for /f "tokens=1,2,3 delims=:." %%W in ('@echo %time%') DO SET NEWTIME=%NEWTIME%_%%W-%%X-%%Y

echo %NEWTIME%
mkdir "%NEWTIME%_%COMPUTERNAME%"
cd "%NEWTIME%_%COMPUTERNAME%"
xcopy /y ..\data\*.esp .
xcopy /y ..\data\*.bsa .
xcopy /y ..\data\*readme* .
echo d | xcopy /e /y ..\data\skse skse
echo d | xcopy /e /y ..\data\vMYC vMYC
"%ZEXE%" a -r "vMYC_FamiliarFaces_%NEWTIME%.7z" "*"
pause
xcopy /y *.7z ..
cd ..
rmdir /s /q "%NEWTIME%_%COMPUTERNAME%"
