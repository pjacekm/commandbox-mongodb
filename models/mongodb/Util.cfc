/**
*
* @author pjacekm@gmail.com
* @description 
*
*/

component output="false" accessors="true" {

	// Injected properties (DI)
	property name="Factory" inject="Factory@commandbox-mongodb";
	property name="Shell" inject="Shell";

	// Local properties
	property name="NullSupport" type="boolean" default="false"; // For future use

	public function init(){
		return this;
	}




	public void function printDumpToConsole(dumpData) {
		getShell().printString(
			arguments.dumpData
		);
	}



	/**
	* Converts query struct or pipeline array to MongoDB BsonDocument format. 
	* Not compatible with older MongoDB versions that still use DBObject 
	* (see https://stackoverflow.com/a/29758237/2131787 for more insight). 
	* 
	* Use plain JSON notation for complex data and objects in queries, e.g.
	* 	{"_id":{"$oid":"5917654b4420c216dd1bd0dd"}} for specifying _id in search criteria, 
	* 	or: {"field":{"$regex": "^value$", "$options": "i"}} for case-insensitive searches.
	*/
	function toBsonDocument(required any data){
		if(isObject(arguments.data)){
			return arguments.data;
		}
		else if(isArray(arguments.data)){
			var javaArrayList = getFactory().getObject("java.util.ArrayList");

			for(var i in arguments.data){
				javaArrayList.add(toBsonDocument(i));
			}

			return javaArrayList;
			
		}
		else {
			var doc = getFactory().getObject("org.bson.BsonDocument");
			return doc.parse(serializeJSON(arguments.data));
		}
	}




	function toDocument(required any data){
		if(isObject(arguments.data)){
			return arguments.data;
		}
		else if(isArray(arguments.data)){
			var list = getFactory().getObject("java.util.ArrayList");

			for(var i in arguments.data){
				list.add(toDocument(i));
			}

			return list;
			
		}
		else {
			var doc = getFactory().getObject("org.bson.Document");
			return doc.init(arguments.data);
		}
	}




	public any function ObjectId(string _id="") {
		if(len(arguments._id)){
			return getFactory().getObject("org.bson.types.ObjectId").init(arguments._id);
		}
		else{
			return getFactory().getObject("org.bson.types.ObjectId").init();
		}
	}




	function isObjectId(required string id){
		return getFactory().getObject("org.bson.types.ObjectId").isValid(arguments.id);
	}




	function isObjectIdString(required string sId){

		return (
			isSimpleValue(sId) 
			&& 
			!isNumeric(sId)
			&&
			left(trim(sId),1) != '$'
			&&
			arrayLen(sId.getBytes("UTF-8")) == 24
		);
	}




	/**
	* Returns the results of a MongoIterable object as an array of documents
	*/
	function mongoIterableToArray(required any mongoIterable){
		var aResults = [];
		var cursor = mongoIterable.iterator();
		
		while(cursor.hasNext()){
			var nextResult = cursor.next();
			
			if(isObject(nextResult)){
				switch(getMetadata(nextResult).getCanonicalName()){
					case "org.bson.BsonString":
						nextResult=nextResult.asString().getValue();
					break;

					case "com.mongodb.client.gridfs.model.GridFSFile":
						nextResult={
							"hashCode":nextResult.hashCode(),
							"length":nextResult.getLength(),
							"_id":nextResult.getObjectId(),
							"uploadDate":nextResult.getUploadDate(),
							"fileName":nextResult.getFilename(),
							"metadata":nextResult.getMetadata(),
							"chunkSize":nextResult.getChunkSize(),
							"md5":nextResult.getMD5()
						};
					break;
				
					default:
						throw(type = "commandbox-mongodb.unsupportedObjectTypeException", message = "Support for object '#getMetadata(nextResult).getCanonicalName()#' has not yet been implemented in commandbox-mongodb", detail="");
					break;
				}
			}
			
			arrayAppend(aResults, nextResult);
		}

		cursor.close();

		return toCF(aResults);
	}




	/**
	* Converts a Mongo DBObject to a ColdFusion structure
	*/
	function toCF(required any BasicDBObject){
		if(isNull(BasicDBObject)) return;
		
		//if we're in a loop iteration and the array item is simple, return it
		if(isSimpleValue(BasicDBObject)) return BasicDbObject;

		if(isArray(BasicDBObject)){
			var cfObj = [];
			for(var obj in BasicDBObject){
				arrayAppend(cfObj, toCF(obj));
			}
		}
		else {
			var cfObj = {};

			try{
				cfObj.putAll(BasicDBObject);
			}
			catch (any e){
				if(getMetaData(BasicDBObject).getName() == 'org.bson.BsonUndefined') return javacast("null", "");

				return BasicDBObject;
			}
			//loop our keys to ensure first-level items with sub-documents objects are converted
			for(var key in cfObj){
				if(!isNull(cfObj[key]) && ( isArray(cfObj[key]) || isStruct(cfObj[key]) ) ) cfObj[key] = toCF(cfObj[key]);
			}
		}

		//auto-stringify _id 
		if(isStruct(cfObj) && structKeyExists(cfObj,'_id') && !isSimpleValue(cfObj['_id'])){
			cfObj['_id'] = cfObj['_id'].toString();
		} 

		return cfObj;
	}
}
