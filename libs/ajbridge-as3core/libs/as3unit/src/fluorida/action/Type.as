package fluorida.action {
	public class Type extends Action {
		protected override function doRun(args:Array) : void {
			_accessor.$$(args[0])['text'] = args[1];
		}	
	}	
}