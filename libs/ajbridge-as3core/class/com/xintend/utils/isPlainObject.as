package com.xintend.utils {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	
	/**
	 * Checks to see if an object is a plain object (created using "{}" or "new Object").
	 * @param	o
	 * @return
	 */
	public function isPlainObject(o:*): Boolean {
		return o && Object.prototype.toString.call(o) === '[object Object]' && !o['setInterval'];
	}


}