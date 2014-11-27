module Handler.Quals.Qual where

import Import
import Handler.Utils
import Handler.People.PersonUtils (personWholeName)

getQualR :: QualId -> Handler Html
getQualR qid = do
    maybeQual <- runDB $ get qid
    case maybeQual of
        Nothing   -> notFound
        Just qual -> do
            qualGroups <- relations qid
            qualPeople <- relations qid
            defaultLayout $(widgetFile "Quals/qual")
    
deleteQualR :: QualId -> Handler ()
deleteQualR qid = do
    setMessage "Qualification deleted successfully."
    runDB $ do
        deleteWhere [PersonQualRelationQual ==. qid]

        deleteWhere [QualGroupRelationQual ==. qid]

        delete qid

    return ()

instance Related Qual Person where
    relations key = runDB $ do  
        rs <- selectList [PersonQualRelationQual ==. key] []
        let rKeys = map rKey rs
        selectList [PersonId <-. rKeys] []
        where rKey (Entity _ r) = personQualRelationPerson r
        
instance Related Qual PGroup where
    relations key = runDB $ do  
        rs <- selectList [QualGroupRelationQual ==. key] []
        let rKeys = map rKey rs
        selectList [PGroupId <-. rKeys] []
        where rKey (Entity _ r) = qualGroupRelationGroup r

