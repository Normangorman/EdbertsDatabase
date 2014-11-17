module Handler.Plugins where

import Import

clockPickerWidget :: Widget
clockPickerWidget = do
    addStylesheet $ StaticR css_clockpicker_min_css
    addScript     $ StaticR js_clockpicker_min_js
    toWidget [julius|
        $(".clockpicker").clockpicker({ autoclose: true });|]

datePickerWidget :: Widget
datePickerWidget = do
    addStylesheet $ StaticR css_datepicker_css 
    addScript     $ StaticR js_datepicker_js
    toWidget [julius|
        $(".datepicker").datepicker({ format: 'yyyy/mm/dd' });|]

queryBuilderWidget :: Widget
queryBuilderWidget = do
    addStylesheet $ StaticR css_query_builder_min_css
    addScript     $ StaticR js_query_builder_min_js
    [whamlet|
<div .row> 
     <div #query_builder_heading .col-lg-2>
        <h3>Query Builder
        <button .btn .btn-primary .btn-block #query_builder_submit type=submit>
            <span .glyphicon .glyphicon-search>
            Submit query
    <div .col-lg-10>
        <div #query_builder>
    |]
    toWidget [lucius|
#query_builder_heading h3 {
    margin-bottom: 5px;
    text-align: center;
}
    |]
    

tableSorterWidget :: Widget
tableSorterWidget = do
    addScript     $ StaticR js_stupidtable_min_js
    toWidget [lucius|
.tablesorter thead tr > th {
    cursor: pointer;
}
    |]

selectMultipleWidget :: Widget
selectMultipleWidget = do
    addScript     $ StaticR js_selectmultiple_min_js 
    addStylesheet $ StaticR css_selectmultiple_min_css
    toWidget [julius|
$('.selectpicker').selectpicker({
    liveSearch: true
});
    |]

typeaheadWidget :: Widget
typeaheadWidget = do
    addScript $ StaticR js_typeahead_min_js
    $(widgetFile "typeahead") 
