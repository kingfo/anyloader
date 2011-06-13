package anyloader.decoders {
	import anyloader.contents.ContentType;
	import anyloader.events.DescriberEvent;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class ImageDescriber extends EventDispatcher implements IDisplayObjectDescriber, IComplexDescriber {
		
		public function get width(): Number {
			return describer.width;
		}
		public function get height(): Number {
			return describer.height;
		}
		
		public function get core(): IDescriber {
			return describer;
		}
		
		public function get type():String {
			return describer.type;
		}
		
		public function get host():* {
			return _host;
		}
		
		
		public function ImageDescriber() {
			nextHandler = match;
			
		}
		
		public function setDecoderPool(pool:DecoderPool): void {
			this.pool = pool;
		}
		
		public function listen(bytes: IDataInput): void {
			if (!bytes || nextHandler == null) return;
			bytes.readBytes(buffer,buffer.length);
			nextHandler(buffer);
		}
		
		public function match(bytes: IDataInput): void{
			if (!bytes) return;
			
			var dls: Array;
			var dlsLen: int;
			var poolLen: int;
			dls = pool.getLinks('codeLength', buffer.length, DecoderPool.LE);
			dlsLen = dls.length;
			poolLen = pool.size;
			if (dls.length < 1) {
				//dispatchEvent(new DescriberEvent(DescriberEvent.ABANDON));
				return ;
			}
			
			for each (var dl: DecoderLink in dls) {
				buffer.position = 0;
				var dump: Array = [];
				var i: int;
				var len:int
				var code: int;
				len = dl.codeLength;
				//trace("--start--",len,dl.cls);
				for (i = 0; i < len; i++ ) {
					code = buffer.readUnsignedByte();
					//trace(code.toString(16));
					dump.push(code);
				}
				//trace("--end--");
				if (dump.join("") == dl.codes.join("")) {
					//trace(dl.cls);
					// create describer
					describer = new dl.cls();
					describer.setHost(this);
					describer.addEventListener(DescriberEvent.CAPTURE, onCapture);
					// bugfix: 一定要立即使用 否则小文件就可能已下载完毕 轮不到 nextFunc
					describer.listen(bytes); 
					nextHandler = describer.listen;
				}
			}
			if (dlsLen == poolLen) {
				dispatchEvent(new DescriberEvent(DescriberEvent.ABANDON));
				nextHandler = null;
				pool = null;
				buffer = null;
			}
			
		}
		
		public function setHost(value:*):void {
			_host = value;
		}
		
		private function onCapture(e:DescriberEvent):void {
			dispatchEvent(e);
		}
		
		private var nextHandler: Function;
		private var buffer: ByteArray = new ByteArray();
		private var describer: IDisplayObjectDescriber;
		private var pool: DecoderPool;
		private var _host:*;
	}

}