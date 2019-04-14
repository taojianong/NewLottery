package com.control
{
	import com.shape.Ball;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Ball管理器 
	 * @author taojianlong
	 * 
	 */	
	public class BallController
	{
		private var balls:Array = new Array;
	
		private var view:Graphics;
		
		public function BallController(view:Graphics)
		{
			this.view = view;						
		}
				
		public function add( ball:Ball ):void
		{
			if(ball!=null)
			{
				balls.push( ball );
			}			
		}
				
		public var eW:Number = 0;
		public var eH:Number = 0;
		/**显示球的图像数据**/
		public var ballsBitmap:BitmapData = new BitmapData(445,175);
		
		/**绘制球**/
		public function drawBalls():void
		{
			if(ballsBitmap)
				ballsBitmap.dispose();				
			ballsBitmap = new BitmapData(eW,eH);
			for(var i:int=0;i<balls.length;i++)
			{
				var ball:Ball = balls[i];
				var color:uint = ball.mouseDown ? ball.mouseDownColor : ball.color; 
				var bmd:BitmapData = ball.getBallBitmapData(ball.radius,ball.ballIndex, color );
				
				ballsBitmap.copyPixels(bmd,new Rectangle(0,0,ball.radius*2,ball.radius*2),new Point(ball.x,ball.y));
			}
			
			this.view.clear();
			this.view.lineStyle(1,0x000000,1);
			this.view.beginBitmapFill( ballsBitmap , null , false , true);
			this.view.drawRect( 0, 0, ballsBitmap.width , ballsBitmap.height );
			this.view.endFill();
		}
	
		public function mouseDown(mouseX:Number,mouseY:Number):Boolean
		{
			for each( var ball:Ball in balls)
			{
				if(mouseX >= ball.x && mouseX <= (ball.x+ball.radius*2) && mouseY >= ball.y && mouseY <= (ball.y+ball.radius*2) )
				{
					ball.mouseDown = !ball.mouseDown;
					drawBalls();
					return true;
				}
			}			
			return false;
		}
		
		/**
		 * 获取选中的球的索引数组 ,球号
		 * @return 
		 * 
		 */		
		public function getDownBalls():Array
		{
			var arr:Array = new Array;
			for each(var ball:Ball in balls)
			{
				if(ball && ball.mouseDown)
				{
					arr.push( ball.ballIndex );
				}
			}		
			arr = arr.sort(Array.NUMERIC);
			trace("选中球的号码为: " + arr);
			return arr;
		}
		
		public function clear():void
		{
			for each(var ball:Ball in balls)
			{
				if(ball && ball.mouseDown)
				{
					ball.mouseDown = false;
				}
			}
			drawBalls();
		}
	}
}