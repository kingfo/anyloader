package fluorida.publisher {
    import mx.controls.Alert;
	import mx.rpc.http.HTTPService;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.events.FaultEvent;
	
	import fluorida.framework.TestResult;
	
	public class HttpPublisher extends Publisher {
		private var _url:String;
	
		public function HttpPublisher(url:String) {
			_url = url;
		}
		
		public override function publish(result:TestResult) : void {
			var http:HTTPService = new HTTPService();
			http.method = "POST";
			http.url = _url;
			http.addEventListener(ResultEvent.RESULT, onSuccessful);
			http.addEventListener(FaultEvent.FAULT, onError);
			
			var parameters:Object = {data: result.toXml().toXMLString(), status: result.getStatus()};
			http.send(parameters);
		}		

		private function onSuccessful(event:*) : void {
			Alert.show("Result has been published to " + _url);
		}
		
		private function onError(event:*) : void {
			Alert.show(event["fault"]);
		}
	}
}