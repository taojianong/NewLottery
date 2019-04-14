package com.res
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	
	public class CustomFilters
	{
		public function CustomFilters()
		{
		}
		/**<b>抽奖描黄色边滤镜</b>**/
		public static var betFilter:GlowFilter = new GlowFilter(0xFFFF00, 1, 8, 8, 3);		
		/**<b>描黄色边滤镜</b>**/
		public static var yellowFilter:GlowFilter = new GlowFilter(0xFFF000, 1, 3,3);		
		/**<b>文字描黑色边滤镜</b>**/
		public static var glowFilter:GlowFilter = new GlowFilter(0x0, 1, 3,3);		
		/**<b>绿边滤镜</b>**/
		public static var greenFilter:GlowFilter = new GlowFilter(0xC7EDCC, 1, 3,3);		
		/**<b>偏亮滤镜</b>**/
		public static var mLighterFilter:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 15, 0, 1, 0, 0, 15, 0, 0, 1, 0, 15, 0, 0, 0, 1, 0]);		
		/**<b>图片高亮滤镜</b>**/
		public static var mHilightFilter:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 50, 0, 1, 0, 0, 50, 0, 0, 1, 0, 50, 0, 0, 0, 1, 0]);		
		/**<b>图片白亮滤镜</b>**/
		public static var mWhiteFilter:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 100, 0, 1, 0, 0, 100, 0, 0, 1, 0, 100, 0, 0, 0, 1, 0]);		
		/**<b>图片灰色滤镜</b>**/
        public static var mGreyFilter:ColorMatrixFilter = new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 1, 0]);
        
	}
}