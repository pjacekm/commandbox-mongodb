/**
*
* @author pjacekm@gmail.com
* @description Carries MongoDB connection information. By default loaded with data from ModuleConfig.
*
*/

component output="false" accessors="true" {

	// Injected properties (DI)
	property name="ModuleSettings" inject="commandbox:moduleSettings:commandbox-mongodb";

	// Local properties
	property name="Hosts" type="array" setter="false";
	property name="Credentials" type="array" setter="false";
	property name="Options" type="struct" setter="false";
	property name="DatabaseName" type="string" default="";
	property name="MongoDriverVersion" type="string" default="";


	public function init(){
		// Initialize default complex properties
		variables["Hosts"]=[];
		variables["Credentials"]=[];
		variables["Options"]={};

		return this;
	}




	public function onDIComplete() {
		initializeConfigFromSettings();

		return this;
	}




	public void function addHost(required string serverName, required numeric serverPort) {
		var host={
			"serverName": arguments.serverName,
			"serverPort": arguments.serverPort
		}

		arrayAppend(getHosts(), host);
	}




	public void function addCredential(required string userName, required string password, required string database) {
		var credential={
			"userName": arguments.userName,
			"password": arguments.password,
			"database": arguments.database
		}

		arrayAppend(getCredentials(), credential);
	}




	public void function addOption(required string optionName, required any optionValue) {
		var options=getOptions();
		options[arguments.optionName]=arguments.optionValue;
	}




	public function initializeConfigFromSettings() {
		var defaultSettings=getModuleSettings();
		var hidx="";
		var cidx="";

		setMongoDriverVersion(defaultSettings["mongoDriverVersion"]);

		if(structKeyExists(defaultSettings, "hosts") and isArray(defaultSettings["hosts"]) and arrayLen(defaultSettings["hosts"])){
			cfloop(array="#defaultSettings["hosts"]#" item="hidx"){
				this.addHost(
					serverName=hidx["serverName"],
					serverPort=hidx["serverPort"]
				);
			}
		}

		if(structKeyExists(defaultSettings, "credentials") and isArray(defaultSettings["credentials"]) and arrayLen(defaultSettings["credentials"])){
			cfloop(array="#defaultSettings["credentials"]#" item="cidx"){
				this.addCredential(
					userName=cidx["userName"],
					password=cidx["password"],
					database=cidx["database"]
				);
			}
		}

		if(structKeyExists(defaultSettings, "databaseName") and isSimpleValue(defaultSettings["databaseName"]) and len(defaultSettings["databaseName"])){
			this.setDatabaseName(defaultSettings["databaseName"]);
		}

		if(structKeyExists(defaultSettings, "options") and isStruct(defaultSettings["options"]) and structCount(defaultSettings["options"])){
			for(var oidx in defaultSettings["options"]){
				this.addOption(
					optionName=oidx,
					optionValue=defaultSettings["options"][oidx]
				);
			}
		}
	}
}
