package king.of.roshan
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 图片字体
	 */ 
	public class BitmapFontSpriteSheet{
		/**水平摆放*/ 
		public static const LAYOUT_HORIZONTAL:int=1;
		/**垂直摆放*/
		public static const LAYOUT_VERTICAL:int=2;

		private var spriteSheetBitmapData:BitmapData;
		private var fonts:String;
		private var layout:int;
		private var bitmapArray:Array;
		public var width:Number=0;
		public var height:Number=0;
		//
		/**
		 *字体样式表 
		 * @param spriteSheetBitmapData 字体文字表位图
		 * @param fonts 文字
		 * @param layout 排列方式，1 水平排列，2 垂直排列
		 * 
		 */		
		public function BitmapFontSpriteSheet(
			spriteSheetBitmapData:BitmapData,
			fonts:String,
			layout:int=LAYOUT_HORIZONTAL
		){
			this.spriteSheetBitmapData=spriteSheetBitmapData;
			this.fonts=fonts;
			this.layout=layout;
			bitmapArray=new Array();
			setupBitmapArray();
		}
		//
		private function setupBitmapArray():void{
			var totalFontCount:int=fonts.length;
			var cellWidth:Number;
			var cellHeight:Number;
			if(layout==LAYOUT_HORIZONTAL){
				cellWidth=spriteSheetBitmapData.width/totalFontCount;
				cellHeight=spriteSheetBitmapData.height;
			}
			if(layout==LAYOUT_VERTICAL){
				cellWidth=spriteSheetBitmapData.width;
				cellHeight=spriteSheetBitmapData.height/totalFontCount;
			}
			for(var i:int=0;i<totalFontCount;i++){
				var bd:BitmapData=new BitmapData(cellWidth,cellHeight);
				var rect:Rectangle=new Rectangle();
				if(layout==LAYOUT_HORIZONTAL){
					rect.left=i*cellWidth;
					rect.top=0;
				}
				if(layout==LAYOUT_VERTICAL){
					rect.left=0;
					rect.top=i*cellHeight;
				}
				rect.width=cellWidth;
				rect.height=cellHeight;
				var destPoint:Point=new Point();
				destPoint.x=0;
				destPoint.y=0;
				bd.copyPixels(spriteSheetBitmapData,rect,destPoint);
				bitmapArray[fonts.charAt(i)]=bd;
			}
			width=cellWidth;
			height=cellHeight;
		}
		//
		/**
		 *获取某字对应的位图
		 * @param input String
		 * @return BitmapData
		 * 
		 */		
		public function getBitmapData(input:String):BitmapData{
			return bitmapArray[input];
		}
		/**
		 *清除 
		 * 
		 */		
		public function clear():void{
			bitmapArray=[];
		}
	}
}
