module Handler.Person where

import Import
--import Handler.Plugins
import Handler.Utils (fromMaybe)
import Handler.PersonUtils (getPersonAge, getPersonGroups)
import System.IO.Unsafe (unsafePerformIO)

getPersonR :: PersonId -> Handler Html
getPersonR pid = do
    maybePerson <- runDB $ get pid
    case maybePerson of
        Nothing -> defaultLayout $ do
            setMessage "Nobody exists with that ID!"
        Just person -> do 
            personGroups <- getPersonGroups pid
            defaultLayout $(widgetFile "person")

deletePersonR :: PersonId -> Handler ()
deletePersonR pid = do
    setMessage "Person deleted succesfully."
    runDB $ delete pid
    return ()
