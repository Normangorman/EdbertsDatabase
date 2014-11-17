module Handler.Groups where

import Import
import Handler.Plugins
import Handler.Utils
import Database.Persist.Sql (rawSql)
import qualified Data.Text as T

getGroupsR :: Handler Html
getGroupsR = do
    groups <- runDB $ selectList [] [Asc PGroupName]
    let groupsTableRows = mkGroupRows groups
    defaultLayout $ do
        queryBuilderWidget
        clockPickerWidget 
        tableSorterWidget 
        --this hamlet interpolates the peopleRows widget
        $(widgetFile "groups")


mkGroupRows :: [Entity PGroup] -> Widget
mkGroupRows pGroups = do
    [whamlet|
        $forall Entity key pGroup <- pGroups 
          <tr>
            <td><a href=@{GroupR key}>#{pGroupName pGroup}
            <td>#{pGroupProject pGroup}
            <td>#{fromMaybe $ pGroupMeetsOnDay pGroup}
            <td>#{fromMaybe $ pGroupMeetsAtTime pGroup}
    |]

postGroupsR :: Handler Html
postGroupsR = do
    maybeQuery <- lookupPostParam "query"
    case maybeQuery of
        Nothing -> do
            withUrlRenderer [hamlet|No query given...|]
        Just sql -> do 
            let sqlToRun = "SELECT ?? FROM p_group WHERE (" `T.append` sql `T.append` ") "
            pGroups <- runDB $ rawSql sqlToRun []
            rows <- widgetToPageContent $ mkGroupRows pGroups
            withUrlRenderer [hamlet|^{pageBody rows}|]



