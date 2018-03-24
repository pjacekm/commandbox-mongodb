/**
*
* @author pjacekm@gmail.com
* @description 
*
*/

component output="false" extends="MongoIterable" accessors="true" {
	public ListIndexesIterable function batchSize(required numeric batchSize) {
		getMongoIterable().batchSize(javacast("int", arguments.batchSize));
		return this;
	}




	/**
	* Sets the maximum execution time on the server for this operation.
	* @timeUnit literal constant name, as described in https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/TimeUnit.html?is-external=true
	*/
	public ListIndexesIterable function maxTime(required numeric maxTime, required string timeUnit) {
		var tuObj=getFactory().getObject("java.util.concurrent.TimeUnit");
		var tu=tuObj[arguments.timeUnit];
		getMongoIterable().maxTime(javacast("long", arguments.maxTime), tu);
		return this;
	}
}
