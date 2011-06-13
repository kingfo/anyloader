package anyloader.decoders {
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class DecoderLink {
		/**
		 * 特征码
		 */
		public function get codes():Array {
			return _codes;
		}
		public function set codes(value:Array):void {
			_codes = value;
		}
		/**
		 * 对应解码类
		 */
		public function get cls():Class {
			return _cls;
		}
		public function set cls(value:Class):void {
			_cls = value;
		}
		/**
		 * 特征码长度
		 */
		public function get codeLength():uint {
			return _codes.length;
		}
		
		/**
		 * 构造函数
		 * @param	codes					特征码
		 * @param	cls						对应解码类
		 */
		public function DecoderLink(codes:Array,cls:Class) {
			_codes = codes;
			_cls = cls;
		}
		
		private var _codes: Array;
		private var _cls: Class;
		private var _codeLength: uint;
		
		
	}

}