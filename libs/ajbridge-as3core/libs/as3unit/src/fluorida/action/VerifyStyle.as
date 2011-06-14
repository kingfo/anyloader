package fluorida.action {
	import mx.core.UIComponent;

	public class VerifyStyle extends Action {
		protected override function doRun(args:Array) : void {
			var element:UIComponent = UIComponent(_accessor.$$(args[0]));
			var styleName:String = args[1];
			var expectedValue:String = args[2];
			
			assertEquals(expectedValue, element.getStyle(styleName).toString());
		}		
	}
}