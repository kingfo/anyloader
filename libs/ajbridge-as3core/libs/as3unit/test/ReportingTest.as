package {
	import fluorida.framework.AssertionError;
	import fluorida.framework.TestCase;
	import fluorida.framework.TestSuite;
	import fluorida.framework.TestResult;

	public class ReportingTest extends FluoridaTest {
     	public function ReportingTest(methodName:String) {
     		super(methodName);
 		}
     
        public function testXMLReport() : void {
        	var case1:TestCase = new TestCase("case1");
        	var case2:TestCase = new TestCase("case2");
        	var case3:TestCase = new TestCase("case3");
        	
        	var suite:TestSuite = new TestSuite("mySuite");
        	suite.addTestCase(case1);
        	suite.addTestCase(case2);
        	suite.addTestCase(case3);
        	
        	var result:TestResult = new TestResult(suite);
        	result.addError(case2, new Error("an error"));
        	result.addFailure(case3, new AssertionError("an failure"));
        	assertNotNull(result.toXml());
        	
        	var root:XML = result.toXml();
        	assertEquals("testsuite", root.localName());
        	assertEquals("mySuite", root.attribute("name"));
        	assertEquals("3", root.attribute("tests"));
        	assertEquals("1", root.attribute("errors"));
        	assertEquals("1", root.attribute("failures"));
        	
        	var children:XMLList = root.children();
        	assertEquals(3, children.length());
        	var names:XMLList = children.attribute("name");
        	assertTrue(names.contains("case1"));
        	assertTrue(names.contains("case2"));
        	assertTrue(names.contains("case3"));
        	
        	var failureNodes:XMLList = children.children();
        	assertEquals(2, failureNodes.length());
		}
		
	}
}