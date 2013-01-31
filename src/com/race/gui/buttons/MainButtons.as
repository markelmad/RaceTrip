package com.race.gui.buttons
{
	import com.race.Root;
	
	import starling.display.Sprite;

	public class MainButtons
	{
		public var mStartBtn:CustomButton;
		public var mGameCenterBtn:CustomButton;
		public var mMoreGamesBtn:CustomButton;
		public var mOptionsBtn:CustomButton;
		
		public function MainButtons(container:Sprite)
		{
			mStartBtn = new CustomButton(Root.assets.getTexture("button 1"), "Start");
			mStartBtn.x = G.STAGE_CENTER_X;
			mStartBtn.y = G.STAGE_CENTER_Y;
			
			mGameCenterBtn = new CustomButton(Root.assets.getTexture("button 1"), "Game Center");
			mGameCenterBtn.x = G.STAGE_CENTER_X;
			mGameCenterBtn.y = mStartBtn.y + 10 + mGameCenterBtn.height;
			
			mMoreGamesBtn = new CustomButton(Root.assets.getTexture("button 1"), "More Games");
			mMoreGamesBtn.x = G.STAGE_CENTER_X;
			mMoreGamesBtn.y = mGameCenterBtn.y + 10 + mMoreGamesBtn.height;
			
			mOptionsBtn = new CustomButton(Root.assets.getTexture("button 1"), "Options");
			mOptionsBtn.x = G.STAGE_CENTER_X;
			mOptionsBtn.y = mMoreGamesBtn.y + 10 + mOptionsBtn.height;
			
			container.addChild(mStartBtn);
			container.addChild(mGameCenterBtn);
			container.addChild(mMoreGamesBtn);
			container.addChild(mOptionsBtn);
		}
		public function enableTouch(val:Boolean, ...args):void
		{
			if(args)
			{
				var l:int = args.length;
				for(var i:int = 0; i < l; i++)
				{
					args.touchable = val;
				}
			}
			else
			{
				mStartBtn.touchable = val;
			}
		}
		public function changeState(enabled:Boolean, ...args):void
		{
			if(args)
			{
				var l:int = args.length;
				for(var i:int = 0; i < l; i++)
				{
					args.enabled = enabled;
				}
			}
			else
			{
				mStartBtn.enabled = enabled;
			}
		}
	}
}