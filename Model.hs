{-# LANGUAGE UndecidableInstances #-}
module Model where

import Yesod
import Data.Text (Text)
import Database.Persist.Quasi
import Data.Time.LocalTime (TimeOfDay)
import Data.Typeable (Typeable)
import Prelude
import Data.Time.Calendar --used for storing birthdays
import Text.Blaze

instance ToMarkup Day where
    toMarkup = toMarkup . prettyGregorian . toGregorian

prettyGregorian :: (Integer, Int, Int) -> String
prettyGregorian (year, month, day) =
    --for a day to be correctly parsed as a day field, both the month and day must be two characters long.
    let prettyYear = show year
        prettyMonth
            | month < 10 = '0' : show month
            | otherwise  = show month
        prettyDay
            | day < 10   = '0' : show day
            | otherwise  = show day
    in prettyYear ++ "/" ++ prettyMonth ++ "/" ++ prettyDay

-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/
share [mkPersist sqlSettings, mkMigrate "migrateAll"]
    $(persistFileWith lowerCaseSettings "config/models")
