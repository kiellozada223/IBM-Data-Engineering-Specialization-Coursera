###FINAL PROJECT ADVANCED SQL TECHNIQUES###

SHOW DATABASES;
USE CHICAGO;

##Question 1: Write the structure of a query to create or replace a stored procedure called UPDATE_LEADERS_SCORE##
##that takes a in_School_ID parameter as an integer and a in_Leader_Score parameter as an integer.##

DELIMITER //
CREATE PROCEDURE UPDATE_LEADERS_SCORE (IN IN_SCHOOL_ID INT, IN IN_LEADERS_SCORE INT)

BEGIN

END //
DELIMITER ;

##Question 2:Inside your stored procedure, write a SQL statement to update the Leaders_Score field in the##
##CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID to the value in the in_Leader_Score parameter.##

DROP PROCEDURE UPDATE_LEADERS_SCORE;

DELIMITER //

CREATE PROCEDURE UPDATE_LEADERS_SCORE (IN IN_SCHOOL_ID INT, IN IN_LEADERS_SCORE INT)

BEGIN

	UPDATE CHICAGO_PUBLIC_SCHOOLS
    SET
		Leaders_Score = IN_LEADERS_SCORE
	WHERE
		School_ID = IN_SCHOOL_ID;
        
END //
DELIMITER ;

##Question 3:Inside your stored procedure, write a SQL IF statement to update the Leaders_Icon field ##
##in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID using the following information.##

DROP PROCEDURE UPDATE_LEADERS_SCORE;

DELIMITER //

CREATE PROCEDURE UPDATE_LEADERS_SCORE (IN IN_SCHOOL_ID INT, IN IN_LEADERS_SCORE INT)

BEGIN

	UPDATE CHICAGO_PUBLIC_SCHOOLS
    SET
		Leaders_Score = IN_LEADERS_SCORE
	WHERE
		School_ID = IN_SCHOOL_ID;
        
	IF
		IN_LEADERS_SCORE > 0 AND IN_LEADERS_SCORE < 20
	THEN
		UPDATE CHICAGO_PUBLIC_SCHOOLS
        SET
			Leaders_Icon = 'Very Weak'
		WHERE
			School_id = IN_SCHOOL_ID;
            
	ELSEIF
		IN_LEADERS_SCORE < 40
	THEN
		UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET
		Leaders_Icon = 'Weak'
	WHERE
		School_ID = IN_SCHOOL_ID;
        
	ELSEIF
		IN_LEADERS_SCORE < 60
	THEN
		UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET
		Leaders_Icon = 'Average'
	WHERE
		School_ID = IN_SCHOOL_ID;
        
	ELSEIF
		IN_LEADERS_SCORE < 80
	THEN
		UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET
		Leaders_Icon = 'Strong'
	WHERE
		School_ID = IN_SCHOOL_ID;
        
	ELSEIF
		IN_LEADERS_SCORE < 100
	THEN
		UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET
		Leaders_Icon = 'Very Strong'
	WHERE
		School_ID = IN_SCHOOL_ID;

	END IF;
END //
DELIMITER ;

##Question 4:Run your code to create the stored procedure.##
##Write a query to call the stored procedure, passing a valid school ID and a leader score of 50,##
##to check that the procedure works as expected.##
## Using School_ID 610334, Leaders_Icon = 'Weak' ##

SET SQL_SAFE_UPDATES = 0;

CALL UPDATE_LEADERS_SCORE(610334,50);

##Error: Data too long for column "Leaders_Icon" need UPDATE ###

ALTER TABLE CHICAGO_PUBLIC_SCHOOLS
MODIFY COLUMN Leaders_Icon VARCHAR(15);

CALL UPDATE_LEADERS_SCORE(610334,50);

##CHECK UPDATE ##

SELECT School_ID, Leaders_Score, Leaders_Icon FROM CHICAGO_PUBLIC_SCHOOLS WHERE School_ID = 610334;

## You realise that if someone calls your code with a score outside of the allowed range (0-99),##
##then the score will be updated with the invalid data and the icon will remain at its previous value.##
##There are various ways to avoid this problem, one of which is using a transaction.##

DROP PROCEDURE UPDATE_LEADERS_SCORE;

DELIMITER //

CREATE PROCEDURE UPDATE_LEADERS_SCORE (IN IN_SCHOOL_ID INT, IN IN_LEADERS_SCORE INT)

BEGIN
START TRANSACTION;
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET
	Leaders_Score = IN_LEADERS_SCORE
WHERE
	School_ID = IN_SCHOOL_ID;
    
	IF IN_LEADERS_SCORE > 0 AND IN_LEADERS_SCORE < 20
	THEN UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET
		Leaders_Icon = 'Very Weak'
	WHERE
		School_ID = IN_SCHOOL_ID;
    
	ELSEIF IN_LEADERS_SCORE < 40
	THEN UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET
		Leaders_Icon = 'Weak'
	WHERE
		School_ID = IN_SCHOOL_ID;
    
	ELSEIF IN_LEADERS_SCORE < 60
	THEN UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET
		Leaders_Icon = 'Average'
	WHERE
		School_ID = IN_SCHOOL_ID;

	ELSEIF IN_LEADERS_SCORE < 80
	THEN UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET
		Leaders_Icon = 'Strong'
	WHERE
		School_ID = IN_SCHOOL_ID;

	ELSEIF IN_LEADERS_SCORE < 100
	THEN UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET
		Leaders_Icon = 'Very Strong'
	WHERE
		School_ID = IN_SCHOOL_ID;
    
	ELSE
		ROLLBACK;
        
	END IF;
		COMMIT;
END //
DELIMITER ;

##CHECK PROCEDURE USING SAMPLE SCHOOL_ID=609735##
CALL UPDATE_LEADERS_SCORE(609735,101);
SELECT School_ID, Leaders_Score, Leaders_Icon FROM CHICAGO_PUBLIC_SCHOOLS WHERE School_ID = 609735;


    




