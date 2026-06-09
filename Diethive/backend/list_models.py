import google.generativeai as genai

genai.configure(api_key="AIzaSyB3RVX6uLrvyz0cT5aovJjYD-cBhE4IQCw")
for m in genai.list_models():
    if 'generateContent' in m.supported_generation_methods:
        print(m.name)
