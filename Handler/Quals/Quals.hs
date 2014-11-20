module Handler.Quals.Quals where

import Import
import Handler.Utils
import Handler.Quals.Qual (getQualGroups)

getQualsR :: Handler Html
getQualsR = do
    quals <- runDB $ selectList [] [Asc QualName]
    defaultLayout $(widgetFile "Quals/quals")
