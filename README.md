# MongoDB connectivity package for CommandBox
[MongoDB](https://www.mongodb.com/) [Java driver](http://mongodb.github.io/mongo-java-driver/) wrapper for [CommandBox](https://www.ortussolutions.com/products/commandbox). Supports querying, aggregation, map-reduce, GridFS and geospatial queries. This is a CommandBox module - use it in your CommandBox commands, modules or tasks.

## Prerequisites
- CommandBox v. 3.9+ 
- MongoDB v. 3+ (currently supported MongoDB Java driver version: 3.6.3)


## Note
"Work in Progress": at this stage the project code is usable but more documentation is needed.


## Installation

1. If you haven't already, download and install CommandBox: https://www.ortussolutions.com/products/commandbox#download
2. Install package by issuing the following command: `box install commandbox-mongodb`

The module will be installed into the `/modules` subfolder of your CommandBox installation directory (typically `~/.CommandBox/cfml/modules/`). 

## Configuration
Default connection parameters are set in `ModuleConfig.cfc`. You should not modify settings by editing this file, use CommandBox `config set` commands instead. See examples below and review CommandBox documentation for more info on working with config values: https://ortus.gitbooks.io/commandbox-documentation/config_settings/config_settings.html and https://ortus.gitbooks.io/commandbox-documentation/developing/modules/user_settings.html

### MongoDB server(s)
Config value: `modules.commandbox-mongodb.hosts` (Array of structs). 

Prototype:

	"hosts": [
		{
			"serverName":"127.0.0.1",
			"serverPort":"27017"
		}
	]

Local installation of MongoDB is used by default (IP 127.0.0.1, port 27017). Change these values by issuing the following commands in CommandBox CLI:

	config set modules.commandbox-mongodb.hosts='[{"serverName":"{MongoDB IP}", "serverPort":"{MongoDB port}"}]'
or to append new server to existing config:

	config set modules.commandbox-mongodb.hosts='[{"serverName":"{MongoDB IP 1}", "serverPort":"{MongoDB port 1}"}]' --append



### MongoDB credentials
Config value: `modules.commandbox-mongodb.credentials` (Array of structs).

Prototype:

	"credentials": [
		{
			"userName":"",
			"password":"",
			"database":""
		}
	]

By default, no MongoDB connection credentials are used. Set authentication credentials by issuing the following in CommandBox CLI:

	config set modules.commandbox-mongodb.credentials='[{"userName":"{Auth username}", "password":"{Auth password}", "database":"{Auth database}"}]'


### MongoDB connection options
Config value: `modules.commandbox-mongodb.options` (Struct).

Prototype:

	"options": {
		"{setting}":"{value}"
	}

Example:

	"options": {
		"connectTimeout":2000,
		"serverSelectionTimeout":5000,
		"readPreference":"primaryPreferred"
	}

See available options in [Java driver documentation](http://api.mongodb.com/java/current/com/mongodb/MongoClientOptions.Builder.html).
All options that require simple values as arguments should work (e.g. `heartbeatConnectTimeout` or `connectionsPerHost`); otherwise the following options have been implemented: `readPreference`, `readConcern` and `writeConcern`.

No MongoDB connection options are configured by default. Set connection options by issuing the following in CommandBox CLI:

	config set modules.commandbox-mongodb.options='{"{option 1}":"{value 1}", "{option 2}":"{value 2}"}'


### Default database
Config value: `modules.commandbox-mongodb.databaseName` (String)

Prototype:

	"databaseName": "test"

When initialized, the module will try to connect to specified database. Set default database name by issuing the following in CommandBox CLI:

	config set modules.commandbox-mongodb.databaseName="{your database name}"


## Usage
Commandbox-mongodb package structure and usage is loosely based on MongoDB's Java driver structure and usage. When in doubt, refer to [Java driver API docs](http://api.mongodb.com/java/current/).

In general, use the package in the following way:
1. Use CommandBox Wirebox DI framework for instantiating the package. Entry point for all communication with MongoDB is the `MongoClient` class:

		property name="MongoClient" inject="MongoClient@commandbox-mongodb";

2. Get database instance:

		var db=MongoClient.getDatabase("commandboxTestDb");

3. Get collection representation:

		var myTestCollection=db.getCollection("testCollection");

4. Issue your query, get the results as an array:

		var result=myTestCollection.find().toArray();


Example of the above in CommandBox [task](https://commandbox.ortusbooks.com/content/task-runners.html):

	component{
		property name="MongoClient" inject="MongoClient@commandbox-mongodb";
		property name="JSONPrettyPrint" inject="JSONPrettyPrint";

		function run(){
			var db=MongoClient.getDatabase( "commandboxTestDb" );
			var myTestCollection=db.getCollection( "testCollection" );
			var result=myTestCollection.find( {"_id":{"$oid":"5917654b4420c216dd1bd0dd"}} ).toArray();
			print.text( JSONPrettyPrint.formatJSON(result) );
		}
	}


## Credits
This project uses Mark Mandel's Javaloader (http://javaloader.riaforge.org/)