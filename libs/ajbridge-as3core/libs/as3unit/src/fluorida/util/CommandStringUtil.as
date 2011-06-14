package fluorida.util
{
	import fluorida.action.CustomAction;
	
	import mx.utils.StringUtil;
	
	public class CommandStringUtil
	{
		public function CommandStringUtil()
		{
		}
		
		public static function buildCommandArray( commandString : String ) : Array {
//			var beginIndex : int = commandString.indexOf( "|" ) + 1;
//			var endIndex : int = 0;
//			var result : Array = new Array;
//			while( beginIndex != commandString.length )
//			{
//				if( commandString.indexOf( "|{", endIndex ) + 1 == beginIndex)
//				{
//					endIndex = commandString.indexOf( "}|", beginIndex ) + 1;
//					result.push( commandString.substring( beginIndex, endIndex ) );
//					beginIndex =  endIndex + 2;
//				} else {
//					endIndex = commandString.indexOf( "|", beginIndex + 1 );
//					result.push( commandString.substring( beginIndex, endIndex ) );
//					beginIndex =  endIndex + 1;
//				}
//				
//			}
			return commandString.split("|").map(trim).filter(notEmpty);
		}
		
		public static function getUsefulRows(content:String) : Array {
			return content.split("\n").map(trim).filter(notEmpty).filter(notComment);
		}
		
		public static function buildCustomActionByUsefulRows( rows : Array ) : CustomAction {
			var cmdArray:Array = buildCommandArray( rows[0] );
			var action:String = cmdArray.shift();
			if ( action == "def" ) {
				var actionName : String = cmdArray.shift();
				var cAction : CustomAction = new CustomAction( cmdArray );
				for ( var index : Number = 1; index < rows.length; index++) {
					var actionCommandRow : String = rows[ index ];
					if( actionCommandRow != "|end|" ) {
						cAction.addCommandRowsString( actionCommandRow );
					} else {
						break;
					}
				}
				cAction.name = actionName;
				return cAction;
			}
			
			return null;
		}
		
		private static function notEmpty(element:*, index:int, arr:Array) : Boolean {
            return (element as String).length > 0;
        }
		
		private static function trim(element:*, index:int, arr:Array) : String {
            return StringUtil.trim(element as String);
        }
		
		private static function notComment(element:*, index:int, arr:Array) : Boolean {
            return (element as String).charAt(0) != "#";
        }
	}
}