package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	
	import blocks.QuadBatcher;
	
	import physics.GameSpace;
	
	import scenes.Menu;
	import scenes.Scene;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	import utils.ProgressBar;
	
	public class Root extends Sprite
	{
		public static const BACK_TO_MENU:String = "back to menu";
		
		public static var starAssets:AssetManager;
		public static var logo:Image;
		public static var activeScene:Scene;
		
		private var menu:Menu;
		private var background:Image;
		private var loadedBG:Image;
		
		public function Root()
		{
			//this.addEventListener(Menu.START_GAME, startScene);
			Starling.current.stage.addEventListener(Menu.SELECTED, initGame);
			Starling.current.stage.addEventListener(Root.BACK_TO_MENU, showMenu);
		}
		
		public function start(background:Image, assets:AssetManager):void
		{
			trace("Root start()")
			
			this.background = background;
			
			Root.starAssets = assets;
			
			this.addChild(this.background);
			
			//trace("background.width: " + background.width);
			
			var progressBar:ProgressBar = new ProgressBar(BlockStorm.stageWidth * 0.5, BlockStorm.stageHeight * 0.05);
			progressBar.x = (BlockStorm.stageWidth * 0.5) - (progressBar.width * 0.5);
			progressBar.y = (BlockStorm.stageHeight * 0.75) - (progressBar.height * 0.5);
			addChild(progressBar);
			
			assets.loadQueue(function onProgress(ratio:Number):void
			{
				progressBar.ratio = ratio;
				
				if (ratio == 1)
					
					Starling.juggler.delayCall(function():void
					{
						progressBar.removeFromParent(true);
						Starling.current.stage.dispatchEventWith(Root.BACK_TO_MENU, true);
						
					}, 0.15);
			});
		}
		
		public function showMenu(event:Event):void
		{
			if (!this.loadedBG) setLoadedBG();
			
			if (!this.menu)
			{
				this.menu = new Menu();
			}
			
			Starling.current.stage.addChild(this.menu);
			this.menu.visible = true;
		}
		
		private function setLoadedBG():void
		{
			this.loadedBG = new Image(Root.assets.getTexture(BlockStorm.prefix + "_bg"));
			this.loadedBG.alignPivot();
			this.loadedBG.x = BlockStorm.stageWidth * 0.5;
			this.loadedBG.y = BlockStorm.stageHeight * 0.5;
			this.loadedBG.width = BlockStorm.stageWidth;
			this.loadedBG.height = BlockStorm.stageHeight;
			
			this.removeChild(this.background);
			this.addChild(this.loadedBG);
		}
		
		private function showScene(mode:String):void
		{
			trace("showScene: " + mode);
			
			if (!Root.activeScene) 
			{
				Root.activeScene = new Scene(mode);
				this.addChild(Root.activeScene);
			}
			else
			{
				Starling.current.stage.dispatchEventWith(Scene.RESET, true, mode);
			}
			
			Starling.current.stage.dispatchEventWith(Menu.HIDE, false);
		}
		
		private function initGame(event:Event, mode:String):void
		{
			trace("initGame: " + mode);
			switch (mode)
			{
				case "level": showScene("level"); break;
				case "marathon": showScene("marathon"); break;
			}
		}
		
		public static function get assets():AssetManager 
		{ 
			return Root.starAssets;
		}
	}
}