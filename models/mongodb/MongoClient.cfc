/**
*
* @author pjacekm@gmail.com
* @description 
*
*/

component output="false" accessors="true" {

	// Injected properties (DI)
	property name="Factory" inject="Factory@commandbox-mongodb";
	property name="Wirebox" inject="wirebox";

	// Local properties
	property name="MongoClient" type="any";

	public function init(){
		return this;
	}




	public function getDatabase(required string databaseName) {
		var database=getWirebox().getInstance("MongoDatabase@commandbox-mongodb");
		var mongoDatabase=getMongoClient().getDatabase(
			javaCast("string", arguments.databaseName)
		);
		database.setMongoDatabase(mongoDatabase);
		return database;
	}
}
