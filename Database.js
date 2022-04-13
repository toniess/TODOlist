/*
 *  toniess 2022
 *
 *
 *  A library to work with todolist's database consists of following functions:
 *  1. init()
 *  2. getHandle()
 *  3. read()
 *  4. insert()
 *  5. update()
 *  6. erase()
*/

function init() {
    var db = LocalStorage.openDatabaseSync('listedTasks', '1.0', 'TODOLIST', 1000000)
    try {
        db.transaction(function (tx) {
            var sql = 'CREATE TABLE IF NOT EXISTS notes(id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, status BIT, done TEXT)';
            tx.executeSql(sql)
        })
    } catch (err) {
        console.log("Error creating table in database: " + err)
    };

}

function getHandle() {
    try {
        var db = LocalStorage.openDatabaseSync('listedTasks', '1.0', 'TODOLIST', 1000000)
    } catch(err) {
        console.log("Error connecting database: " + err)
    }
    return db
}

function read() {
    var db = getHandle()
    var result
    db.transaction(function (tx) {
        result = tx.executeSql('SELECT * FROM notes')
    })
    return result.rows
}

function insert(task, status, done) {
    var db = getHandle()
    var rowid = 0;
    db.transaction(function (tx) {
        tx.executeSql('INSERT INTO notes ("task", "status", "done") VALUES(?, ?, ?)',
                      [task, status, done])
        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })
    console.log("вставлено  в ", rowid)
    return rowid;
}

function update(id, task, status, done) {
    var db = getHandle()
    var rowid = 0;
    db.transaction(function (tx) {
        tx.executeSql('UPDATE notes SET task = ?, status = ?, done = ? WHERE id = ?',
                      [task, status, done, id])
        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })
    return rowid;
}

function erase(id) {
    var db = getHandle()
    db.transaction(function (tx) {
        tx.executeSql('DELETE FROM notes WHERE id = ?', [id]);
    })
}

function getToday(done) {
    var db = getHandle()
    var result
    db.transaction(function (tx) {
        result = tx.executeSql('SELECT * FROM notes WHERE done = ?', [done])
    })
    return result.rows
}

function getDone() {
    var db = getHandle()
    var result
    db.transaction(function (tx) {
        result = tx.executeSql('SELECT * FROM notes WHERE status = ?', [1])
    })
    return result.rows
}

function getDead(done) {
    var db = getHandle()
    var result
    db.transaction(function (tx) {
        result = tx.executeSql('SELECT * FROM notes WHERE status = ? AND done < ?', [0, done])
    })
    return result.rows
}

function getTodayProgress(done) {
    var db = getHandle()
    var result1
    var result2
    db.transaction(function (tx) {
        result1 = tx.executeSql('SELECT * FROM notes WHERE status = ? AND done = ?', [1, done])
    })
    db.transaction(function (tx) {
        result2 = tx.executeSql('SELECT * FROM notes WHERE done = ?', [done])
    })
    return ~~(result1.rows.length/result2.rows.length*100)
}

function isTodayBusy(done) {
    var db = getHandle()
    var result
    db.transaction(function (tx) {
        result = tx.executeSql('SELECT * FROM notes WHERE done = ?', [done])
    })
    if(result.rows.length > 0) {
        var item = result.rows.item(0)
        console.log(item.id, item.task, item.status, item.done)
    }
    return result.rows.length
}
