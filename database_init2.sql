CREATE TABLE Student_class (
    student_id      INTEGER,
	class_id		INTEGER,
    grade			TEXT NOT NULL,

    primary key (student_id, class_id),
    foreign key (student_id) references Student(student_id),
    foreign key (class_id) references Class(class_id)
);

CREATE TABLE Graduate (
	grad_id			INTEGER PRIMARY KEY,
	in_dept			TEXT,
	foreign key (grad_id) references Student(student_id),
    foreign key (in_dept) references Department(dept_name)
);

CREATE TABLE Faculty (
	ssn				TEXT PRIMARY KEY,
	title			TEXT,
	faculty_name	TEXT,
	dept_name		TEXT,
	foreign key (dept_name) references Department(dept_name)
);

CREATE TABLE Thesis_committee (
	stu_id			INTEGER,
	is_phd			BOOLEAN NOT NULL,
	faculty_ssn		TEXT,
	primary key (stu_id, faculty_ssn),
	foreign key (stu_id) references Graduate(grad_id),
    foreign key (faculty_ssn) references Faculty(ssn)
);

insert into faculty (ssn, title, faculty_name, dept_name)  values ('908-293-0193', 'Professor', 'Amy Milae', 'Cognitive_Science');
insert into faculty (ssn, title, faculty_name, dept_name)  values ('129-323-0133', 'Associate Professor', 'Judy Chang', 'Cognitive_Science');
insert into faculty (ssn, title, faculty_name, dept_name)  values ('353-912-0653', 'Assistant Professor', 'Andrew Farkas', 'Cognitive_Science');
insert into faculty (ssn, title, faculty_name, dept_name)  values ('813-945-8371', 'Lecturer', 'Rick Ord', 'Computer_Science');
insert into faculty (ssn, title, faculty_name, dept_name)  values ('029-481-3941', 'Associate Professor', 'Staphanie Ting', 'Computer_Science');
insert into faculty (ssn, title, faculty_name, dept_name)  values ('741-931-5830', 'Professor', 'Jimmy Poland', 'Computer_Science');
insert into faculty (ssn, title, faculty_name, dept_name)  values ('013-432-9381', 'Assistant Professor', 'Frank Loui', 'Computer_Science');
insert into faculty (ssn, title, faculty_name, dept_name)  values ('103-582-3012', 'Assistant Professor', 'Yuanyuan Zhou', 'Economics');
