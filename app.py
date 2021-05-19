from flask import Flask, redirect, url_for, render_template, request, session, flash, jsonify
from datetime import timedelta
from db_connector import connect_to_database, execute_query

app = Flask(__name__)
app.secret_key = "group19"
app.permanent_session_lifetime = timedelta(days=1)

def insert_new_row(query, user_details):
    db_connection = connect_to_database()
    execute_query(db_connection, query, user_details)
    print(user_details)
    return 'inserted OK'

def select_result(query):
    db_connection = connect_to_database()
    user_data_db = execute_query(db_connection, query).fetchall()
    print(user_data_db)
    return user_data_db

@app.route("/")
def home():
    return render_template('users.html')

@app.route("/api/users", methods=["POST", "GET"])
def add_account():

    # db_connection = connect_to_database()
    # query = "SELECT fname, lname, homeworld, age, id from bsg_people;"
    # result = execute_query(db_connection, query).fetchall()
    if request.method == 'GET':
        return render_template('users.html')
    else:
        # insert a new row to the Users table
        print('Add a new user account')
        # check if the email address already exist
        user_email = request.form['user_email']
        query = 'Select user_email from Users;'
        emails = select_result(query)
        if user_email in emails:
            return 'This email already exist!'

        user_details = (
            request.form['user_name'],
            request.form['user_password'],
            request.form['user_email'],
            request.form['regis_date'],
            request.form['active']
        )
        

        query = 'Insert into Users (user_name, user_password, user_email, regis_date, active) Values (%s,%s,%s,%s,%s)'
        status_info = insert_new_row(query, user_details)
        if status_info == 'inserted OK':
            # select the last inserted row from the Users table
            query = 'Select * from Users where user_id = (select max(user_id) from Users);'
            user_data_db = select_result(query)

            # send data back to populate the result table
            return render_template('users.html', values=user_data_db)

@app.route('/api/users/<int:id>', methods=['GET', 'PUT'])
def update_account(id):
    db_connection = connect_to_database()
    # Delete account
    if request.method == 'GET':
        print('Delete account')
        db_connection = connect_to_database()
        query = "DELETE FROM Users WHERE user_id = %s"
        data = (id,)
        result = execute_query(db_connection, query, data)
        return (str(result.rowcount) + "row deleted")
        # search_query = 'SELECT * from Users WHERE user_id = %s' % (id)
        # search_result = execute_query(db_connection, search_query).fetchone()

        # if search_result == None:
        #     return "No such account found!"

        # return render_template('users.html', values= search_result)
    # update account
    elif request.method == 'PUT':
        print("Update account!")
        update_details = (
            request.form['user_name'],
            request.form['user_password'],
            request.form['regis_date'],
            request.form['active'],
            request.form['user_id']
        )
        print(request.form)

        query = "UPDATE Users SET user_name = %s, user_password = %s, regis_date = %s, active = %s WHERE user_id = %s"
        result = execute_query(db_connection, query, update_details)
        print(str(result.rowcount) + " row(s) updated")

        return redirect(url_for('home'))

@app.route('/delete_account/<int:id>')
def delete_account(id):
    '''deletes a account with the given id'''
    db_connection = connect_to_database()
    query = "DELETE FROM Users WHERE user_id = %s"
    data = (id,)
    result = execute_query(db_connection, query, data)
    return (str(result.rowcount) + "row deleted")
  

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
        print(data)
        execute_query(db_connection, query, data)
        print('sim record added!')
        return render_template("simulators.html")

@app.route("/quiz_user", methods=["POST", "GET"])
def quiz_user():
    if request.method == 'POST':
        return render_template("quizRecords.html")
    elif request.method == 'POST':
        print("Add new Quiz record!")
        user_id = request.form['user_id']
        quiz_date = request.form['quiz_date']
        quiz_state = request.form['quiz_state']
        quiz_score = request.form['quiz_score']
        db_connection = connect_to_database()
        query = 'INSERT INTO QuizRecords (user_id, quiz_date, quiz_state, quiz_score) VALUES (%s,%s,%s,%s)'
        data = (user_id, quiz_date, quiz_state, quiz_score)
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
