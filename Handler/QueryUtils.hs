module Handler.QueryUtils where

import Import
import qualified Data.Text as T
import Data.Time.Calendar (Day, toGregorian)
import Model (prettyGregorian)

mkPeopleRows :: [Entity Person] -> Widget
mkPeopleRows people = do
    [whamlet|
        $forall Entity pkey person <- people 
          <tr>
            <td><a href=@{PersonR pkey}>#{personFirstName person}
            <td>#{personLastName person}
            <td>#{fromMaybe $ personBirthday person}
            <td>#{fromMaybe $ personHomeNumber person}
            <td>#{fromMaybe $ personMobileNumber person}
            <td>#{fromMaybe $ personEmailAddress person}
            <td>#{fromMaybe $ personGender person}
            <td>#{fromMaybe $ personNationality person}
    |]

class FromMaybe a where
    fromMaybe :: Maybe a -> String

instance FromMaybe String where
    fromMaybe (Just s) = s
    fromMaybe Nothing = ""

instance FromMaybe Text where
    fromMaybe (Just t) = T.unpack t
    fromMaybe Nothing = ""

instance FromMaybe Day where
    fromMaybe (Just d) = prettyGregorian . toGregorian $ d
    fromMaybe Nothing = ""
