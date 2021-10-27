import GHC.RTS.Flags (CCFlags)
{-
  CISC 360, Fall 2021
  Jana Dunfield
  
  Questions possibly relevant to Quiz 2
-}

data Codeblock = End
               | Up Codeblock
               | Down Codeblock
               | Spin Codeblock Integer
               deriving Show
{-
Q1.
Write a Haskell expression of type Codeblock that corresponds to the following tree:

      Up
       |
     Spin
    /    \
 Down    360
  | 
 End
-}
expr1 :: Codeblock
expr1 = (Up (Spin (Down (End)) 360))



{-
Q2.
The type declaration

  me :: t -> t

says that me is a function that takes something of type t, and returns something of type t.

Briefly explain, in English, what the following type declaration says.

  mystery :: (b -> Codeblock, b -> Codeblock) -> b -> [Codeblock]

(Don't speculate about what such a function would actually do.)
-}
{-
  Mystery is a function that takes two functions (that takes something of type b, and returns something of type Codeblock), as well as something of type b, and returns an array of Codeblocks
-}

{-
Q3.
Write a function g such that

  rotate g (Spin End 2)          returns   Spin (Up End) 2
and
  rotate g (Up (Down End))     returns   Down End

  Begin by writing the appropriate type declaration for g.

  Hint: Use pattern matching to define g.
-}
rotate :: (Codeblock -> Codeblock) -> Codeblock -> Codeblock
rotate z (Up block)     = Down (rotate z block)
rotate z (Spin block n) = Spin (rotate z block) n
rotate z block          = z block

g :: Codeblock -> Codeblock
{-
-> rotate g (Spin End 2)
-> Spin (rotate g End 2)
-> Spin (g End 2)
turn g End 2 into Up End 2
-> Spin (Up End) 2
-}
g End = Up End

{-
-> rotate g (Up (Down End))
-> Down (rotate g (Down End))
-> Down (g (Down End))
-> Down End
-}

g (Down End) = End

{-
Q4.
  Here are two strange functions, splat and blat.

  'splat' takes a Painting, changes two adjacent Rs to one G, and removes Bs.
  For example:

   splat (B (R (R (G Canvas))))  returns  G (G Canvas):
          ^  ^^^^  ^- preserved           ^  ^
          |   ||                          |  from G
          |  changed to G                 |
         removed                      from R R

  The function  blat  is supposed to behave like 'splat' when its first argument
  is (\x -> x).

  For example,
   
   blat (\x -> x) (B (R (R (G Canvas))))  returns G (G Canvas).

  More precisely, for all paintings p, we want:

   blat (\x -> x) p  ==  splat p

  However, there are two bugs in the definition of 'blat'.
  Find the bugs, and:

  1. Explain what they are and why they are bugs;
 
  2. Fix the bugs and give a correct definition of 'blat'.
-}
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

blat :: (Painting -> b) -> Painting -> b
blat k (R (R p)) = blat (\q -> k (G q)) p
blat k (G p)     = blat (\q -> k q) p
blat k (B p)     = k p
blat k p         = k p
{-

-}

{-
Q5.
Haskell has a built-in type Maybe a:

  data Maybe a = Nothing
               | Just a
               deriving (Show, Eq)

Write a function fill of type
-}
fill :: t -> (t -> t) -> [Maybe t] -> [t]
{-
such that

  fill r f ms

returns a list where:

  - each Nothing element in ms is replaced by r, and

  - each Just x element in ms is replaced by f x.

For example:

  fill 9 (\x -> x + 2) [Nothing, Just 2, Just 0, Nothing]

should return          [9,       4,      2,      9].

The first argument, 9, tells fill to replace Nothing with 9.
The second argument, (\x -> x + 2), tells fill to add 2 to the Just elements.
-}
fill r f [] = []
fill r f (Nothing : ms) = r : fill r f ms
fill r f ((Just a) : ms) = (f a) : fill r f ms




