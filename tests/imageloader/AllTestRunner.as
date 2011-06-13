package {
	import asunit.textui.TestRunner;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public class AllTestRunner extends Sprite {
		
		public function AllTestRunner():void {
			System.useCodePage = true;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			runner = new TestRunner();
			stage.addChild(runner);
			runner.start(AllTests, null, false);
		}
		
		private var runner: TestRunner;
	}
	
}