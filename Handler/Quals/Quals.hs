module Handler.Quals.Quals where

import Import
import Handler.Utils

getQualsR :: Handler Html
getQualsR = do
    quals <- runDB $ selectList [] [Asc QualName]
    defaultLayout $(widgetFile "Quals/quals")
