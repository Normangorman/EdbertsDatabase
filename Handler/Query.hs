module Handler.Query where

import Import

postQueryR :: Handler Html
postQueryR = do
    people <- runDB $ selectList [] [Asc PersonFirstName]
    rows <- widgetToPageContent $ mkTableRows people
    withUrlRenderer [hamlet|^{pageBody rows}|]

-- used for a quick search by first name
--getQueryR :: Handler ()
getQueryR = do
    mquery <- lookupGetParam "query"
    case mquery of 
        Nothing -> do
            setMessage "You didn't enter a query!"
            redirect HomeR
        Just q -> do
            people <- runDB $ selectList [PersonFirstName ==. q] [Asc PersonFirstName, Asc PersonLastName]
            let peopleTableRows = mkTableRows people
            defaultLayout $ do 
                $(widgetFile "people")
    
mkTableRows :: [Entity Person] -> Widget
mkTableRows people = do
    [whamlet|
        $forall Entity pkey person <- people 
          <tr>
            <td><a href=@{PersonR pkey}>#{personFirstName person}
            <td>#{personLastName person}
            <td>#{fromMaybe $ personBirthday person}
            <td>#{fromMaybe $ personHomeNumber person}
            <td>#{fromMaybe $ personMobileNumber person}
            <td>#{fromMaybe $ personEmailAddress person}
            <td>#{fromMaybe $ personGender person}
    |]

fromMaybe :: Show a => Maybe a -> String
fromMaybe Nothing  = ""
fromMaybe (Just a) = show a

