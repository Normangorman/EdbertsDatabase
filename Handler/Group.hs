module Handler.Group where

import Import
import Handler.QueryUtils (fromMaybe)

getGroupR :: PGroupId -> Handler Html
getGroupR pgid = do
    maybeGroup <- runDB $ get pgid
    case maybeGroup of
        Nothing -> defaultLayout $ do
            setMessage "No group exists with that ID!"
        Just group -> defaultLayout $  do
            $(widgetFile "group")

deleteGroupR :: PGroupId -> Handler ()
deleteGroupR pgid = do
    setMessage "Group deleted succesfully."
    runDB $ delete pgid
    return ()
