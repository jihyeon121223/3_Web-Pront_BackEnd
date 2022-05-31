SELECT * FROM information_schema.tables;


SELECT DISTINCT table_schema FROM information_schema.tables;

SELECT table_name FROM information_schema.TABLES
WHERE table_schema = 'SampleDB';

SELECT column_name FROM information_schema.columns
WHERE TABLE_NAME = 'world' AND table_schema = 'SampleDB';

SELECT * FROM SampleDB.성적;

SELECT * FROM world;