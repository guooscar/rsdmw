package king.of.roshan
{
	/**
	 * 
	 */ 
	internal class LinkedList{
		internal var firstNode:LinkedListNode;
		internal var  lastNode:LinkedListNode;		
		private var  _size:uint=0;
		//
		public function clear():void{
			_size=0;
			firstNode=lastNode=null;
		}
		//
		public static function swap(node1:LinkedListNode,node2:LinkedListNode):void{
			var t:*=node1.value;
			node1.value=node2.value;
			node2.value=t;
			node1.value.node=node1;
			node2.value.node=node2;
		}
		//
		public function add(node:LinkedListNode):void{
			if(firstNode==null){
				firstNode=node;
				lastNode=node;
			}else{
				lastNode.next=node;
				node.prior=lastNode;
				lastNode=node;	
			}
			_size++;
		}
		//
		public function remove(node:LinkedListNode):LinkedListNode{
			var ret:LinkedListNode=node.next;;
			//tween is first of linkedlist
			if(firstNode==node){
				firstNode=node.next;
				if(node.next){
					node.next.prior=null;
				}
			}else{
				node.prior.next=node.next;
				if(node.next){
					node.next.prior=node.prior;
				}
				//update last
				if(lastNode==node){
					lastNode=node.prior;		
				}
			}
			_size--;
			return ret;
		}
		//
		public function get size():uint{
			return _size;
		}
	}
}