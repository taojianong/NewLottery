package com.setup
{
	import com.UIGlobal;
	import com.res.Resource;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowDisplayState;
	import flash.display.NativeWindowSystemChrome;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowDisplayStateEvent;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;

	public class SettingSystem
	{
		public function SettingSystem()
		{
		}
		
		/**
		 * 初始化，默认为打开程序显示任务栏小图表，并将窗体显示在屏幕中间  
		 * 
		 */		
		public function init():void
		{
			setupAIRMinimizeType();//设置AIR最小化时的状态
			FlexGlobals.topLevelApplication.nativeWindow.visible = true; //设置本地程序窗体不可见      
			SystemTrayIcon(NativeApplication.nativeApplication.icon).bitmaps = 
				[new Resource.LogohIcon_16().bitmapData , new Resource.LogohIcon_32().bitmapData , new Resource.LogohIcon_48().bitmapData , new Resource.LogohIcon_128().bitmapData];//设置托盘的图标
		}
		
		/**设置AIR最小化时的状态**/
		public function setupAIRMinimizeType():void
		{
			if(NativeApplication.supportsSystemTrayIcon)
			{      
				setSystemTrayProperties();//设置托盘菜单的事件      
				SystemTrayIcon(NativeApplication.nativeApplication.icon).menu = createSystrayRootMenu();//生成托盘菜单      
			}           
		}
		
		/**设置托盘图标的事件**/      
		private function setSystemTrayProperties():void
		{      
			SystemTrayIcon(NativeApplication.nativeApplication.icon).tooltip = "双色球选号器";  
			//托盘小图标监听点击事件
			SystemTrayIcon(NativeApplication.nativeApplication.icon).addEventListener(MouseEvent.CLICK, iconClickHandler); 
			//监听窗体显示事件，比如最大化最小化，关闭等
			FlexGlobals.topLevelApplication.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, airMinimized);       
		} 
		
		//是否最小化	
		private var isDock:Boolean = false;		
		public function iconClickHandler(event:MouseEvent):void
		{
			isDock = !isDock;
			if(isDock)
			{
				dock();
			}
			else
			{
				undock();
			}
		}
		
		/**激活程序窗体**/      
		public function undock(event:Event=null):void 
		{      
			isDock = false;
			FlexGlobals.topLevelApplication.nativeWindow.visible = true;//设置本地程序窗体可见      
			FlexGlobals.topLevelApplication.nativeWindow.orderToFront();//设置本地程序窗体到最前端      
			//NativeApplication.nativeApplication.icon.bitmaps = [];//将托盘图标清空      
		}  
		
		/**最小化窗体**/      
		private function airMinimized(displayStateEvent:NativeWindowDisplayStateEvent):void 
		{      
			if(displayStateEvent.afterDisplayState == NativeWindowDisplayState.MINIMIZED) //最小化
			{      
				displayStateEvent.preventDefault();//阻止系统默认的关闭窗体事件      
				dock();//将程序放入托盘      
			}      
		} 
		
		/**将本地应用程序放到托盘**/      
		public function dock():void 
		{      
			isDock = true;
			if(NativeApplication.supportsSystemTrayIcon) 
			{ 
				FlexGlobals.topLevelApplication.nativeWindow.visible = false; //设置本地程序窗体不可见      
				SystemTrayIcon(NativeApplication.nativeApplication.icon).bitmaps = [new Resource.LogohIcon_16().bitmapData,new Resource.LogohIcon_32().bitmapData,new Resource.LogohIcon_48().bitmapData,new Resource.LogohIcon_128().bitmapData];//设置托盘的图标  
			}
			else
			{
				Alert.show( "对不起，该系统不支持最小化到托盘", "系统提示");
			}
		}  
		
		/**设置任务栏鼠标右键**/
		private function createSystrayRootMenu():NativeMenu
		{      
			var menu:NativeMenu = new NativeMenu();      
			var openNativeMenuItem:NativeMenuItem = new NativeMenuItem("打开主面板");//生成OPEN菜单项      
			//var msgNativeMenuItem:NativeMenuItem = new NativeMenuItem("msg");//生成OPEN菜单项   
			var exitNativeMenuItem:NativeMenuItem = new NativeMenuItem( "退出" );//同理      
			openNativeMenuItem.addEventListener(Event.SELECT, undock);      
			exitNativeMenuItem.addEventListener(Event.SELECT, closeApp);//添加EXIT菜单项事件      
			//msgNativeMenuItem.addEventListener(Event.SELECT,infos);   
			menu.addItem(openNativeMenuItem);      
			//menu.addItem(msgNativeMenuItem);   
			menu.addItem(new NativeMenuItem("",true));//separator       
			menu.addItem(exitNativeMenuItem);//将菜单项加入菜单      			
			return menu;      			
		} 
		
		/**关闭程序窗体**/      
		public function closeApp(event:Event):void 
		{      
			FlexGlobals.topLevelApplication.nativeWindow.close();      
		} 
		
		private static var instance:SettingSystem;
		public static function get Instance():SettingSystem
		{
			if(instance == null)
			{
				instance = new SettingSystem;
			}
			return instance;
		}
	}
}