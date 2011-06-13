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
	public class JPEGDescriber extends EventDispatcher implements IDisplayObjectDescriber {
		
		public const TYPE: String = ContentType.IMAGE_JPEG;
		
		public function get type():String { return TYPE; }
		
		public function get width():Number {
			return _width;
		}
		
		public function get height():Number {
			return _height;
		}
		
		
		public function get standard():String {
			return _standard;
		}
		
		public function get precision():uint {
			return _precision;
		}
		
		public function get host():* {
			return _host;
		}
		
		
		
		public function JPEGDescriber() {
			nextFunc = checkFormat;
		}
		
		public function listen(bytes: IDataInput): void {
			if (nextFunc == null) return;
			nextFunc(bytes);
		}
		
		public function setHost(value:*):void {
			_host = value;
		}
		
		private function checkFormat(bytes: IDataInput): void {
			if(bytes.bytesAvailable < 10) return; // marker  + length + identifier = 2 + 2 + 6
			
			var marker: uint = bytes.readUnsignedShort();
			var markerNumber: uint = marker ^ 0xFFE0;
			
			nextLen = getLength(bytes) - 2; // JPEG 的 length 包含了 length 自己的 2个字节数
			
			switch(markerNumber) {
				case 0:
					//JFIF 的  Identifier 有 5 个字节
					_standard = bytes.readUTFBytes(5);
					nextLen -= 5;
				break;
				case 1:
					//EXIF 的 Identifier 有 6 个字节
					_standard = bytes.readUTFBytes(6);
					nextLen -= 6;
				break;
				default:
					trace('unknown marker:' + markerNumber.toString(16));
					dispatchEvent(new DecoderErrorEvent(DecoderErrorEvent.FORMAT_ERROR, bytes,true));
			}
			nextFunc = readSize;
			nextFunc(bytes);
		}
		
		private function readSize(bytes: IDataInput): void {
			var leastSOF0:uint = 9; // marker + length + precision + width + height = 2 + 2 + 1 + 2 + 2
			var minLen:uint = nextLen + leastSOF0
			if(bytes.bytesAvailable < minLen) return;  
			
			// 跳过前面的积累数据块
			bytes.readUTFBytes(nextLen);
			
			var marker: uint = bytes.readUnsignedShort();
			var markerNumber: uint = marker ^ 0xFFC0;
			
			if (markerNumber == 0) {
				// 找到 SOF0
				getLength(bytes); // 跳过 Length
				_precision = bytes.readUnsignedByte();
				_height = bytes.readUnsignedShort();
				_width = bytes.readUnsignedShort();
				dispatchEvent(new DescriberEvent(DescriberEvent.CAPTURE,true));
				nextFunc = null;
			}else {
				// skip markers
				nextLen = getLength(bytes) - 2; // 从实际数据块到下一标记的长度
				nextFunc(bytes);
			}
		}
		
		private function getLength(bytes:IDataInput): uint {
			return bytes.readUnsignedShort();
		}
		
		
		
		
		private var _standard: String;
		private var _precision: uint;
		
		private var nextLen: uint = 2; // 直接是 2 , 因为 JPEG 开头都是 0xFFD8 (SOI 标记)
		private var nextFunc: Function;
		
		private var _width: Number;
		private var _height: Number;
		private var _host:*;
	}

}