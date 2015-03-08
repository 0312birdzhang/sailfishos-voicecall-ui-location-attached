.pragma library
.import QtQuick.LocalStorage 2.0 as SQL
var regin;
function getDatabase() {
    return SQL.LocalStorage.openDatabaseSync("phone_location", "1.0", "phonelocation", 1024*1024*10);

}
function initialize() {
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS phone_location(_id integer,aera TEXT);');

                });
}

function getLocation(num) {
    try{
        initialize();
        var phoneid
        num = num.replace(/\+/g,"");
        if(num.length>7){
            phoneid = num.substr(0,7);
        }else{
        	phoneid=num;
        }
        var db = getDatabase();
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT area FROM phone_location where _id = ?;',[phoneid]);
          if (rs.rows.length > 0) {
                regin=rs.rows.item(0).area
            } else {
                regin="Unkown Location";
                }
        });
    }
    catch(e){
        regin="Unkown";
    }
        return regin;
}