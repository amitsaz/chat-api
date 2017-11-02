USE challenge;

DROP TABLE IF EXISTS test;
DROP TABLE IF EXISTS MESSAGES;
DROP TABLE IF EXISTS USERS_MESSAGE_COUNT;
DROP TABLE IF EXISTS USERS;
DROP PROCEDURE IF EXISTS insertMessages;



CREATE TABLE test(col VARCHAR(10));

INSERT INTO test(col) VALUES('OK');

CREATE  TABLE  USERS (
   USER_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
   USERNAME VARCHAR(20) NOT NULL UNIQUE   ,
   PASSWD VARCHAR(32) NOT NULL ,
   CREATE_DATE DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
   LAST_UPDATED DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   INDEX IDX_USERNAME (USERNAME)

) ENGINE =INNODB ;

INSERT INTO USERS (USERNAME,PASSWD) VALUES ("JOHN",MD5("1PASSWD"));
INSERT INTO USERS (USERNAME,PASSWD) VALUES ("Mary",MD5("1PASSWD"));
INSERT INTO USERS (USERNAME,PASSWD) VALUES ("Tom",MD5("1PASSWD"));
INSERT INTO USERS (USERNAME,PASSWD) VALUES ("JOHN-2",MD5("1PASSWD"));
INSERT INTO USERS (USERNAME,PASSWD) VALUES ("JOHN-3",MD5("1PASSWD"));
INSERT INTO USERS (USERNAME,PASSWD) VALUES ("ERIC",MD5("1PASSWD"));
INSERT INTO USERS (USERNAME,PASSWD) VALUES ("ERROL",MD5("1PASSWD"));
INSERT INTO USERS (USERNAME,PASSWD) VALUES ("RICK",MD5("1PASSWD"));
INSERT INTO USERS (USERNAME,PASSWD) VALUES ("STEVE",MD5("1PASSWD"));
INSERT INTO USERS (USERNAME,PASSWD) VALUES ("Sean",MD5("1PASSWD"));
INSERT INTO USERS (USERNAME,PASSWD) VALUES ("KIM",MD5("1PASSWD"));
INSERT INTO USERS (USERNAME,PASSWD) VALUES ("Rock",MD5("1PASSWD"));
INSERT INTO USERS (USERNAME,PASSWD) VALUES ("DON",MD5("1PASSWD"));



CREATE  TABLE  USERS_MESSAGE_COUNT (
   MESSAGE_KEY VARCHAR(50) NOT NULL UNIQUE ,
   MESSAGE_COUNT INT NOT NULL ,
   LAST_UPDATED DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   INDEX IDX_USER_MSG_COUNT (MESSAGE_KEY)

) ENGINE =INNODB ;



CREATE  TABLE  MESSAGES (
   MESSAGE_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
   MESSAGE_KEY VARCHAR(50) NOT NULL  ,
   SENDER VARCHAR(20) NOT NULL ,
   RECEIVER VARCHAR(20) NOT NULL ,
   CREATE_DATE DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
   MESSAGE_TYPE ENUM ('TEXT','IMG','VIDEO') NOT NULL ,
   MESSAGE_VALUE VARCHAR(1000)  ,
   MESSAGE_META_DATA JSON DEFAULT NULL ,

   INDEX IDX_USER_TIME (MESSAGE_KEY,CREATE_DATE),
   FOREIGN KEY FK_SENDER(SENDER)
   REFERENCES USERS(USERNAME)
   ON UPDATE CASCADE ,

   FOREIGN KEY FK_RECEIVER(RECEIVER)
   REFERENCES USERS(USERNAME)
   ON UPDATE CASCADE ,

   FOREIGN KEY FK_MSG_KEY(MESSAGE_KEY)
   REFERENCES USERS_MESSAGE_COUNT(MESSAGE_KEY)
   ON UPDATE CASCADE

) ENGINE =INNODB ;


DELIMITER $$
CREATE PROCEDURE insertMessages()
BEGIN
  DECLARE v1 INT DEFAULT 10000;
  DECLARE ran1 varchar(20) ;
  DECLARE ran2 varchar(20) ;
  WHILE v1 > 0 DO
    SET ran1=(select ELT(0.5 + RAND() * 13, 'JOHN','Mary','Tom','JOHN-2','JOHN-3','ERIC','ERROL','RICK','STEVE','Sean','KIM','Rock','DON'));
    SET ran2=(select ELT(0.5 + RAND() * 13, 'JOHN','Mary','Tom','JOHN-2','JOHN-3','ERIC','ERROL','RICK','STEVE','Sean','KIM','Rock','DON'));
    INSERT INTO USERS_MESSAGE_COUNT (MESSAGE_KEY,MESSAGE_COUNT) VALUES(concat(ran1,":",ran2),1) ON DUPLICATE KEY UPDATE MESSAGE_COUNT=MESSAGE_COUNT+1;
    INSERT INTO MESSAGES (MESSAGE_KEY,SENDER,RECEIVER,MESSAGE_TYPE ,MESSAGE_VALUE) VALUES (concat(ran1,":",ran2),ran1,ran2,"text","Some not so random message");
    SET v1 = v1 - 1;
  END WHILE;
END $$

DELIMITER ;
call insertMessages() ;
