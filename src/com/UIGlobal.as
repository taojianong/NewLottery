package com
{
	import mxml.ChartUI;
	import mxml.MainUI;
	import mxml.QueryUI;
	import mxml.SelectUI;
	
	import spark.components.Application;
	import spark.components.WindowedApplication;

	public class UIGlobal
	{
		public function UIGlobal()
		{
		}
		
		public var app:WindowedApplication;
		
		/**
		 * 主界面 
		 */		
		public var mainUI:MainUI;
		
		/**
		 * 选号界面 
		 */		
		public var selectUI:SelectUI;
		
		/**
		 * 图表区 
		 */		
		public var chartUI:ChartUI;
		
		/**
		 * 存储界面 
		 */		
		public var queryUI:QueryUI;
		
		/**
		 * SQLLite数据库存储地址  d:/data/ \\data\\
		 */		
		public static const SPATH:String = "d:/data/";
		
		private static var instance:UIGlobal;
		public static function get Instance():UIGlobal
		{
			if(instance == null)
			{
				instance = new UIGlobal;
			}
			return instance;
		}
	}
}