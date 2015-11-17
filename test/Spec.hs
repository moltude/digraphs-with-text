import Test.HUnit
import Dwt
import qualified Data.List as List
                           
main = runTestTT testList

testList = TestList 
  [ -- TestLabel "tStmt" tStmt -- why was I doing that, if these work?
    tInsert
    , tInsert'
    , tRelvs
    , tRelvs'
  ]

g1,g1',g2,g2' :: Mindmap
g1 = mkGraph [   (0, StrExpr "dog"   )
               , (1, StrExpr "_ wants _" )
               , (2, StrExpr "_ needs _" )
               , (3, StrExpr "water" )
               , (4, StrExpr "brandy")
               , (5, RelExpr 3       )
               , (6, RelExpr 3       ) ]
            [   (5,0,RelPosition 1), (5,1,RelPosition 2), (5,4,RelPosition 3)
              , (6,0,RelPosition 1), (6,2,RelPosition 2), (6,3,RelPosition 3) ]

g1' =   insRelExpr (0,2,3)      $ insRelExpr (0,1,4)
      $ insStrExpr "brandy"     $ insStrExpr "water" 
      $ insStrExpr "_ needs _"  $ insStrExpr "_ wants _"
      $ insStrExpr "dog" mmEmpty

tInsert = TestCase $ do
  assertBool "insStrExpr" $ insStrExpr "nerp" mmEmpty 
    == mkGraph [(0, StrExpr "nerp")] []
  assertBool "insRelExpr & insStrExpr" $ g1 == g1'

tRelvs = TestCase $ do
  assertBool "mmRelvs 0-- some" $ mmRelvs g1 (Just 0, Nothing, Nothing) == [5,6]
    -- TODO: Order matters; that could have been [6,5]. Use Set instead.
  assertBool "mmRelvs 1-- none" $ mmRelvs g1 (Just 1, Nothing, Nothing) == []
  assertBool "mmRelvs -1- some" $ mmRelvs g1 (Nothing, Just 1, Nothing) == [5]
  assertBool "mmRelvs -0- none" $ mmRelvs g1 (Nothing, Just 0, Nothing) == []
  assertBool "mmRelvs --4 some" $ mmRelvs g1 (Nothing, Nothing, Just 4) == [5]
  assertBool "mmRelvs --0 none" $ mmRelvs g1 (Nothing, Nothing, Just 0) == []
  assertBool "mmRelvs 01- some" $ mmRelvs g1 (Just 0, Just 1, Nothing) == [5]
  assertBool "mmRelvs 02- some" $ mmRelvs g1 (Just 0, Just 2, Nothing) == [6]
  assertBool "mmRelvs 03- none" $ mmRelvs g1 (Just 0, Just 3, Nothing) == []
  assertBool "mmRelvs -14 some" $ mmRelvs g1 (Nothing, Just 1, Just 4) == [5]
  assertBool "mmRelvs -20 none" $ mmRelvs g1 (Nothing, Just 2, Just 0) == []
  assertBool "mmRelvs 023 some" $ mmRelvs g1 (Just 0, Just 2, Just 3) == [6]
  assertBool "mmRelvs 024 none" $ mmRelvs g1 (Just 0, Just 2, Just 4) == []

g2 = mkGraph [   (0, StrExpr "dog"   )
               , (1, StrExpr "_ wants _" )
               , (2, StrExpr "_ needs _" )
               , (3, StrExpr "water" )
               , (4, StrExpr "brandy")
               , (5, RelExpr 2       )
               , (6, RelExpr 2       ) ]
            [   (5,1,RelTemplate), (5,0,RelPosition 1), (5,4,RelPosition 2)
              , (6,2,RelTemplate), (6,0,RelPosition 1), (6,3,RelPosition 2) ]

g2' =   insRelExpr' 2 [0,3]     $ insRelExpr' 1 [0,4]
      $ insStrExpr "brandy"     $ insStrExpr "water" 
      $ insStrExpr "_ needs _"  $ insStrExpr "_ wants _"
      $ insStrExpr "dog" mmEmpty

tInsert' = TestCase $ do
  assertBool "insStrExpr" $ insStrExpr "nerp" mmEmpty 
    == mkGraph [(0, StrExpr "nerp")] []
  assertBool "insRelExpr' & insStrExpr" $ g2 == g2'

tRelvs' = TestCase $ do
  assertBool "mmRelvs 0-- some" $ mmRelvs g2 (Just 0, Nothing, Nothing) == [5,6]
    -- TODO: Order matters; that could have been [6,5]. Use Set instead.
  assertBool "mmRelvs 1-- none" $ mmRelvs g2 (Just 1, Nothing, Nothing) == []
  assertBool "mmRelvs -1- some" $ mmRelvs g2 (Nothing, Just 1, Nothing) == [5]
  assertBool "mmRelvs -0- none" $ mmRelvs g2 (Nothing, Just 0, Nothing) == []
  assertBool "mmRelvs --4 some" $ mmRelvs g2 (Nothing, Nothing, Just 4) == [5]
  assertBool "mmRelvs --0 none" $ mmRelvs g2 (Nothing, Nothing, Just 0) == []
  assertBool "mmRelvs 01- some" $ mmRelvs g2 (Just 0, Just 1, Nothing) == [5]
  assertBool "mmRelvs 02- some" $ mmRelvs g2 (Just 0, Just 2, Nothing) == [6]
  assertBool "mmRelvs 03- none" $ mmRelvs g2 (Just 0, Just 3, Nothing) == []
  assertBool "mmRelvs -14 some" $ mmRelvs g2 (Nothing, Just 1, Just 4) == [5]
  assertBool "mmRelvs -20 none" $ mmRelvs g2 (Nothing, Just 2, Just 0) == []
  assertBool "mmRelvs 023 some" $ mmRelvs g2 (Just 0, Just 2, Just 3) == [6]
  assertBool "mmRelvs 024 none" $ mmRelvs g2 (Just 0, Just 2, Just 4) == []
