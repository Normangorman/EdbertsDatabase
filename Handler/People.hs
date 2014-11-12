module Handler.People where

import Import
-- import Yesod.Request

getPeopleR :: Handler Html
getPeopleR = do
    defaultLayout $ do
        --this hamlet interpolates the peopleRows widget
        $(widgetFile "people")

fromMaybe :: Show a => Maybe a -> String
fromMaybe Nothing  = ""
fromMaybe (Just a) = show a

peopleRows :: Widget
peopleRows = do
    people <- handlerToWidget $ runDB $ selectList [] [Asc PersonFirstName, Asc PersonLastName]
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

postPeopleR :: Handler ()
postPeopleR = do
    query <- runInputPost $ ireq textField "quick_search_query"
    setMessage (toHtml query)
    redirect HomeR
