module Handler.EditGroup where

import Import
import Handler.Plugins
import Handler.Utils
import Handler.PersonUtils
import Text.Julius (rawJS)
import Handler.Group (getGroupPeople)
import Database.Persist.Sql (toSqlKey, fromSqlKey)
--Used for parsing textual database ids
import Data.Int (Int64)
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
            groupPeople <- getGroupPeople gid

            --These are all interpolated in the julius file for form preselects
            let project         = (toJSON . pGroupProject) group
            let meetsOnDay      = (toJSON . fromMaybe . pGroupMeetsOnDay) group
            let groupPeopleIds  = toJSON $ map (\(Entity key _) -> key) groupPeople
            defaultLayout $ do
                clockPickerWidget
                chosenWidget
                $(widgetFile "edit-group") 

postEditGroupR :: PGroupId -> Handler Html
postEditGroupR gid = do
    editedGroup <- runInputPost $ PGroup
        <$> ireq textField "name"
        <*> ireq textField "project"
        <*> iopt textField "meets_on_day"      
        <*> iopt timeField "meets_at_time"
    runDB $ replace gid editedGroup

    --Create new personGroupRelations where appropriate
    personIds <- lookupPostParams "person_ids"
    runDB $ deleteWhere [PersonGroupRelationGroup ==. gid]    
    mapM_ (insertRelation gid) personIds

    setMessage "Group succesfully edited."
    redirect (GroupR gid)

insertRelation :: PGroupId -> Text -> Handler ()
insertRelation _   ""       = return ()
insertRelation gid textPid  = runDB $ do
    case decimal textPid of
        Left  _        -> return ()
        Right (pid, _) -> insert_ $ PersonGroupRelation (toSqlKey pid) gid
