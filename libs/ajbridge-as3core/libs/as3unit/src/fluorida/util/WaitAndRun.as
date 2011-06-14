package fluorida.util {
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class WaitAndRun {
		public static var defaultTimeout:int = 30;
	
		private var _condition:Function;
		private var _todo:Function;
		private var _timeoutHandler:Function;
		private var _timer:Timer;

		public function WaitAndRun(condition:Function, todo:Function, timeoutHandler:Function = null, timeout:int = -1) {
			_condition = condition;
			_todo = todo;
			_timeoutHandler = (timeoutHandler == null) ? defaultTimeoutHandler : timeoutHandler;
			
			timeout = (timeout > 0) ? timeout : defaultTimeout;
			_timer = new Timer(100, timeout * 10);
			_timer.addEventListener(TimerEvent.TIMER, check);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
			_timer.start();
		}
	
		private function onTimeout(event:TimerEvent) : void {
			_timeoutHandler.call();
		}
		
		private function check(event:TimerEvent) : void {
			if(_condition.call()) {
				_timer.stop();
				_todo.call();
			}			
		}

		private function defaultTimeoutHandler() : void {
			throw new Error("Timeout");
		}
	}
}