package demo
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.sensors.Accelerometer;
	
	import king.of.roshan.Animation;
	import king.of.roshan.AnimationSprite;
	import king.of.roshan.BitmapEngine;
	import king.of.roshan.EmitterSprite;
	import king.of.roshan.ImageSprite;
	import king.of.roshan.SpriteSheetAnimation;

	/**
	 * 
	 */
	[SWF(width=1000, height=600,frameRate="60")]
	public class TestAnimationSprite extends Sprite{
		[Embed (source="assets/sprite_sheet.png" )]
		private static const ImageClass:Class;
		//
		[Embed (source="assets/logo2.png" )]
		private static const ParticleClass:Class;
		//
		private var animationSprite:AnimationSprite;
		private var emitterSprite:EmitterSprite;
		private var engine:BitmapEngine;
		//
		public function TestAnimationSprite(){
			//init engine with onEnterFrame callback  and 1000*600 screen size 
			//and 60 FPS
			engine=new BitmapEngine(onEnterFrame,1000,600,60);
			engine.start();
			engine.debug(true);//debug on 
			engine.debugBorder(true);
			addChild(engine.screen.scene);
			//
			animationSprite=new AnimationSprite();
			animationSprite.x=100;//position 
			animationSprite.y=100;
			//
			var spriteSheet:SpriteSheetAnimation=new SpriteSheetAnimation("a",10);
			spriteSheet.setSpriteSheet((new ImageClass() as Bitmap).bitmapData,2,4,0,8);
			animationSprite.addAnimation(spriteSheet);
			//
			engine.addSprite(animationSprite);//add an image sprite to default layer
			//
			emitterSprite=new EmitterSprite((new ParticleClass() as Bitmap).bitmapData);
			emitterSprite.connect(animationSprite,70,200,true);
			engine.addSprite(emitterSprite);
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
			if (Input.kd("SPACE")) {
				emitterSprite.emit(0,0,//pos
					1000,10,//vx vy
					500,//time
					10,10,//move x move y
					-0.5,-0.5,//scale x scale y
					180);
			}
			//
			if (Input.kd("P")) {
				animationSprite.play("a");
			}
			if (Input.kd("O")) {
				animationSprite.stop();
			}
			if (Input.kd("LEFT")) {
				animationSprite.x--;
			}
			if (Input.kd("RIGHT")) {
				animationSprite.x++;
			}
			if (Input.kd("UP")) {
				animationSprite.y--;
			}
			if (Input.kd("DOWN")) {
				animationSprite.y++;
			}
			//---------------------------------
			if (Input.kd("Z")) {
				animationSprite.angle--;
			}
			if (Input.kd("X")) {
				animationSprite.angle++;
			}
			//
			if (Input.kd("+")) {
				animationSprite.scaleX=animationSprite.scaleY=animationSprite.scaleX+0.05;
			}
			if (Input.kd("-")) {
				animationSprite.scaleX=animationSprite.scaleY=animationSprite.scaleX-0.05;
			}
		}
	}
}