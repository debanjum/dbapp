USE `aalavi_db`;

DROP TABLE IF EXISTS `Reviewer_Interest`;
DROP TABLE IF EXISTS `Manuscript_Reviewer`;
DROP TABLE IF EXISTS `Manuscript_Author`;
DROP TABLE IF EXISTS `RI_Code`;
DROP TABLE IF EXISTS `Manuscript`;
DROP TABLE IF EXISTS `Issue`;
DROP TABLE IF EXISTS `Person`;

CREATE TABLE IF NOT EXISTS `Person` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `type` smallint(6) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `affiliation` varchar(255) DEFAULT NULL,
  `mailing_address` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Issue` (
  `year` smallint(6) NOT NULL,
  `period` tinyint(4) NOT NULL,
  `volume` smallint(6) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `status` ENUM('Scheduled', 'Published') NOT NULL DEFAULT 'Scheduled',
  PRIMARY KEY (`year`,`volume`),
  KEY `fk_year_index` (`year`),
  KEY `fk_vol_index` (`volume`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Manuscript` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `description` text NOT NULL,
  `ri_code` int(11) NOT NULL,
  `status` ENUM('Submitted', 'Under Review', 'Accepted', 'Rejected', 'Typesetting', 'Scheduled', 'Published') NOT NULL,
  `issue_vol` smallint(6) DEFAULT NULL,
  `issue_year` smallint(6) DEFAULT NULL,
  `num_pages` int(11) DEFAULT NULL,
  `start_page` int(11) DEFAULT NULL,
  `date_changed` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `review_date` datetime DEFAULT NULL,
  `filename` varchar(255) NOT NULL DEFAULT 'placeholder.pdf',
  `assigned_editor` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_year_idx` (`issue_vol`,`issue_year`),
  CONSTRAINT `fk_issue` FOREIGN KEY (`issue_vol`, `issue_year`) REFERENCES `Issue` (`volume`, `year`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_editor` FOREIGN KEY (`assigned_editor`) REFERENCES `Person` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Manuscript_Author` (
  `manuscript_id` int(11) NOT NULL,
  `author_id` int(11) NOT NULL,
  `rank` smallint(6) NOT NULL,
  PRIMARY KEY (`manuscript_id`,`author_id`),
  KEY `author_id_idx` (`author_id`),
  CONSTRAINT `author_id` FOREIGN KEY (`author_id`) REFERENCES `Person` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `manuscript_id` FOREIGN KEY (`manuscript_id`) REFERENCES `Manuscript` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Manuscript_Reviewer` (
  `reviewer_id` int(11) NOT NULL,
  `manuscript_id` int(11) NOT NULL,
  `result` varchar(1) NOT NULL DEFAULT '-',
  `clarity` tinyint(4) DEFAULT NULL,
  `method` tinyint(4) DEFAULT NULL,
  `contribution` tinyint(4) DEFAULT NULL,
  `appropriate` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`reviewer_id`,`manuscript_id`),
  KEY `reviewer_id_idx` (`reviewer_id`),
  KEY `manuscript_id_idx` (`manuscript_id`),
  CONSTRAINT `fk_manuscript_id` FOREIGN KEY (`manuscript_id`) REFERENCES `Manuscript` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_reviewer_id` FOREIGN KEY (`reviewer_id`) REFERENCES `Person` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `RI_Code` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `interest` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Reviewer_Interest` (
  `reviewer_id` int(11) NOT NULL,
  `ri_code` int(11) NOT NULL,
  PRIMARY KEY (`reviewer_id`,`ri_code`),
  KEY `user_id_idx` (`reviewer_id`),
  KEY `ri_code_idx` (`ri_code`),
  CONSTRAINT `ri_code` FOREIGN KEY (`ri_code`) REFERENCES `RI_Code` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `user_id` FOREIGN KEY (`reviewer_id`) REFERENCES `Person` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: sunapee.cs.dartmouth.edu    Database: aalavi_db
-- ------------------------------------------------------
-- Server version	5.5.5-10.1.21-MariaDB

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
-- Dumping data for table `Issue`
--

LOCK TABLES `Issue` WRITE;
/*!40000 ALTER TABLE `Issue` DISABLE KEYS */;
INSERT INTO `Issue` (`year`, `period`, `volume`, `title`, `status`) VALUES (2016,4,1,'mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis','Published');
INSERT INTO `Issue` (`year`, `period`, `volume`, `title`, `status`) VALUES (2016,4,2,'justo morbi ut odio cras mi pede','Published');
INSERT INTO `Issue` (`year`, `period`, `volume`, `title`, `status`) VALUES (2017,1,1,'ornare consequat lectus in est risus auctor','Scheduled');
/*!40000 ALTER TABLE `Issue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Manuscript`
--

LOCK TABLES `Manuscript` WRITE;
/*!40000 ALTER TABLE `Manuscript` DISABLE KEYS */;
INSERT INTO `Manuscript` (`id`, `title`, `description`, `ri_code`, `status`, `issue_vol`, `issue_year`, `num_pages`, `start_page`, `date_changed`, `date_created`, `review_date`, `assigned_editor`) VALUES (1,'accumsan odio','In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.',92,'Under Review',NULL,NULL,NULL,NULL,'2017-04-26 16:24:18','2017-04-26 16:24:18','2017-04-27 16:24:18', 1);
INSERT INTO `Manuscript` (`id`, `title`, `description`, `ri_code`, `status`, `issue_vol`, `issue_year`, `num_pages`, `start_page`, `date_changed`, `date_created`, `review_date`, `assigned_editor`) VALUES (2,'sapien cum sociis natoque penatibus et magnis dis','Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.',31,'Accepted',NULL,NULL,NULL,NULL,'2017-04-26 16:24:18','2017-04-26 16:24:18','2017-04-26 22:24:18', 1);
INSERT INTO `Manuscript` (`id`, `title`, `description`, `ri_code`, `status`, `issue_vol`, `issue_year`, `num_pages`, `start_page`, `date_changed`, `date_created`, `review_date`, `assigned_editor`) VALUES (3,'a libero nam dui proin leo odio','Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.',94,'Rejected',NULL,NULL,NULL,NULL,'2017-04-26 16:24:18','2017-04-26 16:24:18','2017-04-26 20:24:18', 1);
INSERT INTO `Manuscript` (`id`, `title`, `description`, `ri_code`, `status`, `issue_vol`, `issue_year`, `num_pages`, `start_page`, `date_changed`, `date_created`, `review_date`, `assigned_editor`) VALUES (4,'integer ac leo','Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.',65,'Scheduled',1,2017,24,1,'2017-04-26 16:24:18','2017-04-26 16:24:18','2017-04-26 23:24:18', 1);
INSERT INTO `Manuscript` (`id`, `title`, `description`, `ri_code`, `status`, `issue_vol`, `issue_year`, `num_pages`, `start_page`, `date_changed`, `date_created`, `review_date`, `assigned_editor`) VALUES (5,'donec posuere metus vitae ipsum aliquam','Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.',82,'Typesetting',NULL,NULL,NULL,NULL,'2017-04-26 16:24:18','2017-04-26 16:24:18','2017-04-26 20:24:18', 1);
INSERT INTO `Manuscript` (`id`, `title`, `description`, `ri_code`, `status`, `issue_vol`, `issue_year`, `num_pages`, `start_page`, `date_changed`, `date_created`, `review_date`, `assigned_editor`) VALUES (6,'metus arcu adipiscing','Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.',74,'Published',1,2016,12,1,'2017-04-26 16:24:18','2017-04-26 16:24:18','2017-04-26 17:24:18', 1);
INSERT INTO `Manuscript` (`id`, `title`, `description`, `ri_code`, `status`, `issue_vol`, `issue_year`, `num_pages`, `start_page`, `date_changed`, `date_created`, `review_date`, `assigned_editor`) VALUES (7,'luctus et ultrices','Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.',64,'Published',2,2016,22,1,'2017-04-26 16:24:18','2017-04-26 16:24:18','2017-04-26 19:44:18', 1);
INSERT INTO `Manuscript` (`id`, `title`, `description`, `ri_code`, `status`, `issue_vol`, `issue_year`, `num_pages`, `start_page`, `date_changed`, `date_created`, `review_date`, `assigned_editor`) VALUES (8,'a feugiat et eros vestibulum','Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.',85,'Under Review',NULL,NULL,NULL,NULL,'2017-04-26 16:24:19','2017-04-26 16:24:19','2017-04-27 10:24:18', 1);
INSERT INTO `Manuscript` (`id`, `title`, `description`, `ri_code`, `status`, `issue_vol`, `issue_year`, `num_pages`, `start_page`, `date_changed`, `date_created`, `review_date`, `assigned_editor`) VALUES (9,'justo sollicitudin ut suscipit','In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.',20,'Submitted',NULL,NULL,NULL,NULL,'2017-04-26 16:24:19','2017-04-26 16:24:19',NULL, 1);
INSERT INTO `Manuscript` (`id`, `title`, `description`, `ri_code`, `status`, `issue_vol`, `issue_year`, `num_pages`, `start_page`, `date_changed`, `date_created`, `review_date`, `assigned_editor`) VALUES (10,'ut suscipit a feugiat et','Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.',66,'Submitted',NULL,NULL,NULL,NULL,'2017-04-26 16:24:19','2017-04-26 16:24:19',NULL, 1);
INSERT INTO `Manuscript` (`id`, `title`, `description`, `ri_code`, `status`, `issue_vol`, `issue_year`, `num_pages`, `start_page`, `date_changed`, `date_created`, `review_date`, `assigned_editor`) VALUES (11,'ut rhoncus aliquet','Fusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.',111,'Submitted',NULL,NULL,NULL,NULL,'2017-04-26 16:24:19','2017-04-26 16:24:19',NULL, 1);
INSERT INTO `Manuscript` (`id`, `title`, `description`, `ri_code`, `status`, `issue_vol`, `issue_year`, `num_pages`, `start_page`, `date_changed`, `date_created`, `review_date`, `assigned_editor`) VALUES (12,'at vulputate vitae nisl aenean lectus','Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.',68,'Submitted',NULL,NULL,NULL,NULL,'2017-04-26 16:24:19','2017-04-26 16:24:19',NULL, 1);
INSERT INTO `Manuscript` (`id`, `title`, `description`, `ri_code`, `status`, `issue_vol`, `issue_year`, `num_pages`, `start_page`, `date_changed`, `date_created`, `review_date`, `assigned_editor`) VALUES (13,'eget eros elementum pellentesque','Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.',25,'Submitted',NULL,NULL,NULL,NULL,'2017-04-26 16:24:19','2017-04-26 16:24:19',NULL, 1);
INSERT INTO `Manuscript` (`id`, `title`, `description`, `ri_code`, `status`, `issue_vol`, `issue_year`, `num_pages`, `start_page`, `date_changed`, `date_created`, `review_date`, `assigned_editor`) VALUES (14,'ut dolor morbi vel lectus in quam','Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.',86,'Submitted',NULL,NULL,NULL,NULL,'2017-04-26 16:24:19','2017-04-26 16:24:19',NULL, 1);
INSERT INTO `Manuscript` (`id`, `title`, `description`, `ri_code`, `status`, `issue_vol`, `issue_year`, `num_pages`, `start_page`, `date_changed`, `date_created`, `review_date`, `assigned_editor`) VALUES (15,'ut ultrices vel augue vestibulum ante ipsum','Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.',67,'Submitted',NULL,NULL,NULL,NULL,'2017-04-26 16:24:19','2017-04-26 16:24:19',NULL, 1);
INSERT INTO `Manuscript` (`id`, `title`, `description`, `ri_code`, `status`, `issue_vol`, `issue_year`, `num_pages`, `start_page`, `date_changed`, `date_created`, `review_date`, `assigned_editor`) VALUES (16,'vestibulum rutrum rutrum neque','Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.',15,'Submitted',NULL,NULL,NULL,NULL,'2017-04-26 16:24:19','2017-04-26 16:24:19',NULL, 1);
/*!40000 ALTER TABLE `Manuscript` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Manuscript_Author`
--

LOCK TABLES `Manuscript_Author` WRITE;
/*!40000 ALTER TABLE `Manuscript_Author` DISABLE KEYS */;
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (1,2,1);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (1,4,2);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (1,23,3);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (2,11,1);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (2,23,2);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (3,2,4);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (3,5,1);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (3,6,2);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (3,10,3);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (4,17,1);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (4,18,2);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (5,22,1);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (6,27,1);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (6,28,2);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (6,29,3);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (7,6,1);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (8,2,3);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (8,4,1);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (8,6,2);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (9,16,1);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (9,17,2);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (10,10,1);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (11,18,1);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (11,29,2);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (12,23,2);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (12,27,1);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (13,2,2);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (13,4,4);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (13,10,3);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (13,11,1);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (13,29,5);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (14,17,3);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (14,18,2);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (14,24,1);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (15,5,2);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (15,26,1);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (16,5,1);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (16,23,3);
INSERT INTO `Manuscript_Author` (`manuscript_id`, `author_id`, `rank`) VALUES (16,25,2);
/*!40000 ALTER TABLE `Manuscript_Author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Manuscript_Reviewer`
--

LOCK TABLES `Manuscript_Reviewer` WRITE;
/*!40000 ALTER TABLE `Manuscript_Reviewer` DISABLE KEYS */;
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (3,1,'-',NULL,NULL,NULL,NULL);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (3,2,'y',8,7,9,10);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (7,3,'n',5,5,5,6);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (7,4,'y',10,10,10,10);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (8,5,'y',8,8,8,8);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (8,6,'y',9,9,9,9);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (9,7,'y',10,10,10,10);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (9,8,'-',NULL,NULL,NULL,NULL);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (13,1,'-',NULL,NULL,NULL,NULL);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (13,2,'y',10,10,9,10);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (14,3,'n',2,4,6,8);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (14,4,'y',9,9,10,10);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (15,5,'y',9,9,9,9);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (15,6,'y',7,8,10,10);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (19,7,'y',10,10,10,10);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (19,8,'-',NULL,NULL,NULL,NULL);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (20,1,'-',NULL,NULL,NULL,NULL);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (20,2,'y',9,9,9,9);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (20,3,'n',1,1,2,3);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (21,4,'y',8,10,8,9);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (21,5,'y',8,10,9,7);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (30,6,'y',10,7,7,10);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (30,7,'y',9,9,9,9);
INSERT INTO `Manuscript_Reviewer` (`reviewer_id`, `manuscript_id`, `result`, `clarity`, `method`, `contribution`, `appropriate`) VALUES (30,8,'-',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `Manuscript_Reviewer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Person`
--

LOCK TABLES `Person` WRITE;
/*!40000 ALTER TABLE `Person` DISABLE KEYS */;
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (0,'Debanjum','Solanky',2,'dibz@dibbymail.dib','Dibby Dabby Doo','69 Dub Lane');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (1,'Tabby','Zannetti',1,'tzannetti0@mozilla.org','Ecole Nationale de la Statistique et de l\'Administration Economique','6 Moose Court');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (2,'Howard','Tappor',2,'htappor1@answers.com','William Tyndale College','9 Summer Ridge Pass');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (3,'Euell','Aleshintsev',3,'ealeshintsev2@slashdot.org','Central Academy of  Fine Art','2254 2nd Plaza');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (4,'Eben','Rolfe',2,'erolfe3@pbs.org','Universidad de Carabobo','2 Vidon Point');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (5,'Flem','Thompson',2,'fthompson4@squarespace.com','Escuela Superiore de Administración Pública','95879 Graceland Point');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (6,'Billie','Nieass',2,'bnieass5@spiegel.de','University of Kota','63703 Amoth Terrace');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (7,'Marylee','MacClure',3,'mmacclure6@simplemachines.org','Central Methodist College','2 Golf Plaza');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (8,'Michelina','Cousans',3,'mcousans7@yale.edu','2nd Military Medical University','258 Schurz Trail');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (9,'Ambros','Seeler',3,'aseeler8@bbc.co.uk','Indus Institute of Higher Education','4992 Prentice Terrace');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (10,'Cameron','Gladdish',2,'cgladdish9@webeden.co.uk','Federal University of Petroleum Resources','0 Ohio Plaza');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (11,'Jermain','Barnbrook',2,'jbarnbrooka@unesco.org','Carroll College Helena','2 Mosinee Park');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (12,'Bucky','Dummett',2,'bdummettb@over-blog.com','Université de Lubumbashi','471 Hallows Pass');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (13,'Fernando','Viste',3,'fvistec@goo.gl','Universitas Wisnuwardhana','680 Hoepker Circle');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (14,'Daffy','Kidston',3,'dkidstond@weibo.com','Kent State University - Stark','2 Johnson Road');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (15,'Dame','Yurenev',3,'dyureneve@surveymonkey.com','Northern Illinois University','99 Brentwood Alley');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (16,'Burg','Blaine',2,'bblainef@hc360.com','Metropolitan State University','841 Prairie Rose Parkway');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (17,'Willy','Vizor',2,'wvizorg@wikispaces.com','Universitas Negeri Surabaya','7 Mockingbird Road');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (18,'Amalea','Lempenny',2,'alempennyh@devhub.com','Sogang University','262 Moulton Crossing');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (19,'Gerty','Brittian',3,'gbrittiani@indiegogo.com','Tamil Nadu Dr. Ambedkar Law University','2378 Sunbrook Junction');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (20,'Lesya','Pietasch',3,'lpietaschj@google.com.br','Universidad Regiomontana','48 Westerfield Way');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (21,'Bealle','Schuster',3,'bschusterk@discovery.com','Jordan Academy of Music / Higher Institute of Music','2329 Elgar Junction');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (22,'Aloysius','Monckman',2,'amonckmanl@netvibes.com','Université de Toamasina','401 Moland Court');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (23,'Max','Massei',2,'mmasseim@chronoengine.com','Europäische Fachhochschule','41 Anzinger Terrace');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (24,'Jerrold','Gibbs',2,'jgibbsn@biblegateway.com','Universidad Privada San Pedro','774 West Point');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (25,'Lucien','Sudy',2,'lsudyo@cocolog-nifty.com','Midland Lutheran College','10 Bellgrove Alley');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (26,'Bette-ann','de Keep',2,'bdekeepp@globo.com','Debre Markos University','133 Elmside Crossing');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (27,'Valida','Balbeck',2,'vbalbeckq@sun.com','Ecole Supérieure de Physique et de Chimie Industrielles','032 Barby Drive');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (28,'Aili','Slimon',2,'aslimonr@facebook.com','Institut National des Sciences Appliquées de Lyon','367 Bashford Court');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (29,'Packston','Hartland',2,'phartlands@aboutads.info','Universidad Autónoma Metropolitana - Iztapalapa','686 Lake View Avenue');
INSERT INTO `Person` (`id`, `first_name`, `last_name`, `type`, `email`, `affiliation`, `mailing_address`) VALUES (30,'Sholom','Overshott',3,'sovershottt@arizona.edu','Turku School of Economics and Business Administration','922 Fieldstone Center');
/*!40000 ALTER TABLE `Person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `RI_Code`
--

LOCK TABLES `RI_Code` WRITE;
/*!40000 ALTER TABLE `RI_Code` DISABLE KEYS */;
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (1,'Agricultural engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (2,'Biochemical engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (3,'Biomechanical engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (4,'Ergonomics');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (5,'Food engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (6,'Bioprocess engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (7,'Genetic engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (8,'Human genetic engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (9,'Metabolic engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (10,'Molecular engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (11,'Neural engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (12,'Protein engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (13,'Rehabilitation engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (14,'Tissue engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (15,'Aquatic and environmental engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (16,'Architectural engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (17,'Civionic engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (18,'Construction engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (19,'Earthquake engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (20,'Earth systems engineering and management');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (21,'Ecological engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (22,'Environmental engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (23,'Geomatics engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (24,'Geotechnical engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (25,'Highway engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (26,'Hydraulic engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (27,'Landscape engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (28,'Land development engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (29,'Pavement engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (30,'Railway systems engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (31,'River engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (32,'Sanitary engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (33,'Sewage engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (34,'Structural engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (35,'Surveying');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (36,'Traffic engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (37,'Transportation engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (38,'Urban engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (39,'Irrigation and agriculture engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (40,'Explosives engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (41,'Biomolecular engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (42,'Ceramics engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (43,'Broadcast engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (44,'Building engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (45,'Signal Processing');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (46,'Computer engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (47,'Power systems engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (48,'Control engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (49,'Telecommunications engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (50,'Electronic engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (51,'Instrumentation engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (52,'Network engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (53,'Neuromorphic engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (54,'Engineering Technology');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (55,'Integrated engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (56,'Value engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (57,'Cost engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (58,'Fire protection engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (59,'Domain engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (60,'Engineering economics');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (61,'Engineering management');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (62,'Engineering psychology');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (63,'Ergonomics');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (64,'Facilities Engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (65,'Logistic engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (66,'Model-driven engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (67,'Performance engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (68,'Process engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (69,'Product Family Engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (70,'Quality engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (71,'Reliability engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (72,'Safety engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (73,'Security engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (74,'Support engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (75,'Systems engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (76,'Metallurgical Engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (77,'Surface Engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (78,'Biomaterials Engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (79,'Crystal Engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (80,'Amorphous Metals');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (81,'Metal Forming');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (82,'Ceramic Engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (83,'Plastics Engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (84,'Forensic Materials Engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (85,'Composite Materials');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (86,'Casting');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (87,'Electronic Materials');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (88,'Nano materials');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (89,'Corrosion Engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (90,'Vitreous Materials');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (91,'Welding');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (92,'Acoustical engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (93,'Aerospace engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (94,'Audio engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (95,'Automotive engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (96,'Building services engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (97,'Earthquake engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (98,'Forensic engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (99,'Marine engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (100,'Mechatronics');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (101,'Nanoengineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (102,'Naval architecture');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (103,'Sports engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (104,'Structural engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (105,'Vacuum engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (106,'Military engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (107,'Combat engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (108,'Offshore engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (109,'Optical engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (110,'Geophysical engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (111,'Mineral engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (112,'Mining engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (113,'Reservoir engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (114,'Climate engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (115,'Computer-aided engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (116,'Cryptographic engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (117,'Information engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (118,'Knowledge engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (119,'Language engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (120,'Release engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (121,'Teletraffic engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (122,'Usability engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (123,'Web engineering');
INSERT INTO `RI_Code` (`id`, `interest`) VALUES (124,'Systems engineering');
/*!40000 ALTER TABLE `RI_Code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Reviewer_Interest`
--

LOCK TABLES `Reviewer_Interest` WRITE;
/*!40000 ALTER TABLE `Reviewer_Interest` DISABLE KEYS */;
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (3,31);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (3,92);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (3,120);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (7,65);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (7,94);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (8,22);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (8,74);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (8,82);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (9,64);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (9,85);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (9,121);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (13,31);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (13,92);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (14,1);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (14,65);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (14,94);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (15,70);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (15,74);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (15,82);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (19,64);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (19,85);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (19,102);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (20,31);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (20,92);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (20,94);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (21,65);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (21,82);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (30,64);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (30,74);
INSERT INTO `Reviewer_Interest` (`reviewer_id`, `ri_code`) VALUES (30,85);
/*!40000 ALTER TABLE `Reviewer_Interest` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-04-28 20:03:18

USE `aalavi_db`;

-- Trigger 1
DELIMITER $$
DROP TRIGGER IF EXISTS Manuscript_No_RI $$
CREATE TRIGGER `Manuscript_No_RI` BEFORE INSERT ON `Manuscript` 
FOR EACH ROW 
BEGIN
DECLARE C INT;

SELECT COUNT(*) INTO C FROM Reviewer_Interest WHERE ri_code=NEW.ri_code;
  IF C = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Sorry, the paper can not be considered at this time';
  END IF;
END$$;
DELIMITER $$;

-- Trigger 2

DELIMITER $$

DROP TRIGGER IF EXISTS Person_AFTER_UPDATE $$

CREATE TRIGGER `Person_AFTER_UPDATE` AFTER UPDATE ON `Person`
FOR EACH ROW
BEGIN
DECLARE C INT;

IF (old.type = 3 AND new.type = 4) THEN
  SELECT count(manuscript_id) INTO C FROM (
    SELECT manuscript_id, count(*)
    FROM Manuscript_Reviewer
    WHERE manuscript_id IN (SELECT DISTINCT manuscript_id FROM Manuscript_Reviewer WHERE reviewer_id = old.id)
    GROUP BY manuscript_id
    HAVING count(*) = 1
  ) AS T1;
  
  IF C > 0 THEN    
    UPDATE Manuscript
    SET status = 'submitted'
    WHERE id IN (
      SELECT manuscript_id FROM (
        SELECT manuscript_id, count(*)
        FROM Manuscript_Reviewer
        WHERE manuscript_id IN (SELECT DISTINCT manuscript_id FROM Manuscript_Reviewer WHERE reviewer_id = old.id)
        GROUP BY manuscript_id
        HAVING count(*) = 1
        ) as T
    ) AND status = 'under_review';

    SIGNAL SQLSTATE '01000'
    SET MESSAGE_TEXT = 'Only Reviewer(s) assigned to Manuscript resigned, resetting status to \'submitted\'';
  END IF;

  DELETE FROM Manuscript_Reviewer WHERE reviewer_id = old.id AND result = '-';
END IF;
END$$;
DELIMITER $$;

