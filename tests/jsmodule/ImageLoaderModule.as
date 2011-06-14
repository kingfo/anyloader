package  {
	import anyloader.adapters.ImageLoaderJSAdapter;
	import anyloader.events.AnyLoaderEvent;
	import com.xintend.ajbridge.core.AJBridge;
	import com.xintend.ajbridge.core.IAJBridgeContent;
	import com.xintend.display.Spirit;
	import flash.events.Event;
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class ImageLoaderModule extends Spirit implements IAJBridgeContent {
		
		
		
		public function ImageLoaderModule() {
			
		}
		
		override public function init():void {
			super.init();
			var flashvars: Object = stage.loaderInfo.parameters;
			
			AJBridge.bridge.deploy(flashvars);
			
			adapter  = new ImageLoaderJSAdapter();
			
			adapter.loader.addEventListener(AnyLoaderEvent.FINISH,eventHandler);
			adapter.loader.addEventListener(AnyLoaderEvent.ITEM,eventHandler);
			adapter.loader.addEventListener(AnyLoaderEvent.ITEM_CANCEL,eventHandler);
			adapter.loader.addEventListener(AnyLoaderEvent.ITEM_CAPTURE,eventHandler);
			adapter.loader.addEventListener(AnyLoaderEvent.ITEM_COMPLETE, eventHandler);
			
			adapter.loader.auto = flashvars['auto'] == true;
			
			var callbacks: Object = { 
					add: adapter.add,
					exec: adapter.exec,
					remove: adapter.remove,
					launch: adapter.loader.launch,
					removeOn: adapter.loader.removeOn,
					clear: adapter.loader.clear,
					close: adapter.loader.close,
					removeOn: adapter.insert,
					setAuto: adapter.setAuto
				};
			
			AJBridge.bridge.addCallback(callbacks);
			AJBridge.bridge.activate();
			dispatchContentReady();
		}
		
		private function eventHandler(e:Event):void {
			AJBridge.bridge.sendEvent(e);
		}
		
		public function dispatchContentReady(): void {
			AJBridge.bridge.sendEvent({type:AJBridge.CONTENT_READY});
		}
		
		private var adapter: ImageLoaderJSAdapter;
	}

}