package fluorida.action
{
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.listClasses.ListBase;
	
	public class Select_LisBase extends Action
	{
		protected override function doRun(args:Array) : void {
			var listbaseComponent : ListBase = _accessor.$$(args[0]) as ListBase;
			listbaseComponent.selectedIndex = listbaseComponent.itemRendererToIndex((_accessor.$$(args[1]) as IListItemRenderer) );			
		}

	}
}