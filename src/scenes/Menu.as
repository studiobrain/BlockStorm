package scenes
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	
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
		private var quotes:Array = [
			"there's a storm appraoching...",
			"your head is a block...",
			"high score is out of reach...",
			"maybe you should try Tetris...",
			"is the pizza ready yet...",
			"grab me one while your up...",
			"Angry Birds is way more fun...",
			"this better be a free game...",
			"fever! only cure more BlockStorm...",
			];
		
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
			
			initMenuButtons();
			
			this.container 			= new Sprite();
			this.container.alignPivot();
			this.container.x 		= BlockStorm.stageWidth * 0.5;
			this.container.y 		= BlockStorm.stageHeight * 0.5;
			
			this.logo = new Image(Root.assets.getTexture(BlockStorm.prefix + "_logo"));
			this.logo.alignPivot();
			this.logo.scaleX = this.logo.scaleY = BlockStorm.scaleFactor;
			this.logo.y = -BlockStorm.stageHeight * 0.0525;
			
			this.container.addChild(this.logo);
			
			this.buttonBlue = Root.assets.getTexture(BlockStorm.prefix + "_buttonBlue");
			this.buttonOrange = Root.assets.getTexture(BlockStorm.prefix + "_buttonOrange");
			
			this.menuTop 			= new Sprite();
			this.menuTop.alignPivot();
			this.menuTop.width 		= BlockStorm.stageWidth;
			this.menuTop.height 	= BlockStorm.stageHeight;
			//this.menuTop.x 			= BlockStorm.stageWidth * 0.5; 
			this.menuTop.y 			= -BlockStorm.stageHeight;
			initTopMenu();
			
			this.menuRight 			= new Sprite();
			this.menuRight.alignPivot();
			this.menuRight.width 	= BlockStorm.stageWidth;
			this.menuRight.height 	= BlockStorm.stageHeight;
			this.menuRight.x 		= this.menuRight.width * 1.5;
			//this.menuRight.y 		= BlockStorm.stageHeight * 0.5;
			initRightMenu();
			
			this.menuBottom 		= new Sprite();
			this.menuBottom.alignPivot();
			this.menuBottom.width 	= BlockStorm.stageWidth;
			this.menuBottom.height 	= BlockStorm.stageHeight;
			this.menuBottom.x 		= BlockStorm.stageWidth * 0.5;
			this.menuBottom.y 		= this.menuTop.height;
			initBottomMenu();
			
			this.menuLeft 			= new Sprite();
			this.menuLeft.alignPivot();
			this.menuLeft.width 	= BlockStorm.stageWidth;
			this.menuLeft.height 	= BlockStorm.stageHeight;
			this.menuLeft.x 		= -this.menuLeft.width;
			this.menuLeft.y 		= BlockStorm.stageHeight * 0.5;
			initLeftMenu();
			
			this.container.addChild(this.menuTop);
			this.container.addChild(this.menuRight);
			this.container.addChild(this.menuBottom);
			this.container.addChild(this.menuLeft);
			this.addChild(this.container);
			
			revealUI();
		}
		
		private function revealUI():void
		{
			var logoStart:Number = -BlockStorm.stageHeight * 0.0525;
			var top:Number = (-BlockStorm.stageHeight * 0.5) + this.topButton.height * 0.6;
			var topStart:Number = (-BlockStorm.stageHeight * 0.5) - this.topButton.height * 0.6;
			var right:Number = (BlockStorm.stageWidth * 0.5) - this.rightButton.width * 0.6;
			var rightStart:Number = (BlockStorm.stageWidth * 0.5) + this.rightButton.width * 0.6;
			
			this.menuReveal = new TimelineMax();
			this.menuReveal.appendMultiple([
				TweenMax.to(this.logo, 0.3, {y:0, scaleX:scaling, scaleY:scaling, 
					startAt:{
						scaleX:BlockStorm.scaleFactor, 
						scaleY:BlockStorm.scaleFactor, 
						y:logoStart}, ease:Circ.easeInOut}),
				TweenMax.to(this.topButton, 0.3, {y:top, startAt:{y:topStart}, ease:Circ.easeInOut}),
				TweenMax.to(this.rightButton, 0.3, {x:right, startAt:{x:rightStart}, ease:Circ.easeInOut}),
				], 0.1, TweenAlign.START, 0);
		}
		
		private function initMenuButtons():void
		{
			this.top 		= Root.assets.getTexture(BlockStorm.prefix + "_arrowTop");
			this.topBack 	= Root.assets.getTexture(BlockStorm.prefix + "_arrowTop");
			
			this.right 		= Root.assets.getTexture(BlockStorm.prefix + "_arrowRight");
			this.rightBack 	= Root.assets.getTexture(BlockStorm.prefix + "_arrowRight");
			
			this.bottom 	= Root.assets.getTexture(BlockStorm.prefix + "_arrowBottom");
			this.bottomBack = Root.assets.getTexture(BlockStorm.prefix + "_arrowBottom");
			
			this.left 		= Root.assets.getTexture(BlockStorm.prefix + "_arrowLeft");
			this.leftBack 	= Root.assets.getTexture(BlockStorm.prefix + "_arrowLeft");
		}
		
		private function backTriggered(event:Event):void
		{
			var button:Button = event.currentTarget as Button;
			
			//dampenArrows();
			
			TweenMax.to(this.container, 0.5, {x:returnPosX, y:returnPosY, ease:Circ.easeInOut/*, onComplete:lightArrows*/});
		}
		
		/*private function lightArrows():void
		{
			for (var i:int = 0; i < this.menuArrows.length; i++) 
			{
				this.menuArrows[i].filter = null;
			}
		}*/
		
		/*private function dampenArrows():void
		{
			for (var i:int = 0; i < this.menuArrows.length; i++) 
			{
				this.menuArrows[i].filter = this.desaturate;
			}
		}*/
		
		private function initTopMenu():void
		{
			this.topButton = new Button(top, "", top);
			this.topButton.alignPivot();
			this.topButton.scaleX = this.topButton.scaleY = BlockStorm.scaleFactor;
			this.topButton.y = (-BlockStorm.stageHeight * 0.5) - this.topButton.height * 0.6;
			this.topButton.addEventListener(Event.TRIGGERED, topMenuTriggered);
			
			this.topButtonBack = new Button(topBack, "", topBack);
			this.topButtonBack.alignPivot();
			this.topButtonBack.scaleX = this.topButtonBack.scaleY = -BlockStorm.scaleFactor;
			this.topButtonBack.y = (-BlockStorm.stageHeight * 0.5) - this.topButtonBack.height * 0.6;
			this.topButtonBack.addEventListener(Event.TRIGGERED, backTriggered);
			
			this.container.addChild(this.topButton);
			this.container.addChild(this.topButtonBack);
			
			this.menuArrows.push(this.topButton);
			this.menuArrows.push(this.topButtonBack);
		}
		
		private function topMenuTriggered(event:Event):void
		{
			var button:Button = event.currentTarget as Button;
			var posY:Number = BlockStorm.stageHeight * 1.5;
			
			//dampenArrows();
			
			TweenMax.to(this.container, 0.5, {y:posY, ease:Circ.easeInOut/*, onComplete:lightArrows*/});
		}
		
		private function initRightMenu():void
		{
			/*var cornerTop:Image = new Image(Root.assets.getTexture(BlockStorm.prefix + "_coner"));
			var cornerBottom:Image = new Image(Root.assets.getTexture(BlockStorm.prefix + "_coner"));
			var rightLogo:Image = new Image(Root.assets.getTexture(BlockStorm.prefix + "_logo"));
			
			//cornerTop.alignPivot();
			cornerTop.touchable = false;
			cornerTop.scaleX = cornerTop.scaleY = BlockStorm.scaleFactor;
			cornerTop.x = BlockStorm.stageWidth * 0.5;
			cornerTop.y = -BlockStorm.stageHeight * 0.5;
			
			//cornerBottom.alignPivot();
			cornerBottom.scaleX = BlockStorm.scaleFactor;
			cornerBottom.scaleY = -BlockStorm.scaleFactor;
			cornerBottom.x = BlockStorm.stageWidth * 0.5;
			cornerBottom.y = BlockStorm.stageHeight * 0.5;*/
			
			/*this.menuRight.addChild(cornerTop);
			this.menuRight.addChild(cornerBottom);*/
			
			this.rightButton = new Button(right, "", right);
			this.rightButton.alignPivot();
			this.rightButton.scaleX = this.rightButton.scaleY = BlockStorm.scaleFactor;
			this.rightButton.x = (BlockStorm.stageWidth * 0.5) + this.rightButton.width * 0.6;
			this.rightButton.addEventListener(Event.TRIGGERED, rightMenuTriggered);
			
			this.rightButtonBack = new Button(rightBack, "", rightBack);
			this.rightButtonBack.alignPivot();
			this.rightButtonBack.scaleX = this.rightButtonBack.scaleY = -BlockStorm.scaleFactor;
			this.rightButtonBack.x = (BlockStorm.stageWidth * 0.5) + this.rightButtonBack.width * 0.6;
			this.rightButtonBack.addEventListener(Event.TRIGGERED, backTriggered);
			
			this.container.addChild(this.rightButton);
			this.container.addChild(this.rightButtonBack);
			
			this.buttonLevel = new Button(this.buttonBlue, "", this.buttonBlue);
			this.buttonLevel.alignPivot();
			this.buttonLevel.width = BlockStorm.stageWidth * 0.75;
			this.buttonLevel.height = BlockStorm.stageHeight * 0.15;
			this.buttonLevel.x = BlockStorm.stageWidth + this.buttonLevel.width * 0.14;
			this.buttonLevel.y = this.buttonLevel.height * 0.5;
			this.buttonLevel.addEventListener(Event.TRIGGERED, levelTriggered);
			this.menuRight.addChild(this.buttonLevel);
			
			this.buttonMarathon  = new Button(this.buttonOrange/*, "", this.buttonOrange*/);
			this.buttonMarathon.alignPivot();
			this.buttonMarathon.width = BlockStorm.stageWidth * 0.75;
			this.buttonMarathon.height = BlockStorm.stageHeight * 0.15;
			this.buttonMarathon.x = BlockStorm.stageWidth + this.buttonMarathon.width * 0.14;
			this.buttonMarathon.y = this.buttonMarathon.height * 1.55;
			this.buttonMarathon.addEventListener(Event.TRIGGERED, marathonTriggered);
			this.menuRight.addChild(this.buttonMarathon);
			
			/*rightLogo.alignPivot();
			rightLogo.touchable = false;
			rightLogo.scaleX = rightLogo.scaleY = BlockStorm.scaleFactor * 0.75;
			rightLogo.x = BlockStorm.stageWidth + rightLogo.width * 0.14;
			rightLogo.y = -BlockStorm.stageHeight * 0.225;
			this.menuRight.addChild(rightLogo);*/
			
			this.statusText = new TextField(BlockStorm.stageWidth * 0.9, BlockStorm.stageHeight * 0.05, "", "Bauhaus93", 50, 0x6ea8e1);
			this.statusText.alignPivot();
			this.statusText.autoScale 	= true;
			this.statusText.vAlign 		= "top";
			this.statusText.hAlign 		= "center";
			this.statusText.x 			= BlockStorm.stageWidth * 0.5;
			this.statusText.y 			= BlockStorm.stageHeight * 0.75;
			this.statusText.text 		= getRandQuote();
			this.statusText.visible 	= false;
			Starling.current.stage.addChild(this.statusText);
		}
		
		private function rightMenuTriggered(event:Event):void
		{
			var button:Button = event.currentTarget as Button;
			var posX:Number = -BlockStorm.stageWidth * 0.5;
			
			//dampenArrows();
			
			TweenMax.to(this.container, 0.5, {x:posX, ease:Circ.easeInOut/*, onComplete:lightArrows*/});
		}
		
		private function initBottomMenu():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function initLeftMenu():void
		{
			/*this.leftButton = new Button(top, "", top);
			this.leftButton.alignPivot();
			this.leftButton.scaleX = this.leftButton.scaleY = BlockStorm.scaleFactor;
			this.leftButton.y = (-BlockStorm.stageHeight * 0.5) + this.leftButton.height * 0.6;
			this.leftButton.addEventListener(Event.TRIGGERED, topMenuTriggered);
			
			this.leftButtonBack = new Button(topBack, "", topBack);
			this.leftButtonBack.alignPivot();
			this.leftButtonBack.scaleX = this.leftButtonBack.scaleY = -BlockStorm.scaleFactor;
			this.leftButtonBack.y = (-BlockStorm.stageHeight * 0.5) - this.leftButtonBack.height * 0.6;
			this.leftButtonBack.addEventListener(Event.TRIGGERED, backTriggered);
			
			this.container.addChild(this.leftButton);
			this.container.addChild(this.leftButtonBack);
			
			this.menuArrows.push(this.topButton);
			this.menuArrows.push(this.topButtonBack);*/
		}
		
		public function hideMenu(event:Event):void
		{
			this.visible = false;
			Scene.hud.blockText.visible = true;
			Scene.hud.scoreText.visible = true;
			Root.activeScene.alpha = 1;
			TweenMax.to(this.container, 0.5, {x:returnPosX, y:returnPosY, ease:Circ.easeInOut});
			this.menuReveal.reverse();
			
			TweenMax.to(this.statusText, 0.5, {autoAlpha:0, delay:2});
		}
		
		public function revealMenu(event:Event):void
		{
			Root.activeScene.alpha = 0.2;
			Scene.hud.blockText.visible = false;
			Scene.hud.scoreText.visible = false;
			this.visible = true;
			this.menuReveal.play();
		}
		
		private function levelTriggered(event:Event):void
		{
			trace("LEVEL PLAY");
			
			var posX:Number = -BlockStorm.stageWidth * 1.5;
			
			TweenMax.to(this.container, 0.3, {x:posX, ease:Circ.easeInOut, 
				onComplete:startGame, onCompleteParams:["level"]});
			
			
			//Starling.current.stage.dispatchEventWith(Menu.HIDE, true);
		}
		
		private function marathonTriggered(event:Event):void
		{
			trace("MARATHON");
			
			this.statusText.visible = true;
			this.statusText.alpha = 0;
			this.statusText.text = getRandQuote();
			
			var posX:Number = -BlockStorm.stageWidth * 1.5;
			
			TweenMax.to(this.container, 0.3, {x:posX, ease:Circ.easeInOut, 
				onComplete:startGame, onCompleteParams:["marathon"]});
			TweenMax.to(this.statusText, 0, {alpha:1, delay:0.25});
			
			//Starling.current.stage.dispatchEventWith(Menu.SELECTED, true, "marathon");
			//Starling.current.stage.dispatchEventWith(Menu.HIDE, true);
		}
		
		public function startGame(mode:String):void
		{
			Starling.current.stage.dispatchEventWith(Menu.SELECTED, true, mode);
		}
		
		public function getRandQuote():String
		{
			var randomQuote:int = Math.floor(Math.random() * this.quotes.length);
			
			return this.quotes[randomQuote];
		}
	}
}