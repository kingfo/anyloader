package anyloader.loaders {
	import anyloader.contents.ContentInfo;
	import anyloader.contents.ContentStream;
	import anyloader.contents.ImageInfo;
	import anyloader.decoders.DecoderLink;
	import anyloader.decoders.DecoderPool;
	import anyloader.decoders.GIFDescriber;
	import anyloader.decoders.ImageDescriber;
	import anyloader.decoders.ImageHeaderChunk;
	import anyloader.decoders.JPEGDescriber;
	import anyloader.decoders.PNGDescriber;
	import anyloader.events.AnyLoaderEvent;
	import anyloader.events.DescriberEvent;
	import flash.events.ProgressEvent;
	/**
	 * 图片类型文件下载
	 * @author kingfo oicuicu@gmail.com
	 */
	public class ImageLoader extends AnyLoader {
		
		

		public function ImageLoader() {
			
			pool.add(new DecoderLink(ImageHeaderChunk.JPEG, JPEGDescriber));
			pool.add(new DecoderLink(ImageHeaderChunk.PNG,PNGDescriber));
			pool.add(new DecoderLink(ImageHeaderChunk.GIF, GIFDescriber));
			
			
		}
		
		override protected function configContentStream(content:ContentStream,info: ContentInfo): ContentStream {
			content.addEventListener(ProgressEvent.PROGRESS, onProgress);
			var describer: ImageDescriber = new ImageDescriber();
			describer.setHost(content);
			describer.setDecoderPool(pool);
			describer.addEventListener(DescriberEvent.CAPTURE, onCapture);
			info.setDescriber(describer);
			
			return super.configContentStream(content,info);
		}
		
		private function onProgress(e: ProgressEvent): void {
			// 处理并解析
			var content: ContentStream =  e.target as ContentStream;
			decode(content);
		}
		
		
		private function onCapture(e: DescriberEvent): void {
			var desc: ImageDescriber = e.target as ImageDescriber;
			desc.removeEventListener(AnyLoaderEvent.ITEM_CAPTURE,onCapture);
			var cnt: ContentStream = desc.host;
			if (!cnt)return ;
			dispatchEvent(new AnyLoaderEvent(AnyLoaderEvent.ITEM_CAPTURE,cnt.info));
		}
		
		override protected function itemComplete(content: ContentStream): void {
			decode(content);
			super.itemComplete(content);
		}
		
		private function decode(content: ContentStream): void {
			var info: ImageInfo = content.info as ImageInfo;
			var describer: ImageDescriber = info.describer as ImageDescriber;
			describer.listen(content);
		}
		
		
		private var type: String;
		private var pool: DecoderPool = new DecoderPool();
		
		
		
		
	}

}