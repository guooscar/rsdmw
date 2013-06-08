package king.of.roshan
{
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * for MJ
	 */ 
	public class BitmapEngine{
		public static const RAD:Number = Math.PI / -180;
		/**shared point object*/ 
		public static const POINT:Point=new Point(0,0);
		/**shared rectangle object*/ 
		public static const RECT:Rectangle=new Rectangle(0,0,0,0);
		/**shared matrix object*/ 
		public static const MATRIX:Matrix=new Matrix();
		/**shared shape object*/ 
		public static const SHAPE:Shape=new Shape();
		//
		internal static var _debug:Boolean=false;
		internal static var _debugBorder:Boolean=false;
		//
		internal var _width:uint;
		internal var _height:uint
		internal var isPause:Boolean=false;
		public var screen:Screen;
		//
		public static var cameraX:Number=0;
		public static var cameraY:Number=0;
		//
		public static var frameRate:Number = 60;
		public var realFrameRate:Number;
		//screen size information
		//----------------------------------------------------------------------
		private var delta:Number = 0;
		private var time:Number;
		private var last:Number;
		private var timer:Timer;
		internal var rate:Number;
		private var	skip:Number;
		private var	prev:Number;
		//
		public var elapsed:Number;
		//timer information
		
		// FrameRate tracking.
		private var frameLast:uint = 0;
		private var frameListSum:uint = 0;
		private var frameList:Vector.<uint> = new Vector.<uint>();
		//frame rate tracking
		//----------------------------------------------------------------------
		private var tickRate:uint = 4;
		private var maxElapsed:Number = 0.0333;
		private var maxFrameSkip:uint = 5;
		//frame rate information
		private var enterFrame:Function;
		private var currentSprite:BaseSprite;
		private var currentLayer:Layer;
		//
		//----------------------------------------------------------------------
		//
		private var layers:LinkedList=new LinkedList();
		//
		//tween
		private var tweens:LinkedList=new LinkedList();
		//
		//for debug
		private var _totalLayerCount:uint=0;
		private var _renderLayerCount:uint=0;
		private var _totalSpriteCount:uint=0;
		private var _updateSpriteCount:uint=0;
		private var _renderSpriteCount:uint=0;
		private var _totalTweenCount:uint=0;
		
		//
		public static const FIRST_LAYER_NAME:String="$f$";
		
		//-
		/**
		 * Constructor. Defines startup information about your game.
		 * @param	width			The width of your game.
		 * @param	height			The height of your game.
		 * @param	frameRate		The game framerate, in frames per second.
		 */
		public function BitmapEngine(
			enterFrame:Function,
			width:uint, 
			height:uint,
			frameRate:Number =60){	
			this._width=width;
			this._height=height;
			BitmapEngine.frameRate=frameRate;
			this.enterFrame=enterFrame;
			//
			this.rate = 1000 / frameRate;
			
			//
			screen=new Screen(width,height);
			time=getTimer();
			//
			var firstLayer:Layer=new Layer();
			firstLayer.name=FIRST_LAYER_NAME;
			layers.add(new LinkedListNode(firstLayer));
		}
		//
		public function debug(isOpen:Boolean):void{
			_debug=isOpen;
			_debugBorder=true;
			screen.showInfoTextField(isOpen);
		}
		//
		public function debugBorder(isOpen:Boolean):void{
			_debugBorder=isOpen;
		}
		/**
		 * return width of bitmap engine scene
		 */ 
		public function get width():Number{
			return _width;
		}
		/**
		 * return height of bitmap engine scene
		 */ 
		public function get height():Number{
			return _height;
		}
		/**
		 * start main game loop
		 */ 
		public function start():void{
			// remove event listener
			skip = rate * (maxFrameSkip + 1);
			last = prev = getTimer();
			timer = new Timer(tickRate);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			cameraX=0;
			cameraY=0;
		}
		//--stat
		public 	function get  totalLayerCount():Number{
			return _totalLayerCount;
		}
		public 	function get  renderLayerCount():Number{
			return _renderLayerCount;
		}
		public 	function get  totalSpriteCount():Number{
			return _totalSpriteCount;
		}
		public 	function get  updateSpriteCount():Number{
			return _updateSpriteCount;
		}
		public 	function get  renderSpriteCount():Number{
			return _renderSpriteCount;
		}
		public 	function get  totalTweenCount():Number{
			return _totalTweenCount;
		}
		
		//
		/**
		 * pause game loop
		 */
		public function pause():void{
			isPause=true;
		}
		/**
		 * resume game loop
		 */ 
		public function resume():void{
			isPause=false;
		}
		//
		/** @private Fixed framerate game loop. */
		private function onTimer(e:TimerEvent):void{
			// update timer
			time = getTimer();
			delta += (time -last);
			last = time;
			// quit if a frame hasn't passed
			if (delta < rate||isPause){
				return;
			}	
			// update loop
			if (delta > skip) {
				delta = skip;
			}
			while (delta >= rate){
				elapsed = rate;
				// update timer
				delta -= rate;
				prev = time;
				
				// update loop
				enterFrame();
				//
				var tempLayerNode:LinkedListNode=layers.firstNode;
				//
				_totalSpriteCount=0;
				_updateSpriteCount=0;
				while(tempLayerNode){
					currentLayer=tempLayerNode.value;
					var currentSpriteNode:LinkedListNode=currentLayer.sprites.firstNode;
					while(currentSpriteNode){
						currentSprite=currentSpriteNode.value;
						_totalSpriteCount++;
						if(currentSprite.visible||!currentSprite.deadInHide){
							currentSprite.updateInternal(this);
							currentSprite.update(this);
							_updateSpriteCount++;
						}
						currentSpriteNode=currentSpriteNode.next;
					}
					tempLayerNode=tempLayerNode.next;
				}
				//update tween
				var tempTweenNode:LinkedListNode=tweens.firstNode;
				_totalTweenCount=0;
				while(tempTweenNode){
					_totalTweenCount++;
					tempTweenNode.value.update(this);
					tempTweenNode=tempTweenNode.next;
				}
				// update timer
				time = getTimer();
			}
			// render loop
			render();
		}
		/**
		 * Renders the game, rendering sprites.
		 */
		private function render():void{
			if(isPause){
				return;
			}
			if(_debug){
				screen.showDebugInfo("FPS:"+uint(realFrameRate)
					+"/TL:"+_totalLayerCount
					+"/RL:"+_renderLayerCount
					+"/TT:"+_totalTweenCount
					+"/TS:"+_totalSpriteCount
					+"/US:"+_updateSpriteCount
					+"/RS:"+_renderSpriteCount
				);
			}
			// frame rate tracking
			var t:Number = getTimer();
			if (!frameLast) {
				frameLast = t;
			}
			// render loop
			screen.swap();
			screen.refresh();
			
			//render sprite
			//
			var tempLayerNode:LinkedListNode=layers.firstNode;
			//
			_renderSpriteCount=0;
			_totalLayerCount=0;
			_renderLayerCount=0;
			//
			while(tempLayerNode){
				//invisible layer dont need render
				currentLayer=(tempLayerNode.value);
				_totalLayerCount++;
				if(currentLayer.isVisible){
					_renderLayerCount++;
					var currentSpriteNode:LinkedListNode=tempLayerNode.value.sprites.firstNode;
					while(currentSpriteNode){
						currentSprite=currentSpriteNode.value;
						if(currentSprite.visible&&currentSprite.inScreen(screen)){
							currentSprite.render(screen);	
							_renderSpriteCount++;
						}
						currentSpriteNode=currentSpriteNode.next;
					}
				}
				tempLayerNode=tempLayerNode.next;
			}
			screen.redraw();
			//frame rate tracking
			t = getTimer();
			frameListSum += (frameList[frameList.length] = t - frameLast);
			if (frameList.length > 10){
				frameListSum -= frameList.shift();
			}
			realFrameRate = 1000 / (frameListSum / frameList.length);
			frameLast = t;
		}
		//----------------------------------------------------------------------
		/**
		 * return if the layer specified by name contains
		 */ 
		public function containsLayer(name:String):Boolean{
			var layer:LinkedListNode;
			var temp:LinkedListNode=layers.firstNode;
			while(temp){
				if(temp.value.name==name){
					layer=temp;
					break;
				}
				temp=temp.next;
			}
			return layer!=null;
		}
		/**
		 * toggle layer display
		 */ 
		public function toggleLayerVisible(name:String):Boolean{
			var layer:Layer=getLayer(name).value;
			layer.isVisible=!layer.isVisible;
			return layer.isVisible;
		}
		/**
		 * return true if layer specified by name is visible
		 */ 
		public function isLayerVisible(name:String):Boolean{
			var layer:Layer=getLayer(name).value;
			return layer.isVisible;
		}
		/**
		 * set layer visible attribute
		 */ 
		public function setLayerVisible(name:String,isVisible:Boolean):void{
			var layer:Layer=getLayer(name).value;
			layer.isVisible=isVisible;
		}
		/**
		 * add name to engine
		 */ 
		public function addLayer(name:String):void{
			if(containsLayer(name)){
				return;
			}
			var layer:Layer=new Layer();
			layer.name=name;
			layers.add(new LinkedListNode(layer));
		}
		/**
		 * remove layer from engine
		 */ 
		public function removeLayer(name:String):void{
			var layer:Layer=getLayer(name).value;
			layers.remove(layer.node);
		}
		/**
		 * clear layer sprites
		 */ 
		public function clearLayer(name:String):void{
			var layer:Layer=getLayer(name).value;
			layer.sprites.clear();
		}
		//
		private function getLayer(layerName:String):LinkedListNode{
			var layer:LinkedListNode;
			var temp:LinkedListNode=layers.firstNode;
			while(temp){
				if(temp.value.name==layerName){
					layer=temp;
					break;
				}
				temp=temp.next;
			}
			if(layer==null){
				throw new Error("can not find layer with name:"+layerName);
			}
			return layer;
		}
		/**
		 * swap layer index
		 */ 
		public function swapLayer(l1:String,l2:String):void{
			var layer1:LinkedListNode=getLayer(l1);
			var layer2:LinkedListNode=getLayer(l2);
			LinkedList.swap(layer1,layer2);
		}
		/**
		 * swap sprite index
		 */ 
		public function swapSprite(sprite1:BaseSprite,sprite2:BaseSprite):void{
			LinkedList.swap(sprite1.node,sprite2.node);
		}
		/***
		 * add sprite to engine
		 */ 
		public function addSprite(sprite:BaseSprite,layerName:String=FIRST_LAYER_NAME):void{
			if(sprite.layer!=null){
				sprite.layer.sprites.remove(sprite.node);
			}
			var layer:Layer=getLayer(layerName).value;
			sprite.layer=layer;
			layer.sprites.add(new LinkedListNode(sprite));
		}
		/***
		 * remove sprite from engine
		 */ 
		public function removeSprite(sprite:BaseSprite):void{
			if(!sprite){
				return;
			}
			//invalite sprite
			if(sprite._isRemoved||!sprite.node){
				return;
			}
			sprite.layer.sprites.remove(sprite.node);
			//free sprite
			sprite._isRemoved=true;
			sprite.layer=null;
			sprite.node=null;
			if(sprite.autoDispose){
				sprite.dispose();
			}
			sprite=null;
		}
		//
		//----------------------------------------------------------------------
		//
		internal function addTween(tween:Tween):void{
			tweens.add(new LinkedListNode(tween));
		}
		//
		internal function removeTween(tween:Tween):void{
			if(!tween){
				return;
			}
			//invalite sprite
			if(tween.isRemoved||!tween.node){
				return;
			}
			tweens.remove(tween.node);
			//free tween
			tween.isRemoved=true;
			tween.node=null;
			tween=null;
		}
		/**
		 * add tween
		 */ 
		public function tween(target:Object,
							  time:Number,
							  options:Object,
							  ease:Function=null,
							  callback:Function=null):Tween{
			var t:Tween=new Tween(target,time,options,ease,callback);
			addTween(t);
			return t;
		}
		/**
		 * kill all tween
		 */ 
		public function clearTween():void{
			tweens.clear();
		}
		//----------------------------------------------------------------------
		/**
		 * disopse engine,stop world remove all layers,remove all tweens
		 */ 
		public function dispose():void{
			if(timer){
				timer.stop();
			}
			isPause=true;
			//
			//dispose all sprite
			var tempLayer:LinkedListNode=layers.firstNode;
			//
			while(tempLayer){
				var currentSpriteNode:LinkedListNode=tempLayer.value.sprites.firstNode;
				while(currentSpriteNode){
					currentSpriteNode.value.dispose();
					currentSpriteNode=currentSpriteNode.next;
				}
				tempLayer=tempLayer.next;
			}
			//
			layers.clear();
			tweens.clear();
		}
	}
}