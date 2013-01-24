package com.race
{
	import com.race.gui.buttons.MainButtons;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Main extends Sprite
	{
		public static const START_GAME:String = "load game";
		private var buttons:MainButtons;
		
		public function Main()
		{
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			
			buttons = new MainButtons(this);
			addEventListener(Event.TRIGGERED, btnClicked);
		}
		private function btnClicked(e:Event):void
		{
			if(e.target == buttons.mStartBtn)
			{
				dispatchEventWith(START_GAME);
			}
		}
	}
}