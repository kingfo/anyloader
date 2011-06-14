package fluorida.action {
	import flash.events.MouseEvent;
	
	public class DoubleClick extends Action {
		protected override function doRun(args:Array) : void {
			var locator:String = args.shift();
			var clickEvent:MouseEvent = new MouseEvent(MouseEvent.DOUBLE_CLICK);
			_accessor.$$(locator).dispatchEvent(clickEvent);
		}
	}	
}