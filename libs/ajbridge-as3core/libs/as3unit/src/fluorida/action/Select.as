package fluorida.action {
	import flash.display.DisplayObject;
	
	import mx.events.ListEvent; 
	
	public class Select extends Action {
		
		protected override function doRun(args:Array) : void {
			var dropDown : DisplayObject = _accessor.$$(args[0]);
			
			var oldSelectedIndex : Number = ( dropDown as Object ).selectedIndex;
			
			if ( args[1] == "index" && dropDown.hasOwnProperty( "selectedIndex" ) )
			{
				( dropDown as Object ).selectedIndex = parseInt( args[2] );
			} else {
				var propertyName : String = args[1];
				if ( dropDown.hasOwnProperty("numChildren") )
					for ( var index : int = 0;  index < ( dropDown as Object ).numChildren; index++ )
					{
						var dropDownObject : Object = dropDown as Object ;
						var selectedItem : Object = dropDownObject.getChindAt( index ) as Object;
						if ( selectedItem.hasOwnProperty( propertyName ) && selectedItem[ propertyName ] == args[2] )
						{
							dropDownObject.selectedIndex = dropDownObject.getChildIndex( dropDownObject.getChindAt( index ) );
						}
					}
			}
			
			if ( oldSelectedIndex != ( dropDown as Object ).selectedIndex ) 
					dropDown.dispatchEvent( new ListEvent(ListEvent.CHANGE) );
		}
	}	
}	
