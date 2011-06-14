package fluorida.action {
    import flash.errors.IllegalOperationError;
    
    import fluorida.framework.AssertionError;
    import fluorida.framework.Command;
    import fluorida.framework.TestCase;
    import fluorida.util.Accessor;
    import fluorida.util.WaitAndRun;
    
    import mx.controls.Alert;

	public class Action {
		private static function getActionMap() : Object {
			return {
				assign:Assign,
				assertFailed:AssertFailed,
				setTimeout:SetTimeout,
				click:Click,
				clickAt:ClickAt,
				closePopup:ClosePopup,
				call:Call,
				doubleClick:DoubleClick,
				dragAndDrop:DragAndDrop,
				fail:Fail,
				"import":Import,
				mouseOver:MouseOver,
				mouseOut:MouseOut,
				open:Open,
				select:Select,
//				select_listbase:Select_LisBase,
				sleep:Sleep,
				type:Type,
				verifyElementProperty:VerifyElementProperty,
				verifyText:VerifyText,
				verifyStyle:VerifyStyle,
				verifyElementPresent:VerifyElementPresent,
				waitForElementProperty:WaitForElementProperty,
				waitForElementPresent:WaitForElementPresent
			};
		}
		
		public static function create(test:TestCase, command:Command, accessor:Accessor, finishCallback:Function) : Action {
			var actionName:String = command.getAction();
			var action:Action = null;
			if(getActionMap().hasOwnProperty(actionName)) {
				var actionClass:Class = getActionMap()[actionName];
				action = new actionClass();
			} else if( test.getCustomAction( actionName ) ){
				action = test.getCustomAction( actionName ).clone();
			} else {
				action = new Fail("We don't support this action yet: " + actionName);
			}
			
			action.setTestCase(test);
			action.setArgs(command.getArgs());
			action.setFinishCallback(finishCallback);
			action.setAccessor(accessor);
			return action;
		}
		
		protected var _finishCallback:Function = null;
		protected var _accessor:Accessor = null;
		
		private var _test:TestCase = null;
		private var _args:Array = null;
		
		private function setTestCase(test:TestCase) : void {
			_test = test;
		}
		
		protected function getTestCase() : TestCase {
			return this._test;
		}
		
		private function setArgs(args:Array) : void {
			_args = args;	
		}
		
		private function setFinishCallback(callback:Function) : void {
			_finishCallback = callback;
		}
		
		private function setAccessor(accessor:Accessor) : void {
			_accessor = accessor;	
		}
		
		private function timeoutCallback() : void {
			try {
				onTimeout();
			} catch (error:Error) {
				_test.addError(error);
			}
			_finishCallback.call();
		}
		
		public function run() : void {
			try {
				doRun(_args);
			} catch (failure:AssertionError) {
				_test.addFailure(failure);
			} catch (error:Error) {
				_test.addError(error);
			}
			new WaitAndRun(getSuccessIndicator(), _finishCallback, timeoutCallback);
		}
		
		public function runOnly() : void {
			doRun(_args);
			new WaitAndRun(getSuccessIndicator(), _finishCallback, timeoutCallback);
		}
		
		protected function doRun(args:Array) : void {
			throw new IllegalOperationError("This function should never be invoked.");
		}
		
		protected function getSuccessIndicator() : Function {
			return alwaysTrue;	
		}
		
		protected function onTimeout() : void {
			fail("Time out.");
		}
		
		protected function alwaysTrue() : Boolean {
			return true;
		}

		protected function debug(obj:Object) : void {
			Alert.show(obj.toString());	
		}
		
		protected function fail(message:String) : void {
			throw new AssertionError(message);
		}
		
		protected function assertEquals(expected:Object, actual:Object) : void {
			if(expected != actual) {
				throw new AssertionError("Expected [" + expected + "], but is [" + actual + "].");
			}			
		}
		
		protected function assertMatches(expectedPattern:String, actual:String) : void {
			if(!new RegExp(expectedPattern).test(actual)) {
				throw new AssertionError("Expected pattern [" + expectedPattern + "] doesn't match [" + actual + "].");
			}		
		}
	}	
}