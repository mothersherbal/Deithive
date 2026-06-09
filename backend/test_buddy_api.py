import requests

def test_buddy_chat():
    url = "http://127.0.0.1:5000/buddy/chat"
    payload = {
        "message": "Hi Buddy, I'm feeling a bit tired today and lost motivation for my workout.",
        "history": []
    }
    try:
        response = requests.post(url, json=payload)
        print(f"Status: {response.status_code}")
        print(f"Response: {response.json()}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    test_buddy_chat()
