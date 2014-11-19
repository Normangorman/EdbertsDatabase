module Handler.EditPerson where

import Import
import Handler.Plugins
import Handler.Utils (fromMaybe)
import Text.Julius (rawJS)
import Data.Maybe (fromJust)

getEditPersonR :: PersonId -> Handler Html
getEditPersonR pid = do
    maybePerson <- runDB $ get pid
    case maybePerson of 
        Nothing -> do
            setMessage "No person found with that ID."
            redirect HomeR
        Just person -> do
            let gender = (rawJS . fromMaybe . personGender) person
            let nationality = (rawJS . fromMaybe . personNationality) person

            allGroups    <- runDB $ selectList ([] :: [Filter PGroup]) []
            personGroups <- getPersonGroups pid
            --this is interpolated in the julius file and used to set the default selected options
            let personGroupNames = toJSON $ map (\(Entity _ pgroup) -> pGroupName pgroup) personGroups

            defaultLayout $ do
                datePickerWidget
                selectMultipleWidget
                $(widgetFile "edit-person") 


getPersonGroups :: PersonId -> Handler [Entity PGroup]
getPersonGroups pid = runDB $ do
    relations <- selectList [PersonGroupRelationPerson ==. pid] []
    let groupKeys = map groupKey relations

    selectList [PGroupId <-. groupKeys] []
    where groupKey (Entity _ r) = personGroupRelationGroup r

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
    
    --Wipe all existing relations to groups, then add the new ones 
    runDB $ deleteWhere [PersonGroupRelationPerson ==. pid]    

    groupNames <- lookupPostParams "groups"
    mapM_ (insertRelation pid) groupNames

    setMessage "Person succesfully edited."
    redirect (PersonR pid)

insertRelation :: PersonId -> Text -> Handler ()
insertRelation pid ""        = return ()
insertRelation pid groupName = runDB $ do
    maybeEntity <- selectFirst [PGroupName ==. groupName] []   
    -- if a group name is given then it's assumed it definitely does exist in the database
    let gid = (\(Just (Entity key _)) -> key) maybeEntity
    insert_ $ PersonGroupRelation pid gid

