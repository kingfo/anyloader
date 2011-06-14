package fluorida.action {
	import fluorida.util.WaitAndRun;

	public class SetTimeout extends Action {
		protected override function doRun(args:Array) : void {
			var timeout:int = parseInt(args.shift());
			WaitAndRun.defaultTimeout = timeout;
		}	
	}	
}