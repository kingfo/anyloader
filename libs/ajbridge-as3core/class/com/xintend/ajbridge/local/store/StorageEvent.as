package com.xintend.ajbridge.local.store {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public class StorageEvent extends Event {
		
		public static const CREATE: String = "create";
		public static const STORAGE: String = "storage";
		public static const STATUS: String = "status";
		public static const PENDING: String = "pending";
		public static const CLEAR: String = "clear";
		public static const SHOW_SETTINGS: String = "showSettings";
		public static const ERROR: String = "error";
		public static const OPEN: String = "open";
		public static const CLOSE: String = "close";
		public static const CHECKOUT: String = "checkout";
		public static const DESTROY: String = "destroy";
		
		public function get key():String { return _key; }
		
		public function get message():* { return _message; }
		
		public function get oldValue():String { return _oldValue; }
		
		public function get newValue():String { return _newValue; }
		
		public function StorageEvent(type: String, 
									message: * = null,
									key: String = null,
									oldValue:*= null,
									newValue:*= null,
									bubbles: Boolean = false, 
									cancelable: Boolean = true) { 
			super(type, bubbles, cancelable);
			
			_key = key;
			_message = message;
			_oldValue = oldValue;
			_newValue = newValue;
		} 
		
		public override function clone():Event { 
			return new StorageEvent(type,message,key,oldValue,newValue,bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("StorageEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		private var _key: String;
		private var _message: *;
		private var _oldValue: String;
		private var _newValue: String;
	}
	
}