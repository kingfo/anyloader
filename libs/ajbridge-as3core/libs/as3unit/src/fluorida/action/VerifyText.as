package fluorida.action {
	public class VerifyText extends VerifyElementProperty {
		protected override function doRun(args:Array) : void {
			verifyElementProperty(args[0], "text", args[1]);
		}		
	}
}