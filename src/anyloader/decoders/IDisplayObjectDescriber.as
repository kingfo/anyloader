package anyloader.decoders {
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public interface IDisplayObjectDescriber extends IDescriber {
		
		function get width(): Number;
		function get height(): Number;
		
	}
	
}