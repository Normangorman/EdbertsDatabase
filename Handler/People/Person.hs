module Handler.People.Person where

import Import
--import Handler.Plugins
import Handler.Utils
import Handler.People.PersonUtils
import System.IO.Unsafe (unsafePerformIO)

getPersonR :: PersonId -> Handler Html
getPersonR pid = do
    maybePerson <- runDB $ get pid
    case maybePerson of
        Nothing -> defaultLayout $ do
            setMessage "Nobody exists with that ID!"
        Just person -> do 
            personGroups <- relations pid
            personQuals  <- relations pid
            
            defaultLayout $(widgetFile "People/person")

deletePersonR :: PersonId -> Handler ()
deletePersonR pid = do
    setMessage "Person deleted succesfully."
    runDB $ delete pid
    return ()
