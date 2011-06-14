package com.xintend.events {
	import flash.events.Event;
	import org.flashdevelop.utils.FlashConnect;
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public dynamic class RichEvent extends Event{
		
		
		public function RichEvent(
										type: String, 
										bubbles: Boolean = false, 
										cancelable: Boolean = true,
										any:* = null
										) { 
			super(type, bubbles, cancelable);
			this.any = any;
			mixin();
		} 
		
		override public function clone():Event {
			return new RichEvent(type,bubbles,cancelable,any);
		}
		
		public override function toString():String { 
			return formatToString("RichEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		
		protected function mixin(): void {
			var k:*;
			if (!any) return;
			if (!isPlainObject(any)) {
				this.message = any;
			}else if(any is Function) {
				this.message = any.toString();
			}else if (any is Array) {
				this.dump = any;
			}else if (any is Object) {
				for (k in any) {
					if (k == "type" 
						|| k == "bubbles"
						|| k == "cancelable"
						|| k == "eventPhase"
						|| k == "currentTarget"
						|| k == "target"
						)continue;
					if (any[k] is Function) continue;
					this[k] = any[k];
				}
			}
		}
		
		protected function isPlainObject(o:*): Boolean {
			return o && Object.prototype.toString.call(o) === '[object Object]' && !o['setInterval'];
		}
		
		
		private var any:*;
		
		
	}

}