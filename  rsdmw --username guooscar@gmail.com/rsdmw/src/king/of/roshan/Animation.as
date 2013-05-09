package king.of.roshan
{
	import flash.display.BitmapData;

	/**
	 * 
	 */ 
	public class Animation{
		public var name:String;
		public var frameCount:uint;
		public var frameRate:uint;	
		public var callback:Function;
		protected var _firstFrame:BitmapData;
		//
		public function Animation(name:String,frameRate:int){
			this.name=name;
			this.frameRate=frameRate;
		}
		//
		public function get firstFrame():BitmapData{
			return _firstFrame;
		}
		/**
		 * render frame to buffer
		 */ 
		public function render(buffer:BitmapData,frameIndex:uint):void{
			
		}
		//
		public function dispose():void{
			
		}
	}
}