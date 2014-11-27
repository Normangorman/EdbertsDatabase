module Handler.Groups.EditGroup where

import Import
import Handler.Plugins
import Handler.Utils
import Handler.People.PersonUtils
import Handler.Groups.Group ()
--Used for parsing textual database ids
import Database.Persist.Sql (toSqlKey, fromSqlKey)
import Data.Text.Read (decimal)

getEditGroupR :: PGroupId -> Handler Html
getEditGroupR gid = do
    maybeGroup <- runDB $ get gid
    case maybeGroup of 
        Nothing -> do
            setMessage "No group found with that ID."
            redirect HomeR
        Just group -> do
            allPeople   <- runDB $ selectList ([]::[Filter Person]) []
            groupPeople <- relations gid :: Handler [Entity Person]

            allQuals    <- runDB $ selectList ([]::[Filter Qual])   []
            groupQuals  <- relations gid :: Handler [Entity Qual]

            --These are all interpolated in the julius file for form preselects
            let project         = (toJSON . pGroupProject) group
            let meetsOnDay      = (toJSON . fromMaybe . pGroupMeetsOnDay) group
            let groupPeopleIds  = jsonKeys groupPeople
            let groupQualIds    = jsonKeys groupQuals 
            defaultLayout $ do
                clockPickerWidget
                chosenWidget
                $(widgetFile "Groups/edit-group") 
    

postEditGroupR :: PGroupId -> Handler Html
postEditGroupR gid = do
    editedGroup <- runInputPost $ PGroup
        <$> ireq textField "name"
        <*> ireq textField "project"
        <*> iopt textField "meets_on_day"      
        <*> iopt timeField "meets_at_time"
    runDB $ replace gid editedGroup

    personIds <- lookupPostParams "person_ids"
    runDB $ deleteWhere [PersonGroupRelationGroup ==. gid]    
    mapM_ (insertPersonRelation gid) personIds

    qualIds <- lookupPostParams "qual_ids"
    runDB $ deleteWhere [QualGroupRelationGroup ==. gid]    
    mapM_ (insertQualRelation gid) qualIds

    setMessage "Group successfully edited."
    redirect (GroupR gid)

insertPersonRelation :: PGroupId -> Text -> Handler ()
insertPersonRelation _   ""       = return ()
insertPersonRelation gid textPid  = runDB $ do
    case decimal textPid of
        Left  _        -> return ()
        Right (pid, _) -> insert_ $ PersonGroupRelation (toSqlKey pid) gid

insertQualRelation :: PGroupId -> Text -> Handler ()
insertQualRelation _   ""       = return ()
insertQualRelation gid textQid  = runDB $ do
    case decimal textQid of
        Left  _        -> return ()
        Right (qid, _) -> insert_ $ QualGroupRelation (toSqlKey qid) gid
