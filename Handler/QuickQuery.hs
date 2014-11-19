module Handler.QuickQuery where

import Import
import Handler.People (peoplePageWidget)


-- used for a quick search by first name
getQuickQueryR :: Handler Html
getQuickQueryR = do
    mquery <- lookupGetParam "query"
    case mquery of 
        Nothing -> do
            setMessage "You didn't enter a query!"
            redirect HomeR
        Just q -> do
            people <- runDB $ selectList [PersonFirstName ==. q] [Asc PersonFirstName, Asc PersonLastName]
            defaultLayout $ peoplePageWidget people
