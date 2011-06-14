package fluorida.util {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import fluorida.action.CustomAction;
	import fluorida.framework.Command;
	import fluorida.framework.TestCase;
	import fluorida.framework.TestSuite;
	
	import mx.utils.StringUtil;
	
	public class TestLoader extends EventDispatcher {
		private var _baseUrl:String;
		private var _suiteUrl:String;
		private var _suite:TestSuite;
		private var _cases:Array = new Array();
		
		public function TestLoader(baseUrl:String) {
			_baseUrl = baseUrl;
		}
		
		public function getSuite() : TestSuite {
			return _suite;	
		}

		public function load(url:String) : void {
			_suiteUrl = url;
			new FileLoader(this, createSuite).load(getUrl(_suiteUrl));
		}
		
		private function getUrl(url:String) : String {
			return _baseUrl + "/" + url;
		}
		
		private function createSuite(data:String) : void {
			_suite = new TestSuite(_suiteUrl);
			_cases = CommandStringUtil.getUsefulRows(data).map(createCase);

			for each(var testCase:TestCase in _cases) {
				_suite.addTestCase(testCase);
			}
			
			loadNextCase();
		}
		
		private function loadNextCase() : void {
			if(_cases.length == 0) {
				dispatchEvent(new Event(Event.COMPLETE));
				return ;
			}
			var testCase:TestCase = _cases[0];
			new FileLoader(this, loadTestCase).load(getUrl(testCase.getName()));
		}
		
		private function loadTestCase(string:String) : void {
			var testCase:TestCase = _cases.shift();
			
			new TestCaseBuilder(testCase, string, _baseUrl).build();
			loadNextCase();
		}
		
		private function createCase(element:*, index:int, arr:Array) : TestCase {
            return new TestCase(element as String);
        }
	}
}