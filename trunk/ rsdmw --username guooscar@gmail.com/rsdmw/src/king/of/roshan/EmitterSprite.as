package king.of.roshan
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * 
	 */ 
	public class EmitterSprite extends BaseSprite{
		private var particles:LinkedList;
		protected var particleBitmap:BitmapData;
		protected var particleBmp:Bitmap;
		private var currentNode:LinkedListNode;
		private var currentParticle:Particle;
		private var rect:Rectangle;
		protected var _particleWidth:Number=0;
		protected var _particleHeight:Number=0;
		
		public function EmitterSprite(bitmapData:BitmapData){
			particles=new LinkedList();
			particleBitmap=bitmapData;
			particleBmp=new Bitmap(particleBitmap);
			rect=particleBitmap.rect;
			_particleWidth=rect.width;
			_particleHeight=rect.height;
			visible=false;
		}
		//
		public function get particleWidth():Number{
			return _particleWidth;
		}
		//
		public function get particleHeight():Number{
			return _particleHeight;
		}
		//
		public override function update(engine:BitmapEngine):void{
			super.update(engine);
			currentNode=particles.firstNode;
			if(!currentNode){
				visible=false;
				return;
			}
			var frameTime:Number=engine.rate/1000;
			while(currentNode){
				currentParticle=currentNode.value;
				currentParticle.ttl+=engine.elapsed;
				currentParticle.x+=(currentParticle.vx*frameTime);
				currentParticle.y+=(currentParticle.vy*frameTime);
				currentParticle.scaleX+=(currentParticle.vScaleX*frameTime);
				currentParticle.scaleY+=(currentParticle.vScaleY*frameTime);
				currentParticle.angle+=(currentParticle.vAngle*frameTime);
				if(currentParticle.x+x>engine._width
				||currentParticle.y+y>engine._height
				||currentParticle.x+x<0
				||currentParticle.y+y<0
				||currentParticle.scaleX<=0
				||currentParticle.scaleY<=0
				){
					//out of screen
					currentNode=particles.remove(currentNode);
				}else if(currentParticle.ttl>currentParticle.liveTime){
					currentNode=particles.remove(currentNode);
				}else{
					currentNode=currentNode.next;
				}
			}
		}
		//
		public override function render(screen:Screen):void{
			currentNode=particles.firstNode;
			while(currentNode){
				currentParticle=currentNode.value;
				BitmapEngine.POINT.x=x+currentParticle.x;
				BitmapEngine.POINT.y=y+currentParticle.y;
				if(currentParticle.moveX!=0){
					BitmapEngine.POINT.x+=Math.random()*currentParticle.moveX-BitmapEngine.cameraX;
				}
				if(currentParticle.moveY!=0){
					BitmapEngine.POINT.y+=Math.random()*currentParticle.moveY-BitmapEngine.cameraY;
				}
				// render without transformation
				if (currentParticle.angle == 0 && currentParticle.scaleX  == 1 && currentParticle.scaleY == 1){
					screen.buffer.copyPixels(particleBitmap,rect,BitmapEngine.POINT,null,null,true);
				}else{
					// render with transformation
					var matrix:Matrix=BitmapEngine.MATRIX;
					matrix.identity();
					matrix.scale(currentParticle.scaleX,currentParticle.scaleY);
					matrix.translate(BitmapEngine.POINT.x,BitmapEngine.POINT.y);
					if (currentParticle.angle != 0){
						matrix.rotate(currentParticle.angle *BitmapEngine.RAD);
					}
					particleBmp.smoothing = true;
					screen.buffer.draw(particleBmp, matrix, null,null,null,true);	
				}
				currentNode=currentNode.next;
			}
		}
		//
		public function emit(
			x:Number, 
			y:Number,
			vx:Number,
			vy:Number,
			liveTime:Number,
			moveX:Number=0,
			moveY:Number=0,
			vScaleX:Number=0,
			vScaleY:Number=0,
			vAngle:Number=0
		):void{
			var p:Particle=new Particle();
			p.x=x;
			p.y=y;
			p.vx=vx;
			p.vy=vy;
			p.liveTime=liveTime;
			p.moveX=moveX;
			p.moveY=moveY;
			p.vAngle=vAngle;
			p.vScaleX=vScaleX;
			p.vScaleY=vScaleY;
			particles.add(new LinkedListNode(p));
			visible=true;
			deadInHide=false;
		}
		//
		protected function disposeBuffer():void{
			if(particleBitmap){
				particleBitmap.dispose();
				particleBitmap=null;
			}
		}
	}
}