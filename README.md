# xld-sybase-plugin

[![Build Status](https://travis-ci.org/xebialabs-community/xld-sybase-plugin.svg?branch=master)](https://travis-ci.org/xebialabs-community/xld-sybase-plugin)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d7cb6f6e35f547daabd61ebaa5858dc1)](https://www.codacy.com/app/tjrandall/xld-sybase-plugin?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=xebialabs-community/xld-sybase-plugin&amp;utm_campaign=Badge_Grade)
[![Code Climate](https://codeclimate.com/github/xebialabs-community/xld-sybase-plugin/badges/gpa.svg)](https://codeclimate.com/github/xebialabs-community/xld-sybase-plugin)
[![License: MIT][xld-sybase-plugin-license-image] ][xld-sybase-plugin-license-url]
[![Github All Releases][xld-sybase-plugin-downloads-image]]()

[xld-sybase-plugin-license-image]: https://img.shields.io/badge/License-MIT-yellow.svg
[xld-sybase-plugin-license-url]: https://opensource.org/licenses/MIT
[xld-sybase-plugin-downloads-image]: https://img.shields.io/github/downloads/xebialabs-community/xld-sybase-plugin/total.svg

## Preface
The Sybase plugin allows you to create a Sybase database client, and Sybase database deployable, to deploy Sybase SQL database.

## Overview
This Sybase SQL plugin works the same as all other SQL deployments.  For each SQL file in your SQL deployable, a wrapper.sql file is created to ensure proper error handling.  This wrapper.sql file is then passed into the SQL database client, with the appropriate flags.  (ex/ host, port, username, password, etc)

For this Sybase plugin, the following flags are passed into ISQL:

	-S server_name
	-D database
	-U username
	-P password
	(Any additionalOptions)
	--retserverror
	-i inputfile

ref. [Sybase ISQL documentation](http://infocenter.sybase.com/help/index.jsp?topic=/com.sybase.infocenter.dc34237.1500/html/mvsinst/CIHHFDGC.htm)

The actual command, using Freemarker replacement at runtime, will be for Windows:

`"${deployed.container.sybHome}\${deployed.container.sybOcs}\bin\isql.exe" -S ${deployed.container.address}:${deployed.container.port} -D ${sanitize(deployed.container.dbName)} -U ${sanitize(cmn.lookup('username'))} -P <#if cmn.lookup('password')??>${sanitize(cmn.lookup('password'))}</#if> ${cmn.lookup('additionalOptions')!} --retserverror -i ${sqlScriptToExecute}`

The actual command, using Freemarker replacement at runtime, will be for Unix/Linux:

`"${deployed.container.sybHome}/${deployed.container.sybOcs}/bin/isql" -S ${deployed.container.address}:${deployed.container.port} -D ${sanitize(deployed.container.dbName)} -U ${sanitize(cmn.lookup('username'))} -P <#if cmn.lookup('password')??>${sanitize(cmn.lookup('password'))}</#if> ${cmn.lookup('additionalOptions')!} --retserverror -i ${sqlScriptToExecute}`

Note: An empty password or 'NULL' password is allowed bij Sybase but using an empty password is considered insecure.

To use the plugin, you:

1. Create a sql.SybaseClient under Infrastructure.
2. Add the sql.SybaseClient into target Environment definition.
3. Create an application, with a sql.SqlScripts deployable.

You can now execute a Sybase database deployment.
For an example check the examples directory. Here you will find an Infrastructure As Code file to configure your server with the xl(.exe) client and some innocent SQL files to use against your database.

## Installation
1. Download the version of the plugin from the [Releases](https://github.com/xebialabs-community/xld-sybase-plugin/releases) tab, and install in your **XL_DEPLOY/plugins** directory or upload to XL Deploy using the pluginmanager.
2. Restart XL Deploy.

## References

[Introduction to SQL Database Plugin](https://docs.digital.ai/bundle/devops-deploy-version-v.22.3/page/deploy/concept/database-plugin.html)

[Extend the XL Deploy Database plugin](https://docs.digital.ai/bundle/devops-deploy-version-v.22.3/page/deploy/how-to/extend-the-xl-deploy-database-plugin.html)