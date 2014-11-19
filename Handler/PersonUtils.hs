module Handler.PersonUtils where

import Import
import Handler.Utils (fromMaybe)
import Data.Time.Calendar (Day, diffDays)
import Data.Time.Clock (getCurrentTime, utctDay)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Text as T

personWholeName :: Person -> Text
personWholeName p = personFirstName p `T.append` " " `T.append` personLastName p

getPersonAge :: Person -> IO (Maybe Integer)
getPersonAge person = do 
    currentDay <- fmap utctDay getCurrentTime -- IO Day  (2014, 11, 14)
    return $ fmap (yearDifference currentDay) (personBirthday person)
    where
        yearDifference :: Day -> Day -> Integer
        yearDifference x = (`div` 365) . diffDays x

getPersonGroups :: PersonId -> Handler [Entity PGroup]
getPersonGroups pid = runDB $ do
    relations <- selectList [PersonGroupRelationPerson ==. pid] []
    let groupKeys = map groupKey relations

    selectList [PGroupId <-. groupKeys] []
    where groupKey (Entity _ r) = personGroupRelationGroup r

mkPeopleRows :: [Entity Person] -> Widget
mkPeopleRows people = do
    [whamlet|
        $forall Entity pkey person <- people 
          <tr>
            <td><a href=@{PersonR pkey}>#{personFirstName person}
            <td>#{personLastName person}
            <td>#{fromMaybe $ personBirthday person}
            <td>#{fromMaybe $ unsafePerformIO $ getPersonAge person}
            <td>#{fromMaybe $ personHomeNumber person}
            <td>#{fromMaybe $ personMobileNumber person}
            <td>#{fromMaybe $ personEmailAddress person}
            <td>#{fromMaybe $ personGender person}
            <td>#{fromMaybe $ personNationality person}
    |]
