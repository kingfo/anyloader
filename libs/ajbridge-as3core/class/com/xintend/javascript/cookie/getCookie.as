package com.xintend.javascript.cookie {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	
	import com.xintend.javascript.ExternalInterfaceWarp;	
	import com.xintend.utils.isEmptyString;
	
	public function getCookie(name:String):* {
		if (isEmptyString(name)) return null;
		var s: String;
		var m: Array;
		// 正则表达式无法在此接口中直接被转化
		s = ExternalInterfaceWarp.call("function (){"
										+"return document.cookie;"
										+"}"
										);
		s = s || "";
		m = s.match('(?:^| )' + name + '(?:(?:=([^;]*))|;|$)')
		//m = s.match('(?:^|;)\\s*' + name + '=([^;]*)');
		return (m && m[1]) ? decodeURIComponent(m[1]) : '';
	}

}