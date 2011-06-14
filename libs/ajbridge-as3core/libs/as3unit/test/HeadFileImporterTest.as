package
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import fluorida.util.HeadFileImporter;
	
	import mx.controls.Alert;
	
	public class HeadFileImporterTest extends TestCase
	{
		public function HeadFileImporterTest( methodName : String ) {
			super( methodName );
		}
		public static function suite() : TestSuite {
			var testSuite : TestSuite = new TestSuite();
			testSuite.addTest( new HeadFileImporterTest("testHeadFileImporter") );
			return testSuite;
		}
		
		public function testHeadFileImporter() : void {
			var importer : HeadFileImporter = new HeadFileImporter(null);
			var testString : String = "|def|action|dsakdjaflkjdaflda|\n"+
										"|select|dafdjalkfjdalfja|\n"+
										"|end|\n" +
										"|def|action|dafadfadfa|\n" 
										+"|select|adfadfadsfa|\n"
										+"|end|\n";
//			Alert.show( testString );
//			var array : Array = importer.splitToFunctons(testString);
			var array : Array = testString.match(/\|def\|.*?\|end\|/gs)
			assertNotNull(array);
			Alert.show( "length is " + array.length.toString() );
			for each ( var actionString : String in array )
				Alert.show( "actionString :" +  actionString );
		}
	}
}