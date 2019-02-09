/**
*
* @author pjacekm@gmail.com
* @description 
*
*/

component output="false" accessors="true" singleton {

	// Injected properties (DI)
	property name="Factory" inject="Factory@commandbox-mongodb";
	property name="Wirebox" inject="wirebox";

	public function init(){
		lock name="mongoClientsCache" type="exclusive" timeout=2 {
			variables["mongoClientsCache"]={};
		}

		return this;
	}




	public any function create(string connectionString="") {

		/* var connectionStringHash=hash(arguments.connectionString);

		if(structKeyExists(variables["mongoClientsCache"], connectionStringHash)){
			return variables["mongoClientsCache"][connectionStringHash];
		}
		else{
			lock name='mongoClientsCache' type='exclusive' timeout=30 {
				if(!structKeyExists(variables["mongoClientsCache"], connectionStringHash)){
					var mongoClients=getFactory().getObject("com.mongodb.client.MongoClients");
		
					if(arguments.connectionString.len()){
						var mongoClient=mongoClients.create(
							javacast("string", arguments.connectionString)
						);
					}
					else {
						var mongoClient=mongoClients.create();
					}

					var mongoClient=getWirebox().getInstance("MongoClient@commandbox-mongodb");
					mongoClient.setMongoClient(mongoClient);

					variables["mongoClientsCache"][connectionStringHash]=mongoClient;
				}
				
			}
			
			return variables["mongoClientsCache"][connectionStringHash];
		} */




		var mongoClients=getFactory().getObject("com.mongodb.client.MongoClients");
		
		if(arguments.connectionString.len()){
			var mongoClient=mongoClients.create(
				javacast("string", arguments.connectionString)
			);
		}
		else {
			var mongoClient=mongoClients.create();
		}

		var mongoClientWrapper=getWirebox().getInstance("MongoClient@commandbox-mongodb");
		mongoClientWrapper.setMongoClient(mongoClient);

		return mongoClientWrapper;
		
	}
}
