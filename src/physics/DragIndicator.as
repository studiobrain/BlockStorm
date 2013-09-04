package physics
{
	import nape.callbacks.CbType;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	
	import scenes.Scene;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	
	public class DragIndicator extends Sprite
	{
		public var arm:Quad;
		public var armBody:Body;
		public var pivot:Image;
		public var dragPivot:Image;
		public var arrow:Image;
		public var armShape:Polygon; 
		
		private var clearDetection:CbType = new CbType();
		private var startingWidth:Number = BlockStorm.stageWidth * 0.05;
		private var startingHeight:Number = BlockStorm.stageWidth * 0.075;
		private var arrows:Array = []; 
		private var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
		
		public function DragIndicator()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.colorMatrixFilter.adjustBrightness(-0.45);
			buildIndicator();
		}
		
		private function buildIndicator():void
		{
			this.armBody 	= new Body(BodyType.KINEMATIC);
			this.armShape 	= new Polygon(
				Polygon.rect(
					0, -BlockStorm.stageWidth * 0.0075, 
					BlockStorm.stageWidth * 0.015, 
					BlockStorm.stageWidth * 0.015));
			this.armShape.sensorEnabled = true;
			this.armBody.shapes.add(this.armShape);
			this.armBody.cbTypes.add(GameSpace.CLEAR);
			this.armBody.position.setxy(-2000, -2000);
			this.armBody.space = GameSpace.space;
			
			this.arm = new Quad(BlockStorm.stageWidth * 0.015, BlockStorm.stageWidth * 0.015, 0x00FFFF);
			this.arm.pivotY = this.arm.height * 0.5;
			this.arm.alpha = 0;
			this.addChild(this.arm);
			
			this.armBody.userData.graphic = this.arm;
			
			this.pivot = new Image(Root.assets.getTexture("pivot"));
			this.pivot.x = this.arm.x;
			this.pivot.y = this.arm.y;
			this.pivot.width = startingWidth;
			this.pivot.height = startingWidth;
			this.pivot.alignPivot();
			this.pivot.color = 0xFFFFFF;
			this.pivot.filter = this.colorMatrixFilter;
			this.addChild(this.pivot);
			
			//buildArrows();
		}
		
		private function buildArrows():void
		{
			for (var i:int = 0; i < 40; i++) 
			{
				this.arrow = new Image(Root.assets.getTexture("arrow"));
				this.arrow.x = startingWidth * i;
				this.arrow.y = this.arm.y;
				this.arrow.width = startingWidth;
				this.arrow.height = startingHeight;
				this.arrow.alignPivot();
				this.arrow.visible = false;
				this.addChild(this.arrow);
				
				this.arrows.push(this.arrow);
			}
		}
		
		public function setArrows(width:Number, color:uint):void
		{
			var showArrows:Number = Math.ceil(width / startingWidth);
			
			for (var i:int = 0; i < this.arrows.length; i++) 
			{
				if (i != 0 && i <= showArrows)
				{
					this.arrows[i].color = color;
					this.arrows[i].visible = true;
					this.pivot.color = color;
					this.pivot.visible = true;
				}
				else
				{
					this.arrows[i].visible = false;
				}
			}
		}
		
		public function resetArrows():void
		{
			for (var i:int = 0; i < this.arrows.length; i++) 
			{
				this.arrows[i].visible = false;
				this.pivot.visible = false;
			}
		}
	}
}