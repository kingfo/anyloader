package com.xintend.trine.ajbridge {
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	import org.flashdevelop.utils.FlashConnect;
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public class AJBridge {
		
		
		public static var swfID: String;
		
		public static var jsEntry: String;
		
		public function AJBridge() {
			
		}
		
		static public function init(stage: Stage): void {
			var flashvars: Object;
			flashvars = stage.loaderInfo.parameters;
			/**
			 * JS入口，作为总体回调的入口
			 * 默认命名为 bridgeCallback
			 * 当然开放给第三方使用，可自定义此入口
			 */
			jsEntry = flashvars[JS_ENTRY_KEY];
			jsEntry = jsEntry == null || jsEntry == "" ? "ajbCallback" : jsEntry;
			/**
			 * 此处在页面中添加SWF HTML 容器元素 ID 要保持 一致
			 * 在没有指定 SWFID情况下  会失效
			 * 由于双<object/>模式兼容性问题，强烈建议保持此属性
			*/
			try {
				swfID = flashvars[SWF_ID_KEY] || ExternalInterface.objectID || "mySWF";
			}catch (e: Error) {
				FlashConnect.atrace("com.xintend.trine.ajbridge::init",e,e.message,e.name,e.errorID);
			}
			
			sendEvent({type:"init"});
			
			
			addCallbacks( { 
							activate: activate,
							getReady:function ():String { return isReady; }
							} );
			//addCallback("activate",activate);
			//addCallback("getReady", function ():String { return isReady; } );
		}
		
		
		static public function addCallback(name: String, func: Function) : void {
			try {
				if (ExternalInterface.available) {
					ExternalInterface.addCallback(name, func);
					sendEvent({type:"addCallback"});
				}else {
					FlashConnect.atrace("com.xintend.trine.ajbridge::addCallback","ExternalInterface:disable");
				}
			}catch (e: Error) {
				FlashConnect.atrace("com.xintend.trine.ajbridge::addCallback",e,e.message,e.name,e.errorID);
			}
			
		}
		
		static public function addCallbacks(callbacks: Object) : void {
			var func: Function;
			try {
				if (ExternalInterface.available) {
					for (var callback: String in callbacks) {
						func = callbacks[callback] as Function;
						if (func == null) continue;
						ExternalInterface.addCallback(callback, func);
					}
					sendEvent({type:"addCallbacks"});
				}else {
					FlashConnect.atrace("com.xintend.trine.ajbridge::addCallbacks","ExternalInterface:disable");
				}
			}catch (e: Error) {
				FlashConnect.atrace("com.xintend.trine.ajbridge::addCallbacks",e,e.message,e.name,e.errorID);
			}
		}
		
		static public function  ready(): void {
			sendEvent({type:"swfReady"});
		}
		
		static public function sendEvent(evt: Object): void {
			
			
			if (jsEntry == null || jsEntry == "" || swfID == null || swfID == "") {
				throw new Error("未初始化AJBridge,请在执行前调用AJBridge.init();");
			}
			////	对象深拷贝
			////	不适合显示对象
			//var r: ByteArray = new ByteArray();
			//r.writeObject(evt);
			//r.position = 0;
			//evt = r.readObject();
			try {
				if (ExternalInterface.available) {
					ExternalInterface.call(jsEntry,swfID,evt);
				}
			}catch (e: Error) {
				FlashConnect.atrace("com.xintend.trine.ajbridge::sendEvent",e,e.message,e.name,e.errorID,evt);
			}
		}
		static public function log(...args): void {
			sendEvent( { type: 'log', data: args } );
		}
		
		static private function activate(config: Object = null): void {
			if (config) {
				jsEntry = config.jsEntry || jsEntry;
				swfID = config.swfID || swfID;
			}
			ready();
		}
		
		
		
			
		
		private static var isReady: String = "ready";
		
		private static const JS_ENTRY_KEY: String = "jsEntry";
		private static const SWF_ID_KEY: String = "swfID";
		
	}

}