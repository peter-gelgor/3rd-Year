type ShoppingList = [(String, Int)]

addItem :: String -> Int -> ShoppingList -> ShoppingList
addItem name amount [] = [(name, amount)]
addItem name amount (x:xs) = if (x == (name, _)) then (name, amount + _) : xs else x : addItem name amount xs

data Tree = Int
        | Tree Int Tree
        deriving(Show, Eq)

