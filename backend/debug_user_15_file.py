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

with open("debug_results.txt", "w") as f:
    conn = get_db_connection()
    if conn:
        with conn.cursor() as cursor:
            f.write("--- USER 15 INFO ---\n")
            cursor.execute("SELECT * FROM register WHERE id=15")
            user = cursor.fetchone()
            f.write(str(user) + "\n")

            f.write("\n--- USER 15 GOALS ---\n")
            cursor.execute("SELECT * FROM user_goals WHERE user_id=15")
            goals = cursor.fetchall()
            for g in goals:
                f.write(f"Goal ID: {g['id']}, Habit ID: {g['habit_id']}, Status: {g['status']}, Start Date: {g['start_date']}\n")

            f.write("\n--- USER 15 GOAL TRACKING ---\n")
            cursor.execute("""
                SELECT gdt.* 
                FROM goal_daily_tracking gdt
                JOIN user_goals ug ON ug.id = gdt.goal_id
                WHERE ug.user_id = 15
            """)
            tracking = cursor.fetchall()
            f.write("Tracking rows count: " + str(len(tracking)) + "\n")
            for t in tracking:
                f.write(str(t) + "\n")

            f.write("\n--- USER 15 PROGRESS ---\n")
            cursor.execute("SELECT * FROM user_progress WHERE user_id=15")
            progress = cursor.fetchone()
            f.write(str(progress) + "\n")
        conn.close()
    else:
        f.write("Could not connect to database.")
