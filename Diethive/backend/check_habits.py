
import pymysql

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
        cursor.execute("SELECT * FROM user_goals ORDER BY created_at DESC LIMIT 5")
        goals = cursor.fetchall()
        print("--- LATEST USER GOALS ---")
        for g in goals:
            print(g)
        
        cursor.execute("SELECT * FROM habits")
        habits = cursor.fetchall()
        print("\n--- ALL HABITS ---")
        for h in habits:
            print(f"ID: {h['id']}, Title: {h['title']}")

finally:
    conn.close()
