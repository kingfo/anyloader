package com.xintend.utils {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	
	 
	/**
	 * Copies all the properties of s to r.
	 * @param	r
	 * @param	s
	 * @param	ov
	 * @param	wl
	 * @return
	 */
	public function mixin(r:*,s:*,ov:Boolean=true,wl:Array=null):* {
		var i:int, p:*, l:int;
		if (wl && (l = wl.length)) {
			for (i = 0; i < l; i++) {
				p = wl[i];
				if (p in s) {
					if (ov || !(p in r)) {
						r[p] = s[p];
					}
				}
			}
		} else {
			for (p in s) {
				if (ov || !(p in r)) {
					r[p] = s[p];
				}
			}
		}
		return r;
	}
		

}