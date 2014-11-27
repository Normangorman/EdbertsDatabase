module Handler.Plugins where

import Import

clockPickerWidget :: Widget
clockPickerWidget = do
    addStylesheet $ StaticR css_clockpicker_min_css
    addScript     $ StaticR js_clockpicker_min_js
    toWidget [julius|
$(".clockpicker").clockpicker({ autoclose: true });
    |]

datePickerWidget :: Widget
datePickerWidget = do
    addStylesheet $ StaticR css_datepicker_css 
    addScript     $ StaticR js_datepicker_js
    toWidget [julius|
$(".datepicker").datepicker({
    format: 'yyyy/mm/dd',
    autoclose: true
});
    |]

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

chosenWidget :: Widget
chosenWidget = do
    addScript $ StaticR js_chosen_jquery_min_js
    addStylesheet $ StaticR css_chosen_css
    addStylesheet $ StaticR css_chosen_bootstrap_css
    toWidget [julius|
$(".chosen_select").chosen({
    disable_search_threshold: 10,
    display_disabled_options: false,
    no_results_text: "Oops, nothing found!"
});

function chosenPreselect(items, inputDivId) {
    if (items != []) {
        //Loop through each item and select its respective option div,
        //using the "value" property of the div to locate it 
        for (var i=0; i < items.length; i++) {
            var id = items[i];
            $(inputDivId + " option")
              .filter('[value="' + id + '"]')
              .prop('selected', true); 
        };

        //Update the Chosen input box to account for the changes
        $(inputDivId).trigger('chosen:updated'); 
    }
};
    |]

chartsWidget :: Widget
chartsWidget = do
    addScript $ StaticR js_Chart_js

randomColorWidget :: Widget
randomColorWidget = do
    addScript $ StaticR js_randomColor_js
    
    
