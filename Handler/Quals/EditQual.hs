module Handler.Quals.EditQual where

import Import
import Handler.Utils
import Handler.Plugins
import Handler.Quals.Qual (getQualGroups)
--Used for parsing textual database ids
import Database.Persist.Sql (toSqlKey, fromSqlKey)
import Data.Text.Read (decimal)

getEditQualR :: QualId -> Handler Html
getEditQualR qid = do
    maybeQual <- runDB $ get qid
    case maybeQual of 
        Nothing -> do
            setMessage "No qualification found with that ID."
            redirect HomeR
        Just qual -> do
            allGroups   <- runDB $ selectList ([]::[Filter PGroup]) []
            qualGroups  <- getQualGroups qid

            --These are all interpolated in the julius file for form preselects
            let qualGroupIds  = toJSON $ map (\(Entity key _) -> key) qualGroups
            defaultLayout $ do
                chosenWidget
                $(widgetFile "Quals/edit-qual") 

postEditQualR :: QualId -> Handler Html
postEditQualR qid = do
    editedQual <- runInputPost $ Qual
        <$> ireq textField "name"
        <*> iopt textField "details"
    runDB $ replace qid editedQual

    --Create new personGroupRelations where appropriate
    groupIds <- lookupPostParams "group_ids"
    runDB $ deleteWhere [QualGroupRelationQual ==. qid]    
    mapM_ (insertRelation qid) groupIds

    setMessage "Qualification succesfully edited."
    redirect (QualR qid)

insertRelation :: QualId -> Text -> Handler ()
insertRelation _   ""       = return ()
insertRelation qid textGid  = runDB $ do
    case decimal textGid of
        Left  _        -> return ()
        Right (gid, _) -> insert_ $ QualGroupRelation qid (toSqlKey gid) 
