package fluorida.action {
	import fluorida.framework.AssertionError;
	
	public class Fail extends Action {
		private var _message:String;
		
		public function Fail(message:String = null) {
			_message = message;
		}
		
		protected override function doRun(args:Array) : void {
			fail(getMessage(args));
		}	
		
		private function getMessage(args:Array) : String {
			if(_message != null) {
				return _message;
			}
			if(args.length > 0) {
				return args[0];
			}
			return "";
		}
	}
}