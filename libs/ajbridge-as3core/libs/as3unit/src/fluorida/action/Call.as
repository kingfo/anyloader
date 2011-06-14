package fluorida.action
{
	import flash.display.DisplayObject;
	
	import fluorida.framework.Command;
	import fluorida.util.CommandStringUtil;
	
	public class Call extends Action
	{
		protected override function doRun(args:Array) : void {
			var locator:String = args.shift();
			var selectedObject : DisplayObject = _accessor.$$(locator);
			var calledFunction : Function = selectedObject[args.shift()];
			if ( calledFunction == null )
			{
				throw new Error( "no such method!");
			}
			var parameters : Array = new Array();
			for each ( var arg : String in args )
			{
				if ( arg as Number )
				{
					parameters.push( arg as Number );
				} else if ( arg as int ) {
					parameters.push( arg as int );
				} else if ( arg.indexOf("{") == 0 && arg.lastIndexOf( "}" ) ==  arg.length - 1 )
				{
					var cmdArray:Array = CommandStringUtil.buildCommandArray( arg.substring( 1, arg.length -1 ) );
					var actionName:String = cmdArray.shift();
					var command : Command = new Command(actionName, cmdArray);
					var action : Action = Action.create(this.getTestCase(), command, _accessor, null);
					action.runOnly();
					var subCallResult : * = (action as Call).result;
					if( subCallResult is Object )
						parameters.push( subCallResult );
				} else if ( arg.indexOf("css=") == 0 ){
					parameters.push( _accessor.$$( arg ) );
				} else {
					parameters.push( arg.replace( "\\{", "{").replace("\\}", "}") );
				}
				// TODO 
			}
			_result = calledFunction.apply( selectedObject, parameters );
			
		}
		
		public function get result() : Object {
			return this._result;
		} 	
		
		private var _result : Object = null;
	}
}