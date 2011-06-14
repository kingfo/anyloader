package fluorida.action {
	public class VerifyElementProperty extends Action {
		protected override function doRun(args:Array) : void {
			verifyElementProperty(args[0], args[1], args[2]);
		}

		protected function verifyElementProperty(elementName:String, propertyName:String, expectedValue:String) : void {
			var element:Object = _accessor.$$(elementName);
			if(!element.hasOwnProperty(propertyName)) {
				fail("Element [" + elementName + "] doesn't have [" + propertyName + "] property.");
			}
			
			var regexpPrefix:String = "regexp:";
			if(expectedValue.indexOf(regexpPrefix) == 0) {
				var expectedPattern:String = expectedValue.substring(regexpPrefix.length);
				assertMatches(expectedPattern, element[propertyName].toString());
			} else {
				assertEquals(expectedValue, element[propertyName].toString());
			}
		}
	}
}