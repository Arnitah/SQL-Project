—-Project_1_Practice--

Create Table friends (
 id INTEGER,
 name TEXT,
 birthday DATE
);


Insert into friends(id, name, birthday)
values (1, 'Ororo Munroe', 'May 30th, 1940');


INSERT INTO friends (id, name, birthday)
VALUES (2, 'Jane Doe', 'August 13th, 1960');


INSERT INTO friends (id, name, birthday)
 VALUES (3, 'Jemimah Lin', 'April 25th, 1975');


 Update friends
 set name = 'Storm Munroe'
 where id= 1;


Alter Table friends
Add Column email Text;


Update friends
set email = 'storm@codecademy.com'
where id = 1;


Update friends
set email = 'jane@codecademy.com'
where id = 2;


Update friends
set email = 'jemimah@codecademy.com'
where id = 3;


Delete from friends
where name = 'Storm Munroe';


 select * from friends;
