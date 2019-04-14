package com.manger
{
	import com.ConfigGlobal;
	import com.DataGlobal;
	import com.SetGlobal;
	import com.UIGlobal;
	import com.pub.ArrayUtill;
	import com.pub.PublicClass;
	import com.util.RandomUtil;

	public class AppManger
	{
		public function AppManger()
		{
		}
		
		/**
		 * 根据奇偶三区质数比选出 红色球数据
		 * 
		 * 
		 */		
		public function selectRedNumberByOE():void
		{
			for(var i:int=0;i<SetGlobal.Instance.selectPreiods;i++)
			{	
				DataGlobal.Instance.pushDisplayInfo = "根据奇偶三区质数比选出的数字: " + 
					RuleManager.Instance.selectedNumbersWith();
			}
		}
		
		/**
		 * 从前 periods期中选择出count数字为必出红色球数字,一般为0~3个
		 * @param periods 期数
		 * @param count 选出上periods重复数字 不能大于6
		 * @return Array 必出红色球数字
		 * 
		 */		
		public function getMustReds(periods:int = 1 , count:int=1):Array
		{			
			if(periods < 1 || count < 1) 
				return null;
			if(count > 6)
				count = 6;
			var rArr:Array = [];
			var arr:Array = [];
			var num:int;
			var i:int;		
			var j:int;
			for(i=0;i<periods;i++)
			{
				arr += ConfigGlobal.Instance.reds[i];
			}	
			arr = ArrayUtill.clearTheSameInArray(arr);			
			if(count > 1)
			{				
				for(i=0;i<count;i++)
				{
					j = int( arr.length * Math.random() );
					num = arr.splice(j,1);
					rArr.push( num );
				}
			}
			return rArr;
		}
		
		/**
		 * 从数组中选出count(一般为0~3)个数为红色球必出数字 
		 * @param arr
		 * @param count  选出上periods重复数字 不能大于6
		 * @return Array 必出红色球数字
		 * 
		 */		
		public function getMustRedsFrom(arr:Array , count:int=1):Array
		{
			if(arr.length <= 0)
				return null;
			if(count > 6)
			{
				count = 6;
			}
			if(arr.length < count)
			{
				count = arr.length;
			}
			var rArr:Array = [];
			var i:int ;
			var j:int;
			var num:int;
			if(count > 0)
			{				
				for(i=0;i<count;i++)
				{
					j = int( arr.length * Math.random() );
					num = arr.splice(j,1);
					if(num==0)
					{
						trace("num: " + num);
					}
					rArr.push( num.toString() );
				}
			}
			return rArr;
		}
		
		/**
		 * @param nPeriod 前N期
		 * @param periods 选出几期红色球号码
		 * @param mustReds 必选的红色球
		 * @param noReds 必选不中的红色球
		 * 选择红色数字 
		 * 
		 */		
		public function selectRedNumber( nPeriod:int = 0 , periods:int = 1,mustReds:Array=null, noReds:Array=null):Array
		{			
			if(noReds == null)
				noReds = [];
			var cloneMusetReds:Array = PublicClass.cloneObject(mustReds) as Array;
			var arr:Array = [];		
			var i:int = 0;
			var sArr:Array = [];
			var j:int = 0;
			var musts:Array = [];
			for(i=0;i<SetGlobal.Instance.selectPreiods;i++)
			{								
				if(i == SetGlobal.Instance.selectPreiods-1) //多组选号时最后一组买与前几期都不一样的数
				{
					for(j=0;j<arr.length;j++)
					{
						noReds = noReds.concat( arr[j] );
					}
					noReds = ArrayUtill.clearTheSameInArray( noReds );
					DataGlobal.Instance.pushDisplayInfo = "选号最后一组排除前面几组的数据为： " +　noReds + "  长度为：" + noReds.length;		
					
					sArr = RuleManager.Instance.getExclusiveReds( null , SetGlobal.Instance.theSameRedRate , null , noReds);
				}
				else 
				{
					if(mustReds != null)
						musts = getMustRedsFrom( cloneMusetReds , int(Math.random()*4));
					DataGlobal.Instance.pushDisplayInfo = "必出红色球: " + musts;
					
					sArr = RuleManager.Instance.findAllNoRepetRedNumbers( nPeriod , SetGlobal.Instance.theSameRedRate , musts , noReds);				
				}			
				
				arr.push(sArr); //奖选出的号码加入到数组中
			}

			DataGlobal.Instance.pushDisplayInfo = "不能出现与前 " + nPeriod + "期的数字:["+DataGlobal.Instance.getPrevNPeriodReds( nPeriod )
				+"]\n出现概率为： " + SetGlobal.Instance.theSameRedRate;
			for(i=0;i<arr.length;i++)
			{
				DataGlobal.Instance.pushDisplayInfo = "当前选择的红色号码: " + arr[i];
			}			
			DataGlobal.Instance.reds.concat( arr );
			return arr;
		}
		
		/**
		 * 选择蓝色数字 
		 * @param counts 选择蓝色球个数
		 */		
		public function selectBlueNumber(counts:int=5):void
		{
			DataGlobal.Instance.blues = [];
			var arr:Array = [];
			var num:int;
			if(counts<1)
				counts = 1;
			for(var i:int = 0;i<counts;i++)
			{
				num = RuleManager.Instance.findNoRepetBuleNumber( 10,SetGlobal.Instance.theSameBlueRate );
				DataGlobal.Instance.blues.push( num );
			}			
		}
		
		private static var instance:AppManger;
		public static function get Instance():AppManger
		{
			if(instance == null)
			{
				instance = new AppManger;
			}
			return instance;
		}
	}
}