ученик("Коля", 7).
ученик("Миша", 9).
ученик("Толя", 7).
ученик("Ваня", 7).
ученик("Маша", 9).
ученик("Таня", 7).

увлекается("Коля", "Бадминтон").
увлекается("Миша", "Баскетбол").
увлекается("Коля", "Теннис").
увлекается("Таня", "Бадминтон").
увлекается("Маша", "Крикет").
увлекается("Таня", "Шахматы").
увлекается("Ваня", "Хоккей").
увлекается("Толя", "Бадминтон").

пункт_а :-
    увлекается(Имя, Спорт),
    write(Имя), write(", "),
    write(Спорт), write(", "),
    nl, fail.

пункт_б(Класс) :-
    ученик(Имя1, Класс1), увлекается(Имя1, Спорт1),
    ученик(Имя2, Класс2), увлекается(Имя2, Спорт2),
    fail.