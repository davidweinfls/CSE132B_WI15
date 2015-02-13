/* Capitalize first character of table name
   attributes should be lower case
*/

/* Student table */
CREATE TABLE Student (
    student_id      INTEGER PRIMARY KEY,
    first           TEXT    NOT NULL,
    middle          TEXT,
    last            TEXT    NOT NULL,
    ssn             TEXT    NOT NULL UNIQUE,
    enrollment      BOOLEAN NOT NULL,
    residency       TEXT   NOT NULL,
    five_year_program   BOOLEAN NOT NULL
);

CREATE TABLE Department (
    dept_name       TEXT    PRIMARY KEY
);

CREATE TABLE Course (
    course_id       SERIAL  PRIMARY KEY,
    course_name     TEXT    NOT NULL    UNIQUE,
    unit_low        INTEGER NOT NULL,
    unit_high       INTEGER NOT NULL,
    letter_su       TEXT    NOT NULL,
    lab             BOOLEAN NOT NULL,
    title           TEXT    NOT NULL,
    consent_of_instructor   BOOLEAN NOT NULL,
    dept_name       TEXT    REFERENCES  Department (dept_name) ON DELETE CASCADE
);

CREATE TABLE Class (
    class_id        SERIAL  PRIMARY KEY,
    class_name      TEXT    NOT NULL	REFERENCES Course (course_name) ON DELETE CASCADE,
    quarter         TEXT    NOT NULL,
    year            INTEGER NOT NULL
);

CREATE TABLE Prerequisite (
    course_id       INTEGER REFERENCES Course (course_id) ON DELETE CASCADE,
    prerequisite_id INTEGER REFERENCES Course (course_id) ON DELETE CASCADE,
    PRIMARY KEY (course_id, prerequisite_id)
);

CREATE TABLE Faculty (
	ssn			TEXT PRIMARY KEY,
	title		TEXT	NOT NULL,
	first		TEXT	NOT NULL,
	last		TEXT	NOT NULL,
	dept_name	TEXT	NOT NULL REFERENCES	Department (dept_name) ON DELETE CASCADE
);

CREATE TABLE Student_Class (
	student_id		INTEGER	NOT NULL	REFERENCES Student (student_id) ON DELETE CASCADE,
	class_id		INTEGER	NOT NULL	REFERENCES Class (class_id) ON DELETE CASCADE,
	grade			TEXT	NOT NULL,
	PRIMARY KEY (student_id, class_id)
);

CREATE TABLE Section (
	section_id		SERIAL	PRIMARY KEY,
	enroll_limit			INTEGER,
	grade_option	TEXT	NOT NULL,
	instructor_ssn	TEXT	NOT NULL REFERENCES Faculty (ssn) ON DELETE CASCADE,
	class_id		INTEGER	NOT NULL REFERENCES Class (class_id) ON DELETE CASCADE
);

CREATE TABLE Section_Enrolllist (
	student_id		INTEGER	REFERENCES	Student (student_id) ON DELETE CASCADE,
	section_id		INTEGER	REFERENCES	Section (section_id) ON DELETE CASCADE,
	grade_option	TEXT	NOT NULL,
	waitlist		BOOLEAN	NOT NULL,
	PRIMARY KEY (student_id, section_id)
);

/* last five forms */

CREATE TABLE Graduate (
	grad_id			INTEGER PRIMARY KEY,
	in_dept			TEXT,
	foreign key (grad_id) references Student(student_id) ON DELETE CASCADE,
    foreign key (in_dept) references Department(dept_name) ON DELETE CASCADE
);

CREATE TABLE Thesis_Committee (
	stu_id			INTEGER,
	is_phd			BOOLEAN NOT NULL,
	faculty_ssn		TEXT,
	primary key (stu_id, faculty_ssn),
	foreign key (stu_id) references Graduate(grad_id) ON DELETE CASCADE,
    foreign key (faculty_ssn) references Faculty(ssn) ON DELETE CASCADE
);

CREATE TABLE Probation (
	pro_id			INTEGER,
	start_year		INTEGER,
	end_year		INTEGER,
	start_quarter	TEXT,
	end_quarter		TEXT,
	reason 			TEXT,
	primary key (pro_id, start_year, end_year, start_quarter, end_quarter),
	foreign key (pro_id) references Student (student_id) ON DELETE CASCADE
);

CREATE TABLE Meeting (
	meeting_id		SERIAL 	PRIMARY KEY,
	type			TEXT 	NOT NULL,
	mandatory		BOOLEAN NOT NULL,
	weekly			BOOLEAN NOT NULL,
	time			TEXT	NOT NULL,
	date			TEXT,
	building_room	TEXT	NOT NULL,
	day				TEXT	NOT NULL,
	section_id		INTEGER,
	foreign key (section_id) references Section (section_id) ON DELETE CASCADE
);

create TABLE Requirement (
	require_id		INTEGER PRIMARY KEY,
	units			INTEGER NOT NULL,
	degree			TEXT	NOT NULL,
	gpa				FLOAT	NOT NULL,
	description		TEXT	NOT NULL
);

create TABLE Dept_Requirement (
	dept_name	TEXT,
	require_id	INTEGER,
	primary key (dept_name, require_id),
	foreign key (dept_name) references Department(dept_name) ON DELETE CASCADE,
	foreign key (require_id) references Requirement(require_id) ON DELETE CASCADE
);

create TABLE Concentration (
	name			TEXT PRIMARY KEY,
	description		TEXT NOT NULL,
	dept_name		TEXT,
	foreign key (dept_name) references Department(dept_name) ON DELETE CASCADE
);

create TABLE Concentration_Course (
	con_name		TEXT,
	course_id		SERIAL,
	primary key (con_name, course_id),
	foreign key (con_name) references Concentration(name) ON DELETE CASCADE,
	foreign key (course_id) references Course(course_id) ON DELETE CASCADE
);

create TABLE Undergraduate (
	u_id			INTEGER PRIMARY KEY,
	college			TEXT NOT NULL,
	major			TEXT NOT NULL,
	minor			TEXT,
	foreign key (u_id) references Student(student_id) ON DELETE CASCADE,
	foreign key (major) references Department(dept_name) ON DELETE CASCADE
);

create TABLE Master (
	master_id		INTEGER PRIMARY KEY,
	con_name		TEXT,
	foreign key (master_id) references Graduate(grad_id) ON DELETE CASCADE,
	foreign key (con_name) references Concentration(name) ON DELETE CASCADE
);

create TABLE Phd (
	phd_id			INTEGER PRIMARY KEY,
	candidacy		BOOLEAN NOT NULL,
	foreign key (phd_id) references Graduate(grad_id) ON DELETE CASCADE
);

create TABLE Prev_Degree (
	degree_id 		SERIAL UNIQUE,
	degree			TEXT	NOT NULL,
	institute		TEXT	NOT NULL,
	primary key (degree_id, degree, institute)
);

create TABLE Other_Degree (
	degree_id		SERIAL UNIQUE,
	student_id		INTEGER	NOT NULL,
	primary key (degree_id, student_id),
	foreign key (degree_id) references Prev_Degree (degree_id) ON DELETE CASCADE,
	foreign key (student_id) references Student (student_id) ON DELETE CASCADE
);

CREATE TABLE Advisor (
	phd_id		INTEGER NOT NULL REFERENCES Phd (phd_id) ON DELETE CASCADE,
	faculty_ssn	TEXT	NOT NULL REFERENCES Faculty (ssn) ON DELETE CASCADE,
	PRIMARY KEY (phd_id, faculty_ssn)
);

CREATE TABLE Faculty_Teach_Class ( 
	faculty_ssn		TEXT	NOT NULL	REFERENCES	Faculty (ssn)		ON DELETE CASCADE,
	class_id		INTEGER	NOT NULL	REFERENCES	Class (class_id)	ON DELETE CASCADE,
	PRIMARY KEY (faculty_ssn, class_id)
);
