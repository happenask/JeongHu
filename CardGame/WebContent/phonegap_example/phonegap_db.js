	function deviceReady() {

		var db = window.openDatabase("Test", "1.0", "Test", 200000);
		db.transaction(populateDB, errorDB, successDB);
		
	}
	
	function populateDB(tx) 
    {
//		tx.executeSql("SELECT brain FROM sqlite_master WHERE type='table'", [], function (tx, result) {
//            if (result.rows.length == 1) {
//                //here are no your tables currently
//            } else {
//
//            }
//        });
//		tx.executeSql("DROP TABLE IF EXISTS test1");
		tx.executeSql("CREATE TABLE IF NOT EXISTS brain_option (id unique, name)");
		tx.executeSql("INSERT INTO test1 (id, name) VALUES (1, 'Tony')");
		tx.executeSql("INSERT INTO test1 (id, name) VALUES (1, 'Tony')");
		tx.executeSql("INSERT INTO test1 (id, name) VALUES (1, 'Tony')");
	}
	function queryDB(tx) 
	{
		tx.executeSql('SELECT * FROM test1', [], querySuccess, errorCB);
	}
	
	// Query the success callback
	//
	function querySuccess(tx, results) 
	{
	//first get the number of rows in the result set
		var len = results.rows.length;
		var status = document.getElementById("status");
		var string = "Rows: " +len+"<br/>";
		for (var i=0;i<len;i++)
		{
			string += results.rows.item(i).name + "<br/>";
		}
		status.innerHTML = string;
	}
	
	function errorDB(err) 
	{
		alert("Error processing SQL: "+err.code);
		
	}
	function successDB() 
	{
		var db = window.openDatabase("Test", "1.0", "Test", 200000);
		db.transaction(queryDB, errorCB);
	}