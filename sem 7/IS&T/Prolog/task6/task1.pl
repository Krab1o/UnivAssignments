% task 3
sum([], 0) :- !.
sum([X|L], S) :-
    sum(L, S_new),
    S is S_new + X.

% task 8
genl(0, []) :- !.
genl(N, [Hd | Tl]) :-
    N_decr is N - 1,
    Hd is (5 - N_decr) * 3,
    genl(N_decr, Tl).

task_8(S) :-
    genl(5, Lst),
    sum(Lst, S).