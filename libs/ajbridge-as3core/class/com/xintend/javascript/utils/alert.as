package com.xintend.javascript.utils {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	import com.xintend.javascript.ExternalInterfaceWarp;
	
	public function alert(o:*):void {
		ExternalInterfaceWarp.call("alert",String(obj));
	}

}