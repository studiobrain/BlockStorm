package 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import main.view.BlockPool;
	import dump.QuadBatcher;
	
	import main.view.physics.GameSpace;
	
	import main.view.scenes.Menu;
	import main.view.scenes.Scene;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	import utils.ProgressBar;
	
	public class Root extends Sprite
	{
		public static const STOCK_THE_POOL:String = "stock the pool";
		public static const BACK_TO_MENU:String = "back to menu";
		
		public static var space:GameSpace = new GameSpace();
		public static var starAssets:AssetManager;
		public static var background:Image;
		public static var logo:Image;
		public static var activeScene:Scene;
		public static var menu:Menu;
		public static var blockPool:BlockPool;
		
		private var loadedBG:Image;
		
		
		public function Root()
		{
			//this.addEventListener(Menu.START_GAME, startScene);
			Starling.current.stage.addEventListener(Menu.SELECTED, initGame);
			Starling.current.stage.addEventListener(Root.STOCK_THE_POOL, stockPool);
			//Starling.current.stage.addEventListener(Root.BACK_TO_MENU, showMenu);
		}
		
		private function stockPool():void
		{
			Root.blockPool = new BlockPool();
			Root.blockPool.fillThePool(100);
		}
		
		public function start(background:Image, assets:AssetManager):void
		{
			trace("Root start()")
			
			Root.background = background;
			Root.starAssets = assets;
			
			addChild(Root.space);
			addChild(Root.background);
			
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
						Starling.current.stage.dispatchEventWith(Root.STOCK_THE_POOL);
						Starling.current.stage.dispatchEventWith(Root.BACK_TO_MENU);
						
					}, 0.15);
			});
		}
		
		public static function showMenu(event:Event):void
		{
			trace("Root showMenu()");
			
			if (!Root.menu)
			{
				Root.menu = new Menu();
			}
			
			TweenMax.to(Root.background, 0.25, {x:-Root.background.width * 0.25});
			
			
			Starling.current.stage.addChild(Root.menu);
			Root.menu.visible = true;
			TweenMax.to(Root.menu, 0.25, {x:0, ease:Back.easeOut});
		}
		
		private function setLoadedBG():void
		{
			this.loadedBG = new Image(Root.assets.getTexture(BlockStorm.prefix + "_bg"));
			this.loadedBG.scaleX = this.loadedBG.scaleY = BlockStorm.scaleFactor;
			//this.loadedBG.alignPivot();
			//this.loadedBG.x = BlockStorm.stageWidth * 0.5;
			//this.loadedBG.y = BlockStorm.stageHeight * 0.5;
			//this.loadedBG.width = BlockStorm.stageWidth * 3;
			//this.loadedBG.height = BlockStorm.stageHeight;
			
			this.removeChild(Root.background);
			this.addChild(this.loadedBG);
		}
		
		private function showScene(mode:String):void
		{
			trace("Root showScene: " + mode);
			
			if (!Root.activeScene) 
			{
				Root.activeScene = new Scene(mode);
				this.addChild(Root.activeScene);
			}
			else
			{
				Starling.current.stage.dispatchEventWith(Scene.RESET, false, mode);
			}
		}
		
		private function initGame(event:Event, mode:String):void
		{
			trace("Root initGame: " + mode);
			
			TweenMax.to(Root.background, 0.5, {x:-Root.background.width * 0.5, onComplete:showScene, onCompleteParams:[mode]});
			
			Starling.current.stage.dispatchEventWith(Menu.HIDE);
			
			/*switch (mode)
			{
				case "level": showScene("level"); break;
				case "marathon": showScene("marathon"); break;
			}*/
		}
		
		public static function get assets():AssetManager 
		{ 
			return Root.starAssets;
		}
	}
}