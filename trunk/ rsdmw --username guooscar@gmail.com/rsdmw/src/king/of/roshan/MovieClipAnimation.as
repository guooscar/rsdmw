package king.of.roshan
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 
	 */ 
	public class MovieClipAnimation extends Animation{
		private var bitmapData:BitmapData;
		private var _frameWidth:Number;
		private var _frameHeight:Number;
		//
		public function MovieClipAnimation(name:String,frameRate:uint=0){
			super(name,frameRate);	
		}
		//
		public function getBitmap():Bitmap{
			return new Bitmap(bitmapData);
		}
		//
		public function get frameWidth():Number{
			return _frameWidth;
		}
		//
		public function get frameHeight():Number{
			return _frameHeight;
		}
		//
		//
		private var maxTotalFrames:Number=0;
		//
		private function gotoAndStopMC(displayObject:DisplayObject,frameCount:int):void{
			if(!(displayObject is MovieClip)){
				return;
			}
			var mc:MovieClip=(displayObject as MovieClip);
			mc.gotoAndStop(frameCount%(mc.totalFrames+1));
			//
			for(var i:int=0;i<mc.numChildren;i++){
				gotoAndStopMC(mc.getChildAt(i),frameCount);
			}
		}
		//
		private function getMaxTotalFrames(disObject:DisplayObject):void{
			if(!(disObject is MovieClip)){
				return;
			}
			var mc:MovieClip=(disObject as MovieClip);
			
			if(mc.totalFrames>maxTotalFrames){
				maxTotalFrames=mc.totalFrames;
			}
			for(var i:int=0;i<mc.numChildren;i++){
				getMaxTotalFrames(mc.getChildAt(i));
			}
		}
		//
		public function setMovieClip(mc:MovieClip):void{
			if(bitmapData){
				bitmapData.dispose()
			}
			//not set frame rate use flash 's setting
			if(frameRate==0&&mc.loaderInfo){
				frameRate=mc.loaderInfo.frameRate;
			}
			var index:uint=0;
			_frameHeight=mc.height;
			_frameWidth=mc.width;
			//
			getMaxTotalFrames(mc); 
			//
			for ( var j:int = 1; j <= maxTotalFrames; j++ ) { 
				gotoAndStopMC(mc,j);
				_frameHeight=(_frameHeight>mc.height?_frameHeight:mc.height);
				_frameWidth=(_frameWidth>mc.width?_frameWidth:mc.width);
			}
			//
			frameCount=maxTotalFrames;
			bitmapData=new BitmapData(_frameWidth*maxTotalFrames,_frameHeight,true,0);
			var point:Point=new Point(0,0);
			//loop through all the frames in the BlockFace movie clip 
			for ( var i:int = 1; i <= mc.totalFrames; i++ ) { 
				//move the movie clip to the "i-th" frame 
				mc.gotoAndStop(i); 
				//these three lines have been moved into the loop from below 
				var bd:BitmapData=new BitmapData(_frameWidth,_frameHeight,true,0x00FFFFFF); 
				bd.draw(mc); 
				point.x=(i-1)*_frameWidth;
				bitmapData.copyPixels(bd,bd.rect,point);
				if(i==1){
					_firstFrame=bd;
				}else{
					bd.dispose();	
				}
			}
		}
		/**
		 * render frame to buffer
		 */ 
		public override function render(buffer:BitmapData,frameIndex:uint):void{
			var rect:Rectangle=BitmapEngine.RECT;
			rect.x=frameIndex*_frameWidth;
			rect.y=0;
			rect.width=_frameWidth;
			rect.height=_frameHeight;
			BitmapEngine.POINT.x=0;
			BitmapEngine.POINT.y=0;
			buffer.copyPixels(bitmapData,rect,BitmapEngine.POINT);
		}
		//
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