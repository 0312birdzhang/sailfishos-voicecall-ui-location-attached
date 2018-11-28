import os
import urllib.request
import sqlite3
import pyotherside
import codecs
import re

HOME = os.path.expanduser("~")
XDG_DOWNLOAD_DIR = os.environ.get("XDG_DOWNLOAD_DIR", os.path.join(HOME, "Downloads"))
XDG_DATA_HOME = os.environ.get("XDG_DATA_HOME", os.path.join(HOME, ".local", "share"))
dbPath = os.path.join(XDG_DATA_HOME, "JollaMobile", "voicecall-ui", "QML", "OfflineStorage", "Databases","")

__domain__ = "https://phone.birdzhang.xyz"

def getVersion():
    url = "%s/getversion" % (__domain__, )
    return get(url)

def updateDB(version):
    downname = "%s/%s.data" % (XDG_DOWNLOAD_DIR, version)
    downurl = "%s/%s.data" % (__domain__, version)
    if download(downname, downurl):
        updateSql(downname, getDbname())
    else:
        pyotherside.send("updated",False)    
        return
    pyotherside.send("updated",True)


def get(url):
    headers = {
        "User-Agent": "Sailfish Phone location",
        'Host': 'phone.birdzhang.xyz'
    }
    req = urllib.request.Request(url, headers=headers)
    try:
        response = urllib.request.urlopen(req, timeout=30)
        version = response.read()
        return int(version)
    except Exception as e:
        #my daughter's birthday
        return 20180131

def download(downname,downurl):
    # print(downname,downurl)
    try:
        urllib.request.urlretrieve(downurl,downname)
    except urllib.error.HTTPError as e:
        return False
    except urllib.error.ContentTooShortError as e:
        return False
    return True

def getDbname():
    import hashlib
    h = hashlib.md5()
    h.update("phone_location".encode(encoding='utf-8', errors='strict'))
    dbname=h.hexdigest()
    return "%s%s.sqlite" % (dbPath, dbname)

def updateSql(newdb, olddb):
    # print(olddb)
    conn = sqlite3.connect(olddb)
    c = conn.cursor()
    with codecs.open(newdb, 'r+', encoding='utf-8') as f:
        for i in f.readlines():
            row = i.split(",")
            c.execute("INSERT OR REPLACE INTO phone_location values (?,?);", (row[0], row[1]))
    conn.commit()
    conn.close()



def getaddress(num):
    try:
        conn = sqlite3.connect(getDbname())
        cur = conn.cursor()
        t = (num,)
        cur.execute('SELECT area FROM phone_location WHERE _id=?', t)
        return cur.fetchone()[0]
    except Exception as e:
        # print(e)
        return ""
    finally:
        conn.close()

def getLocation(num):
    result=""
    num="".join(num.split("+86"))
    num="".join(num.split("+"))
    num="".join(num.split("("))
    num="".join(num.split(")"))
    if re.search("^1[345789]\d{9}$",num):
        result = getaddress(num[0:7])
    else:
        num_length = len(num)
        if num_length == 4:
            result ="模拟器"
        elif num_length == 7:
            result = "本地号码"
        elif num_length == 8:
            result = "本地号码"
        elif num_length == 10:#3位区号，7位号码
            result = getaddress(num[1:4])
        elif num_length == 11:#3位区号，8位号码  或4位区号，7位号码
            result = getaddress(num[1:4])
            if len(result) == 0:
                result = getaddress(num[0:4])
            if len(result) == 0:
                result = getaddress(num[1:2])
            if len(result) == 0:
                result = getaddress(num[0:3])
        elif  num_length == 12:
            result = getaddress(num[0:4])
        else:
            result = getaddress(num)
    if len(result) == 0:
        result = "未知"
    return result

if __name__ == '__main__':
    getLocation("18565089262")