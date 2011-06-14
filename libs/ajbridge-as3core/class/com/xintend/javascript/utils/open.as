package com.xintend.javascript.utils {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	import com.xintend.javascript.ExternalInterfaceWarp;
	
	public function open(url: String = null, window: String = "_blank", method: String = 'post'): void {
			ExternalInterfaceWarp.call("function open2Blank(C,D,E){"	
										+"var isT = !document.getElementById('itemClickForm');"
										+"if(isT){"
										+"var B=document.createElement('form');"
										+"B.id='itemClickForm';"
										+"B.target= D;"
										+"B.method= E;"
										+"B.style.display='none';"
										+"var A=document.createElement('input');"
										+"A.type='submit';"
										+"B.appendChild(A);"
										+"A.id='itemClickButton';"
										+"document.body.appendChild(B);"									
										+"}else{"
										+"var B=document.getElementById('itemClickForm');"
										+"var A=document.getElementById('itemClickButton');"
										+"}"
										+"B.action=C;"
										+"A.click();"										
										+"}",url,window,method
									  );
	}

}