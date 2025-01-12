-- Задание 1.

-- Создаем табличное выражение, где определяем начало новых сессий
WITH session_data AS (
    SELECT 
        user_id,
        ab_group,
        ts,
        pdate,
        -- Если прошло более 30 минут или дата изменилась, фиксируем начало новой сессии
        CASE 
            WHEN EXTRACT(EPOCH FROM (ts - LAG(ts) OVER (PARTITION BY user_id ORDER BY ts))) / 60 > 30
                 OR pdate != LAG(pdate) OVER (PARTITION BY user_id ORDER BY ts) 
            THEN 1
            ELSE 0
        END AS new_session
    FROM task
),

-- Присваиваем уникальный идентификатор каждой сессии
session_groups AS (
    SELECT 
        user_id,
        ab_group,
        ts,
        pdate,
        SUM(new_session) OVER (PARTITION BY user_id ORDER BY ts) AS session_id
    FROM session_data
)

--  Выводим итоговую таблицу
SELECT 
    user_id,
    ab_group,
    MIN(ts) AS start_ts,
    MAX(ts) AS end_ts,
    pdate
FROM session_groups
GROUP BY user_id, ab_group, session_id, pdate
-- продолжительность сессии не более 30 минут
HAVING EXTRACT(EPOCH FROM (MAX(ts) - MIN(ts))) / 60 <= 30
ORDER BY user_id, start_ts;

-- Задание 2. 

-- Определяем первую и вторую сессии каждого пользователя
WITH first_two_sessions AS (
    SELECT 
        user_id,
        ab_group,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY start_ts) AS rn
    FROM (
        SELECT 
            user_id,
            ab_group,
            MIN(ts) AS start_ts,
            MAX(ts) AS end_ts,
            pdate
        FROM session_groups
        GROUP BY user_id, ab_group, session_id, pdate
    ) subquery
),

-- Считаем количество пользователей в первой и второй сессиях для каждой группы
conversion_data AS (
    SELECT 
        ab_group,
        COUNT(DISTINCT CASE WHEN rn = 1 THEN user_id END) AS users_in_first_session,
        COUNT(DISTINCT CASE WHEN rn = 2 THEN user_id END) AS users_in_second_session
    FROM first_two_sessions
    WHERE rn <= 2 -- Рассматриваем только первую и вторую сессии
    GROUP BY ab_group
)

-- Рассчитываем конверсию
SELECT 
    ab_group,
    users_in_first_session,
    users_in_second_session,
    ROUND(1.0 * users_in_second_session / users_in_first_session, 4) AS conversion_rate
FROM conversion_data;