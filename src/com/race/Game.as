package com.race
{
	import com.race.cars.Car;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
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
		private const INTERVAL:Number = 1/60;
		
		private var mSpace:Space;
		private var mHills:Sprite;
		private var mSliceConstructor:Vector.<Vec2>;
		private var mGroundTexture:Texture;
		private var mSlices:Vector.<Body>;
		
		private var mIndexSliceInCurrentHill:int;
		private var mSlicesInCurrentHill:int;
		private var mCurrentAmplitude:Number;
		private var mSlicesCreated:int;
		private var mCurrentYPoint:Number;
		
		private var car:Car;
		
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
			mSlices = new Vector.<Body>();
			
			mSliceConstructor = new Vector.<Vec2>();
			mSliceConstructor.push(new Vec2(0, SLICE_HEIGHT));
			mSliceConstructor.push(new Vec2(0, 0));
			mSliceConstructor.push(new Vec2(SLICE_WIDTH, 0));
			mSliceConstructor.push(new Vec2(SLICE_WIDTH, SLICE_HEIGHT));
			
			mGroundTexture = Texture.fromBitmapData(new BitmapData(SLICE_WIDTH, SLICE_HEIGHT, false, 0xffffff));
			
//			createTestBody();
			for(var i:int = 0; i < SLICE_WIDTH * 1.2; i++)
			{
				trace(i);
				createSlice();
			}
			
			car = new Car();
			car.body.space = mSpace;
			car.body.debugDraw = true;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function createTestBody():void
		{
			var floor:Polygon=new Polygon(Polygon.box(640,40));
			floor.material.elasticity=0.5;
			var staticFloor:Body = new Body(BodyType.STATIC);
			staticFloor.shapes.add(floor);
			staticFloor.space=mSpace;
			staticFloor.debugDraw = true;
		}
		private function createSlice():void
		{
			if(mIndexSliceInCurrentHill >= mSlicesInCurrentHill)
			{
				mSlicesInCurrentHill = Math.random() * 40 + 10;
				mCurrentAmplitude = Math.random() * 60 - 20;
				mIndexSliceInCurrentHill = 0;
			}
			//calculate the position of the next slice
			var nextYPoint:Number = mCurrentYPoint + (Math.sin(((Math.PI / mSlicesInCurrentHill) * mIndexSliceInCurrentHill)) * mCurrentAmplitude);
			
			mSliceConstructor[2].y = nextYPoint - mCurrentYPoint;
			
			var slicePolygon:Polygon = new Polygon(mSliceConstructor);
			var sliceBody:Body = new Body(BodyType.STATIC);
//			sliceBody.shapes.add(slicePolygon);
			sliceBody.position.x = mSlicesCreated * SLICE_WIDTH;
			sliceBody.position.y = mCurrentYPoint;
//			trace(sliceBody, sliceBody.space, mSpace.bodies);
			sliceBody.space = mSpace;
//			mSpace.liveBodies.push(sliceBody);
//			trace(sliceBody, sliceBody.space);
			
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
			
//			mSlices.push(sliceBody);
		}
		private function onEnterFrame(e:Event):void
		{
			mSpace.step(INTERVAL);
			
//			var l:int = mSpace.liveBodies.length;
//			var body:Body;
//			for(var i:int = 0; i < l; i++)
//			{
//				body = mSpace.liveBodies.at(i);
//				if(body
//			}
			
//			checkHills();
//			panForeground();
		}
		private function checkHills():void
		{
			for (var i:int = 0; i < mSlices.length; i++) {
				if (car.body.position.x - mSlices[i].position.x > 600) {
					mSpace.bodies.remove(mSlices[i]);
					if (mSlices[i].userData.graphic.parent) {
						mSlices[i].userData.graphic.parent.removeChild(mSlices[i].userData.graphic);
					}
					mSlices.splice(i, 1);
					i--;
					createSlice();
				}
				else {
					break;
				}
			}
		}
		private function panForeground():void
		{
			this.x = Starling.current.stage.stageWidth / 2 - car.body.position.x;
			this.y = Starling.current.stage.stageHeight / 2 - car.body.position.y;
		}
	}
}		