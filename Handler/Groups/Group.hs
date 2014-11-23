module Handler.Groups.Group where

import Import
--import Handler.Plugins
import Handler.Utils

getGroupR :: PGroupId -> Handler Html
getGroupR gid = do
    maybeGroup <- runDB $ get gid
    case maybeGroup of
        Nothing -> defaultLayout $ do
            setMessage "No group exists with that ID!"
        Just group -> do 
            groupPeople    <- relations gid
            groupQuals     <- relations gid
            groupRegisters <- relations gid
            defaultLayout $(widgetFile "Groups/group")

deleteGroupR :: PGroupId -> Handler ()
deleteGroupR pgid = do
    setMessage "Group deleted succesfully."
    runDB $ delete pgid
    return ()

instance Related PGroup Person where
    relations key = runDB $ do  
        rs <- selectList [PersonGroupRelationGroup ==. key] []
        let rKeys = map rKey rs
        selectList [PersonId <-. rKeys] []
        where rKey (Entity _ r) = personGroupRelationPerson r

instance Related PGroup Qual where
    relations key = runDB $ do  
        rs <- selectList [QualGroupRelationGroup ==. key] []
        let rKeys = map rKey rs
        selectList [QualId <-. rKeys] []
        where rKey (Entity _ r) = qualGroupRelationQual r

instance Related PGroup Register where
    relations key = runDB $ do  
        selectList [RegisterGroup ==. key] [Desc RegisterDate]
