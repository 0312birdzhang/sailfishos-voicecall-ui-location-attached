#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
Created on 2015年10月13日

@author: 0312birdzhang
'''
import os,sys
import sqlite3
import re

def getaddress(num):
    print("处理后的号码",num)
    try:
        conn = sqlite3.connect("../data/6fbb8aa57ce8aa1ef7899348e99fac00.sqlite")
        cur = conn.cursor()
        t = (num,)
        cur.execute('SELECT area FROM phone_location WHERE _id=?', t)
        return cur.fetchone()[0]
    except Exception,e:
        print(e)
        return ''
    conn.close()

def getLocation(num):
    result=""
    num="".join(num.split("+86"))
    num="".join(num.split("("))
    num="".join(num.split(")"))
    print("去掉特殊符号的号码：",num)
    if re.search("^1[34578]\d{9}$",num):
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
            if result == "":
                result = getaddress(num[0:4])
	    if result == "":
                result = getaddress(num[0:4])
            if result == "":
                result = getaddress(num[1:2])
	    if result == "":
                result = getaddress(num[0:3])
        elif num_length == 12:
            result = getaddress(num[0:4])
        else:
            result = getaddress(num)
    if len(result) == 0:
        result = "未知"
    print(result)
    return result

if __name__ == '__main__':
    #getLocation("05538970123")
    getLocation("10010")
    

