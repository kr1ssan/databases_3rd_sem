SELECT ki.name
FROM konditerskoe_izdelie ki LEFT JOIN sostav s
                             ON ki.id_ki = s.id_ki
GROUP BY ki.name
HAVING COUNT(s.id_ki) = 0


SELECT CONCAT(ФИО)
FROM Студенты с JOIN Студенты с2
                ON c.id_студента <> с2.id_студента
WHERE с.стипендия > (SELECT AVG(с.стипендия)
                                    FROM Студенты с2
                                    WHERE с.курс = )