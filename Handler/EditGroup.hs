module Handler.EditGroup where

import Import
import Handler.Plugins
import Handler.Utils
import Handler.PersonUtils
import Text.Julius (rawJS)
import Handler.Group (getGroupPeople)

getEditGroupR :: PGroupId -> Handler Html
getEditGroupR gid = do
    maybeGroup <- runDB $ get gid
    case maybeGroup of 
        Nothing -> do
            setMessage "No group found with that ID."
            redirect HomeR
        Just group -> do
            let project = (rawJS . pGroupProject) group
            let meetsOnDay = (rawJS . fromMaybe . pGroupMeetsOnDay) group

            allPeople   <- runDB $ selectList ([]::[Filter Person]) []
            groupPeople <- getGroupPeople gid

            let allPeopleNames      = jsonArrayOfNames allPeople
            let allGroupPeopleNames = jsonArrayOfNames groupPeople

            defaultLayout $ do
                clockPickerWidget
                typeaheadWidget
                $(widgetFile "edit-group") 
    where jsonArrayOfNames entities = toJSON $ map (\(Entity _ p) -> personWholeName p) entities

postEditGroupR :: PGroupId -> Handler Html
postEditGroupR pgid = do
    editedGroup <- runInputPost $ PGroup
        <$> ireq textField "name"
        <*> ireq textField "project"
        <*> iopt textField "meets_on_day"      
        <*> iopt timeField "meets_at_time"
    runDB $ replace pgid editedGroup
    setMessage "Group succesfully edited."
    redirect (GroupR pgid)

