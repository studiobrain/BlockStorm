package scenes
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import main.view.Hud;
	
	import main.view.Block;
	import main.view.BlockPool;
	
	import data.MainData;
	
	import nape.callbacks.InteractionType;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.shape.Polygon;
	
	import dump.DragIndicator;
	import main.view.physics.GameSpace;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import utils.Utility;
	import main.controller.Root;
	
	public class Scene extends Sprite
	{
		private static const POINT:Point = new Point();
		private static const PREV:Point  = new Point();
		
		public static const GAME_OVER:String = "game over";
		public static const RESET:String = "game reset";
		
		public static var mode:String; 
		public static var space:GameSpace = new GameSpace();
		public static var marathon:String = "marathon";
		public static var levels:String = "levels";
		public static var startingBlock:Block;
		public static var hud:Hud;
		public static var marathonDropTime:Timer = new Timer(250, 10);
		
		private var halfDistance:int = BlockStorm.stageWidth * 0.5;
		private var numOfColumns:int = 10; 
		private var armDrag:DragIndicator;
		private var posX:Number; 
		private var posY:Number;
		private var summary:Summary; 
		
		private var count:Number = 0;
		private var started:Boolean; 
		private var blockList:BodyList = new BodyList();
		private var removal:Array = [];
	
		
		public function Scene(mode:String)
		{
			super();
			trace("Scene: " + mode);
			Scene.mode = mode;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			Starling.current.stage.addEventListener(Scene.GAME_OVER, endingScenario);
			Starling.current.stage.addEventListener(Scene.RESET, resetScene);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			Scene.marathonDropTime.addEventListener(TimerEvent.TIMER, dropNewBlock);
			Scene.marathonDropTime.addEventListener(TimerEvent.TIMER_COMPLETE, restartDrop);
			
			this.addChild(Scene.space);
			initBlocks(Scene.mode);
			addArm();
			addUI();
		}
		
		private function addUI():void
		{
			Scene.hud = new Hud(Scene.mode);
			Starling.current.stage.addChild(Scene.hud);
		}
		
		private function addArm():void
		{
			this.armDrag = new DragIndicator();
			this.armDrag.visible = false;
			this.addChild(this.armDrag);
			
			addEventListener(TouchEvent.TOUCH, startDrag);
		}
		
		private function startDrag(event:TouchEvent):void
		{ 
			var touch:Touch = event.getTouch(this);
			var graphic:Block;
			var prevGraphic:Block;
			
			//var startScale:Number = BlockStorm.stageWidth * 0.111;
			//var newScale:Number;
			
			
			
			if (touch)
			{
				POINT.x = touch.globalX;
				POINT.y = touch.globalY;
				
				this.globalToLocal(POINT, POINT);
				
				trace(touch);
				if (this.hitTest(POINT, true)) graphic = this.hitTest(POINT, true).parent as Block;
				
				if (!started) 
				{
					Scene.startingBlock = graphic;
					this.blockList.add(Scene.startingBlock.blockBody);
					this.removal.push(Scene.startingBlock);
					Scene.startingBlock.lightenUp(true);
					started = true;
					trace("Scene.startingBlock: " + Scene.startingBlock);
				}
				switch (true)
				{
					case ((touch.phase == TouchPhase.BEGAN || touch.phase == TouchPhase.MOVED)):
						
						if (graphic && !graphic.added)
						{
							prevGraphic = this.removal[this.removal.length -1];
							
							if (Root.space.blockChecker(prevGraphic.blockBody, graphic.blockBody) == true) 
							{
								this.blockList.add(graphic.blockBody);
								this.removal.push(graphic);
								graphic.added = true;
							}
							
							//graphic.alpha = 0.5;
							//removal[removal.length -1].lightenUp(true);
							
							//removal.push(graphic);
						}
						
						
						
						/*if (graphic && graphic.color == Scene.startingBlock.color && !graphic.added)
						{
							graphic.lightenUp(true);
							graphic.added = true;
							this.removal.add(graphic.blockBody);
						}*/
						
						break;
					
					case (touch.phase == TouchPhase.HOVER || touch.phase == TouchPhase.ENDED):
						
						trace(this.blockList.length);
						
						if (this.blockList.length > 2) 
						{
							Root.space.destroyBlocks(this.blockList);
							this.blockList.clear();
						}
						else
						{
							trace("need more blocks");
							Root.space.restoreBlocks(this.blockList);
							Scene.startingBlock.lightenUp(false);
							if (prevGraphic) prevGraphic.lightenUp(false);
						}
						
						started = false;
						this.removal = [];
						
						break;
				}
			}	
			
			/*switch (true) 
			{
				case (touch.phase == TouchPhase.BEGAN):
					//trace("BEGAN");
					if (event.target != Starling.current.stage)
					{
						var current:Quad = event.target as Quad;
						Scene.startingBlock = current.parent as Block;
					}
					
					Scene.startingBlock.lightenUp(true);
					
					this.armDrag.visible = true;
					this.armDrag.x = touch.globalX;
					this.armDrag.y = touch.globalY;
					this.addChild(this.armDrag);
					break;
				case (touch.phase == TouchPhase.MOVED):
					//trace("MOVED");
					var toX:int = touch.globalX - this.armDrag.x;
					var toY:int = touch.globalY - this.armDrag.y;
					this.armDrag.rotation = 0;
					this.armDrag.arm.width = Math.round(Math.sqrt((toX * toX) + (toY * toY)));
					//this.armDrag.setArrows(this.armDrag.arm.width, Scene.startingBlock.color);
					this.armDrag.rotation = Math.atan2(toY, toX);
					this.armDrag.armBody.position.setxy(this.armDrag.x, this.armDrag.y);
					this.armDrag.armBody.rotation = this.armDrag.rotation;
					newScale = this.armDrag.arm.width / startScale;
					scaleArmBody(newScale);
					break;
				case (touch.phase == TouchPhase.ENDED):
					//trace("ENDED");
					//this.armDrag.resetArrows();
					Scene.space.destroyBlocks();
					this.armDrag.armBody.shapes.clear();
					this.armDrag.arm.width = 0;
					this.armDrag.visible = false;
					break;
				default:
					break;
			}*/
		}
		
		private function scaleArmBody(scale:Number):void
		{
			var updatedShape:Polygon = new Polygon(
				Polygon.rect(
					0, -BlockStorm.stageWidth * 0.0075, 
					BlockStorm.stageWidth * 0.111, 
					BlockStorm.stageWidth * 0.015));
			
			this.armDrag.armBody.shapes.clear();
			this.armDrag.armBody.shapes.add(updatedShape);
			updatedShape.sensorEnabled = true;
			this.armDrag.armBody.scaleShapes(scale, 1);
			this.armDrag.armBody.space = GameSpace.space;
		}
		
		public function initBlocks(mode:String):void
		{
			trace("initBlocks(): " + mode);
			
			switch (mode)
			{
				case "level": 
					dropMarathonBlocks(); 
					
					break;
				case "marathon": dropMarathonBlocks(); break;
			}
		}
		
		private function dropLevelBlocks():void
		{
			trace("dropLevelBlocks()");
		}
		
		private function dropMarathonBlocks():void
		{
			trace("dropBlocks()");
			
			Starling.juggler.delayCall(marathonDropTime.start, 2);
			
			var block:Block;
			
			for (var i:int = 0; i < 50; i++) 
			{
				var hazard:Boolean = (Math.random() < .10) ? true : false;
				
				block = new Block(hazard);
				block.blockBody.position.x = block.width * 0.5 + (i % this.numOfColumns) * block.width;
				block.blockBody.position.y = (BlockStorm.stageHeight - block.height * 0.5) - (Math.floor(i / this.numOfColumns) * block.height);
				
				this.addChild(block);
			}
		}
		
		private function restartDrop(event:TimerEvent):void
		{
			marathonDropTime.reset();
			Starling.juggler.delayCall(marathonDropTime.start, 2);
		}
		
		private function dropNewBlock(event:TimerEvent):void
		{
			var hazard:Boolean = (Math.random() < .10) ? true : false;
			var block:Block = new Block(hazard);
			
			block.blockBody.position.x = block.width * 0.5 + (count % this.numOfColumns) * block.width;
			block.blockBody.position.y = -block.height * 2;
		
			this.addChild(block);
			
			count ++;
			
			/*for (var i:int = 0; i < dropCount; i++) 
			{
				var hazard:Boolean = (Math.random() < .10) ? true : false;
				
				block = new Block(hazard);
				block.blockBody.position.x = block.width * 0.5 + (i % this.numOfColumns) * block.width;
				block.blockBody.position.y = (-block.height * 5) * i;
				
				this.addChild(block);
			}*/
		}
		
		private function getDistance(x1:Number, x2:Number,  y1:Number, y2:Number):Number 
		{
			var distX:Number = x1 - x2;
			var distY:Number = y1 - y2;
			
			return Math.round(Math.sqrt(distX * distX + distY * distY));
		}
		
		public function endingScenario(event:Event, scenario:String):void
		{
			switch (scenario)
			{
				case "ceiling": gameOver(); break;
			}
		}
		
		public function gameOver():void
		{
			this.touchable = false;
			Scene.marathonDropTime.stop();
			
			/*if (!this.summary) 
			{
				this.summary = new Summary();
				Starling.current.stage.addChild(this.summary);
			}
			
			this.summary.visible = true;*/
			
			trace("GAME OVER BECAUSE THE BLOCKS ARE STACKED TOO HIGH!");
		}
		
		public function resetScene(event:Event, mode:String):void
		{
			Scene.hud.score 	= 0;
			Scene.hud.blockAmt 	= 0;
			Scene.mode = mode;
			trace("resetScene(): " + Scene.mode);
			
			Starling.current.stage.dispatchEventWith(GameSpace.CLEAN, true);
			initBlocks(Scene.mode);
			this.touchable = true;
			this.armDrag.armBody.space = GameSpace.space;
			
			//addArm();
		}
	}
}