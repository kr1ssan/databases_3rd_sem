--41.Вывести названия модель, автомобилей которых нет в БД
SELECT md."model_name"
FROM public."Model" md LEFT JOIN public."Car" cr 
     ON md.id_model = cr.id_model
GROUP BY md."model_name"
HAVING COUNT(cr.*) = 0

--42.Вывести ФИО владельца, который имеет больше других автомобилей
SELECT CONCAT (o.surname, ' ', o.name, ' ', o.middle_name)
FROM public."Owner" o
	 JOIN public."Car" cr
	 ON o."id_owner" = cr."id_owner"
GROUP BY CONCAT (o.surname, ' ', o.name, ' ', o.middle_name)
ORDER BY COUNT (cr.*) DESC LIMIT 1

--43.Вывести номера автомобилей, которые не попадали в ДТП.
SELECT cr."reg_number"
FROM public."Car" cr LEFT JOIN public."DTP_number" dn
     ON cr.id_car = dn.id_car
GROUP BY cr."id_car"
HAVING COUNT(dn.*) = 0

--44.Вывести ФИО владельцев, которые не попадали в ДТП по своей вине.
SELECT CONCAT (o.surname, ' ', o.name, ' ', o.middle_name)
FROM public."Owner" o
	 JOIN public."Car" cr
	 ON o."id_owner" = cr."id_owner"
	 JOIN public."DTP_number" dn
     ON cr.id_car = dn.id_car
WHERE dn."guilt" <> true
GROUP BY CONCAT (o.surname, ' ', o.name, ' ', o.middle_name)


--45.Вывести ФИО владельца, который имеет Ford и KIA, но не имеет Ниву. ????
SELECT CONCAT (o.surname, ' ', o.name, ' ', o.middle_name)
FROM public."Owner" o
	 JOIN public."Car" cr
	 ON o."id_owner" = cr."id_owner"
	 JOIN public."Model" md
	 ON cr."id_model" = md."id_model"
GROUP BY CONCAT (o.surname, ' ', o.name, ' ', o.middle_name)
HAVING (md.id_marka = 10 OR md.id_marka = 11) AND md.id_model <> 12

--46.Вывести название марок и название моделей в одном столбце
SELECT mr."name" 
FROM public."Marka" mr
UNION SELECT md."model_name" 
FROM public."Model" md

--47.Ввести дату и время ДТП, в котором больше всего автомашин.
SELECT distinct dtp.date, dtp.time
FROM public."DTP" dtp JOIN public."DTP_number" dn
					  ON dtp."id_DTP" = dn."id_DTP"
WHERE dtp."id_DTP" = (
	SELECT dtp."id_DTP"
	FROM public."DTP" dtp JOIN public."DTP_number" dn
					      ON dtp."id_DTP" = dn."id_DTP"
	GROUP BY dtp."id_DTP"
	ORDER BY COUNT(dn.id_car) DESC LIMIT 1
					 )

--48.Вывести дату время трех последних ДТП.
with cte1 as (
  select max(dtp.date) max_date, dtp."id_DTP"
  from public."DTP" dtp
  group by dtp."id_DTP"
),
cte2 as (
  select max(cte1.max_date), max(dtp.time), dtp."id_DTP"
  from public."DTP" dtp
  join cte1 on dtp."id_DTP" = cte1."id_DTP"
  GROUP BY dtp."id_DTP"
)
SELECT distinct cte2.*, dtp.date, dtp.time 
FROM public."DTP" dtp JOIN cte2 
				  ON dtp."id_DTP" = cte2."id_DTP"
ORDER BY dtp.date DESC, dtp.time DESC LIMIT 3

--49. Выбрать ФИО владельца, номер автомобиля, название марки и модели для всех автомобилей и если были у автомобиля ДТП, 
--то дату последнего ДТП
SELECT CONCAT (o.surname, ' ', o.name, ' ', o.middle_name), cr.reg_number, mr.name, md.model_name, MAX(dtp.date)
FROM public."Car" cr
     JOIN public."Model" md
	 ON cr."id_model" = md."id_model"
	 JOIN public."Marka" mr
	 ON md."id_marka" = mr."id_marka"
	 JOIN public."Owner" o
	 ON cr."id_owner" = o."id_owner"
	 LEFT JOIN public."DTP_number" dn
	 ON cr."id_car" = dn."id_car"
	 LEFT JOIN public."DTP" dtp
	 ON dn."id_DTP" = dtp."id_DTP"
GROUP BY CONCAT (o.surname, ' ', o.name, ' ', o.middle_name), cr.reg_number, mr.name, md.model_name

--50.Выбрать ФИО владельцев, номер автомобилей, название марки и модели для автомобилей попавших дважды в ДТП за один день. ????
SELECT CONCAT (o.surname, ' ', o.name, ' ', o.middle_name), cr.reg_number, mr.name, md.model_name
FROM public."Car" cr
     JOIN public."Model" md
	 ON cr."id_model" = md."id_model"
	 JOIN public."Marka" mr
	 ON md."id_marka" = mr."id_marka"
	 JOIN public."Owner" o
	 ON cr."id_owner" = o."id_owner"
	 LEFT JOIN public."DTP_number" dn
	 ON cr."id_car" = dn."id_car"
	 LEFT JOIN public."DTP" dtp
	 ON dn."id_DTP" = dtp."id_DTP"
GROUP BY CONCAT (o.surname, ' ', o.name, ' ', o.middle_name), cr.reg_number, mr.name, md.model_name
HAVING COUNT(dn.*) > 2

--51.Вывести название самой популярной марки
SELECT mr.name
FROM public."Marka" mr join public."Model" md
on mr."id_marka" = md."id_marka"
GROUP BY mr.name, mr.id_marka
HAVING SUM(md.id_marka) = 
(
SELECT MAX(count_marks) FROM (SELECT SUM(md1.id_marka) as count_marks
FROM public."Model" md1 JOIN public."Marka" mr1
ON mr1."id_marka" = md1."id_marka"
GROUP BY md1.id_marka)as subquery)