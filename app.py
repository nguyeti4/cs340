from flask import Flask, redirect, url_for, render_template, request, session, flash
from datetime import timedelta
# from db_connector import connect_to_database, execute_query

app = Flask(__name__)
app.secret_key = "group19"
app.permanent_session_lifetime = timedelta(days=1)


@app.route("/", methods=["POST", "GET"])
def users():
    # db_connection = connect_to_database()
    # query = "SELECT fname, lname, homeworld, age, id from bsg_people;"
    # result = execute_query(db_connection, query).fetchall()
    return render_template("users.html")

@app.route("/sim_user",methods=["POST","GET"])
def sim_user():
    return render_template("simulators.html")

@app.route("/quiz_user", methods=["POST", "GET"])
def quiz_user():
    return render_template("quizRecords.html")

@app.route("/quiz_detail", methods=["POST", "GET"])
def quiz_detail():
    return render_template("quizQuestions.html")

@app.route("/ques", methods=["POST", "GET"])
def questions():
    return render_template("questions.html")



if __name__ == "__main__":
    app.run(debug=True)
