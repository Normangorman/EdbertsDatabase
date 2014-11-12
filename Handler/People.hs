module Handler.People where

import Import
import Handler.Query (mkTableRows)
-- import Yesod.Request

getPeopleR :: Handler Html
getPeopleR = do
    people <- runDB $ selectList [] [Asc PersonFirstName, Asc PersonLastName]
    let peopleTableRows = mkTableRows people
    defaultLayout $ do
        addStylesheet $ StaticR css_query_builder_min_css
        addScript     $ StaticR js_query_builder_min_js
        --this hamlet interpolates the peopleRows widget
        $(widgetFile "people")



-- postPeopleR :: Handler ()
postPeopleR = do
    query <- runInputPost $ ireq textField "quick_search_query"
    people <- runDB $ selectList [PersonFirstName ==. "Polly"] [Asc PersonFirstName, Asc PersonLastName]
    defaultLayout $ do
        mkTableRows people

