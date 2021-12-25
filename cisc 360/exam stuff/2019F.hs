two_power :: Integer -> Integer
two_power n = if n == 0 then 1 else 2 * two_power (n-1)

-- two_acc acc n: return the accumulator acc, multiplied by two raised to the power of n
two_acc :: Integer -> Integer -> Integer

two_acc acc n = if n == 0 then acc
                else two_acc (acc * 2) (n-1)



-- conjoin t: returns a function of type t -> Bool that returns True if and only if all the functions in t return True
conjoin :: [t -> Bool] -> (t -> Bool)
conjoin [] = (\x -> True)
conjoin (f : fs) = let conjoined_fs = conjoin fs
                   in (\x -> f x && conjoined_fs x)

-- allfilter l t: return a list of all elements of t that return true for all functions in l
-- allfilter :: [a -> Bool] -> [a] -> [a]
-- allfilter fs [] = []
-- allfilter fs (x : xs) = if conjoin fs (\f -> f x) then x : allfilter fs xs else allfilter fs xs

type Item = Integer     -- weight
knapsack :: [Item]      -- items available to put in knapsack
            -> (Integer,-- threshold: items placed must have AT LEAST this weight
                Integer) -- limit: the knapsack can carry UP TO this weight
            -> (
                ([Item], -- success continuation: take a solution
                () -> b) -- plus a way to get more solutions 
                -> b,    -- success continuation returns type b
                () -> b  -- failure continuation
                )
                -> b

-- otherwise written as knapsack :: [Item] -> (Integer, Integer) -> (([Item], () -> b) -> b, () -> b) -> b

knapsack items (threshold, limit) (kSucceed, kFail) = 
    if limit < 0 then kFail()
    else case items of
        [] -> if threshold > 0 then kFail()
                else kSucceed([], id)
        (itemWeight : rest) -> 
            let kTryWithoutItem() -> knapsack rest (threshold, limit) (kSucceed, kFail)
                kSucceedWithItem (contents, kMore) =
                    kSucceed (itemWeight : contents, kMore)
            in
                knapsack rest
                    (threshold - itemWeight, -- we put in this item, so we are itemWeight closer to putting in enough
                    limit - itemWeight)     -- we put in this item, so we have less weight remaining
                    (kSucceedWithItem, kTryWithoutItem)
            

diag :: Integer -> Integer
diag x = if x == 0 then 0 
        else x + (diag (x-1))

accdiag :: Integer -> Integer -> Integer
accdiag acc y = if y == 0 then acc
                else accdiag (acc + y) (y-1)
             

            