package fluorida.locator {
	import flash.display.DisplayObject;

	public class AttributeSelector extends Selector {
		private var _attribute:String;
		private var _expectedValue:String;
		private var _typeSelector:TypeSelector;
		
		public function AttributeSelector(type:String, attribute:String, expectedValue:String) {
			_attribute = attribute;
			_expectedValue = expectedValue;
			_typeSelector = new TypeSelector(type);
		}
		
		public override function match(element:DisplayObject) : Boolean {
			if(!_typeSelector.match(element)) {
				return false;
			}
			if(!element.hasOwnProperty(_attribute)) {
				return false;
			}
			return element[_attribute] == _expectedValue;
		}
	}
}