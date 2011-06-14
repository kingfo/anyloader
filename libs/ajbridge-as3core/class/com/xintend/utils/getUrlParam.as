package com.xintend.utils {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public function getUrlParam(url: String, paraStr: String):* {
		var result:String = ""; 
		var str:String = "&" + url.split("?")[1];  
		var paraName:String = paraStr + "=";
		if(str.indexOf("&"+paraName)!=-1)  
		 {  
			//如果要获取的参数到结尾是否还包含“&”  
			 if(str.substring(str.indexOf(paraName),str.length).indexOf("&")!=-1)  
			 {  
				 //得到要获取的参数到结尾的字符串  
				 var TmpStr:String =str.substring(str.indexOf(paraName),str.length);  
				 //截取从参数开始到最近的“&”出现位置间的字符  
				 result=TmpStr.substr(TmpStr.indexOf(paraName),TmpStr.indexOf("&")-TmpStr.indexOf(paraName));    
			 }  
			 else  
			 {    
				 result =str.substring(str.indexOf(paraName),str.length);    
			 }  
		 }    
		 else  
		 {    
			 result="";    
		 }    
		 return (result.replace("&",""));    
	}

}