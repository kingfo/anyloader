package {
	import com.adobe.serialization.json.JSON;
	import com.xintend.net.uploader.Uploader;
	import com.xintend.trine.ajbridge.AJBridge;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.DataEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.setTimeout;
	import org.flashdevelop.utils.FlashConnect;
	
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public class Main extends Sprite {
		
		
		public static const VERSION:String = "1.1.3"
		
		
		public function Main(): void {
			Security.allowDomain("*");
			
			//if (stage) init();
			//else addEventListener(Event.ADDED_TO_STAGE, init);
			setTimeout(init, 100);
			
			try {
                ExternalInterface.marshallExceptions = true;
            }catch (error: Error) {
				trace(error);
            }
		}
		
		private function init(e: Event = null): void {
			var params:Object = stage.loaderInfo.parameters;
			
			
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			// 1.获取外部配置
			AJBridge.init(stage);
			
			defaultServerURL = params["ds"];
			defaultServerParameters = params["dsp"];
			
			
			
			hand = params["hand"] || false;
			btn = params["btn"] ||  false;
			
			if (defaultServerParameters) {
				defaultServerParameters = defaultServerParameters.replace(/\'/g,'"');
				defaultServerParameters = JSON.decode(defaultServerParameters);
			}
			// 2.创建并配置上传实例
			uploader = new Uploader();
			// 3.创建监听程序
			uploader.addEventListener(Uploader.CONTENT_READY, eventHandler);
			uploader.addEventListener(Uploader.UPLOAD_LOCK, eventHandler);
			uploader.addEventListener(Uploader.UPLOAD_UNLOCK, eventHandler);
			uploader.addEventListener(Uploader.FILE_SELECT, eventHandler);
			uploader.addEventListener(Uploader.BROWSE_CANCEL, eventHandler);
			uploader.addEventListener(Uploader.UPLOAD_CLEAR, eventHandler);
			uploader.addEventListener(Uploader.UPLOAD_START, eventHandler);
			uploader.addEventListener(Uploader.UPLOAD_PROGRESS, eventHandler);
			uploader.addEventListener(Uploader.UPLOAD_COMPLETE, eventHandler);
			uploader.addEventListener(Uploader.UPLOAD_COMPLETE_DATA, eventHandler);
			uploader.addEventListener(Uploader.UPLOAD_LIST_COMPLETE, eventHandler);
			uploader.addEventListener(Uploader.UPLOAD_ERROR, eventHandler);
			
			
			// 4.注册 AJBridge
			var callbacks: Object = { 
					upload: uploader.upload,
					uploadAll: uploader.uploadAll,
					cancel: uploader.cancel,
					getFile: uploader.getFile,
					removeFile: uploader.removeFile,
					lock: uploader.lock,
					unlock: uploader.unlock,
					clear: uploader.clear,
					/*简单的多接口*/
					multifile: uploader.setAllowMultipleFiles,
					setAllowMultipleFiles: uploader.setAllowMultipleFiles,
					filter: uploader.setFileFilters,
					setFileFilters: uploader.setFileFilters,
					/* 增加的接口 */
					browse: browse,
					setBtnMode: setBtnMode,
					useHand: useHand,
					getVersion:getVersion
				};
			
			
			
			AJBridge.addCallbacks(callbacks);
			AJBridge.ready();
			
			
			hotspot = new Sprite();
			hotspot.addEventListener(Event.RESIZE, hotspotResize);
			hotspot.buttonMode = btn;
			hotspotResize();
			addChild(hotspot);
			
			
			if (hand || btn) {
				useHand(hand);
				setBtnMode(btn);
			}
			
			hotspot.addEventListener(MouseEvent.CLICK, mouseHandler);
			
			uploader.init(defaultServerURL, defaultServerParameters);
		}
		
		private function useHand(value:Boolean):void{
			hotspot.useHandCursor = value;
		}
		
		private function setBtnMode(value:Boolean):void{
			if (value) {
				hotspot.addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
				hotspot.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
				hotspot.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				hotspot.addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
			}else {
				hotspot.removeEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
				hotspot.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
				hotspot.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				hotspot.removeEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
			}
		}
		
		private function getVersion():String{
			return VERSION;
		}
		
		/**
		 * 定义浏览模式
		 * @param	mulit
		 * @param	fileFilters
		 */
		private function browse(mulit: Boolean = true, fileFilters: Array = null):Boolean{
			if (uploader.isLocked) return false;
			uploader.setFileFilters(fileFilters);
			uploader.setAllowMultipleFiles(mulit);
			return true;
 		}
		
		
		
		private function eventHandler(e: Event): void {
			switch(e.type) {
				case Uploader.FILE_SELECT:
				case Uploader.BROWSE_CANCEL:
					hotspot.addEventListener(MouseEvent.CLICK, mouseHandler);
				break;
			}
			AJBridge.sendEvent(e);
		}
		
		private function mouseHandler(e: MouseEvent): void {
			switch(e.type) {
				case MouseEvent.CLICK:
					uploader.browse();
					hotspot.removeEventListener(MouseEvent.CLICK, mouseHandler);
				break;
			}
			
			// 鼠标事件需要单独转换  
			// 否则会堆栈溢出
			// flash 自身 bug ?
			AJBridge.sendEvent({type:e.type});
		}
		
		
		private function hotspotResize(e: Event = null): void {
			FlashConnect.atrace("hotspotResize");
			hotspot.graphics.clear();
			hotspot.graphics.beginFill(0,0);
			hotspot.graphics.drawRect(0, 0, stage.stageWidth,stage.stageHeight);
			hotspot.graphics.endFill();
		}
		
		private var uploader: Uploader;
		private var defaultServerURL: String;
		private var defaultServerParameters: * ;
		private var hotspot: Sprite;
		private var hand: Boolean;
		private var btn: Boolean;
		
	}
	
}