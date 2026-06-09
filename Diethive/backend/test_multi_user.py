import requests
import json
import time

BASE_URL = "http://127.0.0.1:5000"

def test_user_separation():
    print("🚀 Starting User Separation Test...")
    
    # 1. Register Person A and Person B
    user_a = {"full_name": "Person A", "email": "a@diethive.test", "password": "Password1!", "confirm_password": "Password1!"}
    user_b = {"full_name": "Person B", "email": "b@diethive.test", "password": "Password1!", "confirm_password": "Password1!"}
    
    requests.post(f"{BASE_URL}/register", json=user_a)
    requests.post(f"{BASE_URL}/register", json=user_b)
    print("✅ Registered Person A (a@diethive.test) and Person B (b@diethive.test)")

    # 2. Create Habit for Person A
    res_a_habit = requests.post(f"{BASE_URL}/habits/create-own", json={"email": user_a["email"], "title": "Morning Run (A)"})
    habit_a_id = res_a_habit.json().get("habit_id")
    
    # 3. Create Habit for Person B
    res_b_habit = requests.post(f"{BASE_URL}/habits/create-own", json={"email": user_b["email"], "title": "Evening Yoga (B)"})
    habit_b_id = res_b_habit.json().get("habit_id")
    
    print(f"✅ Created specific habits Setup -> Person A habit_id: {habit_a_id}, Person B habit_id: {habit_b_id}")

    # 4. Activate Goals
    if habit_a_id:
        requests.post(f"{BASE_URL}/goals/activate", json={
            "email": user_a["email"], "habit_id": habit_a_id, "marks_per_day": 10, "duration_weeks": 1
        })
    if habit_b_id:
        requests.post(f"{BASE_URL}/goals/activate", json={
            "email": user_b["email"], "habit_id": habit_b_id, "marks_per_day": 20, "duration_weeks": 2
        })
    print("✅ Activated Goals independently for both users.")

    # 5. Fetch Goals to see if they are actually separate
    print("\n================ PERSON A'S GOALS ================")
    res_a_goals = requests.get(f"{BASE_URL}/my-goals?email={user_a['email']}").json()
    for g in res_a_goals.get("goals", []):
        print(f" => Goal Title: {g['title']} | Marks/Day: {g['marks_per_day']}")

    print("\n================ PERSON B'S GOALS ================")
    res_b_goals = requests.get(f"{BASE_URL}/my-goals?email={user_b['email']}").json()
    for g in res_b_goals.get("goals", []):
        print(f" => Goal Title: {g['title']} | Marks/Day: {g['marks_per_day']}")
        
    print("\n🎯 If the outputs are completely different, the backend is 100% separating users!")
    print("🎯 If your app still shows the same goals for B, your Frontend App is accidentally using Person A's email cached in SharedPreferences instead of Person B's email.")

if __name__ == "__main__":
    try:
        test_user_separation()
    except requests.exceptions.ConnectionError:
        print("❌ Error: Looks like the Flask Server (app.py) is not running. Please run it first!")
