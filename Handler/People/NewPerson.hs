module Handler.People.NewPerson where

import Import
import Handler.Plugins

getNewPersonR :: Handler Html 
getNewPersonR = defaultLayout $ do
    datePickerWidget
    -- Client side dates are in english format. This widget converts them to international format.
    dateValidationWidget "#new_person_form" "Birthday"
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
        <*> iopt textField "Emergency contact"
        <*> iopt textField "Other information"
        <*> iopt textField "Project"
    personId <- runDB $ insert person
    setMessage "Person successfully created!"
    redirect $ PersonR personId
