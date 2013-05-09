package king.of.roshan
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;

	/**
	 * 
	 */ 
	public class CanvasSprite extends ImageSprite{
		//
		private var shape:Shape;
		public var graphics:Graphics;
		/***
		 * 
		 */ 
		public function CanvasSprite(w:Number,h:Number){
			var bd:BitmapData=new BitmapData(w,h,true,0);
			super(bd);
			shape=new Shape();
			graphics=shape.graphics;
		}
		//
		//
		public override function render(screen:Screen):void{
			buffer.fillRect(rect,0);
			buffer.draw(shape);
			super.render(screen);
		}
	}
}