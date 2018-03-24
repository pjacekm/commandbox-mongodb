/**
*
* @author 
* @description 
*
*/

component output="false" extends="MongoIterable" accessors="true" {
	/**
	* Specify the MapReduceAction to be used when writing to a collection.
	*/
	public MapReduceIterable function action(required string action) {
		var mrObj=getFactory().getObject("com.mongodb.client.MapReduceIterable");
		var mr=mrObj[uCase(arguments.action)]; // Currently supported: MERGE, REDUCE, REPLACE
		getMongoIterable().action(mr);
		return this;
	}



	/**
	* Sets the number of documents to return per batch.
	*/
	public MapReduceIterable function batchSize(required numeric batchSize) {
		getMongoIterable().batchSize(javacast("int", arguments.batchSize));
		return this;
	}



	/**
	* Sets the bypass document level validation flag.
	*/
	public MapReduceIterable function bypassDocumentValidation(required boolean bypassDocumentValidation) {
		getMongoIterable().bypassDocumentValidation(javacast("boolean", arguments.bypassDocumentValidation));
		return this;
	}



	/**
	* Sets the collectionName for the output of the MapReduce
	*/
	public MapReduceIterable function collectionName(required string collectionName) {
		getMongoIterable().collectionName(javacast("string", arguments.collectionName));
		return this;
	}



	/**
	* Sets the name of the database to output into.
	*/
	public MapReduceIterable function databaseName(required string databaseName) {
		getMongoIterable().databaseName(javacast("string", arguments.databaseName));
		return this;
	}



	/**
	* Sets the query filter to apply to the query.
	*/
	public MapReduceIterable function filter(required struct filter) {
		getMongoIterable().filter(
			getUtil().toBsonDocument(arguments.filter)
		);
		return this;
	}



	/**
	* Sets the JavaScript function that follows the reduce method and modifies the output.
	*/
	public MapReduceIterable function finalizeFunction(required string finalizeFunction) {
		getMongoIterable().finalizeFunction(javacast("string", arguments.finalizeFunction));
		return this;
	}



	/**
	* Sets the flag that specifies whether to convert intermediate data into BSON format between the execution of the map and reduce functions.
	*/
	public MapReduceIterable function jsMode(required boolean jsMode) {
		getMongoIterable().jsMode(javacast("boolean", arguments.jsMode));
		return this;
	}



	/**
	* Sets the limit to apply.
	*/
	public MapReduceIterable function limit(required numeric limit) {
		getMongoIterable().limit(javacast("int", arguments.limit));
		return this;
	}




	/**
	* Sets the maximum execution time on the server for this operation.
	* @timeUnit literal constant name, as described in https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/TimeUnit.html?is-external=true
	*/
	public MapReduceIterable function maxTime(required numeric maxTime, required string timeUnit) {
		var tuObj=getFactory().getObject("java.util.concurrent.TimeUnit");
		var tu=tuObj[uCase(arguments.timeUnit)];
		getMongoIterable().maxTime(javacast("long", arguments.maxTime), tu);
		return this;
	}



	/**
	* Sets if the post-processing step will prevent MongoDB from locking the database.
	*/
	public MapReduceIterable function nonAtomic(required boolean nonAtomic) {
		getMongoIterable().nonAtomic(javacast("boolean", arguments.nonAtomic));
		return this;
	}



	/**
	* Sets the global variables that are accessible in the map, reduce and finalize functions.
	*/
	public MapReduceIterable function scope(required struct scope) {
		getMongoIterable().scope(
			getUtil().toBsonDocument(arguments.scope)
		);
		return this;
	}



	/**
	* Sets if the output database is sharded
	*/
	public MapReduceIterable function sharded(required boolean sharded) {
		getMongoIterable().sharded(javacast("boolean", arguments.sharded));
		return this;
	}



	/**
	* Sets the sort criteria to apply to the query.
	*/
	public MapReduceIterable function sort(required struct sort) {
		getMongoIterable().sort(
			getUtil().toBsonDocument(arguments.sort)
		);
		return this;
	}



	/**
	* Sets whether to include the timing information in the result information.
	*/
	public MapReduceIterable function verbose(required boolean verbose) {
		getMongoIterable().verbose(javacast("boolean", arguments.verbose));
		return this;
	}
}
