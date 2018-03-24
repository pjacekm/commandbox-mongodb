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

	// Local properties
	property name="Buckets" type="struct" setter="false";

	public function init(){
		// Initialize default complex properties
		variables["Buckets"]={};
		return this;
	}




	public GridFSBucket function create(required MongoDatabase database, string bucketName="fs") {
		var buckets=getBuckets();
		var bucket="";
		
		if(structKeyExists(buckets, arguments.database.getName()) and structKeyExists(buckets[arguments.database.getName()], arguments.bucketName)){
			bucket=buckets[arguments.database.getName()][arguments.bucketName];
		}
		else{
			bucket=getWirebox().getInstance("GridFSBucket@commandbox-mongodb");
			var mongoBucket=getFactory().getObject("com.mongodb.client.gridfs.GridFSBuckets").create(
				arguments.database.getMongoDatabase(),
				javacast("string", arguments.bucketName)
			);
			bucket.setGridFSBucket(mongoBucket);
			buckets[arguments.database.getName()][arguments.bucketName]=bucket;
		}

		return bucket;
	}
}
