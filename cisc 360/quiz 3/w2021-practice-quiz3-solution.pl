/*
  CISC 360, Winter 2021
  Jana Dunfield
  Practice questions for Prolog Quiz 3
*/

/* Q1

This question asks you to translate Prolog clauses into logical formulas.

green(L, R) and blue(L, R) represent branch nodes with two children L and R.  leaf represents a leaf node.

Translate each of the Prolog clauses 1-4 into the appropriate logical formula.

You can copy and paste these symbols: ∀ ∃ ∧ →
or type:    all    exists    and    ->

1. against(V, V).
  all V against(V, V)

2. nonempty(green(leaf, leaf)).

nonempty(green(leaf, leaf))

3. bright(H) :- flight(H, sky), empty(sky).

all H (flight(H, sky) /\ empty(sky) → bright(H))
% flight is a relation on H and sky
% not saying:  flight(H /\ sky)

4. leaning(blue(L, leaf)) :- leaning(L).
∀L leaning(L) -> leaning(blue(L, leaf))
*/
connected(X, X).

/* Q2

This question asks you to translate Prolog queries into logical formulas.

Translate each of the Prolog queries 5-7 into the appropriate logical formula.

You can copy and paste these symbols: ∀ ∃ ∧ →
or type:    all    exists    and    ->

5.  ?- flight(sky, sky).
flight(sky, sky)

6.  ?- against(V, V).
exists V against(V, V)

7.  ?- leaning(green(T1, T2)).

exists T1 ∃T2 leaning(green(T1, T2))

8. flight(sky, Sky)      % ouch
∃Sky flight(sky, Sky)
*/

/* Q3

This question asks you to translate logical formulas into the corresponding Prolog clauses (facts and/or rules).
*/

/*
1.   ∀R green(R, R)
green(R, R).

2.   ∀B1 ∀B2 (green(B1, B2) → green(B2, B1))
green(B2, B1) :- green(B1, B2).

3.   ∀X ∀Y (left(X, zero) ∧ left(zero, Y) → left(X, Y))

left(X, Y) :- left(X, zero), left(zero, Y).

*/


/* Q4

This question asks you to translate one Haskell function to a corresponding Prolog predicate.

Your predicate 'mysum' must be defined by one fact and one rule.
You may use the Prolog arithmetic features

  is
  >
  +
  -

You may not use other Prolog arithmetic operators or library predicates.

For example,

Consult 360-lec16.pdf and lec16.pl for information on arithmetic in Prolog.

-- mysum: Given a non-negative integer k, return the sum of k, k-1, k-2, ..., 0.
mysum :: Int -> Int
mysum 0 = 0
mysum n = n + mysum (n - 1)
*/

mysum(0, 0).
mysum(N, Z) :- N > 0,
               M is N - 1,
               mysum(M, Result),
               Z is N + Result.
% Why does Prolog wait after giving 0 for
% ?- mysum(0, Answer).   ?
% Is it possible that N = 0 and Z = Answer?
% N = 0, 

% This rule needs more premises.
% Hint: mysum(X, K) puts the result of the mysum "function" on X into K.
%  For example, after mysum(5, K), K should equal the result of Haskell's mysum 5.


/* Q5

This question asks you to translate two Haskell functions to the corresponding Prolog predicates (collections of clauses: facts and/or rules).

Consider the following Haskell data definition and two functions, swaproot and angle.

  data Tree = Leaf           
            | Green Tree Tree
            | Blue Tree Tree

Write Prolog clauses that define two predicates, swaproot and angle, that correspond to two Haskell functions:

   Prolog  swaproot(T, R)  should be true iff Haskell swaproot returns R when passed the argument T

   Prolog  angle(T, R)  should be true iff Haskell angle returns R when passed the argument T

For example:
   swaproot (Green Leaf Leaf) == Blue Leaf Leaf
so
   swaproot(green(leaf, leaf), blue(leaf, leaf))
should be true.

Hint: Remember that Haskell does pattern matching in order.

swaproot :: Tree -> Tree
swaproot (Green t1 t2) = Blue t1 t2
swaproot (Blue t1 t2)  = Green t1 t2

angle :: Tree -> Tree
angle (Green t1 t2) = t1
angle (Blue t1 t2)  = Green (angle t1) t2
angle t             = t
-- same as: angle Leaf             = Leaf
*/

swaproot( green( T1, T2), blue( T1, T2)).
swaproot( blue( T1, T2), green( T1, T2)).


angle( green(T1, T2), T1).
angle( blue(T1, T2), green(X, T2)) :- angle(T1, X).
angle( leaf, leaf).

% notes:
%
% angle( blue(T1, T2), green(angle(T1), T2)).    'angle' used as a data constructor
% angle( T, T).    % matches 1st argument green/blue, even though the last Haskell clause wouldn't


