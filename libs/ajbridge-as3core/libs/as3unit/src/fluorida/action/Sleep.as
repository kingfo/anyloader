package fluorida.action {
	public class Sleep extends Action {
		private var toSleep:int;
		private var startTime:Date;
	
		protected override function doRun(args:Array) : void {
			toSleep = parseInt(args[0]);
			startTime = new Date();
		}
		
		protected override function getSuccessIndicator() : Function {
			return wake;	
		}
		
		private function wake():Boolean {
			var currentTime:Date = new Date();
			return currentTime.getTime() >= startTime.getTime() + toSleep * 1000;
		}
	}
}