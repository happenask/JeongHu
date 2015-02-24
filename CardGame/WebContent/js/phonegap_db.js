var $PhoneGapDB = {
		
		
		selectOption: function(){
			var db = window.openDatabase("BrainTrainer", "1.0", "BrainTrainer", 100000);
			db.transaction(setTableDB, errorDB, successDB);
			
			function setTableDB(tx) 
		    {
				tx.executeSql("CREATE TABLE IF NOT EXISTS brainOption (b_level varchar, b_operator varchar, b_sound varchar)");
			}
			function successDB() 
			{
				var db = window.openDatabase("BrainTrainer", "1.0", "BrainTrainer", 100000);
				db.transaction(queryDB, errorDB);
			}
			function queryDB(tx) 
			{
				tx.executeSql('SELECT * FROM brainOption', [], renderEntry, errorDB);
			}
			function renderEntry(tx,results)
			{
				if(results.rows.length==0)
				{
					tx.executeSql("INSERT INTO brainOption (b_level, b_operator, b_sound) VALUES ('beginner', '+', 'on')");
					
					$PhoneGapDB.gameLevel  =  'beginner';
					$PhoneGapDB.operator   =  '+';
					$PhoneGapDB.sound      =  'on';
				}
				else
				{
					tx.executeSql('SELECT * FROM brainOption', [], querySuccess, errorDB);
				}
			}
			
			function querySuccess(tx, results) 
			{
				$PhoneGapDB.gameLevel  =  results.rows.item(0).b_level;
				$PhoneGapDB.operator   =  results.rows.item(0).b_operator;
				$PhoneGapDB.sound      =  results.rows.item(0).b_sound;
			}
			
			function errorDB(err) 
			{
				alert("Error processing SQL: "+err.code);
				
			}
			
		}
       ,
		
		updateRecord: function(gameId,record){
			var db = window.openDatabase("BrainTrainer", "1.0", "BrainTrainer", 100000);
			db.transaction(setRecordTableDB, errorDB, successRecordDB);
			
				
				function setRecordTableDB(tx) 
			    {
					tx.executeSql("DROP TABLE IF EXISTS brainRecord");
					tx.executeSql("CREATE TABLE IF NOT EXISTS brainGameRecord (b_gameId varchar , b_record varchar)");
				}
				function successRecordDB() 
				{
					var db = window.openDatabase("BrainTrainer", "1.0", "BrainTrainer", 100000);
					db.transaction(queryRecordDB, errorDB);
				}
				function queryRecordDB(tx) 
				{
					tx.executeSql("SELECT * FROM brainGameRecord where b_gameId = '"+gameId+"'", [], renderEntryRecord, errorDB);
				}
				function renderEntryRecord(tx,results)
				{
					if(results.rows.length==0)
					{
						tx.executeSql("INSERT INTO brainGameRecord (b_gameId, b_record) VALUES ('"+gameId+"','"+record+"')");
						
					}
					else
					{
						tx.executeSql("SELECT * FROM brainGameRecord where b_gameId = '"+gameId+"'", [], queryRecordSuccess, errorDB);
					}
				}
				
				function queryRecordSuccess(tx, results) 
				{
					var db_gameId =  results.rows.item(0).b_gameId;
					var db_record  =  results.rows.item(0).b_record;
					
					//$PhoneGapDB.gameRecord = db_record;
					if(record< db_record)
					{
						
						navigator.notification.alert("Best score is now updated.");
						tx.executeSql("UPDATE brainGameRecord SET b_record = '"+record+"' where b_gameId = '"+gameId+"'");	
						
					//	window.localStorage.setItem("record", record);
						
					}
					else
					{
					//	window.localStorage.setItem("record", db_record);
					}
				}
				
				function errorDB(err) 
				{
					alert("Error processing SQL: "+err.code);
					
				}
		}
};

	
	
	