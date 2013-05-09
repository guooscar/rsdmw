package king.of.roshan
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	/**
	 * 
	 */ 
	public class Screen{
		public var width:uint;
		public var height:uint;
		private var canvasBitmap:Bitmap;
		private var frameRate:uint;
		/**double buffer suface*/
		private var bitmap:Vector.<Bitmap> = new Vector.<Bitmap>(2);
		private var current:int = 0;
		private var color:uint = 0xFF202020;
		private var matrix:Matrix = new Matrix();
		private var bounds:Rectangle;
		//transform attr
		
		private var _originX:int;
		private var _originY:int;
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		private var _angle:Number = 0;
		//
		public var scene:Sprite;
		//
		private var infoTextField:TextField;
		private var backgroundSprite:Sprite;
		//
		/**draw buffer*/
		public var buffer:BitmapData;
		//
		public function Screen(width:uint,height:uint){
			this.width=width;
			this.height=height;
			initBitmap();
		}
		/*
		 *init cache bitmap 
		 */ 
		private function initBitmap():void{
			bitmap[0] = new Bitmap(new BitmapData(
				width, height,false, 0), 
				PixelSnapping.NEVER);
			bitmap[1] = new Bitmap(new BitmapData(
				width, height,false, 0), 
				PixelSnapping.NEVER);
			scene=new Sprite();
			scene.addChild(bitmap[0]).visible = true;
			scene.addChild(bitmap[1]).visible = false;
			buffer = bitmap[0].bitmapData;	
			//
			bounds=new Rectangle(0,0,width,height);
			//for debug
			infoTextField=new TextField();
			infoTextField.width=400;
			infoTextField.height=20;
			infoTextField.textColor=0xff0000;
			var tf:TextFormat=new TextFormat();
			tf.size=12;
			tf.font="Arial";
			infoTextField.defaultTextFormat=tf;
			backgroundSprite=new Sprite();
			backgroundSprite.graphics.beginFill(0x0,0.6);
			backgroundSprite.graphics.drawRect(0,0,400,20);
			backgroundSprite.graphics.endFill();
			scene.addChild(backgroundSprite);
			scene.addChild(infoTextField);
			showInfoTextField(false);
		}
		//
		internal function showDebugInfo(info:String):void{
			infoTextField.text=""+info;
		}
		//
		internal function showInfoTextField(isShow:Boolean):void{
			infoTextField.visible=isShow;
			backgroundSprite.visible=isShow;
		}
		/**
		 * Swaps screen buffers.
		 */
		public function swap():void{
			current = 1 - current;
			buffer = bitmap[current].bitmapData;
		}
		/**
		 * Refreshes the screen.
		 */
		public function refresh():void{
			buffer.lock();
			// refreshes the screen
			buffer.fillRect(bounds,color);
		}
		/**
		 * Redraws the screen.
		 */
		public function redraw():void{
			buffer.unlock();
			// refresh the buffers
			bitmap[current].visible = true;
			bitmap[1 - current].visible = false;
		}
		
		//
		/** @private Re-applies transformation matrix. */
		private function update():void{
			matrix.b = matrix.c = 0;
			matrix.a = _scaleX ;
			matrix.d = _scaleY ;
			matrix.tx = -_originX * matrix.a;
			matrix.ty = -_originY * matrix.d;
			if (_angle != 0){
				matrix.rotate(_angle*BitmapEngine.RAD);
			}
			matrix.tx += _originX  ;
			matrix.ty += _originY  ;
			//
			//
			scene.transform.matrix = matrix;
		}
		//
		
		public function get angle():Number{
			return _angle;
		}
		
		public function set angle(value:Number):void{
			if(_angle==value){
				return;
			}
			_angle = value;
			update();
		}
		
		public function get scaleY():Number{
			return _scaleY;
		}
		
		public function set scaleY(value:Number):void{
			if(_scaleY==value){
				return;
			}
			_scaleY = value;
			update();
		}
		
		public function get scaleX():Number{
			return _scaleX;
		}
		
		public function set scaleX(value:Number):void{
			if(_scaleX==value){
				return;
			}
			_scaleX = value;
			update();
		}
		
		public function get originY():int{
			return _originY;
		}
		
		public function set originY(value:int):void{
			if(_originY==value){
				return;
			}
			_originY = value;
			update();
		}
		
		public function get originX():int{
			return _originX;
		}
		
		public function set originX(value:int):void{
			if(_originX==value){
				return;
			}
			_originX = value;
			update();
		}
	}
}