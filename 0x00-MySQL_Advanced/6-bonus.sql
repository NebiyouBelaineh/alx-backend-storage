-- SQL script that creates a stored procedure AddBonus that adds a new correction for a student.
-- Procedure AddBonus takes three inputs: user_id, project_name, and score.

DELIMITER //

CREATE PROCEDURE AddBonus (IN p_user_id INT, IN p_project_name VARCHAR(255), IN p_score INT)
BEGIN
    -- Check if project exists
    DECLARE project_exists BOOLEAN;
    DECLARE proj_id INT;

    SET project_exists = EXISTS (SELECT 1 FROM `projects` WHERE `name` = p_project_name);
    
    -- Checks if project exists
    IF project_exists THEN
        -- Insert new corrections with the project id
        SET proj_id = (SELECT `id` FROM `projects` WHERE ( `name` = p_project_name ) );

        INSERT INTO `corrections` (`user_id`, `project_id`, `score`) VALUES ( p_user_id, proj_id, p_score );

    ELSE
        -- Create project and then insert new correction with the project id
        INSERT INTO `projects` (`name`) VALUES (p_project_name);
        SET proj_id = LAST_INSERT_ID();

        -- Insert new correction with project id
        INSERT INTO `corrections` (`user_id`, `project_id`, `score`) VALUES ( p_user_id, proj_id, p_score );
    END IF;

END // 

DELIMITER ;
