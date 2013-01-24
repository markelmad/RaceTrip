package com.race.gui.buttons
{
	import com.race.Root;
	
	import starling.display.Sprite;

	public class MainButtons
	{
		public var mStartBtn:CustomButton;
		
		public function MainButtons(container:Sprite)
		{
			mStartBtn = new CustomButton(Root.assets.getTexture("button 1"), "Start");
			mStartBtn.x = G.STAGE_CENTER_X;
			mStartBtn.y = G.STAGE_CENTER_Y;
			
			container.addChild(mStartBtn);
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