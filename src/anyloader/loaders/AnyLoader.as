package anyloader.loaders {
	import anyloader.contents.ContentInfo;
	import anyloader.contents.ContentStatus;
	import anyloader.contents.ContentStream;
	import anyloader.events.AnyLoaderEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * 加载器
	 * 实现 IAnyLoader 接口
	 * 一般情况下作为所有下载器的接口
	 * 若仅使用该对象实例则仅仅对指定源进行下载,不做任何处理
	 * @author kingfo oicuicu@gmail.com
	 */
	public class AnyLoader extends EventDispatcher implements IAnyLoader {
		
		
		/**
		 * 运行状态
		 * 如果 是 auto 为 true 则此属性可以忽略
		 */
		public function get isRunning():Boolean {
			return _isRunning;
		}
		/**
		 * 当前正在运行的内容
		 * 仅作为参考使用
		 * 这是个类似指针的对象
		 */
		public function get currentContent():ContentStream {
			return _content;
		}
		/**
		 * 当前已下载项个数
		 */
		public function get itemLoaded():uint {
			return _itemLoaded;
		}
		/**
		 * 等待总共请求下周的数量
		 * 包含了那些不适用的请求
		 * 如格式错误、url地址错误
		 */
		public function get itemTotal():uint {
			return _itemTotal;
		}
		/**
		 * 自动启动模式
		 * 一旦为true，那么 add() 后就自动运行
		 */
		public function get auto():Boolean {
			return _auto;
		}
		public function set auto(value:Boolean):void {
			_auto = value;
		}
		
		public function AnyLoader() {
			
		}
		
		
		/**
		 * 添加至加载队列
		 * @param	src
		 * @param	config
		 */
		public function add(info:ContentInfo): void {
			
			waittingList.push(info);
			
			_itemTotal++;
			
			if (auto) {
				launch();
			}
			
		}
		/**
		 * 指定正在下载项后的某项开始插入一系列 ContentInfo
		 * @param	offset
		 * @param	infoList
		 */
		public function insert(infoList: Array, offset: uint = 0): void {
			var args: Array = [offset, 0];
			
			var a:Array = infoList.filter(
				function(element:*, index: int, arr: Array): Boolean {
					return element is ContentInfo;
					},this);
			_itemTotal += a.length;
			args = args.concat(a);
			var t: Array = runingList.length > 0 ? runingList : waittingList;
			t.splice.apply(this, args);
		}
		
		/**
		 * 移除指定的加载项
		 * @param	field
		 * @param	value
		 */
		public function removeOn(field: String,value:*): void {
			var idx: int;
			var b: Array = [runingList, waittingList];
			var t: Array;
			var blen: uint = b.length;
			for (var i: int = 0; i < blen; i++ ) {
				t = b[i];
				var a: Array = t.filter(
				function(element:*, index: int, arr: Array): Boolean {
					var tag: Boolean = element[field] == value;
					if(tag) idx = index;
					return tag;
					},this);
				if (a.length < 1) continue;
				t.splice(idx, a.length);
			}
		}
		/**
		 * 立即执行
		 * @param	src					内容源 URL
		 */
		public function exec(info:ContentInfo): void {
			_itemTotal++;
			execute(info);
		}
		
		/**
		 * 清除所有下载项
		 * @param	force				强制清除，包含正在下载项
		 */
		public function clear(force: Boolean = true): void {
			waittingList = [];
			runingList = [];
			_itemLoaded = 0;
			_itemTotal = 0;
			if(force)cancel();
			_isRunning = false;
		}
		
		/**
		 * 启动下载器
		 */
		public function launch(): Boolean {
			if (waittingList.length == 0) return false;
			runingList = runingList.concat(waittingList.splice(0, waittingList.length));
			if (!isRunning) {
				next();
			}
			_isRunning = true;
			return _isRunning;
		}
		
		
		/**
		 * 关闭下载器
		 * @param	force				强制终止正在下载项
		 */
		public function close(force: Boolean = true): void {
			if (force) {
				cancel();
			}
			_isRunning = false;
		}
		/**
		 * 取消当前下载对象
		 */
		protected function cancel(): void {
			if (!isRunning) return;
			try {
				_content.close();
			}catch (e: Error) {
				trace(e);
			}
			dispatchEvent(new AnyLoaderEvent(AnyLoaderEvent.ITEM_CANCEL,_content.info));
			_content = null;
		}
		/**
		 * 执行下一项下载
		 */
		protected function next(): void {
			var info: ContentInfo = runingList.shift();
			execute(info);
		}
		/**
		 * 执行下载
		 * @param	info
		 */
		protected function execute(info: ContentInfo): void {
			if (!info) return;
			_content = configContentStream(new ContentStream(),info);
			
			_content.launch();
			
			info.setStatus(ContentStatus.RUNNING);
			dispatchEvent(new AnyLoaderEvent(AnyLoaderEvent.ITEM,info));
		}
		
		
		protected function configContentStream(content:ContentStream,info:ContentInfo): ContentStream {
			content.addEventListener(Event.COMPLETE, onCurrentContentComplete);
			
			info.setContent(content);
			content.setInfo(info);
			
			return content;
		}
	
		
		
		/**
		 * 单项完成处理 
		 * 子类可以自行实现完成项的处理
		 * @param	c
		 */
		protected function itemComplete(cs:ContentStream): void {
			if (!cs) return;
			var info: ContentInfo = cs.info;
			info.setStatus(ContentStatus.DONE);
			dispatchEvent(new AnyLoaderEvent(AnyLoaderEvent.ITEM_COMPLETE,info));
		}
		
		
		private function onCurrentContentComplete(e: Event): void {
			e.currentTarget.removeEventListener(Event.COMPLETE, onCurrentContentComplete);
			
			itemComplete(e.currentTarget as ContentStream);
			
			_itemLoaded++;
			
			if (runingList.length == 0) {
				_isRunning = false;
				dispatchEvent(new AnyLoaderEvent(AnyLoaderEvent.FINISH));
				return ;
			}
			next();
		}
		
		
		
		
		protected var waittingList: Array = [];
		protected var runingList: Array = [];
		
		private var _content: ContentStream;
		private var _isRunning: Boolean = false;
		private var _itemLoaded: uint = 0;
		private var _itemTotal: uint;
		private var _auto: Boolean = false;
		
		
	}

}