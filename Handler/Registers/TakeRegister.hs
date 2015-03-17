module Handler.Registers.TakeRegister where

import Import
import Handler.Plugins
import Database.Persist.Sql (fromSqlKey)
import Handler.Utils
import Handler.People.PersonUtils (personWholeName) -- and the instances of Related 
import Data.Time.Clock (getCurrentTime, utctDay)
import Data.Maybe (fromJust)
import qualified Data.Text as T
import Data.List ((\\), sortBy, elemIndex)

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

toSimple :: Entity Person -> Handler SimplePerson
toSimple (Entity pid person) = do
    groups <- relations pid
    let gids = map (\(Entity gid _) -> gid) groups
    return $ SP gids pid (personWholeName person)

getSimplePerson :: PersonId -> Handler SimplePerson
getSimplePerson pid = do
    --this is done so that the toSimple function can be used for this
    --as well as getAllSimplePeople - which has to use selectList
    [personEntity] <- runDB $ selectList [PersonId ==. pid] []
    toSimple personEntity

getAllSimplePeople :: Handler [SimplePerson]
getAllSimplePeople = do
    people <- allPeople
    mapM toSimple people 

getTakeRegisterR :: Handler Html
getTakeRegisterR = do
    unsortedGroups <- allGroups
    -- Sort the groups in terms of the day they meet on, starting from monday to sunday.
    let groups = sortBy groupDaySorterFunc unsortedGroups
    
    people <- getAllSimplePeople
    let jsonPeople = toJSON people
    
    defaultLayout $ do
        chosenWidget 
        $(widgetFile "Registers/take-register")

    where
        groupDaySorterFunc :: Entity PGroup -> Entity PGroup -> Ordering
        groupDaySorterFunc (Entity _ group1) (Entity _ group2) = 
            let
                groupMeetingDay group = case pGroupMeetsOnDay group of
                                            Just d  -> d 
                                            Nothing -> "" 
                days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday", ""]
                dayIndex group =  case elemIndex (groupMeetingDay group) days of
                                    Just x -> x
                                    Nothing -> 9 
            in case dayIndex group1 `compare` dayIndex group2 of
                EQ -> pGroupName group1 `compare` pGroupName group2
                x  -> x

postTakeRegisterR :: Handler () 
postTakeRegisterR = do
    maybeGroupId   <- lookupPostParam "group_id"
    --This param is a string of textual person ids seperated by commas
    maybeGroupPids <- lookupPostParam "group_pids"
    --An array of textual person ids
    peoplePresent  <- lookupPostParams "person_present"

    if maybeGroupId   == Nothing || maybeGroupId == Just "" ||
       maybeGroupPids == Nothing || maybeGroupPids == Just ""
        then do
            setMessage "Register creation unsuccessful, something went wrong. Perhaps you tried to register a group which has no members?"
            redirect TakeRegisterR
        else do
            let groupId   = fromJust maybeGroupId
            let groupPids = fromJust maybeGroupPids

            --Calculate people_not_present by comparing groupPids with people_present
            let peopleNotPresent = (T.splitOn "," groupPids) \\ peoplePresent

            --Calculate the params needed to make a Register
            date <- liftIO $ getCurrentTime >>= return . utctDay
            let gid            = textToSqlKey groupId
            let presentPids    = map textToSqlKey peoplePresent
            let notPresentPids = map textToSqlKey peopleNotPresent

            rid <- runDB $ do
                --Avoid duplicate registers for the same day
                deleteWhere [RegisterDate ==. date, RegisterGroup ==. gid]
                insert (Register date gid presentPids notPresentPids)

            redirect $ ViewRegisterR rid

postQuickAddPersonToGroupR :: Handler Value
postQuickAddPersonToGroupR = do
    Just textPid <- lookupPostParam "pid"
    Just textGid <- lookupPostParam "gid"
    
    let pid = textToSqlKey textPid
    let gid = textToSqlKey textGid

    runDB $ do
        --avoid duplicates
        deleteWhere [PersonGroupRelationPerson ==. pid,
                     PersonGroupRelationGroup  ==. gid]
        insert_ $ PersonGroupRelation pid gid
    
    editedPerson <- getSimplePerson pid
    return $ toJSON editedPerson

postQuickCreatePersonR :: Handler Value
postQuickCreatePersonR = do
    Just firstName <- lookupPostParam "first_name"
    Just lastName  <- lookupPostParam "last_name"
    Just textGid   <- lookupPostParam "gid"
    
    let gid = textToSqlKey textGid

    pid <- runDB $ do
        pid <- insert $ Person firstName lastName Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing
        insert_ $ PersonGroupRelation pid gid
        return pid
        
    newPerson <- getSimplePerson pid
    return $ toJSON newPerson
