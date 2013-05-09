package demo
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import king.of.roshan.BitmapEngine;
	import king.of.roshan.ImageSprite;

	/**
	 * 
	 */
	[SWF(width=1000, height=600,frameRate="60")]
	public class TestImageSprite extends Sprite{
		[Embed (source="assets/logo1.png" )]
		private static const ImageClass:Class;
		//
		private var imageSprite:ImageSprite;
		private var engine:BitmapEngine;
		//
		public function TestImageSprite(){
			//init engine with onEnterFrame callback  and 1000*600 screen size 
			//and 60 FPS
			engine=new BitmapEngine(onEnterFrame,1000,600,60);
			engine.start();
			engine.debug(true);//debug on 
			/*
			 *about debug information  
			 * FPS:frame pre second
			 * TL:total layer count
			 * RL:render layer count
			 * TS:total sprite count
			 * US:update sprite count
			 * RS:render sprite count
			 * TT:tween count 
			 */ 
			addChild(engine.screen.scene);
			//
			imageSprite=new ImageSprite((new ImageClass() as Bitmap).bitmapData);
			imageSprite.x=100;//position 
			imageSprite.y=100;
			imageSprite.alpha=0.8;//alpha
			imageSprite.scaleX=0.5;//scale
			imageSprite.scaleY=0.5;
			imageSprite.angle=30;//rotate
			//
			//just like flash sprite register point
			imageSprite.originX=imageSprite.width/2;
			imageSprite.originY=imageSprite.height/2;
			//
			engine.addSprite(imageSprite);//add an image sprite to default layer
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
			if (Input.kd("LEFT")) {
				imageSprite.x--;
			}
			if (Input.kd("RIGHT")) {
				imageSprite.x++;
			}
			if (Input.kd("UP")) {
				imageSprite.y--;
			}
			if (Input.kd("DOWN")) {
				imageSprite.y++;
			}
			//---------------------------------
			if (Input.kd("Z")) {
				imageSprite.angle--;
			}
			if (Input.kd("X")) {
				imageSprite.angle++;
			}
			//
			if (Input.kd("+")) {
				imageSprite.scaleX=imageSprite.scaleY=imageSprite.scaleX+0.05;
			}
			if (Input.kd("-")) {
				imageSprite.scaleX=imageSprite.scaleY=imageSprite.scaleX-0.05;
			}
			//
			if (Input.kd("A")) {
				imageSprite.alpha-=0.05;
			}
			if (Input.kd("S")) {
				imageSprite.alpha+=0.05;
			}
		}
	}
}