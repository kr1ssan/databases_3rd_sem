SELECT

FROM Disciplines D LEFT JOIN performance p
    ON D.id_discipline = P.id_performance
    FULL JOIN Teachers T 
    ON P.id_teacher = T.id_teacher


    Выбрать данные о сотрудниках, которые получают зп больше чем их руководители.

    SELECT
    FROM Преподаватели П JOIN Преподаватели рук 
        ON П.id_