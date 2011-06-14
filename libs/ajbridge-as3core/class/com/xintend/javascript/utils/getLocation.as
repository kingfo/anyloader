package com.xintend.javascript.utils {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	import com.xintend.javascript.ExternalInterfaceWarp;	
	
	public function getLocation():* {
		return ExternalInterfaceWarp.call("function (){"
										+"return document.location;"
										+"}"
										) || {};
	}
		

}