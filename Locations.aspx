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
    <script type="text/javascript" src="jqwidgets/jqxtabs.js"></script>
    
    <script type="text/javascript">

        var selectedLocationId = 0; //is set to the ID of the location that is selected from the main grid
        var thisNewLocation = false; //determines whether a new Location is being made so the feature grid doesn't get set 
        var DisableEdit = false;
        var group = '<%= Session["groupList"] %>';

        // ============= Initialize Page ==================== Begin
        $(document).ready(function () {


            //set up the tabs
            $('#jqxTabs').jqxTabs({ width: '100%', position: 'top' });
            $('#jqxTabs').css('margin-bottom', '10px');
            $('#settings div').css('margin-top', '10px');
            $('#animation').on('change', function (event) {
                var checked = event.args.checked;
                $('#jqxTabs').jqxTabs({ selectionTracker: checked });
            });

            $('#contentAnimation').on('change', function (event) {
                var checked = event.args.checked;
                if (checked) {
                    $('#jqxTabs').jqxTabs({ animationType: 'fade' });
                }
                else {
                    $('#jqxTabs').jqxTabs({ animationType: 'none' });
                }
            });


            //set up the location Detail tabs
            $('#jqxLocationTabs').jqxTabs({ width: '100%', position: 'top' });
            $('#jqxLocationTabs').css('margin-bottom', '10px');
            $('#settings div').css('margin-top', '10px');
            $('#animation').on('change', function (event) {
                var checked = event.args.checked;
                $('#jqxLocationTabs').jqxTabs({ selectionTracker: checked });
            });

            $('#contentAnimation').on('change', function (event) {
                var checked = event.args.checked;
                if (checked) {
                    $('#jqxLocationTabs').jqxTabs({ animationType: 'fade' });
                }
                else {
                    $('#jqxLocationTabs').jqxTabs({ animationType: 'none' });
                }
            });


            //Loads main location grid
            loadLocationGrid();

            //#region SetupButtons
            $("#btnNew").jqxButton();
            $("#Save").jqxButton();
            $("#Cancel").jqxButton();
            $("#addFeature").jqxButton();
            $("#deleteFeature").jqxButton();
            $("#updateFeature").jqxButton();
            $("#updateLocationImages").jqxButton();
            $("#addLocationImages").jqxButton();
            $("#btnNew").jqxLinkButton({ width: '100%', height: '26' });
            //#endregion

            //#region ButtonClick

            //updateLocationImages

            $("#updateLocationImages").on("click", function (event) {


                var putURL = "";
                var ImageId = "";
                var LocationId = "";
                var ImageUrl = "";
                var Caption = "";
                var SortOrder = "";
                var thisError = false;

                var rows = $("#jqxLocationImagesGrid").jqxGrid('getrows');

                for (i = 0; i < rows.length; i++) {
                    row = rows[i];
                    ImageId = row.ImageId;
                    LocationId = row.LocationId;
                    ImageUrl = row.ImageUrl;
                    Caption = row.Caption;
                    SortOrder = row.SortOrder;
                    putURL = $("#apiDomain").val() + "images/" + ImageId;

                    $.ajax({
                        async: false,
                        headers: {
                            "Accept": "application/json",
                            "Content-Type": "application/json",
                            "AccessToken": $("#userGuid").val(),
                            "ApplicationKey": $("#AK").val()
                        },
                        type: "PUT",
                        url: putURL,
                        data: JSON.stringify({
                            "LocationId": LocationId,
                            "ImageUrl": ImageUrl,
                            "Caption": Caption,
                            "SortOrder": SortOrder
                        }),
                        dataType: "json",
                        success: function (response) {
                            
                        },
                        error: function (request, status, error) {
                            alert(error + " - " + request.html);
                            thisError = true;
                        }
                    })
                }
                if (thisError == false) {
                    alert("Saved!")

                    loadLocationImagesGrid(selectedLocationId);
                }


            });

            //Save main location
            $("#Save").click(function () {
                // If LocationId is nothing then we are adding a new Location and we need a post
                if ($("#LocationId").val() == "0") {
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
                    var newLocationStateId = $("#stateCombo").jqxComboBox('getSelectedItem').value;
                    var newDistanceFromAirport = $("#DistanceFromAirport").val();
                    var newAirportId = $("#airportCombo").jqxComboBox('getSelectedItem').value;
                    var newRateQualifications = $("#RateQualifications").val();
                    var newRateText = $("#RateText").val();
                    var newMemberRateText = $("#MemberRateText").val();
                    var newLocationHighlights = $("#LocationHighlights").val();
                    var newLocationContactEmail = $("#LocationContactEmail").val();
                    var newIMP = $("#SkiDataIMP").val();
                    var newSiteURL = $("#SiteURL").val();
                    var newCityId = $("#cityCombo").jqxComboBox('getSelectedItem').value;

                    var postUrl = $("#apiDomain").val() + "locations"

                    $.ajax({
                        headers: {
                            "Accept": "application/json",
                            "Content-Type": "application/json",
                            "AccessToken": $("#userGuid").val(),
                            "ApplicationKey": $("#AK").val()
                        },
                        url: postUrl,
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
                            "LocationContactEmail": newLocationContactEmail,
                            "LocationHighlights": newLocationHighlights,
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
                            "Imp": newIMP,
                            "SiteURL": newSiteURL
                        }),
                        success: function (response) {
                            alert("Saved!");
                            $("#popupLocation").jqxWindow('hide');
                            //refresh the main grid
                            loadLocationGrid();
                        },
                        error: function (request, status, error) {
                            alert(error + " - " + request.responseJSON.message);
                        }
                    });
                    
                    //update main grid
                    loadLocationGrid();

                } else {
                    //if edit row is greater than zero then a row has been selected and we are updating a location
                    if ($("#LocationId").val() != "0") {

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
                        var newLocationStateId = $("#stateCombo").jqxComboBox('getSelectedItem').value;
                        var newDistanceFromAirport = $("#DistanceFromAirport").val();
                        var newAirportId = $("#airportCombo").jqxComboBox('getSelectedItem').value;
                        var newRateQualifications = $("#RateQualifications").val();
                        var newRateText = $("#RateText").val();
                        var newMemberRateText = $("#MemberRateText").val();
                        var newLocationHighlights = $("#LocationHighlights").val();
                        var newLocationContactEmail = $("#LocationContactEmail").val();
                        var newIMP = $("#SkiDataIMP").val();
                        var newSiteURL = $("#SiteURL").val();
                        var newCityId = $("#cityCombo").jqxComboBox('getSelectedItem').value;

                        var putUrl = $("#apiDomain").val() + "locations/" + selectedLocationId //ID of the location to update

                        var test = JSON.stringify({
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
                            "LocationContactEmail": newLocationContactEmail,
                            "LocationHighlights": newLocationHighlights,
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
                            "Imp": newIMP,
                            "SiteURL": newSiteURL
                        });

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
                                "LocationContactEmail": newLocationContactEmail,
                                "LocationHighlights": newLocationHighlights,
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
                                "Imp": newIMP,
                                "SiteURL": newSiteURL
                            }),
                            
                            success: function (response) {
                                alert("Saved!");
                                $("#popupLocation").jqxWindow('hide');
                                //refresh the main grid
                                loadLocationGrid();
                            },
                            error: function (request, status, error) {
                                alert(error + " - " + request.responseJSON.message);
                            }
                        });

                       
                    }
                }
            });

            $("#saveCharge").on("click", function (event) {
                SaveCharges();
            });

            $("#Cancel").click(function () {
                //clears all of the inputs in the location edit window\
                $("div#popupLocation input:text").val("");
                $("#stateCombo").jqxComboBox('selectItem', 0);
                $("#cityCombo").jqxComboBox('selectItem', 0);
                $("#brandCombo").jqxComboBox('selectItem', 0);
                $("#popupLocation").jqxWindow('hide');
            });

            $("#addLocationImages").on("click", function (event) {
                $("#popupLocationImage").css('display', 'block');
                $("#popupLocationImage").css('visibility', 'hidden');
                var offset = $("#jqxgrid").offset();
                $("#popupLocationImage").jqxWindow({ position: { x: '25%', y: '30%' } });
                $('#popupLocationImage').jqxWindow({ resizable: false });
                $('#popupLocationImage').jqxWindow({ draggable: true });
                $('#popupLocationImage').jqxWindow({ isModal: true });
                $("#popupLocationImage").css("visibility", "visible");
                $('#popupLocationImage').jqxWindow({ height: '250px', width: '50%' });
                $('#popupLocationImage').jqxWindow({ minHeight: '250px', minWidth: '50%' });
                $('#popupLocationImage').jqxWindow({ maxHeight: '500px', maxWidth: '50%' });
                $('#popupLocationImage').jqxWindow({ showCloseButton: true });
                $('#popupLocationImage').jqxWindow({ animationType: 'combined' });
                $('#popupLocationImage').jqxWindow({ showAnimationDuration: 300 });
                $('#popupLocationImage').jqxWindow({ closeAnimationDuration: 500 });
                $("#popupLocationImage").jqxWindow('open');
            });

            $("#addImageSubmit").on("click", function (event) {
                addLocationImage();
            })

            $("#addFeature").click(function () {
                //gets the data from the feature form to save as new feature for site
                var newFeatureId = $("#featureCombo").jqxComboBox('getSelectedItem').value;
                var newFeatureAvailableDatetime = $("#addFeatureAvailableDatetime").val();
                var newMaxAvailable = $("#addFeatureMaxAvailable").val();
                var newIsDisplayed = $("#addFeatureIsDisplayed").is(':checked');
                var newSortOrder = $("#addFeatureSortOrder").val();
                var newChargeAmount = $("#addFeatureChargeAmount").val();
                var newChargeNote = $("#addFeatureChargeNote").val();
                var newOptionalExtrasName = $("#addFeatureOptionalExtrasName").val();
                var newOptionalExtrasDescription = $("#addFeatureOptionalExtrasDescription").val();
                var newIsDisplayedOptionalExtra = $("#addFeatureIsDisplayedOptionalExtra").is(':checked');
                var newDisplayIcon = $("#addFeatureDisplayIcon").is(':checked');

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
                        "DisplayIcon": newDisplayIcon,
                        "SortOrder": newSortOrder,
                        "ChargeAmount": Number(newChargeAmount),
                        "ChargeNote": newChargeNote,
                        "OptionalExtrasName": newOptionalExtrasName,
                        "OptionalExtrasDescription": newOptionalExtrasDescription,
                        "IsDisplayedOptionalExtra": true
                    }),
                    dataType: "json",
                    success: function (response) {
                        alert("Saved!");
                        clearFeatureForm();
                        //refreshes feature grid after succesful save
                        loadFeatureGrid(selectedLocationId);
                    },
                    error: function (request, status, error) {
                        alert(error + " - " + request.html);
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
                var newIsDisplayed = $("#IsDisplayed").is(":checked");

                var featurePostUrl = $("#apiDomain").val() + "locations/" + selectedLocationId + "/features/" + newFeatureId;

                var test = featurePostUrl;

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
                        "OptionalExtrasDescription": newOptionalExtrasDescription,
                        "IsDisplayedOptionalExtra": newIsDisplayed
                    }),
                    dataType: "json",
                    success: function (response) {
                       alert("Saved!")
                    },
                    error: function (request, status, error) {
                        alert(error + " - " + request.html);
                    },
                    complete: function(data) {
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
                    type: "delete",
                    url: featurePostUrl,
                    dataType: "json",
                    success: function (response) {
                        alert("Deleted!");
                        clearFeatureForm();
                        //refreshes feature grid after succesful save
                        loadFeatureGrid(selectedLocationId);
                    },
                    error: function (request, status, error) {
                        alert(error + " - " + request.html);
                    }
                })

            });

            //#endregion

            //#region SetupComboBoxes

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
                width: '100%',
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

            Security();

           //#endregion
       

        });
   
        // ============= Initialize Page ================== End

        //#region LoadGridFunctions

        //show image in location images
        function showImage(imageURL) {
            alert(imageURL);
        }


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
                    { name: 'LocationContactEmail' },
                    { name: 'Imp' },
                    { name: 'LocationHasFeatureId' },
                    { name: 'SiteURL' },
                    { name: 'FirstName', map: 'MarketingRep>FirstName' },
                    { name: 'LastName', map: 'MarketingRep>LastName' }
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
                pagermode: 'advanced',
                pagesize: 50,
                pagesizeoptions: ['10', '20', '50', '100'],
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
                          text: '',
                          pinned: true,
                          datafield: 'Edit',
                          width: 50,
                          columntype: 'button',
                          cellclassname: "editor",
                          cellsrenderer: function () {
                              return "Edit";
                          }, buttonclick: function (row) {
                              // open the popup window when the user clicks a button.
                              if (DisableEdit == false) {
                                  $("#popupLocation").css('display', 'block');
                                  $("#popupLocation").css('visibility', 'hidden');

                                  editrow = row;
                                  var offset = $("#jqxgrid").offset();
                                  $("#popupLocation").jqxWindow({ position: { x: '5%', y: '7.5%' } });
                                  $('#popupLocation').jqxWindow({ resizable: false });
                                  $('#popupLocation').jqxWindow({ draggable: true });
                                  $('#popupLocation').jqxWindow({ isModal: true });
                                  $("#popupLocation").css("visibility", "visible");
                                  $('#popupLocation').jqxWindow({ height: '85%', width: '90%' });
                                  $('#popupLocation').jqxWindow({ minHeight: '85%', minWidth: '90%' });
                                  $('#popupLocation').jqxWindow({ maxHeight: '90%', maxWidth: '90%' });
                                  $('#popupLocation').jqxWindow({ showCloseButton: true });
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
                                  $("#stateCombo").jqxComboBox('selectItem', dataRecord.StateId);
                                  $("#brandCombo").jqxComboBox('selectItem', dataRecord.BrandId);
                                  $("#airportCombo").jqxComboBox('selectItem', dataRecord.AirportId);
                                  $("#LocationContactEmail").val(dataRecord.LocationContactEmail);
                                  $("#SkiDataIMP").val(dataRecord.Imp);
                                  $("#SiteURL").val(dataRecord.SiteURL);
                                  $("#cityCombo").jqxComboBox('selectItem', dataRecord.CityId);
                                  $("#DistanceFromAirport").val(dataRecord.DistanceFromAirport);

                                  //sets the current selected location
                                  selectedLocationId = dataRecord.LocationId;

                                  $('#jqxTabs').jqxTabs('select', 0);
                                  $('#jqxLocationTabs').jqxTabs('select', 0);


                                  loadFeatureGrid(selectedLocationId);

                                  loadLocationImagesGrid(selectedLocationId);

                                  // show the popup window.
                                  $("#popupLocation").jqxWindow('open');
                              }
                          }
                      },
                      // loads the rest of the columns for the location grid
                      { text: 'LocationId', datafield: 'LocationId', hidden: true },
                      { text: 'Name', datafield: 'NameOfLocation', width: '20%' },
                      { text: 'Display Name', datafield: 'DisplayName', hidden: true },
                      { text: 'Short Name', datafield: 'ShortLocationName', hidden: true },
                      { text: 'Facility #', datafield: 'FacilityNumber', hidden: true },
                      { text: 'SkiData Version', datafield: 'SkiDataVersion', hidden: true },
                      { text: 'SkiData Location', datafield: 'SkiDataLocation', hidden: true },
                      { text: 'Address', datafield: 'LocationAddress', width: '15%' },
                      { text: 'City', datafield: 'LocationCity', hidden: true },
                      { text: 'Zip', datafield: 'LocationZipCode', width: '5%' },
                      { text: 'Phone', datafield: 'LocationPhoneNumber', width: '10%' },
                      { text: 'Fax', datafield: 'LocationFaxNumber', hidden: true },
                      { text: 'Capacity', datafield: 'Capacity', width: '5%' },
                      { text: 'Description', datafield: 'Description', hidden: true },
                      { text: 'Alert', datafield: 'Alert', hidden: true },
                      { text: 'Slug', datafield: 'Slug', hidden: true },
                      { text: 'Manager', datafield: 'Manager', width: '15%' },
                      { text: 'Manager Email', datafield: 'ManagerEmail', hidden: true },
                      { text: 'Daily Rate', datafield: 'DailyRate', width: '5%' },
                      { text: 'Hourly Rate', datafield: 'HourlyRate', width: '5%' },
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
                      { text: 'LocationContactEmail', datafield: 'LocationContactEmail', hidden: true },
                      { text: 'SiteURL', datafield: 'SiteURL', hidden: true },
                      { text: 'Imp', datafield: 'Imp', hidden: true },
                      { text: 'City', datafield: 'CityName', hidden: true },
                      { text: 'State', datafield: 'StateName', hidden: true },
                      { text: 'Marketing Rep', datafield: 'FirstName', cellsrenderer: function(row, column, value, defaultSettings, columnSettings, rowdata )
                            {
                                return "<div style='margin-left: 4px;margin-top:10px;'>" + value + ' ' + rowdata.LastName +"</div>";
                            }, width: '15%'
                      }
                ]
            });
        }

        //loads feature grid, requires locationID
        function loadFeatureGrid(thisLocationId) {

            var parent = $("#jqxFeatureGrid").parent();
            $("#jqxFeatureGrid").jqxGrid('destroy');
            $("<div id='jqxFeatureGrid'></div>").appendTo(parent);

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
                sortable: true,
                altrows: true,
                filterable: true,
                editable: true,
                ready: function(){
                    $("#jqxFeatureGrid").jqxGrid('sortby', 'SortOrder', 'asc');
                },
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
                            { text: 'LocationHasFeatureId', datafield: 'LocationHasFeatureId', hidden: true, editable: false },
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

        function loadLocationImagesGrid(thisLocationId) {

            //destroying images grid and recreating 
            var parent = $("#jqxLocationImagesGrid").parent();
            $("#jqxLocationImagesGrid").jqxGrid('destroy');
            $("<div id='jqxLocationImagesGrid'></div>").appendTo(parent);


            var url = $("#apiDomain").val() + "images/" + thisLocationId;

            var locationImagesSource =
            {
                datafields: [
                    { name: 'ImageId', },
                    { name: 'LocationId' },
                    { name: 'ImageUrl' },
                    { name: 'Caption', },
                    { name: 'SortOrder', }
                ],

                id: 'ImageId',
                type: 'Get',
                datatype: "json",
                url: url,
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                root: "data"
            };

            // creage location images grid
            $("#jqxLocationImagesGrid").jqxGrid(
            {
                width: '100%',
                height: 300,
                source: locationImagesSource,
                altrows: true,
                editable: true,
                ready: function () {
                    $("#jqxLocationImagesGrid").jqxGrid('sortby', 'SortOrder', 'asc');
                },
                columns: [
                            //  uncomment below to show the what you want
                            { text: 'ImageId', datafield: 'ImageId', editable: false, width: '7%' },
                            { text: 'LocationId', datafield: 'LocationId', editable: false, width: '7%' },
                            {
                                text: 'ImageUrl', datafield: 'ImageUrl', cellsrenderer: function (row, column, value, defaultSettings, columnSettings, rowdata) {
                                    return "<a class='imageLink'><div oncontextmenu='return false;'>" + value + "</div></a>";
                                }, width: '49%'
                            },
                            { text: 'Caption', datafield: 'Caption', width: '30%' },
                            { text: 'SortOrder', datafield: 'SortOrder', width: '7%' }

                ]
            });

            $('#jqxLocationImagesGrid').on('rowclick', function (event) {

                var rightclick = args.rightclick;

                if (rightclick == true) {

                    var row = event.args.rowindex;
                    var datarow = $("#jqxLocationImagesGrid").jqxGrid('getrowdata', row);
                    var source = datarow.ImageUrl;
                    var offset = $("#jqxLocationTabs").offset();

                    $("#popupImage").jqxWindow({ position: { x: '19%', y: '20%' } });
                    $('#popupImage').jqxWindow({ resizable: false });
                    $('#popupImage').jqxWindow({ draggable: true });
                    $('#popupImage').jqxWindow({ isModal: true });
                    $("#popupImage").css("visibility", "visible");
                    $('#popupImage').jqxWindow({ height: '320px', width: '50%' });
                    $('#popupImage').jqxWindow({ minHeight: '320px', minWidth: '50%' });
                    $('#popupImage').jqxWindow({ maxHeight: '500px', maxWidth: '50%' });
                    $('#popupImage').jqxWindow({ showCloseButton: true });
                    $('#popupImage').jqxWindow({ animationType: 'combined' });
                    $('#popupImage').jqxWindow({ showAnimationDuration: 300 });
                    $('#popupImage').jqxWindow({ closeAnimationDuration: 500 });
                    $("#popupImage").jqxWindow('open');
                    document.getElementById('showImage').src = "https://stage.thefastpark.com" + source;

                }

            });
        }

        //#endregion

        //#region Functions

        function SaveCharges () {
            //gets the data from the feature form to save as new feature for site
            var newFeatureId = $("#featureCombo").jqxComboBox('getSelectedItem').value;
            var newChargeAmount = $("#FeatureChargeAmount").val();
            var newChargeNote = $("#FeatureChargeNote").val();
            var newFeatureEffectiveDatetime = $("#FeatureEffectiveDatetime").val();
            var LocationHasFeatureId = $("#LocationHasFeatureId").val();


            var featurePostUrl = $("#apiDomain").val() + "locations/" + selectedLocationId + "/features/" + newFeatureId + "/charges";

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
                    alert("Saved!")
                },
                error: function (request, status, error) {
                    alert(error + " - " + request.html);
                }
            })

        }


        function addLocationImage() {
            //gets the data from the feature form to save as new feature for site
            var newLocationId = selectedLocationId
            var newImageUrl = $("#addImageUrl").val();
            var newCaption = $("#addCaption").val();
            var newSortOrder = $("#addSortOrder").val();


            var featurePostUrl = $("#apiDomain").val() + "images";

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
                    "LocationId": newLocationId,
                    "ImageUrl": newImageUrl,
                    "Caption": newCaption,
                    "SortOrder": newSortOrder
                }),
                dataType: "json",
                success: function (response) {
                    alert("Saved!");
                    $("#popupLocationImage").jqxWindow('hide');
                    loadLocationImagesGrid(newLocationId);
                },
                error: function (request, status, error) {
                    alert(error + " - " + request.html);
                }
            })

        }

        //opens the location Pop out form empty for new location
        function newLocation() {

                var offset = $("#jqxgrid").offset();
                //sets the varialbe to true so form doesn't try to load feature grid
                thisNewLocation = true;
                $("#popupLocation").jqxWindow({ position: { x: '5%', y: '7.5%' } });
                $('#popupLocation').jqxWindow({ resizable: false });
                $('#popupLocation').jqxWindow({ draggable: true });
                $('#popupLocation').jqxWindow({ isModal: true });
                $("#popupLocation").css("visibility", "visible");
                $('#popupLocation').jqxWindow({ height: '85%', width: '90%' });
                $('#popupLocation').jqxWindow({ minHeight: '85%', minWidth: '90%' });
                $('#popupLocation').jqxWindow({ maxHeight: '90%', maxWidth: '90%' });
                $('#popupLocation').jqxWindow({ showCloseButton: true });
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
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-3 col-sm-offset-9">
                            <div class="row search-size">
                                <div class="col-sm-8 col-sm-offset-4">
                                    <div class="row search-size">
                                        <div class="col-sm-12">
                                            <a href="javascript:newLocation();" id="btnNew" class="editor">New Location</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div><!-- /.container-fluid -->
    
    <div style="display:none;">
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
    <div id="popupLocation" style="display:none;">
        <div>Location Details</div>
        <div>
            <div class="modal-body">
                <div id="jqxTabs" class="tab-system">
                    <ul>
                        <li>Location</li>
                        <li>Edit Feature</li>
                        <li>Add Feature</li>
                        <li>Location Images</li>
                    </ul>
                    <div id="LocationTab" class="tab-body">
                        <div id="jqxLocationTabs" class="tab-system">
                            <ul>
                                <li>Location</li>
                                <li>Skidata</li>
                                <li>Website</li>
                                <li>Contact</li>
                            </ul>
                            <div id="locationTab" class="tab-body">
                                <div class="row">
                                    <div class="col-sm-6">
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
                                                <label for="LocationAddress" class="col-sm-3 col-md-4 control-label">Address:</label>
                                                <div class="col-sm-9 col-md-8">
                                                    <input type="text" class="form-control" id="LocationAddress" />
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
                                    <div class="col-sm-6">
                                        <div class="form-horizontal">
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
                                                <label for="cityCombo" class="col-sm-3 col-md-4 control-label">City (Legacy):</label>
                                                <div class="col-sm-9 col-md-8">
                                                    <div id="cityCombo"></div>
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
                            </div>
                            <div id="skiDataTab" class="tab-body">
                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="form-horizontal">
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
                                                <label for="SkiDataIMP" class="col-sm-3 col-md-4 control-label">IMP:</label>
                                                <div class="col-sm-9 col-md-8">
                                                    <input type="text" class="form-control" id="SkiDataIMP"  />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="websiteTab" class="tab-body">
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-horizontal">
                                            <div class="form-group">
                                                <label for="Description" class="col-sm-3 col-md-2 control-label">Description:</label>
                                                <div class="col-sm-9 col-md-10">
                                                    <textarea rows="5" class="form-control" id="Description"></textarea>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="Alert" class="col-sm-3 col-md-2 control-label">Alert:</label>
                                                <div class="col-sm-9 col-md-10">
                                                    <input type="text" class="form-control" id="Alert" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="form-horizontal">
                                            <div class="form-group">
                                                <label for="DailyRate" class="col-sm-3 col-md-4 control-label">Daily Rate:</label>
                                                <div class="col-sm-9 col-md-8">
                                                    <input type="text" class="form-control" id="DailyRate" />
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="HourlyRate" class="col-sm-3 col-md-4 control-label">Hourly Rate:</label>
                                                <div class="col-sm-9 col-md-8">
                                                    <input type="text" class="form-control" id="HourlyRate" />
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="RateText" class="col-sm-3 col-md-4 control-label">Rate Text:</label>
                                                <div class="col-sm-9 col-md-8">
                                                    <textarea rows="3" class="form-control" id="RateText"></textarea>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="MemberRateText" class="col-sm-3 col-md-4 control-label">Member Rate Text:</label>
                                                <div class="col-sm-9 col-md-8">
                                                    <textarea rows="3" class="form-control" id="MemberRateText"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="form-horizontal">
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
                                                <label for="Slug" class="col-sm-3 col-md-4 control-label">Slug:</label>
                                                <div class="col-sm-9 col-md-8">
                                                    <input type="text" class="form-control" id="Slug" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="managerTab" class="tab-body">
                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="form-horizontal">
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
                                            <div class="form-group">
                                                <label for="LocationContactEmail" class="col-sm-3 col-md-4 control-label">Location Contact Email:</label>
                                                <div class="col-sm-9 col-md-8">
                                                    <input type="text" class="form-control" id="LocationContactEmail" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <div class="top-divider">
                                    <div class="col-sm-2 col-md-3">
                                    </div>
                                    <div class="col-sm-4 col-md-3">
                                        <input type="button" id="Save" value="Save"  class="editor" />
                                    </div>
                                    <div class="col-sm-4 col-md-3">
                                        <input type="button" id="Cancel" value="Cancel" />
                                    </div>
                                    <div class="col-sm-2 col-md-3">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="editfeatureTab" class="tab-body">
                        <div class="row">
                            <div class="col-sm-12">
                                <div id="jqxFeatureGrid"></div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-horizontal">
                                    <div class="form-group">
                                        <label for="FeatureSortOrder" class="col-sm-3 col-md-4 control-label">Sort Order:</label>
                                        <div class="col-sm-9 col-md-8">
                                            <input type="text" class="form-control" id="FeatureSortOrder" />
                                            <input type="text" id="LocationHasFeatureId" style="display:none;" />
                                        </div>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="FeatureOptionalExtrasName" class="col-sm-3 col-md-4 control-label"> Optional Extras Name:</label>
                                        <div class="col-sm-9 col-md-8">
                                            <input type="text" class="form-control" id="FeatureOptionalExtrasName" />
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="FeatureOptionalExtrasDescription" class="col-sm-3 col-md-4 control-label">Optional Extras Description:</label>
                                    <div class="col-sm-9 col-md-8">
                                        <input type="text" class="form-control" id="FeatureOptionalExtrasDescription" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="MaxAvailable" class="col-sm-3 col-md-4 control-label">Max Available:</label>
                                    <div class="col-sm-9 col-md-8">
                                        <input type="text" class="form-control" id="MaxAvailable" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="FeatureAvailableDatetime" class="col-sm-3 col-md-4 control-label">Date Available:</label>
                                    <div class="col-sm-9 col-md-8">
                                        <input type="text" class="form-control" id="FeatureAvailableDatetime" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="IsDisplayed" class="col-sm-3 col-md-4 control-label">Display:</label>
                                    <div class="col-sm-9 col-md-8">
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" class="form-control" id="IsDisplayed" />
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-horizontal">
                                     <div class="form-group">
                                        <label for="FeatureChargeAmount" class="col-sm-3 col-md-4 control-label">Charge Amount:</label>
                                        <div class="col-sm-9 col-md-8">
                                            <input type="text" class="form-control" id="FeatureChargeAmount" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="FeatureOptionalExtrasDescription" class="col-sm-3 col-md-4 control-label">Charge Note:</label>
                                        <div class="col-sm-9 col-md-8">
                                            <input type="text" class="form-control" id="FeatureChargeNote" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="FeatureEffectiveDatetime" class="col-sm-3 col-md-4 control-label">Effective Date:</label>
                                        <div class="col-sm-9 col-md-8">
                                            <input type="text" class="form-control" id="FeatureEffectiveDatetime" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="col-sm-9 col-md-8">
                                            <input type="Button" class="form-control editor" id="saveCharge" value="Save Charge Info" />
                                        </div>
                                    </div>
                                    
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <div class="top-divider">
                                    <div class="col-sm-2 col-md-3">
                                    </div>
                                    <div class="col-sm-4 col-md-3">
                                        <input type="button" class="form-control editor" id="updateFeature" value="Update" />
                                    </div>
                                    <div class="col-sm-4 col-md-3">
                                        <input type="button" class="form-control" id="deleteFeature" value="Delete" />
                                    </div>
                                    <div class="col-sm-2 col-md-3">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="addFeatureTab" class="tab-body">
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-horizontal">
                                    <div class="form-group">
                                        <label for="featureCombo" class="col-sm-3 col-md-4 control-label">Feature:</label>
                                        <div class="col-sm-9 col-md-8">
                                            <div id="featureCombo"></div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="addFeatureSortOrder" class="col-sm-3 col-md-4 control-label">Sort Order:</label>
                                        <div class="col-sm-9 col-md-8">
                                            <input type="text" class="form-control" id="addFeatureSortOrder" />
                                        </div>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="addFeatureOptionalExtrasName" class="col-sm-3 col-md-4 control-label">Extras Name:</label>
                                        <div class="col-sm-9 col-md-8">
                                            <input type="text" class="form-control" id="addFeatureOptionalExtrasName" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="addFeatureOptionalExtrasDescription" class="col-sm-3 col-md-4 control-label">Extras Description:</label>
                                        <div class="col-sm-9 col-md-8">
                                            <input type="text" class="form-control" id="addFeatureOptionalExtrasDescription" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="addFeatureDisplayIcon" class="col-sm-3 col-md-4 control-label">Display Icon:</label>
                                        <div class="col-sm-9 col-md-8">
                                            <div class="checkbox">
                                                <label>
                                                    <input type="checkbox" class="form-control" id="addFeatureDisplayIcon" />
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="addFeatureIsDisplayed" class="col-sm-3 col-md-4 control-label">Display:</label>
                                        <div class="col-sm-9 col-md-8">
                                            <div class="checkbox">
                                                <label>
                                                    <input type="checkbox" class="form-control" id="addFeatureIsDisplayed" />
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-horizontal">
                                    <div class="form-group">
                                        <label for="addFeatureIsDisplayedOptionalExtra" class="col-sm-3 col-md-4 control-label">Dispaly Optional Extra:</label>
                                        <div class="col-sm-9 col-md-8">
                                            <div class="checkbox">
                                                <label>
                                                     <input type="checkbox" class="form-control" id="addFeatureIsDisplayedOptionalExtra" />
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="addFeatureMaxAvailable" class="col-sm-3 col-md-4 control-label">Max Available:</label>
                                        <div class="col-sm-9 col-md-8">
                                            <input type="text" class="form-control" id="addFeatureMaxAvailable" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="addFeatureAvailableDatetime" class="col-sm-3 col-md-4 control-label">Date Available:</label>
                                        <div class="col-sm-9 col-md-8">
                                            <input type="text" class="form-control" id="addFeatureAvailableDatetime" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="addFeatureChargeAmount" class="col-sm-3 col-md-4 control-label">Charge Amount:</label>
                                        <div class="col-sm-9 col-md-8">
                                            <input type="text" class="form-control" id="addFeatureChargeAmount" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="addFeatureChargeNote" class="col-sm-3 col-md-4 control-label">Charge Note:</label>
                                        <div class="col-sm-9 col-md-8">
                                            <input type="text" class="form-control" id="addFeatureChargeNote" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <div class="top-divider">
                                    <div class="col-sm-4 col-md-4">
                                    </div>
                                    <div class="col-sm-4 col-md-4">
                                        <input type="button" class="form-control editor" id="addFeature" value="Add" />
                                    </div>
                                    <div class="col-sm-4 col-md-4">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="locationImagesTab" class="tab-body">
                        <div class="row">
                            <div class="col-sm-12">
                                <div id="jqxLocationImagesGrid"  oncontextmenu='return false;'></div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <div class="top-divider">
                                    <div class="col-sm-4 col-md-4">
                                        <input id="updateLocationImages" type="button" value="Update" class="editor" />
                                    </div>
                                    <div class="col-sm-4 col-md-4">
                                        
                                    </div>
                                    <div class="col-sm-4 col-md-4">
                                        <input id="addLocationImages" type="button" value="Add" class="editor" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <%-- html for popup edit box --%>
    <div id="popupImage" style="display:none;" oncontextmenu='return false;'>
        <div>Location Image</div>
        <div>
            <div class="modal-body">
                <!--<iframe id="showImage" style="width:640px;height:250px;border:none;text-align:center;"></iframe>-->
                <img id="showImage" src="#" oncontextmenu='return false;' />
            </div>
        </div>
    </div>

     <%-- html for popup Add Location Image --%>
    <div id="popupLocationImage" style="display:none">
        <div>Add Location Image</div>
        <div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="addImageUrl" class="col-sm-3 col-md-4 control-label">Image URL:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="addImageUrl" placeholder="Image URL" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="addCaption" class="col-sm-3 col-md-4 control-label">Caption:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="addCaption" placeholder="Caption" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="addSortOrder" class="col-sm-3 col-md-4 control-label">Is Active:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="addSortOrder" placeholder="Sort Order" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="top-divider">
                            <div class="col-sm-3 col-md-4">
                            </div>
                            <div class="col-sm-6 col-md-4">
                                <input type="button" class="form-control" id="addImageSubmit" value="Add" />
                            </div>
                            <div class="col-sm-3 col-md-4">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>


