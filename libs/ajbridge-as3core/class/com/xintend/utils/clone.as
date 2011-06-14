package com.xintend.utils {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	/**
	 * Creates a deep copy of a plain object or array. Others are returned untouched.
	 * @param	o
	 * @return
	 */
	public function clone(o:*):* {
		var ret:* = o, k:*,c;

		// array or plain object
		if (o is Array) {
			return o.concat();
		}else if(o && isPlainObject(o)) {
			c = getDefinitionByName(getQualifiedClassName(o));
			try {
				ret = new c();
			}catch (e:Error) {
				return ret;
			}
			for (k in o) {
				if (o.hasOwnProperty(k)) {
					ret[k] = clone(o[k]);
				}
			}
		}

		return ret;	
	}
	
	
	

}