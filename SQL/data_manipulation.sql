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
Select regis_date, COUNT(user_id) as new_customers
from Users
where regis_date >= :startdateInput and regis_date <= :enddateInput
group by regis_date;

-- Look up a particular user's information by user_email
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

-- Look up a particular quiz's information
Select quiz_id, question_id, result from QuizQuestions
where quiz_id=:quiz_idInput;

-- Calculate a particular question's accuracy 
-- test case: replace :question_idInput with 1
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

-- Search questions by keywords: testcase - 'alcohol'
SELECT q.question_id, q.state, q.question_desc, q.question_right_answer, qc1.choice_desc as choice1,
qc2.choice_desc as choice2, qc3.choice_desc as choice3
from Questions q 
join QuestionChoices qc1 on q.question_id = qc1.question_id
join QuestionChoices qc2 on (qc1.question_id = qc2.question_id and qc1.choice_id < qc2.choice_id)
join QuestionChoices qc3 on (qc2.question_id = qc3.question_id and qc2.choice_id < qc3.choice_id)
where (q.question_desc like '%alcohol%')
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

--Simulator Page
--add a new Record
Insert into Simulators (user_id, grading, play_date, scenario_name)
Values (:IDInput, :gradeInput, :dateInput, :sceneInput);

--Lookup Simulator record by scenario name
Select * from Simulators
where Scenario = :scenInput;

--Lookup Simulator records you want to delete
Select * from Simulators where play_date <= :play_from_update;

--Delete the Searched quiz records that are older than play_date
Delete * from Simulators 
where play_date < :play_from_update;

--QuizRecords Page
--add a new Record
Insert into QuizRecords (user_id, quiz_date, quiz_state, quiz_score)
Values (:useInput, :quizInput, :stateInput, :scoreInput);

--Lookup all Quiz records by state
Select * from QuizRecords where quiz_state = :State_input;

--Lookup all Quiz records by date
Select * from QuizRecords 
where quiz_date <= :quiz_delete_input;

--Delete the Searched records that are older than quiz_date
Delete * from QuizRecords
where quiz_date < :quiz_delete_input;

-- Alter Table QuizRecords On DELETE CASCADE
SHOW CREATE TABLE QuizRecords;
ALTER TABLE QuizRecords DROP FOREIGN KEY QuizRecords_ibfk_1;
ALTER TABLE QuizRecords ADD CONSTRAINT FK_UserQuiz FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE cascade;



-- Alter Table Simulators On DELETE CASCADE
SHOW CREATE TABLE Simulators;
ALTER TABLE Simulators DROP FOREIGN KEY Simulators_ibfk_1;
ALTER TABLE Simulators ADD CONSTRAINT FK_UserSim FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE cascade;


-- Alter Table QuizRecords On DELETE CASCADE
show create table QuizQuestions;
ALTER TABLE QuizQuestions DROP FOREIGN KEY QuizQuestions_ibfk_1;
ALTER TABLE QuizQuestions DROP FOREIGN KEY QuizQuestions_ibfk_2;
ALTER TABLE QuizQuestions ADD CONSTRAINT FK_LinkQuiz FOREIGN KEY (quiz_id) REFERENCES QuizRecords (quiz_id) ON DELETE cascade;
ALTER TABLE QuizQuestions ADD CONSTRAINT FK_LinkQuestion FOREIGN KEY (question_id) REFERENCES Questions (question_id) ON DELETE Cascade;