from flask import Flask, render_template, jsonify
import platform
import sys

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/threads")
def threads():
    return render_template("threads.html")

@app.route("/race-conditions")
def race_conditions():
    return render_template("race_conditions.html")

@app.route("/clocks")
def clocks():
    return render_template("clocks.html")

@app.route("/api/system-info")
def system_info():
    return jsonify({
        "python_version": platform.python_version(),
        "platform": platform.platform(),
        "processor": platform.processor(),
    })

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=8080)
