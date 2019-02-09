/**
*
* @author pjacekm@gmail.com
* @description 
*
*/

component output="false" {

	// Module properties
	this.autoMapModels = true;

	function configure(){
		"settings"={
			"libPaths": [
				"/commandbox-mongodb/lib/"
			],
			"mongoDriverVersion": "3.8.1"
		};
	}
}
