@ECHO off 
setlocal
:REM This will install the EnvioImagem Application as a Windows Service with the most recent Version
:REM
:REM Prerequisits:
:REM   * Copy the nssm_Application directory to BASE_DIR 
:REM   * Place NSSM to installation folder
:REM   * Make Sure Java 8 or other version of Java is inthe Path 
echo ....................................................
echo ....................................................
echo Step 1) Antes de tudo colocar a pasta nssm-2.24 no seu diretorio C:\ da sua maquina!
echo nssm-2.24 essa pasta se encontra no pacote, e é essencial para criar serviço no windows

set nssm_DIR=C:\nssm-2.24
if not exist "%nssm_DIR%" (
  echo ....................................................................................
  echo......................... Aviso .....................................................
  echo ....................................................................................
  echo
  echo Essencial para cirar o serviço no windows "%nssm_DIR%"!
  echo.
  echo Nao foi encontrado o arquivo %NSSM%!
  echo Por favor, faca o download pela URL http://nssm.cc/release/nssm-2.24.zip
  echo Instale na seguinte estrutura: C:\nssm-2.24
  echo favor verificar se o direotrio existe
  echo.
  pause
  exit /B 1
)
if exist "%nssm_DIR%" (
  echo.
  echo Diretorio o pacote ja existe "%nssm_DIR%"!
  echo ok!
)

echo ....................................................................................
echo ....................................................................................
echo.
echo Step 2) - Devemos criar o seguinte diretorio: 
echo Neste diretorio fica tudo referente ao serviço de importação da JUCEC
echo OBS: Caso já exista desconsidere
echo ............ C:\ImportacaoDiariaJucec ..............................................
echo ....................................................................................

set PROPERTIES_DIR_RAIZ=C:\ImportacaoDiariaJucec
echo %PROPERTIES_DIR_RAIZ%

if not exist "%PROPERTIES_DIR_RAIZ%" (
  echo.
  echo Nao foi encontrado o diretorio "%PROPERTIES_DIR_RAIZ%"!
  echo.
  echo verifique esta configuracao
  echo.
  pause
  exit /B 1
)
if exist "%PROPERTIES_DIR_RAIZ%" (
  echo.
  echo Diretorio ja existe "%PROPERTIES_DIR_RAIZ%"!
  echo ok!
)

echo ....................................................................................
echo ....................................................................................
echo.
echo Step 3) - Devemos criar o seguinte diretorio: 
echo diretorio onde fica os logs da aplicação, neste diretorio deve ter duas pastas são elas:
echo Log_negocio e Log_sistema
echo OBS: Caso já exista desconsidere
echo
echo ........................... C:\ImportacaoDiariaJucec\log ...........................
echo ....................................................................................

set PROPERTIES_DIR_LOG=C:\ImportacaoDiariaJucec\log
echo %PROPERTIES_DIR_LOG%

if not exist "%PROPERTIES_DIR_LOG%" (
  echo.
  echo Nao foi encontrado o diretorio "%PROPERTIES_DIR_LOG%"!
  echo.
  echo verifique esta configuracao
  echo.
  pause
  exit /B 1
)
if exist "%PROPERTIES_DIR_LOG%" (
  echo.
  echo Diretorio ja existe "%PROPERTIES_DIR_LOG%"!
  echo ok!
)


echo ....................................................................................
echo ....................................................................................
echo
echo Step 4) - E no diretorio " C:\ImportacaoDiariaJucec\CONFIG-PROPERTIES " iremos colar esses quatro arquivos:
echo.
echo 1) - log4jSistema.properties
echo 2) - Log4jNegocio.properties
echo 3) - log4jSistema.properties
echo 4) - config.properties
echo OBS: Os arquivos mencionado a cima devem esta no pacote que lhe foi entregue!
echo È de sua responsabilidade configurar os as arquivos acima. 
echo OBS: Caso já exista desconsidere
echo ....................................................................................
echo ....................................................................................
set PROPERTIES_DIR_PROPE=C:\ImportacaoDiariaJucec\CONFIG-PROPERTIES
if not exist "%PROPERTIES_DIR_PROPE%" (
  echo.
  echo Nao foi encontrado o diretorio "%PROPERTIES_DIR_PROPE%"!
  echo.
  echo verifique esta configuracao
  echo.
  pause
  exit /B 1
)
if exist "%PROPERTIES_DIR_PROPE%" (
  echo.
  echo Diretorio ja existe "%PROPERTIES_DIR_PROPE%"!
  echo ok!
)

pause


echo ....................................................................................
echo .......... Digite o Diretorio onde o jar se encontra, exemplo (c:\batch) ...........
echo ....................................................................................
set /p BASE_DIR=Digite o Diretorio onde o jar se encontra, exemplo (c:\batch) = 
echo %BASE_DIR%


echo ....................................................................................
echo ............. Digite o nome do jar exemplo (importacao.jar) ........................
echo ....................................................................................
set /p SERVER_JAR=Digite o nome do jar exemplo (importacao.jar) = 
echo %SERVER_JAR%


echo ....................................................................................
echo ............ Digite o Nome do Servico que deseja criar (sem espacos) ...............
echo ....................................................................................
echo ................ Por padrao devemos usar o nome abaixo .............................
echo ............................. importacaojucec ......................................

set /p SERVICE_NAME=Digite o Nome do Servico que deseja criar (sem espacos) = 
echo %SERVICE_NAME%

set NSSM="c:\nssm-2.24\win64\nssm.exe"

echo Local do arquivo Jar: %BASE_DIR%\%SERVER_JAR%
echo Nome do servico que sera criado: %SERVICE_NAME%

pause

if not exist %NSSM% (
  echo .
  echo Nao foi encontrado o arquivo %NSSM%!
  echo Por favor, faca o download pela URL http://nssm.cc/release/nssm-2.24.zip
  echo Instale na seguinte estrutura: C:\nssm-2.24
  echo .
  pause
  exit /B 1
)
if not exist "%BASE_DIR%\%SERVER_JAR%" (
  echo.
  echo Não foi encontrado o arquivo "%BASE_DIR%\%SERVER_JAR%"!
  echo.
  echo verifique esta configuracao
  echo.
  pause
  exit /B 1
)

echo [SC] Parando servico "%SERVICE_NAME%"
sc stop %SERVICE_NAME% >NUL 2>NUL

echo [NSSM] Tentando remover o servico "%SERVICE_NAME%" caso ele exista...

%NSSM% remove %SERVICE_NAME% confirm > NUL 2>NUL

echo [NSSM] Instalando como servico: *%SERVICE_NAME%
echo.
echo         Caminho: "%SERVER_JAR%"
echo.

cd %BASE_DIR%

%NSSM% install "%SERVICE_NAME%" java -jar -Dlogback.configurationFile=%LOGBACK_FILE% %SERVER_JAR% %FOLDER_CONFIG%
%NSSM% set "%SERVICE_NAME%" AppDirectory "%BASE_DIR%"
%NSSM% set "%SERVICE_NAME%" DisplayName "%SERVICE_NAME%"
%NSSM% set "%SERVICE_NAME%" Description "Importação de imagem Jucec"
%NSSM% set "%SERVICE_NAME%" Start "SERVICE_AUTO_START"
%NSSM% set "%SERVICE_NAME%" ObjectName "LocalSystem"
%NSSM% set "%SERVICE_NAME%" Type "SERVICE_WIN32_OWN_PROCESS"
%NSSM% set "%SERVICE_NAME%" AppPriority "NORMAL_PRIORITY_CLASS"
%NSSM% set "%SERVICE_NAME%" AppNoConsole "0"
%NSSM% set "%SERVICE_NAME%" AppAffinity "All"
%NSSM% set "%SERVICE_NAME%" AppStopMethodSkip "0"
%NSSM% set "%SERVICE_NAME%" AppStopMethodConsole "1500"
%NSSM% set "%SERVICE_NAME%" AppStopMethodWindow "1500"
%NSSM% set "%SERVICE_NAME%" AppStopMethodThreads "1500"
%NSSM% set "%SERVICE_NAME%" AppThrottle "1500"
%NSSM% set "%SERVICE_NAME%" AppExit "Default Restart"
%NSSM% set "%SERVICE_NAME%" AppRestartDelay "0"
%NSSM% set "%SERVICE_NAME%" AppThrottle "1500"
%NSSM% set "%SERVICE_NAME%" AppStdoutCreationDisposition "4"
%NSSM% set "%SERVICE_NAME%" AppStderrCreationDisposition "4"
%NSSM% set "%SERVICE_NAME%" AppRotateFiles "1"
%NSSM% set "%SERVICE_NAME%" AppRotateOnline "1"
%NSSM% set "%SERVICE_NAME%" AppRotateSeconds "86400"
%NSSM% set "%SERVICE_NAME%" AppRotateBytes "524288000"
pause
exit /b