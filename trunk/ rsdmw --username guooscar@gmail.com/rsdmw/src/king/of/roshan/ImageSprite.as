package king.of.roshan
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * simple image sprite support position change,scale change,alpha change
	 * apply filter,change colorTransform
	 */ 
	public class ImageSprite extends BaseSprite{
		
		protected var buffer:BitmapData;
		protected var bitmap:Bitmap;
		protected var _colorTransform:ColorTransform;
		protected var _alpha:Number;
		protected var rect:Rectangle;
		protected var orginalBitmapData:BitmapData;
		protected var _filter:BitmapFilter;
		//
	
		/**
		 * If the image should be drawn transformed with pixel smoothing.
		 * This will affect drawing performance, but look less pixelly.
		 */
		public var smooth:Boolean=true;
		
		/**
		 * Optional blend mode to use when drawing this image.
		 * Use constants from the flash.display.BlendMode class.
		 */
		public var blend:String;
		//
		public function ImageSprite(bd:BitmapData){
			super();
			updateBuffer(bd);
			_colorTransform=null;
		}
		//
		protected function updateBuffer(bf:BitmapData):void{
			if(!bf){
				return;
			}
			if(buffer){
				buffer.dispose();
			}else{
				this.orginalBitmapData=bf.clone();
			}
			buffer=bf;
			width=(buffer.width);
			height=(buffer.height);
			bitmap=new Bitmap(bf);
			rect=buffer.rect;
			if(_filter!=null){
				var p:Point=BitmapEngine.POINT;
				p.x=p.y=0;
				buffer.applyFilter(buffer,buffer.rect,p,_filter);
			}
		}
		//
		public override function render(screen:Screen):void{
			super.render(screen);
			var point:Point=BitmapEngine.POINT;
			// quit if no graphic is assigned
			if(!buffer){
				return;
			}
			// determine drawing location
			point.x = x-BitmapEngine.cameraX;
			point.y = y-BitmapEngine.cameraY;
			// render without transformation
			if (angle == 0 && scaleX  == 1 && scaleY == 1 && !blend){
				screen.buffer.copyPixels(buffer,rect,point, null, null, true);
				return;
			}
			// render with transformation
			var matrix:Matrix=BitmapEngine.MATRIX;
			matrix.b = matrix.c = 0;
			matrix.a = scaleX ;
			matrix.d = scaleY ;
			matrix.tx = -originX * matrix.a;
			matrix.ty = -originY * matrix.d;
			if (angle != 0){
				matrix.rotate(angle *BitmapEngine.RAD);
			}
			matrix.tx += originX + point.x;
			matrix.ty += originY + point.y;
			bitmap.smoothing = smooth;
			screen.buffer.draw(bitmap, matrix, null, blend, null, smooth);
		}
		//
		public function resetBuffer():void{
			updateBuffer(orginalBitmapData.clone());
		}
		//
		public function set colorTransform(value:ColorTransform):void{
			_colorTransform=value;
			resetBuffer();
			buffer.colorTransform(buffer.rect,value);
		}
		/**
		 * get color transform of sprite
		 */ 
		public function get colorTransform():ColorTransform{
			return _colorTransform;
		}
		//
		public function get alpha():Number{
			
			return _alpha;
		}
		//
		public function set alpha(a:Number):void{
			a = a < 0 ? 0 : (a > 1 ? 1 : a);
			_alpha=a;	
			if(_colorTransform==null){
				_colorTransform=new ColorTransform();
			}
			_colorTransform.alphaMultiplier=a;
			colorTransform=_colorTransform;
		}
		/**
		 * apply filter to bitmap
		 */ 
		public function applyFilter(filter:BitmapFilter):void{
			var p:Point=BitmapEngine.POINT;
			p.x=p.y=0;
			_filter=filter;
			buffer.applyFilter(buffer,buffer.rect,p,filter);
		}
		/**
		 * remove all filter
		 */ 
		public function removeFilter():void{
			_filter=null;
			resetBuffer();
		}
		//
		public override function dispose():void{
			
		}
	}
}