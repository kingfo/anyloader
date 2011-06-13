package cases {
	import anyloader.contents.ContentInfo;
	import anyloader.events.AnyLoaderEvent;
	import anyloader.loaders.AnyLoader;
	import asunit.framework.TestCase;
	import flash.events.Event;
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class AnyLoaderTC extends TestCase {
		
		public function AnyLoaderTC(testMethod:String = null) {
			super(testMethod);
		}
		
		public function testLaunch(): void {
			var loader: AnyLoader = new AnyLoader();
			var idx: int = 0;
			var curSrc: String;
			loader.addEventListener(AnyLoaderEvent.ITEM, addAsync(function (e: AnyLoaderEvent): void {
																		curSrc = assets[idx];
																		assertEquals(curSrc, e.info.src);
																		
																	}));
			loader.addEventListener(AnyLoaderEvent.ITEM_COMPLETE, addAsync(function (e:AnyLoaderEvent):void {
																		assertEquals(curSrc, e.info.src);
																		idx++;
																	}));
			loader.addEventListener(AnyLoaderEvent.FINISH, addAsync(function (e: AnyLoaderEvent): void {
																		assertEquals(assets.length, loader.itemTotal);
																		assertFalse(loader.isRunning);
																		assertTrue(loader.itemTotal >= loader.itemLoaded);
																	}));
			
			loader.auto = true;
			var info: ContentInfo;
			for (var i: int = 0; i < assets.length; i++ ) {
				info = new ContentInfo();
				info.setSrc(assets[i]);
				loader.add(info);
			}
			loader.launch();
			assertTrue(loader.isRunning);
		}
		
		
		public function testAuto(): void {
			var loader: AnyLoader = new AnyLoader();
			var idx: int = 0;
			var curSrc: String;
			
			loader.addEventListener(AnyLoaderEvent.ITEM, addAsync(function (e: AnyLoaderEvent): void {
																		curSrc = assets[idx];
																		assertEquals(curSrc, e.info.src);
																	}));
			loader.addEventListener(AnyLoaderEvent.ITEM_COMPLETE, addAsync(function (e:AnyLoaderEvent):void {
																		assertEquals(curSrc, e.info.src);
																		idx++;
																	}));
			loader.addEventListener(AnyLoaderEvent.FINISH, addAsync(function (e:AnyLoaderEvent):void {
																		assertEquals(assets.length, loader.itemTotal);
																		assertFalse(loader.isRunning);
																		assertTrue(loader.itemTotal >= loader.itemLoaded);
																	}));
			
			loader.auto = true;
			var info: ContentInfo;
			for (var i: int = 0; i < assets.length; i++ ) {
				info = new ContentInfo();
				info.setSrc(assets[i]);
				loader.add(info);
			}
			assertTrue(loader.isRunning);
		}
		
		public function testInsert(): void {
			var loader: AnyLoader = new AnyLoader();
			var idx: int = 0;
			var curSrc: String;
			
			loader.addEventListener(AnyLoaderEvent.ITEM, addAsync(function (e: AnyLoaderEvent): void {
																		curSrc = assets[idx];
																		assertEquals(curSrc, e.info.src);
																	}));
			loader.addEventListener(AnyLoaderEvent.ITEM_COMPLETE, addAsync(function (e:AnyLoaderEvent):void {
																		assertEquals(curSrc, e.info.src);
																		idx++;
																	}));
			loader.addEventListener(AnyLoaderEvent.FINISH, addAsync(function (e: AnyLoaderEvent): void {
																		assertEquals(assets.length, loader.itemTotal);
																		assertFalse(loader.isRunning);
																		assertTrue(loader.itemTotal >= loader.itemLoaded);
																	}));
			
			var info: ContentInfo;
			var list: Array = [];
			for (var i: int = 0; i < assets.length; i++ ) {
				info = new ContentInfo();
				info.setSrc(assets[i]);
				list.push(info);
			}
			list.push(1,2,3);
			loader.insert(list);
			loader.launch();
			assertTrue(loader.isRunning);
		}
		
		
		public function testRemoveOn(): void {
			var loader: AnyLoader = new AnyLoader();
			var idx: int = 0;
			var curSrc: String;
			var target: uint = 3;
			
			loader.addEventListener(AnyLoaderEvent.ITEM, addAsync(function (e: AnyLoaderEvent): void {
																		
																		if (idx >= target) {
																			curSrc = assets[idx + 1];
																		}else {
																			curSrc = assets[idx];
																		}
																		assertEquals(curSrc, e.info.src);
																	}));
			loader.addEventListener(AnyLoaderEvent.ITEM_COMPLETE, addAsync(function (e:AnyLoaderEvent):void {
																		assertEquals(curSrc, e.info.src);
																		idx++;
																	}));
			loader.addEventListener(AnyLoaderEvent.FINISH, addAsync(function (e: AnyLoaderEvent): void {
																		assertEquals(assets.length, loader.itemTotal);
																		assertFalse(loader.isRunning);
																		assertTrue(loader.itemTotal >= loader.itemLoaded);
																	}));
			
			var info: ContentInfo;
			for (var i: int = 0; i < assets.length; i++ ) {
				info = new ContentInfo();
				info.setSrc(assets[i]);
				loader.add(info);
			}
			loader.launch();
			assertTrue(loader.isRunning);
			loader.removeOn('src',assets[target]);
		}
		
		
		public function testExec(): void {
			var loader: AnyLoader = new AnyLoader();
			var count: int = 0;
			
			loader.addEventListener(AnyLoaderEvent.ITEM_COMPLETE, addAsync(function (e:AnyLoaderEvent):void {
																		if (assets[3] == e.info.src) count++;
																	}));
			loader.addEventListener(AnyLoaderEvent.FINISH, addAsync(function (e: AnyLoaderEvent): void {
																		assertEquals(2, count);
																	}));
			var info: ContentInfo;
			for (var i: int = 0; i < assets.length; i++ ) {
				info = new ContentInfo();
				info.setSrc(assets[i]);
				loader.add(info);
			}
			info = new ContentInfo();
			info.setSrc(assets[3]);
			loader.launch();
			loader.exec(info);
			assertTrue(loader.isRunning);
		}
		
		public function testForceClear(): void {
			var loader: AnyLoader = new AnyLoader();
			
			loader.addEventListener(AnyLoaderEvent.ITEM_CANCEL, addAsync());
			
			var info: ContentInfo;
			for (var i: int = 0; i < assets.length; i++ ) {
				info = new ContentInfo();
				info.setSrc(assets[i]);
				loader.add(info);
			}
			loader.launch();
			assertTrue(loader.isRunning);
			loader.clear(true);
			assertFalse(loader.isRunning);
			assertEquals(0,loader.itemTotal);
		}
		
		public function testNonForceClear(): void {
			var loader: AnyLoader = new AnyLoader();
			
			loader.addEventListener(AnyLoaderEvent.FINISH, addAsync());
			
			var info: ContentInfo;
			for (var i: int = 0; i < assets.length; i++ ) {
				info = new ContentInfo();
				info.setSrc(assets[i]);
				loader.add(info);
			}
			
			loader.launch();
			assertTrue(loader.isRunning);
			loader.clear(false);
			assertFalse(loader.isRunning);
			assertEquals(0,loader.itemTotal);
		}
		
		public function testForceClose(): void {
			var loader: AnyLoader = new AnyLoader();
			
			loader.addEventListener(AnyLoaderEvent.ITEM_CANCEL, addAsync());
			
			var info: ContentInfo;
			for (var i: int = 0; i < assets.length; i++ ) {
				info = new ContentInfo();
				info.setSrc(assets[i]);
				loader.add(info);
			}
			loader.launch();
			assertTrue(loader.isRunning);
			loader.close(true);
			assertFalse(loader.isRunning);
			assertTrue(loader.itemTotal > 0);
		}
		
		public function testNonForceClose(): void {
			var loader: AnyLoader = new AnyLoader();
			
			loader.addEventListener(AnyLoaderEvent.FINISH, addAsync());
			
			var info: ContentInfo;
			for (var i: int = 0; i < assets.length; i++ ) {
				info = new ContentInfo();
				info.setSrc(assets[i]);
				loader.add(info);
			}
			
			loader.launch();
			assertTrue(loader.isRunning);
			loader.close(false);
			assertFalse(loader.isRunning);
			assertTrue(loader.itemTotal > 0);
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