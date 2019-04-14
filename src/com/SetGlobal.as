package com
{
	/**
	 * 面板参数设置 
	 * @author dragon
	 * 
	 */	
	public class SetGlobal
	{
		public function SetGlobal()
		{
		}
		
		/**
		 * <b>奇偶比,奇偶比和为6</b><br/>
		 * 奇数 
		 */		
		public var odd:int = 3;
		
		/**
		 * <b>奇偶比,奇偶比和为6</b><br/>
		 * 偶数 
		 */		
		public var even:int = 3;
		
		/**
		 * <b>三区比,三区比之和为6</b><br/>
		 * 一区 (1~11)
		 */		
		public var one:int = 1;	
		/**
		 * <b>三区比,三区比之和为6</b><br/>
		 * 二区 (12~22)
		 */	
		public var two:int = 2;		
		/**
		 * <b>三区比,三区比之和为6</b><br/>
		 * 三区 (23~33)
		 */	
		public var three:int = 3;
		
		/**
		 * 出现质数个数 
		 */		
		public var primes:int = 2;
		
		/**
		 * 是否出连号 
		 */		
		public var isHyphen:Boolean = false;
		
		/**
		 * 选出几期号码 
		 */		
		public var selectPreiods:int = 1;
		
		/**
		 * 必定选出的红色球数字,作为算号时的参考
		 * 选号时必定出现的数字
		 */		
		public var mustReds:Array = [];
		
		/**
		 * 必不选出出的红色球数字,作为算号时的参考
		 * 选号时不能出现的数字
		 */		
		public var noReds:Array = ["1","33"];
		
		/**
		 * 第上period期，从0开始,0表示最近一期 
		 */		
		public var period:int = 0;
		
		/**
		 * 出现与上期出现相同红色球的概率 
		 */		
		public var theSameRedRate:Number = 0;
		
		/**
		 * 出现与上期出现相同蓝色球的概率 
		 */		
		public var theSameBlueRate:Number = 0;
		
		private static var instance:SetGlobal;
		public static function get Instance():SetGlobal
		{
			if(instance == null)
			{
				instance = new SetGlobal;
			}
			return instance;
		}
	}
}