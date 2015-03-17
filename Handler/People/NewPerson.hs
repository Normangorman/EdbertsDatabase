module Handler.People.NewPerson where

import Import
import Handler.Plugins

getNewPersonR :: Handler Html 
getNewPersonR = defaultLayout $ do
    datePickerWidget
    $(widgetFile "People/new-person")

postNewPersonR :: Handler ()
postNewPersonR = do
    person <- runInputPost $ Person
        <$> ireq textField "First name"
        <*> ireq textField "Last name"
        <*> iopt dayField  "Birthday"      
        <*> iopt textField "Home number"  
        <*> iopt textField "Home address"  
        <*> iopt textField "Mobile number"
        <*> iopt textField "Email address"
        <*> iopt textField "Gender"      
        <*> iopt textField "Nationality"
    personId <- runDB $ insert person
    setMessage "Person successfully created!"
    redirect $ PersonR personId
