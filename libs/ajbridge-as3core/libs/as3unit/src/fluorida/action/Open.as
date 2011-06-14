package fluorida.action {
	public class Open extends Action {
		protected override function doRun(args:Array) : void {
			var url:String = args.shift();
			_accessor.getAutContainer().load(url);
		}
		
		protected override function getSuccessIndicator() : Function {
			return autReady;	
		}
		
		private function autReady():Boolean {
			return _accessor.getAut() != null;
		}
	}
}