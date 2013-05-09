package king.of.roshan{
	import flash.display.BitmapData;

	/***
	 * 
	 */ 
	public class GraphicsUtil{
		/**
		 * http://www.simppa.fi/blog/extremely-fast-line-algorithm-as3-optimized/
		 * Draws a pixelated, non-antialiased line.
		 * @param	x1		Starting x position.
		 * @param	y1		Starting y position.
		 * @param	x2		Ending x position.
		 * @param	y2		Ending y position.
		 * @param	color	Color of the line.
		 */
		public static function line(target:BitmapData,
									x:int, 
									y:int,
									x2:int, 
									y2:int, 
									color:uint = 0xFFFFFF, 
									alpha:Number = 1.0):void{
			color = (uint(alpha * 0xFF) << 24) | (color & 0xFFFFFF);
			var shortLen:int = y2-y;
			var longLen:int = x2-x;
			if((shortLen ^ (shortLen >> 31)) 
				-(shortLen >> 31) 
				> (longLen ^ (longLen >> 31)) 
				- (longLen >> 31)){
				shortLen ^= longLen;
				longLen ^= shortLen;
				shortLen ^= longLen;
				
				var yLonger:Boolean = true;
			}else{
				yLonger = false;
			}
			
			var inc:int = longLen < 0 ? -1 : 1;
			var multDiff:Number = longLen == 0 ? shortLen : shortLen / longLen;
			if (yLonger){
				for (var i:int = 0; i != longLen; i += inc){
					target.setPixel(x + i*multDiff, y+i, color);
				}
			}else{
				for (i = 0; i != longLen; i += inc){
					target.setPixel(x+i, y+i*multDiff, color);
				}
			}
		}
		//
		/**
		 * Draws a non-filled, pixelated circle.
		 * @param	x			Center x position.
		 * @param	y			Center y position.
		 * @param	radius		Radius of the circle.
		 * @param	color		Color of the circle.
		 */
		public static function circle(target:BitmapData,
									  x:int, 
									  y:int, 
									  radius:int, 
									  color:uint = 0xFFFFFF):void{
			if (color < 0xFF000000) color = 0xFF000000 | color;
			var f:int = 1 - radius,
				fx:int = 1,
				fy:int = -2 * radius,
				xx:int = 0,
				yy:int = radius;
			target.setPixel32(x, y + radius, color);
			target.setPixel32(x, y - radius, color);
			target.setPixel32(x + radius, y, color);
			target.setPixel32(x - radius, y, color);
			while (xx < yy){
				if (f >= 0) {
					yy --;
					fy += 2;
					f += fy;
				}
				xx ++;
				fx += 2;
				f += fx;    
				target.setPixel32(x + xx, y + yy, color);
				target.setPixel32(x - xx, y + yy, color);
				target.setPixel32(x + xx, y - yy, color);
				target.setPixel32(x - xx, y - yy, color);
				target.setPixel32(x + yy, y + xx, color);
				target.setPixel32(x - yy, y + xx, color);
				target.setPixel32(x + yy, y - xx, color);
				target.setPixel32(x - yy, y - xx, color);
			}
		}
		//
	}
}