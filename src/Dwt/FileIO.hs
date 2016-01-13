    module Dwt.FileIO
      ( graphToText
      ) where

    import Dwt.Graph
    import Dwt.Parse
    import Data.List (intersperse, sortOn)

-- pretty-print graph for svn|git diff
    -- each line corresponds either to a node, or to the members of a Rel or Coll
      -- (and always in the same order)
    -- so that if you edit a graph, the diff is easily human-readable
    -- TODO ? could be more general (in 2 ways)
      -- currently it groups on whether the first coordinates are equal
        -- it assumes that elts with the same first coord are contiguous
        -- in a more general func, that could be forced by sorting first (1 way)
      -- "take the first coord" could be a function argument (the 2nd way)
    _groupEdges :: [LEdge b] -> [[LEdge b]] -> [[LEdge b]]
    _groupEdges [] els = els
    _groupEdges (e:es) [] = _groupEdges es [[e]]
    _groupEdges   (( a, b, c):es )  
                 (((aa,bb,cc):es'):els') = if a == aa
      then _groupEdges es $   ((a,b,c):(aa,bb,cc):es'):els'
      else _groupEdges es $ [(a,b,c)]:((aa,bb,cc):es'):els'

    groupEdges :: Ord b => [LEdge b] -> [[LEdge b]]
    groupEdges es = map (sortOn (\(_,_,c)->c))
      $ _groupEdges es []

    graphToText g = concat $ map (++ "\n") $ 
         (map show $ labNodes g)
      ++ (map (concat . intersperse "," . map show) $ groupEdges $ labEdges g)
