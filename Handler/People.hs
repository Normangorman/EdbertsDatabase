module Handler.People where

import Import

getPeopleR :: Handler Html
getPeopleR = do
    people <- runDB $ selectList 
        []
        [Asc PersonLastName, Asc PersonFirstName]
    defaultLayout $ do
        $(widgetFile "people")

fromMaybe :: Show a => Maybe a -> String
fromMaybe Nothing  = ""
fromMaybe (Just a) = show a

postPeopleR :: Handler Html
postPeopleR = error "Not yet implemented: postPeopleR"
