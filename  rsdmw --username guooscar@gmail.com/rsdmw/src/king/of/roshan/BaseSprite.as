package king.of.roshan
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * base sprite of bitmap engine
	 */ 
	public class BaseSprite{
		internal var node:LinkedListNode;
		internal var layer:Layer;
		//
		internal var _liveTime:Number=0;
		internal var _isRemoved:Boolean=false;
		//
		/**
		 * position x of sprite
		 */ 
		public var x:Number=0;
		/**
		 * position y of sprite
		 */ 
		public var y:Number=0;
		/**
		 * width of sprite
		 */
		public var width:Number=0;
		/**
		 * height of sprite
		 */
		public var height:Number=0;
		/**
		 * if sprite is visible
		 */ 
		public var visible:Boolean=true;
		/**
		 * name of this sprite
		 */ 
		public var name:String="";
		/**
		 * if deadInHide is true when sprite is invisible update method won't call
		 */ 
		public var deadInHide:Boolean=false;
		/**
		 * Rotation of the image, in degrees.
		 */
		public var angle:Number = 0;
		/**
		 * X scale of the image.
		 */
		public var scaleX:Number = 1;
		
		/**
		 * Y scale of the image.
		 */
		public var scaleY:Number = 1;
		
		/**
		 * X origin of the image, determines transformation point.
		 */
		public var originX:Number = 0;
		
		/**
		 * Y origin of the image, determines transformation point.
		 */
		public var originY:Number = 0;
		
		
		/**
		 * max time to live in millsec
		 */ 
		public var maxTimeToLive:Number=0;
		/**
		 *sprite connect to  
		 */
		public var connected:BaseSprite;
		/**
		 * connect to x offset
		 */ 
		public var connectedX:Number=0;
		/**
		 * connect to y offset
		 */ 
		public var connectedY:Number=0;
		//
		public var connectAutoRotate:Boolean=true;
		//
		public var autoDispose:Boolean=true;
		//
		internal var translateConnectedPoint:Point;
		//
		//
		public function BaseSprite(){
		}
		/**
		 * connect to sprite
		 */ 
		public function connect(sprite:BaseSprite,cx:Number=0,cy:Number=0,autoRotate:Boolean=true):void{
			connected=sprite;
			connectedX=cx;
			connectedY=cy;
			connectAutoRotate=autoRotate;
			translateConnectedPoint=new Point(connectedX,connectedY);
		}
		/**
		 * main loop of sprite
		 * remove sprite when ttl>maxTimeToLive
		 */ 
		public function update(engine:BitmapEngine):void{
			
		}
		//
		internal function updateInternal(engine:BitmapEngine):void{
			_liveTime+=engine.elapsed;
			if(maxTimeToLive>0&&_liveTime>maxTimeToLive){
				engine.removeSprite(this);	
				return;
			}
			if(connected!=null){
				translateConnectedPoint.x=connectedX;
				translateConnectedPoint.y=connectedY;
				if(connected.angle!=0&&connectAutoRotate){
					translateConnectedPoint=connected.translatePoint(translateConnectedPoint);
					angle=connected.angle;
				}
				x=translateConnectedPoint.x+connected.x;
				y=translateConnectedPoint.y+connected.y;
				if(connected._isRemoved){
					connected=null;
				}
			}
		}
		/**
		 * translate internal point 
		 */ 
		public function translatePoint(p:Point):Point{
			var matrix:Matrix=BitmapEngine.MATRIX;
			matrix.identity();
			matrix.b = matrix.c = 0;
			matrix.a = scaleX ;
			matrix.d = scaleY ;
			matrix.tx = -originX * matrix.a;
			matrix.ty = -originY * matrix.d;
			if (angle != 0){
				matrix.rotate(angle *BitmapEngine.RAD);
			}
			matrix.tx += originX;
			matrix.ty += originY;
			return BitmapEngine.MATRIX.transformPoint(p);
		}
		/**
		 * is sprite alive
		 */ 
		public function get alive():Boolean{
			return !_isRemoved;
		}
		//
		public function get liveTime():Number{
			return _liveTime;
		}
		/**
		 * render function
		 */ 
		public function render(screen:Screen):void{
			if(BitmapEngine._debug&&BitmapEngine._debugBorder){
				drawDebug(screen);
			}
		}
		//
		private function drawDebug(screen:Screen):void{
			var shape:Shape=BitmapEngine.SHAPE;
			shape.graphics.clear();
			//border
			shape.graphics.lineStyle(1,0xFF0000,0.7);
			shape.graphics.drawRect(x,y,width,height);
			//origin
			shape.graphics.lineStyle(1,0x00FF00,0.7);
			shape.graphics.drawRect(x+originX,y+originY,1,1);
			//connncected
			if(connected!=null){
				shape.graphics.lineStyle(1,0xFFFF00,0.7);
				shape.graphics.drawRect(
					connected.x+translateConnectedPoint.x,
					connected.y+translateConnectedPoint.y,1,1);
			}
			//
			screen.buffer.draw(shape);
		}
		/**
		 * dispose function
		 */ 
		public function dispose():void{
		
		}
		/**
		 * is this sprite in screen
		 */ 
		public function inScreen(screen:Screen):Boolean{
			if(((angle == 0)) && (scaleX == 1) && (scaleY== 1)){
				return(
					(x+width >=0)
					&& (x< screen.width) 
					&& (y+height >=0)
					&& (y < screen.height));
			}
			var halfWidth:Number = width/2;
			var halfHeight:Number = height/2;
			var absScaleX:Number = (scaleX>0)?scaleX:-scaleX;
			var absScaleY:Number = (scaleY>0)?scaleY:-scaleY;
			var radius:Number = Math.sqrt(halfWidth*halfWidth+halfHeight*halfHeight)*((absScaleX >= absScaleY)?absScaleX:absScaleY);
			var tx:Number=x+ halfWidth;
			var ty:Number=y+ halfHeight;
			return ((tx + radius > 0) && (tx - radius < screen.width) && (ty + radius > 0) && (ty - radius < screen.height));
		}
		/**
		 * 
		 * clone sprite attribute
		 */ 
		public function clone():BaseSprite{
			var bs:BaseSprite=new BaseSprite();
			bs.angle=angle;
			bs.height=height;
			bs.originX=originX;
			bs.originY=originY;
			bs.scaleX=scaleX;
			bs.scaleY=scaleY;
			bs.x=x;
			bs.y=y;
			bs.autoDispose=autoDispose;
			return bs;
		}
		//
		public function toString():String{
			return "Sprite:["+name+"]";
		}
	}
}