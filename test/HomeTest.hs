{-# LANGUAGE OverloadedStrings #-}
module HomeTest
    ( homeSpecs
    ) where

import TestImport
import qualified Data.List as L

homeSpecs :: Spec
homeSpecs =
    ydescribe "Home page tests:" $ do

        yit "loads the home page and checks it looks right" $ do
            get HomeR
            statusIs 200
            htmlAnyContain "h1" "Edberts Database"

{-
        -- This is a simple example of using a database access in a test.  The
        -- test will succeed for a fresh scaffolded site with an empty database,
        -- but will fail on an existing database with a non-empty user table.
        yit "leaves the user table empty" $ do
            get HomeR
            statusIs 200
            people <- runDB $ selectList ([] :: [Filter Person]) []
            assertEqual "user table not empty" 0 $ L.length people
-}


{-
    request $ do
            setMethod "POST"
            setUrl HomeR
            addNonce
            fileByLabel "Choose a file" "test/main.hs" "text/plain" -- talk about self-reference
            byLabel "What's on the file?" "Some Content"
-}
