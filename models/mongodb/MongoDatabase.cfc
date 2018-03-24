/**
*
* @author pjacekm@gmail.com
* @description 
*
*/

component output="false" accessors="true" {

	// Injected properties (DI)
	property name="Wirebox" inject="wirebox";
	property name="Util" inject="Util@commandbox-mongodb";

	// Local properties
	property name="MongoDatabase" type="any" default="";
	property name="Collections" type="struct" setter="false";

	public function init(){
		// Initialize default complex properties
		variables["Collections"]={};

		return this;
	}



	/**
	* Returns current database name
	*/
	public string function getName() {
		return getMongoDatabase().getName();
	}



	/**
	* Drops current database
	*/
	public void function drop() {
		getMongoDatabase().drop();
	}



	/**
	* Creates new collection
	* <TODO> Add CreateCollectionOptions support
	*/
	public void function createCollection(required string collectionName) {
		getMongoDatabase().createCollection(javacast("string", arguments.collectionName));
	}



	/**
	* Gets MongoCollection wrapper object
	*/
	public any function getCollection(required string collectionName) {
		var collections=getCollections();
		var collection="";

		if(structKeyExists(collections, arguments.collectionName)){
			collection=collections[arguments.collectionName];
		}
		else{
			collection=getWirebox().getInstance("MongoCollection@commandbox-mongodb");
			var mongoCollection=getMongoDatabase().getCollection(javacast("string", arguments.collectionName));
			collection.setMongoCollection(mongoCollection);
			collections[arguments.collectionName]=collection;
		}

		return collection;
	}




	public any function runCommand(required struct command) {
		var commandDocument=getUtil().toBsonDocument(arguments.command);
		var result=getMongoDatabase().runCommand(commandDocument);
		
		return getUtil().toCF(result);
	}
}
