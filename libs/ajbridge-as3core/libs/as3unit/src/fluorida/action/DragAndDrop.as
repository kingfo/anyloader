package fluorida.action {
	import flash.events.MouseEvent;
	import mx.events.DragEvent;
	import mx.core.UIComponent;
	
	public class DragAndDrop extends Action {
		protected override function doRun(args:Array) : void {
			var initiator:UIComponent = _accessor.$$(args.shift()) as UIComponent;
			var target:UIComponent = _accessor.$$(args.shift()) as UIComponent;
			var x:int = parseInt(args.shift());
			var y:int = parseInt(args.shift());
			
			initiator.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			initiator.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));
			initiator.dispatchEvent(createDragEvent(initiator, DragEvent.DRAG_START));
			target.dispatchEvent(createDragEvent(initiator, DragEvent.DRAG_ENTER));
			
			var dragDrop:DragEvent = createDragEvent(initiator, DragEvent.DRAG_DROP);
			dragDrop.localX = x;
			dragDrop.localY = y;
			target.dispatchEvent(dragDrop);
			
			initiator.dispatchEvent(createDragEvent(initiator, DragEvent.DRAG_COMPLETE));
		}	
		
		private function createDragEvent(initiator:UIComponent, type:String) : DragEvent {
			var event:DragEvent = new DragEvent(type);
			event.dragInitiator = initiator;
			return event;
		}
	}	
}