-- SQL script that creates a stored procedure ComputeAverageWeightedScoreForUser
-- that computes and store the average weighted score for a student.
-- Procedure ComputeAverageWeightedScoreForUser is taking 1 input: user_id, a users.id value 

DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;

DELIMITER //

-- Create the procedure
CREATE PROCEDURE ComputeAverageWeightedScoreForUser (IN user_id INT)
BEGIN
    DECLARE total_weighted_score FLOAT DEFAULT 0;
    DECLARE total_weight INT DEFAULT 0;
    DECLARE average_weighted_score FLOAT DEFAULT 0;

    -- Calculate total weighted score
    SELECT SUM(corrections.score * projects.weight) INTO total_weighted_score
    FROM corrections
    INNER JOIN projects projects ON corrections.project_id = projects.id
    WHERE corrections.user_id = user_id;

    -- Calculate total weight
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
    
END //
