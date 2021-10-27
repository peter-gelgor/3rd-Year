{-
  CISC 360, Fall 2021
  
  Practice for quiz 1, first part

  Note: This file won't load, because of some of the bugs in the last question.
-}

module PracticeQuiz1 where

{- The Formula type will probably appear on the actual quiz.
-}
data Formula = And Formula Formula
             | Not Formula
             | Con Bool
             deriving Show

{- Write a Haskell expression of type Formula that corresponds to the following parse tree:

             Not
              |
              |
             And
            /   \
           /     \
          /       \
       And         And
      /   \       /   \
    Con  Con    Not  Con
    |     |     |     |
  False  True  Con   False
                |
               True

(the actual question will be less annoying than this one)
-}

--  (Formula not 
--   Formula(
--     Formula (
--         Formula(
--             Con False
--           ) and
--         Formula (
--           Con True
--           )

--       ) and 
--     Formula (
--         (not Formula (Con True)) and
--         Con False
--       )
--   )
--   )


 

{-
Write an English sentence that corresponds to this Haskell type declaration:

  mystery :: [Integer] -> [String] -> (Formula, Bool)
-}




{-
In this question, you are asked to find the bugs in some Haskell code.
Explain what the bugs are, and fix them by writing a correct version of the code.
Giving correct code by itself is not enough; you need to explain what the bugs are.
-}

{-
  The function  eval_formula "evaluates"
  a formula, by interpreting And as conjunction (and), Not as negation (not),
  and  Con b  as a constant b:  Con True  is interpreted as true, and Con False
  is interpreted as false.

  For example,  eval_formula (Con False)  should return False,  and
                eval_formula (Not (Con False))  should return True.
-}
eval_formula :: Formula -> Bool
eval_formula (And p1 p2) = (eval_formula p1) && (eval_formula p2)
eval_formula Not q       = eval_formula q
eval_formula Con b       = b
