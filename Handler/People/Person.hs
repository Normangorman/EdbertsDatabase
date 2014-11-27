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
    runDB $ do
        --Delete all their group memberships
        deleteWhere [PersonGroupRelationPerson ==. pid]

        --Then all their qual ownerships
        deleteWhere [PersonQualRelationPerson ==. pid]

        --Finally the person themself
        delete pid
    
    setMessage "Person deleted successfully."
    return ()
