module Handler.EditPerson where

import Import
import Handler.QueryUtils (fromMaybe)
import Text.Julius (rawJS)

getEditPersonR :: PersonId -> Handler Html
getEditPersonR pid = do
    maybePerson <- runDB $ get pid
    case maybePerson of 
        Nothing -> do
            setMessage "No person found with that ID."
            redirect HomeR
        Just person -> do
            let gender = (rawJS . fromMaybe . personGender) person
            let nationality = (rawJS . fromMaybe . personNationality) person
            defaultLayout $ do
                addStylesheet $ StaticR css_datepicker_css 
                addScript $ StaticR js_datepicker_js
                $(widgetFile "edit-person") 
                -- some javascript to set the default datepicker options
                $(widgetFile "datepicker")

postEditPersonR :: PersonId -> Handler Html
postEditPersonR pid = do
    editedPerson <- runInputPost $ Person
        <$> ireq textField "First name"
        <*> ireq textField "Last name"
        <*> iopt dayField  "Birthday"      
        <*> iopt textField "Home number"  
        <*> iopt textField "Mobile number"
        <*> iopt textField "Email address"
        <*> iopt textField "Gender"      
        <*> iopt textField "Nationality"
    runDB $ replace pid editedPerson
    setMessage "Person succesfully edited."
    redirect (PersonR pid)

