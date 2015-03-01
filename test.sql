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