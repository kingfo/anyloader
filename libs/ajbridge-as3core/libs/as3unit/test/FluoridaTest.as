package {
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import fluorida.locator.Selector;
	import fluorida.util.HeadFileImporter;
	import fluorida.util.TestLoader;
	
	import mx.controls.Alert;
	
	public class FluoridaTest extends TestCase {
     	public function FluoridaTest(methodName:String) {
     		super(methodName);
 		}
     
        public static function suite() : TestSuite {
            var testSuite:TestSuite = new TestSuite();
			testSuite.addTest(new FluoridaTest("testLoadFile"));
			testSuite.addTest(new FluoridaTest("testSplitLine"));
			testSuite.addTest(new FluoridaTest("testLoadTestSuite"));
			testSuite.addTest(new FluoridaTest("testMapAccess"));
			testSuite.addTest(new FluoridaTest("testRegexp"));
			testSuite.addTest(new FluoridaTest("testCreateSelector"));
			
			testSuite.addTest(new ReportingTest("testXMLReport"));
            return testSuite;
        }
        
        public function testLoadFile() : void {
        	var request:URLRequest = new URLRequest("sample/suite.fls");
		    var loader:URLLoader = new URLLoader();
		    loader.addEventListener("complete", addAsync(verifyLoader, 1000, {loader: loader}));
		    loader.load(request);
		}
		
		private function verifyLoader(event:Event, data:Object) : void {
			var loader:URLLoader = data.loader as URLLoader;
		    assertEquals("sample/success_case.flt\r\nsample/error_case.flt\r\nsample/fail_case.flt", loader.data);
		}
		
		public function testSplitLine() : void {
			var line:String = "|action|arg1|arg2|";	
			var array:Array = line.split("|");
			assertEquals(5, array.length);
			assertEquals("", array[0]);
		}
		
		public function testLoadTestSuite() : void {
			var testLoader:TestLoader = new TestLoader(".");
			testLoader.addEventListener(Event.COMPLETE, addAsync(verifyTestLoader, 1000, {loader: testLoader}));
			testLoader.load("sample/suite.fls");
		}
		
		private function verifyTestLoader(event:Event, data:Object) : void {
			TestStatics.verifyTestLoader(data.loader);
		}
		
		public function testMapAccess() : void {
			var map:Object = {
				testCase:TestCase,
				testSuite:TestSuite
			};
			assertEquals(TestCase, map['testCase']);	
		}
		
		public function testRegexp() : void {
			assertTrue(new RegExp(".?ell.*$").test("hello"));
			assertTrue(Selector.TYPE_SELECTOR_PATTERN.test("Button"));
			assertEquals("", Selector.TYPE_SELECTOR_PATTERN.exec("Button")[2]);
			
			var matches:Array = Selector.ATTRIBUTE_SELECTOR_PATTERN.exec("Button[id='button']");
			assertEquals("Button", matches[1]);
			assertEquals("id", matches[2]);
			assertEquals("button", matches[3]);
			
			matches = Selector.TYPE_SELECTOR_PATTERN.exec("VBox > Button[name='helloButton']");
			assertEquals("VBox", matches[1]);
			assertEquals("Button[name='helloButton']", matches[2]);
			
		}
		
		public function testCreateSelector() : void {
			var selector:Selector = Selector.parse("myId");
			assertEquals("fluorida.locator::SimpleSelector", getQualifiedClassName(selector));

			selector = Selector.parse("css=Button");
			assertEquals("fluorida.locator::TypeSelector", getQualifiedClassName(selector));
			
			selector = Selector.parse("css=*");
			assertEquals("fluorida.locator::TypeSelector", getQualifiedClassName(selector));
			
			selector = Selector.parse("css=Button[id='button']");
			assertEquals("fluorida.locator::AttributeSelector", getQualifiedClassName(selector));
			
			selector = Selector.parse("css=VBox Button[id='button']");
			assertEquals("fluorida.locator::TypeSelector", getQualifiedClassName(selector));
			
			selector = Selector.parse("css=VBox[id='box'] Button");
			assertEquals("fluorida.locator::AttributeSelector", getQualifiedClassName(selector));
		}
		
	}
}