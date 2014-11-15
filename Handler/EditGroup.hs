module Handler.EditGroup where

import Import
import Handler.QueryUtils (fromMaybe)
import Text.Julius (rawJS)

getEditGroupR :: PGroupId -> Handler Html
getEditGroupR pgid = do
    maybeGroup <- runDB $ get pgid
    case maybeGroup of 
        Nothing -> do
            setMessage "No group found with that ID."
            redirect HomeR
        Just group -> do
            let project = (rawJS . pGroupProject) group
            let meetsOnDay = (rawJS . fromMaybe . pGroupMeetsOnDay) group
            defaultLayout $ do
                addStylesheet $ StaticR css_clockpicker_min_css
                addScript     $ StaticR js_clockpicker_min_js

                $(widgetFile "edit-group") 

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

