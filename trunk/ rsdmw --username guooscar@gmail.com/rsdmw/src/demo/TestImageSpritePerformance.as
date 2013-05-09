package demo
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import king.of.roshan.BitmapEngine;
	import king.of.roshan.ImageSprite;

	/**
	 * 
	 */
	[SWF(width=1000, height=600,frameRate="60")]
	public class TestImageSpritePerformance extends Sprite{
		[Embed (source="assets/logo2.png" )]
		private static const ImageClass:Class;
		//
		private var engine:BitmapEngine;
		private var imageSpriteArray:Array=[];
		//share bitmapdata in all sprite
		private var bitmapData:BitmapData=(new ImageClass() as Bitmap).bitmapData;
		
		//
		public function TestImageSpritePerformance(){
			//init engine with onEnterFrame callback  and 1000*600 screen size 
			//and 60 FPS
			engine=new BitmapEngine(onEnterFrame,1000,600,60);
			engine.start();
			engine.debug(true);//debug on 
			engine.debugBorder(false);
			addChild(engine.screen.scene);
			for(var i:int=0;i<1000;i++){
				var imageSprite:ImageSprite=new ImageSprite(bitmapData);
				imageSprite.name="image"+i;
				engine.addSprite(imageSprite);//add an image sprite to default layer
				imageSpriteArray.push(imageSprite);
			}
			//
			addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		//
		private function onAddToStage(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			Input.initialize(stage);
		}
		//
		private function onEnterFrame():void{
			//random all sprite position
			for(var i:int=0;i<imageSpriteArray.length;i++){
				var sprite:ImageSprite=imageSpriteArray[i];
				sprite.x=Math.random()*1000;
				sprite.y=Math.random()*600;
			}
			//
			if (Input.kd("A")) {
				var imageSprite:ImageSprite=new ImageSprite(bitmapData);
				imageSpriteArray.push(imageSprite);
				engine.addSprite(sprite);
			}
		}
	}
}