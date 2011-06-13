package anyloader.contents {
	import anyloader.decoders.IDescriber;
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class ContentInfo {
		public function get describer():IDescriber {
			return _describer;
		}
		
		public function get type():String {
			return _type;
		}
		
		public function get content():ContentStream {
			return _content;
		}
		
		public function get src():String {
			return _src;
		}
		
		public function get status():String {
			return _status;
		}
		
		public function get params():* {
			return _params;
		}
		
		public function get method():String {
			return _method;
		}
		
		public function ContentInfo() {
			
		}
		
		public function setContent(value:ContentStream):void {
			_content = value;
		}
		public function setDescriber(value:IDescriber):void {
			_describer = value;
		}
		public function setType(value:String):void {
			_type = value;
		}
		public function setSrc(value:String):void {
			_src = value;
		}
		public function setStatus(value:String):void {
			_status = value;
		}
		public function setParams(value:*):void {
			_params = value;
		}
		
		public function toString(): String {
			return '[object ContentInfo' + ' src=' + src + ' status=' + status + ' method=' + method + ']'
		}
		
		
		
		private var _content: ContentStream;
		private var _describer: IDescriber;
		private var _type: String;
		private var _src: String;
		private var _status: String = ContentStatus.WAITTING;
		private var _params:*;
		private var _method: String = "GET";
	}

}