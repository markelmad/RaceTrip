package com.race.cars
{
	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	
	import starling.core.Starling;
	import starling.display.Stage;
	import starling.events.Event;

	public class Car
	{
		private const SPAWN_POSITION:Vec2 = new Vec2(1024 / 2 + 100, 200);
		private var mCharacterCBType:CbType;
		
		private var mImpulse:Vec2;
		private var mBody:Body;
		private var mStage:Stage;
		
		public function Car()
		{
			mBody = new Body(BodyType.DYNAMIC, SPAWN_POSITION);
			mCharacterCBType = new CbType();
			var material:Material = new Material(Number.NEGATIVE_INFINITY, .1, 2, 1);
			mImpulse = new Vec2(30, 0);
			
			mBody.shapes.add(new Circle(50, null, material));
			
			mStage = Starling.current.stage;
			mStage.addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		private function onUpdate(e:Event):void
		{
			mBody.applyImpulse(mImpulse);
			if(mBody.velocity.x < 350)
			{
				mBody.velocity.x = 350;
			}
		}
		public function get body():Body
		{
			return mBody;
		}
	}
}