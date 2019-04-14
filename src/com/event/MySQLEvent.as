package com.event
{
	import flash.events.SQLEvent;

	public class MySQLEvent extends SQLEvent
	{
		/**
		 * 打开表 
		 */		
		public static const OPEN_TABLE:String = "open_table";
		
		/**
		 * 链接完成 
		 */		
		public static const CONNECT_COMPLETE:String = "connect_complete";
		
		/**
		 * 中奖号码Data表数据库中数据 
		 */		
		public var data:*;
		
		/**
		 * 打开的表名 
		 */		
		public var table:String = "";
		
		public function MySQLEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}