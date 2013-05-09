package king.of.roshan
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 *
	 */ 
	public class TextSprite extends ImageSprite{
		public var textField:TextField;
		private var content:String;
		//
		public function TextSprite(text:String){
			textField=new TextField();
			this.content=text;
			textField.text=content;
			var bitmapData:BitmapData=new BitmapData(textField.width+4,textField.height+4,true,0);
			super(bitmapData);
			updateTextBuffer();
		}
		//
		public function updateTextField():void{
			updateTextBuffer();
			text=this.content;
		}
		//
		private function updateTextBuffer():void{
			textField.width = width;
			var _textWidth:Number = textField.textWidth + 4;
			var _textHeight:Number = textField.textHeight + 4;
			if ((_textWidth > width || _textHeight > height)){
				if (width < _textWidth) {
					width = _textWidth;
				}
				if (height < _textHeight) {
					height = _textHeight;
				}
			}
			//update buffer
			if (width > buffer.width || height > buffer.height){
				buffer = new BitmapData(
					Math.max(width, buffer.width),
					Math.max(height, buffer.height),
					true, 0);
				rect=buffer.rect;
			}
			buffer.fillRect(rect,0);
			//
			buffer.draw(textField);
		}
		//
		public function set text(value:String):void{
			content=value;
			textField.text=value;
			updateTextBuffer();
		}
		//
		public function get text():String{
			return content;
		}
	}
}