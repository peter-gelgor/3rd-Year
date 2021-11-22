turn(node(T1, node(_, _), node(A, T1))) :-
    turn(T1, A).
turn(node(T1, T2), T2).
turn(leaf, leaf).




narrow(Xs, _) :-
 length(Xs, Z),
 Z < 2.
narrow( [XJ | [XK | XS]], N) :-
    Abs is abs(XJ - XK),
    Abs =< N,
    narrow( [XK | XS], N).