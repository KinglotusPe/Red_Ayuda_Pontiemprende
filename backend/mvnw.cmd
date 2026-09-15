@REM ----------------------------------------------------------------------------
@REM Maven Start Up Batch script
@REM ----------------------------------------------------------------------------
@IF "%DEBUG%" == "" @ECHO OFF
@SETLOCAL

SET ERROR_CODE=0

@REM Set local scope for the variables with windows NT shell
IF "%OS%"=="Windows_NT" @SETLOCAL

IF NOT "%JAVA_HOME%" == "" GOTO OkJHome

ECHO.
ECHO Error: JAVA_HOME not found in your environment. >&2
ECHO.
GOTO error

:OkJHome
IF EXIST "%JAVA_HOME%\bin\java.exe" GOTO init

ECHO.
ECHO Error: JAVA_HOME is set to an invalid directory. >&2
ECHO JAVA_HOME = "%JAVA_HOME%" >&2
ECHO.
GOTO error

:init
SET MAVEN_PROJECTBASEDIR=%~dp0
IF "%MAVEN_PROJECTBASEDIR:~-1%"=="\" SET MAVEN_PROJECTBASEDIR=%MAVEN_PROJECTBASEDIR:~0,-1%

SET WRAPPER_JAR="%MAVEN_PROJECTBASEDIR%\.mvn\wrapper\maven-wrapper.jar"
SET WRAPPER_LAUNCHER=org.apache.maven.wrapper.MavenWrapperMain

IF EXIST %WRAPPER_JAR% GOTO run

SET WRAPPER_URL="https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.3.2/maven-wrapper-3.3.2.jar"
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('%WRAPPER_URL%', '%WRAPPER_JAR%')}"

:run
"%JAVA_HOME%\bin\java.exe" %MAVEN_OPTS% -Dmaven.multiModuleProjectDirectory="%MAVEN_PROJECTBASEDIR%" -cp %WRAPPER_JAR% %WRAPPER_LAUNCHER% %*
IF ERRORLEVEL 1 GOTO error
GOTO end

:error
SET ERROR_CODE=1

:end
@IF "%OS%"=="Windows_NT" @ENDLOCAL
@EXIT /B %ERROR_CODE%
