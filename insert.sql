INSERT INTO Department VALUES ('Computer_Science');
INSERT INTO Department VALUES ('ECE');

INSERT INTO Faculty (ssn, title, first, last, dept_name) VALUES ('100-00-0000', 'Professor', 'Fac1', 'A', 'Computer_Science'); /* 1 */
INSERT INTO Faculty (ssn, title, first, last, dept_name) VALUES ('200-00-0000', 'Associate Professor', 'Fac2', 'B', 'Computer_Science'); /* 2 */
INSERT INTO Faculty (ssn, title, first, last, dept_name) VALUES ('300-00-0000', 'Assistant Professor', 'Fac3', 'C', 'Computer_Science'); /* 3 */
INSERT INTO Faculty (ssn, title, first, last, dept_name) VALUES ('400-00-0000', 'Professor', 'Fac4', 'D', 'ECE'); /* 4 */
INSERT INTO Faculty (ssn, title, first, last, dept_name) VALUES ('500-00-0000', 'Associate Professor', 'Fac5', 'E', 'ECE'); /* 5 */
INSERT INTO Faculty (ssn, title, first, last, dept_name) VALUES ('600-00-0000', 'Professor', 'Fac6', 'F', 'Computer_Science'); /* 6 */
INSERT INTO Faculty (ssn, title, first, last, dept_name) VALUES ('700-00-0000', 'Lecturer', 'Fac7', 'G', 'Computer_Science'); /* 7 */
INSERT INTO Faculty (ssn, title, first, last, dept_name) VALUES ('800-00-0000', 'Lecturer', 'Fac7', 'G', 'ECE'); /* 8 */

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
INSERT INTO Course VALUES (12, 'CSE12', 2, 4, 'L/SU', false, 'OS2', false, 'UD', 'Computer_Science'); /* 12 */
INSERT INTO Course VALUES (13, 'CSE13', 2, 4, 'L/SU', false, 'OS3', false, 'UD', 'Computer_Science'); /* 13 */

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
INSERT INTO Class (class_name, quarter, year) VALUES ('CSE5', 'Winter', 2008); /* 11 */

INSERT INTO Section VALUES (1, 3, 'L', '100-00-0000', 1); /* 1 */
INSERT INTO Section VALUES (2, 3, 'L', '300-00-0000', 2); /* 2 */
INSERT INTO Section VALUES (11, 3, 'L', '200-00-0000', 1); /* 11 */
INSERT INTO Section VALUES (22, 3, 'L', '400-00-0000', 2); /* 22 */
INSERT INTO Section VALUES (3, 3, 'L', '600-00-0000', 3); /* 3 */
INSERT INTO Section VALUES (33, 3, 'L', '200-00-0000', 3); /* 33 */

INSERT INTO Section VALUES (12, 3, 'L', '300-00-0000', 4); /* 12 */
INSERT INTO Section VALUES (4, 3, 'L', '100-00-0000', 5); /* 4 */
INSERT INTO Section VALUES (5, 3, 'L/SU', '400-00-0000', 6); /* 5 */
INSERT INTO Section VALUES (6, 3, 'L/SU', '200-00-0000', 7); /* 6 */
INSERT INTO Section VALUES (7, 3, 'L/SU', '100-00-0000', 8); /* 7 */
INSERT INTO Section VALUES (8, 3, 'L/SU', '300-00-0000', 8); /* 8 */
INSERT INTO Section VALUES (9, 3, 'L/SU', '300-00-0000', 9); /* 9 */
INSERT INTO Section VALUES (10, 3, 'L/SU', '200-00-0000', 10); /* 10 */
INSERT INTO Section VALUES (44, 3, 'L/SU', '100-00-0000', 11); /* 10 */

INSERT INTO Student_class values (2, 1, 'WIP', '100-00-0000');
INSERT INTO Student_class values (1, 1, 'WIP', '100-00-0000');
INSERT INTO Student_class values (5, 2, 'WIP', '300-00-0000');
INSERT INTO Student_class values (9, 1, 'WIP', '200-00-0000');
INSERT INTO Student_class values (5, 1, 'WIP', '200-00-0000');
INSERT INTO Student_class values (1, 2, 'WIP', '400-00-0000');
INSERT INTO Student_class values (7, 2, 'WIP', '400-00-0000');

INSERT INTO Student_class values (2, 4, 'A', '300-00-0000');
INSERT INTO Student_class values (3, 4, 'P', '300-00-0000');
INSERT INTO Student_class values (1, 4, 'C', '300-00-0000');
INSERT INTO Student_class values (3, 5, 'B', '100-00-0000');
INSERT INTO Student_class values (4, 5, 'B+', '100-00-0000');
INSERT INTO Student_class values (7, 5, 'A', '100-00-0000');
INSERT INTO Student_class values (1, 6, 'A-', '400-00-0000');
INSERT INTO Student_class values (5, 6, 'F', '400-00-0000');
INSERT INTO Student_class values (4, 6, 'F', '400-00-0000');
INSERT INTO Student_class values (8, 7, 'A', '200-00-0000');
INSERT INTO Student_class values (5, 7, 'A', '200-00-0000');
INSERT INTO Student_class values (7, 7, 'D', '200-00-0000');
INSERT INTO Student_class values (8, 8, 'A', '100-00-0000');
INSERT INTO Student_class values (3, 8, 'A-', '100-00-0000');
INSERT INTO Student_class values (6, 8, 'A-', '300-00-0000');
INSERT INTO Student_class values (4, 8, 'A', '300-00-0000');
INSERT INTO Student_class values (1, 9, 'B+', '300-00-0000');
INSERT INTO Student_class values (5, 9, 'B+', '300-00-0000');
INSERT INTO Student_class values (8, 9, 'A', '300-00-0000');
INSERT INTO Student_class values (2, 10, 'B-', '200-00-0000');
INSERT INTO Student_class values (8, 10, 'P', '200-00-0000');
INSERT INTO Student_class values (4, 10, 'A', '200-00-0000');
INSERT INTO Student_class values (1, 11, 'A+', '100-00-0000');
INSERT INTO Student_class values (2, 11, 'B-', '100-00-0000');
INSERT INTO Student_class values (8, 11, 'C', '100-00-0000');
/*
INSERT INTO Student_class (student_id, class_id, grade) values (7, 9, 'A');
INSERT INTO Student_class (student_id, class_id, grade) values (7, 10, 'B');
*/
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(2, 1, 'P/NP', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(1, 1, 'P/NP', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(5, 2, 'P/NP', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(9, 11, 'P/NP', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(5, 11, 'P/NP', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(1, 22, '2', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(7, 22, '4', false);

INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(2, 12, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(3, 12, 'P/NP', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(1, 12, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(3, 4, '2', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(4, 4, '2', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(7, 4, '4', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(1, 5, '2', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(5, 5, 'P/NP', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(4, 5, 'P/NP', false);
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
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(8, 10, 'P/NP', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(4, 10, '2', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(1, 44, '2', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(2, 44, '2', false);
INSERT INTO Section_Enrolllist (student_id, section_id, grade_option, waitlist) values(8, 44, '4', false);

INSERT INTO Meeting VALUES (1, 'LE', true, true, '03:00 PM', '05:00 PM', NULL, 'CTR01', 'Mon', 11);
INSERT INTO Meeting VALUES (2, 'LE', true, true, '03:00 PM', '05:00 PM', NULL, 'CTR01', 'Wed', 11);
INSERT INTO Meeting VALUES (3, 'LE', true, true, '02:00 PM', '03:00 PM', NULL, 'CTR02', 'Mon', 2);
INSERT INTO Meeting VALUES (4, 'LE', true, true, '02:00 PM', '03:00 PM', NULL, 'CTR02', 'Thu', 2);
INSERT INTO Meeting VALUES (5, 'LE', true, true, '02:00 PM', '03:00 PM', NULL, 'CTR03', 'Mon', 22);
INSERT INTO Meeting VALUES (6, 'LE', true, true, '02:00 PM', '03:00 PM', NULL, 'CTR03', 'Thu', 22);
INSERT INTO Meeting VALUES (7, 'DI', true, true, '11:00 AM', '12:00 PM', NULL, 'CTR13', 'Fri', 22);
INSERT INTO Meeting VALUES (8, 'LE', true, true, '02:00 PM', '04:00 PM', NULL, 'CTR04', 'Mon', 3);
INSERT INTO Meeting VALUES (9, 'LE', true, true, '02:00 PM', '04:00 PM', NULL, 'CTR04', 'Wed', 3);
INSERT INTO Meeting VALUES (10, 'LE', true, true, '02:00 PM', '04:00 PM', NULL, 'CTR05', 'Mon', 33);
INSERT INTO Meeting VALUES (11, 'LE', true, true, '02:00 PM', '04:00 PM', NULL, 'CTR05', 'Wed', 33);
INSERT INTO Meeting VALUES (12, 'LE', true, true, '03:00 PM', '05:00 PM', NULL, 'CTR01', 'Tue', 1);
INSERT INTO Meeting VALUES (13, 'LE', true, true, '03:00 PM', '05:00 PM', NULL, 'CTR01', 'Thu', 1);
INSERT INTO Meeting VALUES (14, 'DI', true, true, '10:00 AM', '11:00 AM', NULL, 'CTR11', 'Tue', 1);
INSERT INTO Meeting VALUES (15, 'DI', true, true, '10:00 AM', '11:00 AM', NULL, 'CTR12', 'Tue', 11);
INSERT INTO Meeting VALUES (16, 'DI', true, true, '11:00 AM', '12:00 PM', NULL, 'CTR11', 'Fri', 2);
INSERT INTO Meeting VALUES (17, 'LAB', true, true, '10:00 AM', '12:00 PM', NULL, 'EBUB3', 'Wed', 3);
INSERT INTO Meeting VALUES (18, 'LAB', true, true, '10:00 AM', '12:00 PM', NULL, 'EBUB4', 'Wed', 33);

INSERT INTO Requirement (require_id, units, degree, gpa, description) values(1, 30, 'bs', 2.0, 'TU');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(2, 12, 'ba', 2.0, 'ba2');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(3, 4, 'master', 2.0, 'Systems');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(4, 14, 'phd', 2.0, 'phd4');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(5, 8, 'bs', 2.0, 'LD');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(6, 12, 'bs', 2.0, 'UD');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(7, 8, 'bs', 2.0, 'TE');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(8, 4, 'master', 3.0, 'Architecture');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(9, 8, 'master', 2.5, 'Databases');
INSERT INTO Requirement (require_id, units, degree, gpa, description) values(10, 12, 'master', 2.0, 'Theory');

INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 1);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 2);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 3);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 4);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 5);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 6);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 7);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 8);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 9);
INSERT INTO Dept_requirement (dept_name, require_id) values('Computer_Science', 10);

INSERT INTO Concentration (name, description, dept_name, gpa, unit) values('Databases', 'database within cse', 'Computer_Science', 2.0, 12);
INSERT INTO Concentration (name, description, dept_name, gpa, unit) values('Theory', 'software within cse', 'Computer_Science', 2.0, 12);
INSERT INTO Concentration (name, description, dept_name, gpa, unit) values('Systems', 'systems within cse', 'Computer_Science', 2.0, 12);
INSERT INTO Concentration (name, description, dept_name, gpa, unit) values('Architecture', 'architecture within cse', 'Computer_Science', 2.0, 12);

INSERT INTO Concentration_course (con_name, course_id) values('Theory', 2);
INSERT INTO Concentration_course (con_name, course_id) values('Theory', 12);
INSERT INTO Concentration_course (con_name, course_id) values('Theory', 13);
INSERT INTO Concentration_course (con_name, course_id) values('Systems', 3);
INSERT INTO Concentration_course (con_name, course_id) values('Systems', 5);
INSERT INTO Concentration_course (con_name, course_id) values('Systems', 6);
INSERT INTO Concentration_course (con_name, course_id) values('Databases', 7);
INSERT INTO Concentration_course (con_name, course_id) values('Databases', 10);
INSERT INTO Concentration_course (con_name, course_id) values('Databases', 11);
INSERT INTO Concentration_course (con_name, course_id) values('Architecture', 4);

INSERT INTO Graduate (grad_id, in_dept) values(6, 'Computer_Science');
INSERT INTO Graduate (grad_id, in_dept) values(7, 'Computer_Science');
INSERT INTO Graduate (grad_id, in_dept) values(8, 'Computer_Science');
INSERT INTO Graduate (grad_id, in_dept) values(9, 'Computer_Science');

INSERT INTO Master (master_id, con_name) values(6, 'Theory'); 
INSERT INTO Master (master_id, con_name) values(7, 'Databases');
INSERT INTO Master (master_id, con_name) values(8, 'Theory');

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

