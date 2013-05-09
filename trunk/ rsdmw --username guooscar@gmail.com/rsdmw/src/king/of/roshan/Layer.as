package king.of.roshan
{
	public class Layer {
		internal var isVisible:Boolean=true;
		internal var node:LinkedListNode;
		internal var name:String;
		internal var sprites:LinkedList=new LinkedList();
		//
		public function toString():String{
			return "Layer:["+name+"]";
		}
	}
}