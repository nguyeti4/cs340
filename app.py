from flask import Flask, redirect, url_for, render_template, request, session, flash, jsonify, Response
from datetime import timedelta

from flask.helpers import make_response
from db_connector import connect_to_database, execute_query

app = Flask(__name__)
app.secret_key = "group19"
app.permanent_session_lifetime = timedelta(days=1)


# ----------------------------------------------------
# ----------------------------------------------------
#      User Page
# ----------------------------------------------------
# ----------------------------------------------------
@app.route("/", methods=["GET"])
@app.route("/users", methods=["GET"])
def users_page():
    return render_template('users.html')

@app.route("/api/users", methods=["POST", "GET"])
def users():
    print('/api/users', request.method)
    db_connection = connect_to_database()
    # add a new user account
    if request.method == 'POST':
        # check if the email address already exist
        input_email = request.form['user_email']
        print(input_email)
        query = 'Select * from Users where user_email=%s'
        user = execute_query(db_connection, query, (input_email,)).fetchall()
        print(user)
        if len(user) != 0:
        # if user with this email already exsit:
            return 'This email already exist!'
        user_name = request.form['user_name']
        if user_name is None: # Not Null
            return 'user_name can not be null!' 
        
        # insert a new row to the Users table
        print('Add a new user account')
        user_details = (
            request.form['user_name'],
            request.form['user_password'],
            request.form['user_email'],
            request.form['regis_date'],
            request.form['active']
        )
        query = 'Insert into Users (user_name, user_password, user_email, regis_date, active) Values (%s,%s,%s,%s,%s)'
        cur = execute_query(db_connection, query, user_details)

        return jsonify({
            'user_id': cur.lastrowid,
            'user_name': user_details[0],
            'user_password': user_details[1],
            'user_email': user_details[2],
            'regis_date': str(user_details[3]),
            'active': user_details[4],
        })

    if request.method == 'GET':
        db_connection = connect_to_database()
        query = "select * from Users;"
        rows = execute_query(db_connection, query).fetchall()
        users = []
        for row in rows:
            users.append({
                'user_id': row[0],
                'user_name': row[1],
                'user_password': row[2],
                'user_email': row[3],
                'regis_date': str(row[4]),
                'active': row[5],
            })
        res = make_response(jsonify(users))
        return res

@app.route('/api/users/<int:id>', methods=['GET', 'PUT'])
def change_account(id):
    db_connection = connect_to_database()
    # Delete user
    if request.method == 'DELETE':
        print('Delete account')
        db_connection = connect_to_database()
        query = "DELETE FROM Users WHERE user_id = %s"
        data = (id,)
        result = execute_query(db_connection, query, data)
        print (str(result.rowcount) + "row deleted")
        return jsonify("delete ok")
 
    #update account
    if request.method == 'PUT':
        print("Update account!")
        user_id = id
        update_details = (
            request.form['user_name'],
            request.form['user_password'],
            request.form['regis_date'],
            request.form['active'],
            user_id
        )
        print(request.form)

        query = "UPDATE Users SET user_name = %s, user_password = %s, regis_date = %s, active = %s WHERE user_id = %s"
        result = execute_query(db_connection, query, update_details)
        print(str(result.rowcount) + " row(s) updated")
        query = 'Select * from Users where user_id=%s'
        rows = execute_query(db_connection, query, (user_id,)).fetchall()
        row = rows[0]
        return jsonify({
            'user_id': row[0],
            'user_name': row[1],
            'user_password': row[2],
            'user_email': row[3],
            'regis_date': str(row[4]),
            'active': row[5],
        })

@app.route('/api/users/search')
def search_user():
    db_connection = connect_to_database()
    '''
    User Account Search by email in the User page
    '''
    # check whether the email address exists
    user_email = request.args.get('user_email')
    print(user_email)
    query = 'Select * from Users WHERE user_email=%s'
    data = (user_email,)
    user_info = execute_query(db_connection, query, data).fetchall()
    print(user_info)
    if len(user_info) == 0:
    # if user_info is None:
        return 'This email does not exist!'
    else:
        return render_template('users.html', values=user_info)

@app.route('/api/users/statistics')
def count_customers():
    # count new customers
    db_connection = connect_to_database()
    start_date = request.args.get('start_date')
    end_date = request.args.get('end_date')
    query = 'Select regis_date, COUNT(user_id) as new_customers from Users where regis_date >= %s and regis_date <= %s group by regis_date;'
    dates = (start_date, end_date)
    num_new_customers = execute_query(db_connection, query, dates).fetchall()
    return render_template('users.html', numbers=num_new_customers)

# ----------------------------------------------------
# ----------------------------------------------------
#      Simulator Page
# ----------------------------------------------------
# ----------------------------------------------------
@app.route("/simulators", methods=["GET"])
def simulators_page():
    db_connection = connect_to_database()
    query = "SELECT * FROM Simulators"
    sim_db=execute_query(db_connection, query)
    return render_template('simulators.html', result=sim_db)

@app.route("/api/simulators/add",methods=["POST","GET"])
def sim_user():
    if request.method == 'POST':
        db_connection = connect_to_database()
        print("Add new simulator record!")
        input_id = request.form['user_id']
        print(input_id)
        query = 'Select * from Users where user_id= %s'
        user = execute_query(db_connection, query, (input_id,)).fetchone()
        print(user)
        if user == None:
            print('This user does not exist!')
            return redirect(url_for("simulators_page"))
       
        user_id = request.form['user_id']
        grade = request.form['grade']
        date = request.form['play_date']
        scenario = request.form['scenario']
        query = 'INSERT INTO Simulators (user_id, grading, play_date, scenario_name) VALUES (%s,%s,%s,%s)'
        data = (user_id, grade, date, scenario)
        execute_query(db_connection, query, data)
        print('sim record added!')

        return redirect(url_for("simulators_page"))
        
@app.route("/api/simulators/update")
def sim_update():
    db_connection = connect_to_database()
    oldest_date = request.args.get('sim_dates')
    query2 = 'Select * from Simulators where play_date < %s;'  
    dates_to_delete = execute_query(db_connection, query2, (oldest_date,)).fetchall()  
    return redirect(url_for("simulators_page"))

@app.route("/api/simulators/delete/<int:id>")
def sim_delete(id):
    db_connection = connect_to_database()
    query = "DELETE FROM Simulators WHERE result_id = %s"
    result = execute_query(db_connection,query,(id,))
    print(str(result.rowcount) + "rows deleted")
    return redirect(url_for("simulators_page"))


# ----------------------------------------------------
# ----------------------------------------------------
#      Quiz_Records Page
# ----------------------------------------------------
# ----------------------------------------------------
@app.route("/quiz_records", methods=["GET"])
def quiz_records_page():
    db_connection = connect_to_database()
    query = "SELECT * FROM QuizRecords"
    record_db=execute_query(db_connection, query)
    return render_template('quizRecords.html', results=record_db)

@app.route("/api/quiz_records/add", methods=["POST", "GET"])
def quiz_user():
    if request.method == 'POST':
        db_connection = connect_to_database()
        print("Add new Quiz record!")
        
        input_id = request.form['quiz_user_id']
        print(input_id)
        query = 'Select * from Users where user_id=%s'
        user = execute_query(db_connection, query, (input_id,)).fetchone()
        print(user)
        if user is None:
            print('This user does not exist!')
            return redirect(url_for("quiz_records_page"))
        
        quiz_user_id = request.form['quiz_user_id']
        quiz_date = request.form['quiz_date']
        quiz_state = request.form['quiz_state']
        quiz_score = request.form['quiz_score']
       
        query = 'INSERT INTO QuizRecords (user_id, quiz_date, quiz_state, quiz_score) VALUES (%s,%s,%s,%s)'
        data = (quiz_user_id, quiz_date, quiz_state, quiz_score)
        execute_query(db_connection, query, data)
        print('Quiz record added!')
    
        #query = 'Select * from Quiz_Records;'
        #quizrecord_data_db = execute_query(db_connection, query).fetchall()
        #return render_template("quizRecords.html",results=quizrecord_data_db)
        return redirect(url_for("quiz_records_page"))
   
@app.route("/api/quiz_records/update")
def quiz_update():
    db_connection = connect_to_database()
    oldest_date = request.args.get('del_quizdates')
    query3 = 'Select * from QuizRecords where quiz_date < %s;'  
    result2 = execute_query(db_connection, query3, (oldest_date,)).fetchall()     
    return redirect(url_for("quiz_records_page"))

@app.route("/api/quiz_records/delete/<int:id>")
def quiz_delete(id):
    db_connection = connect_to_database()
    query = "DELETE FROM QuizRecords WHERE quiz_id = %s"
    result = execute_query(db_connection,query,(id,))
    print(str(result.rowcount) + "rows deleted")
    return redirect(url_for("quiz_records_page"))


# ----------------------------------------------------
# ----------------------------------------------------
#      QuizQuestions Page
# ----------------------------------------------------
# ----------------------------------------------------

@app.route("/quiz_questions")
def quiz_question_page():
    return render_template("quizQuestions.html")

@app.route("/api/quiz_questions", methods=["POST", "GET"])
def quiz_questions():
    db_connection = connect_to_database()
    # add the result of a question in a quiz
    if request.method == 'POST':
        # check whether quiz_id exist
        quiz_id = request.form['quiz_id']
        quiz_query = 'Select * from QuizRecords WHERE quiz_id=%s'
        quiz_result = execute_query(db_connection, quiz_query, (quiz_id,)).fetchall()
        if quiz_result is None:
            return 'No such quiz_id exist!'
        # check whether question_id exist
        question_id = request.form['question_id']
        question_query = 'Select * from Questions WHERE question_id=%s'
        question_result = execute_query(db_connection, question_query, (question_id,)).fetchall()
        if question_result is None:
            return 'No such question_id exist!'
        # insert a new row to the QuizQuestions table
        print('Add a row to the QuizQuestions table')
        quizQues_details = (
            request.form['quiz_id'],
            request.form['question_id'],
            request.form['result']
        )
        query = 'Insert into QuizQuestions (quiz_id, question_id, result) Values (%s,%s,%s)'
        status_info = insert_new_row(query, quizQues_details)
        if status_info == 'inserted OK':
            # select the last inserted row from the QuizQuestions table
            query = 'Select * from QuizQuestions where id = (select max(id) from QuizQuestions);'
            data_db = execute_query(db_connection, query).fetchall()
            # send data back to populate the result table
            return render_template('quizQuestions.html', values=data_db)
    
    # search function: search quiz_info by quiz_id 
    if request.method == 'GET':
        # check whether the email address exists
        quiz_id = request.args.get('quiz_id')
        print(quiz_id)
        query = 'Select * from QuizQuestions WHERE quiz_id=%s'
        data = (quiz_id,)
        quiz_info = execute_query(db_connection, query, data).fetchall()
        print(quiz_info)
        if quiz_info is None:
            return 'This quiz_id does not exist!'
        else:
            return render_template('quizQuestions.html', values=quiz_info)

@app.route("/api/question_accuracy", methods=["POST", "GET"])
def question_accuracy():
    db_connection = connect_to_database()
    question_id = request.args.get('ques_id')
    print(question_id)
    # if there is no parameter in the request, it means it requests all
    if question_id is None:
        query = (
            f'Select q.question_id, sum(ifnull(qzqs.result,0)) as total_score, ifnull(COUNT(qzqs.question_id),0) as frequency, '
            f'( ifnull(sum(qzqs.result) / COUNT(qzqs.question_id),0) ) as accuracy from QuizQuestions qzqs '
            f'RIGHT JOIN Questions q on qzqs.question_id = q.question_id '
            f'group by q.question_id;',
        )
        accuracy_all = execute_query(db_connection, query[0]).fetchall()
        print(accuracy_all)
        return render_template('quizQuestions.html', accuracy=accuracy_all)
    
    # question_id is sent along with the request
    query = 'Select * from Questions where question_id=%s'
    find_ques = execute_query(db_connection, query, (question_id,)).fetchall()
    print(find_ques)
    if find_ques is None:
        return 'This question id does not exsit!'
    query = (
        f'Select q.question_id, sum(ifnull(qzqs.result,0)) as total_score, ifnull(COUNT(qzqs.question_id),0) as frequency, '
        f'( ifnull(sum(qzqs.result) / COUNT(qzqs.question_id),0) ) as accuracy from QuizQuestions qzqs '
        f'RIGHT JOIN Questions q on qzqs.question_id = q.question_id '
        f'where q.question_id=%s '
        f'group by q.question_id;',
    )
    accuracy_one = execute_query(db_connection, query[0], (question_id,)).fetchall()
    return render_template('quizQuestions.html', accuracy=accuracy_one)


# ----------------------------------------------------
# ----------------------------------------------------
#      Questions Page
# ----------------------------------------------------
# ----------------------------------------------------

@app.route("/questions", methods=["GET"])
def questions_page():
    return render_template("questions.html")

@app.route("/api/questions", methods=["POST", "GET"])
def questions():
    db_connection = connect_to_database()

    # add a new question into a database
    if request.method == 'POST':
        # insert a new row to the Questions table
        print('Add a row to the Questions table')
        question_details = (
            request.form['state'],
            request.form['question_desc'],
            request.form['right_answer']
        )
        query = 'Insert into Questions (state, question_desc, question_right_answer) Values (%s,%s,%s)'
        cur = execute_query(db_connection, query, question_details)
        question_id = cur.lastrowid
        print(question_id)

        choices =[]
        if len(request.form['choice_1']) != 0:
            choices.append(request.form['choice_1'])
        if len(request.form['choice_2']) != 0:
            choices.append(request.form['choice_2'])
        if len(request.form['choice_3']) != 0:
            choices.append(request.form['choice_3'])
        print(choices)
        
        for choice in choices:
            query = 'Insert into QuestionChoices (question_id, choice_desc) Values (%s,%s)'
            data = (question_id, choice)
            execute_query(db_connection, query, data)
        
        if len(choices) == 3:
            return jsonify({
                'question_id': question_id,
                'state': question_details[0],
                'question_desc': question_details[1],
                'right_answer': question_details[2],
                'choice_1': choices[0],
                'choice_2': choices[1],
                'choice_3': choices[2]
            })
        else:
            return jsonify({
                'question_id': question_id,
                'state': question_details[0],
                'question_desc': question_details[1],
                'right_answer': question_details[2],
                'choice_1': choices[0],
                'choice_2': choices[1],
                'choice_3': '',
            })

    if request.method == 'GET':
        query_1 = (
            f'SELECT q.question_id, q.state, q.question_desc, q.question_right_answer, qc1.choice_desc as choice1, '
            f'qc2.choice_desc as choice2, qc3.choice_desc as choice3 '
            f'from Questions q '
            f'left join QuestionChoices qc1 on q.question_id = qc1.question_id '
            f'left join QuestionChoices qc2 on (qc1.question_id = qc2.question_id and qc1.choice_id < qc2.choice_id) '
            f'left join QuestionChoices qc3 on (qc2.question_id = qc3.question_id and qc2.choice_id < qc3.choice_id) '
            f'group by q.question_id',
        )
        result_1 = execute_query(db_connection, query_1[0]).fetchall()
        print(result_1)
        questions = []
        for row in result_1:
            questions.append({
                'question_id': row[0],
                'state': row[1],
                'question_desc': row[2],
                'right_answer': row[3],
                'choice_1': row[4],
                'choice_2':row[5],
                'choice_3': row[6],
            })
        print(questions)

        res = make_response(jsonify(questions))
        return res

@app.route('/api/questions/<int:id>', methods=['DELETE', 'PUT'])
def change_questions(id):
    db_connection = connect_to_database()
    # Delete questions
    if request.method == 'DELETE':
        print('Delete a question')
        query = "DELETE FROM Questions WHERE question_id = %s"
        data = (id,)
        result = execute_query(db_connection, query, data)
        print (str(result.rowcount) + "row deleted")
        return jsonify("delete ok")
 
    # update account
    elif request.method == 'PUT':
        print("Update a question!")
        question_id = id
        # first update the Questions table
        update_question = (
            request.form['state'],
            request.form['question_desc'],
            request.form['right_answer'],
            question_id
        )
        print(request.form)

        query = "UPDATE Questions SET state = %s, question_desc = %s, question_right_answer = %s WHERE question_id = %s"
        result = execute_query(db_connection, query, update_question)
        print(str(result.rowcount) + " row(s) updated")

        # then update the QuestionChoices table
        # group the updated choices
        update_choices =[]
        if len(request.form['choice_1']) != 0:
            update_choices.append(request.form['choice_1'])
        if len(request.form['choice_2']) != 0:
            update_choices.append(request.form['choice_2'])
        if len(request.form['choice_3']) != 0:
            update_choices.append(request.form['choice_3'])
        print(update_choices)

        # pull out the orginal choices for this particular question
        query = 'Select * from QuestionChoices where question_id=%s'
        rows = execute_query(db_connection, query, (question_id,)).fetchall()
        
        # execute SQL update
        i = 0
        for row in rows:
            query = 'UPDATE QuestionChoices SET choice_desc = %s WHERE choice_id = %s'
            data =(update_choices[i],row[0])
            execute_query(db_connection, query, data)
            i += 1

        # special case: add a new choice
        if len(update_choices) > len(rows):
            query = 'Insert into QuestionChoices (question_id, choice_desc) VALUES (%s,%s)'
            data = (question_id, update_choices[2])
            execute_query(db_connection, query, data)
        # special case: delete a choice
        if len(update_choices) < len(rows):
            query = 'Delete * from QuestionChoices where choice_id = %s '
            data = (rows[2][0])
            execute_query(db_connection, query, data)

        return jsonify({
            'state': update_question[0],
            'question_desc': update_question[1],
            'right_answer': update_question[2],
            'choice_1': update_choices[0],
            'choice_2': update_choices[1],
            'choice_3': update_choices[2],
        })


@app.route("/api/questions/search", methods=["GET"])
def search_question():
    db_connection = connect_to_database()
    # search function: search questions by keywords
    keywords = request.args.get('keywords')
    print(keywords)

    query1 = (
        f'SELECT q.question_id, q.state, q.question_desc, q.question_right_answer, qc1.choice_desc as choice1, '
        f'qc2.choice_desc as choice2, qc3.choice_desc as choice3 '
        f'from Questions q '
        f'join QuestionChoices qc1 on q.question_id = qc1.question_id '
        f'join QuestionChoices qc2 on (qc1.question_id = qc2.question_id and qc1.choice_id < qc2.choice_id) '
        f'join QuestionChoices qc3 on (qc2.question_id = qc3.question_id and qc2.choice_id < qc3.choice_id) '
        f'where q.question_desc like %s '
        f'group by q.question_id;',
    )
    data= str(keywords)
    print(data)
    result1 = execute_query(db_connection, query1[0], ('%'+data+'%',)).fetchall()
    print(result1)

    query2 = (
        f'SELECT q.question_id, q.state, q.question_desc, q.question_right_answer, qc1.choice_desc as choice1, '
        f'qc2.choice_desc as choice2, qc3.choice_desc as choice3 '
        f'from Questions q '
        f'join QuestionChoices qc1 on q.question_id = qc1.question_id '
        f'join QuestionChoices qc2 on (qc1.question_id = qc2.question_id and qc1.choice_id < qc2.choice_id) '
        f'where q.question_desc like %s '
        f'group by q.question_id;',
    )
    data= str(keywords)
    print(data)
    result2 = execute_query(db_connection, query2[0], ('%'+data+'%',)).fetchall()
    print(result2)


    if len(questions_info) == 0:
        return 'No matching result!'
    else:
        return render_template('questions.html', values=questions_info)





if __name__ == "__main__":
    # app.run(debug=True)
    app.run(debug=True, host='localhost', port=5000)
