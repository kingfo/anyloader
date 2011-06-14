package fluorida.framework {
	import fluorida.util.ArrayUtil;

	public class Command {
		private var _action:String;
		private var _args:Array;
		
		public function Command(action:String, args:Array) {
			_action = action;
			_args = args;
		}
		
		public function getAction() : String {
			return _action;
		}
		
		public function getArgs() : Array {
			return ArrayUtil.copy(_args);
		}
		
		public function toString() : String {
			var result:String = "|" + _action + "|";
			for each(var arg:String in _args) {
				result += (arg + "|");
			}
			return result;
		}
	}
}