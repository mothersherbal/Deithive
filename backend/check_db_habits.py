
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
        cursor.execute("SELECT id, title FROM habits")
        habits = cursor.fetchall()
        print("--- HABITS TABLE ---")
        for h in habits:
            print(f"{h['id']}: {h['title']}")
        
        cursor.execute("SELECT id, user_id, habit_id, status, created_at FROM user_goals ORDER BY created_at DESC LIMIT 10")
        goals = cursor.fetchall()
        print("\n--- LATEST USER GOALS ---")
        for g in goals:
            cursor.execute("SELECT title FROM habits WHERE id=%s", (g['habit_id'],))
            h = cursor.fetchone()
            title = h['title'] if h else 'UNKNOWN'
            print(f"GoalID: {g['id']}, UserID: {g['user_id']}, Habit: {title}, Status: {g['status']}, Created: {g['created_at']}")

finally:
    conn.close()
