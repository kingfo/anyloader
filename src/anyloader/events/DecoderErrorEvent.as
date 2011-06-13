package anyloader.events {
	import flash.events.Event;
	import flash.utils.IDataInput;
	
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class DecoderErrorEvent extends Event {
		
		public static const FORMAT_NOT_SUPPORTED: String = "formatNotSupported";
		public static const FORMAT_ERROR: String = "formatError";
		
		public function get source():IDataInput {
			return _source;
		}
		
		public function DecoderErrorEvent(type:String,source:IDataInput, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			_source = source;
		} 
		
		public override function clone():Event { 
			return new DecoderErrorEvent(type, _source, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("DecoderErrorEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		private var _source: IDataInput;
		
		
	}
	
}