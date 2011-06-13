package anyloader.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class DescriberEvent extends Event {
		
		public static const CAPTURE: String = 'capture';
		public static const ABANDON: String = 'abandon';
		
		public function DescriberEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event { 
			return new DescriberEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("DescriberEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}