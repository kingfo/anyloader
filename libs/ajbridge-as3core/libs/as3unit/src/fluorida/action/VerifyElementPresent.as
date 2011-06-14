package fluorida.action {
	public class VerifyElementPresent extends Action {
		protected override function doRun(args:Array) : void {
			_accessor.$$(args[0]);
		}
	}
}