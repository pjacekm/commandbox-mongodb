/**
*
* @author pjacekm@gmail.com
* @description 
*
*/

component output="false" extends="MongoIterable" accessors="true" {
	public AggregateIterable function allowDiskUse(required boolean allowDiskUse) {
		getMongoIterable().allowDiskUse(
			javacast("boolean", arguments.allowDiskUse)
		);
		return this;
	}




	public AggregateIterable function batchSize(required numeric batchSize) {
		getMongoIterable().batchSize(
			javacast("int", arguments.batchSize)
		);
		return this;
	}




	public AggregateIterable function bypassDocumentValidation(required boolean bypassDocumentValidation) {
		getMongoIterable().bypassDocumentValidation(
			javacast("boolean", arguments.bypassDocumentValidation)
		);
		return this;
	}



	/**
	* Sets the comment to the aggregation
	*/
	public AggregateIterable function comment(required string comment) {
		getMongoIterable().comment(
			javacast("string", arguments.comment)
		);
		return this;
	}



	/**
	* Sets the maximum execution time on the server for this operation.
	* @timeUnit literal constant name, as described in https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/TimeUnit.html?is-external=true
	*/
	public AggregateIterable function maxTime(required numeric maxTime, required string timeUnit) {
		var tuObj=getFactory().getObject("java.util.concurrent.TimeUnit");
		var tu=tuObj[arguments.timeUnit];
		getMongoIterable().maxTime(javacast("long", arguments.maxTime), tu);
		return this;
	}




	public AggregateIterable function useCursor(required boolean useCursor) {
		getMongoIterable().useCursor(javacast("boolean", arguments.useCursor));
		return this;
	}
}
