module Handler.Registers.EditRegister where

import Import
import Handler.Utils
import Handler.Plugins
import Handler.Registers.ViewRegister (getRegisterPeople)
import Database.Persist.Sql (fromSqlKey)
import qualified Data.Text as T
import Data.List((\\))
import Data.Text (split)
import qualified Data.Time.Format as DTF
import Handler.Groups.Group

getEditRegisterR :: RegisterId -> Handler Html
getEditRegisterR rid = do
    maybeReg <- runDB $ get rid
    case maybeReg of
        Nothing -> do
            setMessage "No register found with that ID."
            redirect HomeR
        Just reg -> do
            groupEntity <- runDB $ get (registerGroup reg)
            let groupName = case groupEntity of 
                                Just group ->  pGroupName group 
                                Nothing -> ""
            
            peoplePresent    <- getRegisterPeople (registerPeoplePresent    reg)

            groupPeople <- relations (registerGroup reg) :: Handler [Entity Person]
            let peopleNotPresent = groupPeople \\ peoplePresent

            defaultLayout $ do
                datePickerWidget
                dateValidationWidget "#edit_register_form" "Date"
                $(widgetFile "Registers/edit-register")

postEditRegisterR :: RegisterId -> Handler Html
postEditRegisterR rid = do
    maybeReg <- runDB $ get rid
    case maybeReg of
        Nothing -> do
            setMessage "No register with that ID!"
            redirect HomeR
        Just reg -> do
            maybeDate <- lookupPostParam "Date"
            let newDate = case maybeDate of
                            Nothing -> registerDate reg
                            Just dateString -> case DTF.parseTime DTF.defaultTimeLocale "%Y/%m/%d" (T.unpack dateString) of
                                Nothing -> registerDate reg
                                Just date -> date

            --liftIO $ putStrLn $ "Got date: " ++ fromMaybe maybeDate
                
            groupPeople <- relations (registerGroup reg) :: Handler [Entity Person]
            let groupPids = map (\(Entity pid _) -> T.pack . show . fromSqlKey $ pid) groupPeople :: [Text]

            --An array of textual person ids
            peoplePresent  <- lookupPostParams "person_present"
            let peopleNotPresent = groupPids \\ peoplePresent

            let presentPids    = map textToSqlKey peoplePresent
            let notPresentPids = map textToSqlKey peopleNotPresent

            runDB $ replace rid (Register newDate (registerGroup reg) presentPids notPresentPids)

            setMessage "Register successfully edited."
            redirect (ViewRegisterR rid)
