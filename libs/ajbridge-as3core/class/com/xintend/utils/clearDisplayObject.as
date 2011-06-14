package com.xintend.utils {
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public function clearDisplayObject(container:DisplayObjectContainer):void {
		while (container.numChildren) {
			container.removeChildAt(0);
		}
	}

}