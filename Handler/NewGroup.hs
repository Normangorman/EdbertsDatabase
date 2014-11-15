module Handler.NewGroup where

import Import

getNewGroupR :: Handler Html
getNewGroupR = do
    defaultLayout $ do
        --JQuery clockpicker
        addStylesheet $ StaticR css_clockpicker_min_css
        addScript $ StaticR js_clockpicker_min_js
        $(widgetFile "new-group") 

postNewGroupR :: Handler ()
postNewGroupR = do
    group <- runInputPost $ Group
        <$> ireq textField "Name"
        <*> ireq textField "Project"
        <*> iopt textField "Meets on day"  
        <*> iopt timeField "Meets at time"
    groupId <- runDB $ insert group
    setMessage "Group succesfully created!"
    redirect HomeR --CHANGE THIS 
