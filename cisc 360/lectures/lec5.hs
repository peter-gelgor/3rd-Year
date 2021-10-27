-- CISC 360, Fall 2021
-- Jana Dunfield
-- 
-- Code for week 2, part 3 (lecture 5 / 360-lec5.pdf)

module Lec5 where

{-
In this file:

      1. the Char type
           Thompson sec. 3.5

      2. using guards to define functions "piecewise"
           Thompson sec. 3.4

      3. more recursion
           Thompson sec. 4.4, 4.5, 4.7
-}

{-
     1. the Char type
-}
-- Like many other languages, Haskell has a type of single characters,
-- enclosed in ' '

capitalA :: Char
capitalA = 'A'

-- This is different from strings, which are enclosed in " "
-- In Haskell, strings are lists [ ] of characters
incoherent :: [Char]
incoherent = "AAAAAAAAAAAAAAAAAAAAA"
--         ['A', 'A', 'A', 'A', ]
-- 'A' and "A" are different

coherent :: [Char]
coherent = "A"        -- just one character, but in " " so [Char], not Char

withdeclaration :: String
withdeclaration = "abc"      -- try  :type withdeclaration


{-
     2. using guards to define functions "piecewise"
-}

-- More "piecewise" functions:
--
--   absolute value
--   is_upper
--   is_lower

-- abs(x) = x    if x >= 0
-- abs(x) = -x   if x < 0
-- abs(x) =
--     x    if x >= 0
--     -x   otherwise
my_abs :: Integer -> Integer
my_abs x
     | x >= 0  =  x
     | x < 0   =  -x   -- originally written like this: x * (-1)

-- The following functions could be written with guards,
-- but shorter this way
--
-- is_upper ch == True  iff ch is an uppercase letter
--
-- equivalently:
--
-- is_upper ch  = True   if ch in the range 'A'...'Z'
-- is_upper ch  = False  otherwise
is_upper :: Char -> Bool
-- is_upper ch = (ch >= 'A') && (ch <= 'Z')
is_upper ch
       | (ch >= 'A') && (ch <= 'Z') = True
       | otherwise = False

-- is_lower ch == True  iff ch is a lowercase letter
is_lower :: Char -> Bool
is_lower ch = (ch >= 'a') && (ch <= 'z')

-- is_letter ch == True  iff ch is a letter
is_letter :: Char -> Bool
is_letter ch = is_upper ch || is_lower ch


{-
     3. more recursive functions
-}

--                 0
-- two_raised 0 = 2  = 1

--                 n
-- two_raised n = 2     (2 to the nth power)
-- assume n >= 0
--
two_raised :: Integer -> Integer
two_raised n = if n == 0 then 1 else 2 * two_raised (n - 1)
{-
               n         (n - 1)
              2  =  2 * 2
    ^^^^^^^^^^^^        ^^^^^^^^
    two_raised n        two_raised (n - 1)
-}

{-
      two_raised 3 
   => (if n == 0 then 1 else 2 * two_raised (n - 1))[3/n]
   =  (if 3 == 0 then 1 else 2 * two_raised (3 - 1))
   => (if False  then 1 else 2 * two_raised (3 - 1))
   => 2 * two_raised (3 - 1)
   => 2 * two_raised 2
   => ...
   => 2 * (2 * two_raised (2 - 1))
   => 2 * (2 * two_raised 1)
   => ...
   => 2 * (2 * (2 * (two_raised (1 - 1))))
   => 2 * (2 * (2 * (two_raised 0)))
 =>=> 2 * (2 * (2 * 1))
   => 2 * (2 * 2)
   => 2 * 4
   => 8
-}

-- Some functions that loop forever
-- (and that may need unusual interventions to interrupt them)
danger_zone :: Integer -> Integer
danger_zone n = 2 * danger_zone n

maybe_danger_zone :: Integer -> Integer
maybe_danger_zone n = maybe_danger_zone n
