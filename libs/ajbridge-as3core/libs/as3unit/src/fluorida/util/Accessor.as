package fluorida.util {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import mx.core.Application;
    import mx.controls.Alert;
    import mx.controls.List;
    import mx.controls.ProgressBar;
	import mx.controls.Text;
	import mx.controls.TextArea;
	import mx.controls.SWFLoader;
    import mx.collections.ListCollectionView;
	import mx.managers.SystemManager;
	
	import fluorida.framework.TestResult;
	import fluorida.framework.TestFailure;
	import fluorida.locator.Selector;
	
	public class Accessor {
		private var _application:Application = null;
		
		public function Accessor(application:Application) {
			_application = application;
		}
		
		public function getApplication() : Application {
			return _application;	
		}
		
		public function getAutContainer() : SWFLoader {
			return $(_application, 'aut') as SWFLoader;
		}
		
		public function getAut() : Application {
			var autContainer:SWFLoader = getAutContainer();
			if(autContainer == null) {
				return null;	
			}
			var autManager:SystemManager = autContainer.content as SystemManager;
			if(autManager == null) {
				return null;	
			}
			return autManager.application as Application;
		}
		
		public function renderResult(result:TestResult) : void {
			var testFailures:List = $(_application, "testFailures") as List;
			var cases:Array = result.getUnsuccessfulCases();
			testFailures.dataProvider = cases;
			if(cases.length > 0) {
				testFailures.selectedIndex = 0;
				testFailures.verticalScrollPosition = testFailures.maxVerticalScrollPosition;
				var detail:TextArea = $(_application, "detail") as TextArea;
				detail.text = cases[0].cause.getStackTrace();
			}
			
			var progressBar:ProgressBar = $(_application, "progressBar") as ProgressBar;
			progressBar.label = result.toString();
			progressBar.setProgress(result.getTestSuite().countRunTests(), result.getTestSuite().countTestCases());
			if(result.isSuccessful()) {
				progressBar.setStyle("barColor",0x00FF00);
			} else {
				progressBar.setStyle("barColor",0xFF0000);
			}
			
			var allTests:List = $(_application, "allTests") as List;
			allTests.dataProvider = result.getTestSuite().getTestCases();
		}
		
		public function enableRunSuite(enabled:Boolean = true) : void {
			$(_application, "runSuite")["enabled"] = enabled;
		}
		
		public function $$(locator:String) : DisplayObject {
			var result:DisplayObject = $(getAut(), locator);
			if(result == null) {
				throw new Error("Can't find element: " + locator);
			}
			return result;
		}
		
		private function $(container:DisplayObjectContainer, locator:String) : DisplayObject {
			var selector:Selector = Selector.parse(locator);
			var result:Array = selector.select(container);
			if(result.length == 0) {
				return null;
			} else {
				return result[0];
			}
		}
	}	
}