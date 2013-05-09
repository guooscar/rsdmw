package king.of.roshan
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * BitmapFontLabel提供了使用位图作为字体渲染的Label
	 */ 
	public class BitmapFontSprite extends ImageSprite{
		/**
		 * 字体对齐方式左对齐
		 */ 
		public static const ALIGN_LEFT:int=1;
		/**
		 * 字体对齐方式居中
		 */ 
		public static const ALIGN_RIGHT:int=2;
		/**
		 * 字体对齐方式右对齐
		 */ 
		public static const ALIGN_CENTER:int=3;
		//
		private var fontSpriteSheet:BitmapFontSpriteSheet;
		private var cellSpace:int;
		private var _text:String="";
		private var _indent:int;
		
		/**
		 * 构造函数
		 * @param fontSpriteSheet 需要传递提供字体信息的FontSpriteSheet
		 * @param cellSpace 字间距，默认值为0
		 * 
		 */		
		public function BitmapFontSprite(fontSpriteSheet:BitmapFontSpriteSheet,cellSpace:int=0){
			super(null);
			this.fontSpriteSheet=fontSpriteSheet;
			this.cellSpace=cellSpace;
			_indent=0;
		}
	
		/**
		 * 设置首字缩进
		 * @param indent int类型
		 * 
		 */		
		public function set indent(indent:int):void{
			this._indent=indent;
		}

		/**
		 * 返回所显示的文本
		 * @return String
		 * 
		 */		
		public function get text():String{
			return _text;
		}
		
		/**
		 * 设置所显示的文本
		 * @param text 文本内容 String
		 * 
		 */		
		public function set text(text:String):void{
			this._text=text;			
			//
			var bd:BitmapData=new BitmapData(
				text.length*fontSpriteSheet.width,
				fontSpriteSheet.height,true,0);
			//
			var index:int=0;
			for(var i:int=0;i<text.length;i++){
				var char:String=text.charAt(i);
				var bitmap:BitmapData=fontSpriteSheet.getBitmapData(char);
				if(bitmap==null){
					continue;
				}
				var targetX:int=(index*fontSpriteSheet.width)+cellSpace*index+_indent;
				//
				var p:Point=BitmapEngine.POINT;
				p.x=targetX;
				p.y=0;
				//
				bd.copyPixels(bitmap,bitmap.rect,p);
				index++;
			}
			updateBuffer(bd);
		}
	}
}