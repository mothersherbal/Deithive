import pymysql

def get_db_connection():
    try:
        conn = pymysql.connect(
            host="127.0.0.1",
            user="root",
            password="",
            database="deithive",
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
        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()
        print("Tables in deithive:", tables)
    conn.close()
else:
    print("Could not connect to database.")
