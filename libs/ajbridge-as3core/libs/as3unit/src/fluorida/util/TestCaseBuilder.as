package fluorida.util
{
	import fluorida.framework.Command;
	import fluorida.framework.TestCase;
	
	public class TestCaseBuilder
	{
		private var _testCase : TestCase;
		private var _content : String;
		private var _baseUrl : String;
		private var _index : Number = 0;
		private var rows : Array;
		private var _commandBuildFinished : Boolean = false;
		
		public function TestCaseBuilder( testCase : TestCase, content : String, baseUrl : String )
		{
			this._testCase = testCase;
			this._content = content;
			this._baseUrl = baseUrl;
		}
		
		public function build() : void {
			rows = CommandStringUtil.getUsefulRows(_content);
			loadNextCommand();
			
		}
		
		private function loadNextCommand() : void {
			if( _index >= rows.length ) {
				return;	
			}
			_commandBuildFinished = false;
			loadCommand();
			new WaitAndRun(isCommandBuildFinished, loadNextCommand);
			loadNextCommand();
		}
		
		private function loadCommand() : void {
			var row : String = rows[ _index ];
			var cmdArray:Array = CommandStringUtil.buildCommandArray( row );
			
			var action:String = cmdArray.shift();
			if ( action == "def" ) {
				var actionName : String = cmdArray.shift();
				var defUsefulRows : Array = new Array;
				while( ( rows[ _index ] as String ).indexOf( "|end|" ) != 0 ) {
					defUsefulRows.push( rows[ _index++ ] );
				}
				defUsefulRows.push( rows[ _index ] );
				_testCase.setCustomAction( actionName, CommandStringUtil.buildCustomActionByUsefulRows(defUsefulRows) );  
			} else if ( action == "var") {
				// TODO
				_testCase.setVariable( cmdArray.shift(), cmdArray.shift() );
			}else {
				var args:Array = new Array;
				for ( var cmdIndex : Number = 0; cmdIndex < cmdArray.length; cmdIndex++ )
				{
					var cmd : String = cmdArray[ cmdIndex ];
					for ( var variableName : String in _testCase.variables ) 
					{
						 cmd = cmd.replace(new RegExp(  "\\" + variableName, "g" ), 
													_testCase.variables[ variableName ] 
													);
					}
					args.push( cmd );
				}	
				if ( action == "import" ) {
					args.push(_baseUrl);
				}
				var command:Command = new Command(action, args);
				_testCase.addCommand(command);
			}
			buildCommandSuccess();
			_index++;
		}
		
		private function isCommandBuildFinished() : Boolean {
			return _commandBuildFinished;
		}
		
		private function buildCommandSuccess() : void {
			_commandBuildFinished = true;
		}
	}
}