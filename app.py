from werkzeug.urls import quote  # Change to `quote`
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'
