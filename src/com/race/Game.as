package com.race
{
	import com.race.cars.Car;
	
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
		private const SLICE_WIDTH:int = 30;
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
		private var mCurrentYPoint:Number = 600;
		private var mSlices:Vector.<Body>;
		private var mSliceConstructor:Vector.<Vec2>;
		
		public function Game():void 
		{			
			//Initialize Nape Space
			mSpace = new Space(new Vec2(0, 2000));
			
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
			mCar = new Car();
			mCar.body.space = mSpace;
//			addChild(mCar.graphic);
			
			startSimulation();
		}
		
		private function createSlice():void 
		{
			//Every time a new hill has to be created this algorithm predicts where the slices will be positioned
			if (mIndexSliceInCurrentHill >= mSlicesInCurrentHill) {
				mSlicesInCurrentHill = Math.random() * 40 + 10;
				mCurrentAmplitude = Math.random() * 60 - 20;
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
		}
		
	}
	
}