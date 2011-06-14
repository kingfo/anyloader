package com.xintend.javascript.cookie {
	import com.xintend.javascript.ExternalInterfaceWarp;
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	
	 
	public function setCookie(name:String, val:*, expires:*, domain:String=null, path:String=null, secure:Boolean=false):void {
		ExternalInterfaceWarp.call("function (name, val, expires, domain, path, secure){"
										+" var text = encodeURIComponent(val), date = expires;"
										+"  if (typeof date === 'number') {"
										+"       date = new Date();"
										+"       date.setTime(date.getTime() + expires * 86400000);"
										+"  }"
										+"  if (date instanceof Date) text += '; expires=' + date.toUTCString();"
										+"  if (domain) text += '; domain=' + domain;"
										+"  if (path)text += '; path=' + path;"
										+"  if (secure) text += '; secure';"
										+"  document.cookie = name + '=' + text;"
										+"}",name,val,expires,domain,path,secure
										);
	}

}