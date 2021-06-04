-- MySQL dump 10.16  Distrib 10.1.37-MariaDB, for Linux (x86_64)
--
-- Host: classmysql.engr.oregonstate.edu    Database: cs340_
-- ------------------------------------------------------
-- Server version	10.1.37-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Users` (
  `user_id` int(11) AUTO_INCREMENT,
  `user_name` varchar(255) NOT NULL,
  `user_password` varchar(255) NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `regis_date` date NOT NULL,
  `active` bool DEFAULT 0, 
  PRIMARY KEY (`user_id`),
  UNIQUE (`user_email`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
-- One email address can only register once.

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` (user_name, user_password, user_email, regis_date, active)
VALUES 
('Jing','ABC','zhenjing@oregonstate.edu','2020-05-09',1),
('Tim','ACK','nguyeti4@oregonstate.edu','2020-12-09',1),
('Dave','PASS','darnie@oregonstate.edu','2021-01-01',1);
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;
-- DATE - format YYYY-MM-DD

--
-- Table structure for table `Simulators`
--

DROP TABLE IF EXISTS `Simulators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Simulators` (
  `result_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `grading` bool NOT NULL,
  `play_date` date NOT NULL,
  `scenario_name` varchar(20),
  PRIMARY KEY (`result_id`),
  FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
-- Bool 1-True, 0-False

--
-- Dumping data for table `Simulators`
--

LOCK TABLES `Simulators` WRITE;
/*!40000 ALTER TABLE `Simulators` DISABLE KEYS */;
INSERT INTO `Simulators` (user_id, grading, play_date, scenario_name)
VALUES (1,1,'2020-09-05','Freeway'),
(2,1,'2020-06-09','Intersection'),
(3,1,'2019-11-01','Parking');
/*!40000 ALTER TABLE `Simulators` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Quiz_Records`
--

-- changed the table name to match our schema.
DROP TABLE IF EXISTS `QuizRecords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `QuizRecords` (
  `quiz_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `quiz_date` date NOT NULL,
  `quiz_state` varchar(20) NOT NULL,
  `quiz_score` int(11) NOT NULL,
  PRIMARY KEY (`quiz_id`),
  FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`) 
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QuizRecords`
--

LOCK TABLES `QuizRecords` WRITE;
/*!40000 ALTER TABLE `QuizRecords` DISABLE KEYS */;
INSERT INTO `QuizRecords` (user_id, quiz_date, quiz_state, quiz_score)
VALUES 
(1,'2019-09-05','California',100),
(2,'2012-06-09','Oregon',90),
(3,'2018-11-01','California',85);
/*!40000 ALTER TABLE `QuizRecords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Questions`
--

DROP TABLE IF EXISTS `Questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Questions` (
  `question_id` int(11) NOT NULL AUTO_INCREMENT,
  `state` varchar(100) NOT NULL,
  `question_desc` TEXT(255),
  `question_right_answer` TEXT(255) NOT NULL,
  PRIMARY KEY (`question_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Questions`
--

LOCK TABLES `Questions` WRITE;
/*!40000 ALTER TABLE `Questions` DISABLE KEYS */;
INSERT INTO Questions (state, question_desc, question_right_answer)
VALUES
('Universal','You may cross double yellow lines to pass another vehicle if the:', 'Yellow line next to your side of the road is broken.'),
('California','Any amount of alcohol in the blood may affect a driver:', 'Judgment and physical coordination.'),
('Oregon','Backing your vehicle is:','Always dangerous.');
/*!40000 ALTER TABLE `Questions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

--
-- Table structure for table `QuestionChoices`
--

DROP TABLE IF EXISTS `QuestionChoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `QuestionChoices` (
  `choice_id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) NOT NULL,
  `choice_desc` TEXT(255) NOT NULL,
  PRIMARY KEY (`choice_id`),
  FOREIGN KEY (`question_id`) REFERENCES `Questions` (`question_id`) 
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QuizChoices`
--

LOCK TABLES `QuestionChoices` WRITE;
/*!40000 ALTER TABLE `QuizChoices` DISABLE KEYS */;
INSERT INTO `QuestionChoices` (question_id, choice_desc)
VALUES (1, 'Vehicle in front of you moves to the right to let you pass.'),
(1, 'Yellow line next to your side of the road is broken.'),
(1, 'Yellow line next to the opposite side of the road is broken.'),
(2, 'Right-of-way privileges.'),
(2, 'Judgment and physical coordination.'),
(2, 'Knowledge.'),
(3, 'Always dangerous.'),
(3, 'Dangerous if you have a helper.'),
(3, 'Only dangerous in large vehicles.');
/*!40000 ALTER TABLE `QuizChoices` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;


--
-- Table structure for table `QuizQuestions`
--

DROP TABLE IF EXISTS `QuizQuestions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `QuizQuestions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quiz_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `result` bool NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`quiz_id`) REFERENCES `QuizRecords` (`quiz_id`),
  FOREIGN KEY (`question_id`) REFERENCES `Questions` (`question_id`) 
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `QuizQuestions`
--

LOCK TABLES `QuizQuestions` WRITE;
/*!40000 ALTER TABLE `QuizQuestions` DISABLE KEYS */;
INSERT INTO `QuizQuestions` (quiz_id, question_id, result)
VALUES (1, 1, 1),
(1, 2, 1),
(2, 1, 1),
(2, 2, 0),
(3, 1, 0),
(3, 3, 1);
/*!40000 ALTER TABLE `QuizQuestions` ENABLE KEYS */;
UNLOCK TABLES;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-02-03  0:38:33

-- Alter Table QuizRecords On DELETE CASCADE
SHOW CREATE TABLE QuizRecords;
ALTER TABLE QuizRecords DROP FOREIGN KEY QuizRecords_ibfk_1;
ALTER TABLE QuizRecords ADD CONSTRAINT FK_UserQuiz FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE cascade;


-- Alter Table Simulators On DELETE CASCADE
SHOW CREATE TABLE Simulators;

ALTER TABLE Simulators DROP FOREIGN KEY Simulators_ibfk_1;
--ALTER TABLE Simulators ADD CONSTRAINT FK_UserSim FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE cascade;
ALTER TABLE Simulators MODIFY user_id INT;
--ALTER TABLE Simulators DROP FOREIGN KEY FK_UserSim;
ALTER TABLE Simulators ADD CONSTRAINT FK_UserSim FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE SET NULL;


-- Alter Table QuizRecords On DELETE CASCADE
SHOW CREATE TABLE QuizRecords;

ALTER TABLE QuizRecords DROP FOREIGN KEY QuizRecords_ibfk_1;
--ALTER TABLE QuizRecords ADD CONSTRAINT FK_UserRec FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE cascade;
ALTER TABLE QuizRecords MODIFY user_id INT;
--ALTER TABLE QuizRecords DROP FOREIGN KEY FK_UserRec;
ALTER TABLE QuizRecords ADD CONSTRAINT FK_UserRec FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE SET NULL;


-- Alter Table QuizRecords On DELETE CASCADE
SHOW CREATE TABLE QuizQuestions;
ALTER TABLE QuizQuestions DROP FOREIGN KEY QuizQuestions_ibfk_1;
ALTER TABLE QuizQuestions DROP FOREIGN KEY QuizQuestions_ibfk_2;
ALTER TABLE QuizQuestions ADD CONSTRAINT FK_LinkQuiz FOREIGN KEY (quiz_id) REFERENCES QuizRecords (quiz_id) ON DELETE cascade;
ALTER TABLE QuizQuestions ADD CONSTRAINT FK_LinkQuestion FOREIGN KEY (question_id) REFERENCES Questions (question_id) ON DELETE Cascade;
