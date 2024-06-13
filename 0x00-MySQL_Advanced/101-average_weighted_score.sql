-- QL script that creates a stored procedure ComputeAverageWeightedScoreForUsers
-- that computes and store the average weighted score for all students.
-- ComputeAverageWeightedScoreForUsers does not take any input


DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;

DELIMITER //

-- Create the procedure
CREATE PROCEDURE ComputeAverageWeightedScoreForUsers ()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE user_id INT;
    DECLARE total_weighted_score FLOAT;
    DECLARE total_weight FLOAT;
    DECLARE average_weighted_score FLOAT;

    -- Cursor to fetch user_ids from users table
    DECLARE cur CURSOR FOR
        SELECT id
        FROM users;

    -- Declare continue handler to exit loop when no more rows to fetch
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    -- Loop through each user_id
    read_loop: LOOP
        FETCH cur INTO user_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Calculate total weighted score and total weight for the user
        SELECT SUM(corrections.score * projects.weight) INTO total_weighted_score
        FROM corrections
        INNER JOIN projects projects ON corrections.project_id = projects.id
        WHERE corrections.user_id = user_id;

        -- Calculate total weight for the user
        SELECT SUM(projects.weight) INTO total_weight
        FROM corrections
        INNER JOIN projects projects ON corrections.project_id = projects.id
        WHERE corrections.user_id = user_id;

        -- Calculate average weighted score
        IF total_weight > 0 THEN
            SET average_weighted_score = total_weighted_score / total_weight;
        ELSE
            SET average_weighted_score = 0; -- Handle division by zero case
        END IF;

        -- Update the average_score for the user in the users table
        UPDATE users
        SET average_score = average_weighted_score
        WHERE id = user_id;
    END LOOP;

    CLOSE cur;
    
END //

-- Reset delimiter to default
DELIMITER ;
