from flask import Flask, redirect, url_for, render_template

app = Flask(__name__)

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/laws")
def quiz():
    return render_template("Laws.html")

@app.route("/quiz")
def quiz():
    return render_template("quiz.html")

@app.route("/sim")
def quiz():
    return render_template("simulator.html")

@app.route("/records")
def quiz():
    return render_template("Records.html")

if __name__ == "__main__":
    app.run(debug=True)
