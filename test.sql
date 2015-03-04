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