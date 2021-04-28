from flask import Flask, redirect, url_for, render_template, request, session, flash
from datetime import timedelta
from db_connector.db_connector import connect_to_database, execute_query

app = Flask(__name__)
app.secret_key = "group19"
app.permanent_session_lifetime = timedelta(days=1)


@app.route("/", methods=["POST", "GET"])
def home():
    db_connection = connect_to_database()
    # query = "SELECT fname, lname, homeworld, age, id from bsg_people;"
    # result = execute_query(db_connection, query).fetchall()

    if request.method == "POST":
        session.permanent = True
        user_email = request.form["user-email"] # get data from the frontend form
        session["user_email"] = user_email  # save user info in the session
        # return redirect(url_for("home"))
        flash("You have sucessfully login")
        return render_template("index.html")
    else:
        return render_template("index.html")

@app.route("/laws")
def laws():
    return render_template("Laws.html")

@app.route("/quiz", methods=["POST", "GET"])
def quiz():
    if "user_email" in session:
        user_email = session["user_email"]
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
