package fluorida.util {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;

	public class FileLoader {
		private var _thisObject:Object;
		private var _handler:Function;
		private var _loader:URLLoader;
		
		public function FileLoader(thisObject:Object, handler:Function) {
			_thisObject = thisObject;
			_handler = handler;
		}
		
		public function load(url:String) : void {
		    _loader = new URLLoader();
		    _loader.addEventListener(Event.COMPLETE, onComplete);
		    _loader.load(new URLRequest(url));
		}
		
		private function onComplete(event:Event) : void {
			var data:String = _loader.data;
			_handler.call(_thisObject, _loader.data);
		}
	}
}