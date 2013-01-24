package com.race.gui.buttons
{
	import starling.display.Button;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;
	
	public class CustomButton extends Button
	{
		public var data:Object;
		
		public function CustomButton(upState:Texture, text:String = "", downState:Texture = null)
		{
			super(upState, text, downState);
			pivotX = width >> 1;
			pivotY = height >> 1;
			fontName = "Harabara";
			fontColor = 0xFFFFFF;
			fontSize = 40;
			alphaWhenDisabled = 1;
		}
		override public function dispose():void
		{
			data = null;
			super.dispose();
		}
		override public function set enabled(value:Boolean):void
		{
			if(!value)
			{
				filter = new ColorMatrixFilter();
				ColorMatrixFilter(filter).adjustSaturation(-1);
				filter.cache();
			}
			else
			{
				filter.clearCache();
				filter = null;
			}
			super.enabled = value;
		}
	}
}