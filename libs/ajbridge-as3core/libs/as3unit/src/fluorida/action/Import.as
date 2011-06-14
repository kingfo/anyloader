package fluorida.action
{
	import fluorida.util.HeadFileImporter;
	
	public class Import extends Action
	{
		protected override function doRun(args:Array) : void {
			var fileName : String = args.shift();
			var baseUrl : String = args.shift();
			var headFileImporter : HeadFileImporter = new HeadFileImporter( this.getTestCase() );
			headFileImporter.completeCallback = changeOverFlag;
			headFileImporter.load( baseUrl + "/" + fileName  );
		}
		
		protected override function getSuccessIndicator() : Function {
			return isOver;	
		}
		
		private function isOver():Boolean {
			return _isImportOver;
		}
		
		private function changeOverFlag() : void {
			this._isImportOver = true;
		}
		
		private var _isImportOver : Boolean = false;

	}
}