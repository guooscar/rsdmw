package king.of.roshan
{
	import flash.display.BitmapData;

	/**
	 * 
	 */ 
	public class SequenceAnimation extends Animation{
		protected var frames:Vector.<BitmapData>=new Vector.<BitmapData>();
		//
		public function SequenceAnimation(name:String,frameRate:uint){
			super(name,frameRate);
		}
		//
		public function addFrame(...bd):void{
			for(var i:int=0;i<bd.length;i++){
				frames.push(bd[i]);	
			}
			frameCount=frames.length;
			_firstFrame=frames[0];
		}
		//
		public function addAllFrame(frames:Array):void{
			for(var i:int=0;i<frames.length;i++){
				this.frames.push(frames[i]);
			}
			frameCount=frames.length;
			_firstFrame=frames[0];
		}
		//
		/**
		 * render frame to buffer
		 */ 
		public override function render(buffer:BitmapData,frameIndex:uint):void{
			var bd:BitmapData=frames[frameIndex];
			BitmapEngine.POINT.x=0;
			BitmapEngine.POINT.y=0;
			buffer.copyPixels(bd,bd.rect,BitmapEngine.POINT);
		}
		public override function dispose():void{
			for(var i:int=0;i<frames.length;i++){
				if(frames[i]){
					frames[i].dispose();
				}
			}
			if(firstFrame){
				firstFrame.dispose();
			}
		}
	}
}