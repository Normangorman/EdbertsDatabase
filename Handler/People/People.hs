module Handler.People.People where

import Import
import Handler.Plugins
--import Handler.Utils (fromMaybe)
import Handler.People.PersonUtils (mkPeopleRows)
import Database.Persist.Sql (rawSql)
import qualified Data.Text as T

getPeopleR :: Handler Html
getPeopleR = do
    people <- runDB $ selectList [] [Asc PersonFirstName, Asc PersonLastName]
    defaultLayout $ peoplePageWidget people

peoplePageWidget :: [Entity Person] -> Widget
peoplePageWidget people = do
    --this widget is interpolated in the hamlet file
    let peopleTableRows = mkPeopleRows people
    queryBuilderWidget
    tableSorterWidget
    datePickerWidget

    $(widgetFile "People/people")

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
