module Handler.NewPerson where

import Import

getNewPersonR :: Handler Html 
getNewPersonR = defaultLayout $ do
    addStylesheet $ StaticR css_datepicker_css 
    addScript $ StaticR js_datepicker_js
    $(widgetFile "new-person")
    -- some javascript to set the default datepicker options
    $(widgetFile "datepicker")
    

postNewPersonR :: Handler ()
postNewPersonR = do
    person <- runInputPost $ Person
        <$> ireq textField "First name"
        <*> ireq textField "Last name"
        <*> iopt dayField  "Birthday"      
        <*> iopt textField "Home number"  
        <*> iopt textField "Mobile number"
        <*> iopt textField "Email address"
        <*> iopt textField "Gender"      
        <*> iopt textField "Nationality"
    personId <- runDB $ insert person
    setMessage "Person succesfully created!"
    redirect $ PersonR personId
