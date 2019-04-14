package com.manger
{
	import com.ConfigGlobal;
	import com.DataGlobal;
	import com.UIGlobal;
	import com.pub.ArrayUtill;
	import com.util.RandomUtil;
	
	import sky.util.DMap;

	/**
	 * 规则管理类 
	 * @author taojianlong
	 * 
	 */	
	public class RuleManager
	{
		public function RuleManager()
		{
		}
		
		/**
		 *存质数相关信息 
		 */		
		public var pDMap:DMap = new DMap;
		/**
		 * 从红球数组中获取奇偶比三区比质数比 
		 * @param value 数组[1,2,3,4,5,6]
		 * @return 奇偶比(odd,even)，三区比(one,two,three)，质数比(primes)，是否有连号(hasHyphen)
		 * 
		 */		
		public function getOddEven(value:Array):Object
		{
			if(value != null)
			{
				var odd:int = 0; //奇数
				var even:int = 0;//偶数
				var one:int = 0; //一区
				var two:int = 0; //二区
				var three:int = 0; //三区
				//var primes:int = 0; //质数				
				for(var i:int=0;i<value.length;i++)
				{
					var num:int = int(value[i]);
					num%2==0 ? (even++) : (odd++);
					
					if(num <= 11)
						one++;
					else if(num >= 12 && num <= 22)
						two++;
					else if(num >= 23 && num <= 33)
						three++;		
					
					if(DataGlobal.PRIMES.indexOf(num) != -1)
					{
						//primes++;
						if(pDMap.get("p_" + num) != null)
						{
							pDMap.d["p_" + num]++;
						}
						else
						{
							pDMap.put("p_" + num , 1 );
						}
					}
						
				}
				var obj:Object = new Object;
				obj.odd = odd;
				obj.even= even;
				obj.one = one;
				obj.two  = two;
				obj.three = three;
				obj.primes = pDMap;
				obj.hasHyphen = ArrayUtill.arrayHasHyphen( value ) ; //是否有连号
				
				return obj;
			}
			return null;
		}
		
		/**
		 * 根据奇偶比选红色球号,奇偶比和必为6
		 * @param oddNumber 奇数比
		 * @param evenNumber 偶数比
		 * @param excArr 要排除的选号
		 */	
		public function selectNumberByParity( oddNumber:int=3,evenNumber:int=3 ,excArr:Array = null):Array
		{			
			if(excArr == null)
				excArr = [];
			var arr:Array = [];
			excArr = arr.concat( excArr );
			var num:int = 1;
			if( (oddNumber + evenNumber) != 6)
			{
				trace("红色球号奇偶号码数比为6");//TODO 界面提醒
			}
			else
			{
				while(oddNumber > 0) //奇数
				{
					num = RandomUtil.makeRomdom( DataGlobal.RED_FROM,DataGlobal.RED_TO,excArr);
					if( num % 2 != 0 )
					{
						arr.push( num );
						excArr.push( num );
						oddNumber--;
					}						
				}
				
				while(evenNumber > 0) //偶数
				{
					num = RandomUtil.makeRomdom( DataGlobal.RED_FROM,DataGlobal.RED_TO,arr);
					if( num % 2 == 0 )
					{
						arr.push( num );
						excArr.push( num );
						evenNumber--;
					}						
				}
			}			
			arr = arr.sort( Array.NUMERIC );
			return arr;
		}
		
		/**
		 * 根据奇偶比，三区比，质数比选择红色球号码，其中奇偶比和为6，三区比和为6，质数必须为小于等于6的数字 
		 * @param oddNumber 奇数比
		 * @param evenNumber 偶数比
		 * @param oneArea 一区
		 * @param twoArea 二区
		 * @param threeArea 三区
		 * @param primes 质数个数范围内，在0~6范围内,大于6则默认为6
		 * @return Array 根据设置奇偶比，三区比，质数比，选择出的数据 
		 * @param isHyphen 是否出连号
		 * @param excArr 要排除选号
		 */		
		public function selectedNumbersWith( oddNumber:int=3,evenNumber:int=3,oneArea:int=3,twoArea:int=2,threeArea:int=1,primes:int=2 ,isHyphen:Boolean=true , excArr:Array=null):Array
		{
			if((oddNumber+evenNumber) != 6)
			{
				trace("红色球号奇偶号码数必为6");//TODO 界面提醒
				return [];
			}
			else if( (oneArea+twoArea+threeArea) != 6 )
			{
				trace("红色球号三区号码数必为6");//TODO 界面提醒
				return [];
			}
			else if(primes > 6)
			{
				primes = 6;
			}
				
			primes = int(Math.random()*primes); //区这个范围
			var odd:int = 0;  //奇数个数
			var even:int = 0; //偶数个数
			var one:int = 0; //一区个数
			var two:int = 0; //二区个数
			var three:int = 0; //三区个数
			var prim:int = 0; //质数个数
			
			var arr:Array = [];
			var i:int = 0;
			var isFind:Boolean = false;
			
			var count:int = 0; //计算次数
			while(!isFind)
			{
				count++;
				arr = null; 
				even = 0 ;
				odd = 0;
				one = 0;
				two = 0;
				three = 0;
				prim = 0;
				arr = selectNumberByParity( oddNumber , evenNumber, excArr); // RandomUtil.getRandomRedNumbers();
				//trace("初选号码: " + arr);
				if(isHyphen && !ArrayUtill.arrayHasHyphen( arr ) ) //如果要检测有连号，但是没有连号则continue
				{
					num++;
					continue;
				}
				else if(!isHyphen && ArrayUtill.arrayHasHyphen( arr ) ) //如果要检测是无连号，但是有连号则continue
				{
					num++;
					continue;
				}
				//trace("arr: " + arr);
				i = 0;
				for(i=0;i<arr.length;i++)
				{
					var num:int = arr[i];				
					num%2==0 ? (even++) : (odd++);
					
					if(num <= 11)
						one++;
					else if(num >= 12 && num <= 22)
						two++;
					else if(num >= 23 && num <= 33)
						three++;		
					
					if(DataGlobal.PRIMES.indexOf(num) != -1)
						prim++;
				}
				//trace("odd(奇):even(偶)__ " + odd + ":" + even + "  one:two:three__ " + one + ": " + two + ":" + three + "  prim: " + prim );
				if(odd == oddNumber && even == evenNumber && oneArea == one &&
					twoArea == two && threeArea == three && primes == prim)
				{		
					trace("计算 " + count + " 次得出结果.");
					isFind = true;
					return arr;
				}
				
				isFind = false;
			}		
			return null;
		}
		
		/**
		 * 获取从1-33中排除的数字,然后随机选出6个不同的数据 
		 * @param exc 排除的数据，必须保留6位数
		 * @param theSameRate 出现exc中的数据的概率 （0~1之间）
		 * @param mustReds 选号时必须出现的红色球数字 数组长度必定小于等于6,且不能出现相同的数字
		 * @param noReds 选号时必不出现的红色球数
		 * @return Array 排除exc中的数据，后获取的1-33位中随机的6个红色球数据
		 * 
		 */		
		public function getExclusiveReds( exc:Array=null , theSameRate:Number = 1 ,mustReds:Array = null,noReds:Array=null):Array
		{			
			if(noReds != null)
			{							
				exc = exc != null ? exc.concat(noReds) : noReds;	
				exc = ArrayUtill.clearTheSameInArray( exc );
				if(exc.length > 27) //当排除的数字大于27时，随机选取27个要排除的数，因为必须保留6个数字，那样才不会造成死循环,或循环很慢
				{
					//exc = ArrayUtill.getRandomFromArray( exc , 27 );
					exc = ArrayUtill.randomArray( exc , 27 ); //2012.10.3
				}
			}
			if(theSameRate < 0)
				theSameRate = 0;
			else if(theSameRate > 1)
				theSameRate = 1;
			
			var ran:Number = 0;
			var val:uint =0;
			var num:uint = 0;
			var arr:Array = [];				
			if(mustReds != null)
				arr = arr.concat(mustReds);
			var mArr:Array = []; //合并数组
			var i:int = 0;
			var isPush:Boolean = false;
			while(arr.length < DataGlobal.REDS)
			{
				//用于概率判断
				val = Math.pow(10,String(theSameRate.toString().split('.')[1]).length );
				ran = uint(Math.random() * val);
				
				num = RandomUtil.makeRomdom( DataGlobal.RED_FROM , DataGlobal.RED_TO , arr );				
				if( exc != null )  //判断是否选择上期中奖的号码
				{
					if(theSameRate>0)
					{			
						trace("num: " + num + "   indexOf: " + exc.indexOf(String(num)) );
						if( exc.indexOf(String(num)) != -1) //exc中搜索到了数据 num
						{
							if(ran <= int(theSameRate * val))
							{
								DataGlobal.Instance.pushDisplayInfo = "选出与上期相同的红色球号码： " + num + "  概率为: " + theSameRate ;								
								arr.push( num );								
							}		
							isPush = true;
						}
					}
					else
					{
						mArr = arr.concat( exc );					
						num = RandomUtil.makeRomdom( DataGlobal.RED_FROM , DataGlobal.RED_TO , mArr );
					}
				}	
				
				if(!isPush)
					arr.push( String(num) );
				isPush = false;
			}
			
			trace("_______________合并数组     arr:" + arr + " exc: " + exc + "____mArr: " + mArr);
			return arr.sort(Array.NUMERIC);			
		}
						
		/**
		 * 选择出于已中奖第N期不重复的红色球数字 (排除第N期每个数字)
		 * @param period 获取前period期的红色球数据，合成的一个不重复的数组
		 * @param theSameRate 出现第N期相同数字的概率,0~1之间的数
		 * @param mustReds 选号时必须出现的红色球数字 数组长度必定小于等于6,且不能出现相同的数字
		 * @param noReds 选号时必不出现的红色球数
		 * @return Array 选出的红色球数据
		 * 
		 */		
		public function findAllNoRepetRedNumbers( period:int = 3 , theSameRate:Number = 1 , mustReds:Array=null,noReds:Array=null):Array
		{
			var arr:Array = DataGlobal.Instance.getPrevNPeriodReds( period ); //DataGlobal.Instance.getPeriodReds(period)
			return this.getExclusiveReds( arr  , theSameRate , mustReds , noReds);			
		}
		
		/**
		 * 选择出于已中奖上N期不重复的红色球数字 (与上N期所有数字相同)
		 * @param prevNoRepetPeriod	 不重复的期数
		 * @param balls 表示要从这个数组中选择出prevNoRepetPeriod位不重复的数据，prevNoRepetPeriod为0则遍历balls所有数据
		 * balls 不为带','的数组
		 * @return Array
		 */	
		public function findNoRepetRedNumber( prevNoRepetPeriod:int = 0 , balls:Array = null):Array
		{
			if(balls == null)
			{
				return RandomUtil.getRandomRedNumbers();
			}
			
			var len:int ;
			if(prevNoRepetPeriod == 0)
			{
				len = balls.length;
			}
			else
				len = prevNoRepetPeriod > balls.length ? balls.length : prevNoRepetPeriod;
					
			var arr:Array ;
			var isRep:Boolean = true;
			while(isRep)
			{
				arr = RandomUtil.getRandomRedNumbers();
				isRep = false;
				for(var i:int=0;i<len;i++)
				{
					var _arr:Array = (balls[i] as Array).sort(Array.NUMERIC) as Array;
					var str:String = _arr.join(',');
					var _str:String = ( arr.sort(Array.NUMERIC) as Array).join(',');
					if( str == _str )
					{
						//trace("*********the same reds: " + str);
						DataGlobal.Instance.pushDisplayInfo = "*********the same reds: " + str ;
						//UIGlobal.Instance.mainUI.info.text += "*********the same reds: " + str + "\n";
						isRep = true;
						break;
					}
				}				
				if(!isRep)
				{
					//trace("选择出于已中奖上"+ len + "期不重复的红色球数字 " + arr.join(','));
					DataGlobal.Instance.pushDisplayInfo = "选择出于已中奖上"+ len + "期不重复的红色球数字 " + arr.join(',');
					//UIGlobal.Instance.mainUI.info.text += "选择出于已中奖上"+ len + "期不重复的红色球数字 " + arr.join(',') + "\n";
					return arr;
				}
			}
			return null;
		}
		
		/**
		 * 选择出于上N期不重复的蓝色球数字 
		 * @param prevNoRepetPeriod 一般为不超过16期的数字(作者要求只能上限为15,建议为5-10期)
		 * @param theSameRate 与这前prevNoRepetPeriod出现相同蓝色数据的概率,默认为0,可以根据自己需求选择(0-1之间的数,最高设置小数点后5位数)
		 * @param theMostPeriod 最大排除多少期
		 * @return int 选择蓝色球的号码
		 */	
		public function findNoRepetBuleNumber( prevNoRepetPeriod:int = 5 , theSameRate:Number=0.005 ,theMostPeriod:int=10):int
		{
			var arr:Array = ConfigGlobal.Instance.blues ;
			var num:int;
			var len:int ;
			if(prevNoRepetPeriod == 0)
			{
				len = arr.length;
			}
			else
				len = prevNoRepetPeriod > arr.length ? arr.length : prevNoRepetPeriod;
			
			if(len > theMostPeriod)
				len = int(Math.random()*theMostPeriod) + 1;	
			
			arr = arr.slice(0,len);		
			
			var ran:Number = 0;
			if(theSameRate > 0 && theSameRate<=1)
			{
				var val:int = Math.pow(10,String(theSameRate.toString().split('.')[1]).length );
				var blue:int =  RandomUtil.makeRomdom( DataGlobal.BLUE_FROM , DataGlobal.BLUE_TO);	
				ran = int(Math.random() * val);
				for(var i:int=0;i<arr.length;i++)
				{
					if(arr[i] == blue && ran>0 && ran <= int(theSameRate * val) )
					{
						//trace("出现与上" + len + "期出现相同蓝色球的概率为: "  + theSameRate );
						DataGlobal.Instance.pushDisplayInfo = "当前选择的蓝色球数字： " + num  + "\n与上" + len + "期出现相同蓝色球的概率为: "  + theSameRate;
						return blue;
					}
				}				
			}		
			num = RandomUtil.makeRomdom( DataGlobal.BLUE_FROM , DataGlobal.BLUE_TO , arr);
			//DataGlobal.Instance.pushDisplayInfo = "当前选择的蓝色球数字： " + num  + "\n上"+len+"期蓝色球数字: " + arr.toString();
			return  num;			
		}
		
		/**
		 * 随机获取period组红蓝色数字，红蓝色以'-'隔开 [绝对随机]
		 * @param period 期数
		 * @return Array 返回获取的红蓝色球数据
		 * 
		 */		
		public function getRandomRedAndBlueBalls( period:int = 5 ):Array
		{
			var arr:Array = [];			
			for(var i:int=0;i<period;i++)
			{
				var blue:int = RandomUtil.makeRomdom( DataGlobal.BLUE_FROM , DataGlobal.BLUE_TO );
				var str:String = this.getRandomReds.toString() + "-" + blue ; 
				arr.push( str );
			}
			return arr;
		}
		
		/**
		 * 随机获取一组红色球数据 
		 * @return 
		 * 
		 */		
		public function get getRandomReds():Array
		{
			var arr:Array = [];
			var num:int;
			while(arr.length < DataGlobal.REDS)
			{
				num = RandomUtil.makeRomdom( DataGlobal.RED_FROM , DataGlobal.RED_TO , arr );
				arr.push( num );
			}
			arr = arr.sort(Array.NUMERIC);
			return arr;
		}
		
		private static var instance:RuleManager;
		public static function get Instance():RuleManager
		{
			if(instance == null)
			{
				instance = new RuleManager;
			}
			return instance;
		}
	}
}