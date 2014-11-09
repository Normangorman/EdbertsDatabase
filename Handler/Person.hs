module Handler.Person where

import Import

getPersonR :: PersonId -> Handler Html
getPersonR personId = do
    maybePerson <- runDB $ get personId
    case maybePerson of
        Nothing -> defaultLayout $ do
            setMessage "Nobody exists with that ID!"
        Just person -> defaultLayout $  do
            $(widgetFile "person")

postPersonR :: PersonId -> Handler Html
postPersonR = error "Not yet implemented: postPersonR"

putPersonR :: PersonId -> Handler Html
putPersonR = error "Not yet implemented: putPersonR"
