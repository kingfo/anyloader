package fluorida.util {
	public class Config {
		private var _xml:XML;
		
		public function Config(xmlString:String) {
			_xml = new XML(xmlString);
		}
		
		public function getResultUrl() : String {
			return getAttribute("postResultTo");
		}
		
		public function getBaseUrl() : String {
			return getAttribute("baseUrl", ".");
		}
		
		private function getAttribute(key:String, defaultValue:String = "") : String {
			var value:String = _xml.attribute(key);
			if(value == "") {
				return defaultValue;
			}
			return value;
		}
	}
}