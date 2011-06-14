package {
	import flexunit.framework.Assert;
	
	import fluorida.framework.TestSuite;
	import fluorida.framework.TestCase;
	import fluorida.util.TestLoader;
	
	public class TestStatics {
		public static function verifyTestLoader(obj:Object) : void {
			Assert.assertNotNull(obj);
			var loader:TestLoader = obj as TestLoader;
			Assert.assertNotNull(loader);
			
			var suite:TestSuite = loader.getSuite();
			Assert.assertNotNull(suite);
			Assert.assertEquals(3, suite.countTestCases());

			var successCase:TestCase = suite.getTestCases()[0];
			var errorCase:TestCase = suite.getTestCases()[1];
			Assert.assertEquals("sample/success_case.flt", successCase.getName());
			Assert.assertEquals(2, errorCase.countCommands());
			
			var commands:Array = successCase.getCommands();
			Assert.assertEquals("open", commands[0].getAction());
			Assert.assertEquals("click", commands[1].getAction());
			Assert.assertEquals("verifyText", commands[2].getAction());
		}
	}
}