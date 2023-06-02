--11. Найти среднюю стоимость автомобилей
SELECT ROUND(AVG(cost), 1) AS average_price 
FROM public."Model"

-- 12. Выбрать общее количество автомобилей в базе
SELECT COUNT(*)
FROM public."Car"

-- 13. Выбрать общее количество различных имен владельцев в базе
SELECT DISTINCT(COUNT(name))
FROM public."Owner"

-- 14. Найти максимальную и минимальную стоимость автомобилей модели Camry
SELECT MIN(m.cost), MAX(m.cost)
FROM public."Model" M
WHERE m.model_name LIKE 'Camry';

-- 15. Найти суммарную стоимость автомобилей с четными id_марки
SELECT SUM(m.cost)
FROM public."Model" M
WHERE MOD(m.id_marka, 2) = 0

--16. Для каждого автомобиля выбрать количество ДТП, в которых он участвовал.
SELECT id_car, count(*)
FROM public."DTP_number"
GROUP BY id_car

--18. Для каждого автомобиля выбрать количество ДТП, в которых он участвовал за последние три года (2016, 2015, 2014).
SELECT cr."id_car", count(dn.*)
FROM public."DTP_number" dn FULL JOIN public."Car" cr
				  ON dn."id_car" = cr."id_car"
				  full JOIN public."DTP" d
				  ON d."id_DTP" = dn."id_DTP" and EXTRACT(YEAR FROM age(CURRENT_DATE)) - EXTRACT(YEAR FROM age(d."date")) <= 3
GROUP BY cr."id_car"
--HAVING EXTRACT(YEAR FROM age(CURRENT_DATE)) - EXTRACT(YEAR FROM age(d."date")) <= 3

--21. Для каждого id автомобиля вывести количество ДТП, в которых
--автомобиль участвовал. В результат включить только те ДТП, в которых
--признана виновность водителя. Результат отсортировать по убыванию количества ДТП.
SELECT cr."id_car", COUNT(dn.*)
FROM public."DTP" d JOIN public."DTP_number" dn
				  ON d."id_DTP" = dn."id_DTP" and dn."guilt" = true
				  FULL JOIN public."Car" cr
				  ON dn."id_car" = cr."id_car"
GROUP BY cr."id_car"
ORDER BY COUNT(dn.*) DESC;

--22.Для каждого id автомобиля вывести количество ДТП, в которых
--автомобиль участвовал. В результат включить только те автомобили,
--которые побывали в 3 ДТП и более.
SELECT dn."id_car", COUNT(dn.*)
FROM public."DTP" d JOIN public."DTP_number" dn
				  ON d."id_DTP" = dn."id_DTP"
GROUP BY dn."id_car"
HAVING COUNT(dn.*) >= 3

--23. Для каждой id марки вывести количество различных автомобилей, в
--номере которых есть буквы о и а. В результат включить только те марки,
--количество автомобилей которых более двух.
SELECT md."id_marka", COUNT(DISTINCT(cr.*))
FROM public."DTP_number" dn
				  JOIN public."Car" cr 
				  ON dn."id_car" = cr."id_car"
				  JOIN public."Model" md
				  ON cr."id_model" = md."id_model"
WHERE cr."reg_number" LIKE '%A%' AND cr."reg_number" LIKE '%O%'
GROUP BY md."id_marka"
HAVING COUNT(DISTINCT(cr.*)) >= 2

-- 24.Выбрать ФИО владельца (в одном столбце) и номер автомобиля.
-- Результат отсортировать в лексикографическом порядке.
SELECT CONCAT(o.name,' ', o.middle_name, ' ', o.surname) AS fio, c.reg_number
FROM public."Owner" O JOIN public."Car" C 
    ON O.id_owner = C.id_owner
ORDER BY fio ASC, c.reg_number ASC;

--25.Выбрать ФИО владельца, номер автомобиля, модель, марку, дату и время
--ДТП, виновность. Результат отсортировать по ФИО владельца в порядке
--обратном лексикографическому, по номеру автомобиля в
--лексикографическом порядке.

SELECT o."surname", o."name", o."middle_name", cr."reg_number", md."model_name", mr."name", d."date", d."time", dn."guilt"
FROM public."DTP" d JOIN public."DTP_number" dn
				  ON d."id_DTP" = dn."id_DTP"
				  JOIN public."Car" cr 
				  ON dn."id_car" = cr."id_car"
				  JOIN public."Model" md
				  ON cr."id_model" = md."id_model"
				  JOIN public."Marka" mr
				  ON md."id_marka" = mr."id_marka"
				  JOIN public."Owner" o
				  ON cr."id_owner" = o."id_owner"
ORDER BY o."surname" DESC, o."name" DESC, o."middle_name" DESC, cr."reg_number" ASC



