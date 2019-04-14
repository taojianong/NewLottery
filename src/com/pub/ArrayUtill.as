package com.pub
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/*
	 * 2011.3.8
	 * taojianlong
	 * This class deal with Array	 
	 */
	public class ArrayUtill
	{
		public function ArrayUtill()
		{
			
		}
		
		/**
		 * 检测数组中是否出现连号 
		 * @param  arr     要检测的数组
		 * @return Boolean 是否检测出连号
		 */		
		public static function arrayHasHyphen( arr:Array ):Boolean
		{
			arr = arr.sort( Array.NUMERIC );
			for(var i:int=0;i<arr.length-1;i++)
			{
				for(var j:int=i+1;j<arr.length;j++)
				{
					if( int( arr[j] ) == int( arr[i] ) + 1 )
					{
						return true;
					}
				}
			}
			return false;
		}
		
//		/**
//		 * 从数组中随机抽取出几位数字组成新的数组 
//		 * @param arr 初始数组
//		 * @param num 抽出几位
//		 * @return Array 随机数组
//		 * 
//		 */		
//		public static function getRandomFromArray( arr:Array , num:int = 6):Array
//		{
//			arr = clearTheSameInArray(arr);
//			if(arr.length > 6)
//			{
//				var ran:int ;
//				var _arr:Array = [];
//				while(_arr.length==num)
//				{
//					ran = int(Math.random() * arr.length);
//					_arr.push( arr.splice(ran,1) );
//				}
//				return _arr;
//			}		
//			return arr;
//		}
		
		/**
		 * 选择法，随机化数组,效率最高
		 * **/
		public static function randomArray( arr:Array , num:int = 6 ):Array
		{
			if(arr != null)
			{					
				var rnd:uint;
				var temp:*;
				var len:uint = arr.length;
				var time:int = getTimer();
				
				for(var i:uint;i<len;i++)
				{
					temp = arr[i];
					rnd = Math.random() * len;
					arr[i] = arr[rnd];
					arr[rnd] = temp;
				}
				time = getTimer() - time;	
				arr = arr.slice( 0, num);
				arr = arr.sort( Array.NUMERIC );
				trace("循环" + len + "次,花费时间: " + time + " 毫秒,获得随机数组: " + arr);
			}
			return arr;
		}
		
		/**
		 * 清理一个数组中相同的数据
		 * @return Array 清理后的数据
		 * 
		 */		
		public static function clearTheSameInArray(arr:Array):Array
		{
			if(arr == null)
				return arr;
			
			arr = arr.sort( Array.NUMERIC );
			var i:int=arr.length-1;						
			while(i>0)
			{
				if(arr[i] == arr[i-1])
				{
					trace("_______________数组中相同的数字: " + arr[i]);
					arr.splice(i,1);
					i=arr.length-1;
				}
				i--;
			}
			trace("_______________清除数组中相同数据后的数组：" + arr);
			return arr;
		}
		
		/**
		 * 2012.3.3
		 * 讲两个数组合成一个数组，并将数据相同的两个数合并 
		 * @param arr1  数字数组
		 * @param arr2 数字数组
		 * @param type 返回类型 0为返回合并的数组(交集)，1为返回两个数组中相同数据的数组(交集取补)，2为返回两个数组中除去相同数据后的数组(并集)
		 * @return Array 合并的数组
		 * 
		 */		
		public static function mergeArray( arr1:Array , arr2:Array , type:int = 2):Array
		{
			var a1:Array = [];
			var a2:Array = [];
			var a3:Array = [];
			var temp:Array = arr1.concat(arr2);		
			temp = temp.sort(Array.NUMERIC);
			for each (var _key:* in temp)
			{
				if (arr1.indexOf(_key) != -1 && arr2.indexOf(_key) != -1)
				{
					if (a1.indexOf(_key) == -1)
					{
						a1.push(_key);//相同
					}
				}
				else
				{
					if (a2.indexOf(_key) == -1)
					{
						a2.push(_key);//不同
					}
				}
			}			
			if(type == 0) //交集
			{
				temp = a1;
			}
			else if(type == 1) //交集取补
			{
				temp = a2;
			}
			else if(type == 2) //并集
			{
				temp = a1.concat(a2);
			}
			trace("_______________a1（交集）: " + a1 + " a2（交集取补）: " + a2 + " 并集: " + a1.concat(a2));
			return temp;
		}
	
		/**
		 * 2012.3.3
		 * 找出两个不同数组中相同的对象来
		 * @param arrA
		 * @param arrB
		 * @return Array 
		 * 
		 */		
		public static function findDiff(arrA:Array,arrB:Array):Array
		{			
			var diff:Array = new Array;			
			var dic:Dictionary = new Dictionary(true);			
			var o:Object;			
			for each(o in arrA)
			{				
				if(dic[o])
					diff.push(o);				
				dic[o] = true;				
			}			
			for each(o in arrB)
			{			
				if(dic[o])
					diff.push(o);				
				dic[o] = true;				
			}			
			return diff;			
		}		
		/***********************************************
		 * ...(rest) 用法
		 */
	    public static function setArgs(...args):Array
		{
			var arr:Array = [];
			for(var i:int=0;i<args.length;i++)
			{
				arr.push(args[i]);
			}
			return arr;
		}	
	}
}