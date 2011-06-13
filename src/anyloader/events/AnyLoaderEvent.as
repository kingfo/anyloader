package anyloader.events {
	import anyloader.contents.ContentStream;
	import anyloader.decoders.IDescriber;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class AnyLoaderEvent extends Event {
		/**
		 * 每个单项开始执行
		 */
		public static const ITEM: String = "item";
		/**
		 * 每个单项完成捕获
		 */
		public static const ITEM_CAPTURE: String = "itemCapture";
		/**
		 * 每个单项完成下载
		 */
		public static const ITEM_COMPLETE: String = "itemComplete";
		/**
		 * 正在下载项取消
		 */
		public static const ITEM_CANCEL: String = "itemCancel";
		/**
		 * 非自动运行模式下全部下载完毕
		 */
		public static const FINISH: String = "finish";
		
		
		
		public function get info():* {
			return _info;
		}
		
		
		public function AnyLoaderEvent(type:String,info:*=null,bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			_info = info;
		} 
		
		public override function clone():Event { 
			return new AnyLoaderEvent(type, info, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("AnyLoaderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		private var _info: *;
		
		
		
		
		
	}
	
}