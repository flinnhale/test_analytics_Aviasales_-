# test_analytics_Aviasales_-
[Выполнение тестового задания Aviasales](https://github.com/Hexlet/ru-test-assignments/tree/aa5f74a22680cd37459384a3dad3e3c7f4491fc4/analytics/Aviasales%20%D0%9F%D1%80%D0%BE%D0%B4%D1%83%D0%BA%D1%82%D0%BE%D0%B2%D1%8B%D0%B9%20%D0%B0%D0%BD%D0%B0%D0%BB%D0%B8%D1%82%D0%B8%D0%BA)

# Задание 1

<br>
Есть таблица с действиями юзеров A/B-теста (<i>task_1_events.csv</i>):

- $events$ - установки приложения
    - $user\_id$ - id юзера,
    - $ab\_group$ - группа A/B-теста,
    - $ts$ - время совершения действия,
    - $pdate$ - дата совершения действия.

Пользовательская сессия определяется по следующим правилам:
<br>
1. Новая сессия начинается после 30 минут бездействия.
<br>
2. Сессия прерывается при переходе между двумя датами.

<b>Постройте таблицу с сессиями юзеров в формате<b>:
<br>
- $user\_id$ - id юзера
- $ab\_group$ - группа A/B-теста,
- $start\_ts$ - время старта сессии,
- $end\_ts$ - время окончания сессии,
- $pdate$ - дата сессии.

# Задание 2

Был проведен A/B-тест.
<br>
В качестве данных используйте таблицу, построенную в предыдущем задании. Первая сессия юзера считается моментом попадания в A/B-тест.
<br><br>
Ключевая метрика эксперимента - конверсия во вторую сессию.
<br>
Сделайте вывод о том, какая группа выиграла в A/B-тесте. Ответ обоснуйте.
<br>

# Решение

queries.sql - файл с запросам для построения таблиц.
<br>
task1.csv - таблица, построенная в первом задании в формате csv.
<br>
task1_2.csv - таблица, построенная во втором задании.
<br>
/charts - папка с построенными диаграммами.
<br><br>
В ходе выполнения задания было сформировано две таблицы, рассчитана конверсия во вторую сессию для каждой группы в А/В-тесте.
<br>
<b>Вывод:</b>
<br>
[диаграмма конверсии](charts/conversion-rate-2025-01-12T18-39-50.265Z.jpg)
<br>
Исходя из полученных данных, мы видим, что конверсия у группы В незначительно выше (0,014), чем у группы А. Посчитав p-значение (0,1443), делаем вывод, что разница в конверсии могла наблюдаться случайно с вероятностью 14,4%. Следовательно, <i>разница между конверсия групп А и В незначительна</i>, поэтому группа В не может считаться победителем.
<br>
[таблица конверсии](charts/conversion-table-2025-01-12T18-43-39.201Z.jpg)