module Handler.Utils where

import Import
import qualified Data.Text as T
import Data.Time.Calendar (Day, toGregorian)
import Data.Time.LocalTime (TimeOfDay)
import Model (prettyGregorian)


class FromMaybe a where
    fromMaybe :: Show a => Maybe a -> String
    fromMaybe (Just a) = show a
    fromMaybe Nothing  = ""

instance FromMaybe String where
    fromMaybe (Just s) = s
    fromMaybe Nothing = ""

instance FromMaybe Text where
    fromMaybe (Just t) = T.unpack t
    fromMaybe Nothing = ""

instance FromMaybe Day where
    fromMaybe (Just d) = prettyGregorian . toGregorian $ d
    fromMaybe Nothing = ""

instance FromMaybe Integer
instance FromMaybe TimeOfDay

class (PersistEntity a, PersistEntity b) => Related a b where
    relations :: Key a -> Handler [Entity b]

jsonKeys :: PersistEntity a => [Entity a] -> Value
jsonKeys ents = toJSON $ map (\(Entity key _) -> key) ents
