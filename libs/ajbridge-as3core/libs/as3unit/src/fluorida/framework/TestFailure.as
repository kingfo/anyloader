package fluorida.framework {
	public class TestFailure {
		public var test:TestCase;
		public var cause:Error;
		
		public function TestFailure(test:TestCase, cause:Error) {
			this.test = test;
			this.cause = cause;
		}
		
		public function toString() : String {
			return test.getName();
		}
		
		public function toXml() : XML {
			return <{getType()} message={cause.message}><![CDATA[ {cause.getStackTrace()} ]]></{getType()}>;
		}
		
		private function getType() : String {
			return (cause is AssertionError) ? "failure" : "error";
		}
	}	
}