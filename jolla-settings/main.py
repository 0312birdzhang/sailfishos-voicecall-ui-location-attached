import os
import urllib
import sqlite3
import pyotherside
import codecs

HOME = os.path.expanduser("~")
XDG_DOWNLOAD_DIR = os.environ.get("XDG_DOWNLOAD_DIR", HOME)
XDG_DATA_HOME = os.environ.get("XDG_DATA_HOME", os.path.join(HOME, ".local", "share"))
dbPath = os.path.join(XDG_DATA_HOME, "JollaMobile", "voicecall-ui", "QML", "OfflineStorage", "Databases","")

__domain__ = "https://phone.birdzhang.xyz"

def getVersion():
    url = "%s/getversion" % (__domain__, )
    return get(url)

def updateDB(version):
    downname = "%s/%s.data" % (XDG_DOWNLOAD_DIR, version,)
    downurl = "%s/%s" % (__domain__, version)
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
    try:
        urllib.request.urlretrieve(downurl,downname)
    except urllib.error.HTTPError:
        return False
    except urllib.error.ContentTooShortError:
        return False
    return True

def getDbname():
    import hashlib
    h = hashlib.md5()
    h.update("phone_location".encode(encoding='utf-8', errors='strict'))
    dbname=h.hexdigest()
    return "%s%s.sqlite" % (dbPath, dbname)

def updateSql(newdb, olddb):
    conn = sqlite3.connect(olddb)
    c = conn.cursor()
    with codecs.open(newdb, 'r+', encoding='utf-8') as f:
        for i in f.readlines():
            row = i.split(",")
            c.execute("INSERT OR REPLACE INTO phone_location values ('%s','%s')"  % (row[0], row[1]))
    conn.commit()
    conn.close()

