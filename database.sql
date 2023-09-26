
-- Drop all database objects to start with an empty database
DROP TABLE IF EXISTS member_interest_groups CASCADE;
DROP TABLE IF EXISTS interest_group CASCADE;
DROP TABLE IF EXISTS member_events CASCADE;
DROP TABLE IF EXISTS user CASCADE;
DROP TABLE IF EXISTS event CASCADE;


-- Create the user table **LR completed 9.11.23**
CREATE TABLE user(
	user_id serial NOT NULL,
    username varchar (20) UNIQUE NOT NULL,
	first_name varchar(100) NOT NULL,
	last_name varchar(100) NOT NULL,
    role varchar(100) NOT NULL,
	email text UNIQUE,
	phone_number text NULL,
	registration_date DATE DEFAULT GETDATE(),
	alerts_email_flag boolean NOT NULL,
    CONSTRAINT PK_user PRIMARY KEY (user_id)
);


-- Create the Interest Group table **zero to many memberships**
CREATE TABLE interest_pet_group(
	group_id serial NOT NULL,
	name varchar(100) unique NOT NULL,
	CONSTRAINT PK_interest_group PRIMARY KEY (group_id)
);


-- Create the posts table
CREATE TABLE posts(
	post_id serial NOT NULL,
	title varchar(100) NOT NULL,
	description text,
	created_date date NOT NULL,
	created_time time NOT NULL, 
	group_id int NOT NULL,
	CONSTRAINT PK_event PRIMARY KEY (event_id),
	CONSTRAINT FK_interest_pet_group FOREIGN KEY(group_id) REFERENCES interest_pet_group (group_id)
);


--  create table member_interest_groups to link FK member, FK interest group

CREATE TABLE member_interest_groups(
	member_ID INT,
	group_id int,
	CONSTRAINT PK_member_interest_groups PRIMARY KEY (member_id, group_id),
	CONSTRAINT FK_member FOREIGN KEY(member_id) REFERENCES member (member_id),
	CONSTRAINT FK_interest_group FOREIGN KEY(group_id) REFERENCES member (member_id)
);

 -- Create table member_events to link FK member & FK event

CREATE TABLE member_events(
	member_ID INT,
	event_id int,
	CONSTRAINT PK_member_events PRIMARY KEY (member_id, event_id),
	CONSTRAINT FK_member FOREIGN KEY(member_id) REFERENCES member (member_id),
	CONSTRAINT FK_event FOREIGN KEY(event_id) REFERENCES event (event_id)
);

-- Insert test data into the member table and select it 
INSERT INTO user (first_name, last_name, email, phone_number,date_of_birth,reminder_email_flag)
VALUES
	('Alfred', 'Hitchcock', 'ahhh123@gmail.com', '6144534567', '1950-01-06', TRUE),
	('Beyonce', 'Knowles', 'bk4321@gmail.com', '6144535432', '1939-11-06', TRUE),
	('Cheryl', 'Hines', 'ch4781@gmail.com', '6144535432', '1939-11-06', FALSE),
	('Justin', 'Bieber', 'Jjc43241@gmail.com', '9375435432', '1985-12-31', FALSE),
	('Kurt' , 'Cobain', 'kc43241@gmail.com', '9377895432', '1978-06-30', FALSE),
	('Lucille' , 'Ball', 'lucyb@gmail.com', '6457435432', '1912-07-13', TRUE),
	('Michael' , 'Jackson', 'MJ241@gmail.com', '698745621', '1950-03-01', FALSE),
	('Pablo' , 'Picasso', 'art241@gmail.com', '6589745123', '1965-05-31', TRUE),
	('Paul' , 'McCartney', 'music3241@gmail.com', '2563985478', '1948-10-31', FALSE);
SELECT * FROM member;

--  Insert test data into the interest_grouptable and select it 
INSERT INTO interest_group (name) VALUES
	('HordeMeet'),
	('HuddleCluster'),
	('ConvergeAgain'),
	('GatherPod'),
	('SwarmMeet'),
	('TribeGather'),
	('CatchUpHub');
	

SELECT * FROM interest_group;

--  Insert test data into the event table and select it
INSERT INTO event(Name, Description, start_date, start_time, duration, group_id) VALUES
	('Hiking Trip to the Mountains', 'Join us for a fun hiking trip to the mountains!', '2023-08-15', '09:00:00', 180, 1),
	('Hiking Trip to the Beach', 'Join us for a fun hiking trip to the beach!', '2023-09-15', '08:30:00', 270,2),
	('Kayaking Trip down the River', 'Join us for a fun kayaking trip down the river!', '2023-10-15', '10:00:00', 30,3),
	('Game Night', 'Join us for a fun night of snacks, drinks and GAMES!', '2023-11-15', '12:00:00', 90, 4),
	('Ladies Book Club', 'Join us to discuss this months book.', '2023-07-15', '09:00:00', 85,5),
	('Cat Photography', 'Join us for a fun tutorial of photographing cats like a pro.', '2023-12-15', '09:00:00', 300,6);
select * from event;

-- Insert test data into the member_interest_groups table and select it 

INSERT INTO member_interest_groups (member_id, group_id) VALUES
	(1, 1),
	(1, 2),
	(2, 2),
	(3, 1),
	(3, 3),
	(4, 5),
	(5, 1),
	(5, 3),
	(6, 2),
	(6, 3),
	(7, 1),
	(7, 2),
	(7, 5),
	(8, 4),
	(7, 6),
	(8, 5),
	(7, 4),
	(8, 6),
	(7, 7),
	(8, 7),
	(8, 2);

SELECT * FROM member_interest_groups;

-- Insert test data into the member_events table and select it back out.
INSERT INTO member_events (member_id, event_id) VALUES
	(1, 1),
	(1, 2),
	(2, 2),
	(3, 3),
	(4, 4),
	(5, 1),
	(6, 3),
	(7, 1),
	(7, 2),
	(7, 3),
	(8, 4),
	(9, 5),
	(9, 6);
	
SELECT * FROM member_events;

-- Join tables to test validity of statements
-- 1st test - make sure all events have members (query will come back empty)
SELECT e.event_id, e.name as EventName
from event e
left join member_events me on e.event_id = me.event_id
group by e.event_id, e.name
having count(me.member_ID)= 0;

-- 2nd test - make sure all groups have at least two members
SELECT ig.group_id, ig.name as GroupName
from interest_group ig
left join member_interest_groups mig on ig.group_id = mig.group_id
group by ig.group_id, ig.name
having count(mig.member_ID) < 2;

