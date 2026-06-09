
import pymysql
import json

def get_db_connection():
    return pymysql.connect(
        host="127.0.0.1",
        user="root",
        password="",
        database="diethive",
        port=3306,
        cursorclass=pymysql.cursors.DictCursor
    )

conn = get_db_connection()
try:
    with conn.cursor() as cursor:
        cursor.execute("SELECT id, title FROM habits")
        habits = cursor.fetchall()
        with open('habits_debug.json', 'w') as f:
            json.dump(habits, f, indent=4)
finally:
    conn.close()
