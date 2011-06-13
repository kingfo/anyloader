package anyloader.decoders {
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class ImageHeaderChunk {
		public static const PNG: Array = [0x89,0x50,0x4E,0x47,0x0D,0x0A,0x1A,0x0A];
		public static const GIF: Array = [0x47, 0x49, 0x46];
		public static const JPEG: Array = [0xFF,0xD8];
	}

}