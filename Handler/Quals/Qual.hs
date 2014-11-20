module Handler.Quals.Qual where

import Import
import Handler.Utils

getQualR :: QualId -> Handler Html
getQualR qid = do
    maybeQual <- runDB $ get qid
    case maybeQual of
        Nothing   -> notFound
        Just qual -> do
            qualGroups <- getQualGroups qid
            defaultLayout $(widgetFile "Quals/qual")
    
getQualGroups :: QualId -> Handler [Entity PGroup]
getQualGroups qid = runDB $ do
    relations <- selectList [QualGroupRelationQual ==. qid] []
    let groupKeys = map groupKey relations

    selectList [PGroupId <-. groupKeys] []
    where groupKey (Entity _ r) = qualGroupRelationGroup r

deleteQualR :: QualId -> Handler ()
deleteQualR qid = do
    setMessage "Qualification deleted succesfully."
    runDB $ delete qid
    return ()
