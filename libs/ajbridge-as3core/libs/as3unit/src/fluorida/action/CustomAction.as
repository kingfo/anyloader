package fluorida.action
{
	import fluorida.framework.Command;
	import fluorida.util.CommandStringUtil;
	
	public class CustomAction extends Action
	{
		public function CustomAction( params : Array )
		{
			this._params = params;
			this._commandRowsStrings = new Array();
			this._runningCommandsStrings = new Array();
			
		}
		public function addCommandRowsString( _commandRowsString : String ) : void {
			this._commandRowsStrings.push( _commandRowsString );
		}
		
		public function set name( name : String ) : void {
			this._name = name;
		}
		
		public function get name() : String {
			return this._name;
		} 
		
		public function clone() : CustomAction {
			var clonedCA : CustomAction = new CustomAction(this._params);
			clonedCA._commandRowsStrings = this._commandRowsStrings;
			return clonedCA;
		}
		
		protected override function doRun( args : Array ) : void {
			for each ( var rowCommandString : String in this._commandRowsStrings )
			{
				var preparedRowCommandString : String = rowCommandString;
				for ( var index : Number = 0; index < args.length; index++ )
				{
					 preparedRowCommandString = preparedRowCommandString.replace( new RegExp("\\"+this._params[ index ], "g" ), args[ index ] );
				}
				this._runningCommandsStrings.push( preparedRowCommandString );
			} 	
			
			runRealActions();
		}
		
		private function runNextCommand() : void {
			if ( this._runningCommandsStrings.length == 0 )
				return;
			var commandString : String = this._runningCommandsStrings[0];
			var cmdArray:Array = CommandStringUtil.buildCommandArray( commandString );
			var actionName:String = cmdArray.shift();
			var command : Command = new Command(actionName, cmdArray);
			var action : Action = Action.create(this.getTestCase(), command, _accessor, runRealActions);
			action.run();
		}
		
		private function runRealActions() : void {
			if ( this._runningCommandsStrings.length == 0 ) {
				this._isFinished = true;
			}
			runNextCommand();
			this._runningCommandsStrings.shift();
			
			
		}
		
		protected override function getSuccessIndicator() : Function {
			return this.isFinished;	
		}
        
        private function isFinished() : Boolean {
        	return _isFinished;
        }
        
		private var _params : Array;
		
		private var _runningCommandsStrings : Array;
		
		private var _commandRowsStrings : Array;
		
		private var _name : String;
		
		private var _isFinished : Boolean = false;
		
	}
}