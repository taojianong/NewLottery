package com
{
	import com.pub.PublicClass;

	public class MethodGlobal
	{
		public function MethodGlobal()
		{
		}
		
		/**<b>获取开奖日期,购买时候录入的开奖时间</b>
		 * 格式 【 04-01 】 返回的只能是每周2,4,7的天数
		 * @return String 开奖日期
		 * **/
		public function getLotteryTime():String
		{
			var str:String;
			var date:Date = new Date();
			if(date.day == 0 || date.day == 2 || date.day == 4)
			{
				
			}
			else
			{
				for(var i:int=1;i<=3;i++)
				{
					date.time += 24 * 60 * 60 * 1000;
					if( date.day == 0 || date.day == 2 || date.day == 4 )
					{
						break;
					}
				}				
			}
				
			//开奖时间,相对于购买时间计算
			str = PublicClass.switchTime( date.time , "MM-DD" );
			trace("开奖时间：" + str);
			return str;
		}
		
		//平均值
		public function averageCphere(arr:Array):Number
		{
			var j:Number=0.0;
			for(var i:int=0;i<arr.length;i++)
			{
			j+=arr[i];
			}
			return j/arr.length;
		}
		
		//期望
		public function expectCPhere(averageNum:Number,arr:Array):Number
		{
			var x:Number=0.0;
			for(var i:int=0;i<arr.length;i++)
			{
				x+= Math.pow( (arr[i]-averageNum),2)/(arr.length-1);
			}
			return Math.sqrt(x);
		}
		
		
		/**
		 * 读取xml中指定的数据如1,2,3,
		 * @param numberCount,为指定参数的个数
		 * @return 
		 * 
		 */		
		public function appointNumber(numberCount:int):Number
		{
		   return 0;
		}
		
		private static var instance:MethodGlobal;
		public static function get Instance():MethodGlobal
		{
			if(instance == null)
			{
				instance = new MethodGlobal;
			}
			return instance;
		}
	}
}