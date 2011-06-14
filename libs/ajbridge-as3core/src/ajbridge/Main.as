package {
	import com.xintend.ajbridge.core.AJBridge;
	import com.xintend.display.Spirit;
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public class Main extends Spirit{
		
		public function Main() {
			
		}
		
		override public function init():void {
			super.init();
			
			var params: Object = stage.loaderInfo.parameters;
			
			AJBridge.bridge.deploy(params);
			
			AJBridge.bridge.activate();
		}
		
		
		
	}

}