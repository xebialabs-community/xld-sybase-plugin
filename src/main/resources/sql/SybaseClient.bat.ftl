<#-- Copyright 2017 XEBIALABS

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-->

@echo off
setlocal

<#import "/sql/commonFunctions.ftl" as cmn>
<#include "/generic/templates/windowsSetEnvVars.ftl">

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

${deployed.container.sybHome}\bin\isql.exe -S ${deployed.container.address} -D ${deployed.container.dbName} -U ${cmn.lookup('additionalOptions')!}${cmn.lookup('username')} -P ${cmn.lookup('additionalOptions')!}${cmn.lookup('password')} --retserverror -i ${sqlScriptToExecute}

set RES=%ERRORLEVEL%
if not %RES% == 0 (
  exit %RES%
)

endlocal
</#if>
