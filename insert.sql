INSERT INTO Department VALUES ('Computer_Science');
INSERT INTO Department VALUES ('ECE');

INSERT INTO Faculty (ssn, title, first, last, dept_name) VALUES ('100-00-0000', 'Professor', 'Fac1', 'A', 'Computer_Science'); /* 1 */
INSERT INTO Faculty (ssn, title, first, last, dept_name) VALUES ('200-00-0000', 'Associate Professor', 'Fac2', 'B', 'Computer_Science'); /* 2 */
INSERT INTO Faculty (ssn, title, first, last, dept_name) VALUES ('300-00-0000', 'Assistant Professor', 'Fac3', 'C', 'Computer_Science'); /* 3 */
INSERT INTO Faculty (ssn, title, first, last, dept_name) VALUES ('400-00-0000', 'Professor', 'Fac4', 'D', 'ECE'); /* 4 */
INSERT INTO Faculty (ssn, title, first, last, dept_name) VALUES ('500-00-0000', 'Associate Professor', 'Fac5', 'E', 'ECE'); /* 5 */
INSERT INTO Faculty (ssn, title, first, last, dept_name) VALUES ('600-00-0000', 'Professor', 'Fac6', 'F', 'Computer_Science'); /* 6 */
INSERT INTO Faculty (ssn, title, first, last, dept_name) VALUES ('700-00-0000', 'Lecturer', 'Fac7', 'G', 'Computer_Science'); /* 7 */

INSERT INTO Student (student_id, first, last, ssn, enrollment, residency, five_year_program) VALUES (1, 'Stu1', 'Dent', '111-11-1111', true, 'US', false);
INSERT INTO Student (student_id, first, last, ssn, enrollment, residency, five_year_program) VALUES (2, 'Stu2', 'Dent', '222-22-2222', true, 'INT', false);
INSERT INTO Student (student_id, first, last, ssn, enrollment, residency, five_year_program) VALUES (3, 'Stu3', 'Dent', '333-33-3333', true, 'INT', false);
INSERT INTO Student (student_id, first, last, ssn, enrollment, residency, five_year_program) VALUES (4, 'Stu4', 'Dent', '444-44-4444', true, 'INT', false);
INSERT INTO Student (student_id, first, last, ssn, enrollment, residency, five_year_program) VALUES (5, 'Stu5', 'Dent', '555-55-5555', true, 'INT', true);
INSERT INTO Student (student_id, first, last, ssn, enrollment, residency, five_year_program) VALUES (6, 'Stu6', 'Dent', '666-66-6666', true, 'INT', true);
INSERT INTO Student (student_id, first, last, ssn, enrollment, residency, five_year_program) VALUES (7, 'Stu7', 'Dent', '777-77-7777', true, 'INT', true);
INSERT INTO Student (student_id, first, last, ssn, enrollment, residency, five_year_program) VALUES (8, 'Stu8', 'Dent', '888-88-8888', true, 'INT', true);
INSERT INTO Student (student_id, first, last, ssn, enrollment, residency, five_year_program) VALUES (9, 'Stu9', 'Dent', '999-99-9999', true, 'INT', true);

INSERT INTO Course VALUES (1, 'CSE1', 2, 4, 'L/SU', false, 'DB_APPS', false, 'UD_TE', 'Computer_Science'); /* 1 */
INSERT INTO Course VALUES (2, 'CSE2', 2, 4, 'L/SU', false, 'Algorithms2', false, 'UD_TE', 'Computer_Science'); /* 2 */
INSERT INTO Course VALUES (3, 'CSE3', 2, 4, 'L/SU', false, 'OS1', false, 'LD', 'Computer_Science'); /* 3 */
INSERT INTO Course VALUES (4, 'CSE4', 2, 4, 'L/SU', false, 'Architecture', false, 'UD', 'Computer_Science'); /* 4 */
INSERT INTO Course VALUES (5, 'CSE5', 2, 4, 'L/SU', false, 'Maths', false, 'LD', 'Computer_Science'); /* 5 */
INSERT INTO Course VALUES (6, 'CSE6', 2, 4, 'L/SU', false, 'Algorithms1', false, 'LD', 'Computer_Science'); /* 6 */
INSERT INTO Course VALUES (7, 'CSE7', 2, 4, 'L/SU', false, 'Database_Applications', false, 'UD', 'Computer_Science'); /* 7 */
INSERT INTO Course VALUES (10, 'CSE10', 2, 4, 'L/SU', false, 'Databases1', false, 'UD', 'Computer_Science'); /* 10 */
INSERT INTO Course VALUES (11, 'CSE11', 2, 4, 'L/SU', false, 'Databases2', false, 'UD', 'Computer_Science'); /* 11 */

INSERT INTO Class (class_name, quarter, year) VALUES ('CSE1', 'Spring', 2009); /* 1 */
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE2', 'Spring', 2009); /* 2 */
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE3', 'Spring', 2009); /* 3 */

INSERT INTO Class (class_name, quarter, year) VALUES ('CSE4', 'Winter', 2009); /* 4 */
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE5', 'Winter', 2009); /* 5 */
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE6', 'Fall', 2008); /* 6 */
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE7', 'Fall', 2008); /* 7 */
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE1', 'Spring', 2008); /* 8 */
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE10', 'Winter', 2008); /* 9 */
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE11', 'Winter', 2008); /* 10 */

INSERT INTO Section VALUES (1, 100, 'L', '100-00-0000', 1); /* 1 */
INSERT INTO Section VALUES (2, 80, 'L', '300-00-0000', 2); /* 2 */
INSERT INTO Section VALUES (11, 500, 'L', '200-00-0000', 1); /* 11 */
INSERT INTO Section VALUES (22, 100, 'L', '400-00-0000', 2); /* 22 */
INSERT INTO Section VALUES (3, 100, 'L', '600-00-0000', 3); /* 3 */
INSERT INTO Section VALUES (33, 100, 'L', '200-00-0000', 3); /* 33 */

INSERT INTO Section VALUES (12, 100, 'L', '300-00-0000', 4); /* 12 */
INSERT INTO Section VALUES (4, 100, 'L', '100-00-0000', 5); /* 4 */
INSERT INTO Section VALUES (5, 100, 'L/SU', '400-00-0000', 6); /* 5 */
INSERT INTO Section VALUES (6, 100, 'L/SU', '200-00-0000', 7); /* 6 */
INSERT INTO Section VALUES (7, 100, 'L/SU', '100-00-0000', 8); /* 7 */
INSERT INTO Section VALUES (8, 200, 'L/SU', '300-00-0000', 8); /* 8 */
INSERT INTO Section VALUES (9, 100, 'L/SU', '300-00-0000', 9); /* 9 */
INSERT INTO Section VALUES (10, 100, 'L/SU', '200-00-0000', 10); /* 10 */

INSERT INTO Student_class (student_id, class_id, grade) values (2, 1, 'WIP');
INSERT INTO Student_class (student_id, class_id, grade) values (1, 1, 'WIP');
INSERT INTO Student_class (student_id, class_id, grade) values (5, 2, 'WIP');
INSERT INTO Student_class (student_id, class_id, grade) values (9, 1, 'WIP');
INSERT INTO Student_class (student_id, class_id, grade) values (5, 1, 'WIP');
INSERT INTO Student_class (student_id, class_id, grade) values (1, 2, 'WIP');
INSERT INTO Student_class (student_id, class_id, grade) values (7, 2, 'WIP');

INSERT INTO Student_class (student_id, class_id, grade) values (2, 4, 'A');
INSERT INTO Student_class (student_id, class_id, grade) values (3, 4, 'P');
INSERT INTO Student_class (student_id, class_id, grade) values (1, 4, 'C');
INSERT INTO Student_class (student_id, class_id, grade) values (3, 5, 'B');
INSERT INTO Student_class (student_id, class_id, grade) values (4, 5, 'B+');
INSERT INTO Student_class (student_id, class_id, grade) values (7, 5, 'A');
INSERT INTO Student_class (student_id, class_id, grade) values (1, 6, 'A-');
INSERT INTO Student_class (student_id, class_id, grade) values (5, 6, 'F');
INSERT INTO Student_class (student_id, class_id, grade) values (4, 6, 'F');
INSERT INTO Student_class (student_id, class_id, grade) values (8, 7, 'A');
INSERT INTO Student_class (student_id, class_id, grade) values (5, 7, 'A');
INSERT INTO Student_class (student_id, class_id, grade) values (7, 7, 'D');
INSERT INTO Student_class (student_id, class_id, grade) values (8, 8, 'A');
INSERT INTO Student_class (student_id, class_id, grade) values (3, 8, 'A-');
INSERT INTO Student_class (student_id, class_id, grade) values (6, 8, 'A-');
INSERT INTO Student_class (student_id, class_id, grade) values (4, 8, 'A');
INSERT INTO Student_class (student_id, class_id, grade) values (1, 9, 'B+');
INSERT INTO Student_class (student_id, class_id, grade) values (5, 9, 'B+');
INSERT INTO Student_class (student_id, class_id, grade) values (8, 9, 'A');
INSERT INTO Student_class (student_id, class_id, grade) values (2, 10, 'B-');
INSERT INTO Student_class (student_id, class_id, grade) values (8, 10, 'P');
INSERT INTO Student_class (student_id, class_id, grade) values (4, 10, 'A');

INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(2, 1, 'P/NP', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(1, 1, 'P/NP', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(5, 2, 'P/NP', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(9, 11, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(5, 11, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(1, 22, 'P/NP', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(7, 22, '4', false);

INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(2, 12, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(3, 12, 'P/NP', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(1, 12, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(3, 4, '2', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(4, 4, '2', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(7, 4, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(1, 5, '2', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(5, 5, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(4, 5, '2', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(8, 6, '2', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(5, 6, '2', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(7, 6, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(8, 7, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(3, 7, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(6, 8, '2', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(4, 8, '2', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(1, 9, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(5, 9, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(8, 9, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(2, 10, '2', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(8, 10, '2', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(4, 10, '2', false);


INSERT INTO Meeting VALUES (1, 'Lecture', true, true, '03:50 PM', '05:50 PM', NULL, 'CTR', 'Mon', 11);
INSERT INTO Meeting VALUES (2, 'Lecture', true, true, '03:50 PM', '05:50 PM', NULL, 'CTR', 'Wed', 11);
INSERT INTO Meeting VALUES (3, 'Lecture', true, true, '02:00 PM', '03:30 PM', NULL, 'CTR', 'Mon', 2);
INSERT INTO Meeting VALUES (4, 'Lecture', true, true, '01:00 PM', '02:30 PM', NULL, 'CTR', 'Thu', 2);
INSERT INTO Meeting VALUES (5, 'Lecture', true, true, '02:00 PM', '03:30 PM', NULL, 'CTR', 'Mon', 22);
INSERT INTO Meeting VALUES (6, 'Lecture', true, true, '03:00 PM', '03:50 PM', NULL, 'CTR', 'Wed', 22);
INSERT INTO Meeting VALUES (7, 'Lecture', true, true, '01:00 PM', '01:50 PM', NULL, 'CTR', 'Fri', 22);
INSERT INTO Meeting VALUES (8, 'Lecture', true, true, '02:00 PM', '04:00 PM', NULL, 'CTR', 'Mon', 3);
INSERT INTO Meeting VALUES (9, 'Lecture', true, true, '01:00 PM', '02:00 PM', NULL, 'CTR', 'Wed', 3);
INSERT INTO Meeting VALUES (10, 'Lecture', true, true, '01:00 PM', '02:00 PM', NULL, 'CTR', 'Mon', 33);
INSERT INTO Meeting VALUES (11, 'Lecture', true, true, '01:00 PM', '02:00 PM', NULL, 'CTR', 'Wed', 33);
INSERT INTO Meeting VALUES (12, 'Lecture', true, true, '01:00 PM', '02:00 PM', NULL, 'CTR', 'Tue', 1);
INSERT INTO Meeting VALUES (13, 'Lecture', true, true, '01:00 PM', '02:00 PM', NULL, 'CTR', 'Thu', 1);

INSERT INTO Requirement (require_id, units, degree, gpa, description) values(1, 30, 'bs', 2.0, 'TU');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(2, 12, 'ba', 2.0, 'ba2');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(3, 16, 'master', 2.0, 'ms3');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(4, 14, 'phd', 2.0, 'phd4');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(5, 8, 'bs', 2.0, 'LD');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(6, 12, 'bs', 2.0, 'UD');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(7, 8, 'bs', 2.0, 'TE');

INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 1);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 2);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 3);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 4);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 5);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 6);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 7);

INSERT INTO Concentration (name, description, dept_name) values('Database', 'database within cse', 'Computer_Science');
INSERT INTO Concentration (name, description, dept_name) values('Software', 'software within cse', 'Computer_Science');

INSERT INTO Concentration_course (con_name, course_id) values('Database', 1);
INSERT INTO Concentration_course (con_name, course_id) values('Database', 2);
INSERT INTO Concentration_course (con_name, course_id) values('Software', 3);
INSERT INTO Concentration_course (con_name, course_id) values('Software', 4);

INSERT INTO Graduate (grad_id, in_dept) values(6, 'Computer_Science');
INSERT INTO Graduate (grad_id, in_dept) values(7, 'Computer_Science');
INSERT INTO Graduate (grad_id, in_dept) values(8, 'Computer_Science');
INSERT INTO Graduate (grad_id, in_dept) values(9, 'Computer_Science');

INSERT INTO Master (master_id, con_name) values(6, 'Database'); /*not ok*/
INSERT INTO Master (master_id, con_name) values(7, 'Software'); /*ok*/
INSERT INTO Master (master_id, con_name) values(8, 'Software'); /*ok*/

INSERT INTO Phd (phd_id, candidacy) values(9, true);

INSERT INTO Undergraduate (u_id, college, major) values(1, 'Sixth', 'Computer_Science');
INSERT INTO Undergraduate (u_id, college, major) values(2, 'Marshall', 'Computer_Science');
INSERT INTO Undergraduate (u_id, college, major) values(3, 'Marshall', 'Computer_Science');
INSERT INTO Undergraduate (u_id, college, major) values(4, 'Marshall', 'Computer_Science');
INSERT INTO Undergraduate (u_id, college, major) values(5, 'Marshall', 'Computer_Science');

INSERT INTO Prev_Degree (degree_id, degree, institute) VALUES (10001, 'master', 'UCSD');
INSERT INTO Prev_Degree (degree_id, degree, institute) VALUES (10002, 'master', 'UCB');
INSERT INTO Prev_Degree (degree_id, degree, institute) VALUES (10003, 'master', 'UCLA');
INSERT INTO Prev_Degree (degree_id, degree, institute) VALUES (10004, 'bs', 'UCSD');
INSERT INTO Prev_Degree (degree_id, degree, institute) VALUES (10005, 'bs', 'UCLA');
INSERT INTO Prev_Degree (degree_id, degree, institute) VALUES (10006, 'ba', 'UCSD');
INSERT INTO Prev_Degree (degree_id, degree, institute) VALUES (10007, 'ba', 'UCLA');


/* last five */

/* Enrollment from TA's data */
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('222-22-2222', 'Spring', 2009);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('111-11-1111', 'Spring', 2009);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('555-55-5555', 'Spring', 2009);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('999-99-9999', 'Spring', 2009);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('777-77-7777', 'Spring', 2009);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('222-22-2222', 'Winter', 2009);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('111-11-1111', 'Winter', 2009);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('777-77-7777', 'Winter', 2009);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('333-33-3333', 'Winter', 2009);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('444-44-4444', 'Winter', 2009);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('444-44-4444', 'Fall', 2008);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('111-11-1111', 'Fall', 2008);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('555-55-5555', 'Fall', 2008);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('777-77-7777', 'Fall', 2008);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('888-88-8888', 'Fall', 2008);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('111-11-1111', 'Spring', 2008);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('222-22-2222', 'Spring', 2008);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('555-55-5555', 'Spring', 2008);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('444-44-4444', 'Spring', 2008);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('666-66-6666', 'Spring', 2008);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('111-11-1111', 'Winter', 2008);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('222-22-2222', 'Winter', 2008);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('555-55-5555', 'Winter', 2008);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('444-44-4444', 'Winter', 2008);
INSERT INTO Enrollment (ssn, quarter, year) VALUES ('888-88-8888', 'Winter', 2008);

