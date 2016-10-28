<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="Locations.aspx.cs" Inherits="Locations" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .locationInfo input[type=text]{
            width:465px;
        }
    </style>


    <link rel="stylesheet" href="jqwidgets/styles/jqx.base.css" type="text/css" />
    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.columnsresize.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcombobox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdata.js"></script>     
    <script type="text/javascript" src="jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.filter.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.pager.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.selection.js"></script> 
    <script type="text/javascript" src="jqwidgets/jqxgrid.sort.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>    
    <script type="text/javascript" src="jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.edit.js"></script>
    
    <script type="text/javascript">

        var selectedLocationId = 0; //is set to the ID of the location that is selected from the main grid
        var thisNewLocation = false; //determines whether a new Location is being made so the feature grid doesn't get set 

        // ============= Initialize Page ==================== Begin
        $(document).ready(function () {

            //Loads main location grid
            loadLocationGrid();

            //#region SetupButtons
            $("#Save").jqxButton({ width: 120, height: 25 });
            $("#Cancel").jqxButton({ width: 120, height: 25 });
            $("#addFeature").jqxButton({ width: 120, height: 25 });
            $("#deleteFeature").jqxButton({ width: 120, height: 25 });
            $("#updateFeature").jqxButton({ width: 120, height: 25 });
            $("#cancelFeature").jqxButton({ width: 120, height: 25 });
            $("#btnShowFeatures").jqxButton({ width: 120, height: 25 });
            //#endregion

            //#region ButtonClick
            $("#Save").click(function () {
                // If LocationId is nothing then we are adding a new Location and we need a post
                if ($("#LocationId").val() == "") {
                    var newNameOfLocation = $("#NameOfLocation").val();
                    var newDisplayName = $("#DisplayName").val();
                    var newShortLocationName = $("#ShortLocationName").val();
                    var newFacilityNumber = $("#FacilityNumber").val();
                    var newSkiDataVersion = $("#SkiDataVersion").val();
                    var newSkiDataLocation = $("#SkiDataLocation").val();
                    var newLocationAddress = $("#LocationAddress").val();
                    var newLocationCity = $("#LocationCity").val();
                    var newLocationZipCode = $("#LocationZipCode").val();
                    var newLocationPhoneNumber = $("#LocationPhoneNumber").val();
                    var newLocationFaxNumber = $("#LocationFaxNumber").val();
                    var newCapacity = $("#Capacity").val();
                    var newDescription = $("#Description").val();
                    var newAlert = $("#Alert").val();
                    var newDailyRate = $("#DailyRate").val();
                    var newSlug = $("#Slug").val();
                    var newManager = $("#siteManager").val();
                    var newManagerEmail = $("#ManagerEmail").val();
                    var newLatitude = $("#Latitude").val();
                    var newLongitude = $("#Longitude").val();
                    var newGoogleLink = $("#GoogleLink").val();
                    var newIsActiveFlag = $("#IsActive").val();
                    var newSpecialFlagsText = $("#SpecialFlagsText").val();
                    var newSpecialFlagsInformation = $("#SpecialFlagsInformation").val();
                    var newManagerImageUrl = $("#ManagerImageUrl").val();
                    var newImageUrl = $("#ImageUrl").val();
                    var newEstimatedCharges = $("#EstimatedCharges").val();
                    var newEstimatedSavings = $("#EstimatedSavings").val();
                    var newBrandId = $("#brandCombo").jqxComboBox('getSelectedItem').value;
                    var newCityId = $("#cityCombo").jqxComboBox('getSelectedItem').value;
                    var newLocationStateId = $("#stateCombo").jqxComboBox('getSelectedItem').value;
                    var newDistanceFromAirport = $("#DistanceFromAirport").val();
                    var newAirportId = $("#airportCombo").jqxComboBox('getSelectedItem').value;;
                    var newRateQualifications = $("#RateQualifications").val();
                    var newRateText = $("#RateText").val();
                    var newMemberRateText = $("#MemberRateText").val();

                    var postUrl = $("#apiDomain").val() + "locations"

                    $.ajax({
                        headers: {
                            "Accept": "application/json",
                            "Content-Type": "application/json",
                            "AccessToken": $("#userGuid").val(),
                            "ApplicationKey": $("#AK").val()
                        },
                        url: PostUrl,
                        type: 'POST',
                        data: JSON.stringify({
                            "NameOfLocation": newNameOfLocation,
                            "DisplayName": newDisplayName,
                            "ShortLocationName": newShortLocationName,
                            "FacilityNumber": newFacilityNumber,
                            "SkiDataVersion": newSkiDataVersion,
                            "SkiDataLocation": newSkiDataLocation,
                            "LocationAddress": newLocationAddress,
                            "LocationCity": newLocationCity,
                            "BrandId": newBrandId,
                            "AirportId": newAirportId,
                            "Capacity": newCapacity,
                            "CityId": newCityId,
                            "LocationStateId": newLocationStateId,
                            "LocationZipCode": newLocationZipCode,
                            "LocationPhoneNumber": newLocationPhoneNumber,
                            "LocationFaxNumber": newLocationFaxNumber,
                            "Description": newDescription,
                            "Alert": newAlert,
                            "DailyRate": newDailyRate,
                            "Slug": newSlug,
                            "RateQualifications": newRateQualifications,
                            "Manager": newManager,
                            "ManagerEmail": newManagerEmail,
                            "RateText": newRateText,
                            "DistanceFromAirport": newDistanceFromAirport,
                            "Latitude": newLatitude,
                            "Longitude": newLongitude,
                            "SpecialFlagsText": newSpecialFlagsText,
                            "SpecialFlagsInformation": newSpecialFlagsInformation,
                            "GoogleLink": newGoogleLink,
                            "IsActiveFlag": newIsActiveFlag,
                            "ManagerImageUrl": newManagerImageUrl,
                            "MemberRateText": newMemberRateText,
                            "ImageUrl": newImageUrl
                        }),
                        success: function (response) {
                            alert("Saved!");
                            $("#popupLocation").jqxWindow('hide');
                            //refresh the main grid
                            loadLocationGrid();
                        },
                        error: function (jqXHR, textStatus, errorThrown, data) {
                            alert(textStatus); alert(errorThrown);
                        }
                    });
                    
                    //update main grid
                    loadLocationGrid();

                } else {
                    //if edit row is greater than zero then a row has been selected and we are updating a location
                    if (editrow >= 0) {

                        var newNameOfLocation = $("#NameOfLocation").val();
                        var newDisplayName = $("#DisplayName").val();
                        var newShortLocationName = $("#ShortLocationName").val();
                        var newFacilityNumber = $("#FacilityNumber").val();
                        var newSkiDataVersion = $("#SkiDataVersion").val();
                        var newSkiDataLocation = $("#SkiDataLocation").val();
                        var newLocationAddress = $("#LocationAddress").val();
                        var newLocationCity = $("#LocationCity").val();
                        var newLocationZipCode = $("#LocationZipCode").val();
                        var newLocationPhoneNumber = $("#LocationPhoneNumber").val();
                        var newLocationFaxNumber = $("#LocationFaxNumber").val();
                        var newCapacity = $("#Capacity").val();
                        var newDescription = $("#Description").val();
                        var newAlert = $("#Alert").val();
                        var newDailyRate = $("#DailyRate").val();
                        var newSlug = $("#Slug").val();
                        var newQualifications = $("#Qualifications").val();
                        var newManager = $("#siteManager").val();
                        var newManagerEmail = $("#ManagerEmail").val();
                        var newLatitude = $("#Latitude").val();
                        var newLongitude = $("#Longitude").val();
                        var newGoogleLink = $("#GoogleLink").val();
                        var newIsActiveFlag = $("#IsActive").val();
                        var newSpecialFlagsText = $("#SpecialFlagsText").val();
                        var newSpecialFlagsInformation = $("#SpecialFlagsInformation").val();
                        var newManagerImageUrl = $("#ManagerImageUrl").val();
                        var newImageUrl = $("#ImageUrl").val();
                        var newEstimatedCharges = $("#EstimatedCharges").val();
                        var newEstimatedSavings = $("#EstimatedSavings").val();
                        var newBrandId = $("#brandCombo").jqxComboBox('getSelectedItem').value;
                        var newCityId = $("#cityCombo").jqxComboBox('getSelectedItem').value;
                        var newLocationStateId = $("#stateCombo").jqxComboBox('getSelectedItem').value;
                        var newDistanceFromAirport = $("#DistanceFromAirport").val();
                        var newAirportId = $("#airportCombo").jqxComboBox('getSelectedItem').value;;
                        var newRateQualifications = $("#RateQualifications").val();
                        var newRateText = $("#RateText").val();
                        var newMemberRateText = $("#MemberRateText").val();

                        var putUrl = $("#apiDomain").val() + "locations/" + selectedLocationId //ID of the location to update

                        $.ajax({
                            headers: {
                                "Accept": "application/json",
                                "Content-Type": "application/json",
                                "AccessToken": $("#userGuid").val(),
                                "ApplicationKey": $("#AK").val()
                            },
                            url: putUrl,
                            type: 'PUT',
                            data: JSON.stringify({
                                "NameOfLocation": newNameOfLocation,
                                "DisplayName": newDisplayName,
                                "ShortLocationName": newShortLocationName,
                                "FacilityNumber": newFacilityNumber,
                                "SkiDataVersion": newSkiDataVersion,
                                "SkiDataLocation": newSkiDataLocation,
                                "LocationAddress": newLocationAddress,
                                "LocationCity": newLocationCity,
                                "BrandId": newBrandId,
                                "AirportId": newAirportId,
                                "Capacity": newCapacity,
                                "CityId": newCityId,
                                "LocationStateId": newLocationStateId,
                                "LocationZipCode": newLocationZipCode,
                                "LocationPhoneNumber": newLocationPhoneNumber,
                                "LocationFaxNumber": newLocationFaxNumber,
                                "Description": newDescription,
                                "Alert": newAlert,
                                "DailyRate": newDailyRate,
                                "Slug": newSlug,
                                "RateQualifications": newRateQualifications,
                                "Manager": newManager,
                                "ManagerEmail": newManagerEmail,
                                "RateText": newRateText,
                                "DistanceFromAirport": newDistanceFromAirport,
                                "Latitude": newLatitude,
                                "Longitude": newLongitude,
                                "SpecialFlagsText": newSpecialFlagsText,
                                "SpecialFlagsInformation": newSpecialFlagsInformation,
                                "GoogleLink": newGoogleLink,
                                "IsActiveFlag": newIsActiveFlag,
                                "ManagerImageUrl": newManagerImageUrl,
                                "MemberRateText": newMemberRateText,
                                "ImageUrl": newImageUrl
                            }),
                            
                            success: function (response) {
                                alert("Saved!");
                                $("#popupLocation").jqxWindow('hide');
                                //refresh the main grid
                                loadLocationGrid();
                            },
                            error: function (jqXHR, textStatus, errorThrown, data) {
                                alert(textStatus); alert(errorThrown);
                            }
                        });

                       
                    }
                }
            });

            $("#Cancel").click(function () {
                //clears all of the inputs in the location edit window\
                $("div#popupLocation input:text").val("");
                $("#cityCombo").jqxComboBox('selectItem', 0);
                $("#stateCombo").jqxComboBox('selectItem', 0);
                $("#brandCombo").jqxComboBox('selectItem', 0);
                $("#popupLocation").jqxWindow('hide');
            });

            //Opens the features pop out form with grid
            $("#btnShowFeatures").click(function () {
                var offset = $("#popupLocation").offset();
                //positions the window just of the main window
                $("#popupFeatureWindow").jqxWindow({ position: { x: parseInt(offset.left) + 60, y: parseInt(offset.top) - 20 } });
                $('#popupFeatureWindow').jqxWindow({ resizable: false });
                $("#popupFeatureWindow").css("visibility", "visible");
                $("#popupFeatureWindow").jqxWindow({ width: '800', height: '600' });
                $("#popupFeatureWindow").jqxWindow('open');
                //gets rid of the X button on the window
                $('#popupFeatureWindow').jqxWindow({ showCloseButton: false });
                $("#popupFeatureWindow").jqxWindow('bringToFront');
                //opens and closes from the corner
                $('#popupFeatureWindow').jqxWindow({ animationType: 'combined' });
                $('#popupFeatureWindow').jqxWindow({ showAnimationDuration: 300 });
                $('#popupFeatureWindow').jqxWindow({ closeAnimationDuration: 500 });
                //doesn't try to load the feature grid if this is a new location
                if (thisNewLocation == false) {
                    loadFeatureGrid(selectedLocationId);
                } else {
                    thisNewLocation = false;
                }

            });

            $("#cancelFeature").click(function () {
                clearFeatureForm();
                $("#popupFeatureWindow").jqxWindow("hide");
            });

            $("#addFeature").click(function () {
                //gets the data from the feature form to save as new feature for site
                var newFeatureId = $("#featureCombo").jqxComboBox('getSelectedItem').value;
                var newFeatureAvailableDatetime = $("#FeatureAvailableDatetime").val();
                var newMaxAvailable = $("#MaxAvailable").val();
                var newIsDisplayed = $("#IsDisplayed").is(':checked');
                var newSortOrder = $("#FeatureSortOrder").val();
                var newChargeAmount = $("#FeatureChargeAmount").val();
                var newChargeNote = $("#FeatureChargeNote").val();
                var newFeatureEffectiveDatetime = $("#FeatureEffectiveDatetime").val();
                var newOptionalExtrasName = $("#FeatureOptionalExtrasName").val();
                var newOptionalExtrasDescription = $("#FeatureOptionalExtrasDescription").val();

                var featurePostUrl = $("#apiDomain").val() + "locations/" + selectedLocationId + "/features"

                $.ajax({
                    headers: {
                        "Accept": "application/json",
                        "Content-Type": "application/json",
                        "AccessToken": $("#userGuid").val(),
                        "ApplicationKey": $("#AK").val()
                    },
                    type: "POST",
                    url: featurePostUrl,
                    data: JSON.stringify({
                        "FeatureId": newFeatureId,
                        "FeatureAvailableDatetime": newFeatureAvailableDatetime,
                        "MaxAvailable": newMaxAvailable,
                        "IsDisplayed": newIsDisplayed,
                        "SortOrder": newSortOrder,
                        "ChargeAmount": Number(newChargeAmount),
                        "ChargeNote": newChargeNote,
                        "EffectiveDatetime": newFeatureEffectiveDatetime,
                        "OptionalExtrasName": newOptionalExtrasName,
                        "OptionalExtrasDescription": newOptionalExtrasDescription
                    }),
                    dataType: "json",
                    success: function (response) {
                        alert("Saved!");
                        clearFeatureForm();
                        //refreshes feature grid after succesful save
                        loadFeatureGrid(selectedLocationId);
                    },
                    error: function (request, status, error) {
                        alert(request.responseText);
                    }
                })

            });

            $("#updateFeature").click(function () {
                //gets the data from the feature form to save as new feature for site
                var newFeatureId = $("#featureCombo").jqxComboBox('getSelectedItem').value;
                var newFeatureAvailableDatetime = $("#FeatureAvailableDatetime").val();
                var newMaxAvailable = $("#MaxAvailable").val();
                var newIsDisplayed = $("#IsDisplayed").is(':checked');
                var newSortOrder = $("#FeatureSortOrder").val();
                var newChargeAmount = $("#FeatureChargeAmount").val();
                var newChargeNote = $("#FeatureChargeNote").val();
                var newFeatureEffectiveDatetime = $("#FeatureEffectiveDatetime").val();
                var newOptionalExtrasName = $("#FeatureOptionalExtrasName").val();
                var newOptionalExtrasDescription = $("#FeatureOptionalExtrasDescription").val();
                var LocationHasFeatureId = $("#LocationHasFeatureId").val();


                var featurePostUrl = $("#apiDomain").val() + "locations/" + selectedLocationId + "/features/" + LocationHasFeatureId;

                $.ajax({
                    headers: {
                        "Accept": "application/json",
                        "Content-Type": "application/json",
                        "AccessToken": $("#userGuid").val(),
                        "ApplicationKey": $("#AK").val()
                    },
                    type: "PUT",
                    url: featurePostUrl,
                    data: JSON.stringify({
                        "FeatureId": newFeatureId,
                        "FeatureAvailableDatetime": newFeatureAvailableDatetime,
                        "MaxAvailable": newMaxAvailable,
                        "IsDisplayed": newIsDisplayed,
                        "SortOrder": newSortOrder,
                        "OptionalExtrasName": newOptionalExtrasName,
                        "OptionalExtrasDescription": newOptionalExtrasDescription
                    }),
                    dataType: "json",
                    success: function (response) {
                        UpdateCharges();
                    },
                    error: function (request, status, error) {
                        alert(request.responseText);
                    },
                    complete: function(data) {
                        alert("Saved!");
                        clearFeatureForm();
                        //refreshes feature grid after succesful save
                        loadFeatureGrid(selectedLocationId);
                    }
                })

            });

            $("#deleteFeature").click(function () {
                //gets the data from the feature form to save as new feature for site
                var LocationHasFeatureId = $("#LocationHasFeatureId").val();

                var featurePostUrl = $("#apiDomain").val() + "locations/features/" + LocationHasFeatureId

                $.ajax({
                    headers: {
                        "Accept": "application/json",
                        "Content-Type": "application/json",
                        "AccessToken": $("#userGuid").val(),
                        "ApplicationKey": $("#AK").val()
                    },
                    type: "DEL",
                    url: featurePostUrl,
                    dataType: "json",
                    success: function (response) {
                        alert("Deleted!");
                        clearFeatureForm();
                        //refreshes feature grid after succesful save
                        loadFeatureGrid(selectedLocationId);
                    },
                    error: function (request, status, error) {
                        alert(request.responseText);
                    }
                })

            });

            //#endregion

            //#region SetupComboBoxes
            //set up the state combobox
            var stateSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'StateName' },
                    { name: 'StateId' }
                ],
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                url: $("#apiDomain").val() + "States",

            };
            var stateDataAdapter = new $.jqx.dataAdapter(stateSource);
            $("#stateCombo").jqxComboBox(
            {
                width: 200,
                height: 25,
                source: stateDataAdapter,
                selectedIndex: 0,
                displayMember: "StateName",
                valueMember: "StateId"
            });
            $("#stateCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {

                    }
                }
            });

            //setup the city combobox
            var citySource =
           {
               datatype: "json",
               type: "Get",
               root: "data",
               datafields: [
                   { name: 'CityName' },
                   { name: 'CityId' }
               ],
               beforeSend: function (jqXHR, settings) {
                   jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
               },
               url: $("#apiDomain").val() + "Cities",

           };
            var cityDataAdapter = new $.jqx.dataAdapter(citySource);
            $("#cityCombo").jqxComboBox(
            {
                width: 200,
                height: 25,
                source: cityDataAdapter,
                selectedIndex: 0,
                displayMember: "CityName",
                valueMember: "CityId"
            });
            $("#cityCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {

                    }
                }
            });

            //setup brand combobox
            var brandSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'BrandName' },
                    { name: 'BrandId' }
                ],
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                url: $("#apiDomain").val() + "Brands",

            };
            var brandDataAdapter = new $.jqx.dataAdapter(brandSource);
            $("#brandCombo").jqxComboBox(
            {
                width: 200,
                height: 25,
                source: brandDataAdapter,
                selectedIndex: 0,
                displayMember: "BrandName",
                valueMember: "BrandId"
            });
            $("#brandCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {

                    }
                }
            });

            //setup Airport combobox
            var airportSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'AirportName' },
                    { name: 'AirportId' }
                ],
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                url: $("#apiDomain").val() + "airports",

            };
            var airportDataAdapter = new $.jqx.dataAdapter(airportSource);
            $("#airportCombo").jqxComboBox(
            {
                width: 200,
                height: 25,
                source: airportDataAdapter,
                selectedIndex: 0,
                displayMember: "AirportName",
                valueMember: "AirportId"
            });
            $("#airportCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {

                    }
                }
            });

            //setup featur combobox
            var FeatureComboSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'FeatureName' },
                    { name: 'FeatureId' }
                ],
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                url: $("#apiDomain").val() + "features",

            };
            var featureDataAdapter = new $.jqx.dataAdapter(FeatureComboSource);
            $("#featureCombo").jqxComboBox(
            {
                width: 590,
                height: 25,
                source: featureDataAdapter,
                selectedIndex: 0,
                displayMember: "FeatureName",
                valueMember: "FeatureId"
            });
            $("#featureCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {

                    }
                }
            });
            
           //#endregion


        });
        // ============= Initialize Page ================== End

        //#region LoadGridFunctions

        //loads main location grid
        function loadLocationGrid() {
            var url = $("#apiDomain").val() + "locations/";

            var source =
            {
                datafields: [
                    { name: 'LocationId' },
                    { name: 'NameOfLocation' },
                    { name: 'DisplayName' },
                    { name: 'ShortLocationName' },
                    { name: 'FacilityNumber' },
                    { name: 'SkiDataVersion' },
                    { name: 'SkiDataLocation' },
                    { name: 'LocationAddress' },
                    { name: 'LocationCity' },
                    { name: 'LocationZipCode' },
                    { name: 'LocationPhoneNumber' },
                    { name: 'LocationFaxNumber' },
                    { name: 'Capacity' },
                    { name: 'Description' },
                    { name: 'Alert' },
                    { name: 'Slug' },
                    { name: 'Manager' },
                    { name: 'ManagerEmail' },
                    { name: 'DailyRate' },
                    { name: 'HourlyRate' },
                    { name: 'RateQualifications' },
                    { name: 'RateText' },
                    { name: 'MemberRateText' },
                    { name: 'DistanceFromAirport' },
                    { name: 'AirportId', map: 'Airport>AirportId' },
                    { name: 'Latitude' },
                    { name: 'Longitude' },
                    { name: 'GoogleLink' },
                    { name: 'IsActive' },
                    { name: 'SpecialFlagsText' },
                    { name: 'SpecialFlagsInformation' },
                    { name: 'ManagerImageUrl' },
                    { name: 'ImageUrl' },
                    { name: 'EstimatedCharges' },
                    { name: 'EstimatedSavings' },
                    { name: 'BrandId', map: 'Brand>BrandId' },
                    { name: 'BrandName', map: 'Brand>BrandName' },
                    { name: 'CityId', map: 'City>CityId' },
                    { name: 'CityName', map: 'City>CityName' },
                    { name: 'StateId', map: 'State>StateId' },
                    { name: 'StateName', map: 'State>StateName' },
                    { name: 'LocationHasFeatureId' }
                ],

                id: 'LocationId',
                type: 'Get',
                datatype: "json",
                url: url,
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                root: "data"
            };

            // creage jqxgrid
            $("#jqxgrid").jqxGrid(
            {
                pageable: true,
                pagermode: 'simple',
                //pagermode: 'advanced',
                pagesize: 12,
                width: '100%',
                height: 500,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                columnsresize: true,

                columns: [
                      {
                          //creates the edit button
                          text: '', pinned: true, datafield: 'Edit', width: 50, columntype: 'button', cellsrenderer: function () {
                              return "Edit";
                          }, buttonclick: function (row) {
                              // open the popup window when the user clicks a button.
                              editrow = row;
                              var offset = $("#jqxgrid").offset();
                              $("#popupLocation").jqxWindow({ position: { x: parseInt(offset.left) + 5, y: parseInt(offset.top) - 80 } });
                              $('#popupLocation').jqxWindow({ resizable: false });
                              $("#popupLocation").css("visibility", "visible");
                              $('#popupLocation').jqxWindow({ maxHeight: 650, maxWidth: 1300 });
                              $('#popupLocation').jqxWindow({ width: 1300, height: 645 });
                              $('#popupLocation').jqxWindow({ showCloseButton: false });
                              $('#popupLocation').jqxWindow({ animationType: 'combined' });
                              $('#popupLocation').jqxWindow({ showAnimationDuration: 300 });
                              $('#popupLocation').jqxWindow({ closeAnimationDuration: 500 });

                              // get the clicked row's data and initialize the input fields.
                              var dataRecord = $("#jqxgrid").jqxGrid('getrowdata', editrow);



                              $("#thisLocationId").val(dataRecord.LocationId);
                              $("#NameOfLocation").val(dataRecord.NameOfLocation);
                              $("#DisplayName").val(dataRecord.DisplayName);
                              $("#ShortLocationName").val(dataRecord.ShortLocationName);
                              $("#FacilityNumber").val(dataRecord.FacilityNumber);
                              $("#SkiDataVersion").val(dataRecord.SkiDataVersion);
                              $("#SkiDataLocation").val(dataRecord.SkiDataLocation);
                              $("#LocationAddress").val(dataRecord.LocationAddress);
                              $("#LocationCity").val(dataRecord.LocationCity);
                              $("#LocationZipCode").val(dataRecord.LocationZipCode);
                              $("#LocationPhoneNumber").val(dataRecord.LocationPhoneNumber);
                              $("#LocationFaxNumber").val(dataRecord.LocationFaxNumber);
                              $("#Capacity").val(dataRecord.Capacity);
                              $("#Description").val(dataRecord.Description);
                              $("#Alert").val(dataRecord.Alert);
                              $("#Slug").val(dataRecord.Slug);
                              $("#siteManager").val(dataRecord.Manager);
                              $("#ManagerEmail").val(dataRecord.ManagerEmail);
                              $("#DailyRate").val(dataRecord.DailyRate);
                              $("#HourlyRate").val(dataRecord.DailyRate);
                              $("#RateQualifications").val(dataRecord.RateQualifications);
                              $("#RateText").val(dataRecord.RateText);
                              $("#MemberRateText").val(dataRecord.MemberRateText);
                              $("#Latitude").val(dataRecord.Latitude);
                              $("#Longitude").val(dataRecord.Longitude);
                              $("#GoogleLink").val(dataRecord.GoogleLink);
                              $("#IsActive").val(dataRecord.IsActive);
                              $("#SpecialFlagsText").val(dataRecord.SpecialFlagsText);
                              $("#SpecialFlagsInformation").val(dataRecord.SpecialFlagsInformation);
                              $("#ManagerImageUrl").val(dataRecord.ManagerImageUrl);
                              $("#ImageUrl").val(dataRecord.ImageUrl);
                              $("#EstimatedCharges").val(dataRecord.EstimatedCharges);
                              $("#EstimatedSavings").val(dataRecord.EstimatedSavings);
                              $("#BrandId").val(dataRecord.BrandId);
                              $("#cityCombo").jqxComboBox('selectItem', dataRecord.CityId);
                              $("#stateCombo").jqxComboBox('selectItem', dataRecord.StateId);
                              $("#brandCombo").jqxComboBox('selectItem', dataRecord.BrandId);
                              $("#airportCombo").jqxComboBox('selectItem', dataRecord.AirportId);

                              //sets the current selected location
                              selectedLocationId = dataRecord.LocationId;

                              // show the popup window.
                              $("#popupLocation").jqxWindow('open');
                          }
                      },
                      // loads the rest of the columns for the location grid
                      { text: 'LocationId', datafield: 'LocationId', hidden: true },
                      { text: 'Name', datafield: 'NameOfLocation' },
                      { text: 'Display Name', datafield: 'DisplayName', hidden: true },
                      { text: 'Short Name', datafield: 'ShortLocationName' },
                      { text: 'Facility #', datafield: 'FacilityNumber', hidden: true },
                      { text: 'SkiData Version', datafield: 'SkiDataVersion', hidden: true },
                      { text: 'SkiData Location', datafield: 'SkiDataLocation', hidden: true },
                      { text: 'Address', datafield: 'LocationAddress' },
                      { text: 'City', datafield: 'LocationCity', hidden: true },
                      { text: 'Zip', datafield: 'LocationZipCode' },
                      { text: 'Phone', datafield: 'LocationPhoneNumber' },
                      { text: 'Fax', datafield: 'LocationFaxNumber', hidden: true },
                      { text: 'Capacity', datafield: 'Capacity' },
                      { text: 'Description', datafield: 'Description', hidden: true },
                      { text: 'Alert', datafield: 'Alert', hidden: true },
                      { text: 'Slug', datafield: 'Slug', hidden: true },
                      { text: 'Manager', datafield: 'Manager' },
                      { text: 'Manager Email', datafield: 'ManagerEmail', hidden: true },
                      { text: 'Daily Rate', datafield: 'DailyRate' },
                      { text: 'Hourly Rate', datafield: 'HourlyRate' },
                      { text: 'RateQualifications', datafield: 'RateQualifications', hidden: true },
                      { text: 'RateText', datafield: 'RateText', hidden: true },
                      { text: 'MemberRateText', datafield: 'MemberRateText', hidden: true },
                      { text: 'Distance From Airport', datafield: 'DistanceFromAirport', hidden: true },
                      { text: 'AirportId', datafield: 'AirportId', hidden: true },
                      { text: 'Latitude', datafield: 'Latitude', hidden: true },
                      { text: 'Longitude', datafield: 'Longitude', hidden: true },
                      { text: 'Google Link', datafield: 'GoogleLink', hidden: true },
                      { text: 'IsActive', datafield: 'IsActive', hidden: true },
                      { text: 'Special Flags Text', datafield: 'SpecialFlagsText', hidden: true },
                      { text: 'Special Flags Info', datafield: 'SpecialFlagsInformation', hidden: true },
                      { text: 'Manager Image Url', datafield: 'ManagerImageUrl', hidden: true },
                      { text: 'Image Url', datafield: 'ImageUrl', hidden: true },
                      { text: 'Estimated Charges', datafield: 'EstimatedCharges', hidden: true },
                      { text: 'Estimated Savings', datafield: 'EstimatedSavings', hidden: true },
                      { text: 'BrandName', datafield: 'BrandName', hidden: true },
                      { text: 'City', datafield: 'CityName' },
                      { text: 'State', datafield: 'StateName' }
                ]
            });
        }

        //loads feature grid, requires locationID
        function loadFeatureGrid(thisLocationId) {

            var url = $("#apiDomain").val() + "locations/" + thisLocationId + "/features";

            var featureSource =
            {
                datafields: [
                    { name: 'LocationHasFeatureId', },
                    { name: 'FeatureName', map: 'LocationFeature>FeatureName' },
                    { name: 'FeatureId', map: 'LocationFeature>FeatureId' },
                    { name: 'FeatureAvailableDatetime', },
                    { name: 'MaxAvailable', },
                    { name: 'IsDisplayed', },
                    { name: 'SortOrder', map: 'SortOrder' },
                    { name: 'ChargeAmount', map: 'FeatureCharges>ChargeAmount' },
                    { name: 'ChargeNote', map: 'FeatureCharges>ChargeNote' },
                    { name: 'EffectiveDatetime', map: 'FeatureCharges>EffectiveDatetime' },
                    { name: 'OptionalExtrasName', },
                    { name: 'OptionalExtrasDescription', },
                    { name: 'MaxAvailable', },
                    { name: 'IsDisplayed', }
                ],

                id: 'FeatureId',
                type: 'Get',
                datatype: "json",
                url: url,
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                root: "data"
            };

            // creage jqxgrid
            $("#jqxFeatureGrid").jqxGrid(
            {
                width: '100%',
                height: 300,
                source: featureSource,
                rowsheight: 35,
                selectionmode: 'none',
                altrows: true,
                editable: true,
                columns: [{
                                //creates the edit button
                            text: '', pinned: true, datafield: 'Edit', width: 50, columntype: 'button', cellsrenderer: function () {
                                return "Edit";
                            }, buttonclick: function (row) {
                                // Populate the edit boxes
                                editrow = row;
                                    var dataRecord = $("#jqxFeatureGrid").jqxGrid('getrowdata', editrow);
                                    $("#LocationHasFeatureId").val(dataRecord.LocationHasFeatureId);
                                    $("#featureCombo").jqxComboBox('selectItem', dataRecord.FeatureId);
                                    $("#FeatureSortOrder").val(dataRecord.SortOrder);
                                    $("#FeatureChargeAmount").val(dataRecord.ChargeAmount);
                                    $("#FeatureChargeNote").val(dataRecord.ChargeNote);
                                    $("#FeatureEffectiveDatetime").val(dataRecord.EffectiveDatetime);
                                    $("#FeatureOptionalExtrasName").val(dataRecord.OptionalExtrasName);
                                    $("#FeatureOptionalExtrasDescription").val(dataRecord.OptionalExtrasDescription);
                                    $("#MaxAvailable").val(dataRecord.MaxAvailable);
                                    $("#FeatureAvailableDatetime").val(dataRecord.FeatureAvailableDatetime);
                                    $("#IsDisplayed").prop("checked", dataRecord.IsDisplayed);
                                }
                            },
                            //  uncomment below to show the what you want
                            { text: 'LocationHasFeatureId', datafield: 'LocationHasFeatureId', editable: false },
                            { text: 'Feature Name', datafield: 'FeatureName', editable: false },
                            { text: 'FeatureId', datafield: 'FeatureId', hidden: true, editable: false },
                            { text: 'FeatureSortOrder', datafield: 'SortOrder', editable: false },
                            { text: 'FeatureChargeAmount', datafield: 'ChargeAmount', hidden: true, editable: false },
                            { text: 'FeatureChargeNote', datafield: 'ChargeNote', hidden: true, editable: false },
                            { text: 'FeatureEffectiveDatetime', datafield: 'EffectiveDatetime', hidden: true, editable: false },
                            { text: 'FeatureOptionalExtrasName', datafield: 'OptionalExtrasName', hidden: true, editable: false },
                            { text: 'FeatureOptionalExtrasDescription', datafield: 'OptionalExtrasDescription', hidden: true, editable: false },
                            { text: 'MaxAvailable', datafield: 'MaxAvailable', hidden: true, editable: false },
                            { text: 'FeatureAvailableDatetime', datafield: 'FeatureAvailableDatetime', hidden: true, editable: false },
                            { text: 'IsDisplayed', datafield: 'IsDisplayed', hidden: true, editable: false }
                      
                      
                ]
            });

        }

        //#endregion



        //#region Functions

        function UpdateCharges () {
            //gets the data from the feature form to save as new feature for site

            var newChargeAmount = $("#FeatureChargeAmount").val();
            var newChargeNote = $("#FeatureChargeNote").val();
            var newFeatureEffectiveDatetime = $("#FeatureEffectiveDatetime").val();
            var LocationHasFeatureId = $("#LocationHasFeatureId").val();


            var featurePostUrl = $("#apiDomain").val() + "locations/" + selectedLocationId + "/features/" + LocationHasFeatureId + "/charges";

            //alert(featurePostUrl);
            //alert("ChargeAmount: " + newChargeAmount + "ChargeNote: " + newChargeNote + "EffectiveDatetime: " + newFeatureEffectiveDatetime)

            $.ajax({
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": $("#userGuid").val(),
                    "ApplicationKey": $("#AK").val()
                },
                type: "POST",
                url: featurePostUrl,
                data: JSON.stringify({
                    "ChargeAmount": Number(newChargeAmount),
                    "ChargeNote": newChargeNote,
                    "EffectiveDatetime": newFeatureEffectiveDatetime
                }),
                dataType: "json",
                success: function (response) {

                },
                error: function (request, status, error) {
                    alert(request.responseText);
                }
            })

        }

        //opens the location Pop out form empty for new location
        function newLocation() {
            var offset = $("#jqxgrid").offset();
            //sets the varialbe to true so form doesn't try to load feature grid
            thisNewLocation = true;
            $("#popupLocation").jqxWindow({ position: { x: parseInt(offset.left) + 75, y: parseInt(offset.top) + 1 } });
            $('#popupLocation').jqxWindow({ resizable: false });
            $("#popupLocation").css("visibility", "visible");
            $('#popupLocation').jqxWindow({ width: '800', height: '500' });
            $('#popupLocation').jqxWindow({ showCloseButton: false });
            $('#popupLocation').jqxWindow({ animationType: 'combined' });
            $('#popupLocation').jqxWindow({ showAnimationDuration: 300 });
            $('#popupLocation').jqxWindow({ closeAnimationDuration: 500 });
            $("#popupLocation").jqxWindow('open');
        }

        //clears feature form so when it is open by new Location button there is now content there
        function clearFeatureForm() {
            $("#featureCombo").jqxComboBox('selectItem', 0);
            $("#FeatureSortOrder").val('');
            $("#FeatureChargeAmount").val('');
            $("#FeatureChargeNote").val('');
            $("#FeatureEffectiveDatetime").val('');
            $("#FeatureOptionalExtrasName").val('');
            $("#FeatureOptionalExtrasDescription").val('');
            $("#MaxAvailable").val('');
            $("#FeatureAvailableDatetime").val('');
            $("#IsDisplayed").prop('checked', false);
        }

        //#endregion

    </script>

    <div id="Locations">      
        <div class="FPR_SearchBox" style="display:block;">
            <div class="FPR_SearchLeft">

            </div>
            <div class="FPR_SearchRight">
                <a href="javascript:" onclick="newLocation();" id="btnNew">New Location</a>     
            </div>
        </div>
        <div style="visibility:hidden">
            <input id="LocationId" type="text" value="0"  />
        </div>
    </div>      
    
    <div id="jqxgrid"></div>

    <%-- html for popup edit box --%>
    <div id="popupLocation" style="visibility:hidden">
            <div id="locationInfo" class="locationInfo" style="overflow: hidden">
                <table style="width:100%;padding:5px">
                    <tr>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td>
                            <table>
                                <tr>
                                    <td>LocationId:</td>
                                    <td><input type="text" id="thisLocationId" disabled /></td>
                                </tr>
                                <tr>
                                    <td>Name Of Location:</td>
                                    <td><input type="text" id="NameOfLocation" /></td>
                                </tr>
                                <tr>
                                    <td>DisplayName:</td>
                                    <td><input type="text" id="DisplayName" /></td>
                                </tr>
                                <tr>
                                    <td>Short Location Name:</td>
                                    <td><input type="text" id="ShortLocationName" /></td>
                                </tr>
                                <tr>
                                    <td>Airport:</td>
                                    <td><div id="airportCombo"></div></td>
                                </tr>
                                <tr>
                                    <td>Facility Number:</td>
                                    <td><input type="text" id="FacilityNumber"  /></td>
                                </tr>
                                <tr>
                                    <td>SkiDataVersion:</td>
                                    <td><input type="text" id="SkiDataVersion" /></td>
                                </tr>
                                 <tr>
                                    <td>SkiDataLocation:</td>
                                    <td><input type="text" id="SkiDataLocation"  /></td>
                                </tr>
                                <tr>
                                    <td>Address:</td>
                                    <td><input type="text" id="LocationAddress" /></td>
                                </tr>
                                <tr>
                                    <td>City:</td>
                                    <td><div id="cityCombo"></div></td>
                                </tr>
                                <tr>
                                    <td>Zip:</td>
                                    <td><input type="text" id="LocationZipCode" /></td>
                                </tr>
                                 <tr>
                                    <td>Phone:</td>
                                    <td><input type="text" id="LocationPhoneNumber"  /></td>
                                </tr>
                                <tr>
                                    <td>Fax:</td>
                                    <td><input type="text" id="LocationFaxNumber" /></td>
                                </tr>
                                <tr>
                                    <td>Capacity:</td>
                                    <td><input type="text" id="Capacity" /></td>
                                </tr>
                                <tr>
                                    <td>Description:</td>
                                    <td><textarea rows="4" cols="55" id="Description"></textarea></td>
                                </tr>
                                <tr>
                                    <td>Alert:</td>
                                    <td><input type="text" id="Alert" /></td>
                                </tr>
                                <tr>
                                    <td>Daily Rate:</td>
                                    <td><input type="text" id="DailyRate" /></td>
                                </tr>
                                <tr>
                                    <td>Rate Text:</td>
                                    <td><textarea rows="2" cols="55" id="RateText"></textarea></td>
                                </tr>
                                <tr>
                                    <td>Member Rate Text:</td>
                                    <td><textarea rows="2" cols="55" id="MemberRateText"></textarea></td>
                                </tr>
                                <tr>
                                    <td>Slug:</td>
                                    <td><input type="text" id="Slug" /></td>
                                </tr>
                                
                            </table>
                        </td>
                        <td>&nbsp;&nbsp;</td>
                        <td>
                            <table>
                                <tr>
                                    <td>Qualifications:</td>
                                    <td><input type="text" id="RateQualifications" /></td>
                                </tr>
                                <tr>
                                    <td>Manager:</td>
                                    <td><input type="text" id="siteManager" /></td>
                                </tr>
                                <tr>
                                    <td>Manager Email:</td>
                                    <td><input type="text" id="ManagerEmail" /></td>
                                </tr>
                                <tr>
                                    <td>Distance From Airport:</td>
                                    <td><input type="text" id="DistanceFromAirport" /></td>
                                </tr>
                                <tr>
                                    <td>Latitude:</td>
                                    <td><input type="text" id="Latitude" /></td>
                                </tr>
                                <tr>
                                    <td>Longitude:</td>
                                    <td><input type="text" id="Longitude" /></td>
                                </tr>
                                <tr>
                                    <td>Google Link:</td>
                                    <td><input type="text" id="GoogleLink" /></td>
                                </tr>
                                <tr>
                                    <td>Active:</td>
                                    <td><input type="text" id="IsActive" /></td>
                                </tr>
                                <tr>
                                    <td>Special Flags Text:</td>
                                    <td><input type="text" id="SpecialFlagsText" /></td>
                                </tr>
                                <tr>
                                    <td>SpecialFlagsInformation:</td>
                                    <td><input type="text" id="SpecialFlagsInformation" /></td>
                                </tr>
                                <tr>
                                    <td>Manager Image Url:</td>
                                    <td><input type="text" id="ManagerImageUrl" /></td>
                                </tr>
                                 <tr>
                                    <td>Hourly Rate:</td>
                                    <td><input type="text" id="HourlyRate" /></td>
                                </tr>
                                <tr>
                                    <td>ImageUrl:</td>
                                    <td><input type="text" id="ImageUrl" /></td>
                                </tr>
                                <tr>
                                    <td>Estimated Charges:</td>
                                    <td><input type="text" id="EstimatedCharges" /></td>
                                </tr>
                                <tr>
                                    <td>Estimated Savings:</td>
                                    <td><input type="text" id="EstimatedSavings" /></td>
                                </tr>
                                <tr>
                                    <td>Brand:</td>
                                    <td><div id="brandCombo"></div></td>
                                </tr>
                                <tr>
                                    <td>City:</td>
                                    <td><input type="text" id="LocationCity" /></td>
                                </tr>
                                <tr>
                                    <td>State:</td>
                                    <td><div id="stateCombo"></div></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><input id="btnShowFeatures" type="button" value="Show Features" /></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td style="padding-top: 10px;"><input style="float:left;margin-top:15px;" type="button" id="Save" value="Save" /></td>
                        <td></td>
                        <td style="padding-top: 10px;"><input style="float:right;margin-top:15px;" id="Cancel" type="button" value="Cancel" /></td>
                        
                    </tr>
                </table>
                    
            </div>

       </div>
       <%-- html for popup edit box END --%>

        <%-- html for popup feature box --%>
    <div id="popupFeatureWindow" style="visibility:hidden">
            <div>Edit</div>
           
            <div style="overflow: hidden">
                <table>
                    <tr>
                        <td colspan="4">
                            <div id="jqxFeatureGrid"></div>
                        </td>
                    </tr>
                     <tr>
                        <td colspan="4">
                             &nbsp;
                        </td>
                    </tr>
                      <tr>
                        <td colspan="4">
                            <div id="featureCombo"></div>
                        </td>
                    </tr>
                     <tr>
                        <td colspan="4">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Sort Order:
                        </td>
                        <td>
                            <input type="text" id="FeatureSortOrder" />
                            <input type="text" id="LocationHasFeatureId" style="visibility:hidden" />
                        </td>
                        <td>
                            Charge Amount:
                        </td>
                        <td>
                            <input type="text" id="FeatureChargeAmount" />
                        </td>
                    </tr>
                     <tr>
                        <td>
                            Charge Note:
                        </td>
                        <td>
                            <input type="text" id="FeatureChargeNote" />
                        </td>
                        <td>
                            Effective Date:
                        </td>
                        <td>
                            <input type="text" id="FeatureEffectiveDatetime" />
                        </td>
                    </tr>
                     <tr>
                        <td>
                            Optional Extras Name:
                        </td>
                        <td>
                            <input type="text" id="FeatureOptionalExtrasName" />
                        </td>
                        <td>
                            Optional Extras Description:
                        </td>
                        <td>
                            <input type="text" id="FeatureOptionalExtrasDescription" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Max Available:
                        </td>
                        <td>
                            <input type="text" id="MaxAvailable" />
                        </td>
                        <td>
                            Date Available:
                        </td>
                        <td>
                            <input type="text" id="FeatureAvailableDatetime" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            
                        </td>
                        <td>
                           
                        </td>
                        <td>
                            Display?:
                        </td>
                        <td>
                            <input type="checkbox" id="IsDisplayed" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input id="addFeature" type="button" value="Add" />
                            <input id="updateFeature" type="button" value="Update" />
                            <input id="deleteFeature" type="button" value="Delete" />
                        </td>
                        <td colspan="2" align="right">
                            <input id="cancelFeature" type="button" value="Cancel" />
                        </td>
                    </tr>
                </table>
            </div>
       </div>
       <%-- html for popup feature box END --%>
    <div id='Menu' style="visibility: hidden">
        <ul>
            <li>Edit Selected Row</li>
            <li>Delete Selected Row</li>
        </ul>
    </div>

</asp:Content>


