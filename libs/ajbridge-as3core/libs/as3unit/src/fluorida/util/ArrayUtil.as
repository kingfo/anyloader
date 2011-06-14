package fluorida.util {
	public class ArrayUtil {
		public static function copy(array:Array) : Array {
			return array.map(copyElement);
		}

		public static function pushAll(arr1:Array, arr2:Array) : void {
			for each(var element:* in arr2) {
				arr1.push(element);
			}
		}

		private static function copyElement(element:*, index:int, arr:Array) : * {
            return element;
        }
	}
}