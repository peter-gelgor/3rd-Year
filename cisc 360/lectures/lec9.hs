-- CISC 360 Fall 2021
-- Jana Dunfield
--
-- Code for week 4, part 1 (lecture 9)

module Lec9 where

{-
  Type of binary trees:

  A Tree is either

      Empty          -- a leaf, containing no information
  or
      Branch l k r   -- a branch, with left child l, integer key k, and right child r
-}
data Tree = Empty
          | Branch Tree Integer Tree
          deriving Show
{-
  `Empty' and `Branch' are constructors. The type of Empty is
 
    Empty :: Tree        -- mistake corrected 2021-02-04

  The type of Branch is

    Branch :: Tree -> Integer -> Tree -> Tree
              ^^^^    ^^^^^^^    ^^^^    ^^^^
             first    second     third     result
             argument argument   argument

  Branch takes arguments because it has more information
  than just "I am a Branch":
  it has a left child (another Tree), a key k (an Integer), and a right child (also a Tree).
-}

tiny_tree :: Tree
tiny_tree = Empty                   {- Drawn as a tree:    Empty -}

smol_tree :: Tree
smol_tree = Branch Empty 9 Empty    {- Drawn as a tree:    Branch
                                                          /  |  \
                                                      Empty  9   Empty   -}

med_tree :: Tree
med_tree = Branch Empty 3 smol_tree {- Drawn as a tree:    Branch
                                                          /  |  \
                                                      Empty  3   Branch
                                                                /  |  \
                                                            Empty  9  Empty   -}

lrg_tree :: Tree
lrg_tree = Branch smol_tree 5 med_tree
 {- Drawn as a tree:

              Branch
             /  |   \
            /   5    \
           /          \
       Branch          Branch
      /  |  \          /  |  \
  Empty  9  Empty  Empty  3   Branch
                             /  |  \
                         Empty  9  Empty   -}

{- NOTE: There are two copies of smol_tree inside this tree.
         Changing one would not affect the other, but you can't change a Tree in Haskell.
         You can only build a new Tree, which (if you want) could include new copies of
         some existing Trees. -}

-- reverse1: Reverse the left and right children of a Tree.
--           More precisely, return a new Tree with the left and right children swapped.
reverse1 :: Tree -> Tree

reverse1 Empty = Empty                                   -- first clause
reverse1 (Branch left k right) = Branch right k left     -- second clause

{- Example:

    reverse1 (Branch Empty 3 (Branch Empty 9 Empty))
 => Branch (Branch Empty 9 Empty) 3 Empty

 In detail:

  Line up first clause:

    reverse1 Empty                                   = Empty
    reverse1 (Branch Empty 3 (Branch Empty 9 Empty))
    
  There is no way for (Branch ... ... ...) to be equal to Empty. So the argument does not match the pattern Empty.

  Line up second clause:

    reverse1 (Branch left  k right                 )  = Branch right k left
    reverse1 (Branch Empty 3 (Branch Empty 9 Empty))
  
  Gives substitution

    Empty/left, 3/k, (Branch Empty 9 Empty)/right

    reverse1 (Branch Empty 3 (Branch Empty 9 Empty))
 => Branch right k left [Empty/left, 3/k, (Branch Empty 9 Empty)/right]
  = Branch (Branch Empty 9 Empty) 3 Empty


            Drawn as a tree:     Branch
                                /   |  \
                           Branch   3   Empty 
                          /  |  \
                      Empty  9  Empty               -}

-- reverse1 Branch left k right = Branch right k left

-- meaningless function, showing "nested pattern matching"
functionname :: Tree -> Tree -> Integer
functionname Empty Empty = 0
functionname (Branch Empty _ Empty) (Branch _ _ _) = 2
--           ^^^^^^^ ^^^^^   ^^^^^   ^^^^^^----2nd argument must be a Branch
-- first argument must    \ /       
--  be a Branch           left and right children of first argument
--                         must be Empty

-- If you omit the parentheses around (Branch ...),
--   Haskell thinks you're trying to pass four arguments:
-- functionname foo    bar  baz  quux  =  
--              1st,   2nd, 3rd, 4th argument
-- functionname Branch left k    right =

-- more_reverse
-- different from reverse1: reverses recursively:
--    flips the left and right children of the root, and then flips *their* children,
--    and so ons
more_reverse :: Tree -> Tree
more_reverse Empty = Empty
more_reverse (Branch left k right) = Branch (more_reverse right) k (more_reverse left)

-- to see the full effect of more_reverse, we need an annoyingly large tree:

annoying :: Tree
annoying = Branch (Branch Empty 1 Empty) 5 (Branch Empty 3 (Branch Empty 9 Empty))
 {- Drawn as a tree:

              Branch
             /  |   \
            /   5    \
           /          \
       Branch          Branch
      /  |  \          /  |  \
  Empty  1  Empty  Empty  3   Branch
                             /  |  \
                         Empty  9  Empty   -}
{-
  Result of

   more_reverse annoying

                  Branch
                 /  |   \
                /   5    \
               /          \
           Branch          Branch
          /  |  \          /  |  \
     Branch  3  Empty   Empty 1  Empty
    /  |  \
Empty  9  Empty
-}

{- The full stepping here is too long, but I'll show one of the pieces we'd need to do.
   This is the stepping for the right-hand child of `annoying', (Branch Empty 3 (Branch Empty 9 Empty)):

   more_reverse (Branch Empty 3 (Branch Empty 9 Empty))
=> Branch (more_reverse (Branch Empty 9 Empty))                3 (more_reverse Empty)
=> Branch (Branch (more_reverse Empty) 9 (more_reverse Empty)) 3 (more_reverse Empty)
=> Branch (Branch Empty 9 (more_reverse Empty))                3 (more_reverse Empty)
=> Branch (Branch Empty 9 Empty)                               3 (more_reverse Empty)
=> Branch (Branch Empty 9 Empty)                               3 Empty

This is used as the result's left-hand child:

           Branch     
          /  |  \     
     Branch  3  Empty
    /  |  \
Empty  9  Empty

-}

-- present t n  returns True iff n is somewhere in t
--               (does *not* require the keys in the tree to be ordered:
--                doesn't have to be a binary *search* tree)
present :: Tree -> Integer -> Bool

present Empty n            = False
present (Branch tL k tR) n =
  if k == n then True              -- found the key n
  else if present tL n then True   -- if n is present in the left child, it is present in the tree
  else present tR n                -- if n is present in the right child, it is present in the tree
{-
  The idea here is that `present', given an Empty tree, says False because there are no keys in an empty tree.

  Given a   Branch
           /  |  \
         tL   k  tR , `present' checks if the key being searched for, n, is equal to k.
                      If so, it returns True because the key is present in the tree (at the root).
                      If not, it calls  present tL n  to look for the key in the left child.
                        If present tL n is True, we return True.
                      Otherwise (the last `else'),
                        return  present tR n:  if present tR n is True, n is in the right child,
                                                                        so it is in the tree.
                                               if present tR n is False, n is not in the right child;
                                                 since we looked at the root, in the left child, and
                                                 in the right child, n is not in the tree.
-}


-- Data type representing "arithmetic expressions",
-- which are also trees of a particular kind.
data ArithExpr = Constant Integer
               | Negate ArithExpr
               | Add ArithExpr ArithExpr
               | Subtract ArithExpr ArithExpr 
               deriving (Show)

{-
  Every `data' type in Haskell can be viewed as a tree.
  (Even the `Bool' type: False is a very small tree, and True is a very small tree.)

  We can view                              We can view

     Add (Constant 3) (Constant 4)               Negate (Constant 2)

  as a tree                                as a tree

             Add                                    Negate
            /   \                                     |
      Constant   Constant                          Constant
         |          |                                 |
         3          4                                 2

  This is kind of like a 204 parse tree       Or a 204 parse tree for the formula
  or syntax tree for a formula p \/ q:        not q:

          \/                                        not
        /    \                                       |
       p      q                                      q

  My intended meaning for Add (Constant 3) (Constant 4) is similar to
  the meaning of the Haskell expression  3 + 4: we should be able to "calculate"
  the result as 7.
-}

{-
  Exercise 1: Draw the tree for   Subtract (Negate (Constant 1)) (Constant 3)

 




  Exercise 2: Write the expression represented by

         Add
        /   \
    Negate   Constant
      |         |
   Constant     9
      |
      3
-}

-- calc :: ArithExpr -> Integer
-- "Calculate" the result of an ArithExpr.
-- Examples:
--   calc (Negate (Constant (-5))) should step (eventually) to 5
--   calc (Negate (Negate (Constant (-5)))) should step (eventually) to -5
--   calc (Add (Constant 3) (Constant 4)) should step (eventually) to 7
--
calc :: ArithExpr -> Integer
calc (Constant k)     = k
calc (Negate e)       = 0 - (calc e)
calc (Add e1 e2)      = (calc e1) + (calc e2)
calc (Subtract e1 e2) = (calc e1) - (calc e2)

{-
  Exercise 3:  Complete the stepping:

     calc (Subtract (Negate (Constant 1)) (Constant 3))
  => (calc (Negate (Constant 1))) - (calc (Constant 3))
  => 

...

-}



{-
  The type [Bool] is the type of lists of Booleans.
  It is essentially the same as us declaring

  data [Bool] = []
              | Bool : [Bool]

  except that we can't do that because [ ] can't appear in a user-defined
  type name; it's reserved for Haskell's built-in lists.
-}

list1 = [True, False, False]

list2 = True : (False : (False : []))
{-
   list2 is the same as list1; it is what list1 "really" is.
   Haskell prints both list1 and list2 as
    [True, False, False] because that's more readable.
   However, when programming with lists, it's usually better to think
   in terms of : and [].
-}



-- mysum ys: Return the sum of the integer elements of the list ys.
--
-- Example: mysum [10, 3, 100] == 113
--
mysum :: [Integer] -> Integer

mysum []       = 0
mysum (x : xs) = x + (mysum xs)



-- myappend xs ys: Return xs appended with ys.
-- Example: myappend [6, 5, 4] [1, 2, 3] should return [6, 5, 4, 1, 2, 3].
--
myappend :: [Integer] -> [Integer] -> [Integer]
myappend []      ys = ys
myappend (h : t) ys = h : (myappend t ys)


-- How to get around Haskell's requirement that list elements have the same type
data IntOrBool = AnInt Int
               | ABool Bool

mixed_list :: [IntOrBool]
mixed_list = [AnInt 3, ABool True, AnInt 10]
