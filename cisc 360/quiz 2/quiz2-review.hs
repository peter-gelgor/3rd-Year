{-
  CISC 360, Fall 2021
  Jana Dunfield
  
  Wednesdsay, 2021-10-20
-}

data ArithExpr = Negate   ArithExpr
               | Mult     ArithExpr ArithExpr
               | Subtract ArithExpr ArithExpr
               | Const    Integer
               deriving (Show)

{- calc: "calculate" an ArithExpr.
   For example,

              Mult
             /   \
         Const    Negate
           |        |
           2      Const
                    | 
                   100
  
      calc (Mult (Const 2) (Negate (Const 100)))
  =>  (calc (Const 2)) * (calc (Negate (Const 100)))  fun. app.
  =>  2 * (calc (Negate (Const 100)))                 fun. app.
  =>  2 * (0 - calc (Const 100))                      fun. app.
  =>  2 * (0 - 100)                                   fun. app.
  =>  2 * (-100)                                     arithmetic
  =>  -200                                           arithmetic
-}
calc :: ArithExpr -> Integer
calc (Const    m)     = m
calc (Negate   e1)    = 0 - (calc e1)
calc (Mult     e1 e2) = (calc e1) * (calc e2)
calc (Subtract e1 e2) = (calc e1) - (calc e2)

{-
  calc with an extra operation done everywhere
-}
excalc :: (Integer -> Integer) -> ArithExpr -> Integer
excalc f (Const m)        = f m
excalc f (Negate e1)      = f (0 - (excalc f e1))
excalc f (Mult e1 e2)     = f (excalc f e1 * excalc f e2)
excalc f (Subtract e1 e2) = f (excalc f e1 - excalc f e2)

-- examples:
--   excalc (\x -> x)   (Negate (Const 3))
--   excalc (\x -> 2*x) (Negate (Const 3))


{- Strange version of calc
-}
zcalc :: (Integer -> Integer) -> ArithExpr -> Integer
zcalc z (Const m)        = z m
zcalc z (Negate e1)      = zcalc (\r -> z (0 - r)) e1
zcalc z (Mult e1 e2)     = zcalc (\r1 -> zcalc (\r2 -> z (r1 * r2)) e2) e1
zcalc z (Subtract e1 e2) = zcalc (\r1 -> zcalc (\r2 -> z (r1 - r2)) e2) e1

