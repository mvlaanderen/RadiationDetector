-- Database installation query. PLEASE CHANGE THE PASSWORD IN ROW 8 OF THIS SCRIPT AND MAKE SURE YOU SPECIFY IT IN THE CONFIG.INI FILE!


-- Create the database
CREATE DATABASE IF NOT EXISTS raddetect;

-- Create new user
CREATE USER 'raddetectuser'@'%' IDENTIFIED BY 'ChangeMe';

-- Grant the user access to the database
GRANT ALL PRIVILEGES ON raddetect.* TO 'raddetectuser'@'%';

-- Apply the privileges
FLUSH PRIVILEGES;

-- Use the new database
USE raddetect;

-- Create the 'radiation' table
CREATE TABLE IF NOT EXISTS radiation (
    id INT AUTO_INCREMENT PRIMARY KEY,   -- Unique ID for each measurement
    timestamp DATETIME NOT NULL,         -- Timestamp of the measurement
    cpm INT NOT NULL,                    -- Counts per minute
    usvh DECIMAL(5,2) NOT NULL           -- Microsievert per hour (with 2 decimal places)
);

-- Add an index for faster queries on timestamp (optional)
CREATE INDEX idx_timestamp ON radiation (timestamp);
