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

/* add grade sc trigger */
CREATE OR REPLACE FUNCTION addGrade() RETURNS trigger AS $addGradeSC$
BEGIN 
	UPDATE CPQG c
	SET num_of_a = num_of_a + 1
	WHERE (NEW.grade = 'A' OR NEW.grade = 'A+' OR NEW.grade = 'A-')
	AND c.class_id = NEW.class_id
	AND c.instructor_ssn = NEW.instructor_ssn;
	
	UPDATE CPQG c
	SET num_of_b = num_of_b + 1
	WHERE (NEW.grade = 'B' OR NEW.grade = 'B+' OR NEW.grade = 'B-')
	AND c.class_id = NEW.class_id
	AND c.instructor_ssn = NEW.instructor_ssn;
	
	UPDATE CPQG c
	SET num_of_c = num_of_c + 1
	WHERE (NEW.grade = 'C' OR NEW.grade = 'C+' OR NEW.grade = 'C-')
	AND c.class_id = NEW.class_id
	AND c.instructor_ssn = NEW.instructor_ssn;
	
	UPDATE CPQG c
	SET num_of_d = num_of_d + 1
	WHERE NEW.grade = 'D' 
	AND c.class_id = NEW.class_id
	AND c.instructor_ssn = NEW.instructor_ssn;
	
	UPDATE CPQG c
	SET num_of_other = num_of_other + 1
	WHERE (NEW.grade = 'P' OR NEW.grade = 'NP' OR NEW.grade = 'F')
	AND c.class_id = NEW.class_id
	AND c.instructor_ssn = NEW.instructor_ssn;
	
	RETURN NULL;
END; 
$addGradeSC$ LANGUAGE plpgsql;

CREATE TRIGGER addGradeSC
AFTER INSERT ON Student_Class
FOR EACH ROW EXECUTE PROCEDURE addGrade();

/* check function exists */
select pg_get_functiondef('addgrade()'::regprocedure);

CREATE OR REPLACE FUNCTION addGradeYear() RETURNS trigger AS $addGradeYearSC$
BEGIN 
	UPDATE CPG c
	SET num_of_a = num_of_a + 1
	WHERE (NEW.grade = 'A' OR NEW.grade = 'A+' OR NEW.grade = 'A-')
	AND c.class_name IN (SELECT cl.class_name FROM Class cl  WHERE cl.class_id = NEW.class_id)
	AND c.instructor_ssn = NEW.instructor_ssn;
	
	UPDATE CPG c
	SET num_of_b = num_of_b + 1
	WHERE (NEW.grade = 'B' OR NEW.grade = 'B+' OR NEW.grade = 'B-')
	AND c.class_name IN (SELECT cl.class_name FROM Class cl  WHERE cl.class_id = NEW.class_id)
	AND c.instructor_ssn = NEW.instructor_ssn;
	
	UPDATE CPG c
	SET num_of_c = num_of_c + 1
	WHERE (NEW.grade = 'C' OR NEW.grade = 'C+' OR NEW.grade = 'C-')
	AND c.class_name IN (SELECT cl.class_name FROM Class cl  WHERE cl.class_id = NEW.class_id)
	AND c.instructor_ssn = NEW.instructor_ssn;
	
	UPDATE CPG c
	SET num_of_d = num_of_d + 1
	WHERE NEW.grade = 'D' 
	AND c.class_name IN (SELECT cl.class_name FROM Class cl  WHERE cl.class_id = NEW.class_id)
	AND c.instructor_ssn = NEW.instructor_ssn;
	
	UPDATE CPG c
	SET num_of_other = num_of_other + 1
	WHERE (NEW.grade = 'P' OR NEW.grade = 'NP' OR NEW.grade = 'F')
	AND c.class_name IN (SELECT cl.class_name FROM Class cl  WHERE cl.class_id = NEW.class_id)
	AND c.instructor_ssn = NEW.instructor_ssn;
	
	RETURN NULL;
END; 
$addGradeYearSC$ LANGUAGE plpgsql;

CREATE TRIGGER addGradeYearSC
AFTER INSERT ON Student_Class
FOR EACH ROW EXECUTE PROCEDURE addGradeYear();

/* update grade sc trigger */
CREATE OR REPLACE FUNCTION updateGrade() RETURNS trigger AS $updateGradeSC$
BEGIN 
	UPDATE CPQG c SET num_of_a = num_of_a + 1
	WHERE (NEW.grade = 'A' OR NEW.grade = 'A+' OR NEW.grade = 'A-')
	AND c.class_id = NEW.class_id AND c.instructor_ssn = NEW.instructor_ssn
	AND NEW.grade <> OLD.grade;
	
	UPDATE CPQG c SET num_of_b = num_of_b + 1
	WHERE (NEW.grade = 'B' OR NEW.grade = 'B+' OR NEW.grade = 'B-')
	AND c.class_id = NEW.class_id AND c.instructor_ssn = NEW.instructor_ssn
	AND NEW.grade <> OLD.grade;
	
	UPDATE CPQG c SET num_of_c = num_of_c + 1
	WHERE (NEW.grade = 'C' OR NEW.grade = 'C+' OR NEW.grade = 'C-')
	AND c.class_id = NEW.class_id AND c.instructor_ssn = NEW.instructor_ssn
	AND NEW.grade <> OLD.grade;
	
	UPDATE CPQG c SET num_of_d = num_of_d + 1
	WHERE NEW.grade = 'D' AND c.class_id = NEW.class_id AND c.instructor_ssn = NEW.instructor_ssn
	AND NEW.grade <> OLD.grade;
	
	UPDATE CPQG c SET num_of_other = num_of_other + 1
	WHERE (NEW.grade = 'P' OR NEW.grade = 'NP' OR NEW.grade = 'F')
	AND c.class_id = NEW.class_id AND c.instructor_ssn = NEW.instructor_ssn
	AND NEW.grade <> OLD.grade;
	
	UPDATE CPQG c SET num_of_a = num_of_a - 1
	WHERE (OLD.grade = 'A' OR OLD.grade = 'A+' OR OLD.grade = 'A-')
	AND c.class_id = OLD.class_id AND c.instructor_ssn = OLD.instructor_ssn
	AND NEW.grade <> OLD.grade;
	
	UPDATE CPQG c SET num_of_b = num_of_b - 1
	WHERE (OLD.grade = 'B' OR OLD.grade = 'B+' OR OLD.grade = 'B-')
	AND c.class_id = OLD.class_id AND c.instructor_ssn = OLD.instructor_ssn
	AND NEW.grade <> OLD.grade;
	
	UPDATE CPQG c SET num_of_c = num_of_c - 1
	WHERE (OLD.grade = 'C' OR OLD.grade = 'C+' OR OLD.grade = 'C-')
	AND c.class_id = OLD.class_id AND c.instructor_ssn = OLD.instructor_ssn
	AND NEW.grade <> OLD.grade;
	
	UPDATE CPQG c SET num_of_d = num_of_d - 1 WHERE OLD.grade = 'D'
	AND c.class_id = OLD.class_id AND c.instructor_ssn = OLD.instructor_ssn
	AND NEW.grade <> OLD.grade;
	
	UPDATE CPQG c SET num_of_other = num_of_other - 1
	WHERE (OLD.grade = 'P' OR OLD.grade = 'NP' OR OLD.grade = 'F')
	AND c.class_id = OLD.class_id AND c.instructor_ssn = OLD.instructor_ssn
	AND NEW.grade <> OLD.grade;
	
	RETURN NULL; END; $updateGradeSC$ LANGUAGE plpgsql;

CREATE TRIGGER updateGradeSC
AFTER UPDATE ON Student_Class
FOR EACH ROW EXECUTE PROCEDURE updateGrade();

/* update grade year sc trigger */
CREATE OR REPLACE FUNCTION updateGradeYear() RETURNS trigger AS $updateGradeYearSC$
BEGIN 
	UPDATE CPG c SET num_of_a = num_of_a + 1
	WHERE (NEW.grade = 'A' OR NEW.grade = 'A+' OR NEW.grade = 'A-')
	AND c.class_name IN (SELECT cl.class_name FROM Class cl WHERE cl.class_id = NEW.class_id) 
	AND c.instructor_ssn = NEW.instructor_ssn AND NEW.grade <> OLD.grade;
	
	UPDATE CPG c SET num_of_b = num_of_b + 1
	WHERE (NEW.grade = 'B' OR NEW.grade = 'B+' OR NEW.grade = 'B-')
	AND c.class_name IN (SELECT cl.class_name FROM Class cl WHERE cl.class_id = NEW.class_id) 
	AND c.instructor_ssn = NEW.instructor_ssn AND NEW.grade <> OLD.grade;
	
	UPDATE CPG c SET num_of_c = num_of_c + 1
	WHERE (NEW.grade = 'C' OR NEW.grade = 'C+' OR NEW.grade = 'C-')
	AND c.class_name IN (SELECT cl.class_name FROM Class cl WHERE cl.class_id = NEW.class_id) 
	AND c.instructor_ssn = NEW.instructor_ssn AND NEW.grade <> OLD.grade;
	
	UPDATE CPG c SET num_of_d = num_of_d + 1
	WHERE NEW.grade = 'D' 
	AND c.class_name IN (SELECT cl.class_name FROM Class cl WHERE cl.class_id = NEW.class_id) 
	AND c.instructor_ssn = NEW.instructor_ssn AND NEW.grade <> OLD.grade;
	
	UPDATE CPG c SET num_of_other = num_of_other + 1
	WHERE (NEW.grade = 'P' OR NEW.grade = 'NP' OR NEW.grade = 'F')
	AND c.class_name IN (SELECT cl.class_name FROM Class cl WHERE cl.class_id = NEW.class_id) 
	AND c.instructor_ssn = NEW.instructor_ssn AND NEW.grade <> OLD.grade;
	
	UPDATE CPG c SET num_of_a = num_of_a - 1
	WHERE (OLD.grade = 'A' OR OLD.grade = 'A+' OR OLD.grade = 'A-')
	AND c.class_name IN (SELECT cl.class_name FROM Class cl WHERE cl.class_id = OLD.class_id) 
	AND c.instructor_ssn = OLD.instructor_ssn AND NEW.grade <> OLD.grade;
	
	UPDATE CPG c SET num_of_b = num_of_b - 1
	WHERE (OLD.grade = 'B' OR OLD.grade = 'B+' OR OLD.grade = 'B-')
	AND c.class_name IN (SELECT cl.class_name FROM Class cl WHERE cl.class_id = OLD.class_id) 
	AND c.instructor_ssn = OLD.instructor_ssn AND NEW.grade <> OLD.grade;
	
	UPDATE CPG c SET num_of_c = num_of_c - 1
	WHERE (OLD.grade = 'C' OR OLD.grade = 'C+' OR OLD.grade = 'C-')
	AND c.class_name IN (SELECT cl.class_name FROM Class cl WHERE cl.class_id = OLD.class_id) 
	AND c.instructor_ssn = OLD.instructor_ssn AND NEW.grade <> OLD.grade;
	
	UPDATE CPG c SET num_of_d = num_of_d - 1 WHERE OLD.grade = 'D'
	AND c.class_name IN (SELECT cl.class_name FROM Class cl WHERE cl.class_id = OLD.class_id) 
	AND c.instructor_ssn = OLD.instructor_ssn AND NEW.grade <> OLD.grade;
	
	UPDATE CPG c SET num_of_other = num_of_other - 1
	WHERE (OLD.grade = 'P' OR OLD.grade = 'NP' OR OLD.grade = 'F')
	AND c.class_name IN (SELECT cl.class_name FROM Class cl WHERE cl.class_id = OLD.class_id) 
	AND c.instructor_ssn = OLD.instructor_ssn AND NEW.grade <> OLD.grade;
	
	RETURN NULL; END; $updateGradeYearSC$ LANGUAGE plpgsql;

CREATE TRIGGER updateGradeYearSC
AFTER UPDATE ON Student_Class
FOR EACH ROW EXECUTE PROCEDURE updateGradeYear();