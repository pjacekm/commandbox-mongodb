/**
*
* @author pjacekm@gmail.com
* @description 
*
*/

component output="false" accessors="true" {

	// Local properties
	property name="MongoDeleteResult" type="any" default="";

	public function init(){
		return this;
	}




	public numeric function getDeletedCount() {
		return getMongoDeleteResult().getDeletedCount();
	}




	public boolean function wasAcknowledged() {
		return getMongoDeleteResult().wasAcknowledged();
	}
}
