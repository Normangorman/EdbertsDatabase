{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Home where

import Import
getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do
        $(widgetFile "homepage")
