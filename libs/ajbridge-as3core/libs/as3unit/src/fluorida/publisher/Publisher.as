package fluorida.publisher {
	import flash.system.System;

	import fluorida.framework.TestResult;

	public class Publisher {
		public static function create(resultUrl:String) : Publisher {
			if(resultUrl == "") {
				return new ScreenPublisher();
			} else {
				return new HttpPublisher(resultUrl);
			}
		}
		
		private var _result:TestResult;
		
		public function publish(result:TestResult) : void {
			_result = result;
			publishXML(result.toXml());
		}
		
		protected function publishXML(xml:XML) : void {
			throw new Error("This function should never be invoked.");
		}
	}
}