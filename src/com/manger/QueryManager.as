package com.manger
{
	import com.ConfigGlobal;
	import com.DataGlobal;
	import com.UIGlobal;
	import com.event.MySQLEvent;
	import com.pub.ArrayUtill;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	/**
	 * 存储数据管理器 
	 * @author cl
	 * 
	 */	
	public class QueryManager
	{
		public function QueryManager()
		{
			
		}		
		
		/**
		 * 创建一个数据库文件保存对应数据 
		 */		
		//private var db:File = File.applicationStorageDirectory.resolvePath("sdcard/query.db"); 
		
		private var conn:SQLConnection; 
		private var createTableStmt:SQLStatement; 
		/**<b>创建中奖号码 data表 </b>**/
		private var createDataTableSQL:String = 
			"CREATE TABLE IF NOT EXISTS Data (" + 
			"period INTEGER PRIMARY KEY AUTOINCREMENT," + 
			"data TEXT," + "date TEXT," + "stime TEXT)";  //创建表Data 字段（ period 期数 , data 数据 , date 时间,stime 开奖时间）
		/**<b>创建自选号码表</b>**/
		private var createSelfTableSQL:String =
		"CREATE TABLE IF NOT EXISTS Self (" + 
			"id INTEGER PRIMARY KEY AUTOINCREMENT," + "period INTEGER," +
			"data TEXT," + "seque TEXT," + "date TEXT," + "stime TEXT," + "log TEXT)"; //创建表Data 字段（ period 期数 , seque 序列号 , data 数据 , date 时间,stime 开奖时间,log 日志）	

		private var insertStmt:SQLStatement; 
		/**<b>插入数据到中奖号码表中</b>**/
		private var insertSQL:String = 
			"INSERT INTO Data (period , data , date , stime)" + 
			"VALUES (:period , :data , :date , :stime)"; 
		
		/**<b>插入数据到自选号码表中</b>**/
		private var insertSelfSQL:String = 
			"INSERT INTO Self (period , data , date , stime , log)" + 
			"VALUES (:period , :data , :date , :stime , :log)"; 
		
		/**
		 * 更新数据到Data表中 
		 */		
		public var updateDataSQL:String = 
			"UPDATE Data (period , data , date , stime)" + 
			"VALUES (:period , :data , :date , :stime)"; 
		
		/**<b>根据字段生成插入SQL语句</b>
		 * @param field 字段数组
		 * @return String 格式 "INSERT INTO Self ( data , date) VALUES ( :data , :date )"
		 * **/
		private function getInsertSQLString( field:Array ):String
		{
			if(field != null)
			{
				trace("________INSERT INTO Self ("+field.toString()+")" + 
					"VALUES (:" +field.join(", :")+ ")");
				return "INSERT INTO Self ("+field.toString()+")" + 
					"VALUES (:" +field.join(", :")+ ")";
			}
			return "";
		}
		
		/**
		 * 创建SQL .db文件 
		 * @param name 文件名字
		 * @param path 文件地址
		 * @param isClear 是否清除数据库
		 */		
		public function creatSQLFile(name:String,isClear:Boolean=false,path:String = UIGlobal.SPATH):void
		{
			var file:File = File.userDirectory; //创建或读取存储目录		
			file = file.resolvePath( path + name +".db" );			
			//在程序目录下创建数据库
//			var file:File = new File;
//			file.nativePath=File.applicationDirectory.nativePath + path + name +".db";
			trace("创建目录: " + file.nativePath + "  " + file.url );
			if (!file.exists || isClear) //如果不存在该文件则创建一个新文件并打开
			{
				var stream:FileStream = new FileStream(); 
				stream.open( file,FileMode.WRITE );   						
				stream.close();	
			}			
		}
		
		/**<b>链接完成</b>**/
		public var conectComplete:Function;
		private var dbFile:String; //要实用的库文件名		
		/**
		 * 链接数据库 
		 * 
		 */		
		public function connectSQLite( dbFile:String ):void
		{
			this.dbFile = dbFile;
			var file:File = File.userDirectory ; 
			file = file.resolvePath( UIGlobal.SPATH + dbFile + ".db");
			//在程序目录下创建数据库
//			var file:File = new File;
//			file.nativePath=File.applicationDirectory.nativePath + UIGlobal.SPATH + dbFile +".db";
			trace("nativePath: " + file.nativePath + "  url: " + file.url);	
			if (file.exists)
			{
				conn = new SQLConnection(); 
				conn.addEventListener(SQLEvent.OPEN, openHandler); 
				conn.addEventListener(SQLErrorEvent.ERROR, errorHandler); 
				conn.openAsync( file );				
			}					 
		}
		private function openHandler(event:SQLEvent):void
		{ 
			trace("Database opened successfully 成功打开数据库文件");
			DataGlobal.Instance.pushDisplayInfo = "Database opened successfully 数据库成功打开";
			conn.removeEventListener(SQLEvent.OPEN, openHandler); 	
			
			openTable(tables[0].text);
			
			var mysqlEvent:MySQLEvent = new MySQLEvent(MySQLEvent.CONNECT_COMPLETE);
			
			UIGlobal.Instance.app.dispatchEvent( mysqlEvent );			
		} 
		
		/**
		 * 删除表 
		 * 
		 */		
		public function deleteTable( table:String = "Self"):void
		{
			var str:String = "DROP TABLE " + table;
			createTableStmt = new SQLStatement(); 
			createTableStmt.sqlConnection = conn; 
			createTableStmt.text = str; 		
			createTableStmt.addEventListener( SQLEvent.RESULT , deleteTableResult); 
			createTableStmt.addEventListener(SQLErrorEvent.ERROR, deleteTableErrorHandler); 
			createTableStmt.execute(); 
		}
		
		private function deleteTableResult(event:SQLEvent):void 
		{ 
			trace("Table created 成功删除表 : ");		
			createTableStmt.removeEventListener(SQLEvent.RESULT, createResult);				
		} 
		private function deleteTableErrorHandler(event:SQLErrorEvent):void 
		{ 
			trace("删除表失败 Error message: " + event.error.message + "\n" + event.error.details);
		} 
		
		/**
		 * 要链接的表名字
		 */		
		private var tables:Array = [{table:'Data',text:createDataTableSQL},{table:'Self',text:createSelfTableSQL}];
		/**
		 * 打开表
		 * @param tableText 打开表的语句
		 * @param tableName 表名
		 */		
		public function openTable( tableText:String , tableName:String="" ):void
		{
			createTableStmt = new SQLStatement(); 
			createTableStmt.sqlConnection = conn; 
			createTableStmt.text = tableText; //createSelfTableSQL , createDataTableSQL			
			createTableStmt.addEventListener( SQLEvent.RESULT , createResult); //SQLEvent.RESULT
			createTableStmt.addEventListener(SQLErrorEvent.ERROR, errorHandler); 
			createTableStmt.execute(); 
		}
		
		private function createResult(event:SQLEvent):void 
		{ 
			trace("Table created 成功创建表 : " + tables[0].table);			
			DataGlobal.Instance.pushDisplayInfo = "Table created 成功创建表" + tables[0].table;
			tables.shift();
			createTableStmt.removeEventListener(SQLEvent.RESULT, createResult);	
			if(tables.length > 0)
				connectSQLite( dbFile );	
//			else
//				selectUsers( selectPeriod ); 
		} 
		private function errorHandler(event:SQLErrorEvent):void 
		{ 
			trace("Error message: " + event.error.message + "\n" + event.error.details);
			DataGlobal.Instance.pushDisplayInfo = "Error message: " + event.error.message; 
			DataGlobal.Instance.pushDisplayInfo = "Details: " + event.error.details; 
		} 
		
		private var selectStmt:SQLStatement; 
		private var selectSQL:String = "SELECT * FROM Data"; 
			
		/**<b>查询期数</b>**/
		public var selectPeriod:int ;
		/**
		 * 根据期数查询  中奖号码表(data) 数据库数据
		 * @param period 期数  默认0查询所有数据 
		 * @param table 表明 Data是中奖号码的表，Self是自己购买号码的数据库
		 */		
		public function selectUsers( period:int = 0 , table:String="Data"):void
		{ 
			selectPeriod = period;
			selectStmt = new SQLStatement(); 
			selectStmt.sqlConnection = conn; 			
			selectStmt.text = "select * from " + table + " where period='" + period+ "'"; 
			if(period == 0)
				selectStmt.text = "select * from " + table; 
			selectStmt.addEventListener(SQLEvent.RESULT, selectResult); 
			selectStmt.addEventListener(SQLErrorEvent.ERROR, errorHandler); 
			selectStmt.execute(); 
		} 
		
		/**<b>查询后执行的方法</b>**/
		public var selectFunc:Function;
		
		/**<b>查询所得数据</b>**/
		public var result:SQLResult; 
		
		private function selectResult(event:SQLEvent):void
		{ 
			DataGlobal.Instance.pushDisplayInfo = "";
			trace("Select completed 选择完成");
			DataGlobal.Instance.pushDisplayInfo = "Select completed 选择完成"; 
			
			result = selectStmt.getResult(); 
			
			if(result != null)
			{
				for each( var obj:Object in result.data )
				{
					DataGlobal.Instance.pushDisplayInfo = "期数: " + obj.period + "   " +obj.data;			
				}
			}			
			else
				DataGlobal.Instance.pushDisplayInfo = "数据为null";
			if(selectFunc != null)
				selectFunc.apply();
		} 
		
		/**
		 * 更新 
		 * @param period 期数
		 * @param data 红蓝色球数据
		 * @param date 时间
		 * @param stime 开奖时间
		 */		
		public function update(period:int , data:String , date:String ,stime:String=""):void
		{
			var updateDataSQL:String =
				"update Data set data=:data,date=:date,stime=:stime where period=:period";//"update Data set stime=:stime where period=:period";
			
			insertStmt = new SQLStatement(); 
			insertStmt.sqlConnection = conn; 
			insertStmt.text = updateDataSQL; 
			insertStmt.parameters[":period"] = period; 
			insertStmt.parameters[":data"] = data; 
			insertStmt.parameters[":date"] = date; 
			insertStmt.parameters[":stime"] = stime; 
			insertStmt.addEventListener(SQLEvent.RESULT, updateResult); 
			insertStmt.addEventListener(SQLErrorEvent.ERROR, updateErrorHandler); 
			insertStmt.execute(); 
		}
		
		private function updateResult(event:SQLEvent):void
		{
			UIGlobal.Instance.queryUI.info.text = "更新成功";
		}
		
		private function updateErrorHandler(event:SQLErrorEvent):void
		{
			UIGlobal.Instance.queryUI.info.text = "更新失败\n" +　event.error.message + "___" + event.error.details;
		}
		
		/**<b>删除完成后调用</b>**/
		public var deleteFunc:Function;
		
		/**
		 * 删除对应期数的数据 
		 * @param period 对应键值的值
		 * @param key 要删除的键
		 * @param table 要删除的表
		 */		
		public function delte(period:*,key:String= "period",table:String="Data"):void
		{
			var deleteDataSQL:String =
				"DELETE FROM "+table+" where "+key+"=:"+key; //delete from emp where salary=:salary
			
			insertStmt = new SQLStatement(); 
			insertStmt.sqlConnection = conn; 
			insertStmt.text = deleteDataSQL; 
			insertStmt.parameters[":"+key] = period; 
			insertStmt.addEventListener(SQLEvent.RESULT, deleteResult); 
			insertStmt.addEventListener(SQLErrorEvent.ERROR, deleteErrorHandler); 
			insertStmt.execute(); 
		}
		private function deleteResult(event:SQLEvent):void
		{			
			trace("删除中奖数据成功");
			if(deleteFunc != null)
				deleteFunc.apply();
		}		
		private function deleteErrorHandler(event:SQLErrorEvent):void 
		{ 
			trace("删除 Data表数据到失败\n" +　event.error.message + "___" + event.error.details);
		} 
		
		/**<b>保存完成后调用</b>**/
		public var saveFunc:Function;
		
		/**<b>保存中奖号码数据</b>**/
		public var saveData:Object;
		
		/**<b>保存期数</b>**/
		private var savePeriod:int
		/**
		 * 保存数据到 中奖号码(Data表) 中 
		 * @param period 期数
		 * @param data 红蓝色球数据
		 * @param date 时间
		 * @param stime 开奖时间
		 */		
		public function save( period:int , data:String , date:String ,stime:String=""):void 
		{ 
			saveData = new Object;
			saveData.period = period;
			saveData.data   = data;
			saveData.date   = date;
			saveData.stime  = stime;
			
			savePeriod = period;
			insertStmt = new SQLStatement(); 
			insertStmt.sqlConnection = conn; 
			insertStmt.text = insertSQL; 
			insertStmt.parameters[":period"] = period; 
			insertStmt.parameters[":data"] = data; 
			insertStmt.parameters[":date"] = date; 
			insertStmt.parameters[":stime"] = stime; //开奖日期
			insertStmt.addEventListener(SQLEvent.RESULT, insertResult); 
			insertStmt.addEventListener(SQLErrorEvent.ERROR, insertErrorHandler); 
			insertStmt.execute(); 
		} 		
		private function insertResult(event:SQLEvent):void
		{ 
			insertStmt.removeEventListener(SQLEvent.RESULT, insertResult); 
			trace("Insert completed 写入数据到 Data表成功");
			DataGlobal.Instance.pushDisplayInfo = "Insert completed 写入数据到 Data表成功"; 			
									
			var blue:int = int(String(saveData.data).split('-')[1]);
			var red:Array = String(String(saveData.data).split('-')[0]).split(',');
			ConfigGlobal.Instance.blues.unshift( blue );
			ConfigGlobal.Instance.reds.unshift( red );
			DataGlobal.Instance.theLastPhase = saveData.period;			
			DataGlobal.Instance.period = int(saveData.period);	
			
			//2012.5.20
			ConfigGlobal.Instance.datas.unshift( saveData );
			
			UIGlobal.Instance.queryUI.init();
			UIGlobal.Instance.queryUI.dis_clickHandler();
//			selectUsers(); 
//			if(saveFunc != null)
//				saveFunc.apply();
		} 		
		private function insertErrorHandler(event:SQLErrorEvent):void 
		{ 
			insertStmt.removeEventListener(SQLErrorEvent.ERROR, insertErrorHandler); 
			trace("Insert completed 写入数据到 Data表失败" +　event.error.message + "___" + event.error.details);
			DataGlobal.Instance.pushDisplayInfo = "Error message: " + event.error.message; 
			DataGlobal.Instance.pushDisplayInfo = "Details: " + event.error.details; 
		} 
		 
		/**
		 * 保存购买号码数据到Self表中 
		 * @param obj
		 * 
		 */		
		public function saveSelf( data:Object ):void
		{
			if(data == null)
			{
				trace("保存数据到Self失败,数据不能为空");
				return;
			}
			insertStmt = new SQLStatement(); 
			insertStmt.sqlConnection = conn; 
			insertStmt.text = insertSelfSQL; 
			for(var str:String in data ) //插入数据到对应表中
			{
				insertStmt.parameters[":"+str] = data[str];
			}
			insertStmt.addEventListener(SQLEvent.RESULT, insertSelfResult); 
			insertStmt.addEventListener(SQLErrorEvent.ERROR, selfErrorHandler); 
			insertStmt.execute(); 
		}	
		
		private function insertSelfResult(event:SQLEvent):void
		{ 
			trace("Insert completed 写入数据到Self表中成功");
			DataGlobal.Instance.pushDisplayInfo = "Insert completed 写入数据到Self表成功"; 
			
			//QueryManager.Insance.connectSQLite("query");//链接并打开数据库
			//UIGlobal.Instance.app.addEventListener(MySQLEvent.CONNECT_COMPLETE,connect_completeHandler); //2012.5.20
		}  
		public function connect_completeHandler(event:MySQLEvent):void
		{
			UIGlobal.Instance.app.removeEventListener(MySQLEvent.CONNECT_COMPLETE,connect_completeHandler);
			ConfigGlobal.Instance.datas = [];
			ConfigGlobal.Instance.reds = [];
			ConfigGlobal.Instance.blues = [];
			//链接数据库完成后执行
			QueryManager.Insance.selectFunc = function selectAll():void
			{
				var results:Array = QueryManager.Insance.result.data;
				if(results == null) return;
				results = results.sortOn( ['period'], Array.NUMERIC | Array.DESCENDING);
				var i:int=0;
				for(i=0;i < results.length ; i++)
				{
					var obj:Object = results[i];
					ConfigGlobal.Instance.datas.push( obj );							
					var str:String = String( obj.data );
					var arr:Array =  (str.split('-')[0] as String).split(',').sort(Array.NUMERIC) as Array;
					//trace("___________arr: " + arr.toString()+ " blue: " + int(str.split('-')[1]) );
					var blue:String = str.split('-')[1];
					ConfigGlobal.Instance.reds.push( arr ); //格式[1,2,3,4,5,6]
					ConfigGlobal.Instance.blues.push( int(blue) );
					
					if(i == 0)
					{
						UIGlobal.Instance.mainUI.setPeriodInfo(obj.period , arr.toString() , blue);
						DataGlobal.Instance.theLastPhase = obj.period;
						
						DataGlobal.Instance.period = int(obj.period);
					}
				}	
				UIGlobal.Instance.mainUI.init();
			}
				
			//查询数据库中所有中奖 号码 Data表
			selectUsers(); 				
		}
		
		private function selfErrorHandler(event:SQLErrorEvent):void 
		{ 
			trace("写入数据到Self表中失败。 Error message: " + event.error.message + "   " + event.error.details);
			DataGlobal.Instance.pushDisplayInfo = "Error message: " + event.error.message; 
			DataGlobal.Instance.pushDisplayInfo = "Details: " + event.error.details; 
		} 
		
		/**<b>获取获奖数据</b>
		 * @param arr 购买的号码，去比对当期中奖号码
		 * @param period 中奖号码期数
		 * @param Array 返回购买中奖的数组
		 * **/
		public function getLotterys( arr:Array , period:int ):Array
		{
			var _arr:Array = []; //中奖号码
			
			if(arr == null) return [];
			var obj:Object; //当期中奖号码
			for each(obj in ConfigGlobal.Instance.datas)
			{
				if(obj.period == period)
				{
					break;
				}
			}
			
			if(obj != null)
			{
				var red:Array = String(obj.data.split("-")[0]).split(',');
				var blue:int = int(obj.data.split("-")[1]);
				for(var i:int=0;i < arr.length;i++)
				{
					var _obj:Object = arr[i];
					if(_obj != null)
					{
						var bRed:Array = String(_obj.data.split("-")[0]).split(',');
						var bBlue:int = int(_obj.data.split("-")[1]);	
						
						var gArr:Array = ArrayUtill.mergeArray( red , bRed , 0 ); //取交集
						
						var gRed:int  = gArr.length; //买中红色球个数
						var gBlue:int = blue ==  bBlue ? 1 : 0; //买中蓝色球个数
						
						trace("该组买中红色球: " + gRed + "个" + " 蓝色球: " +  gBlue );
						
						if(gRed <= 2 && gBlue == 1) //六等奖
						{
							_obj.level = 6;
							_obj.money = 5;
							_arr.push( _obj );
						}
						else if( (gRed == 3 && gBlue == 1) ||  ( gRed == 4 && gBlue == 0 )) //五等奖
						{
							_obj.level = 5;
							_obj.money = 10;
							_arr.push( _obj );
						}
						else if( (gRed == 5 && gBlue == 0) ||  ( gRed == 4 && gBlue == 1 )) //四等奖
						{
							_obj.level = 4;
							_obj.money = 200;
							_arr.push( _obj );
						}
						else if( gRed == 5 && gBlue == 1) //三等奖
						{
							_obj.level = 3;
							_obj.money = 3000;
							_arr.push( _obj );
						}
						else if( gRed == 6 && gBlue == 0 ) //二等奖
						{
							_obj.level = 2;
							_obj.money = 250000;
							_arr.push( _obj );
						}
						else if( gRed == 6 && gBlue == 1 ) //一等奖
						{
							_obj.level = 1;
							_obj.money = 5000000;
							_arr.push( _obj );
						}						
					}					
				}
			}
			
			return _arr;
		}
		
		private static var instance:QueryManager;
		public static function get Insance():QueryManager
		{
			if(instance == null)
			{
				instance = new QueryManager;
			}
			return instance;
		}
	}
}