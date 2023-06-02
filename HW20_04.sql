ДЗ. стр.22 задачи 1-3, 7, 9-13.
стр.26 задачи 17-22

--22.1
SELECT MAX(стипендия), MIN(стипендия), группа
FROM студенты
GROUP BY группа

--22.2
SELECT MAX(стипендия), MIN(стипендия), группа
FROM студенты
GROUP BY курс, группа
ORDER BY 1, 2;

--22.3 ???
SELECT дата_рождения, курс
FROM студенты
GROUP BY курс
HAVING MAX(дата_рождения)

--22.7
SELECT EXTRACT(month from (CURRENT_DATE)), count(*), курс
FROM студенты
WHERE EXTRACT(month from (CURRENT_DATE)) = EXTRACT(month from (дата_рождения)) AND курс = 1
GROUP BY курс

--22.9
SELECT ф.id_факультета, count (п.*)
FROM преподаватели п
WHERE п.id_факультета = 2 OR п.id_факультета = 3 OR п.id_факультета = 5 Or п.id_факультета = 7
GROUP BY п.id_факультета 
HAVING count(п.*) > 100

--22.10
SELECT MAX(стипендия), MIN(Стипендия), курс
FROM студенты
WHERE курс = 1 OR курс = 2
GROUP BY курс


--22.11 ???
SELECT фамилия, count(*)
FROM студенты
WHERE курс IN (1, 2)
GROUP BY фамилия
HAVING count(*) > 3
ORDER BY фамилия DESC


--22.12 ???

--22.13 ???

--26.17
SELECT AVG(у.оценка), SUM(у.оценка)
FROM успеваемость у JOIN студенты с
    ON у.номер_студ_билета = с.номер_студ_билета
GROUP BY с.номер_студ_билета

--26.18
SELECT AVG(у.оценка), с.фамилия, с.имя, с.курс, с.группа
FROM FROM успеваемость у JOIN студенты с
    ON у.номер_студ_билета = с.номер_студ_билета
GROUP BY у.номер_студ_билета

--26.19
SELECT д.название 
FROM

--26.21
SELECT у.дата, COUNT(*) 
FROM успеваемость у join дисциплины д
on y.id_дисциплины = д.id_дисциплины
GROUP BY у.дата
HAVING COUNT(*) > N;

--26.22

SELECT ф.название, д.фамилия, CONCAT(SUBSTR(д.имя, 1, 1), ' ', SUBSTR(д.отчество, 1, 1)) as инициалы, count(distinct с.н_стб), count(distinct п.id_преп)
FROM факультеты ф LEFT JOIN преподаватели д