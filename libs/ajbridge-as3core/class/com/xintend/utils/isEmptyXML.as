package com.xintend.utils {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public function isEmptyXML(xml: XML): Boolean {
		return !xml.*.length();
	}

}