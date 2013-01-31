package com.race
{
	import com.race.cars.Car;
	import com.race.gui.buttons.CustomButton;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Game extends Sprite 
	{
		private const SLICE_HEIGHT:int = 600;
		private const SLICE_WIDTH:int = 15;
		private const INTERVAL:Number = 1 / 60;
		
		private var mSpace:Space;
		private var mCarCbType:CbType;
		private var mCar:Car;
		private var mHills:Sprite;
		
		private var mGroundTexture:Texture;
		private var mSlicesCreated:int;
		private var mCurrentAmplitude:Number;
		private var mSlicesInCurrentHill:int;
		private var mIndexSliceInCurrentHill:int;
		private var mCurrentYPoint:Number = 300;
		private var mSlices:Vector.<Body>;
		private var mSliceConstructor:Vector.<Vec2>;
		
//		private var debug:ShapeDebug;
		
		private var rightBtn:CustomButton;
		private var leftBtn:CustomButton;
		
		public function Game():void 
		{			
			//Initialize Nape Space
			mSpace = new Space(new Vec2(0, 100));
//			debug = new ShapeDebug(G.STAGE_WIDTH, G.STAGE_HEIGHT);
//			debug.drawConstraints = true;
//			Starling.current.nativeOverlay.addChild(debug.display);
			mHills = new Sprite();
			addChild(mHills);
			
			mSlices = new Vector.<Body>();
			
			//Generate a rectangle made of Vec2
			mSliceConstructor = new Vector.<Vec2>();
			mSliceConstructor.push(new Vec2(0, SLICE_HEIGHT));
			mSliceConstructor.push(new Vec2(0, 0));
			mSliceConstructor.push(new Vec2(SLICE_WIDTH, 0));
			mSliceConstructor.push(new Vec2(SLICE_WIDTH, SLICE_HEIGHT));
			
			//Create the texture of the ground
			mGroundTexture = Texture.fromBitmapData(new BitmapData(SLICE_WIDTH, SLICE_HEIGHT, false, 0xffaa33));
			
			//fill the stage with slices of hills
			for (var i:int = 0; i < Starling.current.stage.stageWidth / SLICE_WIDTH * 1.2; i++)
			{
				createSlice();
			}
			mCar = new Car(this, mSpace);
			
			startSimulation();
			
			rightBtn = new CustomButton(Root.assets.getTexture("control btn"));
			rightBtn.x = G.STAGE_WIDTH - rightBtn.pivotX - 10;
			rightBtn.y = G.STAGE_HEIGHT - rightBtn.pivotY - 10;
			
			leftBtn = new CustomButton(Root.assets.getTexture("control btn"));
			leftBtn.scaleX = -1;
			leftBtn.x = leftBtn.pivotX + 10;
			leftBtn.y = rightBtn.y;
			
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			rightBtn.addEventListener(Event.TRIGGERED, onClick);
			leftBtn.addEventListener(Event.TRIGGERED, onClick);
			
			Root.instance.addChild(rightBtn);
			Root.instance.addChild(leftBtn);
		}
		private function createSlice():void 
		{
			//Every time a new hill has to be created this algorithm predicts where the slices will be positioned
			if (mIndexSliceInCurrentHill >= mSlicesInCurrentHill) {
				mSlicesInCurrentHill = Math.random() * 20 + 10;
				mCurrentAmplitude = Math.random() * 20 - 8;
				mIndexSliceInCurrentHill = 0;
			}
			
			//Calculate the position of the next slice
			var nextYPoint:Number = mCurrentYPoint + (Math.sin(((Math.PI / mSlicesInCurrentHill) * mIndexSliceInCurrentHill)) * mCurrentAmplitude);
			
			mSliceConstructor[2].y = nextYPoint - mCurrentYPoint;
			
			var slicePolygon:Polygon = new Polygon(mSliceConstructor);
			var sliceBody:Body = new Body(BodyType.STATIC);
			sliceBody.shapes.add(slicePolygon);
			sliceBody.position.x = mSlicesCreated * SLICE_WIDTH;
			sliceBody.position.y = mCurrentYPoint;
			sliceBody.space = mSpace;
			
			var image:Image = new Image(mGroundTexture);
			sliceBody.userData.graphic = image;
			mHills.addChild(image); 
			
			//Skew and position the image with a matrix
			var matrix:Matrix = image.transformationMatrix;
			matrix.translate(sliceBody.position.x, sliceBody.position.y);
			matrix.a = 1.04;
			matrix.b = (nextYPoint - mCurrentYPoint) / SLICE_WIDTH;
			image.transformationMatrix.copyFrom(matrix);
			
			mSlicesCreated++;
			mIndexSliceInCurrentHill++;
			mCurrentYPoint = nextYPoint;
			
			mSlices.push(sliceBody);
		}
		
		private function startSimulation():void
		{			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			mSpace.step(INTERVAL);
			checkHills();
			panForeground();
			mCar.onCarUpdate();
//			if(mCar.body.userData.graphicUpdate != null)
//			{
//				mCar.body.userData.graphicUpdate(mCar.body);
//			}
//			debug.clear();
//			debug.draw(mSpace);
//			debug.flush();
		}
		
		private function checkHills():void 
		{
			for (var i:int = 0; i < mSlices.length; i++) {
				if (mCar.body.position.x - mSlices[i].position.x > 600) {
					mSpace.bodies.remove(mSlices[i]);
					if (mSlices[i].userData.graphic.parent)
					{
						mSlices[i].userData.graphic.parent.removeChild(mSlices[i].userData.graphic);
					}
					mSlices.splice(i, 1);
					i--;
					createSlice();
				}
				else
				{
					break;
				}
			}
		}
		
		private function panForeground():void
		{
			this.x = Starling.current.stage.stageWidth / 2 - mCar.body.position.x;
			this.y = Starling.current.stage.stageHeight / 2 - mCar.body.position.y;
//			this.x = debug.display.x = Starling.current.stage.stageWidth / 2 - mCar.body.position.x;
//			this.y = debug.display.y = Starling.current.stage.stageHeight / 2 - mCar.body.position.y;
		}
		private function onClick(e:Event):void
		{
			if(e.target == rightBtn)
			{
				mCar.body.applyAngularImpulse(720);
			}
			else if(e.target == leftBtn)
			{
				mCar.body.applyAngularImpulse(-720);
			}
		}
	}
	
}