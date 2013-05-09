package king.of.roshan
{
	/**
	 * 
	 */ 
	public class Tween{
		internal var node:LinkedListNode;
		internal var isRemoved:Boolean=false;
		internal var isKilled:Boolean=false;
		//
		private var time:Number=0;
		private var target:Object;
		private var options:Object={};
		private var callback:Function;
		private var ease:Function;
		public var onUpdate:Function;
		
		//
		private var cloneObject:Object={};
		//
		private var timeElasped:uint=0;
		//
		public function Tween(target:Object,
							  time:Number,
							  options:Object,
							  ease:Function=null,
							  callback:Function=null){	
			this.target=target;
			this.time=time;
			this.options=options;
			this.callback=callback;
			this.ease=ease;
			for(var key :String in options){
				cloneObject[key]=target[key];
			}
		}
		//
		public function update(engine:BitmapEngine):void{
			if(isKilled){
				engine.removeTween(this);
				return;
			}
			timeElasped+=engine.elapsed;
			// percent * diff
			var percent:Number=timeElasped/time;
			if(percent>1){
				finish(engine);
				return;
			}
			if(onUpdate!=null){
				onUpdate();
			}
			//
			if(ease!=null){
				percent=ease(percent);
			}
			for(var key :String in options){
				target[key]=cloneObject[key]+(options[key]-cloneObject[key])*percent;
			}
		}
		//
		//
		public function finish(engine:BitmapEngine):void{
			if(callback!=null){
				callback();
			}
			isKilled=true;
		}
		//
		public function kill():void{
			isKilled=true;
		}
	}
}