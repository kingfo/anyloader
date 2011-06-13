package anyloader.loaders {
	import anyloader.contents.ContentInfo;
	import anyloader.decoders.IDescriber;
	
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public interface IAnyLoader {
		/**
		 * 当前执行项
		 */
		function get itemLoaded(): uint 
		/**
		 * 总共需要执行项
		 */
		function get itemTotal():uint
		/**
		 * 自动执行
		 * 在 add() 时执行检查  
		 * 若 true 则 立即运行
		 * 若 false 则  add() 后等待再次 launch() 进行
		 * @return
		 */
		function get auto(): Boolean;
		function set auto(value: Boolean): void;
		 
		/**
		 * 添加至加载队列
		 * @param	src
		 * @param	config
		 */
		function add(info: ContentInfo): void;
		/**
		 * 指定正在下载项后的某项开始插入一系列 ContentInfo
		 * @param	offset
		 * @param	infoList
		 */
		function insert(infoList:Array,offset:uint = 0): void;
		/**
		 * 移除指定的加载项
		 * @param	field
		 * @param	value
		 * @param	force
		 */
		function removeOn(field: String,value:*): void;
		/**
		 * 立即执行
		 * @param	src					内容源 URL
		 */
		function exec(info:ContentInfo): void;
		/**
		 * 清除所有下载项
		 * @param	force				强制清除，包含正在下载项
		 */
		function clear(force: Boolean = true ): void;
		/**
		 * 启动下载队列
		 */
		function launch(): Boolean;
		/**
		 * 关闭所有下载
		 * @param	force				强制终止正在下载项
		 */
		function close(force:Boolean = true): void;
	}
	
}