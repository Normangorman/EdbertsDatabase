module Handler.NewPerson where

import Import

getNewPersonR :: Handler Html 
getNewPersonR = defaultLayout $ do
    addStylesheet $ StaticR css_datepicker_css 
    addScript $ StaticR js_datepicker_js
    $(widgetFile "new-person")

postNewPersonR :: Handler ()
postNewPersonR = do
    person <- runInputPost $ Person
        <$> ireq textField "First name"
        <*> ireq textField "Last name"
        <*> iopt dayField   "Birthday"      
        <*> iopt textField  "Home number"  
        <*> iopt textField  "Mobile number"
        <*> iopt emailField "Email address"
        <*> iopt textField  "Gender"      
    personId <- runDB $ insert person
    setMessage "Person succesfully created!"
    redirect $ PersonR personId
