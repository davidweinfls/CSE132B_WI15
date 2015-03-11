select m.start_time, m.end_time, m.day, m.section_id, s.class_id, c.class_name 
FROM meeting m, section s, Class c, Section_enrolllist se 
WHERE m.section_id = s.section_id AND s.class_id = c.class_id AND se.student_id = 1 
AND se.section_id = s.section_id 
ORDER BY s.section_id;

select m.start_time, m.end_time,m.day, m.section_id,c.class_id, c.class_name 
FROM Meeting m, Section s, Class c 
WHERE m.section_id = s.section_id AND s.class_id = c.class_id 
AND c.quarter = 'Spring' AND c.year = 2009  
AND c.class_id NOT IN (SELECT class_id FROM Student_Class WHERE student_id = 1) 
ORDER BY c.class_id;

SELECT s.*, se.grade_option 
FROM Class c, Course cou, Student_class sc, Section sec, Section_Enrolllist se, Student s
WHERE c.class_name = cou.course_name AND cou.title IN (SELECT cou.title FROM Course cou, Class c  
													   WHERE cou.course_name = c.class_name AND c.class_id = 1) 
AND sc.class_id = c.class_id AND sc.student_id = s.student_id 
AND sec.class_id = c.class_id
AND se.section_id = sec.section_id AND se.student_id = s.student_id;


SELECT sc.*
FROM Section sec, Section_Enrolllist se, Student_Class sc
WHERE sec.section_id = se.section_id
AND se.student_id = sc.student_id
AND sc.class_id = sec.class_id
AND sc.class_id = 8;

SELECT sc.*
FROM Student_Class sc, Section sec, Section_enrolllist se, Class c
WHERE c.class_name = 'CSE1' AND c.class_id = sec.class_id 
AND sec.section_id = se.section_id AND se.student_id = sc.student_id
AND sc.class_id = sec.class_id
AND sec.instructor_ssn = '100-00-0000';

/* 3.a.ii */
CREATE TABLE CPQG AS (SELECT sec.class_id, sec.instructor_ssn, c.quarter, c.year, 
	SUM(CASE WHEN (sc.grade = 'A' OR sc.grade = 'A+' OR sc.grade = 'A-') THEN 1 ELSE 0 END) AS NUM_OF_A, 
	SUM(CASE WHEN (sc.grade = 'B' OR sc.grade = 'B+' OR sc.grade = 'B-') THEN 1 ELSE 0 END) AS NUM_OF_B, 
	SUM(CASE WHEN (sc.grade = 'C' OR sc.grade = 'C+' OR sc.grade = 'C-') THEN 1 ELSE 0 END) AS NUM_OF_C,
	SUM(CASE WHEN sc.grade = 'D' THEN 1 ELSE 0 END) AS NUM_OF_D,
	SUM(CASE WHEN (sc.grade = 'P' OR sc.grade = 'NP' OR sc.grade = 'F') THEN 1 ELSE 0 END) AS NUM_OF_Other
FROM Section sec, Section_Enrolllist se, Student_Class sc, Class c
WHERE sec.section_id = se.section_id
AND se.student_id = sc.student_id
AND sc.class_id = sec.class_id
AND sec.class_id = c.class_id
GROUP BY sec.class_id, sec.instructor_ssn, c.quarter, c.year
ORDER BY sec.instructor_ssn);

/* 3.a.iii */
CREATE TABLE CPG AS (SELECT c.class_name, sec.instructor_ssn, 
	SUM(CASE WHEN (sc.grade = 'A' OR sc.grade = 'A+' OR sc.grade = 'A-') THEN 1 ELSE 0 END) AS NUM_OF_A, 
	SUM(CASE WHEN (sc.grade = 'B' OR sc.grade = 'B+' OR sc.grade = 'B-') THEN 1 ELSE 0 END) AS NUM_OF_B, 
	SUM(CASE WHEN (sc.grade = 'C' OR sc.grade = 'C+' OR sc.grade = 'C-') THEN 1 ELSE 0 END) AS NUM_OF_C,
	SUM(CASE WHEN sc.grade = 'D' THEN 1 ELSE 0 END) AS NUM_OF_D,
	SUM(CASE WHEN (sc.grade = 'P' OR sc.grade = 'NP' OR sc.grade = 'F') THEN 1 ELSE 0 END) AS NUM_OF_Other
FROM Section sec, Section_Enrolllist se, Student_Class sc, Class c
WHERE sec.section_id = se.section_id
AND se.student_id = sc.student_id
AND sc.class_id = sec.class_id
AND sec.class_id = c.class_id
GROUP BY sec.instructor_ssn, c.class_name
ORDER BY sec.instructor_ssn);
