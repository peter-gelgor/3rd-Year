data Shrub = Blue
           | Red Integer
           | One Shrub
           | Two Shrub Shrub
           deriving Show

exp = Two (One (Red 9)) (Two (Blue) (Red 5))

{-
Write a function h such that

  attwo h (Two (Red 5) (Red 6))  returns  Red 7

and, for all shrubs s,

  attwo h (Two Blue s)           returns  s

For example,

  attwo h (Two Blue (Red 0))     should return  Red 0

Begin by writing the appropriate type declaration for h.
-}
attwo :: (Shrub -> Shrub -> Shrub) -> Shrub -> Shrub
attwo f (One shrub)      = One (attwo f shrub)
attwo f (Two left right) = f (attwo f left) (attwo f right)
attwo f shrub            = shrub

h :: Shrub -> Shrub -> Shrub

{-
attwo h (Two (Red 5) (Red 6))
h (attwo h (Red 5)) (attwo h (Red 6))
h (Red 5) (Red 6)
-}

h (Red 5) (Red 6) = Red 7

{-
attwo h (Two Blue s)
h (attwo h Blue) (attwo h s)
h (Blue) (s)
s
-}

h Blue s = s

altmap :: ((a -> a), [a]) -> [a]
altmap (f, x : y : zs) = (f x) : y : altmap (f, zs)
altmap (f, other)      = other

override :: (s -> t) -> [(Maybe s, s)] -> [t]
override f []                      = []
override f ((Just x, y) : rest)       = f x : override f rest
override f ((Nothing, y) : rest) = f y : (override f rest)