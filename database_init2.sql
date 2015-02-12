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

insert into Faculty (ssn, title, first, last, dept_name)  values ('908-293-0193', 'Professor', 'Amy', 'Milae', 'Cognitive_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('129-323-0133', 'Associate Professor', 'Judy', 'Chang', 'Cognitive_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('353-912-0653', 'Assistant Professor', 'Andrew', 'Farkas', 'Cognitive_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('813-945-8371', 'Lecturer', 'Robert', 'Orland', 'Computer_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('029-481-3941', 'Associate Professor', 'Staphanie', 'Ting', 'Computer_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('741-931-5830', 'Professor', 'Jimmy', 'Poland', 'Computer_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('013-432-9381', 'Assistant Professor', 'Frank', 'Loui', 'Computer_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('103-582-3012', 'Assistant Professor', 'Yuanyuan', 'Zhou', 'Economics');
