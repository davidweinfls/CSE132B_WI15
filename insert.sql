INSERT INTO Department VALUES ('Computer_Science');
INSERT INTO Department VALUES ('Physics');
INSERT INTO Department VALUES ('Economics');
INSERT INTO Department VALUES ('Cognitive_Science');

INSERT INTO Student (student_id, first, last, ssn, enrollment, residency, five_year_program) VALUES (1, 'Xiao', 'Ming', '100-00-0000', true, 'US', false);
INSERT INTO Student (student_id, first, last, ssn, enrollment, residency, five_year_program) VALUES (2, 'Xiao', 'Hong', '200-00-0000', true, 'INT', false);
INSERT INTO Student (student_id, first, last, ssn, enrollment, residency, five_year_program) VALUES (3, 'Xiao', 'Zhang', '300-00-0000', true, 'INT', false);
INSERT INTO Student (student_id, first, last, ssn, enrollment, residency, five_year_program) VALUES (4, 'Xiao', 'Wang', '400-00-0000', true, 'INT', false);
INSERT INTO Student (student_id, first, last, ssn, enrollment, residency, five_year_program) VALUES (5, 'Xiao', 'Huan', '500-00-0000', true, 'INT', true);

INSERT INTO Course (course_name, unit_low, unit_high, letter_su, lab, title, consent_of_instructor, dept_name)  VALUES ('CSE132B', 4, 4, 'L/SU', false, 'Database_Application', false, 'Computer_Science');
INSERT INTO Course (course_name, unit_low, unit_high, letter_su, lab, title, consent_of_instructor, dept_name)  VALUES ('CSE132A', 4, 4, 'L/SU', false, 'Database_Principle', false, 'Computer_Science');
INSERT INTO Course (course_name, unit_low, unit_high, letter_su, lab, title, consent_of_instructor, dept_name)  VALUES ('CSE110', 2, 6, 'L/SU', false, 'Software_Engineering', false, 'Computer_Science');
INSERT INTO Course (course_name, unit_low, unit_high, letter_su, lab, title, consent_of_instructor, dept_name)  VALUES ('CSE100', 4, 4, 'L/SU', false, 'Advanced_Data_Structure', false, 'Computer_Science');
INSERT INTO Course (course_name, unit_low, unit_high, letter_su, lab, title, consent_of_instructor, dept_name)  VALUES ('CSE11', 3, 4, 'L', false, 'Java', false, 'Computer_Science');
INSERT INTO Course (course_name, unit_low, unit_high, letter_su, lab, title, consent_of_instructor, dept_name)  VALUES ('CSE12', 4, 6, 'L', false, 'Intro_to_Data_Structure', false, 'Computer_Science');
INSERT INTO Course (course_name, unit_low, unit_high, letter_su, lab, title, consent_of_instructor, dept_name)  VALUES ('CSE30', 4, 6, 'L', false, 'Assembly', false, 'Computer_Science');
INSERT INTO Course (course_name, unit_low, unit_high, letter_su, lab, title, consent_of_instructor, dept_name)  VALUES ('Phys2A', 4, 4, 'L', false, 'Mechanics', false, 'Physics');

INSERT INTO Class (class_name, quarter, year) VALUES ('CSE132B', 'Winter', 2015);
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE132B', 'Fall', 2015);
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE132B', 'Winter', 2014);
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE132B', 'Winter', 2013);
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE11', 'Fall', 2014);
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE11', 'Winter', 2014);
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE11', 'Spring', 2014);
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE12', 'Fall', 2014);
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE12', 'Winter', 2014);
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE12', 'Spring', 2014);
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE110', 'Fall', 2010);
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE110', 'Winter', 2011);
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE110', 'Spring', 2012);
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE100', 'Spring', 2013);
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE11', 'Winter', 2015);
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE12', 'Winter', 2015);

INSERT INTO Prerequisite (course_id, prerequisite_id) VALUES ((SELECT course_id FROM course WHERE course_name = 'CSE12'), (SELECT course_id FROM course WHERE course_name = 'CSE11'));
INSERT INTO Prerequisite (course_id, prerequisite_id) VALUES ((SELECT course_id FROM course WHERE course_name = 'CSE30'), (SELECT course_id FROM course WHERE course_name = 'CSE12'));
INSERT INTO Prerequisite (course_id, prerequisite_id) VALUES ((SELECT course_id FROM course WHERE course_name = 'CSE100'), (SELECT course_id FROM course WHERE course_name = 'CSE30'));
INSERT INTO Prerequisite (course_id, prerequisite_id) VALUES ((SELECT course_id FROM course WHERE course_name = 'CSE110'), (SELECT course_id FROM course WHERE course_name = 'CSE100'));
INSERT INTO Prerequisite (course_id, prerequisite_id) VALUES ((SELECT course_id FROM course WHERE course_name = 'CSE132B'), (SELECT course_id FROM course WHERE course_name = 'CSE132A'));

INSERT INTO Faculty VALUES ('123-45-6789', 'Professor', 'George', 'Porter', 'Computer_Science'); 
INSERT INTO Faculty VALUES ('111-11-1111', 'Professor', 'Charles', 'Xavier', 'Computer_Science'); 
INSERT INTO Faculty VALUES ('222-22-2222', 'Lecturer', 'Gary', 'Gillespie', 'Computer_Science'); 
insert into Faculty (ssn, title, first, last, dept_name)  values ('908-93-0193', 'Professor', 'Amy', 'Milae', 'Cognitive_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('129-23-0133', 'Associate Professor', 'Judy', 'Chang', 'Cognitive_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('353-12-0653', 'Assistant Professor', 'Andrew', 'Farkas', 'Cognitive_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('813-45-8371', 'Lecturer', 'Robert', 'Orland', 'Computer_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('029-41-3941', 'Associate Professor', 'Staphanie', 'Ting', 'Computer_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('741-31-5830', 'Professor', 'Jimmy', 'Poland', 'Computer_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('013-43-9381', 'Assistant Professor', 'Frank', 'Loui', 'Computer_Science');
insert into Faculty (ssn, title, first, last, dept_name)  values ('103-82-3012', 'Assistant Professor', 'Yuanyuan', 'Zhou', 'Economics');

INSERT INTO Section (enroll_limit, grade_option, instructor_ssn, class_id) VALUES (100, 'L', '222-22-2222', 5);
INSERT INTO Section (enroll_limit, grade_option, instructor_ssn, class_id) VALUES (80, 'L', '222-22-2222', 5);
INSERT INTO Section (enroll_limit, grade_option, instructor_ssn, class_id) VALUES (500, 'L', '222-22-2222', 5);
INSERT INTO Section (enroll_limit, grade_option, instructor_ssn, class_id) VALUES (100, 'L', '222-22-2222', 6);
INSERT INTO Section (enroll_limit, grade_option, instructor_ssn, class_id) VALUES (100, 'L', '222-22-2222', 7);
INSERT INTO Section (enroll_limit, grade_option, instructor_ssn, class_id) VALUES (100, 'L', '222-22-2222', 8);
INSERT INTO Section (enroll_limit, grade_option, instructor_ssn, class_id) VALUES (100, 'L', '222-22-2222', 9);
INSERT INTO Section (enroll_limit, grade_option, instructor_ssn, class_id) VALUES (100, 'L', '222-22-2222', 10);
INSERT INTO Section (enroll_limit, grade_option, instructor_ssn, class_id) VALUES (100, 'L/SU', '222-22-2222', 11);
INSERT INTO Section (enroll_limit, grade_option, instructor_ssn, class_id) VALUES (100, 'L/SU', '222-22-2222', 12);
INSERT INTO Section (enroll_limit, grade_option, instructor_ssn, class_id) VALUES (100, 'L/SU', '222-22-2222', 13);
INSERT INTO Section (enroll_limit, grade_option, instructor_ssn, class_id) VALUES (100, 'L/SU', '222-22-2222', 14);
INSERT INTO Section (enroll_limit, grade_option, instructor_ssn, class_id) VALUES (300, 'L/SU', '222-22-2222', 15);
INSERT INTO Section (enroll_limit, grade_option, instructor_ssn, class_id) VALUES (300, 'L/SU', '222-22-2222', 15);
INSERT INTO Section (enroll_limit, grade_option, instructor_ssn, class_id) VALUES (400, 'L/SU', '222-22-2222', 16);
INSERT INTO Section (enroll_limit, grade_option, instructor_ssn, class_id) VALUES (110, 'L/SU', '222-22-2222', 16);
INSERT INTO Section (enroll_limit, grade_option, instructor_ssn, class_id) VALUES (100, 'L/SU', '222-22-2222', 16);

INSERT INTO Student_class (student_id, class_id, grade) values (1, 5, 'B');
INSERT INTO Student_class (student_id, class_id, grade) values (1, 8, 'C');
INSERT INTO Student_class (student_id, class_id, grade) values (1, 11, 'A-');
INSERT INTO Student_class (student_id, class_id, grade) values (1, 14, 'B+');

INSERT INTO Student_class (student_id, class_id, grade) values (2, 6, 'B');
INSERT INTO Student_class (student_id, class_id, grade) values (2, 9, 'F');
INSERT INTO Student_class (student_id, class_id, grade) values (2, 12, 'A-');
INSERT INTO Student_class (student_id, class_id, grade) values (2, 14, 'B+');

INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(1, 1, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(1, 6, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(1, 9, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(1, 12, '4', false);

INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(2, 4, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(2, 7, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(2, 10, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(2, 12, '4', false);

INSERT INTO Requirement (require_id, units, degree, gpa, description) values(1, 8, 'bs', 2.0, 'bs1');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(2, 12, 'ba', 2.0, 'ba2');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(3, 16, 'master', 2.0, 'ms3');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(4, 14, 'phd', 2.0, 'phd4');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(5, 18, 'bs', 2.0, 'bs5');

INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 1);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 2);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 3);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 4);
INSERT INTO Dept_requirement (dept_name, require_id) values('Economics', 5);

INSERT INTO Concentration (name, description, dept_name) values('Database', 'database within cse', 'Computer_Science');
INSERT INTO Concentration (name, description, dept_name) values('Software', 'software within cse', 'Computer_Science');

INSERT INTO Concentration_course (con_name, course_id) values('Database', 1);
INSERT INTO Concentration_course (con_name, course_id) values('Database', 2);
INSERT INTO Concentration_course (con_name, course_id) values('Software', 3);
INSERT INTO Concentration_course (con_name, course_id) values('Software', 4);

INSERT INTO Graduate (grad_id, in_dept) values(1, 'Computer_Science');
INSERT INTO Graduate (grad_id, in_dept) values(2, 'Computer_Science');
INSERT INTO Graduate (grad_id, in_dept) values(3, 'Computer_Science');

INSERT INTO Master (master_id, con_name) values(1, 'Database'); /*not ok*/
INSERT INTO Master (master_id, con_name) values(2, 'Software'); /*ok*/

INSERT INTO Phd (phd_id, candidacy) values(3, true);

INSERT INTO Undergraduate (u_id, college, major) values(4, 'Sixth', 'Computer_Science');
INSERT INTO Undergraduate (u_id, college, major) values(5, 'Marshall', 'Economics');

INSERT INTO Prev_Degree (degree_id, degree, institute) VALUES (10001, 'master', 'UCSD');
INSERT INTO Prev_Degree (degree_id, degree, institute) VALUES (10002, 'master', 'UCB');
INSERT INTO Prev_Degree (degree_id, degree, institute) VALUES (10003, 'master', 'UCLA');
/* last five */

