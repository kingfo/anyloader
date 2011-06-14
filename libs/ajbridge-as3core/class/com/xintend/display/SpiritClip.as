package com.xintend.display {
	import flash.display.MovieClip;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	/**
	 * 用于解决 ExternalInterface 在不同浏览器下的兼容性
	 * @author Kingfo[Telds longzang]
	 */
	public class SpiritClip extends MovieClip{
		
		public static var initiationDelay: Number = 100;
		
		public function SpiritClip() {
			timeoutId = setTimeout(init, initiationDelay);
		}
		/**
		 * 后续初始化可以覆盖 init 后进行 确保 Flash play 初始化完全成功
		 */
		public function init(): void {
			clearTimeout(timeoutId);
		}
		
		private var timeoutId: uint;
		
	}

}