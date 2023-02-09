<#-- 
Copyright 2023 XEBIALABS

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-->

#!/bin/sh

<#import "/sql/commonFunctions.ftl" as cmn>
<#include "/generic/templates/linuxExportEnvVars.ftl">

SYBASE_HOME="${deployed.container.sybHome}"
export SYBASE_HOME

<#if !cmn.lookup('username')??>
echo 'ERROR: username not specified! Specify it in either SqlScripts or its SybaseClient container'
exit 1
<#else>
<#if !cmn.lookup('password')??>
echo 'WARNING: password not specified! Specify it in either SqlScripts or its SybaseClient container. Using an empty string as a password is considered insecure.'
</#if>

cd "${cmn.scriptsPath()}"

"${deployed.container.sybHome}/bin/isql" -S ${deployed.container.address} -D ${sanitize(deployed.container.dbName)} -U ${sanitize(cmn.lookup('username'))} -P <#if cmn.lookup('password')??>${sanitize(cmn.lookup('password'))}</#if> ${cmn.lookup('additionalOptions')!} --retserverror -i ${sqlScriptToExecute}

res=$?
if [ $res != 0 ] ; then
exit $res
fi
</#if>
