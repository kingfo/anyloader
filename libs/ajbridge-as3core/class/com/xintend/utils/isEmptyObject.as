package com.xintend.utils {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	/**
	 * Checks to see if an object is empty.
	 * @param	o
	 * @return
	 */	
	public function isEmptyObject(o:Object):Boolean {
		for (var p in o) {
			return false;
		}
		return true;
	}
		

}