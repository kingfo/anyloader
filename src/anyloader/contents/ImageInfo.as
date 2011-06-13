package anyloader.contents {
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class ImageInfo extends ContentInfo {
		
		public function get width():Number {
			return _width;
		}
		
		public function get height():Number {
			return _height;
		}
		
		public function ImageInfo() {
			
		}
		
		public function setWidth(value:Number):void {
			_width = value;
		}
		public function setHeight(value:Number):void {
			_height = value;
		}
		
		
		private var _width: Number = 0 ;
		private var _height: Number = 0;
	}

}