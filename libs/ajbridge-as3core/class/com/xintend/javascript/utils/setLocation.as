package com.xintend.javascript.utils {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	import com.xintend.javascript.ExternalInterfaceWarp;
	public function setLocation(url:String):void {
		ExternalInterfaceWarp.call("function setLocationHref(C){"
											+"document.location = C ;"
											+"}",url
											);	
	}

}