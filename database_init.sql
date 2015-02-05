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
