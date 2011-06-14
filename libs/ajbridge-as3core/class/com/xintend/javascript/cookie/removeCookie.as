package com.xintend.javascript.cookie {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public function removeCookie(name, domain, path, secure) {
			setCookie(name, '', 0, domain, path, secure);
	}

}