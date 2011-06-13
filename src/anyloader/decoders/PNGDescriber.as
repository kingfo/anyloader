package anyloader.decoders {
	import anyloader.contents.ContentType;
	import anyloader.events.DecoderErrorEvent;
	import anyloader.events.DescriberEvent;
	import flash.events.EventDispatcher;
	import flash.utils.IDataInput;
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class PNGDescriber extends EventDispatcher implements IDisplayObjectDescriber {
		
		public const TYPE: String = ContentType.IMAGE_PNG;
		
		public function get type():String { return TYPE; }
		
		public function get width():Number {
			return _width;
		}
		
		public function get height():Number {
			return _height;
		}
		
		public function get host():* {
			return _host;
		}
		
		
		public function PNGDescriber() {
		}
		
		public function listen(bytes: IDataInput): void {
			// read IHDR
			if (hasCapture) return;
			var len: uint = getLength(bytes); // data bytes length
			if (bytes.bytesAvailable < 12) return; // 25 = 4(length) + 4(width) + 4(height)
			var chunkType: uint = bytes.readUnsignedInt();
			//trace(chunkType.toString(16));
			if (chunkType != 0x49484452 ) dispatchEvent(new DecoderErrorEvent(DecoderErrorEvent.FORMAT_ERROR,bytes,true));
			_width = bytes.readUnsignedInt();
			_height = bytes.readUnsignedInt();
			dispatchEvent(new DescriberEvent(DescriberEvent.CAPTURE,true));
			hasCapture = true;
		}
		
		public function setHost(value:*):void {
			_host = value;
		}
		
		private function getLength(bytes:IDataInput): uint {
			return bytes.readUnsignedInt();
		}
		
		
		private var hasCapture: Boolean = false;
		private var _width: Number;
		private var _height: Number;
		private var _host:*;
		
		
	}

}