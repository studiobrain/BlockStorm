package main.view
{
	import nape.dynamics.InteractionFilter;
	import nape.hacks.Forcedsleep;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.phys.Material;
	
	import main.view.physics.GameSpace;
	
	import main.view.scenes.Scene;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	
	public class Block extends Sprite
	{
		public static var BLOCKSIZE:Number;
		
		public var blockBody:Body;
		//public var color:uint;
		public var color:String;
		public var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
		public var blockShape:Polygon;
		public var blockImage:Image;
		public var blockOut:Polygon;
		public var blockWorth:Number = 10;
		public var hazard:Boolean;
		public var isUnder:Boolean;
		
		
		//private var randColor:Array = [0xf96c4b, 0x6ea8e1, 0x78be40, 0xd8356e]; 
		private var randColor:Array = ["_blockOrange", "_blockBlue", "_blockPink", "_blockGreen"]; 
		private var wildText:TextField = new TextField(BLOCKSIZE, BLOCKSIZE, "?", "Bauhaus93", 50, 0xffffff);
		private var blockHazard:Image; 
		public var added:Boolean;
		
		public function Block(hazard:Boolean = false)
		{
			BLOCKSIZE = BlockStorm.stageWidth / 9;
			
			this.hazard = hazard;
			
			this.blockBody 	= new Body(BodyType.DYNAMIC);
			this.blockShape = new Polygon(Polygon.box(BLOCKSIZE, BLOCKSIZE));
			this.blockOut 	= new Polygon(Polygon.box(BLOCKSIZE * 1.1, BLOCKSIZE * 1.1));
			this.blockBody.shapes.add(this.blockShape);
			this.blockBody.shapes.add(this.blockOut);
			this.blockOut.sensorEnabled = true;
			this.blockShape.material = Material.steel();
			//this.blockBody.isBullet = true;
			this.blockBody.cbTypes.add(GameSpace.BOXED);
			//this.blockBody.space = GameSpace.space;
			Scene.mode == "marathon" ? this.blockBody.allowRotation = true : this.blockBody.allowRotation = false;
			//this.y = -this.height * 1.5;
			
			this.color = getRandColor();
			
			//this.hazard == true ? this.blockImage = new Image(Root.assets.getTexture("blockNuclearBW")) : 
			this.blockImage = new Image(Root.assets.getTexture(BlockStorm.prefix + this.color));
			
			this.blockImage.width = this.blockImage.height = BLOCKSIZE * 1.15;
			
			//this.color = this.color;
			this.blockImage.alignPivot();
			this.addChild(this.blockImage);
			
			this.colorMatrixFilter.adjustBrightness(1.5);
			//this.colorMatrixFilter.adjustContrast(0.75);
			
			this.blockBody.userData.graphic = this.blockImage;
		}
		
		public function getRandColor():String
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