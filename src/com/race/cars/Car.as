package com.race.cars
{
	import com.race.Root;
	
	import nape.callbacks.CbType;
	import nape.constraint.PivotJoint;
	import nape.constraint.WeldJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Compound;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;

	public class Car
	{
		private const SPAWN_POSITION:Vec2 = new Vec2(0, 250);
		private var mCharacterCBType:CbType;
		
		private var mImpulse:Vec2;
		private var mCompound:Compound;
		//parts of the body
		private var mRearBody:Body;
		private var mFrontBody:Body;
		//wheels
		private var mRearWheelBody:Body;
		private var mFrontWheelBody:Body;
		//starling's stage
		private var mStage:Stage;
		//nape's space
		private var mSpace:Space;
		//visuals
		private var mCarBody:Quad;
		private var mRearWheelGraphic:Image;
		private var mFrontWheelGraphic:Image;
		private var mParent:Sprite;
		
		
		public function Car(parent:Sprite, space:Space)
		{
			mParent = parent;
			mSpace = space;
			
			mCompound = new Compound();
//			mCharacterCBType = new CbType();
			mImpulse = new Vec2(30, 0);
			
			var material:Material = new Material(Number.NEGATIVE_INFINITY, .1, 2, 1);
			
			//CREATE FRONT PART
			//create the front body
			mFrontBody = new Body(BodyType.DYNAMIC, SPAWN_POSITION);
			mFrontBody.shapes.add(new Polygon(Polygon.box(30, 15)));
			//create the front wheel
			mFrontWheelBody = new Body(BodyType.DYNAMIC, Vec2.get(SPAWN_POSITION.x, SPAWN_POSITION.y + 10));
			mFrontWheelBody.shapes.add(new Circle(5, null, material));
			//create the pin
			var frontPoint:Vec2 = Vec2.get(mFrontBody.position.x, mFrontBody.position.y + 10);
			var frontJoint:PivotJoint = new PivotJoint(mFrontBody, mFrontWheelBody, mFrontBody.worldPointToLocal(frontPoint), mFrontWheelBody.worldPointToLocal(frontPoint));
			frontJoint.stiff = true;
			frontJoint.frequency = 10;
			frontJoint.damping = 1;
			
//			CREATE REAR PART
			mRearBody = new Body(BodyType.DYNAMIC, new Vec2(SPAWN_POSITION.x - 30, SPAWN_POSITION.y));
			mRearBody.shapes.add(new Polygon(Polygon.box(30, 15)));
			//create the front wheel
			mRearWheelBody = new Body(BodyType.DYNAMIC, Vec2.get(SPAWN_POSITION.x - 30, SPAWN_POSITION.y + 10));
			mRearWheelBody.shapes.add(new Circle(5, null, material));
			//create the pin
			var rearPoint:Vec2 = Vec2.get(mRearBody.position.x, mRearBody.position.y + 10);
			var rearJoint:PivotJoint = new PivotJoint(mRearBody, mRearWheelBody, mRearBody.worldPointToLocal(rearPoint), mRearWheelBody.worldPointToLocal(rearPoint));
			rearJoint.stiff = true;
			rearJoint.frequency = 10;
			rearJoint.damping = 1;
//			
			var bodyPoint:Vec2 = Vec2.get(mFrontBody.position.x, mFrontBody.position.y);
			var bodyJoint:WeldJoint = new WeldJoint(mRearBody, mFrontBody, mRearBody.worldPointToLocal(bodyPoint), mFrontBody.worldPointToLocal(bodyPoint));
			
			//add them to space
			mFrontBody.space = space;
			mFrontWheelBody.space = space;
			frontJoint.space = space;
			
			mRearBody.space = space;
			mRearWheelBody.space = space;
			rearJoint.space = space;
			
			bodyJoint.space = space;
//			
			mCarBody = new Quad(60, 15);
			mCarBody.pivotX = 45;
			mCarBody.pivotY = 7.5;
			
			mRearWheelGraphic = new Image(Root.assets.getTexture("wheel"));
			mRearWheelGraphic.pivotX = mRearWheelGraphic.width >> 1;
			mRearWheelGraphic.pivotY =  mRearWheelGraphic.height >> 1;
			
			mFrontWheelGraphic = new Image(Root.assets.getTexture("wheel"));
			mFrontWheelGraphic.pivotX = mFrontWheelGraphic.width >> 1;
			mFrontWheelGraphic.pivotY = mFrontWheelGraphic.height >> 1;
			
			parent.addChild(mCarBody);
			parent.addChild(mRearWheelGraphic);
			parent.addChild(mFrontWheelGraphic);
			
			mFrontBody.userData.graphic = mCarBody;
			mRearWheelBody.userData.graphic = mRearWheelGraphic;
			mFrontWheelBody.userData.graphic = mFrontWheelGraphic;
		}
		public function onCarUpdate():void
		{
			mCarBody.x = mFrontBody.position.x;
			mCarBody.y = mFrontBody.position.y;
			mCarBody.rotation = mFrontBody.rotation;
			
			mRearWheelGraphic.x = mRearWheelBody.position.x;
			mRearWheelGraphic.y = mRearWheelBody.position.y;
			mRearWheelGraphic.rotation = mRearWheelBody.rotation;
			
			mFrontWheelGraphic.x = mFrontWheelBody.position.x;
			mFrontWheelGraphic.y = mFrontWheelBody.position.y;
			mFrontWheelGraphic.rotation = mFrontWheelBody.rotation;
			
			mFrontBody.applyImpulse(mImpulse);
//			mRearWheelBody.applyImpulse(mImpulse);
			if(mFrontBody.velocity.x < 350)
			{
				mFrontBody.velocity.x = 350;
			}
			else if(mFrontBody.velocity.x > 500)
			{
				mFrontBody.velocity.x = 500;
			}
		}
		public function get body():Body
		{
			return mFrontBody;
		}
		public function get compound():Compound
		{
			return mCompound;
		}
	}
}