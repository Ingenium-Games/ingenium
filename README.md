# ig.core

Please only use the releases, cloneing may result in errors.

This is the core resource used on the Ingenium Games FiveM Server.

<br>

It utilizes state bags and will __ONLY__ work as intended with OneSync Infinity, so use or tick the box from your txAdmin web panel. or set `+onesync on`

<br>

-----

<br>

> Note: As with all source code on the internet, please review prior to blindly using...

<br>
<br>

## __How it works__

<br>

Data tables (xPlayer, xVehicle, xPed, xObject) are stored server side for each entity, with its entity as its key and data being the table value. ^1

<br>

Any update of an entities data table on the server will trigger the entity state to also updated and repliated. As statebags can be accessed by the client, there is no need to pass the data to the client for any entity. ^2

<br>

From the data tables, the server will asyncriously save data stored to the SQL database at scheduled intervals. ^3

<br>

> ^1: I kept it in the ESX style format for ease of reading/switching over for other servers to not break your brain. Databases are different and will not work from ES / ESX / OX / VRP / Any Other.

<br>

> ^2: Do not trust the clients, for the most part.
Some natives are only client sided, so leverage the callbacks to request data when applicable.

<br>

> ^3: Using the mysql-async resource's store functions, pre determined queries only send the data per transaction rather than full statements, cutting down the time needed to perform.

<br>

-----

<br>


## Overview

<br>

>#### This is a work of constant development and change, some functions may break or change on the way to release.

<br>

This is intended to be used by people getting started within FiveM and to be somewhat user friendly, but also for the more advanced users or developers too.

It is a learning experiance getting started with native functions, runtime issues, differances with NUI/DUI, but if you perservere, you will end up making something enjoyable for yourself and __hopefully__ others.

Just try and have fun.

<br>

-----

<br>


## Getting Started

<br>

Please make sure you have had a read of how to setup a server from the [FiveM Docs](https://docs.fivem.net/docs/), use this as a referance point for both native function useage as well as finding out how things work within their runtime.

But the basics are:
- [Reading the FiveM Docs on how to Setup a Server,](https://docs.fivem.net/docs/server-manual/setting-up-a-server/)
- [Installing and using a SQL Server (MariaDB, MySQL),](https://mariadb.org/)
- import the db.sql to your sql server,
- Check your server.cfg is setup and like the example,
- Have Fun!


A general getting started guide will be on the wiki as mentioned below.

<br>

>##### Note: *Please only use a linux build server if you are comfortable in development. It does not have features that assist with debugging and troubleshooting for the [CFX.re](https://cfx.re/) team.*

<br>

-----

<br>

## [Wiki](https://github.com/Ingenium-Games/ore/wiki)

<br>

The [Wiki](https://github.com/Ingenium-Games/ore/wiki) contains a breif overview of functions and events that operate within the core to assist in leveraging for your own works.

It will also contain a guide on how to get started and eventually a way to import a pre-made server as apart of the txAdmin web panel as a recipe.

This is still, very much, a work in progress


<br>

-----

<br>

## Code Formatting

<br>

An attempt to be as consistant as possible has been made following the below as a set of rough indicators to assist with reading over code blocks,

<br>

### For Lua

<br>

- Variables = lowercase
```lua
local this = {}
```
- Functions = UpperCamelCase
```lua
function TestingFunction() end
```
- Add notes where possible and define paramaters
```lua
--- Function Description
--@param var string "Context around it"
function TestingFunction(var) 
    if type(var) == "string" then
      -- the type of var is string
      print("IS STRING")
    end
end
```

<br>
<br>

### For SQL (mysql-async)

<br>

- Database tables are lowercase, columns are capitalised.
```sql
INSERT INTO `job_accounts` (`Name`, `Description`, `Boss`, `Members`, `Accounts`) etc.. 
```
- Use Parameters within the mysql-async resource.
```lua
local data = "xyz"
MySQL.Async.execute("INSERT `table` .... `Column1` = @data WHERE X=X;", {
["@data"] = data
},function(r) 
    -- do
end)
```
- __*Do not do this!*__
```lua
local data = "Cool Story Bro"
MySQL.Async.execute("INSERT `table` .... `Column1` = "..data..";",{
},function(r) 
    -- do
end)
```

>##### Note: *If you see anyone doing the above, it can probably be exploited in a way to ruin your database.* __*Always pass parameters correctly*__

<br>
<br>

### For JS

<br>

- Variables = lowercase
```js
let variable = 42
```

- Functions = UpperCamelCase
```js
function SameSameA() {};
```

- Add notes where possible and define paramaters
```js
// function descriptions
// @param var type "Context"
function SameSameB(var) {
  if (var != "xyz") {
    // The passed var variable is not equal to xyz
    console.log("var is not xyz")
  };
};
```

<br>
<br>

### For Front End (HTML,CSS,etc)

<br>

- ??? You guys do you, just make it understandable.

>I need to figure out my style..

<br>

<br>

-----

<br>

## Credits and Indirect Contributors

<br>

Special thanks too; 

- @[pietermcfiber](https://github.com/pitermcflebor) for [pmc-callbacks](https://github.com/pitermcflebor/pmc-callbacks)

<br>



-----

<br>

## Testing

<br>

>Note: *It has currently been tested and working on the following server operating systems with no issues present. __As you would hopefully expect!__*
>- Windows Server (64bit)
>- CentOS 8 Stream (64bit) - RHEL Distro

<br>

-----

<br>


> __If you seek to profit, sell, include or use secitons of code, please include the full license as shown.__
> If you do profit, please consider sending some my way.

<br>

-----

<br>


## MIT License (MIT)

**Copyright (c) 2021 : Twiitchter - https://github.com/Ingenium-Games**

*Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:*

*The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.*

*THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*