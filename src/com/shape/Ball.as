package com.shape
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 圆 
	 * @author taojianlong
	 * 
	 */	
	public class Ball
	{	
		
		public var id:String;
		
		public var name:String;
		
		public var type:int ;
		
		private var _radius:Number = 5;		
		/**
		 * 设置圆半径 
		 */	
		public function set radius(value:Number):void
		{
			_radius = value;
			
			draw(_graphics,_color);
		}		
		public function get radius():Number
		{
			return _radius;
		}
		
		private var _color:uint = 0xff0000;		
		/**
		 * 设置圆颜色 
		 * @param value
		 * 
		 */		
		public function set color(value:Number):void
		{
			_color = value;
			
			draw(_graphics,_color);
		}
		public function get color():Number
		{
			return _color;
		}
		
		public var x:Number = 0;
		
		public var y:Number = 0;
		
		public var ballIndex:int;
		
		private var _graphics:Graphics;
		
		public function Ball( radius:Number , color:uint=0xff0000 )
		{
			_radius = radius;			
			_color  = color;
			
			draw(_graphics,_color);
		}
		
		public function draw(graphics:Graphics,color:uint=0xff0000):void
		{			
			if(_graphics==null)
				_graphics = graphics;
			if(graphics)
			{
				graphics.lineStyle(1,1);
				graphics.beginFill( color );
				graphics.drawCircle( x + _radius , y + _radius , _radius );				
				graphics.endFill();
			}	
		}
		
		public function getBallBitmapData(radius:Number,index:int,color:uint=0xff0000):BitmapData
		{
			var shape:Shape = new Shape;
			shape.graphics.lineStyle(1,0xff0000,1);
			shape.graphics.beginFill( color );
			shape.graphics.drawCircle( radius , radius , radius );				
			shape.graphics.endFill();
			
			var bmd:BitmapData = new BitmapData(radius*2,radius*2);
			bmd.draw( shape );
			
			var mBmd:BitmapData = this.getBallIndexBitmapData( index );	
			var vx:Number = (radius*2-mBmd.width)/2;
			var vy:Number = (radius*2-mBmd.height)/2;
			bmd.copyPixels(mBmd,new Rectangle(0,0,mBmd.width,mBmd.height),new Point(vx,vy),null,null,true);	
			return bmd;
		}
		
		/**
		 * 获取索引图片数据
		 * @return 
		 * 
		 */		
		public function getBallIndexBitmapData( value:int ):BitmapData
		{
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.bold = true;
			txtFormat.size = 15;
			
			var txt:TextField = new TextField;
			txt.defaultTextFormat = txtFormat;
			txt.text = value.toString();
			txt.multiline = false;
			txt.wordWrap = false;
			txt.textColor = 0x00ff00;
			txt.width     = _radius * 2;
			txt.autoSize  = TextFieldAutoSize.CENTER;
			
			var bmd:BitmapData = new BitmapData(_radius * 2,txt.height,true,0x00ffffff);
			bmd.draw(txt);					
			return bmd;
		}
		
		private var _mouseDown:Boolean = false;
		
		public function set mouseDown(value:Boolean):void
		{
			_mouseDown = value;
			//value == true ? draw(_graphics,0xff0000) : draw(_graphics,color);
		}				
		public function get mouseDown():Boolean
		{
			return _mouseDown;
		}
		
		public var _downColor:uint = 0xff0000;
		/**
		 * 球按钮下时的颜色,默认为红色 
		 * @param value
		 * 
		 */		
		public function set downColor(value:uint):void
		{
			_downColor = value;
		}
		public function get downColor():uint
		{
			return _downColor;
		}
		
		
		/**球被按下显示的填充颜色**/
		public function get mouseDownColor():uint
		{
			var col:uint = _mouseDown == true ? _downColor : color ;
			return col;
		}
		
		public function set mouseOver(value:Boolean):void
		{
			value == true ? draw(_graphics,0xff0000) : draw(_graphics,color);			
		}
		
		public function set mouseOut(value:Boolean):void
		{
			
		}
	}
}