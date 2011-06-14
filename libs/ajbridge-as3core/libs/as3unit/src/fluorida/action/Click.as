package fluorida.action {
	import flash.events.MouseEvent;
	
	public class Click extends Action {
		protected override function doRun(args:Array) : void {
			var locator:String = args.shift();
			var clickEvent:MouseEvent = new MouseEvent(MouseEvent.CLICK);
			_accessor.$$(locator).dispatchEvent(clickEvent);
		}	
	}	
}