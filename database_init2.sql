CREATE TABLE Graduate (
	grad_id			INTEGER PRIMARY KEY,
	in_dept			TEXT,
	foreign key (grad_id) references Student(student_id),
    foreign key (in_dept) references Department(dept_name)
);


CREATE TABLE Thesis_committee (
	stu_id			INTEGER,
	is_phd			BOOLEAN NOT NULL,
	faculty_ssn		TEXT,
	primary key (stu_id, faculty_ssn),
	foreign key (stu_id) references Graduate(grad_id),
    foreign key (faculty_ssn) references Faculty(ssn)
);

CREATE TABLE Probation (
	pro_id			INTEGER,
	start_year		INTEGER,
	end_year		INTEGER,
	start_quarter	TEXT,
	end_quarter		TEXT,
	reason 			TEXT,
	primary key (pro_id, start_year, end_year, start_quarter, end_quarter),
	foreign key (pro_id) references Student (student_id)
);

insert into Faculty (ssn, title, first, last, dept_name)  values ('908-93-0193', 'Professor', 'Amy', 'Milae', 'Cognitive_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('129-23-0133', 'Associate Professor', 'Judy', 'Chang', 'Cognitive_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('353-12-0653', 'Assistant Professor', 'Andrew', 'Farkas', 'Cognitive_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('813-45-8371', 'Lecturer', 'Robert', 'Orland', 'Computer_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('029-41-3941', 'Associate Professor', 'Staphanie', 'Ting', 'Computer_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('741-31-5830', 'Professor', 'Jimmy', 'Poland', 'Computer_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('013-43-9381', 'Assistant Professor', 'Frank', 'Loui', 'Computer_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('103-82-3012', 'Assistant Professor', 'Yuanyuan', 'Zhou', 'Economics');

CREATE TABLE Meeting (
	meeting_id		SERIAL 	PRIMARY KEY,
	type			TEXT 	NOT NULL,
	mandatory		BOOLEAN NOT NULL,
	weekly			BOOLEAN NOT NULL,
	time			TEXT	NOT NULL,
	date			TEXT,
	building_room	TEXT	NOT NULL,
	day				TEXT	NOT NULL,
	section_id		SERIAL,
	foreign key (section_id) references Section (section_id)
);