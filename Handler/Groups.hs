module Handler.Groups where

import Import
import Handler.QueryUtils (fromMaybe)
import Database.Persist.Sql (rawSql)
import qualified Data.Text as T

getGroupsR :: Handler Html
getGroupsR = do
    groups <- runDB $ selectList [] [Asc PGroupName]
    let groupsTableRows = mkGroupRows groups
    defaultLayout $ do
        --query builder plugin
        addStylesheet $ StaticR css_query_builder_min_css
        addScript     $ StaticR js_query_builder_min_js
        --table sorter plugin
        addScript     $ StaticR js_stupidtable_min_js
        --time picker plugin
        addStylesheet $ StaticR css_clockpicker_min_css
        addScript $ StaticR js_clockpicker_min_js
        
        --this hamlet interpolates the peopleRows widget
        $(widgetFile "query-builder")
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



