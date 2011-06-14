package com.xintend.ajbridge.core {
	import com.xintend.events.RichEvent;
	import com.xintend.javascript.ExternalInterfaceWarp;
	import com.xintend.utils.isEmptyString;
	import com.xintend.utils.isPlainObject;
	import flash.events.EventDispatcher;
	/**
	 * Actionscript3 and javascript bridge
	 * 推荐和 com.xintend.display.Spirit 一起使用，从而达到最佳效果。
	 * @author Kingfo[Telds longzang]
	 */
	public class AJBridge extends EventDispatcher implements IAJBridge {
		
		
		public static const VERSION: String = "2.0.0";
		
		/**
		 * AJBridge 初始化
		 */
		public static const INIT: String = "as3Init";
		/**
		 * AJBridge 添加方法。
		 */
		public static const ADD_CALLBACK: String = "addCallback";
		/**
		 * swf 准备完毕
		 */
		public static const SWF_READY: String = "swfReady";
		/**
		 * 内容完成时作为标准事件抛出
		 * 关键事件
		 */
		public static const CONTENT_READY: String = "contentReady";
		/**
		 * 获取 bridge 实例
		 */
		static public function get bridge():IAJBridge { return instance||=new AJBridge(); }
		/**
		 * 向外部通讯的接口。
		 * 默认是 callback
		 */
		public function get entry():String { return _entry; }
		/**
		 * 本身所在元素 id
		 */
		public function get id():String { return _id; }
		/**
		 * 部署标记位
		 */
		public function get hasDeploy(): Boolean { return _hasDeploy; }
		
		/**
		 * as3core 的 AJBridge 版本号
		 * @return
		 */
		public function getCoreVersion(): String { return VERSION; }
			
		
		/**
		 * 构造函数，请通过  AJBridge.bridge 获得 AJBridge实例
		 */
		public function AJBridge() {
			if (instance) throw Error("singleton class!");
			instance = this;
		}
		
		/**
		 * 配置部署 AJBridge
		 * @param	flashvars					向SWF传递的参数。推荐通过 stage.loaderInfo.parameters 方式获取
		 */
		public function deploy(flashvars: Object): void {
			var richEvent: RichEvent;
			
			// 1.尝试开启 marshallExceptions
			ExternalInterfaceWarp.marshallExceptions = true;
			
			// 2.部署配置
			_entry = flashvars["jsEntry"] || DEFAULT_JS_ENTRY;
			_id = flashvars["swfID"] || ExternalInterfaceWarp.objectID || NO_SWF_ID;
			_hasDeploy = true;
			
			// 3.添加内建接口
			addCallback(
						"activate", activate,
						"getReady", getReady,
						"getCoreVersion",getCoreVersion
						);
						
			// 4.抛出初始化完成事件			
			richEvent = new RichEvent(INIT, false, true, { entry: entry, id: id } );
			dispatchEvent(richEvent);
			sendEvent(richEvent);

			
		}
		
		/**
		 * 添加回调
		 * 支持基本的的 name-function 添加 和 name-function hash对象
		 * @example
		 * <pre>
		 * // name-function 方式
		 * addCallback(
						"activate", activate,
						"getReady", getReady,
						"getCoreVersion",getCoreVersion
						);
		 * </pre>
		 * <pre>
		 * // name-function 对象
		 * var callbaks:Object = {"activate": activate,
								"getReady": getReady,
								"getCoreVersion":getCoreVersion};
			//some code...
		 * addCallback(callbaks);
		 * </pre>
		 * @param	...args
		 */
		public function addCallback(...args): void {
			if (!hasDeploy) throw new Error("deploy it first!");
			if (args.length === 0) return;
			var len: int = args.length;
			var richEvent: RichEvent;
			var name: String;
			var func: Function;
			var funcList: Array = [];
			var callbacks: * ;
			var a: Array;
			
			if (len == 1) { // name-function hash对象
				callbacks = args[0];
				if (!isPlainObject(callbacks)) return ;
				for (name in callbacks) {
					func = callbacks[name] as Function;
					if (func == null) continue;
					funcList.push(name);
					ExternalInterfaceWarp.addCallback(name, func);
				}
				
			}else if (len > 1) { // name-function
				a = args.concat();
				while (a.length) {
					callbacks = a.splice(0, 2);
					name = callbacks[0];
					if (isEmptyString(name)) continue;
					func = callbacks[1] as Function;
					if (func == null) continue;
					funcList.push(name);
					ExternalInterfaceWarp.addCallback(name, func);
				}
			}
			richEvent = new RichEvent(ADD_CALLBACK, false, true, { entry: entry, id: id, funcList: funcList } );
			dispatchEvent(richEvent);
			sendEvent(richEvent);
		}
		/**
		 * 向外部发送自定义事件
		 * @param	event
		 */
		public function sendEvent(event: Object): void {
			if (!hasDeploy) throw new Error("deploy it first!");
			if (_entry == null || _entry == "" || _id == null || _id == "" || _id == NO_SWF_ID) {
				trace( "WARNING:The event [" + event.type + "] cannot be sended to js " + "without js entry or swf object id.");
				return;
			}
			if (ExternalInterfaceWarp.available) {
				ExternalInterfaceWarp.call(_entry,_id,event);
			}
		}
		/**
		 * 
		 * 也可用于静态发布 swf 方式的激活
		 * @param	config
		 */
		public function activate(config: Object = null): void {
			if (!hasDeploy) throw new Error("deploy it first!");
			var richEvent: RichEvent;
			if (config) {
				_entry = config.jsEntry || _entry;
				_id = config.swfID || _id;
			}
			richEvent = new RichEvent(SWF_READY, false, true, { entry: entry, id: id });
			dispatchEvent(richEvent);
			sendEvent(richEvent);
		}
		
		/**
		 * 恒等于  ready  用于外部检测
		 * @return
		 */
		public function getReady(): String {
			return "ready";
		}
		
		
		private var _entry: String;
		private var _id: String;
		private var _hasDeploy: Boolean;
		
		
		private static const NO_SWF_ID: String = "noSWFID";
		private static const DEFAULT_JS_ENTRY: String = "callback";
		
		protected static var instance: IAJBridge;
	}

}