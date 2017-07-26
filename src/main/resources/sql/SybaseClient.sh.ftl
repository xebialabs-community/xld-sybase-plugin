<#-- Copyright 2017 XEBIALABS

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-->

#!/bin/sh

<#import "/sql/commonFunctions.ftl" as cmn>

SYBASE_HOME="${deployed.container.sybHome}"
export SYBASE_HOME

# will override the declarations above if SYBASE_HOME or SYBASE_SID are present
<#include "/generic/templates/linuxExportEnvVars.ftl">
<#if !cmn.lookup('username')??>
echo 'ERROR: username not specified! Specify it in either SqlScripts or its SybaseClient container'
exit 1
<#elseif !cmn.lookup('password')??>
echo 'ERROR: password not specified! Specify it in either SqlScripts or its SybaseClient container'
exit 1
<#else>
# Connect to sybase - dbisql -c "uid=DBA;pwd=sql;eng=SERV1_iqdemo;links=tcpip(host=SERV2;port=1234)"
"${deployed.container.sybHome}/bin/dbisql" -c ${cmn.lookup('additionalOptions')!} uid=${cmn.lookup('username')};pwd=${cmn.lookup('password')};eng=${deployed.container.dbName};links=tcpip(host=${deployed.container.address};port=${deployed.container.port})" <<END_OF_WRAPPER
        WHENEVER SQLERROR EXIT 1 ROLLBACK;
        WHENEVER OSERROR EXIT 2 ROLLBACK;
        @"${step.uploadedArtifactPath}"
END_OF_WRAPPER

res=$?
if [ $res != 0 ] ; then
exit $res
fi
</#if>
