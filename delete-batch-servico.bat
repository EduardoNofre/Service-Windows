@ECHO off 
setlocal
:REM This will install the EnvioImagem Application as a Windows Service with the most recent Version
:REM
:REM Prerequisits:
:REM   * Copy the nssm_Application directory to BASE_DIR 
:REM   * Place NSSM to installation folder
:REM   * Make Sure Java 8 or other version of Java is inthe Path 

set /p SERVICE_NAME=Digite o nome do servico que deseja deletar = 

:REM 

echo Servico %SERVICE_NAME% sera deletado

pause

echo [SC] Parando servico "%SERVICE_NAME%"
sc stop "%SERVICE_NAME%" >NUL 2>NUL

echo removendo o servico "%SERVICE_NAME%"

sc delete "%SERVICE_NAME%" confirm > NUL 2>NUL

pause
exit /b