--26. Вывести номера автомобилей марки Mazda
SELECT cr."reg_number"
FROM public."Car" cr JOIN public."Model" md
					 ON cr."id_model" = md."id_model"
					 JOIN public."Marka" mr
					 ON md."id_marka" = mr."id_marka"
WHERE mr."name" LIKE 'Mazda'

--27. Вывести дату и время ДТП и количество автомобилей, задействованных в ДТП.
SELECT d."date", d."time", COUNT(dn.*)
FROM public."DTP" d JOIN public."DTP_number" dn
					ON d."id_DTP" = dn."id_DTP"
GROUP BY d."date", d."time"

--28. Вывести название моделей и марок автомобилей, которые были в пяти и более ДТП. ++
SELECT mr."name", md."model_name"
FROM public."DTP_number" dn 
	JOIN public."Car" cr 
	ON dn."id_car" = cr."id_car"
	JOIN public."Model" md
	ON cr."id_model" = md."id_model" 
	JOIN public."Marka" mr 
	ON mr."id_marka" = md."id_marka"
GROUP BY mr."name", md."model_name"
HAVING COUNT(dn.*) >= 5

--29. Вывести ФИО водителей, которые были виновны в трех и более ДТП в текущем году.
SELECT o."name", o."surname", o."middle_name"
FROM public."Owner" o
	 JOIN public."Car" cr
	 ON o."id_owner" = cr."id_owner"
	 JOIN public."DTP_number" dn
	 ON cr."id_car" = dn."id_car"	 
	 JOIN public."DTP" d
	 ON dn."id_DTP" = d."id_DTP"
WHERE EXTRACT(YEAR from CURRENT_DATE) = EXTRACT(YEAR from (d."date"))
GROUP BY o."name", o."surname", o."middle_name"
HAVING (SELECT COUNT (dn.*)
	   	FROM public."DTP_number" dn
	   	WHERE guilt IS true) >= 3

--30. Вывести названия ВСЕХ марок автомобилей, и если есть автомобили этой марки, то номер и модель. ?????
SELECT mr."name", cr."reg_number", md."model_name" 
FROM public."Marka" mr JOIN public."Model" md
					   ON mr."id_marka" = md."id_marka"
					   JOIN public."Car" cr
					   ON md."id_model" = cr."id_model"
GROUP BY mr."name", cr."reg_number", md."model_name" 

--31. Вывести марку, модель номер ВСЕХ автомобилей, и если были ДТП, в которых автомобиль был участником, то количество ДТП.
SELECT mr."name", cr."reg_number", md."model_name", COUNT(dn.*)
FROM public."Marka" mr JOIN public."Model" md
					   ON mr."id_marka" = md."id_marka"
					   JOIN public."Car" cr
					   ON md."id_model" = cr."id_model"
					   JOIN public."DTP_number" dn
					   ON cr."id_car" = dn."id_car"
GROUP BY mr."name", cr."reg_number", md."model_name"

--32. Выбрать время, дату и id ДТП, произошедших в один и тот же день, в одно и тоже время.
SELECT d."id_DTP", d."date", d."time"
FROM public."DTP" d JOIN public."DTP" dt
ON d."id_DTP" <> dt."id_DTP"
WHERE d."date" = dt."date" AND d."time" = dt."time"

--33. Найти однофамильцев, которые имеют автомобили одной и той же марки.


--34. Найти владельцев, чьё имя совпадает с названием автомобильной марки.


--35. Найти количество ДТП, в которых приняли участие автомобили одной марки с владельцами тезками.  ++
SELECT COUNT(dn.*)
FROM public."Owner" o 
     JOIN  public."Owner" ow
	 ON o."name" = ow."name"
	 JOIN public."Car" cr 
	 ON o."id_owner" = cr."id_owner"
	 JOIN public."Car" cr1
	 ON cr1."id_owner" = ow."id_owner"
	 JOIN public."DTP_number" dn
	 ON cr."id_car" = dn."id_car"
	 JOIN public."DTP_number" dn1
	 ON dn."id_DTP" = dn1."id_DTP" and cr1."id_car" = dn1."id_car"
	 JOIN public."Model" md
	 ON cr."id_model" = md."id_model"
	 JOIN public."Model" mdl
	 ON md."id_marka" = mdl."id_marka" and cr1."id_model" = mdl."id_model"
WHERE o."id_owner" > ow."id_owner"

--36. Вывести самую дешевую модель.
SELECT md."model_name", md."cost"
FROM public."Model" md
WHERE md."cost" = (SELECT MIN(md."cost") FROM public."Model" md)

--37. Вывести ФИО владельца, номер автомобиля самой дорогой модели.
SELECT o."name", o."surname", o."middle_name", cr."reg_number"
FROM public."Owner" o
	 JOIN public."Car" cr
	 ON o."id_owner" = cr."id_owner"
	 JOIN public."Model" md
	 ON cr."id_model" = md."id_model"
WHERE md."cost" = (SELECT MAX(md."cost") FROM public."Model" md)

--38. Для каждого автомобиля вывести дату и время последнего ДТП (наверное нужен цте) 38,39,40
with cte1 as (
  select dn.id_car, max(dtp.date) max_date
  from public."DTP" dtp join public."DTP_number" dn 
	                  on dtp."id_DTP" = dn."id_DTP"
  group by dn.id_car
),
cte2 as (
  select dn.id_car, max(cte1.max_date), max(dtp.time)
  from public."DTP" dtp join public."DTP_number" dn 
	                    on dtp."id_DTP" = dn."id_DTP"
  join cte1 on dn.id_car = cte1.id_car
  where cte1.max_date = dtp.date
  group by dn.id_car
)
SELECT  distinct cte2.*
FROM public."DTP_number" dn join cte2 on dn.id_car = cte2.id_car;

--39. Для каждого автомобиля вывести дату и время первого и последнего ДТП
with cte1 as (
  select dn.id_car, max(dtp.date) max_date, min(dtp.date) min_date
  from public."DTP" dtp join public."DTP_number" dn 
	                  on dtp."id_DTP" = dn."id_DTP"
  group by dn.id_car
),
cte2 as (
  select dn.id_car, max(cte1.max_date), max(dtp.time), min(cte1.min_date), min(dtp.time)
  from public."DTP" dtp join public."DTP_number" dn 
	                    on dtp."id_DTP" = dn."id_DTP"
  join cte1 on dn.id_car = cte1.id_car
  where cte1.max_date = dtp.date
  group by dn.id_car
)
SELECT distinct cte2.*
FROM public."DTP_number" dn join cte2 on dn.id_car = cte2.id_car;

--40. вывести те марки автомобилей, у которых для каждой модели есть хотя бы один зарегистрированный автомобиль
SELECT md."id_marka"
FROM public."Model" md LEFT JOIN public."Car" cr 
     				   ON md."id_model" = cr."id_model" 
GROUP BY md."id_marka"
HAVING COUNT (DISTINCT cr."id_model") = (
	SELECT COUNT(md2."id_model") 
	FROM public."Model" md2
    where md2."id_marka" = md."id_marka")
	   

--COUNT (distinct cr."id_car")> 0