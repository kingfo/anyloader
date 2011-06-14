package com.xintend.utils {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	
	 
	/**
	 * Applies prototype properties from the supplier to the receiver.
	 * @param	...args			the augmented object,   r, s1, s2, ..., ov, wl
	 * @return
	 */
	public function augment(...args):* {
		var len:int = args.length - 2,
			r:* = args[0], ov:* = args[len], wl:Array = args[len + 1] as Array,
			i:int = 1;

		if (wl) {
			ov = wl;
			wl = undefined;
			len++;
		}

		if (!S.isBoolean(ov)) {
			ov = undefined;
			len++;
		}

		for (; i < len; i++) {
			mix(r.prototype, args[i].prototype || args[i], ov, wl);
		}

		return r;	
	}

}