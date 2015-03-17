module Handler.Registers.ViewRegister where

import Import
import Handler.Utils
import Handler.People.PersonUtils (personWholeName)

getViewRegisterR :: RegisterId -> Handler Html
getViewRegisterR rid = do
    maybeRegister <- runDB $ get rid
    case maybeRegister of
        Just reg -> do
            let gid = registerGroup reg
            group <- runDB (get gid)

            peoplePresent    <- getRegisterPeople (registerPeoplePresent    reg)
            peopleNotPresent <- getRegisterPeople (registerPeopleNotPresent reg)

            defaultLayout $(widgetFile "Registers/view-register")
        Nothing  -> do
            setMessage "No register exists with that Id."
            redirect TakeRegisterR

deleteViewRegisterR :: RegisterId -> Handler ()
deleteViewRegisterR rid = runDB $ delete rid

getRegisterPeople :: [PersonId] -> Handler [Entity Person]
getRegisterPeople pids = runDB $ do
    selectList [PersonId <-. pids] [Asc PersonLastName, Asc PersonFirstName]
