package
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import starling.utils.formatString;
	
	[SWF(frameRate="60", backgroundColor="#000000")]
	
	public class BlockStorm extends Sprite
	{
		[Embed(source="/textures/3x/xhdpi__bgPreload.png")]
		public static var XHDPI:Class;
		
		public static var stageWidth:int  = 240;
		public static var stageHeight:int = 426;
		public static var blockStar:Starling;
		
		public static var scaleFactor:int;
		public static var stageRef:Stage;
		public static var viewPort:Rectangle;
		public static var prefix:String;
		
		private var stageWidth:int;
		private var stageHeight:int;
		private var background:Bitmap;
		private var assets:AssetManager;
		private var appDir:File;
		
		public function BlockStorm()
		{
			var iOS:Boolean 	 = Capabilities.manufacturer.indexOf("iOS") != -1;
			var AND:Boolean 	 = Capabilities.manufacturer.indexOf("Android") != -1;
			
			BlockStorm.stageRef 			= stage;
			BlockStorm.stageRef.align 		= StageAlign.TOP_LEFT;
			BlockStorm.stageRef.scaleMode 	= StageScaleMode.NO_SCALE;;
			
			Starling.multitouchEnabled = false;
			Starling.handleLostContext = true;
			Starling.handleLostContext = !iOS;
			
			if (iOS == true) this.getScaleFactor("iOS");
			if (AND == true) this.getScaleFactor("Android");
				
			else this.getScaleFactor("default");
			
			//BlockStorm.stageWidth 	= this.stageWidth;
			//BlockStorm.stageHeight 	= this.stageHeight;
			
			BlockStorm.viewPort = RectangleUtil.fit(
				new Rectangle(0, 0, this.stageWidth, this.stageHeight), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
				ScaleMode.NO_BORDER);
			
			this.appDir		= File.applicationDirectory;
			this.assets 	= new AssetManager(BlockStorm.scaleFactor);
			
			this.assets.enqueue(
				appDir.resolvePath("audio"),
				//appDir.resolvePath(formatString("fonts/{0}x", scaleFactor)),
				appDir.resolvePath(formatString("textures/{0}x", BlockStorm.scaleFactor))
			);
			
			//this.assets.enqueue("textures/BlockAtlas.png");
			//this.assets.enqueue("textures/BlockAtlas.xml");
			this.assets.enqueue("fonts/BS_Bahaus.png");
			this.assets.enqueue("fonts/BS_Bahaus.fnt");
				
			this.background.x 			= BlockStorm.viewPort.x;
			this.background.y 			= BlockStorm.viewPort.y;
			this.background.width  		= BlockStorm.viewPort.width;
			this.background.height 		= BlockStorm.viewPort.height;
			this.background.smoothing 	= true;
			
			this.addChild(this.background);
			
			trace("**********************************************************");
			trace("BLOCKSTORM 			v 0.01");
			trace("viewPort:			" + BlockStorm.viewPort);
			trace("BlockStorm.stageWidth:		" + BlockStorm.stageWidth);
			trace("BlockStorm.stageHeight:		" + BlockStorm.stageHeight);
			trace("scaleFactor: 			" + BlockStorm.scaleFactor);
			trace("Capabilities.screenDPI: 	" + Capabilities.screenDPI);
			trace("Capabilities.os: "	+ Capabilities.os);
			trace("Capabilities.screenResolutionX: " + Capabilities.screenResolutionX);
			trace("Capabilities.screenResolutionY: " + Capabilities.screenResolutionY);
			trace("**********************************************************");
			
			BlockStorm.blockStar 						= new Starling(Root, stage, BlockStorm.viewPort);
			BlockStorm.blockStar.stage.stageWidth  		= this.stageWidth;
			BlockStorm.blockStar.stage.stageHeight 		= this.stageHeight;
			BlockStorm.blockStar.simulateMultitouch  	= false;
			BlockStorm.blockStar.enableErrorChecking 	= Capabilities.isDebugger;
			
			BlockStorm.blockStar.addEventListener(starling.events.Event.ROOT_CREATED, rootCreated); 
		}
		
		private function getScaleFactor(OS:String):int
		{
			//var perfectScale:Number =  (stage.fullScreenWidth / this.stageWidth);
			//trace("perfectScale: " + perfectScale);
			
			switch (OS) 
			{
				case "iOS":
					trace("iOS");
					if (stage.fullScreenHeight <= 480) BlockStorm.scaleFactor = 1; //background = new BGx1();
					if (stage.fullScreenHeight > 480 && stage.fullScreenHeight <= 960) BlockStorm.scaleFactor = 2; //this.background = new BGx2();
					if (stage.fullScreenHeight > 960 && stage.fullScreenHeight < 1024) BlockStorm.scaleFactor = 3; //this.background = new BGx3();
					if (stage.fullScreenHeight >= 1024 && stage.fullScreenHeight < 2056) BlockStorm.scaleFactor = 4; //this.background = new BGx4();
					if (stage.fullScreenHeight >= 2056) BlockStorm.scaleFactor = 5; //this.background = new BGXHD();
					break;
				case "Android":
					trace("Android");
					if (Capabilities.screenDPI <= 160)  BlockStorm.scaleFactor = 1; // scaled 1
					if (Capabilities.screenDPI > 160 && 
						Capabilities.screenDPI <= 240)  BlockStorm.scaleFactor = 2; // scaled 1.5 
					if (Capabilities.screenDPI > 240)  BlockStorm.scaleFactor = 3; background = new XHDPI(); BlockStorm.prefix = "xhdpi_";
					break;
				default:
					trace("default");
					if (Capabilities.screenDPI <= 160)  BlockStorm.scaleFactor = 1; // scaled 1
					if (Capabilities.screenDPI > 160 && 
						Capabilities.screenDPI <= 240)  BlockStorm.scaleFactor = 2; // scaled 1.5 
					if (Capabilities.screenDPI > 240)  BlockStorm.scaleFactor = 3; // scaled 2
					break;
			}
			
			this.stageWidth   = stage.fullScreenWidth/* / BlockStorm.scaleFactor*/;
			this.stageHeight  = stage.fullScreenHeight/* / BlockStorm.scaleFactor*/;
			
			BlockStorm.stageWidth = this.stageWidth/* * BlockStorm.scaleFactor*/;
			BlockStorm.stageHeight = this.stageHeight;
			
			trace("BlockStorm.scaleFactor: " + BlockStorm.scaleFactor);
			trace("BlockStorm.stageWidth: " + BlockStorm.stageWidth);
			trace("BlockStorm.stageHeight: " + BlockStorm.stageHeight);
			
			return BlockStorm.scaleFactor;
		}
		
		private function rootCreated(event:Object, app:Root):void
		{
			BlockStorm.blockStar.removeEventListener(starling.events.Event.ROOT_CREATED, rootCreated);
			this.removeChild(this.background);
			
			var bgTexture:Texture = Texture.fromBitmap(this.background, false, false, BlockStorm.scaleFactor);
			var backGroundImage:Image = new Image(bgTexture);
			
			backGroundImage.width 	= BlockStorm.stageWidth;
			backGroundImage.height 	= BlockStorm.stageHeight;
			
			app.start(backGroundImage, this.assets);
			BlockStorm.blockStar.start();
			
			Starling.current.showStats = true;
			Starling.current.showStatsAt("left", "top");
		}
	}
}