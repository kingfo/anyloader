package fluorida.action {
	public class WaitForElementPresent extends Action {
		private var locator:String;
	
		protected override function doRun(args:Array) : void {
			locator = args[0];
		}
		
		protected override function getSuccessIndicator() : Function {
			return check;
		}
		
		private function check() : Boolean {
			try {
				_accessor.$$(locator);
			} catch (error:Error) {
				return false;
			}
			return true;
		}
	}
}