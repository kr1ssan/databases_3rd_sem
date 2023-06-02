--30
SELECT *
FROM пациеты п join приемы пр
               ON п.id = пр.id
WHERE EXTRACT(year from date) <> EXTRACT(year from CURRENT_DATE)

--31
SELECT вр.*, COUNT(CASE WHEN )