package fluorida.action
{
	import fluorida.framework.Command;
	
	public class AssertFailed extends Action
	{
		protected override function doRun(args:Array) : void {
			var locator:String = args.shift();
			var actionName : String = args.shift();
			var command:Command = new Command(actionName, args);
			var action : Action = Action.create(this.getTestCase(), command, _accessor, null);
			var passed : Boolean = true;
			try {
				action.runOnly();
			} catch ( error:Error ) {
				passed = false;
			}
			if( passed )
				throw new Error;
		}	

	}
}