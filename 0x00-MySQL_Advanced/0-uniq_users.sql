-- sql script that creates a table 'users' with
-- id INT, email string(255 characters) and name string(255 characters)
-- if table already exists, script should not fail
-- script can be executed on any database

CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255)
)
