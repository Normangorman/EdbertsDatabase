module Handler.Registers.Register where

import Import
import Handler.Plugins
import Database.Persist.Sql (toSqlKey, fromSqlKey)
import Handler.Utils
import Handler.People.PersonUtils (personWholeName) -- and the instances of Related 
import Data.Time.Clock (getCurrentTime, utctDay)
import Data.Text.Read (decimal)
import Data.Maybe (fromJust)

--A lightweight person representation used for displaying results in a register.
--This will be converted to a JSON object with two properties.
data SimplePerson = SP {
    --If a person is in multiple groups then this record will be duplicated. That is ok.
    spGids :: [PGroupId],
    spId   :: PersonId,
    spName :: Text
    }

instance ToJSON SimplePerson where
    toJSON (SP gids pid name) =
        object ["gids" .= gids,
                "pid"  .= pid,
                "name" .= name] 

getRegisterR :: Handler Html
getRegisterR = do
    allGroups <- runDB $ selectList [] [] :: Handler [Entity PGroup]
    allPeople <- getAllSimplePeople
    let jsonPeople = toJSON allPeople
    
    defaultLayout $ do
        chosenWidget 
        $(widgetFile "Registers/register")

getAllSimplePeople :: Handler [SimplePerson]
getAllSimplePeople = do
    allPeople <- runDB $ selectList [] []
    mapM toSimple allPeople 
    
    where toSimple :: Entity Person -> Handler SimplePerson
          toSimple (Entity pid person) = do
            groups <- relations pid
            let gids = map (\(Entity gid _) -> gid) groups
            return $ SP gids pid (personWholeName person)

postRegisterR :: Handler () 
postRegisterR = do
    groupId       <- lookupPostParam "group_id"
    peoplePresent <- lookupPostParams "person_present" -- an array of textual person ids

    if groupId /= Nothing && peoplePresent /= []
        then do
            date <- liftIO $ getCurrentTime >>= return . utctDay
            let gid  = toSqlKey $ unsafeDecimal (fromJust groupId)
            let pids = map (toSqlKey . unsafeDecimal) peoplePresent

            runDB $ insert_ (Register date gid pids)
            redirect $ GroupR gid
        else do
            setMessage "Register creation unsuccessful, something went wrong."
            redirect RegisterR
    
    where unsafeDecimal = (\(Right (x, _)) -> x) . decimal

