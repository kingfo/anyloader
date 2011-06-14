package fluorida.util
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import fluorida.action.CustomAction;
	import fluorida.framework.TestCase;
	
	public class HeadFileImporter
	{
		private var _testCase : TestCase;
		private var _loader : URLLoader;
		private var _completeCallback : Function;
		
		public function HeadFileImporter( testCase : TestCase ) {
			this._testCase = testCase;
		}
		
		public function load( url : String ) : void {
		    _loader = new URLLoader();
		    _loader.addEventListener( Event.COMPLETE, onComplete );
		    _loader.load( new URLRequest( url ) );
		}
		
		private function onComplete( event : Event ) : void {
			var data:String = _loader.data;
			var customActionStringArray : Array = splitToFunctons( _loader.data );
			for each ( var customActionString : String in customActionStringArray ) {
				var customAction : CustomAction = buildCustomActionByString( customActionString );
				if ( customAction )
					this._testCase.setCustomAction( customAction.name, customAction ); 
			}
			if( _completeCallback != null )
				_completeCallback();
		}
		
		public function set completeCallback( value : Function ) : void {
			this._completeCallback = value;
		}
		
		public function splitToFunctons( string : String ) : Array {
//			var functionBegin = splitToFunctons
			return string.match(/\|def\|.*?\|end\|/gs);
		}
		
		private function buildCustomActionByString( string : String ) : CustomAction {
			var rows:Array = CommandStringUtil.getUsefulRows( string );
			return CommandStringUtil.buildCustomActionByUsefulRows( rows );
		}
		
	}
}