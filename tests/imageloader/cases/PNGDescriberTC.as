package cases {
	import anyloader.decoders.PNGDescriber;
	import anyloader.events.DescriberEvent;
	import asunit.framework.TestCase;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class PNGDescriberTC extends TestCase {
		
		public function PNGDescriberTC(testMethod:String = null) {
			super(testMethod);
		}
		
		
		public function testEntry(): void {
			urlStream.addEventListener(Event.COMPLETE, addAsync(onComplete));
			urlStream.addEventListener(ProgressEvent.PROGRESS,onProgress);
			describer.addEventListener(DescriberEvent.CAPTURE, addAsync(onCapture,3000));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, addAsync(onLoader,4000));
			
			urlStream.load(new URLRequest("assets/image.png"));
		}
		
		private function onProgress(e:ProgressEvent):void {
			urlStream.readBytes(bytes, bytes.length);
			bytes.position = 8; // skip PNG HEADER
			describer.listen(bytes);
		}
		
		private function onCapture(e:DescriberEvent):void {
			//trace(describer.width,describer.height)
		}
		
		
		
		private function onComplete(e:Event):void {
			
			urlStream.readBytes(bytes, bytes.length);
			
			describer.listen(bytes);
			
			bytes.position = 0;
			loader.loadBytes(bytes);
			
			
		}
		
		private function onLoader(e: Event): void {
			assertEquals(loader.width, describer.width);
			assertEquals(loader.height, describer.height);
		}
		
		private var bytes: ByteArray = new ByteArray();
		private var loader: Loader = new Loader();
		private var describer: PNGDescriber = new PNGDescriber();
		private var urlStream: URLStream = new URLStream();
	}

}