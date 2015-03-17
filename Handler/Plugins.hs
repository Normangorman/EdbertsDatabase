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
    format: 'dd/mm/yyyy',
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

-- Convert english dd/mm/yyyy formated 'Birthday' input field into the server-desired international format
-- which is yyyy/mm/dd. Takes a jQuery identifier to locate the form.
dateValidationWidget :: Text -> Widget
dateValidationWidget formId = do
    let jsonFormId = toJSON formId
    toWidget [julius|
// Change the english-formatted dd/mm/yyyy date to the yyyy/mm/dd form that will be used on the server.
$(#{jsonFormId}).on('submit', function(event) {
    console.log("changing date format from english to international...");
    var oldBirthdayString = $("input[name=Birthday]").val();
    console.log("old: ", oldBirthdayString);

    if (oldBirthdayString.length > 0) {
        var birthdayComponents = oldBirthdayString.split('/');

        // As a safety measure, if the date is already in the server desired international format
        // then don't change it. This is known if the length of the first component is 4 (i.e. it's a year).
        if (birthdayComponents.length === 3 && !(birthdayComponents[0].length === 4)) {
            var day = birthdayComponents[0];
            var month = birthdayComponents[1];
            var year = birthdayComponents[2];

            var newBirthdayString = year + '/' + month + '/' + day
            $("input[name=Birthday]").val(newBirthdayString);
            console.log("new: ", newBirthdayString);
        }
        else {
            console.log("Birthday was invalid so it was not changed");
        }
    }
});
    |]
