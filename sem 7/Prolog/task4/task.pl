% task 1
power(0, X, 1) :- !.
power(N, X, S) :- 
    N_decr is N - 1,
    power(N_decr, X, S_new),
    S is X * S_new.

% task 2
fib(1, 1) :- !.
fib(2, 2) :- !.
fib(N, F) :-
    N_p1 is N - 1,
    N_p2 is N - 2,
    fib(N_p1, F_1),
    fib(N_p2, F_2),
    F is F_1 + F_2.

% task 3
hanoi(1, I, K) :- 
    format('Move disk 1 from pin ~w to pin ~w ~n', [I, K]), !.
hanoi(N, I, K) :-
    TMP is 6 - I - K,
    N_decr is N - 1,
    hanoi(N_decr, I, TMP),
    format('Move disk ~w from pin ~w to pin ~w ~n', [N, I, K]),
    hanoi(N_decr, TMP, K).