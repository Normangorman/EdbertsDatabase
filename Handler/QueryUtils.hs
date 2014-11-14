module Handler.QueryUtils where

import Import
import qualified Data.Text as T
import Data.Time.Calendar (Day, toGregorian, diffDays)
import Data.Time.Clock (getCurrentTime, utctDay)
import System.IO.Unsafe (unsafePerformIO)
import Model (prettyGregorian)
--import Control.Monad.Trans.Class (lift)        

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

getPersonAge :: Person -> IO (Maybe Integer)
getPersonAge person = do 
    currentDay <- fmap utctDay getCurrentTime -- IO Day  (2014, 11, 14)
    return $ fmap (yearDifference currentDay) (personBirthday person)
    where
        yearDifference :: Day -> Day -> Integer
        yearDifference x = (`div` 365) . diffDays x

class FromMaybe a where
    fromMaybe :: Maybe a -> String

instance FromMaybe String where
    fromMaybe (Just s) = s
    fromMaybe Nothing = ""

instance FromMaybe Integer where
    fromMaybe (Just i) = show i
    fromMaybe Nothing  = ""

instance FromMaybe Text where
    fromMaybe (Just t) = T.unpack t
    fromMaybe Nothing = ""

instance FromMaybe Day where
    fromMaybe (Just d) = prettyGregorian . toGregorian $ d
    fromMaybe Nothing = ""
