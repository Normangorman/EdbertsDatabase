module Handler.EditPerson where

import Import
import Handler.Plugins
import Handler.PersonUtils
import Handler.Utils (fromMaybe)
--Used for parsing textual database ids
import Database.Persist.Sql (toSqlKey, fromSqlKey)
import Data.Text.Read (decimal)

getEditPersonR :: PersonId -> Handler Html
getEditPersonR pid = do
    maybePerson <- runDB $ get pid
    case maybePerson of 
        Nothing -> do
            setMessage "No person found with that ID."
            redirect HomeR
        Just person -> do
            allGroups    <- runDB $ selectList ([] :: [Filter PGroup]) []
            personGroups <- getPersonGroups pid
            --this is interpolated in the julius file and used to set the default selected options
            let gender         = (toJSON . fromMaybe . personGender) person
            let nationality    = (toJSON . fromMaybe . personNationality) person
            let personGroupIds = toJSON $ map (\(Entity key _) -> key) personGroups

            defaultLayout $ do
                datePickerWidget
                chosenWidget
                $(widgetFile "edit-person") 



postEditPersonR :: PersonId -> Handler Html
postEditPersonR pid = do
    editedPerson <- runInputPost $ Person
        <$> ireq textField "First name"
        <*> ireq textField "Last name"
        <*> iopt dayField  "Birthday"      
        <*> iopt textField "Home number"  
        <*> iopt textField "Mobile number"
        <*> iopt textField "Email address"
        <*> iopt textField "Gender"      
        <*> iopt textField "Nationality"
    runDB $ replace pid editedPerson
    
    groupIds <- lookupPostParams "group_ids"
    runDB $ deleteWhere [PersonGroupRelationPerson ==. pid]    
    mapM_ (insertRelation pid) groupIds

    setMessage "Person succesfully edited."
    redirect (PersonR pid)

insertRelation :: PersonId -> Text -> Handler ()
insertRelation _   ""       = return ()
insertRelation pid textGid  = runDB $ do
    case decimal textGid of
        Left  _        -> return ()
        Right (gid, _) -> insert_ $ PersonGroupRelation pid (toSqlKey gid)
