% CISC 360, Fall 2021
% Jana Dunfield
%
% Questions possibly relevant to Quiz 3

/*
Q1. Write a Prolog expression that corresponds to the following tree:

     up
      |
    spin
   /    \
  down  360
   |
  end


  up(spin(down(end), 360))
  
*/


/*
Q2. Translate the following Prolog clauses to logical formulas.

You can copy the symbols  ∀    ∃       →   ∧
or type:                  all  exists  ->  /\
*/
annoying(paperwork).

good(U).

symmetric( node(K, L, M), node(K, X, Y)) :- symmetric(L, X), symmetric(M, Y).
/*
answer:

annoying(paperwork).

∀U good(U).

all K,L,M,X,Y symmetric(L, X) /\ symmetric(M, Y) -> symmetric( node(K, L, M), node(K, X, Y))

*/

/*
Q3. Translate the following Prolog queries to logical formulas.

You can copy the symbols  ∀    ∃       →   ∧
or type:                  all  exists  ->  /\


?- good(U).

?- symmetric( node(K1, empty, empty), node(K2, empty, empty)).

answer:

∃U good(U)

∃K1 ∃K2 symmetric( node(K1, empty, empty), node(K2, empty, empty))

*/

/*
Q4.

Write a predicate 'exchange' where

  exchange( Xs, Ys) is true

iff  Xs is a list of pairs, and Ys has the same pairs as Xs with the components swapped.

For example,

  ?- exchange( [(3, 4), (5, "a")], [(4, 3), ("a", 5)]).

should be true.

Given a query of the form

  ?- exchange( ..., Answer).

where "..." is a list without Prolog variables, Prolog should find Answer.

For example,

  ?- exchange( [(3, 4), (5, "a")], Answer).

should produce
  Answer = [(4, 3), ("a", 5)]

and no other solutions.
*/
exchange( [], []).
exchange( [(X1, X2) | Xs], [(X2, X1) | Ys]) :- exchange(Xs, Ys).



/*
Q5.

- Translate Haskell code to Prolog code.

Consider the following Haskell code:
data Painting = Canvas
              | R Painting
              | G Painting
              | B Painting
              deriving (Show, Eq)

splat :: Painting -> Painting
splat (R (R p)) = G (splat p)
splat (G p)     = G (splat p)
splat (B p)     = splat p
splat p         = p

Translate the Haskell function 'splat' to a Prolog predicate 'splat',
such that, for all paintings P,

  splat( P, R) is true (in Prolog)
  iff
  splat P  ==  R  in Haskell.

For example, Haskell

  splat (B Canvas) == Canvas

so

  ?- splat( b(canvas), canvas).

should be true.

Also, if the second argument is a Prolog variable, there should be exactly one
solution: the result of the Haskell function.  For example:

  ?- splat( g(b(canvas)), Answer).
  Answer = g(canvas)

because  splat (G (B Canvas)) == G Canvas  in Haskell.
*/
splat( r( r( P)), g( R)) :- splat(P, R).
splat( g( P), g( R)) :- splat(P, R).
splat( b( P), R) :- splat(P, R).
splat( canvas, canvas).
% splat( r( X), r( X)) :- X = g(_).
% splat( r( X), r( X)) :- X = b(_).
% splat( r( X), r( X)) :- X = canvas.


/*
Q6.

The Prolog predicate 'halflife', below, is supposed to compute the sequence

  [X, X / 2, X / 4, ...]

where X is its first argument, and the length of the sequence is the second argument.

For example:

  ?- halflife( 1000, 5, Seq).
  Seq = [1000, 500, 250, 125, 62.5]

If the second argument is less than or equal to 0, halflife should return []:

  ?- halflife( 1000, 0, Seq).
  Seq = []

When ; is typed during a query, halflife should never return more than one solution.

The code below contains at least two bugs.

First part of your answer:  Find the bugs in 'average' and explain what they are, and why they are bugs.

Second part of your answer:  Give complete, correct code for 'halflife'.
*/
/* Original code:
halflife( X, 0, []).
halflife( X, N, Ys) :- HalfX is X / 2,
                       halflife( HalfX, N - 1, [X | Ys]).
*/
/*
  Bug #1:
    halflife(..., 0, ...) gives multiple solutions (using the second clause) when ; is typed.
    Solution: add N > 0 premise to second clause.

  Bug #2:
    Should return [] when the second argument is less than 0, instead of recursing forever.
    Solution: add N =< 0 premise to first clause.
    
  Bug #3:
    Writing [X | Ys] as the third argument in the last premise of the second clause
      forces the output to be non-empty.
    Solution: Change [X | Ys] to Ys in the recursive call,
      and change Ys in the conclusion to [X | Ys].

  [Bug #4:
    Writing N - 1 instead of computing a variable Nminus1 would usually be a bug,
    but we use N =< 0 and N > 0, which do the computation.

    So we don't *have* to add "Nminus1 is N - 1", but it's usually safer to do so.

    If we were pattern-matching on N, as in the original code above, it would be a bug
    (for example, 1 - 1 would not match 0).
    ]
    

Fixed code:
*/
halflife( X, N, []) :- N =< 0.
halflife( X, N, [X | Ys]) :- N > 0,
                             HalfX is X / 2,
                             Nminus1 is N - 1,
                             halflife( HalfX, Nminus1, Ys).



/*
NOTE: If SWI-Prolog prints "|...]" instead of the entire list, type

  ?- debug.

to turn on debug mode.  (There is another way to see the entire result but it's more complicated.)
*/
