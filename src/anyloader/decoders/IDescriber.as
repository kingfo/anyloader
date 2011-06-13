package anyloader.decoders {
	import flash.events.IEventDispatcher;
	import flash.utils.IDataInput;
	
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public interface IDescriber extends IEventDispatcher {
		function get host():*;
		
		function get type(): String;
		 
		function setHost(host:*): void;
		
		function listen(bytes: IDataInput): void;
	}
	
}