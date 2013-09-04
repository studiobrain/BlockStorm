package blocks
{
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	import utils.Utility;
	
	public class QuadBatcher extends Sprite
	{
		public var quadbatch:QuadBatch;
		public var imagesVector:Vector.<Block>;
		
		private var block:Block;
		
		public function QuadBatcher()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, initGame);
		}
		
		private function initGame(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,initGame);
			
			this.quadbatch = new QuadBatch();
			this.addChild(quadbatch);
			
			this.imagesVector = new Vector.<Block>;
			
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(event:EnterFrameEvent):void
		{
			this.quadbatch.reset();
			batching();
		} 
		
		private function batching():void
		{
			if (this.imagesVector.length < 100)
			{
				createBlock();
			}
			
			for (var i:int = 0; i < this.imagesVector.length; i++)
			{
				this.quadbatch.addImage(this.imagesVector[i].blockImage);
			}
		}
		
		private function createBlock():void
		{
			block = new Block();
			block.visible = false;
			
			block.alignPivot();
			block.blockBody.position.x = Utility.randNum(block.width * 0.5, BlockStorm.stageRef.stageWidth - block.width * 0.5);
			block.blockBody.position.y = Utility.randNum(-block.height * 2, -block.height * 5);
			
			this.imagesVector.push(block);
		}
	}
}