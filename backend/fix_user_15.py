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

# Import the logic or just copy it for the one-off fix
DAILY_POINTS = 10

def _recalculate_progress(conn, user_id):
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT COUNT(DISTINCT d) AS active_days FROM (
                SELECT l.log_date AS d
                FROM habit_daily_log l
                JOIN user_selected_habits s
                  ON s.user_id = l.user_id
                 AND s.habit_id = l.habit_id
                 AND s.is_active = 1
                WHERE l.user_id=%s
                
                UNION
                
                SELECT gdt.completion_date AS d
                FROM goal_daily_tracking gdt
                JOIN user_goals ug ON ug.id = gdt.goal_id
                WHERE ug.user_id=%s AND gdt.completed=1 AND gdt.completion_date IS NOT NULL
            ) AS combined_activity
        """, (user_id, user_id))
        row = cursor.fetchone()
        active_days = int(row["active_days"] or 0)

        cursor.execute("""
            SELECT COALESCE(SUM(t.reward_points),0) AS trophy_points
            FROM user_trophies ut
            JOIN trophies t ON t.id = ut.trophy_id
            WHERE ut.user_id=%s AND ut.is_unlocked=1
        """, (user_id,))
        trophy_points = int(cursor.fetchone()["trophy_points"] or 0)

        total_points = (active_days * DAILY_POINTS) + trophy_points

        cursor.execute(
            "INSERT INTO user_progress (user_id, total_active_days, total_points) VALUES (%s, %s, %s) "
            "ON DUPLICATE KEY UPDATE total_active_days=%s, total_points=%s",
            (user_id, active_days, total_points, active_days, total_points)
        )
    conn.commit()
    print(f"Recalculated for user {user_id}: Active Days={active_days}, Points={total_points}")

conn = get_db_connection()
if conn:
    _recalculate_progress(conn, 15)
    conn.close()
else:
    print("Could not connect to database.")
