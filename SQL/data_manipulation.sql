-- These are some Database Manipulation queries for a partially implemented Project Website 
-- using the bsg database.
-- Your submission should contain ALL the queries required to implement ALL the
-- functionalities listed in the Project Specs.

-- 
-- User Page
-- Add a new user account
Insert into Users (user_name, user_password, user_email, regis_date)
Values (:nameInput, :passInput, :emailInput, :dateInput);

-- Select user's information  '2001-01-01', '2021-12-31' 
-- test case: replace :startdateInput with '2001-01-01', :enddateInput with '2021-12-31'
-- this query work, but I disabled this function in our website
Select regis_date, COUNT(user_id) as new_customers
from Users
where regis_date >= :startdateInput and regis_date <= :enddateInput
group by regis_date;

-- Look up a particular user's information by user_email
-- this query work, but I disabled this function in our website
Select * from Users
where user_email=:emailInput;

-- For Update button
UPDATE Users 
SET (user_name=:name_from_update, 
user_password=:pass_from_update, 
user_email=:email_from_update, 
regis_date=:date_from_update, 
active=:active_from_update)
WHERE user_id = :userid_from_update

---For Delete button
Delete from Users
where user_id = :userID_from_update;

-- Quiz Detail Page
-- Add a Question from a Quiz Manually 
Insert into QuizQuestions (quiz_id, question_id, result)
Values (:quiz_idInput, :ques_idInput, :resultInput);

-- select all data from this table to display on the webpage
SELECT * FROM QuizQuestions;

-- UPDATE the resulf of a question in a quiz
UPDATE QuizQuestions SET result = :userInput WHERE id = :fromRequest;

-- DELETE a record
DELETE FROM QuizQuestions WHERE id = :fromRequest;



-- Look up a particular quiz's information
-- this query work, but I disabled this function in our website
Select quiz_id, question_id, result from QuizQuestions
where quiz_id=:quiz_idInput;

-- Calculate a particular question's accuracy 
-- test case: replace :question_idInput with 1
-- this query work, but I disabled this function in our website
Select q.question_id, sum(qzqs.result) as total_score, COUNT(qzqs.question_id) as frequency, ( sum(qzqs.result) / COUNT(qzqs.question_id) ) as accuracy
from QuizQuestions qzqs
RIGHT JOIN Questions q on qzqs.question_id = q.question_id 
where q.question_id = :question_idInput
group by q.question_id;

-- Calculate all questions' accuracy
-- this query work, but I disabled this function in our website
Select q.question_id, sum(qzqs.result) as total_score, COUNT(qzqs.question_id) as frequency, ( sum(qzqs.result) / COUNT(qzqs.question_id) ) as accuracy
from QuizQuestions qzqs
RIGHT JOIN Questions q on qzqs.question_id = q.question_id
group by q.question_id;

-- For Delete Data from the database
-- this query work, but I disabled this function in our website
Delete from QuizQuestions qzqs
where qzqs.quiz_id in (
    Select qr.quiz_id from QuizRecords qr
    where qr.quiz_date >=:startDateInput and qr.quiz_date <= :enddateInput
);


-- For Questions page
-- Add a new question (insert into Questions and QuestionChoices at one transaction)
Begin transaction
    DECLARE @questionID int;
    insert into Questions (state, question_desc, question_right_answer)
    values (:stateInput, :descInput, :ansInput);
    @questionID = (select max(question_id) from Questions);
    IF (:choice1Input is not null)
    Begin
    True Insert into QuestionChoices (question_id, choice_desc) VALUES (@questionID, :choice1Input);
    end
    IF (:choice2Input is not null)
    Begin
    True Insert into QuestionChoices (question_id, choice_desc) VALUES (@questionID, :choice2Input);
    end
    IF (:choice3Input is not null)
    Begin
    True Insert into QuestionChoices (question_id, choice_desc) VALUES (@questionID, :choice3Input);
    end
    IF (:choice4Input is not null)
    Begin
    True Insert into QuestionChoices (question_id, choice_desc) VALUES (@questionID, :choice4Input);
    end
COMMIT

-- select all questions
SELECT q.question_id, q.state, q.question_desc, q.question_right_answer, qc1.choice_desc as choice1,
qc2.choice_desc as choice2, qc3.choice_desc as choice3
from Questions q 
left join QuestionChoices qc1 on q.question_id = qc1.question_id
left join QuestionChoices qc2 on (qc1.question_id = qc2.question_id and qc1.choice_id < qc2.choice_id)
left join QuestionChoices qc3 on (qc2.question_id = qc3.question_id and qc2.choice_id < qc3.choice_id)
group by q.question_id;


-- Delete a question
Delete from Questions where question_id = :questionID_from_update;
Delete from QuestionChoices where question_id = :questionID_from_update;

-- update a question
Update Questions
set question_desc = :des_from_update, question_right_answer = :ans_from_update
where question_id = :id_from_update;

Update QuestionChoices
set choice_desc = :choice_des_from_update
where question_id = :id_from_update and choice_id = :choice_id_from_update;

--
--Simulators Page
--

--display all current sim records
SELECT * FROM Simulators

--add a new Record (where user_id is not NULL)
Insert into Simulators (user_id, grading, play_date, scenario_name)
Values (:IDInput, :gradeInput, :dateInput, :sceneInput);

--add a new Record (where user_id is NULL)
--in the event user decides not to run a simulator use this query
--:IDInput is set to NULL
Insert into Simulators (user_id, grading, play_date, scenario_name)
Values (NULL, :gradeInput, :dateInput, :sceneInput);

--Filter Simulator record by scenario name
Select * from Simulators
where scenario_name = :scenInput;

--Display a form to update simulator record
--The form displays info on the row to be updated, where the row result_id (Primary Key) equals :updateResult
SELECT user_id, grading, play_date, scenario_name FROM Simulators WHERE result_id = :updateResult;

--Update Simulator Record
--:updateResult is the same input used in line 149
UPDATE Simulators 
SET user_id = :updateID, grading = :updateGrade, play_date = :updateplay, scenario_name = :updatescenario WHERE result_id = :updateResult;

--Update Simulator Record (where user_id is NULL)
--:updateResult is the same input used in line 149
--if doesn't play the simulator, set user_id to NULL
UPDATE Simulators 
SET user_id = NULL, grading = :updateGrade, play_date = :updateplay, scenario_name = :updatescenario WHERE result_id = :updateResult;

--Delete the Searched sims by id
--where :sim_delete_input is the result_id of the row you want deleted
Delete from Simulators
where result_id = :sim_delete_input;


--
--QuizRecords Page
--

--display all current quiz records
SELECT * FROM QuizRecords

--add a new Record (where user_id s not NULL)
Insert into QuizRecords (user_id, quiz_date, quiz_state, quiz_score)
Values (:useInput, :quizInput, :stateInput, :scoreInput);

--add a new Record (where user_id is NULL)
--in the event user decides not to do a quiz use this query
--:useInput is set to NULL
Insert into QuizRecords (user_id, quiz_date, quiz_state, quiz_score)
Values (NULL, :quizInput, :stateInput, :scoreInput);

--Filter all Quiz records by state
Select * from QuizRecords where quiz_state = :State_input;

--Display a form to update quiz record
--The form displays info on the row to be updated, where the row quiz_id (Primary Key) equals :updateQuiz
SELECT user_id, quiz_date, quiz_state, quiz_score FROM QuizRecords WHERE quiz_id = :updateQuiz;

--Update QuizRecord record
--:updateQuiz is the same input used in line 178
UPDATE QuizRecords
SET user_id = :updateID, quiz_date = :update_quiz_date, quiz_state = :updatestate, quiz_score = :updatescene WHERE quiz_id = :updateQuiz;

--Update QuizRecord record (where user_id is NULL)
--:updateQuiz is the same input used in line 178
--if doesn't do the Quiz, set user_id to NULL
UPDATE QuizRecords
SET user_id = NULL, quiz_date = :update_quiz_date, quiz_state = :updatestate, quiz_score = :updatescene WHERE quiz_id = :updateQuiz;

--Delete the Searched records by id
--where :quiz_delete_input is the quiz_id of the row you want deleted
Delete from QuizRecords
where quiz_id = :quiz_delete_input;

