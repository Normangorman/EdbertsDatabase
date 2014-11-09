module Handler.EditPerson where

import Import

getEditPersonR :: PersonId -> Handler Html
getEditPersonR _ = defaultLayout $ do
    addStylesheet $ StaticR css_datepicker_css 
    addScript $ StaticR js_datepicker_js
    $(widgetFile "edit-person") 

postEditPersonR :: PersonId -> Handler Html
postEditPersonR = error "Not yet implemented: postEditPersonR"
