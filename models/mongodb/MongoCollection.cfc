/**
*
* @author pjacekm@gmail.com
* @description 
*
*/

component output="false" accessors="true" {

	// Injected properties (DI)
	property name="Util" inject="Util@commandbox-mongodb";
	property name="Wirebox" inject="wirebox";

	// Local properties
	property name="MongoCollection" type="any" default="";


	public function init(){
		return this;
	}




	public AggregateIterable function aggregate(required array pipeline) {
		var aggregateIterable=wirebox.getInstance("AggregateIterable@commandbox-mongodb");

		var filter=getUtil().toBsonDocument(arguments.pipeline);
		var result=getMongoCollection().aggregate(filter);

		aggregateIterable.setMongoIterable(result);

		return aggregateIterable;
	}




	public any function bulkWrite(required array requests, struct options={}) {
		// <TODO> Implement this method
		throw(type = "commandbox-mongodb.notImplementedException", message = "Method 'bulkWrite()' is not yet implemented.", detail="");
	}




	public numeric function count(struct query={}) {
		var filter=getUtil().toBsonDocument(arguments.query);
		return getMongoCollection().count(filter);
	}




	public string function createIndex(required struct keys, struct options={}) {
		var keysObj=getUtil().toBsonDocument(arguments.keys);
		var factory=wirebox.getInstance("Factory@commandbox-mongodb");
		var indexOptions=factory.getObject("com.mongodb.client.model.IndexOptions");

		for(var i in arguments.options){
			switch(i){
				case "background":
					indexOptions.background(javacast("boolean", arguments.options[i]));
				break;

				case "bits":
					indexOptions.bits(javacast("int", arguments.options[i]));
				break;

				case "bucketSize":
					indexOptions.bucketSize(javacast("double", arguments.options[i]));
				break;

				case "defaultLanguage":
					indexOptions.defaultLanguage(javacast("string", arguments.options[i]));
				break;

				case "expireAfter":
					var tuObj=factory.getObject("java.util.concurrent.TimeUnit");
					var tu=tuObj[arguments.options[i]["timeUnit"]];
					indexOptions.expireAfter(javacast("long", arguments.options[i]["expireAfter"]), tu);
				break;

				case "languageOverride":
					indexOptions.languageOverride(javacast("string", arguments.options[i]));
				break;

				case "max":
					indexOptions.max(javacast("double", arguments.options[i]));
				break;

				case "min":
					indexOptions.min(javacast("double", arguments.options[i]));
				break;

				case "name":
					indexOptions.name(javacast("string", arguments.options[i]));
				break;

				case "partialFilterExpression":
					var filter=getUtil().toBsonDocument(arguments.options[i]);
					indexOptions.partialFilterExpression(filter);
				break;

				case "sparse":
					indexOptions.sparse(javacast("boolean", arguments.options[i]));
				break;

				case "sphereVersion":
					indexOptions.sphereVersion(javacast("int", arguments.options[i]));
				break;

				case "storageEngine":
					var filter=getUtil().toBsonDocument(arguments.options[i]);
					indexOptions.storageEngine(filter);
				break;

				case "textVersion":
					indexOptions.textVersion(javacast("int", arguments.options[i]));
				break;

				case "unique":
					indexOptions.unique(javacast("boolean", arguments.options[i]));
				break;

				case "version":
					indexOptions.version(javacast("int", arguments.options[i]));
				break;

				case "weights":
					var filter=getUtil().toBsonDocument(arguments.options[i]);
					indexOptions.weights(filter);
				break;
			
				default:
					throw(type = "commandbox-mongodb.optionNotImplementedException", message = "Option not implemented", detail="");
				break;
			}
		}

		return getMongoCollection().createIndex(keysObj, indexOptions);
	}




	public array function createIndexes(required array indexes) {
		var response=[];

		for(var i in arguments.indexes){
			arrayAppend(response, createIndex(argumentCollection=i));
		}

		return response;
	}




	public DeleteResult function deleteMany(struct filter={}) {
		var deleteResult=wirebox.getInstance("DeleteResult@commandbox-mongodb");

		var query=getUtil().toBsonDocument(arguments.filter);
		var result=getMongoCollection().deleteMany(query);

		deleteResult.setMongoDeleteResult(result);

		return deleteResult;
	}




	public DeleteResult function deleteOne(struct filter={}) {
		var deleteResult=wirebox.getInstance("DeleteResult@commandbox-mongodb");

		var query=getUtil().toBsonDocument(arguments.filter);
		var result=getMongoCollection().deleteMany(query);

		deleteResult.setMongoDeleteResult(result);

		return deleteResult;
	}




	public DistinctIterable function distinct(required string fieldName, struct filter={}) {
		var distinctIterable=wirebox.getInstance("DistinctIterable@commandbox-mongodb");
		var factory=wirebox.getInstance("Factory@commandbox-mongodb");
		var query=getUtil().toBsonDocument(arguments.filter);

		var result=getMongoCollection().distinct(
			javacast("string", arguments.fieldName), 
			query, 
			factory.getObject("org.bson.BsonValue").getClass()
		);

		distinctIterable.setMongoIterable(result);

		return distinctIterable;
	}




	public void function drop() {
		getMongoCollection().drop();
	}




	public void function dropIndex(required string indexName) {
		getMongoCollection().dropIndex(javacast("string", arguments.indexName));
	}



	/**
	* Drop all the indexes on this collection, except for the default on _id.
	*/
	public void function dropIndexes() {
		getMongoCollection().dropIndexes();
	}




	public FindIterable function find(struct filter={}) {
		var findIterable=wirebox.getInstance("FindIterable@commandbox-mongodb");

		var query=getUtil().toBsonDocument(arguments.filter);
		var result=getMongoCollection().find(query);

		findIterable.setMongoIterable(result);

		return findIterable;
	}




	public struct function findOneAndDelete(struct filter={}, struct options={}) {
		var filter=getUtil().toBsonDocument(arguments.filter);
		var factory=wirebox.getInstance("Factory@commandbox-mongodb");
		var findOneAndDeleteOptions=factory.getObject("com.mongodb.client.model.FindOneAndDeleteOptions");

		for(var i in arguments.options){
			switch(i){
				case "maxTime":
					var tuObj=factory.getObject("java.util.concurrent.TimeUnit");
					var tu=tuObj[arguments.options[i]["timeUnit"]];
					findOneAndDeleteOptions.maxTime(javacast("long", arguments.options[i]["maxTime"]), tu);
				break;

				case "projection":
					var filter=getUtil().toBsonDocument(arguments.options[i]);
					findOneAndDeleteOptions.projection(filter);
				break;

				case "sort":
					var filter=getUtil().toBsonDocument(arguments.options[i]);
					findOneAndDeleteOptions.sort(filter);
				break;
			
				default:
					throw(type = "commandbox-mongodb.optionNotImplementedException", message = "Option not implemented", detail="");
				break;
			}
		}

		var result=getMongoCollection().findOneAndDelete(filter, findOneAndDeleteOptions);
		
		if(isNull(result)){
			throw(type = "commandbox-mongodb.documentNotFoundException", message = "Document not found", detail="");
		}

		return getUtil().toCF(result);
	}




	public struct function findOneAndReplace(struct filter={}, struct replacement={}, struct options={}) {
		var filter=getUtil().toBsonDocument(arguments.filter);
		var factory=wirebox.getInstance("Factory@commandbox-mongodb");
		var findOneAndReplaceOptions=factory.getObject("com.mongodb.client.model.FindOneAndReplaceOptions");
		var replaceDocument=getUtil().toBsonDocument(arguments.replacement);

		for(var i in arguments.options){
			switch(i){
				case "bypassDocumentValidation":
					findOneAndReplaceOptions.bypassDocumentValidation(javacast("boolean", arguments.options[i]));
				break;

				case "maxTime":
					var tuObj=factory.getObject("java.util.concurrent.TimeUnit");
					var tu=tuObj[arguments.options[i]["timeUnit"]];
					findOneAndReplaceOptions.maxTime(javacast("long", arguments.options[i]["maxTime"]), tu);
				break;

				case "projection":
					var filter=getUtil().toBsonDocument(arguments.options[i]);
					findOneAndReplaceOptions.projection(filter);
				break;

				case "returnDocument":
					// Two values currently supported: BEFORE, AFTER. Default driver value: BEFORE.
					var returnDocument=factory.getObject("com.mongodb.client.model.ReturnDocument");
					findOneAndReplaceOptions.returnDocument(returnDocument[uCase(arguments.options[i])]);
				break;

				case "sort":
					var filter=getUtil().toBsonDocument(arguments.options[i]);
					findOneAndReplaceOptions.sort(filter);
				break;

				case "upsert":
					findOneAndReplaceOptions.upsert(javacast("boolean", arguments.options[i]));
				break;
			
				default:
					throw(type = "commandbox-mongodb.optionNotImplementedException", message = "Option not implemented", detail="");
				break;
			}
		}

		var result=getMongoCollection().findOneAndReplace(filter, replaceDocument, findOneAndReplaceOptions);
		
		if(isNull(result)){
			throw(type = "commandbox-mongodb.documentNotFoundException", message = "Document not found", detail="");
		}

		return getUtil().toCF(result);
	}




	public struct function findOneAndUpdate(struct filter={}, struct update={}, struct options={}) {
		var filter=getUtil().toBsonDocument(arguments.filter);
		var factory=wirebox.getInstance("Factory@commandbox-mongodb");
		var findOneAndUpdateOptions=factory.getObject("com.mongodb.client.model.FindOneAndUpdateOptions");
		var updateDocument=getUtil().toBsonDocument(arguments.update);

		for(var i in arguments.options){
			switch(i){
				case "bypassDocumentValidation":
					findOneAndUpdateOptions.bypassDocumentValidation(javacast("boolean", arguments.options[i]));
				break;

				case "maxTime":
					var tuObj=factory.getObject("java.util.concurrent.TimeUnit");
					var tu=tuObj[arguments.options[i]["timeUnit"]];
					findOneAndUpdateOptions.maxTime(javacast("long", arguments.options[i]["maxTime"]), tu);
				break;

				case "projection":
					var filter=getUtil().toBsonDocument(arguments.options[i]);
					findOneAndUpdateOptions.projection(filter);
				break;

				case "returnDocument":
					// Two values currently supported: BEFORE, AFTER. Default driver value: BEFORE.
					var returnDocument=factory.getObject("com.mongodb.client.model.ReturnDocument");
					findOneAndUpdateOptions.returnDocument(returnDocument[uCase(arguments.options[i])]);
				break;

				case "sort":
					var filter=getUtil().toBsonDocument(arguments.options[i]);
					findOneAndUpdateOptions.sort(filter);
				break;

				case "upsert":
					findOneAndUpdateOptions.upsert(javacast("boolean", arguments.options[i]));
				break;
			
				default:
					throw(type = "commandbox-mongodb.optionNotImplementedException", message = "Option not implemented", detail="");
				break;
			}
		}

		var result=getMongoCollection().findOneAndUpdate(filter, updateDocument, findOneAndUpdateOptions);
		
		if(isNull(result)){
			throw(type = "commandbox-mongodb.documentNotFoundException", message = "Document not found", detail="");
		}

		return getUtil().toCF(result);
	}




	public void function insertMany(required array documents, struct options={}) {
		var docs=getUtil().toDocument(arguments.documents);
		var factory=wirebox.getInstance("Factory@commandbox-mongodb");
		var insertManyOptions=factory.getObject("com.mongodb.client.model.InsertManyOptions");

		for(var i in arguments.options){
			switch(i){
				case "bypassDocumentValidation":
					insertManyOptions.bypassDocumentValidation(javacast("boolean", arguments.options[i]));
				break;

				case "ordered":
					insertManyOptions.ordered(javacast("boolean", arguments.options[i]));
				break;
			
				default:
					throw(type = "commandbox-mongodb.optionNotImplementedException", message = "Option not implemented", detail="");
				break;
			}
		}

		getMongoCollection().insertMany(docs, insertManyOptions);
	}




	public void function insertOne(required struct document, struct options={}) {
		var doc=getUtil().toDocument(arguments.document);
		var factory=wirebox.getInstance("Factory@commandbox-mongodb");
		var insertOneOptions=factory.getObject("com.mongodb.client.model.InsertOneOptions");

		for(var i in arguments.options){
			switch(i){
				case "bypassDocumentValidation":
					insertOneOptions.bypassDocumentValidation(javacast("boolean", arguments.options[i]));
				break;
			
				default:
					throw(type = "commandbox-mongodb.optionNotImplementedException", message = "Option not implemented", detail="");
				break;
			}
		}

		getMongoCollection().insertOne(doc, insertOneOptions);
	}




	public ListIndexesIterable function listIndexes() {
		var listIndexesIterable=wirebox.getInstance("ListIndexesIterable@commandbox-mongodb");

		var result=getMongoCollection().listIndexes();

		listIndexesIterable.setMongoIterable(result);

		return listIndexesIterable;
	}




	public MapReduceIterable function mapReduce(required string mapFunction, required string reduceFunction) {
		var mapReduceIterable=wirebox.getInstance("MapReduceIterable@commandbox-mongodb");

		var result=getMongoCollection().mapReduce(arguments.mapFunction, arguments.reduceFunction);

		mapReduceIterable.setMongoIterable(result);

		return mapReduceIterable;
	}



	/**
	* Rename the collection with oldCollectionName to the newCollectionName.
	* Full namespace (e.g. "database.collection") should be provided. Otherwise "state should be: databaseName is not empty" error will be raised by the driver.
	* https://docs.mongodb.com/manual/reference/command/renameCollection/#dbcmd.renameCollection
	*/
	public void function renameCollection(required string newCollectionNamespace, struct options={}) {
		var factory=wirebox.getInstance("Factory@commandbox-mongodb");
		var mongoNamespace=factory.getObject("com.mongodb.MongoNamespace");
		var renameCollectionOptions=factory.getObject("com.mongodb.client.model.RenameCollectionOptions");

		mongoNamespace.init(javacast("string", arguments.newCollectionNamespace));

		for(var i in arguments.options){
			switch(i){
				case "dropTarget":
					renameCollectionOptions.dropTarget(javacast("boolean", arguments.options[i]));
				break;
			
				default:
					throw(type = "commandbox-mongodb.optionNotImplementedException", message = "Option not implemented", detail="");
				break;
			}
		}

		getMongoCollection().renameCollection(mongoNamespace, renameCollectionOptions);
	}




	public UpdateResult function replaceOne(struct filter={}, struct replacement={}, struct options={}) {
		var factory=wirebox.getInstance("Factory@commandbox-mongodb");
		var updateOptions=factory.getObject("com.mongodb.client.model.UpdateOptions");
		var filter=getUtil().toBsonDocument(arguments.filter);
		var replaceDocument=getUtil().toBsonDocument(arguments.replacement);
		var updateResult=wirebox.getInstance("UpdateResult@commandbox-mongodb");

		for(var i in arguments.options){
			switch(i){
				case "bypassDocumentValidation":
					updateOptions.bypassDocumentValidation(javacast("boolean", arguments.options[i]));
				break;

				case "upsert":
					updateOptions.upsert(javacast("boolean", arguments.options[i]));
				break;
			
				default:
					throw(type = "commandbox-mongodb.optionNotImplementedException", message = "Option not implemented", detail="");
				break;
			}
		}

		var result=getMongoCollection().replaceOne(filter, replaceDocument, updateOptions);
		
		if(isNull(result)){
			throw(type = "commandbox-mongodb.documentNotFoundException", message = "Document not found", detail="");
		}

		updateResult.setUpdateResult(result);

		return updateResult;
	}




	public UpdateResult function updateMany(struct filter={}, struct replacement={}, struct options={}) {
		var factory=wirebox.getInstance("Factory@commandbox-mongodb");
		var updateOptions=factory.getObject("com.mongodb.client.model.UpdateOptions");
		var filter=getUtil().toBsonDocument(arguments.filter);
		var replaceDocument=getUtil().toBsonDocument(arguments.replacement);
		var updateResult=wirebox.getInstance("UpdateResult@commandbox-mongodb");

		for(var i in arguments.options){
			switch(i){
				case "bypassDocumentValidation":
					updateOptions.bypassDocumentValidation(javacast("boolean", arguments.options[i]));
				break;

				case "upsert":
					updateOptions.upsert(javacast("boolean", arguments.options[i]));
				break;
			
				default:
					throw(type = "commandbox-mongodb.optionNotImplementedException", message = "Option not implemented", detail="");
				break;
			}
		}

		var result=getMongoCollection().updateMany(filter, replaceDocument, updateOptions);
		
		if(isNull(result)){
			throw(type = "commandbox-mongodb.documentNotFoundException", message = "Document not found", detail="");
		}

		updateResult.setUpdateResult(result);

		return updateResult;
	}




	public UpdateResult function updateOne(struct filter={}, struct replacement={}, struct options={}) {
		var factory=wirebox.getInstance("Factory@commandbox-mongodb");
		var updateOptions=factory.getObject("com.mongodb.client.model.UpdateOptions");
		var filter=getUtil().toBsonDocument(arguments.filter);
		var replaceDocument=getUtil().toBsonDocument(arguments.replacement);
		var updateResult=wirebox.getInstance("UpdateResult@commandbox-mongodb");

		for(var i in arguments.options){
			switch(i){
				case "bypassDocumentValidation":
					updateOptions.bypassDocumentValidation(javacast("boolean", arguments.options[i]));
				break;

				case "upsert":
					updateOptions.upsert(javacast("boolean", arguments.options[i]));
				break;
			
				default:
					throw(type = "commandbox-mongodb.optionNotImplementedException", message = "Option not implemented", detail="");
				break;
			}
		}

		var result=getMongoCollection().updateOne(filter, replaceDocument, updateOptions);
		
		if(isNull(result)){
			throw(type = "commandbox-mongodb.documentNotFoundException", message = "Document not found", detail="");
		}

		updateResult.setUpdateResult(result);

		return updateResult;
	}
}
