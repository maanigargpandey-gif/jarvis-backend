# File: jarvis-backend/auth.py
from flask import Flask, request, jsonify

app = Flask(__name__)

# Master Identity (Locked)
IDENTITY = {
    "name": "Mani Pandey",
    "email": "maanigargpandey@gmail.com",
    "phone": "+91 86041 41005"
}
PASSWORD = "1005@Maani"

@app.route('/login', methods=['POST'])
def login():
    data = request.json
    if data.get('email') == IDENTITY['email'] and \
       data.get('phone') == IDENTITY['phone'] and \
       data.get('password') == PASSWORD:
        return jsonify({"status": "success", "token": "TOKEN_MANI_2026"}), 200
    return jsonify({"status": "error"}), 401

if __name__ == '__main__':
    app.run(port=5000, host='0.0.0.0')
    
