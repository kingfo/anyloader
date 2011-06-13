package anyloader.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class DecoderEvent extends Event {
		
		public static const CANCEL: String = 'cancel';
		
		public function DecoderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new DecoderEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("DecoderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}