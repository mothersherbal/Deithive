import google.generativeai as genai

genai.configure(api_key="AIzaSyB3RVX6uLrvyz0cT5aovJjYD-cBhE4IQCw")
try:
    model = genai.GenerativeModel("gemini-1.5-pro")
    response = model.generate_content("Hello")
    print(response.text)
except Exception as e:
    print(f"Error: {e}")
