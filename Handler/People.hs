module Handler.People where

import Import
import Handler.Plugins
--import Handler.Utils (fromMaybe)
import Handler.PersonUtils (mkPeopleRows)
import Database.Persist.Sql (rawSql)
import qualified Data.Text as T

getPeopleR :: Handler Html
getPeopleR = do
    people <- runDB $ selectList [] [Asc PersonFirstName, Asc PersonLastName]
    let peopleTableRows = mkPeopleRows people
    defaultLayout $ do
        queryBuilderWidget
        tableSorterWidget
        datePickerWidget

        --this hamlet file interpolates the peopleRows widget
        $(widgetFile "people")


postPeopleR :: Handler Html
postPeopleR = do
    maybeQuery <- lookupPostParam "query"
    case maybeQuery of
        Nothing -> do
            withUrlRenderer [hamlet|No query given...|]
        Just sql -> do 
            let sqlToRun = "SELECT ?? FROM person WHERE (" `T.append` sql `T.append` ") "
            people <- runDB $ rawSql sqlToRun []
            rows <- widgetToPageContent $ mkPeopleRows people
            withUrlRenderer [hamlet|^{pageBody rows}|]
