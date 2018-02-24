# sailfishos-voicecall-ui-location-attached

Add Chinese Location to Voicecall UI.

If you want to show your country phone location ,replace file:

`/home/nemo/.local/share/JollaMobile/voicecall-ui/QML/OfflineStorage/Databases/6fbb8aa57ce8aa1ef7899348e99fac00.sqlite`

`6fbb8aa57ce8aa1ef7899348e99fac00` is the `phone_location`'s md5, if your database is not `phone_location`, you must change it.

Table structure : `CREATE TABLE IF NOT EXISTS phone_location(_id integer,aera TEXT);`

And modify voicecall-ui-jolla/phonelocation.js 

Enjoy :)
