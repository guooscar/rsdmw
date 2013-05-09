package king.of.roshan
{	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 
	 */ 
	public class PreRotationSprite extends ImageSprite{
		private var frameCount:uint;
		private var _frame:Rectangle;
		private var _width:uint;
		private var rotationBitmapData:BitmapData;
		//
		public var frameAngle:int;
		private var lastAngle:uint=1;
		private var currentAngle:uint=0;
		
		
		//
		public function PreRotationSprite(bd:BitmapData,frameCount:uint){
			super(bd);
			this.frameCount=frameCount;
			createRotate();
		}
		//
		private function createRotate():void{
			_frame = new Rectangle(0, 0, 0, 0);
			var temp:BitmapData = buffer;
			var	size:uint = Math.ceil(distance(0, 0, temp.width, temp.height));
			//
			_frame.width = _frame.height = size;
			var width:uint = _frame.width * frameCount;
			var	height:uint = _frame.height;
			//
			rotationBitmapData = new BitmapData(width, height, true, 0);
			
			var m:Matrix = new Matrix(),
				a:Number = 0,
				aa:Number = (Math.PI * 2) / -frameCount,
				ox:uint = temp.width / 2,
				oy:uint = temp.height / 2,
				o:uint = _frame.width / 2,
				x:uint = 0,
				y:uint = 0;
			while (y < height){
				while (x < width){
					m.identity();
					m.translate(-ox, -oy);
					m.rotate(a);
					m.translate(o + x, o + y);
					rotationBitmapData.draw(temp, m, null, null, null, smooth);
					x += _frame.width;
					a += aa;
				}
				x = 0;
				y += _frame.height;
			}
			_width=rotationBitmapData.width;
			//resize buffer
			if(buffer){
				buffer.dispose();
			}
			buffer=new BitmapData(_frame.width,_frame.height);
		}
		public override function render(screen:Screen):void{
			frameAngle %= 360;
			if (frameAngle < 0) {
				frameAngle += 360;
			}
			currentAngle = uint(frameCount * (frameAngle / 360));
			
			if (lastAngle != currentAngle){
				lastAngle = currentAngle;
				_frame.x = _frame.width * lastAngle;
				_frame.y = uint(_frame.x / _width) * _frame.height;
				_frame.x %= _width;
				buffer.copyPixels(rotationBitmapData,_frame,new Point(0,0));
			}
			//
			super.render(screen);
		}
		//
		public static function distance(x1:Number, 
										y1:Number, 
										x2:Number = 0, 
										y2:Number = 0):Number{
			return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
		}
	}
}