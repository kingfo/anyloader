package {
	import flash.utils.getQualifiedClassName;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import fluorida.locator.Selector;
	
	public class RegExpTest extends TestCase {
     	public function RegExpTest(methodName:String) {
     		super(methodName);
 		}
     
        public static function suite() : TestSuite {
            var testSuite:TestSuite = new TestSuite();
			testSuite.addTest(new RegExpTest("testRegexp"));
			
            return testSuite;
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
			
			matches = Selector.ATTRIBUTE_SELECTOR_PATTERN.exec("Button[id='button'] > Label[name='aa']");
			assertEquals("Button", matches[1]);
			assertEquals("id", matches[2]);
			assertEquals("button", matches[3]);
			
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