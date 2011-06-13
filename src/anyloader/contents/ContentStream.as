package anyloader.contents {
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class ContentStream extends URLStream {
		
		public function get info():ContentInfo {
			return _info;
		}
		
		public function ContentStream() {
			
		}
		/**
		 * 配置种子文件
		 * @param	seed
		 */
		public function setInfo(info:ContentInfo): void {
			var params: Object;
			var data: URLVariables;
			
			_info = info;
			
			request = new URLRequest(info.src);
						
			// config url params
			if (info.params) {
				params = info.params;
				data = new URLVariables();
				for (var p:* in params) {
					data[p] = params[p];
				}
				request.data = data;
			}
			
			request.method = info.method;
			
		}
		
		/**
		 * 启动下载
		 */
		public function launch(): void {
			load(request);
		}
		
		
		private var request: URLRequest;
		
		private var _info: ContentInfo;
		
		
	}

}