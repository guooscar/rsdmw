package king.of.roshan
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 
	 */ 
	public class SpriteSheetAnimation extends Animation{
		private var bitmapData:BitmapData;
		private var frameWidth:Number;
		private var frameHeight:Number;
		private var column:uint;
		private var startIndex:uint;
		//
		public function SpriteSheetAnimation(name:String,frameRate:uint){
			super(name,frameRate);	
		}
		//
		public function setSpriteSheet(bd:BitmapData,
									   row:uint,
									   col:uint,
									   startIndex:uint,
									   frameCount:uint):void{
			if(bitmapData){
				bitmapData.dispose()
			}
			bitmapData=bd;
			this.frameCount=frameCount;
			this.startIndex=startIndex;
			var index:uint=0;
			frameWidth=bitmapData.width/col;
			frameHeight=bitmapData.height/row;
			var rect:Rectangle=BitmapEngine.RECT;
			rect.x=0;
			rect.y=0;
			rect.width=frameWidth;
			rect.height=frameHeight;
			var xx:int=startIndex%column;
			var yy:int=startIndex/column;
			this.column=col;
			//
			if(_firstFrame){
				_firstFrame.dispose();
			}
			_firstFrame=new BitmapData(frameWidth,frameHeight,true,0);
			BitmapEngine.POINT.x=0;
			BitmapEngine.POINT.y=0;
			_firstFrame.copyPixels(bitmapData,rect,BitmapEngine.POINT);
		}
		/**
		 * render frame to buffer
		 */ 
		public override function render(buffer:BitmapData,frameIndex:uint):void{
			var rect:Rectangle=BitmapEngine.RECT;
			var xx:int=(startIndex+frameIndex)%column;
			var yy:int=(startIndex+frameIndex)/column;
			rect.x=xx*frameWidth;
			rect.y=yy*frameHeight;
			rect.width=frameWidth;
			rect.height=frameHeight;
			BitmapEngine.POINT.x=0;
			BitmapEngine.POINT.y=0;
			buffer.copyPixels(bitmapData,rect,BitmapEngine.POINT);
		}
		//
		public override function dispose():void{
			if(bitmapData){
				bitmapData.dispose();
			}
			if(firstFrame){
				firstFrame.dispose();
			}
		}
	}
}