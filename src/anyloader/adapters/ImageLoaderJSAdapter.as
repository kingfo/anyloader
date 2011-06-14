package anyloader.adapters {
	import anyloader.contents.ContentInfo;
	import anyloader.loaders.ImageLoader;
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class ImageLoaderJSAdapter{
		
		public function get loader():ImageLoader {
			return _loader;
		}
		
		public function ImageLoaderJSAdapter() {
			
		}
		
		public function add(src: String, params: Object = null, method: String = null): void {
			var info: ContentInfo = getContentInfo(src,params,method);
			loader.add(info);
		}
		
		public function exec(src: String, params: Object = null, method: String = null): void {
			var info:ContentInfo = getContentInfo(src,params,method)
			loader.exec(info);
		}
		
		public function remove(src: String): void {
			loader.removeOn('src',src);
		}
		
		
		public function insert(infoList: Array, offset: uint = 0): void {
			var a: Array = [];
			for (var i: int = 0, len: Number = infoList.length ; i < len; i++  ) {
				var o:* = infoList[i];
				a.push(getContentInfo(o.src, o.params, o.method ));
			}
			loader.insert(a,offset);
		}
		
		
		
		private function getContentInfo(src: String, params: Object = null, method: String = null): ContentInfo {
			if (!src) return null;
			var info: ContentInfo = new ContentInfo();
			info.setSrc(src);
			if (params) info.setParams(params);
			if (method) info.setMethod(method);
			return info;
		}
		
		
		
		
		private var _loader: ImageLoader = new ImageLoader();
		
	}

}