# Potential plug-in for hospital form | Authentication | 

import sqlite3
from tkinter import *

def create_users():
    conn = sqlite3.connect('users_table.db')
    cursor = conn.cursor()

    sql_users_table = '''CREATE TABLE IF NOT EXISTS Users (
                            username TEXT PRIMARY KEY,
                            password TEXT,
                            access_level TEXT
                        )'''
    
    cursor.execute(sql_users_table)
    conn.close()



def first_user(username, password):
    conn = sqlite3.connect('users_table.db')
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM Users")
    users = cursor.fetchall()

    if not users:

        sql_users = '''INSERT INTO Users (username, password, access_level) VALUES (?, ?, ?)'''
        cursor.execute(sql_users,
                       (username, password, "admin"))
        
        conn.commit()
        conn.close()

        return True
    
    else:    
        conn.close()
        return False
    

def register_user(username, password):
    conn = sqlite3.connect('users_table.db')
    cursor = conn.cursor()   

    sql_command = '''SELECT * FROM Users WHERE access_level="admin"'''
    cursor.execute(sql_command)

    admin = cursor.fetchone()

    if admin:

        sql_insert = '''INSERT INTO Users (username, password, access_level) VALUES (?, ?, ?)'''

        cursor.execute(sql_insert,
                       (username, password, "staff"))

        conn.commit()
        conn.close()
        return True
    
    else:
        conn.close()
        return False
    


def authenticate_user(username, password):
    conn = sqlite3.connect('hospital_database.db')
    cursor = conn.cursor()

    sql_select_user = '''SELECT * FROM Users WHERE username=? AND password=?'''
    
    cursor.execute(sql_select_user,
                   (username, password))
    
    user = cursor.fetchone()

    conn.close()

    if user:
        return user[3]
    
    else:
        return None