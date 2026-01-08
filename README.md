For any and all data related things, please review the https://github.com/DurtyFree/gta-v-data-dumps repo as the source of truth.
Test Push
# ingenium

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

> ^3: Using an integrated MySQL2 connection pool with prepared statements, the system optimizes query execution and provides comprehensive performance monitoring.

<br>

-----

<br>

## 📚 Documentation

**Complete documentation is now available in the [`Documentation/`](./Documentation/) folder.**

- **[User Documentation](./Documentation/README.md)** - Guides and API references for using ingenium
- **[Implementation Documentation](./Implementations/README.md)** - Technical details for contributors
- **[Contributing Guidelines](./CONTRIBUTING.md)** - How to contribute to this project

### Quick Links

- **[Documentation Index](./Documentation/README.md)** - Start here
- **[SQL Architecture](./Documentation/SQL_Architecture.md)** - Database system overview
- **[SQL API Reference](./Documentation/SQL_API_Reference.md)** - Complete API documentation
- **[SQL Migration Guide](./Documentation/SQL_Migration_Guide.md)** - Migrating from mysql-async
- **[Contributing Guide](./CONTRIBUTING.md)** - How to contribute

### Key Documentation

- **SQL & Database**: Architecture, API reference, migration guide, performance optimization
- **Security**: Best practices and implementation guidelines
- **Testing**: Testing frameworks and procedures
- **Validation**: Centralized validation system

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

### 🔧 Extensibility Philosophy

**ingenium is built to be modified and extended.** Every security feature, configuration, and system within ingenium is designed with external developers in mind. If something exists within ingenium, it should be accessible and customizable to fit your specific needs. We provide APIs and functions to dynamically control features rather than requiring you to edit core files directly.

Example: Rather than manually editing StateBag protection tables, use the provided `ig.security` API functions to add or remove protected keys at runtime from your own resources.

<br>

-----

<br>


## Getting Started

<br>

**📖 For detailed setup instructions, see the [Documentation](./Documentation/README.md)**

Basic requirements:
- [FiveM Server Setup Guide](https://docs.fivem.net/docs/server-manual/setting-up-a-server/)
- [MySQL 5.7+ or MariaDB 10.3+](https://mariadb.org/)
- Import `db.sql` to your database
- Configure `server.cfg` (see [SQL Architecture](./Documentation/SQL_Architecture.md) for configuration)

Pleas Please PLEASE, DO NOT USE ROOT when permitting your FiveM server to authenticate into your database. Please google best practises and create an account dedicated to fivem to only access what it needs...

<br>

>##### Note: *Please only use a linux build server if you are comfortable in development.*

<br>

-----

<br>

## Configuration

### MySQL Connection

Add to your `server.cfg`:

```bash
# Option 1: Connection string (recommended)
set mysql_connection_string "mysql://user:password@host:port/database"

# Option 2: Individual parameters
set mysql_host "localhost"
set mysql_port "3306"
set mysql_user "root"
set mysql_password "yourpassword"
set mysql_database "fivem"
set mysql_connection_limit "10"
```

For detailed configuration options, see [SQL Architecture Documentation](./Documentation/SQL_Architecture.md).

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

### For SQL

<br>

**The core now uses an integrated MySQL2 system. See [SQL Documentation](./Documentation/) for complete details.**

- Database tables are lowercase, columns are capitalised.
```sql
INSERT INTO `job_accounts` (`Name`, `Description`, `Boss`, `Members`, `Accounts`) etig.. 
```
- Use positional parameters (?) or named parameters (@param):
```lua
-- Recommended: Positional parameters
local data = "xyz"
ig.sql.Update("UPDATE `table` SET `Column1` = ? WHERE X = ?", {data, id})

-- Legacy: Named parameters (still supported via compatibility layer)
MySQL.Async.execute("UPDATE `table` SET `Column1` = @data WHERE X = @id", {
    ["@data"] = data,
    ["@id"] = id
})
```
- __*Do not do this!*__
```lua
local data = "Cool Story Bro"
ig.sql.Update("UPDATE `table` SET `Column1` = "..data, {}) -- SQL INJECTION RISK!
```

>##### Note: *Always use parameterized queries to prevent SQL injection attacks. See [Security Guide](./Documentation/Security_Guide.md)*

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

## Database Optimization

<br>

**For detailed performance optimization, see [SQL Performance Documentation](./Documentation/SQL_Performance.md)**

### MySQL Configuration

The core uses an integrated MySQL2 connection pool with automatic performance monitoring.

Configuration in `server.cfg`:

```bash
set mysql_connection_string "mysql://user:pass@localhost:3306/db"
set mysql_connection_limit "10"  # Adjust based on server load
```

<br>

### Performance Monitoring

The SQL system includes comprehensive monitoring:
- Query execution time tracking
- Slow query detection (>150ms)
- Automatic performance logging
- Statistics API (`ig.sql.GetStats()`)

Console command:
```
sqlstats  # Display performance statistics
```

For details, see:
- [SQL Performance Guide](./Documentation/SQL_Performance.md)
- [SQL Events & Exports](./Documentation/SQL_Events_Exports.md)

<br>

### Save System

The dirty flag system ensures efficient database writes:
- Only changed data is saved (60-80% reduction)
- Optimized save intervals per data type
- Prepared statements for high performance
- Real-time performance monitoring

Save intervals:
- Player data: 90 seconds
- Vehicles: 5 minutes  
- Jobs: 10 minutes
- Objects: 5 minutes

<br>

-----

<br>


## Credits and Indirect Contributors

<br>

Special thanks too; 

- @[pietermcfiber](https://github.com/pitermcflebor) for [pmc-callbacks](https://github.com/pitermcflebor/pmc-callbacks)
- @[mkafrin](https://github.com/mkafrin) for [PolyZone](https://github.com/mkafrin/PolyZone) - Integrated into Ingenium as `ig.zone`

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
