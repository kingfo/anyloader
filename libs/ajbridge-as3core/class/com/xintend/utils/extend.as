package com.xintend.utils {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	
	 
	/**
	 * Utility to set up the prototype, constructor and superclass properties to
	 * support an inheritance strategy that can chain constructors and methods.
	 * Static members will not be inherited.
	 * @param	r			the object to modify
	 * @param	s			the object to inherit
	 * @param	px			prototype properties to add/override
	 * @param	sx			static properties to add/override
	 * @return
	 */
	public function extend(r:*, s:*, px:Object=null, sx:Object=null):* {
		if (!s || !r) return r;
		var OP:Object = Object.prototype,
			O:Function = function (o):* {
				function F():* {
				}

				F.prototype = o;
				return new F();
			},
			sp:Object = s.prototype,
			rp:* = O(sp);

		r.prototype = rp;
		rp.constructor = r;
		r.superclass = sp;

		// assign constructor property
		if (s !== Object && sp.constructor === OP.constructor) {
			sp.constructor = s;
		}

		// add prototype overrides
		if (px) {
			mixin(rp, px);
		}

		// add object overrides
		if (sx) {
			mixin(r, sx);
		}

		return r;	
	}

}