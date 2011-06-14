package com.xintend.display {
	import flash.display.Sprite;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	/**
	 * 用于解决 ExternalInterface 在不同浏览器下的兼容性
	 * @author Kingfo[Telds longzang]
	 */
	public class Spirit extends Sprite{
		
		public static var initiationDelay: Number = 100;
		
		public function Spirit() {
			timeoutId = setTimeout(init, initiationDelay);
		}
		
		public function init(): void {
			clearTimeout(timeoutId);
		}
		
		private var timeoutId: uint;

	}

}