echo off
SET itdate=%date:~-10%
SET itdate=%itdate:~6,4%-%itdate:~3,2%-%itdate:~0,2%
echo Current date: %itdate%
echo . Startting OAS and TIA conf backup
echo .


SET BACKUPDIR=E:\backup
cd %BACKUPDIR%
mkdir E:\backup\%itdate%
set log_file=%BACKUPDIR%\%itdate%\backup.log
echo Log_file=%log_file%

xcopy /y E:\oracle\as_forms1012_echo\forms\server\formsweb.cfg %BACKUPDIR%\%itdate%\ >> %log_file%
xcopy /y E:\oracle\as_forms1012_echo\Apache\modplsql\conf\dads.conf %BACKUPDIR%\%itdate%\ >> %log_file%
xcopy /y E:\oracle\as_forms1012_echo\forms\server\webutil.cfg %BACKUPDIR%\%itdate%\ >> %log_file%
xcopy /y E:\oracle\as_forms1012_echo\forms\server\env.env %BACKUPDIR%\%itdate%\ >> %log_file%
xcopy /y E:\oracle\as_forms1012_echo\NETWORK\ADMIN\tnsnames.ora %BACKUPDIR%\%itdate%\ >> %log_file%

echo . Backup Complete >> %log_file%
echo .
echo . Attempting to remove old files >> %log_file%
:: remove sub directories from BACKUPDIR
FORFILES /p %BACKUPDIR% /S /D -14 /C "cmd /c IF @isdir == TRUE RMDIR /S /Q @path"
COMPRESS -z 
echo . Old files removed >> %log_file%
echo .
echo .Finnished!
echo .Finnished!  >> %log_file%
