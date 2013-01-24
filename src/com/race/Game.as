package com.race
{
	import flash.display.BitmapData;
	
	import nape.geom.Vec2;
	import nape.space.Space;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Game extends Sprite
	{
		private const SLICE_HEIGHT:int = 600;
		private const SLICE_WIDTH:int = 30;
		
		private var mSpace:Space;
		private var mHills:Sprite;
		private var mSliceConstructor:Vector.<Vec2>;
		private var mGroundTexture:Texture;
		
		public function Game()
		{
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//
			mSpace = new Space(new Vec2(0, 2000));
			mHills = new Sprite();
			
			mSliceConstructor = new Vector.<Vec2>();
			mSliceConstructor.push(new Vec2(0, SLICE_HEIGHT));
			mSliceConstructor.push(new Vec2(0, 0));
			mSliceConstructor.push(new Vec2(SLICE_WIDTH, 0));
			mSliceConstructor.push(new Vec2(SLICE_WIDTH, SLICE_HEIGHT));
			
			mGroundTexture = Texture.fromBitmapData(new BitmapData(SLICE_WIDTH, SLICE_HEIGHT, false, 0xffaa33));
		}
	}
}		