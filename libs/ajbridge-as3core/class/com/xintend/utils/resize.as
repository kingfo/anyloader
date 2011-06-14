package com.xintend.utils {
	import flash.display.DisplayObject;
	import flash.display.Loader;
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public function resize(obj: DisplayObject, width: Number, height: Number, constrain: Boolean = true): void {
		var rw: Number;
		var rh: Number;
		
		rw = obj.width / width;
		rh = obj.height / height;
		if (!constrain) {
			obj.width = width;
			obj.height = height;
		}
		if (obj.height > obj.width) {
			obj.width = width;
			obj.height = obj.height / rw;
		}else {
			obj.height = height;
			obj.width = obj.width / rh;
		}
		
	}

}