package fluorida.action {
	public class WaitForElementProperty extends VerifyElementProperty {
		private var elementName:String;
		private var propertyName:String;
		private var expectedValue:String;

		protected override function doRun(args:Array) : void {
			elementName = args[0];
			propertyName = args[1];
			expectedValue = args[2];
		}		
		
		private function check() : Boolean {
			try {
				verifyElementProperty(elementName, propertyName, expectedValue);
			} catch (error:Error) {
				return false;
			}
			return true;
		}
		
		protected override function getSuccessIndicator() : Function {
			return check;	
		}
		
		protected override function onTimeout() : void {
			verifyElementProperty(elementName, propertyName, expectedValue);
		}		
	}
}