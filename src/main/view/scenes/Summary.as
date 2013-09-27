package main.view.scenes
{
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Summary extends Sprite
	{
		private var overlay:Image = new Image(Root.assets.getTexture("summaryBG"));
		private var restartButton:Button;
		
		public function Summary()
		{
			this.overlay.alignPivot();
			this.overlay.width = BlockStorm.stageWidth * 0.92; 
			this.overlay.height = BlockStorm.stageHeight * 0.92; 
			this.overlay.x = BlockStorm.stageWidth * 0.5;
			this.overlay.y = BlockStorm.stageHeight * 0.5;
			this.overlay.alpha = 0.7;
			this.addChild(this.overlay);
			
			var button:Texture = Root.assets.getTexture("restart");
			
			this.restartButton = new Button(button, "LEVEL PLAY", button);
			this.restartButton.alignPivot();
			this.restartButton.x = BlockStorm.stageWidth * 0.5;
			this.restartButton.y = BlockStorm.stageHeight * 0.6;
			this.restartButton.width = BlockStorm.stageWidth * 0.1;
			this.restartButton.height = BlockStorm.stageWidth * 0.1;
			this.restartButton.addEventListener(Event.TRIGGERED, restartGame);
			this.addChild(this.restartButton);
			
			var backButton:Texture = Root.assets.getTexture("buttonMenu");
			var backToMenuButton:Button = new Button(backButton, "BACK TO MENU", backButton);
			
			backToMenuButton.alignPivot();
			backToMenuButton.width = BlockStorm.stageWidth * 0.6;
			backToMenuButton.height = BlockStorm.stageHeight * 0.1;
			backToMenuButton.x = BlockStorm.stageWidth * 0.5;
			backToMenuButton.y = BlockStorm.stageHeight * 0.3;
			backToMenuButton.addEventListener(Event.TRIGGERED, backToMenu);
			this.addChild(backToMenuButton);
		}
		
		private function backToMenu():void
		{
			this.visible = false;
			Starling.current.stage.dispatchEventWith(Root.BACK_TO_MENU, true);
		}
		
		private function restartGame():void
		{
			Starling.current.stage.dispatchEventWith(Scene.RESET, true);
			this.visible = false;
		}
	}
}