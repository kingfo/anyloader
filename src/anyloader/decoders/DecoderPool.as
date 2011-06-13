package anyloader.decoders {
	/**
	 * ...
	 * @author kingfo oicuicu@gmail.com
	 */
	public class DecoderPool {
		/**
		 * equality
		 */
		public static const EQ: String = "eq";
		/**
		 * inequality
		 */
		public static const IE: String = "ie";
		/**
		 * greater than or equal to
		 */
		public static const GE: String = "ge";
		/**
		 * less than or equal to
		 */
		public static const LE: String = "le";
		/**
		 * less than 
		 */
		public static const LT: String = "lt";
		/**
		 * greater than
		 */
		public static const GT: String = "gt";
		/**
		 * strict equality
		 */
		public static const SE: String = "se";
		/**
		 * strict inequality
		 */
		public static const SI: String = "si";
		
		public function get source():Array {
			return _source;
		}
		
		public function get size(): uint {
			return _source.length;
		}
		
		
		public function DecoderPool() {
		}
		
		public function add(link: DecoderLink): void {
			_source.push(link);
		}
		/**
		 * 获取符合条件解码器数组
		 * 如选择 GE 则表达的是
		 *  element[field] >= value 
		 * @param	field							指定的属性。值将与 value 比较。
		 * @param	value							期望值
		 * @param	comparison						条件 默认 GE
		 * @return
		 */
		public function getLinks(field: String,value:*,comparison:String = null): Array {
			var a: Array = _source.concat();
			var b: Array = a.filter(function(element:DecoderLink, index:int, arr:Array):Boolean {
					var s:* = element[field];
					if (!s) return false;
					switch(comparison) {
						case IE:
							return s != value;
						case EQ:
							return s == value;
						case LE:
							return s <= value;
						case LT:
							return s < value;
						case GT:
							return s > value;
						case SE:
							return s === value;
						case SI:
							return s !== value;
						default:
							return s >= value;
					}
				},this);
			return b;
		}
		
		private var _source: Array = [];
		
		
	}

}