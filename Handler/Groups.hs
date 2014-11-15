module Handler.Groups where

import Import
import Handler.QueryUtils (fromMaybe)
import Database.Persist.Sql (rawSql)
import qualified Data.Text as T

getGroupsR :: Handler Html
getGroupsR = do
    groups <- runDB $ selectList [] [Asc GroupName]
    let groupsTableRows = mkGroupRows groups
    defaultLayout $ do
        --query builder plugin
        addStylesheet $ StaticR css_query_builder_min_css
        addScript     $ StaticR js_query_builder_min_js
        --table sorter plugin
        addScript     $ StaticR js_stupidtable_min_js
        
        --this hamlet interpolates the peopleRows widget
        $(widgetFile "query-builder")
        $(widgetFile "groups")


mkGroupRows :: [Entity Group] -> Widget
mkGroupRows groups = do
    [whamlet|
        $forall Entity gkey group <- groups 
          <tr>
            <td>#{groupName group}
            <td>#{groupProject group}
            <td>#{fromMaybe $ groupMeetsOnDay group}
            <td>#{fromMaybe $ groupMeetsAtTime group}
    |]

postGroupsR :: Handler Html
postGroupsR = do
    maybeQuery <- lookupPostParam "query"
    case maybeQuery of
        Nothing -> do
            withUrlRenderer [hamlet|No query given...|]
        Just sql -> do 
            let sqlToRun = "SELECT ?? FROM group WHERE (" `T.append` sql `T.append` ") "
            groups <- runDB $ rawSql sqlToRun []
            rows <- widgetToPageContent $ mkGroupRows groups
            withUrlRenderer [hamlet|^{pageBody rows}|]



