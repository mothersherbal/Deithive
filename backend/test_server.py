import requests
import threading
from app import app
import time

def start_server():
    app.run(port=5000, use_reloader=False)

threading.Thread(target=start_server, daemon=True).start()
time.sleep(2)
try:
    r = requests.get('http://127.0.0.1:5000/')
    print("Root:", r.status_code)
    r = requests.get('http://127.0.0.1:5000/login.html')
    print("Login.html:", r.status_code)
except Exception as e:
    print("Error:", e)
