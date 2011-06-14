package fluorida.action {
	import flash.events.MouseEvent;
	
	public class MouseOut extends Action {
		protected override function doRun(args:Array) : void {
			var locator:String = args.shift();
			var mouseOutEvent:MouseEvent = new MouseEvent(MouseEvent.MOUSE_OUT);
			_accessor.$$(locator).dispatchEvent(mouseOutEvent);
		}	
	}	
}