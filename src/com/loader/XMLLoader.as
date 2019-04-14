/*
  作   者: 淘剑龙
  时   间: 2010.11.28
  作   用: 主要用于加载XML文件，和处理XML文件
  用   法: var xl:XMLLoader = new XMLLoader(url,xmlLoadComplete);
  说   明: url为加载地址，xmlLoadComplete为加载完成后掉用的事件，这个需自己去设计他加载完成后的调度事件
  注   意: 建议这样写xmlLoadComplete事件 function xmlLoadeComplete(e:Event){var myxml:XML = new XML(e.target.data)}
*/
package com.loader
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	public class XMLLoader
	{
		//public var url:String;
		public var myLoader:URLLoader;
		public var myRequest:URLRequest;
		public var xmlLoadComplete:Function;		
		private var per:Number;
		public function XMLLoader(url:String,xmlLoadComplete:Function):void
		{
			myLoader  = new URLLoader();
			myRequest = new URLRequest();
			myRequest.url = url;       
			try
			{
				myLoader.load(myRequest);
			}
			catch(err:Error)
			{
				trace("err: "+err);
			}
			myLoader.addEventListener(ProgressEvent.PROGRESS,onProgress);
			myLoader.addEventListener(Event.COMPLETE,xmlLoadComplete);
			myLoader.addEventListener(IOErrorEvent.IO_ERROR,ioError);
		}		
		private function ioError(event:Event):void
		{
			trace("加载XML文件错误,加载操作失败");
		}
		
		/**<b>加载XML文件</b>
		 * @param
		 * url 加载地址
		 * xmlLoadComplete 加载完成事件
		 * loadError 加载错误事件		 
		 * **/
		public static function load( url:String , xmlLoadComplete:Function = null, loadError:Function = null ):void
		{
			var loader:URLLoader = new URLLoader;			
			try
			{
				loader.load(new URLRequest(url));
			}
			catch(err:Error)
			{
				trace("____________________err: " + err );
			}											
			loader.addEventListener(Event.COMPLETE,xmlLoadComplete);
			if(loadError != null)
				loader.addEventListener( IOErrorEvent.IO_ERROR , loadError );
		}
		private function onProgress(e:ProgressEvent):void
		{
			per = e.bytesLoaded / e.bytesTotal;
			//trace("per: " + per);
		}
		
		//////////
		public static function loadXMLStream(url:String,xmlLoadComplete:Function):void
		{
			var stream:URLStream = new URLStream();		
			//stream.addEventListener(IOErrorEvent.IO_ERROR,doIOError);
			stream.addEventListener(Event.COMPLETE,xmlLoadComplete);
			//stream.addEventListener(ProgressEvent.PROGRESS,doProgress);
			stream.load(new URLRequest(url));	
		}
		
//		private function xmlLoadComplete(evt:Event):void
//		{
//			var stream:URLStream = evt.target as URLStream;
//			var byteList:ByteArray = new ByteArray();
//			if(stream.connected)
//			{   
//				stream.readBytes(byteList,byteList.length);   
//				byteList.position = 0;
//				var result:String = byteList.readMultiByte(byteList.length,"utf-8").replace("\r\n","");
//				var loadXML:XML = new XML(result);	
//			}
//		}
	}
}