module Handler.Group where

import Import
--import Handler.Plugins
import Handler.Utils (fromMaybe)

getGroupR :: PGroupId -> Handler Html
getGroupR gid = do
    maybeGroup <- runDB $ get gid
    case maybeGroup of
        Nothing -> defaultLayout $ do
            setMessage "No group exists with that ID!"
        Just group -> do 
            groupPeople <- getGroupPeople gid
            defaultLayout $(widgetFile "group")

deleteGroupR :: PGroupId -> Handler ()
deleteGroupR pgid = do
    setMessage "Group deleted succesfully."
    runDB $ delete pgid
    return ()

getGroupPeople :: PGroupId -> Handler [Entity Person]
getGroupPeople gid = runDB $ do
    relations <- selectList [PersonGroupRelationGroup ==. gid] []
    let personKeys = map groupKey relations

    selectList [PersonId <-. personKeys] []
    where groupKey (Entity _ r) = personGroupRelationPerson r
