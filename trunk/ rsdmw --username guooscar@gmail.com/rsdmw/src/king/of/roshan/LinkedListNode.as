package king.of.roshan
{
	/**
	 * 
	 */ 
	internal class LinkedListNode{
		public function LinkedListNode(value:*){
			this.value=value;
			value.node=this;
		}
		internal var prior:LinkedListNode;
		internal var next:LinkedListNode;
		internal var value:*;
	}
}