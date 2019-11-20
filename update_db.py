#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
Created on 2019年8月12日

@author: admin
'''

import sqlite3
import sys
# import codecs
from phone import Phone

patch_sqlfile = "C:\\Users\\admin\\git\\sailfishos-voicecall-ui-location-attached\\data\\6fbb8aa57ce8aa1ef7899348e99fac00.sqlite"
phonedata_file = "C:\\Users\\admin\\git\\sailfishos-voicecall-ui-location-attached\\phone.dat"

patch_map = {}
conn = sqlite3.connect(patch_sqlfile)
c = conn.cursor()
# for row in c.execute('SELECT * FROM phone_location'):
#     patch_map[row[0]] = row[1]

not_contain_map = {}

phone = Phone(dat_file = phonedata_file)
print("get all phone")
all_phones = phone.test()
print("done get all")
for i in all_phones:
    row = i.split("|")
    #if int(row[0]) not in patch_map:
    k = int(row[0])
    v = row[1]
    if len(str(k)) == 7 and str(k).startswith("1"):
        c.execute("INSERT OR REPLACE INTO phone_location values ('%s','%s')"  % (k,str(v)))
conn.commit()
conn.close()
