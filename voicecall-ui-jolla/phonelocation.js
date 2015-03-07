.import QtQuick.LocalStorage 2.0 as SQL

function getDatabase() {
    return SQL.LocalStorage.openDatabaseSync("phone_location", "1.0", "phonelocation", 10000);

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
        var phoneid="10086";
        num = num.replace(/\+/g,"");
        if(num.length>7){
            phoneid = num.substr(0,7);
        }
        var db = getDatabase();
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT area FROM phone_location where _id = ?;',[phoneid]);
          if (rs.rows.length > 0) {
                location.text=rs.rows.item(0).area
            } else {
                location.text="Unkown Location";
                }
        });
    }
    catch(e){
        //return "Unkown Location";
        location.text="Unkown";
    }
}