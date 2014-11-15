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
    pGroup <- runInputPost $ PGroup
        <$> ireq textField "name"
        <*> ireq textField "project"
        <*> iopt textField "meets_on_day"  
        <*> iopt timeField "meets_at_time"
    pGroupId <- runDB $ insert pGroup
    setMessage "Group succesfully created!"
    redirect GroupsR
