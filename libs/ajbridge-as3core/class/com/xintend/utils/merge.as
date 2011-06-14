package com.xintend.utils {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	
	 
	/**
	 * Returns a new object containing all of the properties of
	 * all the supplied objects. The properties from later objects
	 * will overwrite those in earlier objects. Passing in a
	 * single object will create a shallow copy of it.
	 * @param	...args
	 * @return
	 */
	public function merge(...args):* {
		var o:Object = {}, i:int, l:int = args.length;
		for (i = 0; i < l; ++i) {
			mixin(o, args[i]);
		}
		return o;	
	}

}