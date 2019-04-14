package com.manger
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class FileManager
	{
		public function FileManager()
		{
		}
		
		/**<b>读取的XML文件</b>**/
		private var readXML:XML; 
		
		/**<b>读取存储的XML文件</b>**/
		private function readStoreXML():void
		{
			var file:File = File.applicationDirectory.resolvePath("xml/store.xml"); 				
			trace("file.data: " + file.data + " file.nativePath: " + file.nativePath);
			var stream:FileStream = new FileStream;
			stream.open(file, FileMode.READ);
			var fileData:String = stream.readUTFBytes(stream.bytesAvailable);				
			readXML = new XML(fileData);					
			trace("readXML: " + readXML);
		}
		
		/**<b>保存XML文件 </b>**/
		private function saveXMLFile(path:String,xml:XML=null):void 
		{
			var filebyte:ByteArray=new ByteArray();
			filebyte.writeUTFBytes( xml.toString() );//直接写入utf字节流
			
			var file:File = File.applicationStorageDirectory;
			file = file.resolvePath( path );
			
			var stream:FileStream = new FileStream(); 
			stream.open( file,FileMode.WRITE );   				
			stream.writeBytes( filebyte );			
			stream.close();				
			trace( "数据保存路径：" + file.nativePath  + " xml: " + xml);
		}	
		
		/**<b>要写入的XML文件</b>**/
		private var writeXML:XML;
		/**<b>改变XML指定节点的名字</b>**/
		private function getChangeWriteXMLNode(txt:String):XML
		{
			if(readXML != null)
			{
				trace("file.length: " + readXML.file.length());
				for(var i:int=0;i<readXML.file.length();i++)
				{						
					var _name:String = readXML.file[i].@name;
					if(readXML.file[i].@id == "n1")
					{
						readXML.file[i].@name = txt;
						writeXML = readXML;
					}
					//trace("name: " + _name);
				}
				//readXML.appenChild(newStroe);
			}					
			//trace("readXML: " + readXML);
			return readXML;
		}
		
		private static var instance:FileManager;
		public static function get Instance():FileManager
		{
			if(instance == null)
			{
				instance = new FileManager;
			}
			return instance;
		}
	}
}