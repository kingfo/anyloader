package fluorida.locator {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class SimpleSelector extends Selector {
		private var _identifier:String;
	
		public function SimpleSelector(identifier:String) {
			_identifier = identifier;
		}
		
		public override function match(element:DisplayObject) : Boolean {
			if(element.hasOwnProperty("id") && element["id"] == _identifier) {
				return true;
			}
			if(element.name == _identifier) {
				return true;
			}
			return false;
		}
	}
}