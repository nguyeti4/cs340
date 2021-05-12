-- These are some Database Manipulation queries for a partially implemented Project Website 
-- using the bsg database.
-- Your submission should contain ALL the queries required to implement ALL the
-- functionalities listed in the Project Specs.

-- 
-- User Page
-- Add a new user account
Insert into Users (user_name, user_password, user_email, regis_date)
Values (:nameInput, :passInput, :emailInput, :dateInput);

-- Select user's information
-- test case: replace :startdateInput with '2001-01-01', :enddateInput with '2021-12-31'
Select regis_date, COUNT(user_id) as new_customers
from Users
where regis_date >= :startdateInput and regis_date <= :enddateInput
group by regis_date;

-- Look up a particular user's information
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
where user_id = (
    Select user_id from Users
    where user_email=:email_from_update;
);

-- Quiz Detail Page
-- Add a Question from a Quiz Manually 
Insert into QuizQuestions (quiz_id, question_id, result)
Values (:quiz_idInput, :ques_idInput, :resultInput);

-- Look up a particular quiz's information
Select quiz_id, question_id, result from QuizQuestions
where quiz_id=:quiz_idInput;

-- Calculate a particular question's accuracy
-- test case: replace :question_idInput with 7
Select q.question_id, sum(qzqs.result) as total_score, COUNT(qzqs.question_id) as frequency, ( sum(qzqs.result) / COUNT(qzqs.question_id) ) as accuracy
from QuizQuestions qzqs
RIGHT JOIN Questions q on qzqs.question_id = q.question_id 
where q.question_id = :question_idInput
group by q.question_id;

-- Calculate all questions' accuracy
Select q.question_id, sum(qzqs.result) as total_score, COUNT(qzqs.question_id) as frequency, ( sum(qzqs.result) / COUNT(qzqs.question_id) ) as accuracy
from QuizQuestions qzqs
RIGHT JOIN Questions q on qzqs.question_id = q.question_id
group by q.question_id;

-- For Delete Data from the database
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
    SELECT @questionID = ();
    Insert into QuestionChoices (question_id, choice_desc) VALUES (@questionID, :choice1Input);
    Insert into QuestionChoices (question_id, choice_desc) VALUES (@questionID, :choice2Input);
    Insert into QuestionChoices (question_id, choice_desc) VALUES (@questionID, :choice3Input);
    Insert into QuestionChoices (question_id, choice_desc) VALUES (@questionID, :choice4Input);
COMMIT

-- Search questions by keywords
Begin transaction
    SELECT q.question_id, q.question_desc, q.question_right_answer from Questions q
        where q.question_desc like '%keyword%';
    SELECT c.choice_id, c.question_id, c.choice_desc from QuestionChoices c
        where c.question_id in (
            SELECT q.question_id from Questions q
            where q.question_desc like '%keyword%'
        );
COMMIT

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



    




















-- -- get all Planet IDs and Names to populate the Homeworld dropdown
-- SELECT planet_id, name FROM bsg_planets

--Simulator Page
--add a new Record
Insert into Simulators (user_id, grade, play_date, scenario)
Values (:IDInput, :gradeInput, :dateInput, :sceneInput);

--Lookup Simulator record by scenario name
Select * from Simulators
where Scenario = :scenInput;

--Lookup Simulator records you want to delete
Select * from Simulators
where playdate = :play_from_update;

--Delete the Searched Record
Delete * from Simulators 
where playdate < :play_from_update

--QuizRecords Page
--add a new Record
Insert into QuizRecords (user_id, quiz_date, quiz_state, quiz_score)
Values (:useInput, :quizInput, :stateInput, :scoreInput);

--Lookup all Quiz records by state
Select * from QuizRecords where quiz_state = :State_input

--Lookup all Quiz records by date
Select * from QuizRecords where quiz_date < :quiz_delete_input

--Delete the Searched records that are older than specified date
Delete * from QuizRecords
where quiz_date < :quiz_delete_input


