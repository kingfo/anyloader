package com.xintend.javascript {
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public class ExternalInterfaceWarp{
		
		
		public static function get available(): Boolean { 
			try {
				return ExternalInterface.available; 
			}catch (error:Error) {
				trace("available:" + error.message);
			}
			return false;
		}
		
		public static function get objectID(): String { 
			try {
				return ExternalInterface.objectID; 
			}catch (error:Error) {
				trace("objectID:" + error.message);
			}
			return null;
		}
		
		
		public static function get marshallExceptions(): Boolean { 
			try {
				return ExternalInterface.marshallExceptions; 
			}catch (error:Error) {
				trace("geet marshallExceptions:" + error.message);
			}
			return false;
		}
		
		public static function set marshallExceptions(value:Boolean):void {
			try {
			    ExternalInterface.marshallExceptions = value; 
			}catch (error:Error) {
				trace("set marshallExceptions:" + error.message);
			}
		}
		
		public function ExternalInterfaceWarp() {
			throw new Error("static class");
		}
		
		static public function addCallback(functionName:String, closure:Function): void {
			try {
			    ExternalInterface.addCallback.call(ExternalInterface, functionName, closure);
			}catch (error:Error) {
				trace("set marshallExceptions:" + error.message);
			}
		}
		
		
		static public function call(functionName: String, ...args): * {
			var a: Array;
			a = [functionName];
			try {
			    return ExternalInterface.call.apply(ExternalInterface, a.concat(args.slice()));
			}catch (error:Error) {
				trace("set marshallExceptions:" + error.message);
			}
		}
		
	}

}