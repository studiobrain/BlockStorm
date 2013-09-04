package physics
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Strong;
	
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.utils.Timer;
	
	import blocks.Block;
	
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.callbacks.PreCallback;
	import nape.callbacks.PreFlag;
	import nape.callbacks.PreListener;
	import nape.dynamics.CollisionArbiter;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	import nape.util.ShapeDebug;
	
	import scenes.Scene;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	
	public class GameSpace extends Sprite
	{
		public static const CLEAN:String	= "clean space";
		public static const PAUSE:String	= "pause space";
		public static const RESUME:String	= "resume space";
		
		public static var CLEAR:CbType 		= new CbType();
		public static var BOXED:CbType 		= new CbType();
		public static var ONE_WAY:CbType 	= new CbType();
		public static var EXCLUDE:CbType 	= new CbType();
		public static var WALL:CbType 		= new CbType();
		public static var stackCheckTimer:Timer = new Timer(1000);
		public static var space:Space;
		
		public var DEBUG:Boolean = true;
		public var debug:ShapeDebug;
		public var material:Material;
		public var firstBlock:Body;
		public var blockList:BodyList = new BodyList();
		
		private var boundsBody:Body;
		private var ceilingBody:Body;
		private var ceilingShape:Polygon;
		private var top:Polygon;
		private var floor:Polygon;
		private var left:Polygon;
		private var right:Polygon;
		private var first:Boolean;
		private var glowed:BlurFilter; 
		private var ceiling:Number; 
		private var boundsFloor:Body;  
		private var currentBlock:Body;
		
		public function GameSpace()
		{
			trace("GameSpace");
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			GameSpace.stackCheckTimer.addEventListener(TimerEvent.TIMER, runStackCheck);
			Starling.current.stage.addEventListener(GameSpace.CLEAN, cleanOutSpace);
			Starling.current.stage.addEventListener(GameSpace.PAUSE, pauseSpace);
			Starling.current.stage.addEventListener(GameSpace.RESUME, resumeSpace);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.glowed = BlurFilter.createGlow(0x00ffff, 0.8, 20, 1);
			this.ceiling = BlockStorm.stageHeight * 0.1;
			
			GameSpace.space = new Space(new Vec2());
			
			if (DEBUG) 
			{
				this.debug = new ShapeDebug(stage.stageWidth, stage.stageHeight);
				BlockStorm.stageRef.addChild(debug.display);
			}
			
			GameSpace.space.gravity.setxy(0, BlockStorm.stageHeight);
			
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, loop);
			this.addBoundries();
			this.addListeners();
			
			GameSpace.stackCheckTimer.start();
		}
		
		private function loop(event:EnterFrameEvent):void
		{
			GameSpace.space.step(1/40, 100, 100);
			GameSpace.space.liveBodies.foreach(this.updateGraphics);
			//this.update();
		}
		
		private function addBoundries():void
		{
			this.boundsBody = new Body(BodyType.STATIC);
			this.ceilingBody = new Body(BodyType.KINEMATIC);
			this.boundsFloor = new Body(BodyType.KINEMATIC);
			
			this.ceilingShape = new Polygon(
				Polygon.rect(BlockStorm.stageWidth * 0.05, 0, BlockStorm.stageWidth * 0.9, 5));
			this.floor  = new Polygon(
				Polygon.rect(0, BlockStorm.stageHeight, BlockStorm.stageWidth, 100));
			this.left 	= new Polygon(
				Polygon.rect(-20, 0, 20, BlockStorm.stageHeight));
			this.right  = new Polygon(
				Polygon.rect(BlockStorm.stageWidth, 0, 20, BlockStorm.stageHeight));
			
			this.boundsBody.shapes.add(this.left);
			this.boundsBody.shapes.add(this.right);
			this.boundsBody.cbTypes.add(WALL);
			this.boundsBody.space = GameSpace.space;
			
			this.ceilingBody.shapes.add(this.ceilingShape);
			this.ceilingBody.space = GameSpace.space;
			this.ceilingBody.cbTypes.add(ONE_WAY);
			
			this.boundsFloor.shapes.add(this.floor);
			this.boundsFloor.allowMovement = false;
			this.boundsFloor.space = GameSpace.space;
		}
		
		private function addListeners():void
		{
			GameSpace.space.listeners.add(new PreListener(InteractionType.COLLISION, ONE_WAY, BOXED, oneWayHandler));
		}
		
		private function runStackCheck(event:TimerEvent):void
		{
			if (interactingStack(this.boundsFloor, InteractionType.SENSOR, isWalled).has(this.ceilingBody))
			{
				trace("STOP THE GAME!");
				
				GameSpace.stackCheckTimer.stop();
				Starling.current.stage.dispatchEventWith(GameSpace.PAUSE, true);
				Starling.current.stage.dispatchEventWith(Scene.GAME_OVER, true, "ceiling");
			}
		}
		
		public function pauseSpace(event:Event):void
		{
			GameSpace.stackCheckTimer.stop();
				
			this.removeEventListener(EnterFrameEvent.ENTER_FRAME, loop);
		}
		
		public function resumeSpace(event:Event):void
		{
			GameSpace.stackCheckTimer.start();
			
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, loop);
		}
		
		private function distance(Obj1, Obj2):Number 
		{
			var dx:Number = Obj1.x - Obj2.x;
			var dy:Number = Obj1.y - Obj2.y;
			
			return Math.sqrt(dx * dx + dy * dy);
		}
		 
		public static function stopGraphics(body:Body):void
		{
			body.velocity.x = 0;
			body.velocity.y = 0;
		}
		
		public function updateGraphics(body:Body):void 
		{
			body.userData.graphic.x 		= body.position.x;
			body.userData.graphic.y 		= body.position.y;
			body.userData.graphic.rotation 	= body.rotation;
		}
		
		public function update():void
		{
			this.debug.clear();
			this.debug.draw(GameSpace.space);
		}
		
		public function getRemovalBlocks():BodyList
		{
			var removalBlocks:BodyList = interactingBodies(Scene.startingBlock.blockBody, InteractionType.SENSOR, isColor);
			
			removalBlocks.add(Scene.startingBlock.blockBody);
			
			return removalBlocks;
		}
		
		public function destroyBlocks(blocksToDestroy:BodyList):void
		{
			var bonus:Boolean = false;
			
			if (blocksToDestroy.length > 2)
			{
				blocksToDestroy.length >= 4 ? bonus = true : bonus = false;
				
				blocksToDestroy.foreach(function(removal:Body):void 
				{
					if (removal.userData.graphic.parent.hazard == true) 
					{
						Scene.mode == "marathon" ? blowItOut(removal) : eraseBlock(removal, bonus);
					}
					else
					{
						eraseBlock(removal, bonus);
					}
				});
			}
		}
		
		public function eraseBlock(removal:Body, bonus:Boolean):void
		{ 
			Scene.hud.updateScore(removal.userData.graphic.parent, bonus);
			GameSpace.space.bodies.remove(removal);
			removal.userData.graphic.parent.removeFromParent(true);
		}
		
		private function blowItOut(removal:Body):void
		{ 
			removal.userData.graphic.alpha = 0;
			removal.scaleShapes(3, 3);
			
			Starling.juggler.delayCall(eraseBlock, 0.1, removal, false); 
		}
		
		public function isColor(a:Body, b:Body):Boolean
		{
			if (a.isKinematic() || b.isKinematic()) return false;
			if (a.isStatic() || b.isStatic()) return false;
			
			return a.userData.graphic.color == b.userData.graphic.color ? true : false;
		}
		
		private function isWalled(a:Body, b:Body):Boolean
		{
			var bool:Boolean;
			
			if (a.isStatic() || b.isStatic()) 
			{
				bool = false;
			}
			else
			{
				bool = true;
			}
			
			return bool;
		}
		
		public function interactingBodies(b:Body, itype:InteractionType, expand:Function):BodyList
		{
			var evaluated:Array = [b];
			var stack:Array		= [b];
			var list:BodyList 	= new BodyList();
			
			while (stack.length > 0) 
			{
				var cur:Body = stack.shift();
				var bodies:BodyList = cur.interactingBodies(itype, 1);
				
				for (var i:int = 0; i < bodies.length; i++) 
				{
					var body:Body = bodies.at(i);
					
					if (expand(cur, body) && evaluated.indexOf(body) == -1 /*&& blockList.has(body)*/) 
					{
						evaluated.push(body);
						stack.push(body);
						list.add(body);
					}
				}
			}
			
			return list;
		}
		
		private function interactingStack(b:Body, itype:InteractionType, expand:Function):BodyList
		{
			var evaluated:Array = [b];
			var stack:Array		= [b];
			var list:BodyList 	= new BodyList();
			
			while (stack.length > 0) 
			{
				var cur:Body = stack.shift();
				var bodies:BodyList = cur.interactingBodies(itype, 1);
				
				for (var i:int = 0; i < bodies.length; i++) 
				{
					var body:Body = bodies.at(i);
					
					if (expand(cur, body) && evaluated.indexOf(body) == -1) 
					{
						evaluated.push(body);
						stack.push(body);
						list.add(body);
					}
				}
			}
			
			return list;
		}
		
		private function nonSense(cb:PreCallback):PreFlag 
		{
			var b:Body = cb.int2.castBody;
			
			return PreFlag.IGNORE;
		}
		
		private function oneWayHandler(cb:PreCallback):PreFlag 
		{
			return PreFlag.IGNORE;
		}
		
		public function cleanOutSpace(event:Event):void
		{
			trace("cleanOutBodies()");
			
			var i:int = 0;
			var removal:BodyList = GameSpace.space.bodies.filter(function(b:Body):Boolean{return b.isDynamic()});
			
			GameSpace.stackCheckTimer.reset();
			
			while (!GameSpace.space.bodies.empty()) {
				
				var b:Body = GameSpace.space.bodies.pop();
				
				b.userData.graphic.parent.removeFromParent(true);
				
				GameSpace.space.bodies.remove(b);
			}
			
			this.boundsBody.space = GameSpace.space;
			this.boundsFloor.space = GameSpace.space;
			this.ceilingBody.space = GameSpace.space;
			
			Starling.current.stage.dispatchEventWith(GameSpace.RESUME, true);
		}
		
		public function restoreBlocks(removal:Object):void
		{
			while (!removal.empty()) {
				
				var b:Body = removal.pop();
				
				if (b.userData.graphic.parent) 
				{
					b.userData.graphic.parent.lightenUp(false);
					b.userData.graphic.parent.added = false;
					removal.remove(b);
				}
			}
		}
		
		public function blockCheck(graphic:Body, block:Body):Boolean
		{
			var isBlock:Boolean;
			
			if (isColor(graphic, block)) isBlock = true; 
			
			return isBlock;
		}
		
		public function blockChecker(blockBody:Body, b:Body):Boolean
		{
			var passed:Boolean;
			
			if (blockBody.interactingBodies(InteractionType.SENSOR, 1).has(b) &&
				isColor(b, Scene.startingBlock.blockBody))
			{
				passed = true;
				b.userData.graphic.parent.lightenUp(true);
			}
			
			return passed;
		}
	}
}