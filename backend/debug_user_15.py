import pymysql

def get_db_connection():
    try:
        conn = pymysql.connect(
            host="127.0.0.1",
            user="root",
            password="",
            database="diethive",
            port=3306,
            cursorclass=pymysql.cursors.DictCursor
        )
        return conn
    except Exception as e:
        print("❌ Error while connecting to MySQL:", e)
        return None

conn = get_db_connection()
if conn:
    with conn.cursor() as cursor:
        print("--- USER 15 INFO ---")
        cursor.execute("SELECT * FROM register WHERE id=15")
        user = cursor.fetchone()
        print("User:", user)

        print("\n--- USER 15 GOALS ---")
        cursor.execute("SELECT * FROM user_goals WHERE user_id=15")
        goals = cursor.fetchall()
        for g in goals:
            print(f"Goal ID: {g['id']}, Habit ID: {g['habit_id']}, Status: {g['status']}")

        print("\n--- USER 15 GOAL TRACKING ---")
        cursor.execute("""
            SELECT gdt.* 
            FROM goal_daily_tracking gdt
            JOIN user_goals ug ON ug.id = gdt.goal_id
            WHERE ug.user_id = 15
        """)
        tracking = cursor.fetchall()
        print("Tracking rows count:", len(tracking))
        for t in tracking:
            print(t)

        print("\n--- USER 15 PROGRESS ---")
        cursor.execute("SELECT * FROM user_progress WHERE user_id=15")
        progress = cursor.fetchone()
        print("Progress:", progress)
    conn.close()
else:
    print("Could not connect to database.")
