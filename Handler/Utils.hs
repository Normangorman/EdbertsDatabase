module Handler.Utils where

import Import
import qualified Data.Text as T
import Data.Time.Calendar (Day, toGregorian)
import Data.Time.LocalTime (TimeOfDay)
import Model (prettyGregorian)
import Data.Text.Read (decimal)
import Data.Char(toUpper, toLower)
import Database.Persist.Sql (toSqlKey, SqlBackend)

capitalized :: String -> String
capitalized (head : tail) = toUpper head : map toLower tail
capitalized [] = []

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
    fromMaybe (Just d) = zeroPad day ++ "/" ++ zeroPad month ++ "/" ++ show year
                         where (year,month,day) = toGregorian d
                               zeroPad n = if n < 10 then '0' : show n else show n
    fromMaybe Nothing = ""

instance FromMaybe Integer
instance FromMaybe Int
instance FromMaybe TimeOfDay

class (PersistEntity a, PersistEntity b) => Related a b where
    relations :: Key a -> Handler [Entity b]

jsonKeys :: PersistEntity a => [Entity a] -> Value
jsonKeys ents = toJSON $ map (\(Entity key _) -> key) ents

textToSqlKey :: (ToBackendKey SqlBackend a, PersistEntity a) => Text -> Key a
textToSqlKey = toSqlKey . fromRight . decimal
    where fromRight (Right (x, _)) = x
          fromRight (Left _) = error "Handler.Utils.fromRight: got a Left"

allRegisters :: Handler [Entity Register]
allRegisters = runDB $ selectList [] [] :: Handler [Entity Register]

allPeople :: Handler [Entity Person]
allPeople = runDB $ selectList [] [] :: Handler [Entity Person]

allGroups :: Handler [Entity PGroup]
allGroups = runDB $ selectList [] [] :: Handler [Entity PGroup]

allQuals :: Handler [Entity Qual]
allQuals =  runDB $ selectList [] [] :: Handler [Entity Qual]
