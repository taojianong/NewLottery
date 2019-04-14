package com.pub
{
	import com.ColorGlobal;
	
	import flash.utils.ByteArray;
	
	import mx.formatters.DateFormatter;

	public class PublicClass
	{
		public function PublicClass()
		{
		}
		/**硬拷贝 objToCopy：需要被拷贝的对象*/
		public static function cloneObject(objToCopy:Object):Object
		{
			var ba:ByteArray = new ByteArray(); 
			ba.writeObject(objToCopy);	
			ba.position = 0;
			var objToCopyInto:Object = ba.readObject();
			return objToCopyInto; 
		}
		
		/**
		 * 转换时间格式 
		 * @param time 当前毫秒数
		 * @param format 转时间格式
		 * @return String
		 * 
		 */		
		public static function switchTime( time:Number , format:String="YYYY-MM-DD"):String
		{
			var date:Date = new Date;
			date.time = time;			
			var dateformater:DateFormatter = new DateFormatter;
			dateformater.formatString = format;
			trace("___________当前时间: " + dateformater.format( date ));
			return dateformater.format( date );
		}
		
		/**
		 * 将非HtmlText文本转换为相应颜色HtmlText字符串
		 * @param str 一般字符串
		 * @param color(颜色 默认为#ff0000)
		 * @return color htmlText 
		 * 
		 */		
		public static function getColorHtmlText( str:String , color:String=ColorGlobal.GREEN):String
		{
			return "<font color=\'"+ color +"\'>" + str + "</font>";
		}
		
			
	}
}