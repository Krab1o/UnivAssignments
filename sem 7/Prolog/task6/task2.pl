% task 2
count([X], 1) :- !.
count([Hd | Tl], N) :-
    count(Tl, N_new),
    N is N_new + 1.

% task 10
intersection(_, [], []).
intersection([], _, []).
intersection([H1|T1], L2, [H1|L]) :-
    member(H1, L2),
    intersection(T1, L2, L), !.
intersection([_|T1], L2, L) :-
    intersection(T1, L2, L).

