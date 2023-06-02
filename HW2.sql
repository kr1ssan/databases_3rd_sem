SELECT *
FROM position P;

SELECT *
FROM discipline D 
ORDER BY D.name ASC;

SELECT CONCAT(C.surname)
FROM students С 
ORDER BY С.surname DESC;

SELECT DISTINCT EXTRACT(YEAR FROM C.date_of_birth)
FROM students С 
ORDER BY EXTRACT(YEAR FROM C.date_of_birth) DESC;

SELECT T.surname, T.name, T.middlename
FROM teachers T 
ORDER BY T.surname DESC, T.name ASC, T.middlename DESC;

SELECT P.name
FROM position P
WHERE P.salary > 50000;

SELECT C.surname + SUBSTRING (C.name, 1, 1) + SUBSTRING (C.middlename, 1, 1) AS student
FROM students C 
WHERE C.number IS NULL OR C.scholarship IS NULL OR C.group IS NULL и так далее по остальным столбцам
ORDER BY C.surname ASC;

SELECT C.surname, C.name, C.middlename, C.Course, C.group
FROM sudents C 
WHERE C.scholarship > 2500
ORDER BY C.course ASC, C.group ASC, C.surname ASC, C.name ASC, C.middlename ASC;

SELECT C.surname, C.name, C.middlename
FROM sudents C 
WHERE C.course NOT IN [1, 4] AND C.group IN [9, 10, 14, 91]
ORDER BY C.group DESC, C.course ASC, C.surname, C.name, C.middlename;

SELECT F.name
FROM faculties F
WHERE F.id_faculty IN [2, 3, 5, 6, 7, 10]
ORDER BY F.name DESC;

SELECT F.name
FROM faculties F
WHERE F.id_faculty NOT IN [2, 3, 5, 6, 7, 10]
ORDER BY F.name DESC;

SELECT P.name 
FROM position P;
WHERE P.name LIKE 'A%' OR P.name LIKE 'П%';

SELECT *
FROM discipline D 
WHERE D.name LIKE '%"%"%';

SELECT *
FROM students C
WHERE C.surname LIKE '%-%' and C.middlename IS NULL;

SELECT C.number, C.name, C.surname, C.middlename
FROM students C
WHERE C.email LIKE '%mail%' OR C.email LIKE '%gmail%' OR C.email LIKE '%+%' OR C.email LIKE '%@_%' ESCAPE '@';

SELECT *
FROM students C
WHERE C.name LIKE '%Иван%' OR C.surname LIKE '%Иван%' OR C.name LIKE '%Иван%';

SELECT D.name
FROM discipline D 
WHERE D.name LIKE '%_ _%';

SELECT D.name
FROM discipline D 
WHERE D.name NOT LIKE '% %';

SELECT *
FROM discipline D 
WHERE D.code LIKE '%@_%' ESCAPE '@'
ORDER BY D.code;

SELECT D.name
FROM discipline D 
WHERE D.name LIKE '% %' AND D.name NOT LIKE '% % %';

SELECT D.name
FROM discipline D 
WHERE TRIM(D.name) LIKE '% % %';

SELECT D.name
FROM discipline D 
WHERE D.code !~* '[^0-9]'


3, 7, 10, 23, 26

SELECT
FROM faculties F JOIN students S
    ON

