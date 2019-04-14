package com
{
	import com.pub.ArrayUtill;

	public class DataGlobal
	{
		public function DataGlobal()
		{
			for(var i:int=1;i<=33;i++)
			{
				redNums.push( i );
			}
		}
		
		[Bindable]
		/**当前中奖期数**/
		public var period:int = 0;
		
		/**红色球最小值 1**/
		public static const RED_FROM:int = 1;
		/**红色球最大值 33**/
		public static const RED_TO:int = 33;
		/**蓝色球最小值 1**/
		public static const BLUE_FROM:int = 1;
		/**蓝色球最大值 16**/
		public static const BLUE_TO:int = 16;
		/**产生红色球数量 6**/
		public static const REDS:int = 6;
		/**产生蓝色球数量 1**/
		public static const BLUES:int = 1;
		/**1~31所有质数 1**/
		public static const PRIMES:Array = [2,3,5,7,11,13,17,19,23,29,31];
		
		/**<b>当前买了号码的组数</b>**/
		public var currentDayGroups:int = 1;
		
		[Bindable]
		/**<b>最近一期的中奖号码期数</b>**/
		public var theLastPhase:String = "";
		
		
		/**<b>红色球数据，默认为1-33,如有特殊需求，去除其中的某些数据,
		 * 比如除去上期中奖的数字,或者指定的数据
		 * </b>**/
		public var redNums:Array = [];
		
		
		
		/**<b>红色球数据，默认为1-16,如有特殊需求，去除其中的某些数据,
		 * 比如除去上期中奖的数字,或者指定的数据
		 * </b>**/
		public var blueNums:Array = [];
		
		
		
				
		private var _pushDisplayInfo:String = "";
		/**
		 * 显示信息 
		 * @param str 要显示的信息
		 * @param isClear 是否清楚显示
		 */		
		public function set pushDisplayInfo(str:String):void
		{
			if(str==null || str == "")
				_pushDisplayInfo = "";
			_pushDisplayInfo += str + "\n";				
		}
		public function get pushDisplayInfo():String
		{
			return _pushDisplayInfo;
		}
		
		/**用于存储在已选过的红色数字
		 * 只要程序没关就始终存在 
		 * **/
		public var reds:Array = [];	
		
		
		/**
		 * 获取第period期的红色球数据 
		 * @param period 默认为0，0为最近一期的数，1为再上一期......
		 * @return Array 第period期的红色球数据，格式[1,2,3,4,5,6]
		 * 
		 */		
		public function getPeriodReds(period:int=0):Array
		{
			for(var i:int=0;i<ConfigGlobal.Instance.reds.length;i++)
			{
				if( i == period)
				{
					DataGlobal.Instance.pushDisplayInfo = "第" + ConfigGlobal.Instance.datas[i].time + "期中奖号码(红色球): " + ConfigGlobal.Instance.reds[i];
					//UIGlobal.Instance.mainUI.info.text += "第" + ConfigGlobal.Instance.datas[i].time + "期中奖号码(红色球): " + ConfigGlobal.Instance.reds[i] + "\n";
					return ConfigGlobal.Instance.reds[i];					
				}
			}			
			return [];
		}
		
		/**
		 * @param period 获取前N期的红色球数据，合成一个不重复的数组
		 * @return Array 一个不重复的数组
		 */		
		public function getPrevNPeriodReds(period:int=1):Array
		{
			var arr:Array = ConfigGlobal.Instance.reds.slice(0,period);	
			var newArr:Array = [];
			if(arr!=null)
			{
				for(var i:int=0;i<arr.length;i++)
				{
					newArr = newArr.concat(arr[i]);
				}
				newArr = ArrayUtill.clearTheSameInArray(newArr);
			}			
			return newArr;
		}
		
		/**用于存在已选过的蓝色数字
		 * 只要程序没关就始终存在 
		 * 格式 : 12
		 * **/
		public var blues:Array = [];			
		
		private static var instance:DataGlobal;
		public static function get Instance():DataGlobal
		{
			if(instance == null)
			{
				instance = new DataGlobal;
			}
			return instance;
		}
	}
}