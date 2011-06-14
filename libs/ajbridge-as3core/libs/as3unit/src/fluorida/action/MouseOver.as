package fluorida.action {
	import flash.events.MouseEvent;
	
	public class MouseOver extends Action {
		protected override function doRun(args:Array) : void {
			var locator:String = args.shift();
			var mouseOverEvent:MouseEvent = new MouseEvent(MouseEvent.MOUSE_OVER);
			_accessor.$$(locator).dispatchEvent(mouseOverEvent);
		}	
	}	
}