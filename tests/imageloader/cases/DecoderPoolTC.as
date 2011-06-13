package cases {
	import anyloader.decoders.DecoderLink;
	import anyloader.decoders.DecoderPool;
	import anyloader.decoders.GIFDescriber;
	import anyloader.decoders.ImageHeaderChunk;
	import anyloader.decoders.JPEGDescriber;
	import anyloader.decoders.PNGDescriber;
	import asunit.framework.TestCase;
	
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class DecoderPoolTC extends TestCase {
		
		public function DecoderPoolTC(testMethod:String = null) {
			super(testMethod);
		}
		
		public function testEntry(): void {
			var pool: DecoderPool = new DecoderPool();
			
			pool.add(new DecoderLink(ImageHeaderChunk.JPEG, JPEGDescriber));
			pool.add(new DecoderLink(ImageHeaderChunk.GIF, GIFDescriber));
			pool.add(new DecoderLink(ImageHeaderChunk.PNG, PNGDescriber));
			
			assertEquals(3,pool.size);
			
			assertTrue(ImageHeaderChunk.JPEG.length < ImageHeaderChunk.GIF.length);
			assertTrue(ImageHeaderChunk.GIF.length < ImageHeaderChunk.PNG.length);
			
			assertEquals(1, pool.getLinks('codeLength', ImageHeaderChunk.JPEG.length, DecoderPool.EQ).length);
			assertEquals(1, pool.getLinks('codeLength', ImageHeaderChunk.GIF.length, DecoderPool.EQ).length);
			assertEquals(1, pool.getLinks('codeLength', ImageHeaderChunk.PNG.length, DecoderPool.EQ).length);
			
			assertEquals(1, pool.getLinks('codeLength', ImageHeaderChunk.JPEG.length, DecoderPool.SE).length);
			assertEquals(1, pool.getLinks('codeLength', ImageHeaderChunk.GIF.length, DecoderPool.SE).length);
			assertEquals(1, pool.getLinks('codeLength', ImageHeaderChunk.PNG.length, DecoderPool.SE).length);
			
			assertEquals(3, pool.getLinks('codeLength', ImageHeaderChunk.JPEG.length, DecoderPool.GE).length);
			assertEquals(2, pool.getLinks('codeLength', ImageHeaderChunk.GIF.length, DecoderPool.GE).length);
			assertEquals(1, pool.getLinks('codeLength', ImageHeaderChunk.PNG.length, DecoderPool.GE).length);
			
			assertEquals(2, pool.getLinks('codeLength', ImageHeaderChunk.JPEG.length, DecoderPool.GT).length);
			assertEquals(1, pool.getLinks('codeLength', ImageHeaderChunk.GIF.length, DecoderPool.GT).length);
			assertEquals(0, pool.getLinks('codeLength', ImageHeaderChunk.PNG.length, DecoderPool.GT).length);
			
			assertEquals(1, pool.getLinks('codeLength', ImageHeaderChunk.JPEG.length, DecoderPool.LE).length);
			assertEquals(2, pool.getLinks('codeLength', ImageHeaderChunk.GIF.length, DecoderPool.LE).length);
			assertEquals(3, pool.getLinks('codeLength', ImageHeaderChunk.PNG.length, DecoderPool.LE).length);
			
			assertEquals(0, pool.getLinks('codeLength', ImageHeaderChunk.JPEG.length, DecoderPool.LT).length);
			assertEquals(1, pool.getLinks('codeLength', ImageHeaderChunk.GIF.length, DecoderPool.LT).length);
			assertEquals(2, pool.getLinks('codeLength', ImageHeaderChunk.PNG.length, DecoderPool.LT).length);
			
			assertEquals(2, pool.getLinks('codeLength', ImageHeaderChunk.JPEG.length, DecoderPool.IE).length);
			assertEquals(2, pool.getLinks('codeLength', ImageHeaderChunk.GIF.length, DecoderPool.IE).length);
			assertEquals(2, pool.getLinks('codeLength', ImageHeaderChunk.PNG.length, DecoderPool.IE).length);
			
			assertEquals(2, pool.getLinks('codeLength', ImageHeaderChunk.JPEG.length, DecoderPool.SI).length);
			assertEquals(2, pool.getLinks('codeLength', ImageHeaderChunk.GIF.length, DecoderPool.SI).length);
			assertEquals(2, pool.getLinks('codeLength', ImageHeaderChunk.PNG.length, DecoderPool.SI).length);
		}
		
	}

}