package fluorida.locator {
	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;
	

	public class TypeSelector extends Selector {
		private var _type:String;
	
		public function TypeSelector(type:String) {
			_type = type;
		}
		
		public override function match(element:DisplayObject) : Boolean {
			if(_type == "*") {
				return true;
			}
			
			var className:String = getQualifiedClassName(element);
			var typePattern:RegExp = new RegExp(".*::" + _type);
			return typePattern.test(className) 
					|| className == _type;
		} 
	}
}