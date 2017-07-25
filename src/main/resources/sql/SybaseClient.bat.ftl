@echo off
setlocal

<#import "/sql/commonFunctions.ftl" as cmn>
<#include "/generic/templates/windowsSetEnvVars.ftl">

set SYBASE_HOME="${deployed.container.sybHome}"

<#if !cmn.lookup('username')??>
echo 'ERROR: username not specified! Specify it in either SqlScripts or its SybaseClient container'
endlocal
exit /B 1
<#elseif !cmn.lookup('password')??>
echo 'ERROR: password not specified! Specify it in either SqlScripts or its SybaseClient container'
endlocal
exit /B 1
<#else>
cd ${deployed.file.path}
echo WHENEVER SQLERROR EXIT 1 ROLLBACK; >> wrapper.sql
echo WHENEVER OSERROR EXIT 2 ROLLBACK; >> wrapper.sql
echo @"${sqlScriptToExecute}" >> wrapper.sql
"${deployed.container.sybHome}\bin\dbisql" -host ${deployed.container.address} -port ${deployed.container.port} -c "${cmn.lookup('additionalOptions')!} uid=${cmn.lookup('username')};pwd=${cmn.lookup('password')};dbn=${deployed.container.dbName};eng=${deployed.container.engName};" @wrapper.sql

set RES=%ERRORLEVEL%
if not %RES% == 0 (
  exit %RES%
)

endlocal
</#if>
