# app.py  ✅ FULL BACKEND (with Buddy VIEW-ONLY)
# -------------------------------------------------
# 1) Run this file:  python app.py
# 2) Create table in phpMyAdmin (SQL tab) using the SQL given below.
#
# ✅ REQUIRED NEW TABLE (run in phpMyAdmin -> diethive -> SQL):
# CREATE TABLE IF NOT EXISTS buddy_sessions (
#   id INT AUTO_INCREMENT PRIMARY KEY,
#   owner_user_id INT NOT NULL,
#   buddy_user_id INT NOT NULL,
#   buddy_token VARCHAR(64) NOT NULL,
#   created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
#   expires_at DATETIME NULL,
#   is_active TINYINT(1) DEFAULT 1,
#   UNIQUE KEY uniq_token (buddy_token),
#   INDEX idx_owner (owner_user_id),
#   INDEX idx_buddy (buddy_user_id)
# );

import re
import secrets
from flask import Flask, request, jsonify, render_template, session, send_from_directory, redirect # type: ignore
from werkzeug.security import generate_password_hash, check_password_hash # type: ignore
import pymysql # type: ignore
from datetime import datetime, timedelta, date
import random
from flask_mail import Mail, Message # type: ignore
from apscheduler.schedulers.background import BackgroundScheduler # type: ignore
import google.generativeai as genai # type: ignore

# ==========================================================
# ✅ APP INIT
# ==========================================================
app = Flask(__name__, static_folder='Web_application', static_url_path='')
app.secret_key = "supersecretkey"

# ==========================================================
# ✅ MAIL CONFIG
# ==========================================================
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = 'kousikssvv34@gmail.com'
app.config['MAIL_PASSWORD'] = 'eltpwfegfydgzkww'
mail = Mail(app)

# ==========================================================
# ✅ DATABASE CONNECTION (DB NAME: diethive)
# ==========================================================
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
        
        # Auto-create OTP columns if they don't exist
        try:
            with conn.cursor() as cursor:
                cursor.execute("SHOW COLUMNS FROM register LIKE 'otp'")
                if not cursor.fetchone():
                    cursor.execute("ALTER TABLE register ADD COLUMN otp VARCHAR(10) NULL")
                cursor.execute("SHOW COLUMNS FROM register LIKE 'otp_expiry'")
                if not cursor.fetchone():
                    cursor.execute("ALTER TABLE register ADD COLUMN otp_expiry DATETIME NULL")
            conn.commit()
        except:
            pass
            
        return conn
    except Exception as e:
        print("❌ Error while connecting to MySQL:", e)
        return None

# ==========================================================
# ✅ SAFE INT HELPER
# ==========================================================
def _to_int(v, default=None):
    try:
        return int(v)
    except:
        return default

# ==========================================================
# ✅ PASSWORD VALIDATOR
# ==========================================================
def validate_password(password):
    missing = []
    if len(password) < 6:
        missing.append("at least 6 characters")
    if not any(c.islower() for c in password):
        missing.append("one lowercase letter")
    if not any(c.isupper() for c in password):
        missing.append("one uppercase letter")
    if not any(c.isdigit() for c in password):
        missing.append("one numerical digit")
    if not re.search(r"[!@#$%^&*(),.?\":{}|<>]", password):
        missing.append("one special character")
    return missing

# ==========================================================
# ✅ BUDDY MODE HELPERS (VIEW ONLY)
# ==========================================================
def _get_token_from_anywhere():
    # Header is best
    token = request.headers.get("X-Buddy-Token")
    if token:
        return token.strip()

    # Query param
    token = (request.args.get("buddy_token") or "").strip()
    if token:
        return token

    # JSON body
    data = request.get_json(silent=True) or {}
    token = (data.get("buddy_token") or "").strip()
    return token

def _is_buddy_mode():
    return bool(_get_token_from_anywhere())

def _get_buddy_session(conn, owner_user_id, buddy_token):
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT id, owner_user_id, buddy_user_id, buddy_token
            FROM buddy_sessions
            WHERE owner_user_id=%s AND buddy_token=%s AND is_active=1
              AND (expires_at IS NULL OR expires_at > NOW())
            ORDER BY id DESC
            LIMIT 1
        """, (owner_user_id, buddy_token))
        return cursor.fetchone()

def _block_if_buddy_mode():
    if _is_buddy_mode():
        return jsonify({
            "status": "error",
            "message": "Buddy mode is VIEW ONLY. Action not allowed."
        }), 403
    return None

# ==========================================================
# ✅ BASIC TEST ROUTE
# ==========================================================
@app.route("/", methods=["GET"])
def health_check():
    return send_from_directory(app.static_folder, 'index.html')

# ==========================================================
# ✅ REGISTER
# ==========================================================
@app.route("/register", methods=["POST"])
def register():
    data = request.get_json(silent=True) or {}

    full_name = data.get("full_name")
    email = data.get("email")
    password = data.get("password")
    confirm_password = data.get("confirm_password")

    if not full_name or not email or not password or not confirm_password:
        return jsonify({"status": "error", "message": "All fields are required"}), 400

    full_name = full_name or ""
    if not re.match(r"^[A-Za-z\s]+$", full_name):
        return jsonify({"status": "error", "message": "Full name must contain only letters and spaces"}), 400

    email = email or ""
    email_pattern = r"^[\w\.-]+@[\w\.-]+\.\w+$"
    if not re.match(email_pattern, email):
        return jsonify({"status": "error", "message": "Invalid email format"}), 400

    missing_requirements = validate_password(password)
    if missing_requirements:
        return jsonify({"status": "error", "message": f"Password must contain: {', '.join(missing_requirements)}"}), 400

    if password != confirm_password:
        return jsonify({"status": "error", "message": "Passwords do not match"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT id FROM register WHERE email=%s", (email,))
            existing_user = cursor.fetchone()

            if existing_user:
                return jsonify({"status": "error", "message": "Mail already registered"}), 409

            hashed_password = generate_password_hash(password)

            cursor.execute(
                "INSERT INTO register (full_name, email, password) VALUES (%s, %s, %s)",
                (full_name, email, hashed_password)
            )
            conn.commit()

        return jsonify({"status": "success", "message": "User registered successfully"}), 201
    finally:
        conn.close()

# ==========================================================
# ✅ LOGIN
# ==========================================================
@app.route("/login", methods=["POST"])
def login():
    data = request.get_json(silent=True) or {}
    email = data.get("email")
    password = data.get("password")

    if not email or not password:
        return jsonify({"status": "error", "message": "Email and password are required"}), 400

    email = email or ""
    email_pattern = r"^[\w\.-]+@[\w\.-]+\.\w+$"
    if not re.match(email_pattern, email):
        return jsonify({"status": "error", "message": "Invalid email format"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM register WHERE email=%s", (email,))
            user = cursor.fetchone()

            if not user:
                return jsonify({"status": "error", "message": "Email is not registered. Please create an account."}), 404

            if not check_password_hash(user["password"], password):
                return jsonify({"status": "error", "message": "Incorrect password. Please try again."}), 401

            return jsonify({
                "status": "success",
                "message": "Login successful",
                "user": {
                    "id": user["id"],
                    "full_name": user["full_name"],
                    "email": user["email"]
                }
            }), 200
    finally:
        conn.close()

# ==========================================================
# ✅ FORGOT PASSWORD (SEND OTP)
# ==========================================================
@app.route("/forgot-password", methods=["POST"])
def forgot_password():
    data = request.get_json(silent=True) or {}
    email = (data.get("email") or "").strip()

    if not email:
        return jsonify({"status": "error", "message": "Email is required"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT id FROM register WHERE email=%s", (email,))
            user = cursor.fetchone()

            if not user:
                return jsonify({"status": "error", "message": "Email not registered"}), 404

            otp = str(random.randint(1000, 9999))

            cursor.execute(
                "UPDATE register SET otp=%s, otp_expiry=DATE_ADD(NOW(), INTERVAL 10 MINUTE) WHERE id=%s",
                (otp, user["id"])
            )
            conn.commit()

        try:
            import smtplib
            from email.message import EmailMessage
            msg = EmailMessage()
            msg.set_content(f"Your Reset Password OTP is: {otp}. It is valid for 10 minutes.")
            msg['Subject'] = "Password Reset OTP"
            msg['From'] = "kousikssvv34@gmail.com"
            msg['To'] = email

            server = smtplib.SMTP('smtp.gmail.com', 587)
            server.starttls()
            server.login("kousikssvv34@gmail.com", "eltpwfegfydgzkww")
            server.send_message(msg)
            server.quit()

            print(f"DEBUG: Generated OTP for {email} is {otp}")
            print(f"DEBUG: Email sent successfully to {email}")
        except Exception as e:
            print("Mail Error:", e)
            return jsonify({"status": "error", "message": f"Failed to send OTP: {str(e)}"}), 500

        return jsonify({"status": "success", "message": "OTP sent to registered email"}), 200
    finally:
        conn.close()

# ==========================================================
# ✅ VERIFY OTP
# ==========================================================
@app.route("/verify-otp", methods=["POST"])
def verify_otp():
    data = request.get_json(silent=True) or {}
    email = (data.get("email") or "").strip()
    otp = (data.get("otp") or "").strip()

    if not email:
        return jsonify({"status": "error", "message": "Email required"}), 400
    if not otp:
        return jsonify({"status": "error", "message": "OTP required"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT otp, (otp_expiry > NOW()) as is_valid FROM register WHERE email=%s", (email,))
            user = cursor.fetchone()

            if not user:
                return jsonify({"status": "error", "message": "User not found"}), 404

            db_otp = str(user.get("otp") or "").strip()
            if db_otp != otp:
                return jsonify({"status": "error", "message": "Invalid OTP"}), 400

            if not user.get("is_valid"):
                return jsonify({"status": "error", "message": "OTP expired"}), 400

        return jsonify({"status": "success", "message": "OTP verified. Ready to reset password."}), 200
    finally:
        conn.close()

# ==========================================================
# ✅ RESET PASSWORD
# ==========================================================
@app.route("/reset-password", methods=["POST"])
def reset_password():
    data = request.get_json(silent=True) or {}

    b = _block_if_buddy_mode()
    if b: return b

    email = (data.get("email") or "").strip()
    new_password = data.get("new_password")
    confirm_password = data.get("confirm_password")

    if not email or not new_password or not confirm_password:
        return jsonify({"status": "error", "message": "All fields are required"}), 400

    if new_password != confirm_password:
        return jsonify({"status": "error", "message": "Passwords do not match"}), 400

    missing_requirements = validate_password(new_password)
    if missing_requirements:
        return jsonify({"status": "error", "message": f"Password must contain: {', '.join(missing_requirements)}"}), 400

    hashed_password = generate_password_hash(new_password)

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "UPDATE register SET password=%s, otp=NULL, otp_expiry=NULL WHERE email=%s",
                (hashed_password, email)
            )
            conn.commit()

        return jsonify({"status": "success", "message": "Password reset successfully"}), 200
    finally:
        conn.close()

# ==========================================================
# ✅ DAILY TIP
# ==========================================================
@app.route("/daily-tip", methods=["GET"])
def daily_tip():
    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            today = datetime.now().date()

            cursor.execute("""
                SELECT t.tip_text
                FROM tip_history h
                JOIN tips t ON h.tip_id = t.id
                WHERE h.shown_date = %s
            """, (today,))
            today_tip = cursor.fetchone()

            if today_tip:
                return jsonify({"status": "success", "daily_tip": today_tip["tip_text"]}), 200

            cursor.execute("""
                SELECT id, tip_text FROM tips
                WHERE id NOT IN (SELECT tip_id FROM tip_history)
            """)
            remaining_tips = cursor.fetchall()

            if not remaining_tips:
                cursor.execute("DELETE FROM tip_history")
                conn.commit()
                cursor.execute("SELECT id, tip_text FROM tips")
                remaining_tips = cursor.fetchall()

            selected_tip = random.choice(remaining_tips)

            cursor.execute(
                "INSERT INTO tip_history (tip_id, shown_date) VALUES (%s, %s)",
                (selected_tip["id"], today)
            )
            conn.commit()

            return jsonify({"status": "success", "daily_tip": selected_tip["tip_text"]}), 200
    finally:
        conn.close()

# ==========================================================
# ✅ NOTIFICATION SETTINGS
# ==========================================================
@app.route("/notification-settings", methods=["GET"])
def get_notification_settings():
    user_id = _to_int(request.args.get("user_id"))
    email = (request.args.get("email") or "").strip()
    if not user_id and not email:
        return jsonify({"status": "error", "message": "user_id or email required"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            if user_id:
                cursor.execute("SELECT id FROM register WHERE id=%s", (user_id,))
            else:
                cursor.execute("SELECT id FROM register WHERE email=%s", (email,))
            u = cursor.fetchone()
            if not u:
                return jsonify({"status": "error", "message": "User not found"}), 404
            
            uid = u["id"]
            cursor.execute("SELECT * FROM notification_settings WHERE user_id=%s", (uid,))
            settings = cursor.fetchone()
            
            if not settings:
                # Default settings
                settings = {
                    "user_id": uid,
                    "daily_enabled": True,
                    "daily_time": "09:00 AM",
                    "monthly_enabled": True,
                    "monthly_day": "5",
                    "monthly_time": "10:00 AM"
                }
                
            # Convert boolean from tinyint
            if isinstance(settings, dict):
                settings.update({
                    "daily_enabled": bool(settings.get("daily_enabled", True)),
                    "monthly_enabled": bool(settings.get("monthly_enabled", True))
                })
            
            return jsonify({"status": "success", "settings": settings}), 200
    finally:
        conn.close()

@app.route("/notification-settings", methods=["POST"])
def update_notification_settings():
    data = request.get_json(silent=True) or {}
    
    b = _block_if_buddy_mode()
    if b: return b
    
    user_id = _to_int(data.get("user_id"))
    email = (data.get("email") or "").strip()
    
    if not user_id and not email:
        return jsonify({"status": "error", "message": "user_id or email required"}), 400

    daily_enabled = data.get("daily_enabled", True)
    daily_time = data.get("daily_time", "09:00 AM")
    monthly_enabled = data.get("monthly_enabled", True)
    monthly_day = str(data.get("monthly_day", "5"))
    monthly_time = data.get("monthly_time", "10:00 AM")

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            if user_id:
                cursor.execute("SELECT id FROM register WHERE id=%s", (user_id,))
            else:
                cursor.execute("SELECT id FROM register WHERE email=%s", (email,))
            u = cursor.fetchone()
            if not u:
                return jsonify({"status": "error", "message": "User not found"}), 404
            
            uid = u["id"]
            
            cursor.execute("""
                INSERT INTO notification_settings (user_id, daily_enabled, daily_time, monthly_enabled, monthly_day, monthly_time)
                VALUES (%s, %s, %s, %s, %s, %s)
                ON DUPLICATE KEY UPDATE 
                    daily_enabled = VALUES(daily_enabled),
                    daily_time = VALUES(daily_time),
                    monthly_enabled = VALUES(monthly_enabled),
                    monthly_day = VALUES(monthly_day),
                    monthly_time = VALUES(monthly_time)
            """, (uid, daily_enabled, daily_time, monthly_enabled, monthly_day, monthly_time))
            conn.commit()

        return jsonify({"status": "success", "message": "Notification settings updated"}), 200
    finally:
        conn.close()

# ==========================================================
# ✅ Habits list (DEFAULT + MY OWN)
# ==========================================================
@app.route("/habits", methods=["GET"])
def list_habits():
    email = (request.args.get("email") or "").strip()
    user_id_param = _to_int(request.args.get("user_id"))

    if not email and not user_id_param:
        return jsonify({"status": "error", "message": "email or user_id is required"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            if user_id_param:
                cursor.execute("SELECT id FROM register WHERE id=%s", (user_id_param,))
            else:
                cursor.execute("SELECT id FROM register WHERE email=%s", (email,))
            u = cursor.fetchone()

            if not u:
                return jsonify({"status": "error", "message": "User not found"}), 404
            user_id = u["id"]

            cursor.execute("""
                SELECT id, title, category, icon, created_by_user_id
                FROM habits
                WHERE is_active = 1 AND (created_by_user_id IS NULL OR created_by_user_id = %s)
                ORDER BY id ASC
            """, (user_id,))
            habits = cursor.fetchall()

        return jsonify({"status": "success", "habits": habits}), 200
    finally:
        conn.close()

# ==========================================================
# ✅ Habit Details
# ==========================================================
@app.route("/habits/<int:habit_id>", methods=["GET"])
def get_habit_details(habit_id):
    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT id, title, category, what_is_it, why_it_matters, icon, created_by_user_id
                FROM habits
                WHERE id=%s AND is_active=1
            """, (habit_id,))
            habit = cursor.fetchone()

        if not habit:
            return jsonify({"status": "error", "message": "Habit not found"}), 404

        return jsonify({"status": "success", "habit": habit}), 200
    finally:
        conn.close()

# ==========================================================
# ✅ Create own habit (BLOCKED in buddy mode)
# ==========================================================
@app.route("/habits/create-own", methods=["POST"])
def create_own_habit():
    data = request.get_json(silent=True) or {}

    b = _block_if_buddy_mode()
    if b: return b

    email = (data.get("email") or "").strip()
    user_id_param = _to_int(data.get("user_id"))
    title = (data.get("title") or "").strip()

    category = (data.get("category") or "").strip() or "Custom"
    what_is_it = (data.get("what_is_it") or "").strip() or title
    why_it_matters = (data.get("why_it_matters") or "").strip() or "User created habit"
    icon = (data.get("icon") or "").strip() or "⭐"

    if not email and not user_id_param:
        return jsonify({"status": "error", "message": "email or user_id is required"}), 400
    if not title:
        return jsonify({"status": "error", "message": "title is required"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            if user_id_param:
                cursor.execute("SELECT id FROM register WHERE id=%s", (user_id_param,))
            else:
                cursor.execute("SELECT id FROM register WHERE email=%s", (email,))
            u = cursor.fetchone()
            if not u:
                return jsonify({"status": "error", "message": "User not found"}), 404
            user_id = u["id"]

            cursor.execute("""
                INSERT INTO habits (title, category, what_is_it, why_it_matters, icon, created_by_user_id, is_active)
                VALUES (%s, %s, %s, %s, %s, %s, 1)
            """, (title, category, what_is_it, why_it_matters, icon, user_id))
            conn.commit()
            new_id = cursor.lastrowid

        return jsonify({"status": "success", "message": "Habit created", "habit_id": new_id}), 201
    finally:
        conn.close()

# ==========================================================
# ✅ Activate Quest (BLOCKED in buddy mode)
# ==========================================================
@app.route("/goals/activate", methods=["POST"])
def activate_quest():
    data = request.get_json(silent=True) or {}

    b = _block_if_buddy_mode()
    if b: return b

    email = (data.get("email") or "").strip()
    user_id_param = _to_int(data.get("user_id"))
    habit_id = _to_int(data.get("habit_id"))
    marks_per_day = _to_int(data.get("marks_per_day"))
    duration_weeks = _to_int(data.get("duration_weeks"))
    start_date_str = (data.get("start_date") or "").strip()
    end_date_str = (data.get("end_date") or "").strip()

    if not email and not user_id_param:
        return jsonify({"status": "error", "message": "email or user_id is required"}), 400
    if not habit_id or not marks_per_day:
        return jsonify({"status": "error", "message": "habit_id and marks_per_day are required"}), 400

    if marks_per_day not in (10, 20, 50, 100):
        return jsonify({"status": "error", "message": "marks_per_day must be 10, 20, 50, or 100"}), 400

    if start_date_str:
        try:
            start_date = datetime.strptime(start_date_str, "%Y-%m-%d").date()
        except:
            return jsonify({"status": "error", "message": "start_date must be YYYY-MM-DD"}), 400
    else:
        start_date = datetime.now().date()

    if duration_weeks:
        if duration_weeks < 1 or duration_weeks > 12:
            return jsonify({"status": "error", "message": "duration_weeks must be between 1 and 12"}), 400
        total_days = duration_weeks * 7
        end_date = start_date + timedelta(days=total_days - 1)
    elif end_date_str:
        try:
            end_date = datetime.strptime(end_date_str, "%Y-%m-%d").date()
        except:
            return jsonify({"status": "error", "message": "end_date must be YYYY-MM-DD"}), 400

        if end_date <= start_date:
            return jsonify({"status": "error", "message": "end_date must be after start_date"}), 400

        total_days = (end_date - start_date).days
    else:
        return jsonify({"status": "error", "message": "Provide duration_weeks OR end_date"}), 400

    total_rewards = total_days * marks_per_day

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            if user_id_param:
                cursor.execute("SELECT id FROM register WHERE id=%s", (user_id_param,))
            else:
                cursor.execute("SELECT id FROM register WHERE email=%s", (email,))
            u = cursor.fetchone()
            if not u:
                return jsonify({"status": "error", "message": "User not found"}), 404
            user_id = u["id"]

            cursor.execute("SELECT id, created_by_user_id FROM habits WHERE id=%s AND is_active=1", (habit_id,))
            habit = cursor.fetchone()
            if not habit:
                return jsonify({"status": "error", "message": "Habit not found"}), 404

            if habit.get("created_by_user_id") and habit["created_by_user_id"] != user_id:
                return jsonify({"status": "error", "message": "This habit does not belong to you"}), 403

            cursor.execute("""
                SELECT id FROM user_goals
                WHERE user_id=%s AND habit_id=%s AND status='ACTIVE'
            """, (user_id, habit_id))
            already = cursor.fetchone()
            if already:
                return jsonify({"status": "error", "message": "This goal is already active"}), 409

            cursor.execute("""
                INSERT INTO user_goals
                    (user_id, habit_id, marks_per_day, start_date, end_date, total_days, total_potential_rewards, status)
                VALUES
                    (%s, %s, %s, %s, %s, %s, %s, 'ACTIVE')
            """, (user_id, habit_id, marks_per_day, start_date, end_date, total_days, total_rewards))
            conn.commit()
            goal_id = cursor.lastrowid

        return jsonify({
            "status": "success",
            "message": "Quest activated successfully",
            "goal": {
                "goal_id": goal_id,
                "user_id": user_id,
                "habit_id": habit_id,
                "marks_per_day": marks_per_day,
                "start_date": str(start_date),
                "end_date": str(end_date),
                "total_days": total_days,
                "total_potential_rewards": total_rewards,
                "status": "ACTIVE"
            }
        }), 201
    finally:
        conn.close()

# ==========================================================
# ✅ My Goals list
# ==========================================================
@app.route("/my-goals", methods=["GET"])
def my_goals_list():
    email = (request.args.get("email") or "").strip()
    user_id_param = _to_int(request.args.get("user_id"))

    if not email and not user_id_param:
        return jsonify({"status": "error", "message": "email or user_id is required"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            if user_id_param:
                cursor.execute("SELECT id FROM register WHERE id=%s", (user_id_param,))
            else:
                cursor.execute("SELECT id FROM register WHERE email=%s", (email,))
            u = cursor.fetchone()

            if not u:
                return jsonify({"status": "error", "message": "User not found"}), 404
            user_id = u["id"]

            cursor.execute("""
                SELECT
                    g.id AS goal_id,
                    g.status,
                    g.marks_per_day,
                    g.start_date,
                    g.end_date,
                    g.total_days,
                    g.total_potential_rewards,
                    h.id AS habit_id,
                    h.title,
                    h.category,
                    h.icon
                FROM user_goals g
                JOIN habits h ON h.id = g.habit_id
                WHERE g.user_id=%s
                ORDER BY g.created_at DESC
            """, (user_id,))
            goals = cursor.fetchall()

            if not goals:
                return jsonify({"status": "success", "active_count": 0, "goals": []}), 200

            goal_ids = [g["goal_id"] for g in goals]

            placeholders = ",".join(["%s"] * len(goal_ids))
            cursor.execute(f"""
                SELECT goal_id, day_number, completed
                FROM goal_daily_tracking
                WHERE goal_id IN ({placeholders})
                ORDER BY goal_id, day_number
            """, tuple(goal_ids))
            tracker_rows = cursor.fetchall()

            tracker_map = {}
            for tr in tracker_rows:
                gid = tr["goal_id"]
                if gid not in tracker_map:
                    tracker_map[gid] = []
                tracker_map[gid].append({
                    "day_number": tr["day_number"],
                    "completed": bool(tr["completed"])
                })

            for g in goals:
                g["tracking"] = tracker_map.get(g["goal_id"], [])

        active_count = sum(1 for g in goals if g.get("status") == "ACTIVE")
        return jsonify({"status": "success", "active_count": active_count, "goals": goals}), 200

    finally:
        conn.close()

# ==========================================================
# ✅ Track Goal Day (BLOCKED in buddy mode)
# ==========================================================
@app.route("/goals/track-day", methods=["POST"])
def track_goal_day():
    data = request.get_json(silent=True) or {}

    b = _block_if_buddy_mode()
    if b: return b

    email = (data.get("email") or "").strip()
    user_id_param = _to_int(data.get("user_id"))
    goal_id = _to_int(data.get("goal_id"))
    day_number = _to_int(data.get("day_number"))
    completed = data.get("completed", True)

    if not email and not user_id_param:
        return jsonify({"status": "error", "message": "email or user_id is required"}), 400
    if not goal_id or not day_number:
        return jsonify({"status": "error", "message": "goal_id and day_number are required"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            if user_id_param:
                cursor.execute("SELECT id FROM register WHERE id=%s", (user_id_param,))
            else:
                cursor.execute("SELECT id FROM register WHERE email=%s", (email,))
            u = cursor.fetchone()
            if not u:
                return jsonify({"status": "error", "message": "User not found"}), 404
            user_id = u["id"]

            cursor.execute("""
                CREATE TABLE IF NOT EXISTS goal_daily_tracking (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    goal_id INT,
                    day_number INT,
                    completed BOOLEAN,
                    UNIQUE KEY(goal_id, day_number)
                )
            """)

            cursor.execute("SELECT id FROM user_goals WHERE id=%s AND user_id=%s", (goal_id, user_id))
            if not cursor.fetchone():
                return jsonify({"status": "error", "message": "Goal not found or does not belong to you"}), 403

            cursor.execute("""
                INSERT INTO goal_daily_tracking (goal_id, day_number, completed)
                VALUES (%s, %s, %s)
                ON DUPLICATE KEY UPDATE completed=%s
            """, (goal_id, day_number, completed, completed))
            conn.commit()

            active_days, total_points = _recalculate_progress(conn, user_id)

        return jsonify({
            "status": "success",
            "message": f"Day {day_number} updated",
            "total_active_days": active_days,
            "total_points": total_points
        }), 200
    finally:
        conn.close()

# ==========================================================
# ✅ DELETE GOAL (BLOCKED in buddy mode)
# ==========================================================
@app.route("/goals/<int:goal_id>", methods=["DELETE"])
def delete_goal_by_id(goal_id):
    b = _block_if_buddy_mode()
    if b: return b

    user_id = request.args.get("user_id", type=int)
    if not user_id:
        return jsonify({"status": "error", "message": "user_id is required as query param"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            # Check goal belongs to user
            cursor.execute("SELECT id, habit_id FROM user_goals WHERE id=%s AND user_id=%s", (goal_id, user_id))
            goal = cursor.fetchone()
            if not goal:
                return jsonify({"status": "error", "message": "Goal not found or unauthorized"}), 403
            
            habit_id = goal["habit_id"]
            
            # Delete tracking and goal
            cursor.execute("DELETE FROM goal_daily_tracking WHERE goal_id=%s", (goal_id,))
            cursor.execute("DELETE FROM user_goals WHERE id=%s", (goal_id,))
            
            # If it's a custom habit, check if we should delete the habit itself
            cursor.execute("SELECT created_by_user_id FROM habits WHERE id=%s", (habit_id,))
            habit_info = cursor.fetchone()
            if habit_info and habit_info["created_by_user_id"] is not None:
                # Check if any other goal still uses this habit
                cursor.execute("SELECT id FROM user_goals WHERE habit_id=%s", (habit_id,))
                if not cursor.fetchone():
                    # No other goals use it, delete the habit too
                    cursor.execute("DELETE FROM habits WHERE id=%s", (habit_id,))
            
            conn.commit()
            
            # Recalculate progress after deletion
            _recalculate_progress(conn, user_id)

        return jsonify({"status": "success", "message": "Goal and related data deleted successfully"}), 200
    finally:
        conn.close()

# ==========================================================
# ✅ TROPHY ROOM
# ==========================================================
@app.route("/trophy-room", methods=["GET"])
def get_trophy_room():
    user_id_param = _to_int(request.args.get("user_id"))

    if not user_id_param:
        return jsonify({"status": "error", "message": "user_id is required"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            # Get user total completed days as substitute for level
            cursor.execute("""
                SELECT COUNT(*) as completed_days 
                FROM goal_daily_tracking gdt
                JOIN user_goals ug ON ug.id = gdt.goal_id
                WHERE ug.user_id = %s AND gdt.completed = 1
            """, (user_id_param,))
            row = cursor.fetchone()
            total_completed_days = int(row["completed_days"]) if row and row["completed_days"] else 0

            # Calculate user streak based on consecutive completed days (or just use total_completed_days)
            user_level = total_completed_days // 7  # 1 level per 7 days completed

            # Define standard trophies
            trophies = [
                {"id": 1, "name": "Bronze Cup", "description": "1 Week", "required_level": 1, "icon": "🥉"},
                {"id": 2, "name": "Silver Cup", "description": "2 Weeks", "required_level": 2, "icon": "🥈"},
                {"id": 3, "name": "Gold Cup", "description": "3 Weeks", "required_level": 3, "icon": "🥇"},
                {"id": 4, "name": "Platinum Cup", "description": "4 Weeks", "required_level": 4, "icon": "💎"},
                {"id": 5, "name": "Sapphire Cup", "description": "5 Weeks", "required_level": 5, "icon": "📘"},
                {"id": 6, "name": "Ruby Cup", "description": "6 Weeks", "required_level": 6, "icon": "📕"},
                {"id": 7, "name": "Emerald Cup", "description": "7 Weeks", "required_level": 7, "icon": "📗"},
                {"id": 8, "name": "Amethyst Cup", "description": "8 Weeks", "required_level": 8, "icon": "🔮"},
                {"id": 9, "name": "Diamond Cup", "description": "9 Weeks", "required_level": 9, "icon": "💠"},
                {"id": 10, "name": "Cosmic Cup", "description": "10 Weeks", "required_level": 10, "icon": "🌌"},
                {"id": 11, "name": "Solar Cup", "description": "11 Weeks", "required_level": 11, "icon": "☀️"},
                {"id": 12, "name": "Legend Cup", "description": "12 Weeks", "required_level": 12, "icon": "👑"}
            ]

            for t in trophies:
                req_level = int(t["required_level"])  # type: ignore
                t["unlocked"] = bool(user_level >= req_level)

        return jsonify({
            "status": "success",
            "user_level": user_level,
            "trophies": trophies
        }), 200
    finally:
        conn.close()

# ==========================================================
# ✅ Profile GET
# ==========================================================
@app.route("/profile", methods=["GET"])
def get_profile():
    email = (request.args.get("email") or "").strip()
    user_id_param = _to_int(request.args.get("user_id"))

    # If no API params provided, the user is navigating via browser — serve the HTML page
    if not email and not user_id_param:
        return send_from_directory(app.static_folder, 'profile.html')

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            if user_id_param:
                cursor.execute("SELECT id, full_name, email FROM register WHERE id=%s", (user_id_param,))
            else:
                cursor.execute("SELECT id, full_name, email FROM register WHERE email=%s", (email,))
            user = cursor.fetchone()

        if not user:
            return jsonify({"status": "error", "message": "User not found"}), 404

        return jsonify({"status": "success", "user": user}), 200
    finally:
        conn.close()

# ==========================================================
# ✅ Profile UPDATE (BLOCKED in buddy mode)
# ==========================================================
@app.route("/profile/update", methods=["PUT"])
def update_profile():
    data = request.get_json(silent=True) or {}

    b = _block_if_buddy_mode()
    if b: return b

    user_id = _to_int(data.get("user_id"))
    full_name = (data.get("full_name") or data.get("username") or "").strip()

    if not user_id or not full_name:
        return jsonify({"status": "error", "message": "user_id and full_name are required"}), 400

    if not re.match(r"^[A-Za-z\s]+$", full_name):
        return jsonify({"status": "error", "message": "Full name must contain only letters and spaces"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT id FROM register WHERE id=%s", (user_id,))
            existing = cursor.fetchone()
            if not existing:
                return jsonify({"status": "error", "message": "User not found"}), 404

            cursor.execute("UPDATE register SET full_name=%s WHERE id=%s", (full_name, user_id))
            conn.commit()

        return jsonify({"status": "success", "message": "Profile updated successfully"}), 200
    finally:
        conn.close()

# ==========================================================
# ✅ Buddy Login (creates buddy_token session) - VIEW ONLY
# ==========================================================
@app.route("/buddy/login", methods=["POST"])
def buddy_login():
    data = request.get_json(silent=True) or {}

    owner_user_id = _to_int(data.get("owner_user_id"))
    buddy_email = (data.get("buddy_email") or "").strip()
    buddy_password = (data.get("buddy_password") or "").strip()

    if not owner_user_id:
        return jsonify({"status": "error", "message": "owner_user_id is required"}), 400
    if not buddy_email or not buddy_password:
        return jsonify({"status": "error", "message": "buddy_email and buddy_password are required"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT id FROM register WHERE id=%s", (owner_user_id,))
            if not cursor.fetchone():
                return jsonify({"status": "error", "message": "Owner user not found"}), 404

            cursor.execute("SELECT id, full_name, email, password FROM register WHERE email=%s", (buddy_email,))
            buddy = cursor.fetchone()
            if not buddy:
                return jsonify({"status": "error", "message": "Buddy not found"}), 404

            if not check_password_hash(buddy["password"], buddy_password):
                return jsonify({"status": "error", "message": "Invalid buddy password"}), 401

            buddy_user_id = buddy["id"]
            if buddy_user_id == owner_user_id:
                return jsonify({"status": "error", "message": "You cannot buddy-login yourself"}), 400

            token = secrets.token_hex(24)  # 48 chars

            # deactivate older sessions for same pair
            cursor.execute("""
                UPDATE buddy_sessions
                SET is_active=0
                WHERE owner_user_id=%s AND buddy_user_id=%s
            """, (owner_user_id, buddy_user_id))

            # store new session (expires 1 day)
            cursor.execute("""
                INSERT INTO buddy_sessions (owner_user_id, buddy_user_id, buddy_token, expires_at, is_active)
                VALUES (%s, %s, %s, DATE_ADD(NOW(), INTERVAL 1 DAY), 1)
            """, (owner_user_id, buddy_user_id, token))
            conn.commit()

        return jsonify({
            "status": "success",
            "message": "Buddy login successful (VIEW ONLY)",
            "owner_user_id": owner_user_id,
            "buddy": {
                "id": buddy_user_id,
                "full_name": buddy["full_name"],
                "email": buddy["email"]
            },
            "buddy_token": token
        }), 200

    finally:
        conn.close()

# ==========================================================
# ✅ View Buddy Goals (token protected) - VIEW ONLY
# ==========================================================
@app.route("/buddy/view/goals", methods=["GET"])
def buddy_view_goals():
    owner_user_id = _to_int(request.args.get("owner_user_id"))
    buddy_token = (request.args.get("buddy_token") or "").strip()

    if not owner_user_id or not buddy_token:
        return jsonify({"status": "error", "message": "owner_user_id and buddy_token are required"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        sess = _get_buddy_session(conn, owner_user_id, buddy_token)
        if not sess:
            return jsonify({"status": "error", "message": "Invalid/expired buddy session"}), 401

        buddy_user_id = sess["buddy_user_id"]

        with conn.cursor() as cursor:
            cursor.execute("SELECT id, full_name, email FROM register WHERE id=%s", (buddy_user_id,))
            buddy = cursor.fetchone()
            if not buddy:
                return jsonify({"status": "error", "message": "Buddy not found"}), 404

            cursor.execute("""
                SELECT
                    g.id AS goal_id,
                    g.status,
                    g.marks_per_day,
                    g.start_date,
                    g.end_date,
                    g.total_days,
                    g.total_potential_rewards,
                    h.id AS habit_id,
                    h.title,
                    h.category,
                    h.icon
                FROM user_goals g
                JOIN habits h ON h.id = g.habit_id
                WHERE g.user_id=%s
                ORDER BY g.created_at DESC
            """, (buddy_user_id,))
            goals = cursor.fetchall()

        return jsonify({
            "status": "success",
            "view_only": True,
            "buddy": buddy,
            "active_count": sum(1 for g in goals if g.get("status") == "ACTIVE"),
            "goals": goals
        }), 200

    finally:
        conn.close()

# ==========================================================
# ✅✅✅ STREAK + TROPHY SYSTEM (unchanged logic, but WRITE routes blocked)
# ==========================================================
DAILY_POINTS = 10

def _parse_date(date_str):
    if not date_str:
        return datetime.now().date()
    try:
        return datetime.strptime(date_str, "%Y-%m-%d").date()
    except:
        return None

def _ensure_user_trophies(conn, user_id):
    with conn.cursor() as cursor:
        cursor.execute("SELECT id FROM trophies ORDER BY days_required ASC")
        trophies = cursor.fetchall()
        for t in trophies:
            cursor.execute(
                "INSERT IGNORE INTO user_trophies (user_id, trophy_id, is_unlocked) VALUES (%s, %s, 0)",
                (user_id, t["id"])
            )
    conn.commit()

def _lock_all_trophies(conn, user_id):
    with conn.cursor() as cursor:
        cursor.execute(
            "UPDATE user_trophies SET is_unlocked=0, unlocked_at=NULL WHERE user_id=%s",
            (user_id,)
        )
    conn.commit()

def _reset_streak(conn, user_id):
    with conn.cursor() as cursor:
        cursor.execute(
            "INSERT INTO user_progress (user_id, total_active_days, total_points) VALUES (%s, 0, 0) "
            "ON DUPLICATE KEY UPDATE total_active_days=0, total_points=0",
            (user_id,)
        )
    conn.commit()
    _ensure_user_trophies(conn, user_id)
    _lock_all_trophies(conn, user_id)

def _recalculate_progress(conn, user_id):
    with conn.cursor() as cursor:
        cursor.execute("""
            SELECT
                (
                    SELECT COUNT(*)
                    FROM goal_daily_tracking gdt
                    JOIN user_goals ug ON ug.id = gdt.goal_id
                    WHERE ug.user_id=%s AND gdt.completed=1
                ) +
                (
                    SELECT COUNT(DISTINCT l.log_date)
                    FROM habit_daily_log l
                    JOIN user_selected_habits s
                      ON s.user_id = l.user_id
                     AND s.habit_id = l.habit_id
                     AND s.is_active = 1
                    WHERE l.user_id=%s
                ) AS active_days
        """, (user_id, user_id))

        row = cursor.fetchone()
        active_days = int(row["active_days"] or 0)

        _ensure_user_trophies(conn, user_id)

        cursor.execute("""
            UPDATE user_trophies ut
            JOIN trophies t ON t.id = ut.trophy_id
            SET ut.is_unlocked = 1,
                ut.unlocked_at = COALESCE(ut.unlocked_at, NOW())
            WHERE ut.user_id=%s AND t.days_required <= %s
        """, (user_id, active_days))

        cursor.execute("""
            SELECT COALESCE(SUM(t.reward_points),0) AS trophy_points
            FROM user_trophies ut
            JOIN trophies t ON t.id = ut.trophy_id
            WHERE ut.user_id=%s AND ut.is_unlocked=1
        """, (user_id,))
        trophy_points = int(cursor.fetchone()["trophy_points"] or 0)

        total_points = (active_days * DAILY_POINTS) + trophy_points

        cursor.execute("""
            INSERT INTO user_progress (user_id, total_active_days, total_points)
            VALUES (%s, %s, %s)
            ON DUPLICATE KEY UPDATE total_active_days=%s, total_points=%s
        """, (user_id, active_days, total_points, active_days, total_points))

    conn.commit()
    return active_days, total_points

@app.route("/streak/select", methods=["POST"])
def streak_select():
    data = request.get_json(silent=True) or {}

    b = _block_if_buddy_mode()
    if b: return b

    user_id = _to_int(data.get("user_id"))
    habit_ids = data.get("habit_ids") or []

    if not user_id:
        return jsonify({"status": "error", "message": "user_id is required"}), 400
    if not isinstance(habit_ids, list) or len(habit_ids) != 5:
        return jsonify({"status": "error", "message": "habit_ids must be a list of exactly 5 ids"}), 400

    habit_ids = [_to_int(x) for x in habit_ids]
    if any(x is None for x in habit_ids) or len(set(habit_ids)) != 5:
        return jsonify({"status": "error", "message": "habit_ids must contain 5 unique valid integers"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            cursor.execute(
                f"SELECT id FROM habits WHERE is_active=1 AND id IN ({','.join(['%s']*len(habit_ids))})",
                tuple(habit_ids)
            )
            found = cursor.fetchall()
            if len(found) != 5:
                return jsonify({"status": "error", "message": "One or more habit_ids are invalid/inactive"}), 400

            cursor.execute("UPDATE user_selected_habits SET is_active=0 WHERE user_id=%s", (user_id,))

            for hid in habit_ids:
                cursor.execute("""
                    INSERT INTO user_selected_habits (user_id, habit_id, is_active)
                    VALUES (%s, %s, 1)
                    ON DUPLICATE KEY UPDATE is_active=1, selected_at=NOW()
                """, (user_id, hid))

            conn.commit()

        _reset_streak(conn, user_id)

        return jsonify({
            "status": "success",
            "message": "Selected 5 habits. Streak reset and started fresh.",
            "user_id": user_id,
            "habit_ids": habit_ids
        }), 200
    finally:
        conn.close()

@app.route("/streak/complete", methods=["POST"])
def streak_complete():
    data = request.get_json(silent=True) or {}

    b = _block_if_buddy_mode()
    if b: return b

    user_id = _to_int(data.get("user_id"))
    habit_id = _to_int(data.get("habit_id"))
    d = _parse_date((data.get("date") or "").strip())

    if not user_id or not habit_id:
        return jsonify({"status": "error", "message": "user_id and habit_id are required"}), 400
    if d is None:
        return jsonify({"status": "error", "message": "date must be YYYY-MM-DD"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT id FROM user_selected_habits
                WHERE user_id=%s AND habit_id=%s AND is_active=1
            """, (user_id, habit_id))
            sel = cursor.fetchone()
            if not sel:
                return jsonify({"status": "error", "message": "Habit not selected (active) for streak"}), 400

            cursor.execute("""
                INSERT IGNORE INTO habit_daily_log (user_id, habit_id, log_date)
                VALUES (%s, %s, %s)
            """, (user_id, habit_id, d))
            conn.commit()

        active_days, total_points = _recalculate_progress(conn, user_id)

        return jsonify({
            "status": "success",
            "message": "Habit completion recorded",
            "user_id": user_id,
            "habit_id": habit_id,
            "date": str(d),
            "total_active_days": active_days,
            "total_points": total_points
        }), 200
    finally:
        conn.close()

@app.route("/streak/analytics", methods=["GET"])
def streak_analytics():
    user_id = _to_int(request.args.get("user_id"))
    if not user_id:
        return jsonify({"status": "error", "message": "user_id is required as query param"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        active_days, total_points = _recalculate_progress(conn, user_id)

        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT title, days_required, reward_points
                FROM trophies
                WHERE days_required > %s
                ORDER BY days_required ASC
                LIMIT 1
            """, (active_days,))
            next_t = cursor.fetchone()

        return jsonify({
            "status": "success",
            "user_id": user_id,
            "total_active_days": active_days,
            "total_points": total_points,
            "daily_points": DAILY_POINTS,
            "next_milestone": next_t,
            "days_left": (next_t["days_required"] - active_days) if next_t else 0
        }), 200
    finally:
        conn.close()



@app.route("/streak/remove", methods=["DELETE"])
def streak_remove():
    data = request.get_json(silent=True) or {}

    b = _block_if_buddy_mode()
    if b: return b

    user_id = _to_int(data.get("user_id"))
    habit_id = _to_int(data.get("habit_id"))

    if not user_id or not habit_id:
        return jsonify({"status": "error", "message": "user_id and habit_id are required"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500

    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                UPDATE user_selected_habits
                SET is_active=0
                WHERE user_id=%s AND habit_id=%s
            """, (user_id, habit_id))
            conn.commit()

        _reset_streak(conn, user_id)

        return jsonify({
            "status": "success",
            "message": "Habit removed from selection. Streak and trophies reset/locked again.",
            "user_id": user_id,
            "habit_id": habit_id
        }), 200
    finally:
        conn.close()

@app.before_request
def redirect_html():
    # Redirect .html URLs to clean URLs (strips .html from address bar)
    if request.path.endswith('.html'):
        clean = request.path[:-5]  # e.g. /habits.html → /habits
        # /habits clashes with API; /profile now serves HTML directly
        if clean == '/habits':
            return redirect('/habits_page', code=301)
        return redirect(clean, code=301)

# --------------------------------------------------
# Web Render
# --------------------------------------------------
from flask import send_from_directory # type: ignore
@app.route("/index", methods=["GET"])
def index(): return send_from_directory(app.static_folder, 'index.html')

@app.route("/about", methods=["GET"])
def page_about(): return send_from_directory(app.static_folder, 'about.html')

@app.route("/buddybot", methods=["GET"])
def page_buddybot(): return send_from_directory(app.static_folder, 'buddybot.html')

@app.route("/calendar", methods=["GET"])
def page_calendar(): return send_from_directory(app.static_folder, 'calendar.html')

@app.route("/choose_goal", methods=["GET"])
def page_choose_goal(): return send_from_directory(app.static_folder, 'choose_goal.html')

@app.route("/community", methods=["GET"])
def page_community(): return send_from_directory(app.static_folder, 'community.html')

@app.route("/d", methods=["GET"])
def page_d(): return send_from_directory(app.static_folder, 'd.html')

@app.route("/dashboard", methods=["GET"])
def page_dashboard(): return send_from_directory(app.static_folder, 'dashboard.html')

@app.route("/edit_info", methods=["GET"])
def page_edit_info(): return send_from_directory(app.static_folder, 'edit_info.html')

@app.route("/forgot_password", methods=["GET"])
def page_forgot_password(): return send_from_directory(app.static_folder, 'forgot_password.html')

@app.route("/goalpage", methods=["GET"])
def page_goalpage(): return send_from_directory(app.static_folder, 'goalpage.html')

@app.route("/h", methods=["GET"])
def page_h(): return send_from_directory(app.static_folder, 'h.html')

@app.route("/habits_page", methods=["GET"])
def page_habits(): return send_from_directory(app.static_folder, 'habits.html')

@app.route("/home", methods=["GET"])
def page_home(): return send_from_directory(app.static_folder, 'home.html')

@app.route("/library", methods=["GET"])
def page_library(): return send_from_directory(app.static_folder, 'library.html')

@app.route("/login", methods=["GET"])
def page_login(): return send_from_directory(app.static_folder, 'login.html')

@app.route("/notifications", methods=["GET"])
def page_notifications(): return send_from_directory(app.static_folder, 'notifications.html')

@app.route("/people_progress", methods=["GET"])
def page_people_progress(): return send_from_directory(app.static_folder, 'people_progress.html')

@app.route("/privacy", methods=["GET"])
def page_privacy(): return send_from_directory(app.static_folder, 'privacy.html')

@app.route("/profile_page", methods=["GET"])
def page_profile(): return send_from_directory(app.static_folder, 'profile.html')

@app.route("/progress", methods=["GET"])
def page_progress(): return send_from_directory(app.static_folder, 'progress.html')

@app.route("/settings", methods=["GET"])
def page_settings(): return send_from_directory(app.static_folder, 'settings.html')

@app.route("/signup", methods=["GET"])
def page_signup(): return send_from_directory(app.static_folder, 'signup.html')

@app.route("/streak", methods=["GET"])
def page_streak(): return send_from_directory(app.static_folder, 'streak.html')
# --------------------------------------------------
# Notifications 
# --------------------------------------------------
@app.route("/enable-daily", methods=["POST"])
def enable_daily():
    data = request.json
    user_id = data.get("user_id")
    time_value = data.get("time")

    if not user_id or not time_value:
        return jsonify({"status": "error", "message": "user_id & time required"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500
    cursor = conn.cursor()
    try:
        cursor.execute("""
            INSERT INTO user_notifications (user_id, type, time_value, status)
            VALUES (%s, 'daily', %s, 1)
            ON DUPLICATE KEY UPDATE time_value=%s, status=1
        """, (user_id, time_value, time_value))
        conn.commit()
        return jsonify({"status": "success", "message": "Daily reminder enabled"})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@app.route("/enable-monthly-flexible", methods=["POST"])
def enable_monthly_flexible():
    data = request.json
    user_id = data.get("user_id")
    day = data.get("day")
    time_value = data.get("time")

    if not user_id or day is None or not time_value:
        return jsonify({"status": "error", "message": "user_id, day & time required"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500
    cursor = conn.cursor()
    try:
        cursor.execute("""
            INSERT INTO user_notifications (user_id, type, day_value, time_value, status)
            VALUES (%s, 'monthly', %s, %s, 1)
            ON DUPLICATE KEY UPDATE day_value=%s, time_value=%s, status=1
        """, (user_id, day, time_value, day, time_value))
        conn.commit()
        return jsonify({"status": "success", "message": "Monthly reminder enabled"})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@app.route("/disable-notification", methods=["POST"])
def disable_notification():
    data = request.json
    user_id = data.get("user_id")
    notif_type = data.get("type")

    if not user_id or not notif_type:
        return jsonify({"status": "error", "message": "user_id & type required"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500
    cursor = conn.cursor()
    try:
        cursor.execute("""
            UPDATE user_notifications SET status = 0 
            WHERE user_id = %s AND type = %s
        """, (user_id, notif_type))
        conn.commit()
        return jsonify({"status": "success", "message": f"{notif_type} reminder disabled"})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@app.route("/get-notifications", methods=["GET"])
def get_notifications():
    user_id = request.args.get("user_id")
    if not user_id:
        return jsonify({"status": "error", "message": "user_id is required"}), 400

    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500
    cursor = conn.cursor()
    try:
        cursor.execute("""
            SELECT id, title, message, time_value as time, type, is_unread 
            FROM notifications WHERE user_id = %s ORDER BY created_at DESC
        """, (user_id,))
        notifications = cursor.fetchall()
        for n in notifications:
            n['is_unread'] = bool(n['is_unread'])
        return jsonify({"status": "success", "notifications": notifications})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@app.route("/delete-notification/<int:notification_id>", methods=["DELETE"])
def delete_notification(notification_id):
    conn = get_db_connection()
    if not conn:
        return jsonify({"status": "error", "message": "DB connection failed"}), 500
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM notifications WHERE id = %s", (notification_id,))
        conn.commit()
        return jsonify({"status": "success", "message": "Notification deleted"})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

def process_notifications():
    from datetime import datetime
    now = datetime.now()
    # Current time in "9:00 AM" format (no leading zero).
    current_time = now.strftime("%I:%M %p").lstrip('0')
    current_day = now.day
    
    print(f"--- Scheduler Running at {current_time} (Day {current_day}) ---")
    
    conn = get_db_connection()
    if not conn: return
    cursor = conn.cursor()
    try:
        # Daily Reminders
        cursor.execute("""
            SELECT user_id FROM user_notifications 
            WHERE type = 'daily' AND time_value = %s AND status = 1
        """, (current_time,))
        daily_users = cursor.fetchall()
        
        for row in daily_users:
            # Check if a daily notification was already sent today for this user
            cursor.execute("""
                SELECT id FROM notifications 
                WHERE user_id = %s AND type = 'daily' AND DATE(created_at) = CURDATE()
            """, (row['user_id'],))
            
            if not cursor.fetchone():
                print(f"Sending daily reminder to user {row['user_id']}")
                insert_notification(row['user_id'], "Daily Tip", "Hey buddy lets chase your goal!", "daily")
            else:
                print(f"Daily reminder already sent to user {row['user_id']} today")
            
        # Monthly Reminders
        cursor.execute("""
            SELECT user_id FROM user_notifications 
            WHERE type = 'monthly' AND day_value = %s AND time_value = %s AND status = 1
        """, (current_day, current_time))
        monthly_users = cursor.fetchall()
        
        for row in monthly_users:
            # Check if a monthly notification was already sent this month for this user
            cursor.execute("""
                SELECT id FROM notifications 
                WHERE user_id = %s AND type = 'monthly' 
                AND MONTH(created_at) = MONTH(NOW()) AND YEAR(created_at) = YEAR(NOW())
            """, (row['user_id'],))
            
            if not cursor.fetchone():
                print(f"Sending monthly reminder to user {row['user_id']}")
                insert_notification(row['user_id'], "Monthly Goal", "It's time to check your progress buddy!", "monthly")
            else:
                print(f"Monthly reminder already sent to user {row['user_id']} this month")
                
    except Exception as e:
        print(f"Scheduler Error: {e}")
    finally:
        cursor.close()
        conn.close()

@app.route("/debug-notifications", methods=["GET"])
def debug_notifications():
    from datetime import datetime # Import datetime here as well for this function
    conn = get_db_connection()
    if not conn: return jsonify({"error": "DB connection failed"}), 500
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT * FROM user_notifications")
        user_notifs = cursor.fetchall()
        cursor.execute("SELECT * FROM notifications ORDER BY created_at DESC LIMIT 20")
        recent_notifs = cursor.fetchall()
        return jsonify({
            "user_settings": user_notifs,
            "recent_actual_notifications": recent_notifs,
            "server_current_time_debug": datetime.now().strftime("%I:%M %p")
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@app.route("/trigger-scheduler", methods=["GET"])
def trigger_scheduler():
    process_notifications()
    return jsonify({"status": "success", "message": "Scheduler triggered manually"})

scheduler = BackgroundScheduler()
scheduler.add_job(process_notifications, 'interval', minutes=1)
scheduler.start()


@app.route("/test-notification", methods=["POST"])
def test_notification():
    data = request.json
    user_id = data.get("user_id")
    if not user_id:
        return jsonify({"status": "error", "message": "user_id required"}), 400
    
    insert_notification(user_id, "Test Alert", "This is a test notification from the server!", "test")
    return jsonify({"status": "success", "message": "Test notification created"})

# ==========================================================
# ✅ BUDDY BOT CHAT (GEMINI)
# ==========================================================
genai.configure(api_key="AIzaSyB3RVX6uLrvyz0cT5aovJjYD-cBhE4IQCw")

BUDDY_SYSTEM_PROMPT = """
You are "Buddy", a super-friendly, encouraging, and professional AI companion for DietHive. Your sole mission is to support users with Diet, Fitness, and Motivation.

PERSONALITY TRAITS:
- Exceptionally warm, supportive, and human-like.
- Always use a positive, "best friend" tone.
- Use emojis frequently to stay engaging (💪, ❤️, 🚀, 🥗, 💦, ✨).

TOPIC FOCUS (ONLY ANSWER THESE):
1. DIET & NUTRITION: Healthy eating, meal ideas, macro advice, hydration, and nutrition tips.
2. FITNESS & EXERCISE: Workout routines, gym advice, yoga, steps, and physical performance.
3. MOTIVATION & HABITS: Discipline, overcoming laziness, building better routines, and mental toughness.

STRICT TOPIC RESTRICTION:
- If a user asks about anything outside Diet, Fitness, or Motivation (e.g., coding, news, celebrities, science, etc.), YOU MUST DECLINE.
- Refusal Style: "Hey buddy! ❤️ I'm your dedicated coach for diet, fitness, and motivation. I don't really know much about other topics, but I'd love to help you with your health goals today! What's on your mind? 💪"

SAFETY & GUIDELINES:
- No medical diagnoses.
- Keep responses concise, clear, and motivational.
- If user greets you, say "Hey buddy! I'm here to help you with your diet and fitness journey! 🚀"
"""

@app.route("/buddy/chat", methods=["POST"])
def buddy_chat():
    data = request.get_json(silent=True) or {}
    user_message = data.get("message", "").strip()
    history = data.get("history", []) # Expected format: [{"role": "user", "parts": ["..."]}, {"role": "model", "parts": ["..."]}]

    if not user_message:
        return jsonify({"status": "error", "message": "Message is required"}), 400

    if not isinstance(history, list):
        history = []

    try:
        model = genai.GenerativeModel(
            model_name="models/gemini-2.0-flash",
            system_instruction=BUDDY_SYSTEM_PROMPT
        )
        chat = model.start_chat(history=history)
        response = chat.send_message(user_message)
        
        return jsonify({
            "status": "success",
            "reply": response.text,
            "history": history + [
                {"role": "user", "parts": [user_message]},
                {"role": "model", "parts": [response.text]}
            ]
        }), 200
    except Exception as e:
        print(f"Buddy Chat Error: {e}")
        return jsonify({"status": "error", "message": str(e)}), 500

def insert_notification(user_id, title, message, notif_type="general"):
    conn = get_db_connection()
    if not conn: return
    cursor = conn.cursor()
    try:
        cursor.execute("""
            INSERT INTO notifications (user_id, title, message, type, is_unread)
            VALUES (%s, %s, %s, %s, 1)
        """, (user_id, title, message, notif_type))
        conn.commit()
    except Exception as e:
        print(f"Error inserting notification: {e}")
    finally:
        cursor.close()
        conn.close()

# ==========================================================
# ✅ RUN SERVER
# ==========================================================
if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)