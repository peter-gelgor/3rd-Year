{-
  CISC 360, Fall 2021
  Jana Dunfield
  
  Questions possibly relevant to Quiz 2

  Sample solution

  [Material in square brackets, like this, would not need to be part of your answer.
   It's explanations of my answers.]
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
expr1 = Up (Spin (Down End) 360)

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
  'mystery' is a function that takes two arguments.

  The first argument to 'mystery' is a pair of functions; each function takes an
  argument of type 'b', and returns a Codeblock.

  The second argument to 'mystery' is a 'b'.

  The result of 'mystery' is a list of Codeblocks.

  [Other phrasings are possible.]
-}


{-
Q3.
Write a function g such that

  rotate g (Spin End 2)        returns   Spin (Up End) 2
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
g End        = Up End
g (Down End) = End
{-
   [How I derived this solution:
 
    Leave g unspecified.

       rotate g (Spin End 2)
    => Spin (rotate g End) 2
    => Spin (g End) 2
    
    I don't know what g is, so I can't actually step  g End.
    But I know what I want to get:

    => Spin (Up End) 2
  
    So I need  g End  to step to  Up End.
    That tells me the first clause of g:
g End        = Up End

    Now, consider the other case we need to handle.

       rotate g (Up (Down End)) 
    => Down (rotate g (Down End))
    => Down (g (Down End))
   
    What I want to get:
    => Down End

    So, given the argument Down End, g needs to return End:    
g (Down End) = End

    Coding against test cases is usually unwise, but this particular
    question asked you to write a function that satisfies just two tests.
    When the tests are the entire specification, coding against
    test cases is perfectly legitimate.

    Another solution:

g (Down block) = block
g block        = Up block
-}

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
splat (R (R p)) = G (splat p)       -- first clause
splat (G p)     = G (splat p)       -- second clause
splat (B p)     = splat p           -- third clause
splat p         = p                 -- fourth clause

blat :: (Painting -> b) -> Painting -> b
{-
-- Original version:
blat k (R (R p)) = blat (\q -> k (G q)) p
blat k (G p)     = blat (\q -> k q) p
blat k (B p)     = k p
blat k p         = k p
-}

{- Solution:

Bug 1: When the argument to  splat  matches (G p), for example,
       G Canvas, splat preserves the G.
       Therefore, blat should also preserve the G.
       Fix: change  k q  to  k (G q).

       [Another approach is to observe that the right-hand sides of
       splat's first clause and splat's second clause are identical.
       So the right-hand sides of blat's first and second clauses
       should be the same, too.]

Bug 2: When the argument to  splat  matches (B p), for example,
       B Canvas, splat makes a recursive call.
       Therefore, blat should make a recursive call.

       [Seeing how to make the recursive call may require some thought.
        Here is one approach, though it requires believing that
        the first clause of  blat  is correct:

        The equivalent of  G (splat p)  in splat is

                           blat (\q -> k (G q)) p

        For the third clause of blat, we want to write the equivalent of
    
           splat p
      
        So we can see (or guess) that removing the G will work: change

          blat (\q -> k (G q)) p

        to
         
          blat (\q -> k ( q)) p

        which is the same as

          blat (\q -> k q) p

        That is the same as the incorrect right-hand side of the second clause;
        it was incorrect for the  G p  clause, but is correct for the  B p  clause.

        We could also write the right-hand side of the third clause as
 
          blat k p

        (Remember how  mymap (\x -> not x)  gave the same result as
                       mymap not            ?
         Same idea.  k  and  (\q -> k q)  do the same thing.)
       ]
-}

{- Corrected code -}
blat k (R (R p)) = blat (\q -> k (G q)) p
blat k (G p)     = blat (\q -> k (G q)) p
blat k (B p)     = blat (\q -> k q) p
blat k p         = k p



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

fill r f []              = []
fill r f ((Just x) : xs) = (f x) : (fill r f xs)
fill r f (Nothing  : xs) = r : (fill r f xs)

{-
 How I got this solution:

 'fill' takes a list, so I break down the problem into two parts:
  what to do on [], and what to do on (x : xs).

fill r f [] = undefined
fill r f (x : xs) = undefined

  Each element of the list has type  Maybe t,  and the specification
  of 'fill' says it should do one thing with Nothing and a different thing
  with Just ..., so I break down the second clause:

fill r f []              = undefined
fill r f ((Just x) : xs) = undefined
fill r f (Nothing  : xs) = undefined

  For the first clause, if the list is empty I'll return the empty list.
  (This isn't directly stated in the specification, but it makes sense since
  we seem to want to return a list of the same length as the 3rd argument.)

fill r f []              = []
fill r f ((Just x) : xs) = undefined
fill r f (Nothing  : xs) = undefined

  For the second clause, the spec said:

  "each Just x element in ms is replaced by f x."

  I am given  (Just x) : xs,
  so I'll return
              (f x)    : (fill r f xs)

fill r f []              = []
fill r f ((Just x) : xs) = (f x) : (fill r f xs)
fill r f (Nothing  : xs) = undefined

  For the third clause, the spec said
 
  "each Nothing element in ms is replaced by r"

  Similarly to the Just clause, I'll return
             r : (fill r f xs)

fill r f []              = []
fill r f ((Just x) : xs) = (f x) : (fill r f xs)
fill r f (Nothing  : xs) = r : (fill r f xs)
-}


