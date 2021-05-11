-- These are some Database Manipulation queries for a partially implemented Project Website 
-- using the bsg database.
-- Your submission should contain ALL the queries required to implement ALL the
-- functionalities listed in the Project Specs.

-- 
-- User Page
-- Add a new user account
Insert into Users (user_name, user_password, user_email, regis_date)
Values (:nameInput, :pasInput, :emailInput, :dateInput);

-- Select user's information
Select * from Users
where regis_date >= :startDateInput and regis_date <= :endDateInput;

-- Look up a particular user's information
Select * from Users
where user_email=:emailInput;

-- For Update button
UPDATE Users (user_name, user_password, user_email, regis_date, active)
VALUES (:nameInput, :pasInput, :emailInput, :dateInput, :activeInput)

---For Delete button
Delete * from Users
where user_id in (
    Select user_id from Users
    where user_email=:emailInput;
);

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

-- get all characters and their homeworld name for the List People page
SELECT bsg_people.character_id, fname, lname, bsg_planets.name AS homeworld, age FROM bsg_people INNER JOIN bsg_planets ON homeworld = bsg_planets.planet_id

-- get a single character's data for the Update People form
SELECT character_id, fname, lname, homeworld, age FROM bsg_people WHERE character_id = :character_ID_selected_from_browse_character_page

-- get all character's data to populate a dropdown for associating with a certificate  
SELECT character_id AS pid, fname, lname FROm bsg_people 
-- get all certificates to populate a dropdown for associating with people
SELECT certification_id AS cid, title FROM bsg_cert

-- get all peoople with their current associated certificates to list
SELECT pid, cid, CONCAT(fname,' ',lname) AS name, title AS certificate 
FROM bsg_people 
INNER JOIN bsg_cert_people ON bsg_people.character_id = bsg_cert_people.pid 
INNER JOIN bsg_cert on bsg_cert.certification_id = bsg_cert_people.cid 
ORDER BY name, certificate

-- add a new character
INSERT INTO bsg_people (fname, lname, homeworld, age) VALUES (:fnameInput, :lnameInput, :homeworld_id_from_dropdown_Input, :ageInput)

-- associate a character with a certificate (M-to-M relationship addition)
INSERT INTO bsg_cert_people (pid, cid) VALUES (:character_id_from_dropdown_Input, :certification_id_from_dropdown_Input)

-- update a character's data based on submission of the Update Character form 
UPDATE bsg_people SET fname = :fnameInput, lname= :lnameInput, homeworld = :homeworld_id_from_dropdown_Input, age= :ageInput WHERE id= :character_ID_from_the_update_form

-- delete a character
DELETE FROM bsg_people WHERE id = :character_ID_selected_from_browse_character_page

-- dis-associate a certificate from a person (M-to-M relationship deletion)
DELETE FROM bsg_cert_people WHERE pid = :character_ID_selected_from_certificate_and_character_list AND cid = :certification_ID_selected_from-certificate_and_character_list
