module Handler.QuickQuery where

import Import
import Handler.People.People (peoplePageWidget)
import Handler.Utils (capitalized)
import qualified Data.Text as T

-- used for a quick search by first name
getQuickQueryR :: Handler Html
getQuickQueryR = do
    mquery <- lookupGetParam "query"
    case mquery of 
        Nothing -> do
            setMessage "You didn't enter a query!"
            redirect HomeR
        Just q -> do
            let personName = T.pack $ capitalized (T.unpack q)
            liftIO $ putStrLn $ "personName: " ++ T.unpack personName
            people <- runDB $ selectList [PersonFirstName ==. personName] [Asc PersonFirstName, Asc PersonLastName]
            defaultLayout $ peoplePageWidget people
