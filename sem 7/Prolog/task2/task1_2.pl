увлекается("Миша", гитара).
увлекается("Маша", арфа).
увлекается("Рома", футбол).
увлекается("Таня", лыжи).

спорт(футбол).
спорт(лыжи).

музыкальный_инструмент(арфа).
музыкальный_инструмент(гитара).

музыкант :-
    увлекается(Имя, Атрибут),
    музыкальный_инструмент(Атрибут),
    write(Имя), write(", "),
    write(Атрибут),
    nl, fail.