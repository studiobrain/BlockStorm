package main.view
{
	
	import main.view.physics.GameSpace;
	
	import main.view.scenes.Menu;
	import main.view.scenes.Scene;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class Hud extends Sprite
	{
		public var scoreText:TextField;
		public var mode:String;
		public var score:Number = 0;
		public var blockText:TextField;
		public var blockAmt:Number = 0;
		public var inGameMenuButton:Button;
		public var paused:Boolean;
		public var button:Texture = Root.assets.getTexture("cog");
		
		public function Hud(mode:String)
		{
			this.mode = mode;
			
			this.scoreText = new TextField(BlockStorm.stageWidth * 0.5, BlockStorm.stageHeight * 0.05, "Score", "BS_Bahaus", 50, 0x6ea8e1);
			this.scoreText.autoScale 	= true;
			this.scoreText.vAlign 		= "top";
			this.scoreText.hAlign 		= "left";
			this.scoreText.x 			= this.scoreText.width * 0.025;
			this.scoreText.y 			= this.scoreText.height * 0.025;
			this.scoreText.text 		= "Score: " + String(this.score);
			//this.scoreText.border 		= true;
			this.addChild(this.scoreText);
			
			this.blockText = new TextField(BlockStorm.stageWidth * 0.5, BlockStorm.stageHeight * 0.05, "Blocks", "BS_Bahaus", 50, 0x6ea8e1);
			this.blockText.autoScale 	= true;
			this.blockText.vAlign 		= "top";
			this.blockText.hAlign 		= "left";
			this.blockText.x 			= this.blockText.width * 0.025;
			this.blockText.y 			= this.scoreText.y + this.scoreText.height;
			this.blockText.text 		= "Blocks: " + String(blockAmt);
			//this.blockText.border 		= true;
			this.addChild(this.blockText);
			
			this.inGameMenuButton = new Button(button, "", button);
			this.inGameMenuButton.alignPivot();
			this.inGameMenuButton.x = BlockStorm.stageWidth - this.inGameMenuButton.width * 0.6;
			this.inGameMenuButton.y = this.inGameMenuButton.height * 0.6;
			this.inGameMenuButton.width = BlockStorm.stageWidth * 0.1;
			this.inGameMenuButton.height = BlockStorm.stageWidth * 0.1;
			this.inGameMenuButton.addEventListener(Event.TRIGGERED, inGameMenuTriggered);
			this.addChild(this.inGameMenuButton);
			
			if (this.mode == "levels") addLevelMeter();
		}
		
		private function addLevelMeter():void
		{ 
			// TODO Auto Generated method stub
			
		}
		
		private function inGameMenuTriggered():void
		{
			paused = !paused;
			
			trace("paused: " + paused);
			
			if (paused == true)
			{
				Starling.current.stage.dispatchEventWith(GameSpace.PAUSE, true);
				Starling.current.stage.dispatchEventWith(Menu.REVEAL, true);
				Scene.marathonDropTime.stop();
			}
			else
			{
				Starling.current.stage.dispatchEventWith(GameSpace.RESUME, true);
				Starling.current.stage.dispatchEventWith(Menu.HIDE, true);
				Scene.marathonDropTime.start();
			}
		}
		
		public function updateScore(block:Block, bonus:Boolean):void
		{
			if (this.mode == "levels") 
			{
				
			}
			else
			{
				bonus == true ? this.score += (block.blockWorth * 1.5) : this.score += block.blockWorth;
				this.blockAmt += 1;
			}
			
			this.scoreText.text = "Score: " + String(this.score);
			this.blockText.text = "Blocks: " + this.blockAmt;
			//this.scoreText.color = block.color;
			//this.blockText.color = block.color;
		}
	}
}