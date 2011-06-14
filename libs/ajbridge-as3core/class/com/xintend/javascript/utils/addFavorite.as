package com.xintend.javascript.utils {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	import com.xintend.javascript.ExternalInterfaceWarp;
	public function addFavorite() {
		ExternalInterfaceWarp.call("function addFav(C){"
									+"var url = document.location.href;"
									+"if (window.sidebar) {"
									+"window.sidebar.addPanel(C, url,'');"
									+"} else if( document.all ) {"
									+"window.external.AddFavorite( url, C);"
									+"} else if( window.opera && window.print ) {"										
									+"return true;}"										
									+"}",title
								);	
	}

}