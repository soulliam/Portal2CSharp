﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="Locations.aspx.cs" Inherits="Locations" %>

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
            $("#Save").jqxButton();
            $("#Cancel").jqxButton();
            $("#addFeature").jqxButton({ width: 120, height: 25 });
            $("#deleteFeature").jqxButton({ width: 120, height: 25 });
            $("#updateFeature").jqxButton({ width: 120, height: 25 });
            $("#cancelFeature").jqxButton({ width: 120, height: 25 });
            $("#btnShowFeatures").jqxButton();
            //$("#btnNew").jqxLinkButton({ width: '100%', height: 26 });
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
                    var newLocationHighlights = $("#LocationHighlights").val();

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
                            "LocationHighlights": newLocationHighlights,
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
                            "ImageUrl": newImageUrl,
                            
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
                        var newAirportId = $("#airportCombo").jqxComboBox('getSelectedItem').value;
                        var newRateQualifications = $("#RateQualifications").val();
                        var newRateText = $("#RateText").val();
                        var newMemberRateText = $("#MemberRateText").val();
                        var newLocationHighlights = $("#LocationHighlights").val();

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
                width: '100%',
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
                width: '100%',
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
                width: '100%',
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
                width: '100%',
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
                              $("#popupLocation").jqxWindow({ position: { x: parseInt(offset.left) + 5, y: parseInt(offset.top) - 50 } });
                              $('#popupLocation').jqxWindow({ resizable: true });
                              $("#popupLocation").css("visibility", "visible");
                              $('#popupLocation').jqxWindow({ maxHeight: 600, maxWidth: 1300 });
                              $('#popupLocation').jqxWindow({ width: 1300, height: 600 });
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

    <div id="Locations" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-1">
                </div>
                <div class="col-sm-12 col-md-10">
                    <div class="row search-size">
                        <div class="col-sm-9">
                            <div class="row search-size">
                                <div class="col-sm-15">
                                    <a href="javascript:" onclick="newLocation();" id="btnNew">New Location</a>
                                </div>
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                </div>
                            </div>
                            <div class="row search-size">
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                </div>
                            </div>
                            <div class="row search-size">
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="row search-size">
                                <div class="col-sm-4">
                                </div>
                                <div class="col-sm-8">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-12 col-md-1">
                </div>
            </div>
        </div>
    </div><!-- /.container-fluid -->
    
                                    <div style="visibility:hidden">
                                        <input id="LocationId" type="text" value="0"  />
                                    </div>
    <div class="container-fluid container-970">
        <div class="row ">
            <div class="col-sm-12">
                <div id="jqxgrid"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->


    <%-- html for popup edit box --%>
    <div id="popupLocation" style="visibility:hidden">
        <div>Location Details</div>
        <div style="overflow: hidden;">
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-4">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="thisLocationId" class="col-sm-3 col-md-4 control-label">LocationId:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="thisLocationId" disabled />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="NameOfLocation" class="col-sm-3 col-md-4 control-label">Location Name:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="NameOfLocation" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="DisplayName" class="col-sm-3 col-md-4 control-label">Display Name:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="DisplayName" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="ShortLocationName" class="col-sm-3 col-md-4 control-label">Short Name:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="ShortLocationName" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="airportCombo" class="col-sm-3 col-md-4 control-label">Airport:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div id="airportCombo"></div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="FacilityNumber" class="col-sm-3 col-md-4 control-label">Facility Number:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="FacilityNumber"  />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="SkiDataVersion" class="col-sm-3 col-md-4 control-label">SkiDataVersion:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="SkiDataVersion" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="SkiDataLocation" class="col-sm-3 col-md-4 control-label">SkiDataLocation:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="SkiDataLocation"  />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="LocationAddress" class="col-sm-3 col-md-4 control-label">Address:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="LocationAddress" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="cityCombo" class="col-sm-3 col-md-4 control-label">City:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div id="cityCombo"></div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="LocationZipCode" class="col-sm-3 col-md-4 control-label">Zip:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="LocationZipCode" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="LocationPhoneNumber" class="col-sm-3 col-md-4 control-label">Phone:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="LocationPhoneNumber"  />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="LocationFaxNumber" class="col-sm-3 col-md-4 control-label">Fax:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="LocationFaxNumber" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="Capacity" class="col-sm-3 col-md-4 control-label">Capacity:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="Capacity" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="Description" class="col-sm-3 col-md-4 control-label">Description:</label>
                                <div class="col-sm-9 col-md-8">
                                    <textarea rows="5" class="form-control" id="Description"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="Alert" class="col-sm-3 col-md-4 control-label">Alert:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="Alert" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="DailyRate" class="col-sm-3 col-md-4 control-label">Daily Rate:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="DailyRate" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="RateText" class="col-sm-3 col-md-4 control-label">Rate Text:</label>
                                <div class="col-sm-9 col-md-8">
                                    <textarea rows="2" class="form-control" id="RateText"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="MemberRateText" class="col-sm-3 col-md-4 control-label">Member Rate Text:</label>
                                <div class="col-sm-9 col-md-8">
                                    <textarea rows="2" class="form-control" id="MemberRateText"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="Slug" class="col-sm-3 col-md-4 control-label">Slug:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="Slug" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="LocationHighlights" class="col-sm-3 col-md-4 control-label">Location Highlights:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="LocationHighlights" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="RateQualifications" class="col-sm-3 col-md-4 control-label">Qualifications:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="RateQualifications" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="siteManager" class="col-sm-3 col-md-4 control-label">Manager:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="siteManager" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="ManagerEmail" class="col-sm-3 col-md-4 control-label">Manager Email:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="ManagerEmail" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="ManagerImageUrl" class="col-sm-3 col-md-4 control-label">Manager Image Url:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="ManagerImageUrl" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="Latitude" class="col-sm-3 col-md-4 control-label">Latitude:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="Latitude" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="Longitude" class="col-sm-3 col-md-4 control-label">Longitude:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="Longitude" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="GoogleLink" class="col-sm-3 col-md-4 control-label">Google Link:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="GoogleLink" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="IsActive" class="col-sm-3 col-md-4 control-label">Active:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="IsActive" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="SpecialFlagsText" class="col-sm-3 col-md-4 control-label">Special Flags Text:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="SpecialFlagsText" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="SpecialFlagsInformation" class="col-sm-3 col-md-4 control-label">Special Flags Information:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="SpecialFlagsInformation" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="DistanceFromAirport" class="col-sm-3 col-md-4 control-label">Distance From Airport:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="DistanceFromAirport" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="HourlyRate" class="col-sm-3 col-md-4 control-label">Hourly Rate:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="HourlyRate" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="ImageUrl" class="col-sm-3 col-md-4 control-label">Image Url:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="ImageUrl" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="EstimatedCharges" class="col-sm-3 col-md-4 control-label">Est. Charges:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="EstimatedCharges" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="EstimatedSavings" class="col-sm-3 col-md-4 control-label">Est. Savings:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="EstimatedSavings" />
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="brandCombo" class="col-sm-3 col-md-4 control-label">Brand:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div id="brandCombo"></div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="LocationCity" class="col-sm-3 col-md-4 control-label">City:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="LocationCity" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="stateCombo" class="col-sm-3 col-md-4 control-label">State:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div id="stateCombo"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-4 col-md-2">
                        <input id="btnShowFeatures" type="button" value="Show Features" />
                    </div>
                    <div class="col-sm-0 col-md-6">
                    </div>
                    <div class="col-sm-4 col-md-2">
                        <input type="button" id="Save" value="Save" />
                    </div>
                    <div class="col-sm-4 col-md-2">
                        <input id="Cancel" type="button" value="Cancel" />
                    </div>
                </div>
            </div>
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


