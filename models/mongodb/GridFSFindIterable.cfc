/**
*
* @author 
* @description 
*
*/

component output="false" extends="MongoIterable" accessors="true" {
	public GridFSFindIterable function batchSize(required numeric batchSize) {
		getMongoIterable().batchSize(javacast("int", arguments.batchSize));
		return this;
	}




	public GridFSFindIterable function filter(required struct filter) {
		getMongoIterable().filter(
			getUtil().toBsonDocument(arguments.filter)
		);
		return this;
	}



	/**
	* Sets the maximum execution time on the server for this operation.
	* @timeUnit literal constant name, as described in https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/TimeUnit.html?is-external=true
	*/
	public GridFSFindIterable function maxTime(required numeric maxTime, required string timeUnit) {
		var tuObj=getFactory().getObject("java.util.concurrent.TimeUnit");
		var tu=tuObj[uCase(arguments.timeUnit)];
		getMongoIterable().maxTime(javacast("long", arguments.maxTime), tu);
		return this;
	}




	public GridFSFindIterable function noCursorTimeout(required boolean noCursorTimeout) {
		getMongoIterable().noCursorTimeout(javacast("boolean", arguments.noCursorTimeout));
		return this;
	}




	public GridFSFindIterable function limit(required numeric limit) {
		getMongoIterable().limit(javacast("int", arguments.limit));
		return this;
	}




	public GridFSFindIterable function skip(required numeric skip) {
		getMongoIterable().skip(javacast("int", arguments.skip));
		return this;
	}




	public GridFSFindIterable function sort(required struct sort) {
		getMongoIterable().sort(
			getUtil().toBsonDocument(arguments.sort)
		);
		return this;
	}
}
