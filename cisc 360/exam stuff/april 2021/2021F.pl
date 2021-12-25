twirl(empty, empty, empty).
twirl(black(Left, S1, Right), red(Left, S2, Right), black(Left, S1, Right)) :- S1 == S2.
twirl(black(Left, S, Right), red(Left, _, Right), black(Left, S, Right)).
twirl(red(Left, S, Right), _, black(Left, S, Right)).

derive (Ctx, Q, use(Q)) :-
    member(Q, Ctx),
    !.

derive (Ctx, Q, and_left(P1, P2, Proof)) :-
    append (Ctx1, [and(P1, P2) | Ctx2], Ctx),
    !,
    append ( Ctx1, [P1 | [P2 | Ctx2]], CtxP12),
    derive (CtxP12, Q, Proof).


alternate([], []).
alternate([X], [X]).
alternate([X, _ | Xs], [X | Ys]) :-
    alternate(Xs, Ys).

% write a prolog predicate called max2 so that max2(List, Value1, Value2) means that Value1 and Value2 are the two greatest numbers in List, and Value1 >= Value2.
max2([X, Y], X, Y) :- X >= Y.
max2([X, Y | Xs], Max, Y) :-
    max2([X | Xs], Max, Y).


funny(a).
funny(f).
funny(g).
silly(a, c).
silly(b, e).
silly(d, g).
silly(b, d).
silly(c, f).
silly(d, f).
humorous(X) :- funny(X).
humorous(X) :- silly(X, Y), funny(Y).
crazy(X) :- funny(Y), silly(X, Y).
weird(X) :- funny(X).
weird(X) :- silly(X, Y), weird(Y).

tall(john).
tall(sarah).
tall(paul).
blond(sarah).
blond(paul).
thin(karen).
thin(sarah).
thin(john).

interesting(X) :- tall(X), blond(X).
interesting(X) :- thin(x).