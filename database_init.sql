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

INSERT INTO Department VALUES ('Computer Science');

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

INSERT INTO Course (course_name, unit_low, unit_high, letter_su, lab, title, consent_of_instructor, dept_name)  VALUES ('CSE132B', 4, 4, 'L_SU', false, 'Database APplication', false, 'Computer Science');
INSERT INTO Course (course_name, unit_low, unit_high, letter_su, lab, title, consent_of_instructor, dept_name)  VALUES ('CSE132A', 4, 4, 'L_SU', false, 'Database Principle', false, 'Computer Science');

CREATE TABLE Class (
    class_id        SERIAL  PRIMARY KEY,
    class_name      TEXT    NOT NULL	REFERENCES Course (course_name) ON DELETE CASCADE,
    quarter         TEXT    NOT NULL,
    year            INTEGER NOT NULL
);

INSERT INTO Class (class_name, quarter, year) VALUES ('CSE132B', 'Winter', 2015);

CREATE TABLE Prerequisite (
    course_id       INTEGER REFERENCES Course (course_id) ON DELETE CASCADE,
    prerequisite_id INTEGER REFERENCES Course (course_id) ON DELETE CASCADE,
    PRIMARY KEY (course_id, prerequisite_id)
);

INSERT INTO Prerequisite VALUES (1, 4);
