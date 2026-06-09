import requests

BASE_URL = "http://127.0.0.1:5000"

print("Fetching goals...")
res = requests.get(f"{BASE_URL}/my-goals?email=a@diethive.test")
data = res.json()
print(data)

if data.get("goals"):
    first_goal = data["goals"][0]
    print("Deleting goal:", first_goal["goal_id"])
    delete_res = requests.delete(f"{BASE_URL}/goals/delete", json={
        "email": "a@diethive.test",
        "goal_id": first_goal["goal_id"]
    })
    print(delete_res.json())
