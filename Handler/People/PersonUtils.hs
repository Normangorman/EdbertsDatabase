module Handler.People.PersonUtils where

import Import
import Handler.Utils
import Data.Time.Calendar (Day, diffDays)
import Data.Time.Clock (getCurrentTime, utctDay)
import System.IO.Unsafe (unsafePerformIO)
import qualified Data.Text as T
import Data.Maybe (fromJust)

personWholeName :: Person -> Text
personWholeName p = personFirstName p `T.append` " " `T.append` personLastName p

getPersonAge :: Person -> IO (Maybe Int)
getPersonAge person = do 
    currentDay <- fmap utctDay getCurrentTime -- IO Day  (2014, 11, 14)
    return $ fmap (yearDifference currentDay) (personBirthday person)
    where
        yearDifference :: Day -> Day -> Int 
        yearDifference x = fromIntegral . (`div` 365) . diffDays x

instance Related Person PGroup where
    relations key = runDB $ do  
        rs <- selectList [PersonGroupRelationPerson ==. key] []
        let rKeys = map rKey rs
        selectList [PGroupId <-. rKeys] []
        where rKey (Entity _ r) = personGroupRelationGroup r

instance Related Person Qual where
    relations key = runDB $ do  
        rs <- selectList [PersonQualRelationPerson ==. key] []
        let rKeys = map rKey rs
        selectList [QualId <-. rKeys] []
        where rKey (Entity _ r) = personQualRelationQual r

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
            <td>#{fromMaybe $ personHomeAddress person}
            <td>#{fromMaybe $ personMobileNumber person}
            <td>#{fromMaybe $ personEmailAddress person}
            <td>#{fromMaybe $ personGender person}
            <td>#{fromMaybe $ personNationality person}
            <td>#{fromMaybe $ personEmergencyContact person}
            <td>#{fromMaybe $ personOtherInformation person}
            <td>#{fromMaybe $ personProject person}
    |]
