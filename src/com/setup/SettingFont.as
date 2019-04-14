package com.setup
{
	import flash.display.Sprite;
	import flash.text.Font;

	public class SettingFont extends Sprite
	{
		[Embed(source = "../../../bin-debug/font/windowsblack.ttf", fontName = "微软雅黑", advancedAntiAliasing = "true", mimeType = "application/x-font")]
		public var WindowsBlackFont:Class;  
		
		public function SettingFont()
		{
			
		}
		
		/**镶嵌自定义字体**/
		public function setCustomFont():void
		{
			Font.enumerateFonts(new WindowsBlackFont());
		}
	}
}