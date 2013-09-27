package main.view.scenes
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class Menu extends Sprite
	{
		public static const SELECTED:String = "game selected";
		public static const REVEAL:String = "reveal menu";
		public static const HIDE:String = "reveal hide";
		
		public var container:Sprite;
		public var level:int;
		public var menuTop:Sprite;
		public var menuRight:Sprite;
		public var menuBottom:Sprite;
		public var menuLeft:Sprite;
		
		private var top:Texture;
		private var topBack:Texture;
		private var right:Texture;
		private var rightBack:Texture
		private var bottom:Texture;
		private var bottomBack:Texture
		private var left:Texture;
		private var leftBack:Texture;
		private var scaling:Number = BlockStorm.scaleFactor * 0.65;
		
		private var buttonBlue:Texture;
		private var buttonOrange:Texture;
		private var buttonLevel:Button
		private var buttonMarathon:Button;
		private var topButton:Button;
		private var topButtonBack:Button;
		private var rightButton:Button;
		private var rightButtonBack:Button;
		private var menuArrows:Array = [];
		private var menuReveal:TimelineMax;
		private var desaturate:ColorMatrixFilter = new ColorMatrixFilter();
		
		private var returnPosX:Number = BlockStorm.stageWidth * 0.5;
		private var returnPosY:Number = BlockStorm.stageHeight * 0.5;
		private var logo:Image; 
		private var statusText:TextField; 
		
		public function Menu()
		{
			trace("Menu");
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			this.desaturate.adjustSaturation(-0.8);
		}
		
		private function onAddedToStage():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			Starling.current.stage.addEventListener(Menu.REVEAL, revealMenu);
			Starling.current.stage.addEventListener(Menu.HIDE, hideMenu);
			
			this.container 			= new Sprite();
			this.container.alignPivot();
			this.container.x 		= BlockStorm.stageWidth * 0.5;
			this.container.y 		= BlockStorm.stageHeight * 0.5;
			
			this.logo = new Image(Root.assets.getTexture(BlockStorm.prefix + "_logo"));
			this.logo.alignPivot();
			this.logo.scaleX = this.logo.scaleY = BlockStorm.scaleFactor;
			this.logo.y = -BlockStorm.stageHeight * 0.0525;
			
			this.container.addChild(this.logo);
			
			this.buttonBlue = Root.assets.getTexture(BlockStorm.prefix + "_levels");
			this.buttonOrange = Root.assets.getTexture(BlockStorm.prefix + "_marathon");
			
			
			this.buttonLevel = new Button(this.buttonBlue, "", this.buttonBlue);
			this.buttonLevel.alignPivot();
			//this.buttonLevel.width = BlockStorm.stageWidth * 0.75;
			//this.buttonLevel.height = BlockStorm.stageHeight * 0.15;
			this.buttonLevel.scaleX = this.buttonLevel.scaleY = BlockStorm.scaleFactor;
			this.buttonLevel.x = BlockStorm.stageWidth * 0.5;
			this.buttonLevel.y = (BlockStorm.stageHeight * 0.5) - this.buttonLevel.height;
			this.buttonLevel.addEventListener(Event.TRIGGERED, levelTriggered);
			this.addChild(this.buttonLevel);
			
			this.buttonMarathon  = new Button(this.buttonOrange, "", this.buttonOrange);
			this.buttonMarathon.alignPivot();
			//this.buttonMarathon.width = BlockStorm.stageWidth * 0.75;
			//this.buttonMarathon.height = BlockStorm.stageHeight * 0.15;
			this.buttonMarathon.scaleX = this.buttonMarathon.scaleY = BlockStorm.scaleFactor;
			this.buttonMarathon.x = BlockStorm.stageWidth * 0.5;
			this.buttonMarathon.y = (BlockStorm.stageHeight * 0.5) + this.buttonMarathon.height;
			this.buttonMarathon.addEventListener(Event.TRIGGERED, marathonTriggered);
			this.addChild(this.buttonMarathon);
			
			this.x = BlockStorm.stageWidth;
		}
		
		public function hideMenu(event:Event):void
		{
			//Scene.hud.blockText.visible = true;
			//Scene.hud.scoreText.visible = true;
			//Root.activeScene.alpha = 1;
			TweenMax.to(this, 0.35, {x:-BlockStorm.stageWidth, ease:Back.easeIn});
			//this.menuReveal.reverse();
			
			//TweenMax.to(this.statusText, 0.5, {autoAlpha:0, delay:2});
		}
		
		public function revealMenu(event:Event):void
		{
			//TweenMax.to(this, 0.5, {x:0, ease:Back.easeOut});
			//Scene.hud.blockText.visible = false;
			//Scene.hud.scoreText.visible = false;
			//this.visible = true;
			//this.menuReveal.play();
		}
		
		private function levelTriggered(event:Event):void
		{
			trace("LEVEL PLAY");
			
			startGame("level");
		}
		
		private function marathonTriggered(event:Event):void
		{
			trace("MARATHON");
			
			startGame("marathon");
		}
		
		public function startGame(mode:String):void
		{
			Starling.current.stage.dispatchEventWith(Menu.SELECTED, false, mode);
		}
	}
}