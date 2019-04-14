package com.loader
{
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	/**用于加载swf,jpg资源**/
	public class SWFLoader
	{
		public static var Obj:Object = new Object;
		public static var loader:Loader = new Loader;
		public static function load(url:String,obj:Object = null,container:Object = null):void
		{
			Obj = obj;
			//var loader:Loader = new Loader;			
			var reques:URLRequest = new URLRequest;
			
			if(url != "" && url != "stage")
			{
				reques.url = url;
				try
				{
					loader.load(reques);
				}
				catch(err:Error)
				{
					trace("Loading error : " + err);
				}	
				if(obj.Progress != null) loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,obj.Progress);	
				if(obj.Complete != null) loader.contentLoaderInfo.addEventListener(Event.COMPLETE,obj.Complete);		
				//container.addChild(loader);
			}
			else if(container is Stage || url == "stage")
			{
				/* 
				* 作   用: 加载舞台自身
				* 用   法: SWFLoader.load("stage",this,{Complete:onComplete,Progress:onProgress});
				* 疑   问: 这里container为stage时加载问题，在帧上为stage表现为不加载
				*/
				//trace("this is load stageSelf");
				if(obj.Progress != null) container.loaderInfo.addEventListener(ProgressEvent.PROGRESS,obj.Progress);
				if(obj.Complete != null) container.loaderInfo.addEventListener(Event.COMPLETE,obj.Complete);
			}		
			else
			{
				trace("url can't set null value");
			}
		}	
		
		public static function clear():void
		{
			if(Obj.Progress != null) loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,Obj.Progress);	
			if(Obj.Complete != null) loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,Obj.Complete);	
		}
	}
}