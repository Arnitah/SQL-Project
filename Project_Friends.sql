-- SQLite migration script

BEGIN TRANSACTION;

-- Create table if it doesn't exist
CREATE TABLE IF NOT EXISTS friends (
  id       INTEGER PRIMARY KEY,                          
  name     TEXT    NOT NULL,                           
  birthday TEXT    NOT NULL CHECK (                     
    birthday GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'
    AND birthday <= DATE('now')                        
  )
);

-- Insert rows using ISO date format
INSERT INTO friends (id, name, birthday)
VALUES
  (1, 'Ororo Munroe', '1940-05-30'),
  (2, 'Jane Doe',     '1960-08-13'),
  (3, 'Jemimah Lin',  '1975-04-25');

-- Add 'email' column if it doesn't already exist.
ALTER TABLE friends ADD COLUMN email TEXT;

-- Use id-based updates
UPDATE friends SET name = 'Storm Munroe' WHERE id = 1;

-- Populate email addresses
UPDATE friends SET email = 'storm@codecademy.com'   WHERE id = 1;
UPDATE friends SET email = 'jane@codecademy.com'    WHERE id = 2;
UPDATE friends SET email = 'jemimah@codecademy.com' WHERE id = 3;

-- Delete record by id
DELETE FROM friends WHERE id = 1;

-- Inspect current contents
SELECT * FROM friends;

COMMIT;
