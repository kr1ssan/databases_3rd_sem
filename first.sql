-- 1 запрос
-- Выбрать все данные о типах задач. Результат отсортировать
-- по названию типа в лексикографическом порядке.
SELECT tt.*
FROM types_of_tasks tt
ORDER BY tt.title;

-- 2 запрос
-- Выбрать года рождения сотрудников без повторений.
SELECT DISTINCT e.date_of_birth
FROM employees e;

-- 3 запрос
-- Выбрать года и месяца вступления сотрудников в должность
-- без повторений. Учитывать только текущие должности. Результат
-- отсортировать в порядке убывания года и в порядке возрастания
-- месяца.
SELECT DISTINCT EXTRACT(year FROM ep.date_of_entry) AS year
                ,EXTRACT(month FROM ep.date_of_entry) AS month
FROM employee_positions ep
ORDER BY 1 DESC, 2;

-- 4 запрос
-- Выбрать id, фамилию и инициалы сотрудников в одном столбце.
-- Результат отсортировать по id в порядке возрастания.
SELECT e.id || ' ' ||
       e.surname || ' ' ||
       SUBSTRING(e.name, 1,1) || '.' ||
       SUBSTRING(e.patronymic, 1, 1) || '.'
       AS task4
FROM employees e
ORDER BY e.id;

-- 5 запрос
-- Выбрать название, краткое название и описание проектов,
-- в описании которых в описании которых есть цифры или слова,
-- написанные через дефис.
SELECT p.title, p.abbreviation, p.description
FROM projects p
WHERE p.description SIMILAR TO '%(\d|[a-zA-Z]-[a-zA-Z])%'
--     p.description LIKE '%-%'
--     OR p.description LIKE '%\d%'
;

-- 6 запрос
-- Выбрать все данные о проектах, начавшихся более двух лет назад.
SELECT p.start_date
FROM projects p
WHERE p.start_date < (NOW() - INTERVAL'2 YEAR');

-- 7 запрос
-- Выбрать все данные о задачах, выполнение которых было
-- завершено позже запланированного срока на 3-10 дней. Результат
-- отсортировать по id проекта в порядке возрастания, по дате старта в
-- порядке убывания, по названию в порядке обратном
-- лексикографическому.
SELECT *
FROM tasks t
WHERE t.date_of_completion_to_fact - t.date_of_completion_to_plan BETWEEN 3 AND 10
ORDER BY t.id, t.start_date DESC, t.title DESC;

-- 8 запрос
-- Выбрать фамилию и инициалы сотрудников, для которых указана
-- дата рождения и id равен 2, 3, 5, 7, 8 или 11. Результат
-- отсортировать следующим образом в первую очередь сотрудники с
-- старше 35 лет, а затем остальные сотрудники.
SELECT  e.surname || ' ' ||
        SUBSTRING(e.name, 1,1) || '.' ||
        SUBSTRING(e.patronymic, 1, 1) || '.'
        AS task8
FROM employees e
WHERE e.date_of_birth IS NOT NULL AND e.id IN (2,3,5,7,8)
ORDER BY e.date_of_birth;

-- 9 запрос
-- Выбрать названия проектов, начатых в прошлом и текущем годах. В
-- описании которых есть цифры.
SELECT p.title
FROM projects p
WHERE p.start_date >= DATE_TRUNC('YEAR', NOW()-INTERVAL'1 YEAR')
        AND p.description SIMILAR TO '%\d%';

-- 10 запрос
-- Выбрать названия и даты начала разработки проектов, в описании
-- которых есть хотя бы три слова и нет символов !, ?, %, _.
SELECT p.title, p.start_date
FROM projects p
WHERE p.description SIMILAR TO '%[a-zA-Z]% %[a-zA-Z]% %[a-zA-Z]%'
        AND p.description NOT SIMILAR TO '%[!,?,#%,#_]%'
        ESCAPE '#';

-- 11 запрос
-- Выбрать все данные о задачах . В последнем столбце
-- результирующей таблицы указать сообщение 'Задача выполнена
-- досрочно', если фактическая дата завершения раньше планируемой
-- даты завершения, 'Задача не завершена', если не указана дата фактического завершения и 'Задача завершена с опозданием', если
-- фактическая дата завершения больше планируемой даты
-- завершения.
SELECT t.*,
       CASE
           WHEN t.date_of_completion_to_fact IS NULL THEN 'Задача не завершена'
           WHEN t.date_of_completion_to_fact > t.date_of_completion_to_plan THEN 'Задача завершена с опозданием'
           ELSE 'Задача выполнена досрочно'
       END
       AS status
FROM tasks t;
