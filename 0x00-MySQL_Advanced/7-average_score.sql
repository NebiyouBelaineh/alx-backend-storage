-- SQL script that creates a stored procedure ComputeAverageScoreForUser that computes
-- and store the average score for a student.
-- ComputeAverageScoreForUser takes 1 input: user_id

DELIMITER //

CREATE PROCEDURE ComputeAverageScoreForUser ( IN p_user_id INT )
BEGIN
    -- get all students with the user_id provided and store it to a variable
    DECLARE average FLOAT;
    SET average = (SELECT AVG(`score`) FROM `corrections` WHERE ( `user_id` = p_user_id ));

    UPDATE `users`
    SET `average_score` = average
    WHERE `id` =  p_user_id;

END //

DELIMITER ;