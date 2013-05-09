package king.of.roshan
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 *
	 */ 
	public class AnimationSprite extends ImageSprite{
		//
		private var frameInfo:Array=[];
		/**
		 * If the animation has stopped.
		 */
		private var complete:Boolean = true;
		
		private var anim:Animation;
		private var index:uint=0;
		private var lastIndex:int=-1;
		private var timer:uint=0;
		private var loop:Boolean=false;
		//
		/**
		 * change play rate
		 */ 
		public var rate:Number=1;
		//
		public function AnimationSprite(){
			super(null);
		}
		//
		public function addAnimation(movie:Animation):void{
			frameInfo[movie.name]=movie;
			updateBuffer(movie.firstFrame.clone());	
		}
		//
		public function getAnimation(name:String):Animation{
			return frameInfo[name];
		}
		/*
		 *update frame and set to buffer 
		 */ 
		public override function update(engine:BitmapEngine):void{
			super.update(engine);
			if (anim && !complete){
				timer ++;
				index=uint(timer*anim.frameRate/BitmapEngine.frameRate*rate);
				if (index == anim.frameCount){
					if(loop){
						index = 0;
						timer = 0;
						if (anim.callback != null){
							anim.callback();
						}
					}else{
						index = anim.frameCount - 1;
						timer =0;
						complete = true;
						if (anim.callback != null) {
							anim.callback();
						}
					}
				}
			}
		}
		//
		public override function render(screen:Screen):void{
			//updateBuffer
			if(anim&&!complete&&lastIndex!=index){
				anim.render(buffer,index);
				if(_colorTransform){
					buffer.colorTransform(buffer.rect,_colorTransform);
				}
				if(_filter){
					BitmapEngine.POINT.x=0;
					BitmapEngine.POINT.y=0;
					buffer.applyFilter(buffer,rect,BitmapEngine.POINT,_filter);
				}
				lastIndex=index;
			}
			super.render(screen);
		}
		//
		public function gotoAndStop(name:String,frameIndex:int):void{
			anim=frameInfo[name];
			if(!anim){
				throw new Error("can not find animation with name:"+name);
			}
			complete=true;
			timer=frameIndex/(anim.frameRate/BitmapEngine.frameRate);
			anim.render(buffer,frameIndex);
		}
		//
		public function gotoAndPlay(name:String,frameIndex:int,loop:Boolean=true):void{
			play(name,loop);
			timer=index/(anim.frameRate/BitmapEngine.frameRate);
		}
		//
		public function play(name:String,loop:Boolean=true):void{
			anim=frameInfo[name];
			if(!anim){
				throw new Error("can not find animation with name:"+name);
			}
			this.loop=loop;
			this.timer=0;
			this.complete=false;
		}
		//
		public function stop():void{
			complete=true;
		}
		//
		public function get currentFrame():Number{
			return index;
		}
		//
		public function get isComplete():Boolean{
			return complete;
		}
	}
}