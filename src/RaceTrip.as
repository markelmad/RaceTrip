package
{
	import com.race.Main;
	import com.race.Root;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import starling.utils.formatString;
	
	[SWF(frameRate="60", width="960", height="640", backgroundColor="0x000000")]
	public class RaceTrip extends Sprite
	{
		// Startup image for SD screens
		[Embed(source="/main bg.png")]
		private static var Background:Class;
		
		private var star:Starling;
		
		public function RaceTrip()
		{
			if(stage) init();
			else addEventListener(flash.events.Event.ADDED_TO_STAGE, init);
		}
		private function init(e:flash.events.Event = null):void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, init);
			//
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			G.screenW = stage.fullScreenWidth;
			G.screenH = stage.fullScreenHeight;
			G.centerX = G.screenW >> 1;
			G.centerY = G.screenH >> 1;
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, G.STAGE_WIDTH, G.STAGE_HEIGHT), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
				ScaleMode.SHOW_ALL);
			
			var scaleFactor:int = viewPort.width < 480 ? 1 : 2; // midway between 320 and 640
			var appDir:File = File.applicationDirectory;
			var assets:AssetManager = new AssetManager(scaleFactor);
			assets.verbose = Capabilities.isDebugger;
			assets.enqueue(
//				appDir.resolvePath("sounds"),
//				appDir.resolvePath(formatString("assets/fonts/{0}x", scaleFactor)),
				appDir.resolvePath(formatString("assets/textures/{0}x", scaleFactor))
			);
			assets.useMipMaps = true;
			
			var bg:Bitmap = new Background();
			bg.x = viewPort.x;
			bg.y = viewPort.y;
			bg.width = viewPort.width;
			bg.height = viewPort.height;
			bg.smoothing = true;
			addChild(bg);
			
			star = new Starling(Root, stage, viewPort);
			star.simulateMultitouch  = false;
			star.enableErrorChecking = Capabilities.isDebugger;
			star.stage.stageWidth = G.STAGE_WIDTH;
			star.stage.stageHeight = G.STAGE_HEIGHT;
			
			star.showStats = true;
			
			star.addEventListener(starling.events.Event.ROOT_CREATED,
				function onRootCreated(e:Object, root:Root):void
				{
					trace("starling ready");
					star.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
					removeChild(bg);
					root.start(Texture.fromBitmap(bg, false), assets);
					star.start();
				});
			//
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, 
				function (e:flash.events.Event):void
				{
					star.start();
				});
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, 
				function (e:flash.events.Event):void
				{
					star.stop();
				});
		}
	}
}