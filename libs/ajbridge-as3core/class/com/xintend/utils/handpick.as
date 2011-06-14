package com.xintend.utils {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	/**
	 * 随机选取一份内容
	 * @param	o
	 * @return
	 */
	public function handpick(o:*):* {
		var n: int;
		var i: *;
		var g: Number = new Date().time;
		switch(typeof o) {
			case "object":
				if (isEmptyObject(o)) return o;
				if (o is Array) {
					n = o.length;
					i = g % n;
					return o[i];
				}else {
					for each(i in o) {
						return i;
					}
				}
			break;
			case "string":
				if (isEmptyString(o)) return o;
			break;
			case "xml":
				if (isEmptyXML(o as XML)) return o;
				n = o.*.length();
				i = g % n;
				return o[i];
			break;
			case "number":
				return g % n;
			break;
			default: 
				return o;
		}
	}

}