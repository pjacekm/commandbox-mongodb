/**
*
* @author 
* @description Encapsulates MongoDB responses
*
*/

component output="false" accessors="true" {

	// Injected properties (DI)
	property name="Util" inject="Util@commandbox-mongodb";
	property name="Factory" inject="Factory@commandbox-mongodb";

	// Local properties
	property name="MongoIterable" type="any" default="";

	public function init(){
		return this;
	}




	public function forEach(required fn) {
		return getMongoIterable().forEach(arguments.fn);
	}




	public function iterator() {
		return getMongoIterable().iterator();
	}




	public array function toArray() {
		return getUtil().mongoIterableToArray( getMongoIterable() );
	}
}
