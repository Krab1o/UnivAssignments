% task 2
s(X, Y) :- 
    X =\= -Y,
    Res is 2 * (X * X + Y * Y) / (X + Y), !,
    write("Res = "), write(Res);
    write("На ноль делить нельзя!").

% task 3
aver(X, Y) :-
    Res is (X + Y) / 2,
    write("Res = "), write(Res).

% task 6
min(A, B, C, A) :- A =< B, A =< C, !.
min(A, B, C, B) :- B =< C, !.
min(A, B, C, C).