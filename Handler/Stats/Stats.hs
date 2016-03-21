module Handler.Stats.Stats where

import Import
import Handler.Plugins
import Handler.Utils
import Data.List (nub)
import qualified Data.Text as T
import Handler.People.PersonUtils (getPersonAge)
import Data.List (sort)
import Data.Time.Calendar (Day, toGregorian)

getStatsR :: Handler Html
getStatsR = do
    defaultLayout $ do
        datePickerWidget
        chartsWidget
        randomColorWidget
        $(widgetFile "Stats/stats")

getStatsDataR :: Handler Value
getStatsDataR = do
    maybeChartName <- lookupGetParam "chartName"

    case maybeChartName of
        Just "nationalities" -> peopleNationalitiesHandler
        Just "ages"          -> peopleAgesHandler
        Just "totalFootfall" -> totalFootfallHandler
        Just "footfallByAge" -> footfallByAgeHandler
        
        Just x  -> error $ "getStatsDataR: option unrecognized: " ++ (T.unpack x) 
        Nothing -> error "getStatsDataR: no 'chart_name' parameter passed"

fromEntity :: Entity a -> a
fromEntity (Entity _ a) = a
        
getStatsNumbersR :: Day -> Day -> Handler Value
getStatsNumbersR startDay endDay = do
    registersWithinRange <- runDB $ selectList [RegisterDate >=. startDay, RegisterDate <=. endDay] []
    let registerPeople = foldl (++) [] $ fmap (registerPeoplePresent . fromEntity) registersWithinRange
    let totalPeople = length registerPeople
    let totalUniquePeople = (length . nub) registerPeople
    return (toJSON (totalPeople, totalUniquePeople))

countList :: (a -> Bool) -> [a] -> Int
countList _ []     = 0
countList f (x:xs) = if f x then 1 else 0 + countList f xs

--Data handlers
data NationalityInfo = NatInf Text Int
instance ToJSON NationalityInfo where
    toJSON (NatInf n q) = object ["nationality" .= n, "quantity" .= q]

peopleNationalitiesHandler :: Handler Value
peopleNationalitiesHandler = do
    let allNats = [ "White British", "White other",
                    "Asian", "Black Caribbean",
                    "Black African", "Black other",
                    "Chinese", "Other"]

    fmap toJSON $ mapM getNatInf allNats

    where getNatInf n = runDB $ do
            q <- count [PersonNationality ==. Just n]
            return $ NatInf n q

data AgeInfo = AgeInf (Int, Int) Int
instance ToJSON AgeInfo where
    toJSON (AgeInf (l, u) q) =
        let ageGroup = show l ++ "-" ++ show u
        in  object ["ageGroup" .= ageGroup, "quantity" .= q]

peopleAgesHandler :: Handler Value
peopleAgesHandler = do
    let ageGroups = [(0,5), (6,12), (13,19), (20,39), (40,60), (60,100)]
    peopleEntities <- allPeople

    let people = map fromEntity peopleEntities
    info <- liftIO $ mapM (getAgeInf people) ageGroups :: Handler [AgeInfo]

    return (toJSON info)

    where
        getAgeInf :: [Person] -> (Int, Int) -> IO AgeInfo
        getAgeInf ps bounds = do
            total <- fmap (length . filter (\p -> p == True)) $ mapM (personAgeInRange bounds) ps
            return (AgeInf bounds total)

        personAgeInRange :: (Int, Int) -> Person -> IO Bool
        personAgeInRange (lower, upper) p = do
            maybeAge <- getPersonAge p
            case maybeAge of
                Nothing -> return False
                Just x  -> return (x >= lower && x <= upper)

data RegInfo = RegInf Day Int
instance ToJSON RegInfo where
    toJSON (RegInf date q) =
        let (y, m, d) = toGregorian date
            dayString = show y ++ "/" ++ show m ++ "/" ++ show d
        in object ["date" .= dayString, "quantity" .= q]
        
totalFootfallHandler :: Handler Value
totalFootfallHandler = do
    rs <- fmap (map fromEntity) allRegisters
    
    let allDates = sort $ map registerDate rs

    fmap toJSON $ mapM (getRegInf rs) allDates
    where
        getRegInf :: [Register] -> Day -> Handler RegInfo
        getRegInf rs d = return $ RegInf d (sum $ map (countAttendance d) rs)
        
        countAttendance d r
            | registerDate r == d = length (registerPeoplePresent r)
            | otherwise = 0

footfallByAgeHandler :: Handler Value
footfallByAgeHandler = return $ object ["foo" .= ("bar" :: String)]
