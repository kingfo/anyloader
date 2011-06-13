package anyloader.decoders {
	import anyloader.contents.ContentType;
	import anyloader.events.DescriberEvent;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class GIFDescriber extends EventDispatcher implements IDisplayObjectDescriber {
		
		public const TYPE: String = ContentType.IMAGE_GIF;
		
		public function get width():Number {
			return _width;
		}
		
		public function get height():Number {
			return _height;
		}
		
		public function get type():String { return TYPE; }
		
		public function get version():String {
			return _version;
		}
		
		public function get host():* {
			return _host;
		}
		
		
		
		public function GIFDescriber() {
		}
		
		
		public function listen(bytes: IDataInput): void {
			if (hasCapture) return;
			if (bytes.bytesAvailable < 7) return; 
			
			_version = bytes.readUTFBytes(3); // 版本号占 3 个字节
			
			bytes.endian  = Endian.LITTLE_ENDIAN; // GIF 数据部分采用的是 LITTLE_ENDIAN 字节顺序
			
			_width = bytes.readUnsignedShort();
			_height = bytes.readUnsignedShort();
			
			//trace(_width,_height);
			hasCapture = true;
			dispatchEvent(new DescriberEvent(DescriberEvent.CAPTURE,true));
		}
		
		public function setHost(value:*):void {
			_host = value;
		}
		
		
		private var _version: String;
		private var hasCapture: Boolean = false;
		private var _width: Number;
		private var _height: Number;
		private var _host:*;
	}

}