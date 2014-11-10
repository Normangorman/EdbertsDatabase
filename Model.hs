module Model where

import Yesod
import Data.Text (Text)
import Database.Persist.Quasi
import Data.Typeable (Typeable)
import Prelude
import Data.Time.Calendar --used for storing birthdays
import Text.Blaze

instance ToMarkup Day where
    toMarkup = toMarkup . prettyGregorian . toGregorian

prettyGregorian :: (Integer, Int, Int) -> String
prettyGregorian (year, month, day) =
    show day ++ "/" ++ show month ++ "/" ++ show year

-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/
share [mkPersist sqlSettings, mkMigrate "migrateAll"]
    $(persistFileWith lowerCaseSettings "config/models")
