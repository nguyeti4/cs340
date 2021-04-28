from flask import Flask, redirect, url_for, render_template, request, session
from datetime import timedelta

app = Flask(__name__)
app.secret_key = "group19"
app.permanent_session_lifetime = timedelta(days=1)

@app.route("/", methods=["POST", "GET"])
def home():
    if request.method == "POST":
        session.permanent = True
        user = request.form["user-name"] # get data from the frontend form
        session["user"] = user  # save user info in the session
        # return redirect(url_for("home"))
    else:
        return render_template("index.html")

@app.route("/laws")
def laws():
    return render_template("Laws.html")

@app.route("/quiz", methods=["POST", "GET"])
def quiz():
    if "user" in session:
        user = session["user"]
    if request.method == "POST":
        state = request.form["state"]
        number = request.form["number"]
        return render_template("quiz.html")
    else:
        return render_template("quiz.html")
        

@app.route("/sim")
def simulator():
    return render_template("simulator.html")

@app.route("/records")
def records():
    return render_template("Record.html")

if __name__ == "__main__":
    app.run(debug=True)
