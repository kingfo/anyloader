package {
	import com.xintend.ajbridge.local.store.LocalStorage;
	import com.xintend.display.Spirit;
	import flash.system.SecurityPanel;
	
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public class Store extends Spirit {
		
		public static const WHITELIST_FILE: String = "storage-whitelist.xml";
		
		
		public function Store():void {
			
		}
		
		override public function init():void {
			super.init();
			// entry point
			
		}
		
		/**
		 * 验证是否有足够的空间
		 * @return
		 */
		public function hasAdequateDimensions(): Boolean {
			return (stage.stageHeight >= 138) && (stage.stageWidth >= 215);
		}
		/**
		 * 显示本地存储配置
		 * 需要至少215x138像素尺寸空间
		 */
		public function displaySettings(): void {
			if (hasAdequateDimensions()) {
				Security.showSettings(SecurityPanel.LOCAL_STORAGE);
				dispatchEvent(new StorageEvent(StorageEvent.SHOW_SETTINGS,CLASS_NAME));
			}else {
				dispatchEvent(new StorageEvent(StorageEvent.ERROR, "Make sure that your application window size is at least 215 x 138 pixels"));
			}
		}
		/**
		 * 分配给此对象的最小磁盘空间（以字节为单位）
		 * 需要至少215x138像素尺寸空间
		 * @param	value						字节
		 * @return
		 */
		public function setMinDiskSpace(value: int): String {
			var status:String;
			if (hasAdequateDimensions()) {
				status = so.flush(value);
			}else {
				dispatchEvent(new StorageEvent(StorageEvent.ERROR,"Make sure that your application window size is at least 215 x 138 pixels"));
			}
			return status;
		}
		
		
		private var localStorage: LocalStorage = new LocalStorage();
	}
	
}