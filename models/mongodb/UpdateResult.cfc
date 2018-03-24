/**
*
* @author pjacekm@gmail.com
* @description 
*
*/

component output="false" accessors="true" {

	// Injected properties (DI)
	property name="Util" inject="Util@commandbox-mongodb";
	property name="Factory" inject="Factory@commandbox-mongodb";

	// Local properties
	property name="UpdateResult" type="any" default=""; // MongoDB UpdateResult object

	public function init(){
		return this;
	}




	public numeric function getMatchedCount() {
		return getUpdateResult().getMatchedCount();
	}




	public numeric function getModifiedCount() {
		return getUpdateResult().getModifiedCount();
	}




	public string function getUpsertedId() {
		var result=getUpdateResult().getUpsertedId();
		if(isNull(result)){
			return "";
		}
		else{
			return getUtil().toCF(result);
		}
	}




	public boolean function isModifiedCountAvailable() {
		return getUpdateResult().isModifiedCountAvailable();
	}




	public boolean function wasAcknowledged() {
		return getUpdateResult().wasAcknowledged();
	}
}
