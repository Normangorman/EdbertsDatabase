module Handler.Quals.EditQual where

import Import
import Handler.Utils
import Handler.Plugins
import Handler.Quals.Qual () -- just import the instances of Related
import Handler.People.PersonUtils (personWholeName)
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
            --groups and people are interpolated in the hamlet file
            groups     <- allGroups
            qualGroups <- relations qid :: Handler [Entity PGroup]

            people     <- allPeople
            qualPeople <- relations qid :: Handler [Entity Person]

            --These are all interpolated in the julius file for form preselects
            let qualGroupIds  = jsonKeys qualGroups
            let qualPeopleIds = jsonKeys qualPeople
            defaultLayout $ do
                chosenWidget
                $(widgetFile "Quals/edit-qual") 

postEditQualR :: QualId -> Handler Html
postEditQualR qid = do
    editedQual <- runInputPost $ Qual
        <$> ireq textField "name"
        <*> iopt textField "details"
    runDB $ replace qid editedQual

    groupIds <- lookupPostParams "group_ids"
    runDB $ deleteWhere [QualGroupRelationQual ==. qid]    
    mapM_ (insertGroupRelation qid) groupIds

    personIds <- lookupPostParams "person_ids"
    runDB $ deleteWhere [PersonQualRelationQual ==. qid]    
    mapM_ (insertPersonRelation qid) personIds

    setMessage "Qualification successfully edited."
    redirect (QualR qid)

insertGroupRelation :: QualId -> Text -> Handler ()
insertGroupRelation _   ""       = return ()
insertGroupRelation qid textGid  = runDB $ do
    case decimal textGid of
        Left  _        -> return ()
        Right (gid, _) -> insert_ $ QualGroupRelation qid (toSqlKey gid) 

insertPersonRelation :: QualId -> Text -> Handler ()
insertPersonRelation _   ""       = return ()
insertPersonRelation qid textPid  = runDB $ do
    case decimal textPid of
        Left  _        -> return ()
        Right (pid, _) -> insert_ $ PersonQualRelation (toSqlKey pid) qid 
