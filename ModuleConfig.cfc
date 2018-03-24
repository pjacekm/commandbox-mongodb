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
			"hosts": [
				{
					"serverName":"127.0.0.1",
					"serverPort":"27017"
				}
			],
			"credentials": [
				/* {
					"userName":"",
					"password":"",
					"database":""
				} */
			],
			"options": {
				/* "connectTimeout":2000,
				"serverSelectionTimeout":5000 */
			},
			"databaseName": "test",
			"libPaths": [
				"/commandbox-mongodb/lib/"
			],
			"mongoDriverVersion": "3.6.3"
		};
	}
}
