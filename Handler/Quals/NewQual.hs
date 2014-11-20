module Handler.Quals.NewQual where

import Import
import Handler.Utils

getNewQualR :: Handler Html
getNewQualR = defaultLayout $(widgetFile "Quals/new-qual")

postNewQualR :: Handler ()
postNewQualR = do
    qual <- runInputPost $ Qual
        <$> ireq textField "Name"
        <*> iopt textField "Details"
    qid <- runDB $ insert qual
    setMessage "Qualification succesfully created!"
    redirect $ QualR qid
