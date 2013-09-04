package blocks
{
	import UI.BirdPool;
	
	import gameTextures.BirdKind;
	
	import scenes.Scene;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	
	public class BlockPool extends Sprite
	{
		private var pool:Vector.<Block>;
		
		public function BlockPool()
		{
			trace("BlockPool()");
		}
		
		public function fillThePool(numBlocks:Number):void
		{
			trace("BlockPool fillThePool() " + numBlocks + " filling...");
			
			pool = new Vector.<Block>(numBlocks);
			
			var block:Block;
			
			for (var i:int = 0; i < pool.length; i++) 
			{
				var wild:Boolean = (Math.random() < .5) ? pool[i] = new Block(true) : pool[i] = new Block();
				
				if (i == pool.length - 1) 
				{
					trace("BlockPool() filled");
					Starling.current.stage.dispatchEventWith(Scene.POOL_FILLED);
				}
			}
		}
		
		public function getBlock():Block 
		{
			if (pool.length > 0) 
			{
				return pool.shift();
			} 
			else 
			{
				return new Block();
			}
		}
		
		public function returnBlock(block:Block):void 
		{
			pool.push(block);
			shuffleVector();
			
			trace("block returned: " + block.color);
		}
		
		public function shuffleVector():void
		{
			if (pool.length > 1) {
				
				var i:int = pool.length - 1;
				
				while (i > 0) 
				{
					var shuffle:Number 	= Math.round(Math.random() * (pool.length - 1));
					var block:Block 	= pool[shuffle];
					
					pool[shuffle] 	= pool[i];
					pool[i] 		= block;
					i--;
				}
			}
		}
	}
}