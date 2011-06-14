package com.xintend.trine.swfstore {
	import com.xintend.security.Whitelist;
	import com.xintend.trine.ajbridge.AJBridge;
	import com.xintend.trine.swfstore.core.Store;
	import com.xintend.trine.swfstore.core.StoreEvent;
	import com.xintend.utils.JSUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public class SWFStore extends Sprite{
		
		
		public static const WHITELIST_FILE: String = "storage-whitelist.xml";
		
		public function SWFStore() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			whitelist.addEventListener(Whitelist.TRUSTED_DOMAIN, onWhitelist);
			whitelist.addEventListener(Whitelist.UNTRUSTED_DOMAIN, onWhitelist);
			whitelist.addEventListener(IOErrorEvent.IO_ERROR, onWhitelist);
			whitelist.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onWhitelist);
			
			
			store.addEventListener(StoreEvent.CLEAR, onStoreEvent);
			store.addEventListener(StoreEvent.NEW, onStoreEvent);
			store.addEventListener(StoreEvent.STORAGE, onStoreEvent);
			store.addEventListener(StoreEvent.INITIALIZE, onStoreEvent);
			store.addEventListener(StoreEvent.PENDING, onStoreEvent);
			store.addEventListener(StoreEvent.SHOW_SETTINGS, onStoreEvent);
			store.addEventListener(StoreEvent.ERROR, onStoreEvent);
			store.addEventListener(StoreEvent.RELOAD, onStoreEvent);
			
			store.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			
			var callbacks: Object = {
										////	HTML5 Web Storage interfaces
										////	see: http://dev.w3.org/html5/webstorage/#the-storage-interface
										getItem: store.getItem,
										setItem: store.setItem,
										removeItem:store.removeItem,
										getLength:store.getLength,
										key:store.key,
										clear: store.clear,
										////	other method:
										getModificationDate: store.getModificationDate,
										hasAdequateDimensions: store.hasAdequateDimensions,
										displaySettings: store.displaySettings,
										getUseCompression: store.getUseCompression,
										getSize: store.getSize,
										setMinDiskSpace: store.setMinDiskSpace
									};
			
									
			AJBridge.init(stage);
			AJBridge.addCallbacks(callbacks);
			AJBridge.ready();
			
			whitelist.urlMatches(JSUtils.getLocationHref()||"www.yourdomain.org");
			
			loadWhitelist();
		}
		
		private function loadWhitelist(): void {
			var fullPath:String = stage.loaderInfo.url;
    		
			//remove trailing slashes
			var parentPath:String;
			
			var hasTrailingSlash:Boolean = fullPath.charAt(fullPath.length - 1) == "/";
			if(hasTrailingSlash) fullPath = fullPath.slice(0, -1);
			
			//now get the path before the final slash (something like "/swffile.swf")
     		parentPath = fullPath.slice(0,fullPath.lastIndexOf("/"));
    		 
			var localpath:String = parentPath + "/" + WHITELIST_FILE;
			whitelist.loadPolicyFile(localpath);
			trace("Whitelist:" + localpath);
		}
		
		private function onNetStatus(e:NetStatusEvent):void {
			if (e.info.level == "error") {
				AJBridge.sendEvent(new StoreEvent(StoreEvent.STATUS,"failed"));
			}else {
				AJBridge.sendEvent(new StoreEvent(StoreEvent.STATUS,"success"));
			}
		}
		
		private function onStoreEvent(e:StoreEvent):void {
			AJBridge.sendEvent(e);
		}
		
		
		private function onWhitelist(e: Event): void {
			trace("onWhitelist:"+e.type)
			switch(e.type) {
				case Whitelist.TRUSTED_DOMAIN:
					store.init(stage);
					AJBridge.sendEvent(new StoreEvent(StoreEvent.CONTENT_READY,Store.CLASS_NAME));
				break;
				case Whitelist.UNTRUSTED_DOMAIN:
					AJBridge.sendEvent(new StoreEvent(StoreEvent.ERROR,e.type));
				break;
				case IOErrorEvent.IO_ERROR:
					AJBridge.sendEvent(e);
				break;
				case SecurityErrorEvent.SECURITY_ERROR:
					AJBridge.sendEvent(e);
				break;
			}
		}
		
		
		
		private var store: Store = new Store();
		private var whitelist: Whitelist  = new Whitelist();
	}

}