package com
{
	public class ConfigGlobal
	{
		public function ConfigGlobal()
		{
		}
		
		/**<b>data.xml中的数据</b>
		 * 
		 * 上N期数据
		 *  
		 */		
		public var datas:Array = [];
	
		/**
		 * 前N期中的红色球数据 		
		 * 格式:[[1,2,3,4,5,6],[1,2,3,4,5,6]]
		 */		
		public var reds:Array = [];						
		
		/**
		 *前N期中的蓝色球数据 	
		 * 格式:[1,2,3,4,5,6]	 
		 */	
		public var blues:Array = [];	
		
		/**
		 * 与上N期不同，只针对蓝色球,一般16就够了
		 */		
		public var prevNoRepetPeriod:int = 1;
		
		/**
		 * 设置红号中出现同蓝号一样的概率
		 */		
		public var theSameProbabilityWithBlueAndRed:Number = 0.001;
		
		private static var instance:ConfigGlobal;
		public static function get Instance():ConfigGlobal
		{
			if(instance == null)
			{
				instance = new ConfigGlobal;
			}
			return instance;
		}
	}
}