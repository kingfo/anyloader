package fluorida.locator {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import fluorida.util.ArrayUtil;

	public class Selector {
		public static var ATTRIBUTE_SELECTOR_PATTERN:RegExp = /^(\w+|\*)\[(\w+)=[\"|\'](.+?)[\"|\']\]\s?>?\s*(.*)/;
		public static var TYPE_SELECTOR_PATTERN:RegExp = /^(\w+|\*)\s?>?\s*(.*)/;
		public static var ELEMENT_SELECTOR_PATTERN:RegExp = /^(\w+|\*)\s?{([^}]*)}\s?>?\s*(.*)/;
			
		public static function parse(desc:String) : Selector {
			var simpleSelectorPattern:RegExp = /^\w+$/;
			if(simpleSelectorPattern.test(desc)) {
				return new SimpleSelector(desc);
			} 
			
			var cssSelectorPattern:RegExp = /^css=(.*)$/;
			if(cssSelectorPattern.test(desc)) {
				return parseCssSelector(cssSelectorPattern.exec(desc)[1]);
			}
			
			throw new Error("Invalid selector description: " + desc);
		}
		
		private static function parseCssSelector(cssDesc:String) : Selector {
			var selector:Selector;
			var matches:Array;
			var remainingDesc:String;
			
			if(ATTRIBUTE_SELECTOR_PATTERN.test(cssDesc)) {
				matches = ATTRIBUTE_SELECTOR_PATTERN.exec(cssDesc);
				selector = new AttributeSelector(matches[1], matches[2], matches[3]);
				remainingDesc = matches[4];
			} else if ( ELEMENT_SELECTOR_PATTERN.test( cssDesc ) ) {
				matches = ELEMENT_SELECTOR_PATTERN.exec(cssDesc);
				selector = new ElementSelector(matches[1], matches[2]);
				remainingDesc = matches[3];
			} else if(TYPE_SELECTOR_PATTERN.test(cssDesc)) {
				matches = TYPE_SELECTOR_PATTERN.exec(cssDesc);
				selector = new TypeSelector(matches[1]);
				remainingDesc = matches[2];
			} 
			
			if(selector == null) {
				throw new Error("Invalid css selector description: " + cssDesc);
			}
			
			if(remainingDesc != "") {
				selector.setChildSelector(parseCssSelector(remainingDesc));
			}
			return selector;
		}
		
		private static function recursiveSelect(selector:Selector, container:DisplayObjectContainer, result:Array) : void {
			selectChildren(selector, container, result);
			for(var cursor:int = 0; cursor < container.numChildren; cursor++) {
				var child:DisplayObject = container.getChildAt(cursor);
				var subContainer:DisplayObjectContainer = child as DisplayObjectContainer;
				if(subContainer == null) {
					continue;	
				}
				recursiveSelect(selector, subContainer, result);
			}
		}
		
		private static function selectChildren(selector:Selector, container:DisplayObjectContainer, result:Array) : void {
			for(var cursor:int = 0; cursor < container.numChildren; cursor++) {
				var child:DisplayObject = container.getChildAt(cursor);
				if(selector.match(child)) {
					if(selector.getChildSelector() == null) {
						result.push(child);
					} else {
						var subContainer:DisplayObjectContainer = child as DisplayObjectContainer;
						if(subContainer == null) {
							continue;
						}
						var matchedChildren:Array = new Array();
						selectChildren(selector.getChildSelector(), subContainer, matchedChildren);
						ArrayUtil.pushAll(result, matchedChildren);
					}
				}
			}
		}
		
		private var childSelector:Selector;
		
		private function setChildSelector(selector:Selector) : void {
			childSelector = selector;
		}
		
		private function getChildSelector() : Selector {
			return childSelector;
		}
		
		public function select(container:DisplayObjectContainer) : Array {
			var result:Array = new Array();
			recursiveSelect(this, container, result);
			return result;
		}
		
		public function match(element:DisplayObject) : Boolean {
			throw new Error("This function should never be invoked.");
		}
	}
}