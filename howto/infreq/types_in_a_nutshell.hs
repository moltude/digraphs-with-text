I use the Functional Graph Library (FGL) to implement something resembling a hyperggraph, which I'm calling SOLRT, in which relationships can involve any number of things, including other relationships. (By contrast, in a graph, Edges cannot belong to other Edges; only Nodes can.)

Here are the types:

    -- data/minmalGraph.hs demonstrates many of these types, in only like 20 lines
    -- Exprs (expressions) play RelRoles in Rels (relationships).
    -- Each Arity-k Rel emits k+1 Edges toward the other Exprs:
      -- one connects it to its RelTplt (relationship template)
      -- k more connect it to each of its k Mbrs (relationship members)
    -- Similarly, Colls use CollRoles.
    -- RelSpecExprs use RelRoles.
      -- but unlike Rels, they can be well-formed without emitting any.

    type RelPos = Int -- the k members of a k-ary Rel take RelPos values [1..k]
    type Arity = Int

    type SOLRT = Gr Expr SOLRTEdge
    data Expr = Str String | Tplt [String] | Rel | Coll String
              | RelSpecExpr RelVarSpec deriving(Show,Read,Eq,Ord)

    data SOLRTEdge = RoleEdge RelRole | CollEdge CollRole deriving(Show,Read,Eq,Ord)
    data RelRole = RelTplt | Mbr RelPos deriving(Show,Read,Eq,Ord) -- w/r/t a Rel
    data CollRole = CollMbr | CollTitle | CollSeparator deriving(Show,Read,Eq,Ord)

    data MbrVar = It | Any | Up | Down
      deriving (Show,Read,Eq,Ord)
    data MbConcreteMbr = VarSpec MbrVar | MbConcreteMbr Node deriving(Show,Read,Eq,Ord)

    type RelVarSpec = Map.Map RelRole MbrVar -- subset of RelSpec info, but
      -- a RelVarSpec in a SOLRT is transformable into a RelSpec.
      -- The rest of the info can be inferred from the edges connected to it.
    type RelSpec = Map.Map RelRole MbConcreteMbr
      -- if well-formed, has a Tplt, and RelPoss from 1 to the Tplt's Arity

The following is an obsolete (uses an earlier version of Dwt) SOLRT that represents the expression "dog needs water" using the subexpressions "dog" (a string), "water" (a string), and "_ wants _" (a relationship two things can have, that is a binary Rel):

    -- mkGraph :: Graph gr => [LNode a] -> [LEdge b] -> gr a b
      -- that is, mkGraph takes a list of nodes followed by a list of edges
    g1 :: SOLRT
    g1 = mkGraph
      [   (0, Str "dog"       )
        , (1, mkTplt "_ wants _" ) -- produces a Tplt with Arity 2
        , (3, Str "water"     )
        , (4, Rel 2           )
      ] [ -- "dog wants water"
            (4,1, RelTplt)  -- Node 1 is the Template for the Rel at Node 4
          , (4,0, RelMbr 1) -- Node 0 is the 1st Rel Member of the Rel at Node 4
          , (4,3, RelMbr 2) -- Node 3 is the 2nd Rel Member of the Rel at Node 4
      ]

The next SOLRT encodes the previous statement and a second statement stating that the first is dubious:

    g2 :: SOLRT
    g2 = mkGraph
      [   (0, Str "dog"       )
        , (1, mkTplt "_ wants _" )
        , (3, Str "water"     )
        , (4, Rel 2           )
        , (5, mkTplt "_ is _")
        , (6, Str "dubious"   )
        , (7, Rel 2           )
      ] 
      [ -- "dog wants water" is represented just like it was in g1
          (4,1,RelTplt), (4,0, RelMbr 1), (4,3,RelMbr 2),
        -- "[dog wants water] is dubious"
          (7,5,RelTplt),
          (7,4,RelMbr 1), -- Node 4, the first Member of this Rel, is itself a Rel
          (7,6,RelMbr 2)
      ]
