data Formula = And Formula Formula
             | Not Formula
             | Con Bool
             deriving Show

eval_formula :: Formula -> Bool
eval_formula (And p1 p2) =
  (eval_formula p1) && (eval_formula p2)
eval_formula (Not q) = not (eval_formula q)
eval_formula (Con b) = b


eval_list :: [Formula] -> Bool
eval_list (f : fs) = (eval_formula f) && (eval_list fs)
eval_list [] = True