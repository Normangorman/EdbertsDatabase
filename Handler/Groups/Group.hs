module Handler.Groups.Group where

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
            groupQuals  <- getGroupQuals  gid
            defaultLayout $(widgetFile "Groups/group")

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

getGroupQuals :: PGroupId -> Handler [Entity Qual]
getGroupQuals gid = runDB $ do
    relations <- selectList [QualGroupRelationGroup ==. gid] []
    let qualKeys = map qualKey relations

    selectList [QualId <-. qualKeys] []
    where qualKey (Entity _ r) = qualGroupRelationQual r
