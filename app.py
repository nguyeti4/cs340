from flask import Flask, redirect, url_for, render_template, request, session, flash, jsonify
from datetime import timedelta
from db_connector import connect_to_database, execute_query

app = Flask(__name__)
app.secret_key = "group19"
app.permanent_session_lifetime = timedelta(days=1)



@app.route("/", methods=["POST", "GET"])
def users():

    # db_connection = connect_to_database()
    # query = "SELECT fname, lname, homeworld, age, id from bsg_people;"
    # result = execute_query(db_connection, query).fetchall()
    if request.method == 'GET':
        return render_template('users.html')
    else:
        user_details = (
            request.form['user_name'],
            request.form['user_password'],
            request.form['user_email'],
            request.form['regis_date']
        )
        insertNewUser(user_details)

def insertNewUser(user_details):
    db_connection = connect_to_database()
    query = 'Insert into Users (user_name, user_password, user_email, regis_date) Values (%s,%s,%s,%s)'
    execute_query(db_connection, query, user_details)
    print(user_details)

def query_result():
    db_connection = connect_to_database()
    query = 'Select * from Users where user_id = (select max(user_id) from Users);'
    user_data_db = execute_query(db_connection, query).fetchall()
    print(user_data_db)
    return user_data_db

def display_data():
    data_result = query_result()
    return render_template('users.html', data_result=data_result)
  

@app.route("/sim_user",methods=["POST","GET"])
def sim_user():
    if request.method == 'GET':
        return render_template("simulators.html")
    elif request.method == 'POST':
        print("Add new simulator record!")
        user_id = request.form['user_id']
        grade = request.form['grade']
        date = request.form['play_date']
        scenario = request.form['scenario']
        db_connection = connect_to_database()
        query = 'INSERT INTO Simulators (user_id, grading, play_date, scenario_name) VALUES (%s,%s,%s,%s)'
        data = (user_id, grade, date, scenario)
        execute_query(db_connection, query, data)
        print('sim record added!')
        return render_template("simulators.html")

@app.route("/quiz_user", methods=["POST", "GET"])
def quiz_user():
    if request.method == 'GET':
        return render_template("quizRecords.html")
    elif request.method == 'POST':
        print("Add new Quiz record!")
        quiz_user_id = request.form['quiz_user_id']
        quiz_date = request.form['quiz_date']
        quiz_state = request.form['quiz_state']
        quiz_score = request.form['quiz_score']
        db_connection = connect_to_database()
        query = 'INSERT INTO Quiz_Records (user_id, quiz_date, quiz_state, quiz_score) VALUES (%s,%s,%s,%s)'
        data = (quiz_user_id, quiz_date, quiz_state, quiz_score)
        execute_query(db_connection, query, data)
        print('Quiz record added!')
        return render_template("quizRecords.html")

@app.route("/quiz_detail", methods=["POST", "GET"])
def quiz_detail():
    return render_template("quizQuestions.html")

@app.route("/ques", methods=["POST", "GET"])
def questions():
    return render_template("questions.html")



if __name__ == "__main__":
    # app.run(debug=True)
    app.run(debug=True, host='localhost', port=5000)
