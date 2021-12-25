data Rbt = Red Rbt String Rbt
        | Black Rbt String Rbt
        | Empty
        deriving (Show, Eq)

-- Given an Rbt, return the maximum number of Black
-- nodes along any path from the root to a leaf.
maxheight :: Rbt -> Integer 
maxheight Empty = 0
maxheight (Red a _ b) = max (maxheight a) (maxheight b)
maxheight (Black a _ b) = 1 + max (maxheight a) (maxheight b)

data Exp = Const Integer 
        | Var String
        | Add Exp Exp
        | Negate Exp
        deriving (Show, Eq)

-- The function 'replace' is supposed to replace a variable with an Exp. For example:
-- replace "h" (Const 4) (Add(Var "h") (Add(Var "g")(Var "h"))) should return
-- Add (Const 4) (Add (Var "g") (Const 4))
-- the Const 4 nodes are the result of replacing the Var "h" with a Const 4.

replace :: String -> Exp -> Exp -> Exp
replace x e (Const m) = Const m
replace x e (Add e1 e2) = Add (replace x e e1) (replace x e e2)
replace x e (Negate y) = Negate (replace x e y)
replace x e (Var y) = if (x == y) then e else (Var y)



data Song = Harmony Song Song
          | Melody Integer
          deriving (Show, Eq)
          
agglom :: Song -> Song
agglom (Melody k) = Melody (k + 1)
agglom (Harmony s1 (Melody _)) =
    Harmony (Melody 2)(agglom s1)
agglom (Harmony s1 s2) =
    if s1 == s2 then Harmony s1 s1
                else Melody 4