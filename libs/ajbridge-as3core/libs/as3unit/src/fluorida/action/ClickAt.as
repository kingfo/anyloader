package fluorida.action {
	import flash.events.MouseEvent;
	
	public class ClickAt extends Action {
		protected override function doRun(args:Array) : void {
			var locator:String = args.shift();
			var x:int = parseInt(args.shift());
			var y:int = parseInt(args.shift());
			
			var clickEvent:MouseEvent = new MouseEvent(MouseEvent.CLICK);
			clickEvent.localX = x;
			clickEvent.localY = y;
			_accessor.$$(locator).dispatchEvent(clickEvent);
		}	
	}	
}