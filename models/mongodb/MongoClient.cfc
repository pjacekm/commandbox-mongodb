/**
*
* @author 
* @description 
*
*/

component output="false" accessors="true" singleton {

	// Injected properties (DI)
	// property name="ModuleConfig" inject="commandbox:moduleConfig:commandbox-mongodb";
	// property name="ModuleSettings" inject="commandbox:moduleSettings:commandbox-mongodb";
	// property name="ModuleService" inject="ModuleService";
	property name="Factory" inject="Factory@commandbox-mongodb";
	property name="Config" inject="Config@commandbox-mongodb";
	property name="Util" inject="Util@commandbox-mongodb";
	property name="Wirebox" inject="wirebox";

	// Local properties
	property name="Databases" type="struct" setter="false";
	property name="MongoClient" type="any" default="";

	public function init(){
		// Initialize default complex properties
		variables["Databases"]={};

		return this;
	}




	public function onDIComplete() {
		connect(getConfig());
		return this;
	}




	public function connect(required config config) {
		var factory=getFactory();
		var mongoClient=factory.getObject("com.mongodb.MongoClient");
		var configHosts=arguments.config.getHosts();

		// Basic checks
		if(!configHosts.len()){
			throw(type = "commandbox-mongodb.missingHostsException", message = "Missing required 'hosts' config.", detail="At least one host should be configured.");
		}
		if(arguments.config.getDatabaseName().len() eq 0){
			throw(type = "commandbox-mongodb.missingDatabaseNameException", message = "Missing required 'DatabaseName' config.", detail="");
		}

		// Create ServerAddress array
		var mongoServers=buildMongoServers(config=arguments.config);

		// Build options
		var mongoClientOptions=buildMongoOptions(config=arguments.config);

		// Create MongoCredential array
		var mongoCredentials=buildMongoCredentials(config=arguments.config);

		// Connect to server
		if(arrayLen(mongoCredentials)){
			mongoClient.init(mongoServers, mongoCredentials, mongoClientOptions);
		}
		else {
			mongoClient.init(mongoServers, mongoClientOptions);
		}

		/* 
			Note:
			If the above lines start to generate console JUL log entries, add SLF4J no-op jar to /lib/.
			See: https://groups.google.com/forum/#!topic/mongodb-user/_t5rHlaxYxI
		*/

		// Preserve initialized and connected java MongoClient in wrapper instance.
		setMongoClient(mongoClient);

		return this;
	}




	public function getDatabase(string databaseName=getConfig().getDatabaseName()) {
		var databases=getDatabases();
		var database="";

		if(structKeyExists(databases, arguments.databaseName)){
			database=databases[arguments.databaseName];
		}
		else{
			database=getWirebox().getInstance("MongoDatabase@commandbox-mongodb");
			var mongoDatabase=getMongoClient().getDatabase(arguments.databaseName);
			database.setMongoDatabase(mongoDatabase);
			databases[arguments.databaseName]=database;
		}

		return database;
	}




	public any function listDatabaseNames() {
		var dbNames=getMongoClient().listDatabaseNames();
		var mongoIterable=getWirebox().getInstance("MongoIterable@commandbox-mongodb");
		mongoIterable.setMongoIterable(dbNames);
		return mongoIterable;
	}




	public any function listDatabases() {
		var dbs=getMongoClient().listDatabases();
		var listDatabasesIterable=getWirebox().getInstance("ListDatabasesIterable@commandbox-mongodb");
		listDatabasesIterable.setMongoIterable(dbs);
		return listDatabasesIterable;
	}




	public any function getMongoClientOptions() {
		return getMongoClient().getMongoClientOptions();
	}




	private function buildMongoServers(required config config) {
		var factory=getFactory();
		var mongoServers=factory.getObject("java.util.ArrayList").init();
		var configHosts=arguments.config.getHosts();
		var hidx="";

		cfloop(array="#configHosts#" item="hidx"){
			var serverAddress=factory.getObject("com.mongodb.ServerAddress").init(hidx["serverName"], hidx["serverPort"]);
			mongoServers.add(serverAddress);
		}

		return mongoServers;
	}




	private function buildMongoOptions(required config config) {
		var factory=getFactory();
		var mongoBuilder=factory.getObject("com.mongodb.MongoClientOptions$Builder");
		var configOptions=arguments.config.getOptions();

		for( var oidx in configOptions ){
			var arg = configOptions[oidx];
			try{
				switch(oidx){
					case "readPreference":
						var rp = this.readPreference(arg);
						mongoBuilder.readPreference(rp);
						break;

					case "readConcern":
						var rc = this.readConcern(arg);
						mongoBuilder.readConcern(rc);
						break;

					case "writeConcern":
						var wc = this.writeConcern(arg);
						mongoBuilder.writeConcern(wc);
						break;

					default:
						evaluate("mongoBuilder.#oidx#(arg)");
				}
			}
			catch (any e){
				throw(type = "commandbox-mongodb.mongoOptionException", message = "The Mongo Client option '#oidx#' could not be found.", detail="Please verify that your 'options' settings contain only valid MongoClientOptions settings: http://api.mongodb.org/java/current/com/mongodb/MongoClientOptions.Builder.html");
			}
		}
		var mongoClientOptions=mongoBuilder.build();

		return mongoClientOptions;
	}




	private function buildMongoCredentials(required config config) {
		var factory=getFactory();
		var configCredentials=arguments.config.getCredentials();
		var mongoCredentials=factory.getObject("java.util.ArrayList");
		var cidx="";

		cfloop(array="#configCredentials#" item="cidx"){
			var mongoCredential=factory.getObject("com.mongodb.MongoCredential");
			var credential = mongoCredential.createCredential(
				javacast("string", cidx["userName"]),
				javacast("string", cidx["database"]),
				cidx["password"].toCharArray()
			);
			mongoCredentials.add(credential);
		}

		return mongoCredentials;
	}




	private function readPreference(required string preference){
		var factory=getFactory();
		var rp=factory.getObject("com.mongodb.ReadPreference");

		switch(preference){
			case "primary":
				return rp.primary();
				break;
			case "nearest":
				return rp.nearest();
				break;
			case "primaryPreferred":
				return rp.primaryPreferred();
				break;
			case "secondary":
				return rp.secondary();
				break;
			case "secondaryPreferred":
				return rp.secondaryPreferred();
				break;
			default:
				return rp.primary();
		}
	}

	
	
	
	private function readConcern(required string concern){
		var factory=getFactory();
		var rc=factory.getObject("com.mongodb.ReadConcern");
		return rc[uCase(concern)];
	}




	private function writeConcern(required string concern){
		var factory=getFactory();
		var wc=factory.getObject("com.mongodb.WriteConcern");
		return wc[uCase(concern)];
	}
}
