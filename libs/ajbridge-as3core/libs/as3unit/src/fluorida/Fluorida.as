package fluorida {
	import flash.events.Event;
    import mx.core.Application;

	import fluorida.framework.TestSuite;
	import fluorida.publisher.Publisher;
	import fluorida.util.TestLoader;
	import fluorida.util.FileLoader;
	import fluorida.util.Config;
	
	public class Fluorida {
		private var _application:Application;
		private var _testLoader:TestLoader;
		private var _publisher:Publisher;
		private var _config:Config;
		private var _suiteUrl:String;
		
		public function Fluorida(application:Application) {
			_application = application;
		}
		
		public function start(url:String) : void {
			_suiteUrl = url;
			new FileLoader(this, configLoadComplete).load("config.xml");
		}
		
		private function configLoadComplete(data:String) : void {
			_config = new Config(data);
			_publisher = Publisher.create(_config.getResultUrl());
			runTestSuite(_suiteUrl);
		}
		
		private function runTestSuite(url:String) : void {
			_testLoader = new TestLoader(_config.getBaseUrl());
			_testLoader.addEventListener(Event.COMPLETE, suiteLoaded);
			_testLoader.load(url);
		}
		
		private function suiteLoaded(event:Event) : void {
			var testSuite:TestSuite = _testLoader.getSuite();
			testSuite.setApplication(_application);
			testSuite.setPublisher(_publisher);
			testSuite.run();
		}
	}	
}