module Handler.Person where

import Import
import Handler.QueryUtils (fromMaybe, getPersonAge)
import System.IO.Unsafe (unsafePerformIO)

getPersonR :: PersonId -> Handler Html
getPersonR pid = do
    maybePerson <- runDB $ get pid
    case maybePerson of
        Nothing -> defaultLayout $ do
            setMessage "Nobody exists with that ID!"
        Just person -> defaultLayout $  do
            $(widgetFile "person")

postPersonR :: PersonId -> Handler Html
postPersonR = error "Not yet implemented: postPersonR"

deletePersonR :: PersonId -> Handler ()
deletePersonR pid = do
    setMessage "Person deleted succesfully."
    runDB $ delete pid
    return ()
