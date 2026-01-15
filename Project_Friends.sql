-- SQLite migration script
-- Notes:
--  - Store dates as TEXT in ISO 8601 'YYYY-MM-DD'.
--  - Use a GLOB pattern and DATE('now') check to validate format and prevent future birthdays.
--  - SQLite's ALTER TABLE ... ADD COLUMN does not support IF NOT EXISTS in many versions,
--    so we show how to check for the column before adding it.

BEGIN TRANSACTION;

-- Create table if it doesn't exist
CREATE TABLE IF NOT EXISTS friends (
  id       INTEGER PRIMARY KEY,                          -- unique identifier
  name     TEXT    NOT NULL,                            -- required name
  birthday TEXT    NOT NULL CHECK (                     -- store ISO-8601 date as TEXT
    birthday GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'
    AND birthday <= DATE('now')                         -- not in the future
  )
);

-- Insert rows using ISO date format
INSERT INTO friends (id, name, birthday)
VALUES
  (1, 'Ororo Munroe', '1940-05-30'),
  (2, 'Jane Doe',     '1960-08-13'),
  (3, 'Jemimah Lin',  '1975-04-25');

-- Add 'email' column if it doesn't already exist.
-- SQLite (pre-3.37) doesn't support "ADD COLUMN IF NOT EXISTS". Use a small check:
-- Run the following query in the sqlite3 shell or from a script; if it returns 0 then run the ALTER.
-- SELECT COUNT(*) AS cnt FROM pragma_table_info('friends') WHERE name = 'email';
-- If cnt = 0:
ALTER TABLE friends ADD COLUMN email TEXT;

-- Use id-based updates (safer than matching by name)
UPDATE friends SET name = 'Storm Munroe' WHERE id = 1;

-- Populate email addresses
UPDATE friends SET email = 'storm@codecademy.com'   WHERE id = 1;
UPDATE friends SET email = 'jane@codecademy.com'    WHERE id = 2;
UPDATE friends SET email = 'jemimah@codecademy.com' WHERE id = 3;

-- Delete record by id (safer than deleting by name)
DELETE FROM friends WHERE id = 1;

-- Inspect current contents
SELECT * FROM friends;

COMMIT;
