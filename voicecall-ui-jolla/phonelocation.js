.pragma library
.import QtQuick.LocalStorage 2.0 as SQL
Qt.include("countries.js")

var region;

function getDatabase() {
    return SQL.LocalStorage.openDatabaseSync("phone_location", "1.0", "phonelocation", 1024*1024*7);
}

function getCountry(codenum){
    codenum = codenum.replace(/\+/g,"");
    for (var i=0; i<countries.length; i++) {
        if(countries[i].code == codenum ){
            return countries[i].country;
        }
    }
    return "国外号码";
}

function getLocation(num) {
    var result;
    if( (num.indexOf("\+") > -1 && num.indexOf("\+86") < 0 ) ||
        num.indexOf("\-") > -1
    ){
        var codenum = num.split(" ")[0] // ???
        result = getCountry(codenum)
        return result;
    }
    num = num.replace(/\+86/g,"");
    num = num.replace(/\+/g,"");
    num = num.replace(/\-/g,"");
    num = num.replace(/\(/g,"");
    num = num.replace(/\)/g,"");
    var reg = /^1[345789]\d{9}$/;
    if(num.match(reg)){//phonenum
        result = getAddress(num.substr(0,7));
    }else{
        var num_length = num.length;
        switch(num_length){
        case 4:
            result ="模拟器";
            break;
        case 7:
            result = "本地号码";
            break;
        case 8:
            result = "本地号码";
            break;
        case 10://3位区号，7位号码
            result = getAddress(num.substr(1,2));
            if(result === ""){
                result = getAddress(num.substr(0,3));
            }
            break;
        case 11://3位区号，8位号码  或4位区号，7位号码
            result = getAddress(num.substr(1,4));
            if(result === ""){
                result = getAddress(num.substr(0,4));
            }
	        if(result === ""){
                result = getAddress(num.substr(1,2));
            }
            if(result === ""){
                result = getAddress(num.substr(0,3));
            }
            break;
        case 12:
            result = getAddress(num.substr(0,4));
            break;
        default:
            result = getAddress(num);
            break;
        }
    }
    if(result.length === 0){
        result = "未知";
    }
    region = result;
    return region;
}

function initialize() {
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS phone_location(_id integer,area TEXT);');

                });
}


function getAddress(num) {

    var address;
    try{
        initialize();
        var db = getDatabase();
        db.transaction(function(tx) {
           var rs = tx.executeSql('SELECT area FROM phone_location where _id = ?;',[num]);
          if (rs.rows.length > 0) {
                address = rs.rows.item(0).area
            } else {
                address = "";
                }
        });
    }
    catch(e){
        address="";
    }
        return address;
}
