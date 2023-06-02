--5
SELECT п.*
FROM преподаватели п
WHERE П.др = (SELECT MAX(пр.др)
              FROM преподаватели п)
           or (SELECT MIN(пр.др)
               FROM преподаватели п) 

--8
SELECT п.*
FROM преподаватели п
WHERE п.id_факультет IN (SELECT п.*
                         FROM преподаватели п
                         WHERE п.фамилия = 'Иванов'
                         п.имя = 'Иван'
                         п.отчество = 'Иванович')

--9
SELECT ф.название
FROM факультеты ф join студенты с
                  on Ф.id_факультет = с.id_факультет
WHERE с.стипендия < (SELECT AVG(с.стипендия)
                     FROM Студенты с join факультеты Ф
                     on Ф.id_факультет = с.id_факультет
                     WHERE ф.название = 'ПММ')

--11
SELECT ф.название
FROM факультеты ф 
WHERE ф.id_факультет NOT IN (SELECT п.id_факультет
                             FROM преподаватели п)

--12
SELECT c.*
FROM студенты с 
WHERE с.НСБ NOT IN (SELECT у.НСБ
                    FROM Успеваемость у)

--13
SELECT c.*
FROM студенты с JOIN (SELECT COUNT(c.*) as ст
                      FROM студенты с
                      GROUP BY С.Курс) AS ст_т
                on с.курс = ст_т.курс
WHERE ст_т.ст < 1000

--14
SELECT д.название
FROM должности д LEFT JOIN преподаватель_в_должности пд 
                 ON д.id_должности = пд.id_должности
WHERE пд.id_должности IS NULL OR пд.id_преподаватель NOT IN (SELECT п.id_преподаватель
                                                             FROM преподаватели п)

--17
SELECT distinct С.Курс, С.группа
FROM факультеты JOIN студенты с
                ON ф.id_факультет = с.id_факультет
WHERE ф.id_факультет IN (SELECT c.id_факультет
                         FROM студенты с JOIN Успеваемость у 
                         ON с.НСБ = у.НСБ
                         JOIN Дисциплины Д 
                         ON у.id_дисциплина = д.id_дисциплина
                         WHERE д.название = 'Базы Данных')


--18-22 ?????????