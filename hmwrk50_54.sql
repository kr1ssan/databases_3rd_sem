--24
SELECT CONCAT(ФИО)
FROM deffect d join def_reg dr 
               ON d.id_reg = dr.id_reg
               join users u 
               ON u.id_user = dr.id_registrator
GROUP BY CONCAT(ФИО), d.id_def
HAVING COUNT(dr.id_reg) >= 3

--25
SELECT def.name
FROM deffect def CROSS JOIN priority p

--26
SELECT pr.name, def.id_def, def.name, dr.date 
FROM deffect def JOIN deffect_number dn
                 ON  def.id_def = dn.id_def
                 JOIN deffect_rework dr
                 ON dn.id_rework = dr.id_rework
                 RIGHT JOIN project pr
                 ON dn.id_project = pr.id_project

--27


--28
SELECT pr.name, CONCAT(u.ФИО), COUNT(dn.*)
FROM users u JOIN project pr 
             ON u.id_employee = pr.id_supervisor
             JOIN deffect_number dn 
             ON pr.id_project = dn.id_project
             JOIN deffect_rework dr 
             ON dn.id_rework = dr.id_rework
GROUP BY pr.name, CONCAT(u.ФИО), COUNT(dn.*)
HAVING dr.rework_date IS NULL

--29
SELECT
CASE
    WHEN EXTRACT(MONTH FROM dr.rework_date) >= 1 AND EXTRACT(MONTH FROM dr.rework_date) <= 3 THEN COUNT(dr.id_rework) AS first_quater
    ELSE
    WHEN EXTRACT(MONTH FROM dr.rework_date) >= 4 AND EXTRACT(MONTH FROM dr.rework_date) <= 6 THEN COUNT(dr.id_rework) AS second_quater
    ELSE
    WHEN EXTRACT(MONTH FROM dr.rework_date) >= 7 AND EXTRACT(MONTH FROM dr.rework_date) <= 9 THEN COUNT(dr.id_rework) AS third_quater
    ELSE
    WHEN EXTRACT(MONTH FROM dr.rework_date) >= 10 AND EXTRACT(MONTH FROM dr.rework_date) <= 12 THEN COUNT(dr.id_rework) AS fourth_quater
END
FROM deffect_rework dr

--31
SELECT pr.name
FROM project pr
WHERE pr.id_supervisor IS NULL

--33
SELECT st.name
FROM statuses st JOIN deffect def
                 ON st.id_status = def.id_status
                 JOIN deffect_number dn
                 ON def.id_def = dn.id_def
WHERE st.name = dn.result

--24
SELECT tu.name, AVG(age(r.date_of_birth) - age(r.date_of_death))
FROM territorial_unit tu JOIN type_of_tu tot 
                         ON tu.id_type = tot.id_type
                         JOIN rulers r
                         ON tu.id_ruler = r.id_ruler
                         JOIN ruler_in_office rio 
                         ON r.id_ruler = rio.id_ruler
WHERE rio.date_in BETWEEN 1701 AND 1800 AND tot.name_of_type LIKE 'Город'
GROUP BY tu.name, AVG(age(r.date_of_birth) - age(r.date_of_death))

--25
SELECT c.name 
FROM climate c JOIN territorial_unit tu 
               ON c.id_climate_zone = tu.id_climate_zone
GROUP BY c.name
HAVING COUNT(tu.*) = 1

--26
SELECT tu.name
FROM territorial_unit tu JOIN type_of_tu tot 
                         ON tu.id_type = tot.id_main
                         JOIN rulers r
                         ON tu.id_ruler = r.id_ruler
GROUP BY tu.name
HAVING COUNT(tu.id_ruling) > 5

--31
SELECT c.name, COUNT(tu.*)
FROM  climate c LEFT JOIN territorial_unit tu
                ON c.id_climate_zone = tu.id_climate_zone
WHERE tu.id_type = 'Город'
GROUP BY c.name

--32


--34
SELECT tu.name, c.name
FROM territorial_unit tu CROSS JOIN climate c
WHERE tu.id_type = 'Страна'

--55
SELECT r.name, r.surname, r.middlename
FROM rulers r join ruler_in_office rio 
              on r.id_ruler = rio.id_ruler
              JOIN territorial_unit tu 
              ON rio.id_ruler = tu.id_ruler
WHERE rio.date_in = (SELECT rio.date_out
                     FROM  rulers r join ruler_in_office rio 
                                    on r.id_ruler = rio.id_ruler
                                    JOIN territorial_unit tu 
                                    ON rio.id_ruler = tu.id_ruler
                     WHERE r.surname = 'Иваонов' AND r.name = 'Иван' AND r.middlename = 'Иванович' AND tu.name = 'N' AND tu.id_type = 'Город')