package  {
	import asunit.framework.TestSuite;
	import cases.AnyLoaderTC;
	import cases.DecoderPoolTC;
	import cases.ExifJPEGDescriberTC;
	import cases.GIFDescriberTC;
	import cases.ImageLoaderTC;
	import cases.JPEGDescriberTC;
	import cases.PNGDescriberTC;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public class AllTests extends TestSuite {
		
		public function AllTests() {
			super();
			
			/* Utils */
			addTest(new DecoderPoolTC());
			
			/* Describers */
			addTest(new GIFDescriberTC());
			addTest(new JPEGDescriberTC());
			addTest(new ExifJPEGDescriberTC());
			addTest(new PNGDescriberTC());
			
			/* Loaders */
			addTest(new AnyLoaderTC());
			addTest(new ImageLoaderTC());
			
		}
		
	}

}