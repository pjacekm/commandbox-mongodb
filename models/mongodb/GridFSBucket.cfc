/**
*
* @author pjacekm@gmail.com
* @description 
* Note that "contentType" and "aliases" fields are deprecated in GridFS: https://jira.mongodb.org/browse/JAVA-2517
*/

component output="false" accessors="true" {

	// Injected properties (DI)
	property name="Factory" inject="Factory@commandbox-mongodb";
	property name="Util" inject="Util@commandbox-mongodb";
	property name="Wirebox" inject="wirebox";

	// Local properties
	property name="GridFSBucket" type="any" default="";

	public function init(){
		return this;
	}



	/**
	* Given a id, delete this stored file's files collection document and associated chunks from a GridFS bucket.
	*/
	public void function delete(required string id) {
		var objectId=getUtil().ObjectId(arguments.id);
		getGridFSBucket().delete(objectId);
	}



	/**
	* Simplified version of original Java method specification: uses destinationFilePath instead of OutputStream object in arguments.
	* Currently supports only retrieval by file ID. Also, "options.revision" implementation in this version of Java driver looks broken.
	*/
	public void function downloadToStream(required string id, required string destinationFilePath, struct options={}) {
		var objectId=getUtil().ObjectId(arguments.id);
		var file=getFactory().getObject("java.io.File").init(arguments.destinationFilePath);
		var fileOutputStream=getFactory().getObject("java.io.FileOutputStream").init(file);

		if(structCount(arguments.options)){
			var gridFSDownloadOptions=factory.getObject("com.mongodb.client.gridfs.model.GridFSDownloadOptions");

			for(var i in arguments.options){
				switch(i){
					case "revision":
						gridFSDownloadOptions.revision(javacast("int", arguments.options[i]));
					break;
				
					default:
						throw(type = "commandbox-mongodb.optionNotImplementedException", message = "Option not implemented", detail="");
					break;
				}
			}

			getGridFSBucket().downloadToStream(
				objectId,
				fileOutputStream,
				gridFSDownloadOptions
			);
		}
		else {
			getGridFSBucket().downloadToStream(
				objectId,
				fileOutputStream
			);
		}
		
	}



	/**
	* Drops the data associated with this bucket from the database.
	*/
	public void function drop() {
		getGridFSBucket().drop();
	}




	public GridFSFindIterable function find(struct filter={}) {
		var gridFSFindIterable=wirebox.getInstance("GridFSFindIterable@commandbox-mongodb");

		var query=getUtil().toBsonDocument(arguments.filter);
		var result=getGridFSBucket().find(query);

		gridFSFindIterable.setMongoIterable(result);

		return gridFSFindIterable;
	}




	public string function getBucketName() {
		return getGridFSBucket().getBucketName();
	}




	public numeric function getChunkSizeBytes() {
		return getGridFSBucket().getChunkSizeBytes();
	}



	/**
	* Simplified version of original Java method specification: uses sourceFilePath instead of InputStream object in arguments.
	* Returns ID of created file.
	*/
	public string function uploadFromStream(required string fileName, required string sourceFilePath, struct options={}) {
		var file=getFactory().getObject("java.io.File").init(arguments.sourceFilePath);
		var fileInputStream=getFactory().getObject("java.io.FileInputStream").init(file);
		var gridFSUploadOptions=factory.getObject("com.mongodb.client.gridfs.model.GridFSUploadOptions");

		for(var i in arguments.options){
			switch(i){
				case "chunkSizeBytes":
					gridFSUploadOptions.chunkSizeBytes(javacast("int", arguments.options[i]));
				break;

				case "metadata":
					var filter=getUtil().toDocument(arguments.options[i]);
					gridFSUploadOptions.metadata(filter);
				break;
			
				default:
					throw(type = "commandbox-mongodb.optionNotImplementedException", message = "Option not implemented", detail="");
				break;
			}
		}
		
		var objectId=getGridFSBucket().uploadFromStream(
			javacast("string", arguments.fileName),
			fileInputStream,
			gridFSUploadOptions
		);
		
		return getUtil().toCF(objectId);
	}
}
