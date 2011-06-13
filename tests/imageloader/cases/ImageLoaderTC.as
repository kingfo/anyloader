package cases {
	import anyloader.contents.ImageInfo;
	import anyloader.events.AnyLoaderEvent;
	import anyloader.events.DescriberEvent;
	import anyloader.loaders.ImageLoader;
	import asunit.framework.TestCase;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class ImageLoaderTC extends TestCase {
		
		public function ImageLoaderTC(testMethod:String = null) {
			super(testMethod);
			
		}
		
		public function testEntry(): void {
			var loader: ImageLoader = new ImageLoader();
			
			loader.addEventListener(AnyLoaderEvent.ITEM, 
									addAsync(function (e:AnyLoaderEvent):void {
										//trace(e.type);
									}));
			loader.addEventListener(AnyLoaderEvent.ITEM_COMPLETE, 
									addAsync(function onItemComplete(e:AnyLoaderEvent):void {
										trace(e.type,e.info);
									}, 3000));
			loader.addEventListener(AnyLoaderEvent.ITEM_CAPTURE, addAsync(function onCapture(e: AnyLoaderEvent): void {
										trace(e.type, e.info);
										assertTrue(e.info.describer.width > 0);
										assertTrue(e.info.describer.height > 0);
										assertTrue(assets.indexOf(e.info.src) > -1);
										assertTrue(assets.indexOf(e.info.src) < assets.length - 1);
									},3000));
			var len: int = assets.length;
			var info: ImageInfo;
			for (var i: int = 0; i < len; i++ ) {
				info = new ImageInfo();
				info.setSrc(assets[i]);
				loader.add(info);
			}
			loader.launch();
		}
		
		
		private var assets: Array = [
										"assets/87a.gif",	
										"assets/89a.gif",	
										"assets/exif.jpg",	
										"assets/image.gif",	//3
										"assets/image.jpeg",
										"assets/image.png",
										"assets/text.html"
									];
	}

}