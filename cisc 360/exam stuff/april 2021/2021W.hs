data Rbt = Red Rbt String Rbt
        | Black Rbt String Rbt
        | Empty

cinv :: Rbt -> Bool
cinv Empty = True
cinv (Red Empty x Empty) = True
cinv (Red (Red l x r) a _) = False
cinv (Red a _ (Red l x r)) = False
cinv (Black l x r) = cinv l && cinv r
cinv (Red l x r) = cinv l && cinv r

adjust :: ((t -> t), [t]) -> [t]
adjust (u, x : y : zs) = (u y) : x : adjust (u, zs)
adjust (u, zs) = []

data Exp = Const Integer
        | Var String
        | Add Exp Exp
        | Negate Exp
        deriving (Show, Eq)

inline :: Exp -> Exp
inline (Const m) = Const m
inline (Add e1 e2) = case (inline e1, inline e2) of
    (Const m, Const n) -> Const (m + n)
    (e1', e2') -> Add e1' e2'
inline (Negate e) = case inline e of
    Const m -> Const (-m)
    e' -> Negate e'

-- patern not matched: var
inline (Var x) = Var x

may p = filter (uncurry p)

june n = 1 : (map (*n) (june n))

