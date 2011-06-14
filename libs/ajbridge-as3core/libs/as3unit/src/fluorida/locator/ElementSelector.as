package fluorida.locator
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	
	public class ElementSelector extends Selector
	{
		public function ElementSelector( type : String, elementCssDes : String )
		{
			_typeSelector = new TypeSelector(type);
			_elementCssDes = elementCssDes;
		}
		
		public override function match(element:DisplayObject) : Boolean {
			if(!_typeSelector.match(element)) {
				return false;
			}
			
			var container : DisplayObjectContainer = element as DisplayObjectContainer;
			if ( container )
			{
				var selector:Selector = Selector.parse(_elementCssDes);
				var result:Array = selector.select(container);
				if(result.length != 0) {
					return true;
				}
			} 
			
			return false;
		}
		
		private var _typeSelector:TypeSelector;
		private var _elementCssDes : String;

	}
}