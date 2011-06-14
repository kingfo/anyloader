package fluorida.action
{
	import flash.display.DisplayObject;
	
	import fluorida.framework.Command;
	import fluorida.util.CommandStringUtil;
	
	public class Assign extends Action
	{
		protected override function doRun(args:Array) : void {
			var locator:String = args.shift();
			var selectedObject : DisplayObject = _accessor.$$(locator);
			var assignedPropertyExp : String = args.shift();
			var assignedValue : String = args.shift();
			if ( assignedValue.indexOf("{") == 0 && assignedValue.lastIndexOf( "}" ) ==  assignedValue.length - 1 )
			{
					var cmdArray:Array = CommandStringUtil.buildCommandArray( assignedValue.substring( 1, assignedValue.length -1 ) );
					var actionName:String = cmdArray.shift();
					var command : Command = new Command(actionName, cmdArray);
					var action : Action = Action.create(this.getTestCase(), command, _accessor, null);
					action.runOnly();
					var subCallResult : * = (action as Call).result;
					if (args.length == 0 )
						selectedObject[ assignedPropertyExp ] = subCallResult;
					else{
						var arg = args.shift();
						var propArray = arg.split(".");
						var lastResult = subCallResult;
						for each ( var prop : String in propArray ) {
							lastResult = subCallResult[prop];
						}
						selectedObject[ assignedPropertyExp ] = lastResult;
					}							
			} else {
				selectedObject[ assignedPropertyExp ] = assignedValue;
			}
		}
		
	}
}