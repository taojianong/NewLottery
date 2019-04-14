package com.res
{
	import flash.media.Sound;
	
	import mx.core.SoundAsset;

	public class Resource
	{		
		//--------------------------------Login----------------------------//
		[Embed(source = '../../../bin-debug/icon/des_16.png')]
		/**<b>工具Logo_16*16-图像资源</b>**/
		static public var LogohIcon_16:Class;
		[Embed(source='../../../bin-debug/icon/des_32.png')]
		/**<b>工具Logo_32*32-图像资源</b>**/
		static public var LogohIcon_32:Class;
		[Embed(source='../../../bin-debug/icon/des_64.png')]
		/**<b>工具Logo_48*48-图像资源</b>**/
		static public var LogohIcon_48:Class;
		[Embed(source='../../../bin-debug/icon/des_128.png')]
		/**<b>工具Logo_128*128-图像资源</b>**/
		static public var LogohIcon_128:Class;
		
		//--------------------------------File----------------------------//
		[Embed(source='../../../bin-debug/icon/des_128.png')]
		/**<b>按钮图标_新建文档</b>**/
		static public var File_Icon_New:Class;
		
		public function Resource()
		{
		}
	}
}