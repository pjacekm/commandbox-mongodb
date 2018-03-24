/**
*
* @author pjacekm@gmail.com
* @description Uses JavaLoader to initialize MongoDB Java Driver classes. Given that all java classes must be delivered by the same JavaLoader instance (ClassLoader), this component should be instantiated as a singleton (see https://github.com/markmandel/JavaLoader/wiki/Switching-the-ThreadContextClassLoader)
*
*/

component output="false" accessors="true" singleton {

	// Injected properties (DI)
	property name="Wirebox" inject="wirebox";
	property name="ModuleSettings" inject="commandbox:moduleSettings:commandbox-mongodb";
	
	// Local properties
	property name="JavaLoader" default="";

	public function init(){
		return this;
	}




	public function onDIComplete() {
		initializeJavaLoader();

		return this;
	}




	public function initializeJavaLoader() {
		var javaLoader=getWirebox().getInstance("JavaLoader@commandbox-mongodb");
		var libPaths=getModuleSettings()["libPaths"];
		var jars=[];
		var dirList=[];
		var pidx="";
		var didx="";
		
		cfloop(array="#libPaths#" item="pidx"){
			var dirList=directoryList( expandPath(pidx), false, "path", "*.jar" );
			if(arrayLen(dirList)){
				cfloop(array="#dirList#", item="didx"){
					arrayAppend(jars, didx);
				}
			}
		}

		javaLoader.init(
			loadPaths=jars
		);

		setJavaLoader(javaLoader);
	}




	public function getObject(required string className) {
		return getJavaLoader().create(arguments.className);
	}




	
}
