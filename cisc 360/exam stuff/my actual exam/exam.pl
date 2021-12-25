% agglom(melody(K), melody(K1)) :- K1 is K + 1.
% agglom(harmony(melody(K), melody(K1)), harmony(melody(K1), melody(K1))) :- K1 is K + 1.
% agglom(harmony(melody(K), S1), harmony(melody(K1), S1)) :- K1 is K + 1.
% agglom(harmony(S1, S2), harmony(melody(K1), S1)) :- K1 is 4.

agglom(melody(K), melody(K1)) :- K1 is K + 1.
agglom(harmony(S1, melody(K)), harmony(melody(2), S2)) :- 
    agglom(S1, S2), !.
agglom(harmony(S1, S2), harmony(S1, S2)) :- S1 = S2.
agglom(harmony(S1, S2), melody(4)) :- S1 \= S2.

% Define a prolog predicate 'balanced' balanced (Xs) that is true iff for every integer (N) in Xs,
% the negation (-N) is also an element of Xs.
% For example, balanced([-3, 1, -52, 52, 3, -1]) is true, but balanced([-3, 1, -52, 52, 3, -1, -3]) is false.

balanced([]).
balanced([X|Xs]) :-
    X1 is -X,
    append(L, [X1 | R], Xs), append(L, R, LR),
    write(LR),
    balanced(LR),
    !.

commute(v(V), v(V)).

commute(implies(P, Q), implies(PC, QC)) :-
    commute(PC, P),
    commute(Q, QC).

commute(and(P1, P2), and(P1C, P2C)) :-
    commute(P1, P1C),
    commute(P2, P2C),

commute(and(P1, P2), and(P2C, P1C)) :-
    commute(P1, P1C),
    commute(P2, P2C).