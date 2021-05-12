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
    where user_email=:email_from_update
);

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



-- Search questions by keywords
Begin transaction
    SELECT * from Questions q
        inner join QuestionChoices qc on q.question_id = qc.question_id
        where q.question_desc like '%alcohol%';
    SELECT c.choice_id, c.question_id, c.choice_desc from QuestionChoices c
        where c.question_id in (
            SELECT q.question_id from Questions q
            where q.question_desc like '%alcohol%'
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

--Lookup Simulator record
Select * from Simulators
where result_id = :resultInput AND user_id = :userInput AND grading = :gradingInput AND play_date = :playInput AND Scenario = :scenInput;

--Delete the Seacrhed Record
Delete * from Users 
where result_id in (
    Select result_id from Simulators
    where result_id = :resultInput AND user_id = :userInput AND grading = :gradingInput AND play_date = :playInput AND Scenario = :scenInput;
)

--QuizRecords Page
--add a new Record
Insert into QuizRecords (user_id, quiz_date, quiz_state, quiz_score)
Values (:useInput, :quizInput, :stateInput, :scoreInput);

--Lookup Quiz record
Select * from QuizRecords
where quiz_id = :qInput AND user_id = :uInput AND grading = :gInput AND play_date = :pInput AND Scenario = :sInput;

--Delete the Searched Record
Delete * from Users 
where quiz_id in (
    Select * from QuizRecords
    where quiz_id = :qInput AND user_id = :uInput AND grading = :gInput AND play_date = :pInput AND Scenario = :sInput;
)


-- get all Planet IDs and Names to populate the Homeworld dropdown
SELECT planet_id, name FROM bsg_planets

-- -- get all characters and their homeworld name for the List People page
-- SELECT bsg_people.character_id, fname, lname, bsg_planets.name AS homeworld, age FROM bsg_people INNER JOIN bsg_planets ON homeworld = bsg_planets.planet_id

-- -- get a single character's data for the Update People form
-- SELECT character_id, fname, lname, homeworld, age FROM bsg_people WHERE character_id = :character_ID_selected_from_browse_character_page

-- -- get all character's data to populate a dropdown for associating with a certificate  
-- SELECT character_id AS pid, fname, lname FROm bsg_people 
-- -- get all certificates to populate a dropdown for associating with people
-- SELECT certification_id AS cid, title FROM bsg_cert

-- -- get all peoople with their current associated certificates to list
-- SELECT pid, cid, CONCAT(fname,' ',lname) AS name, title AS certificate 
-- FROM bsg_people 
-- INNER JOIN bsg_cert_people ON bsg_people.character_id = bsg_cert_people.pid 
-- INNER JOIN bsg_cert on bsg_cert.certification_id = bsg_cert_people.cid 
-- ORDER BY name, certificate

-- -- add a new character
-- INSERT INTO bsg_people (fname, lname, homeworld, age) VALUES (:fnameInput, :lnameInput, :homeworld_id_from_dropdown_Input, :ageInput)

-- -- associate a character with a certificate (M-to-M relationship addition)
-- INSERT INTO bsg_cert_people (pid, cid) VALUES (:character_id_from_dropdown_Input, :certification_id_from_dropdown_Input)

-- -- update a character's data based on submission of the Update Character form 
-- UPDATE bsg_people SET fname = :fnameInput, lname= :lnameInput, homeworld = :homeworld_id_from_dropdown_Input, age= :ageInput WHERE id= :character_ID_from_the_update_form

-- -- delete a character
-- DELETE FROM bsg_people WHERE id = :character_ID_selected_from_browse_character_page

-- -- dis-associate a certificate from a person (M-to-M relationship deletion)
-- DELETE FROM bsg_cert_people WHERE pid = :character_ID_selected_from_certificate_and_character_list AND cid = :certification_ID_selected_from-certificate_and_character_list
