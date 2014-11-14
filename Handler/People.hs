module Handler.People where

import Import
import Handler.QueryUtils
import Database.Persist.Sql (rawSql)
import qualified Data.Text as T
-- import Yesod.Request

getPeopleR :: Handler Html
getPeopleR = do
    people <- runDB $ selectList [] [Asc PersonFirstName, Asc PersonLastName]
    let peopleTableRows = mkPeopleRows people
    defaultLayout $ do
        --query builder plugin
        addStylesheet $ StaticR css_query_builder_min_css
        addScript     $ StaticR js_query_builder_min_js
        --table sorter plugin
        addScript     $ StaticR js_stupidtable_min_js
        
        --this hamlet interpolates the peopleRows widget
        $(widgetFile "query-builder")
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


