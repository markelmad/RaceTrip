package com.race
{
	import com.race.gui.ProgressBar;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class Root extends Sprite
	{
		private static var sAssets:AssetManager;
		private static var sPreloader:ProgressBar;
		
		private var mCurrentScene:Sprite;
		private var bg:Image;
		
		public function Root()
		{
			
		}
		public function start(_bg:Texture, assets:AssetManager):void
		{
			addEventListener(Main.START_GAME, startGame);
			
			sAssets = assets;
			bg = new Image(_bg);
			addChild(bg);
			
			sPreloader = new ProgressBar(500, 30);
			sPreloader.x = G.centerX;
			sPreloader.y = G.screenH - 20 - sPreloader.height;
			addChild(sPreloader);
			
			assets.loadQueue(function onProgress(ratio:Number):void
			{
				sPreloader.ratio = ratio;
				
				// a progress bar should always show the 100% for a while,
				// so we show the main menu only after a short delay. 
				
				if (ratio == 1)
					Starling.juggler.delayCall(function():void
					{
						sPreloader.removeFromParent(true);
						
						var t:Tween = new Tween(bg, 1);
						t.animate("alpha", 0);
						t.onComplete = function():void { bg.removeFromParent(true); showScene(Main);};
						Starling.juggler.add(t);
						
						
					}, 0.15);
			});
			
		}
		private function showScene(s:Class):void
		{
			if(mCurrentScene) mCurrentScene.removeFromParent(true);
			mCurrentScene = new s();
			addChild(mCurrentScene);
		}
		private function startGame(e:Event):void
		{
			showScene(Game);
		}
		
		public static function get assets():AssetManager { return sAssets };
	}
}