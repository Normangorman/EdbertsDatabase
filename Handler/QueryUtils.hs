module Handler.QueryUtils where

import Import

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
    |]

fromMaybe :: Show a => Maybe a -> String
fromMaybe Nothing  = ""
fromMaybe (Just a) = show a


--    rows <- widgetToPageContent $ mkPeopleRows people
--    withUrlRenderer [hamlet|^{pageBody rows}|]
