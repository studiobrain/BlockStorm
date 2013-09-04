package blocks
{
	import nape.dynamics.InteractionFilter;
	import nape.hacks.Forcedsleep;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.phys.Material;
	
	import physics.GameSpace;
	
	import scenes.Scene;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	
	public class Block extends Sprite
	{
		public var blockBody:Body;
		public var color:uint;
		public var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
		public var blockShape:Polygon;
		public var blockImage:Image;
		public var blockOut:Polygon;
		public var blockWorth:Number = 10;
		public var hazard:Boolean;
		public var isUnder:Boolean;
		public var blockSize:Number = BlockStorm.stageWidth * 0.1;
		
		private var randColor:Array = [0xf96c4b, 0x6ea8e1, 0x78be40, 0xd8356e]; 
		private var wildText:TextField = new TextField(blockSize, blockSize, "?", "Bauhaus93", 50, 0xffffff);
		private var blockHazard:Image; 
		public var added:Boolean;
		
		public function Block(hazard:Boolean = false)
		{
			this.hazard = hazard;
			
			this.blockBody 	= new Body(BodyType.DYNAMIC);
			this.blockShape = new Polygon(Polygon.box(blockSize, blockSize));
			this.blockOut 	= new Polygon(Polygon.box(blockSize * 1.1, blockSize * 1.1));
			this.blockBody.shapes.add(this.blockShape);
			this.blockBody.shapes.add(this.blockOut);
			this.blockOut.sensorEnabled = true;
			this.blockShape.material = Material.steel();
			//this.blockBody.isBullet = true;
			this.blockBody.cbTypes.add(GameSpace.BOXED);
			this.blockBody.space = GameSpace.space;
			Scene.mode == "marathon" ? this.blockBody.allowRotation = true : this.blockBody.allowRotation = false;
			this.y = -this.height * 1.5;
			
			this.color = getRandColor();
			
			this.hazard == true ? this.blockImage = new Image(Root.assets.getTexture("blockNuclearBW")) : 
				this.blockImage = new Image(Root.assets.getTexture("blockBW"));
			
			this.blockImage.width = this.blockImage.height = blockSize;
			this.blockImage.color = this.color;
			this.blockImage.alignPivot();
			this.addChild(this.blockImage);
			
			this.colorMatrixFilter.adjustBrightness(1.5);
			//this.colorMatrixFilter.adjustContrast(0.75);
			
			this.blockBody.userData.graphic = this.blockImage;
		}
		
		public function getRandColor():uint
		{
			var randomColor:int = Math.floor(Math.random() * this.randColor.length);
			
			return this.randColor[randomColor];
		}
		
		public function lightenUp(lighter:Boolean):void
		{
			lighter == true ? this.blockImage.filter = this.colorMatrixFilter : this.blockImage.filter = null;
		}
	}
}