function addReservation(ReservationFeeId, ConnectionCheck) {
    var thisMemberId = $("#MemberId").val();;
    var thisLocationId = $("#reservationLocationCombo").jqxComboBox('getSelectedItem').value;
    var thisStartDatetime = $("#reservationStartDate").val();
    var thisEndDatetime = $("#reservationEndDate").val();;
    var thisReservationFeeId = ReservationFeeId;
    
    /// this must have been fixed by CoS in stage
    //if (ConnectionCheck.includes("pcafp-stg-api")) {
    //    var thisPaymentMethodId = 8;  //hard coded for payment method ID 8 "member rewards" no payment method STAGE
    //} else {
    //    var thisPaymentMethodId = 7;  //hard coded for payment method ID 8 "member rewards" no payment PRODUCTION
    //}

    var thisPaymentMethodId = 7;  //hard coded for payment method ID 8 "member rewards" no payment PRODUCTION
    
    var thisFeeDollars = $("#reservationFeeInput").val();
    var thisFeePoints = $("#reservationFeePointsInput").val();
    if (typeof $("#reservationFeeCreditCombo").jqxComboBox('getSelectedItem') != "undefined" && $("#reservationFeeCreditCombo").jqxComboBox('getSelectedItem') != null && $("#reservationFeeCreditCombo").jqxComboBox('getSelectedItem') != '') {
        var thisReservationFeeCreditId = $("#reservationFeeCreditCombo").jqxComboBox('getSelectedItem').value;
    } else {
        var thisReservationFeeCreditId = 0;
    }

    if (typeof $("#reservationFeeDiscountIdGrid").jqxGrid('getselectedrowindex') != "undefined" && $("#reservationFeeDiscountIdGrid").jqxGrid('getselectedrowindex') != null && $("#reservationFeeDiscountIdGrid").jqxGrid('getselectedrowindex') != -1) {
        var data = $('#reservationFeeDiscountIdGrid').jqxGrid('getrowdata', $("#reservationFeeDiscountIdGrid").jqxGrid('getselectedrowindex'));
        var thisReservationFeeDiscountId = data.ReservationFeeDiscountId;
    } else {
        var thisReservationFeeDiscountId = 0;
    }

    var thisCreditCardId = '';
    var thisEstimatedReservationCost = $("#EstimatedReservationCost").val();
    var thisMemberNote = $("#ReservationNote").val();;
    var thisTermsAndConditionsFlag = $("#reservationTermsAndConditionsFlag").is(":checked");
    var thisSendNotificationsFlag = $("#SendNotificationsFlag").is(":checked");
    var thisSaveReservationPreferencesFlag = true;

    var data = {
        "MemberId": thisMemberId,
        "LocationId": thisLocationId,
        "StartDatetime": thisStartDatetime,
        "EndDatetime": thisEndDatetime,
        "ReservationFeeId": thisReservationFeeId,
        "PaymentMethodId": thisPaymentMethodId,
        "FeeDollars": 0,
        "FeePoints": 0,
        "ReservationFeeCreditId": thisReservationFeeCreditId,
        "ReservationFeeDiscountId": thisReservationFeeDiscountId,
        "CreditCardId": null,
        "PayPalPaymentId": null,
        "PayPalPayerId": null,
        "ReservationSource":"undefined",
        "EstimatedReservationCost": thisEstimatedReservationCost,
        "MemberNote": thisMemberNote,
        "TermsAndConditionsFlag": thisTermsAndConditionsFlag,
        "SendNotificationsFlag": thisSendNotificationsFlag,
        "SaveReservationPreferencesFlag": thisSaveReservationPreferencesFlag,
        "CreditCard": null
    };


    data.ReservationFeatures = new Array();
    var items = $("#reservationFeatures").jqxComboBox('getCheckedItems');
    var checkedItems = "";

    $.each(items, function (index) {
        data.ReservationFeatures.push({
            "LocationHasFeatureId": this.value
        });
    });


    var test = JSON.stringify(data);

    $.ajax({
        headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "AccessToken": $("#userGuid").val(),
            "ApplicationKey": $("#AK").val()
        },
        type: "POST",
        data: JSON.stringify(data),
        url: $("#apiDomain").val() + "reservations/",
        dataType: "json",
        success: function (data) {
            swal("Reservation Created.")
        },
        error: function (message) {
            $("#popupReservation").jqxWindow('close');
            swal(message.responseJSON.message)
            .then((value) => {
                $("#popupReservation").jqxWindow('open');
            })
        },
        complete: function () {
            $('#reservationFeeDiscountIdGrid').jqxGrid('clearselection');

            $("#reservationFeeDiscountIdDDB").jqxDropDownButton('setContent', "Please Select");

            $("#reservationStartDate").jqxDateTimeInput('today');
            $("#reservationEndDate").jqxDateTimeInput('today');
            $("#reservationFeeInput").val('');
            $("#reservationFeePointsInput").val('');
            $("#reservationFeeInputValue").val('');
            $("#EstimatedReservationCost").val('');
            $("#reservationTermsAndConditionsFlag").prop('checked', false);
            $("#SendNotificationsFlag").prop('checked', false);
            $("#reservationPaymentMethodId").jqxComboBox('selectItem', 0);
            $("#ReservationNote").val('');

            var parent = $("#reservationFeatures").parent();
            $("#reservationFeatures").jqxComboBox('destroy');
            $("<div id='reservationFeatures'></div>").appendTo(parent);

            var parent = $("#reservationFeeCreditCombo").parent();
            $("#reservationFeeCreditCombo").jqxComboBox('destroy');
            $("<div id='reservationFeeCreditCombo'></div>").appendTo(parent);

            $("#popupReservation").jqxWindow('hide');
            loadReservations(thisMemberId);
        }
    });
}

function editReservation(ReservationId, ReservationFeeId, ConnectionCheck) {
    var thisMemberId = $("#MemberId").val();;
    var thisLocationId = $("#reservationLocationCombo").jqxComboBox('getSelectedItem').value;
    var thisStartDatetime = $("#reservationStartDate").val();
    var thisEndDatetime = $("#reservationEndDate").val();;
    var thisReservationFeeId = ReservationFeeId;

    //if (ConnectionCheck.includes("pcafp-stg-api")) {
    //    var thisPaymentMethodId = 8;  //hard coded for payment method ID 8 "member rewards" no payment method STAGE
    //} else {
    //    var thisPaymentMethodId = 7;  //hard coded for payment method ID 8 "member rewards" no payment PRODUCTION
    //}

    var thisPaymentMethodId = 7;

    var thisEstimatedReservationCost = $("#EstimatedReservationCost").val();
    var thisMemberNote = $("#ReservationNote").val();;
    var thisTermsAndConditionsFlag = $("#reservationTermsAndConditionsFlag").is(":checked");
    var thisSendNotificationsFlag = $("#SendNotificationsFlag").is(":checked");
    var thisSaveReservationPreferencesFlag = true;

    var data = {
        "LocationId": thisLocationId,
        "StartDatetime": thisStartDatetime,
        "EndDatetime": thisEndDatetime,
        "ReservationFeeId": thisReservationFeeId,
        "EstimatedCost": thisEstimatedReservationCost,
        "MemberNote": thisMemberNote,
        "SendNotificationsFlag": thisSendNotificationsFlag,
        "SaveReservationPreferencesFlag": thisSaveReservationPreferencesFlag,
    };


    data.ReservationFeatures = new Array();
    var items = $("#reservationFeatures").jqxComboBox('getCheckedItems');
    var checkedItems = "";

    $.each(items, function (index) {
        data.ReservationFeatures.push({
            "LocationHasFeatureId": this.value
        });
    });


    var test = JSON.stringify(data);

    $.ajax({
        headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "AccessToken": $("#userGuid").val(),
            "ApplicationKey": $("#AK").val()
        },
        type: "PUT",
        data: JSON.stringify(data),
        url: $("#apiDomain").val() + "reservations/" + ReservationId,
        dataType: "json",
        success: function (data) {
            swal("Reservation Updated.")
        },
        error: function (message) {
            $("#popupReservation").jqxWindow('close');
            swal(message.responseJSON.message)
            .then((value) => {
                $("#popupReservation").jqxWindow('open');
            })
        },
        complete: function () {
            $('#reservationFeeDiscountIdGrid').jqxGrid('clearselection');

            $("#reservationFeeDiscountIdDDB").jqxDropDownButton('setContent', "Please Select");

            $("#reservationStartDate").jqxDateTimeInput('today');
            $("#reservationEndDate").jqxDateTimeInput('today');
            $("#reservationFeeInput").val('');
            $("#reservationFeePointsInput").val('');
            $("#reservationFeeInputValue").val('');
            $("#EstimatedReservationCost").val('');
            $("#reservationTermsAndConditionsFlag").prop('checked', false);
            $("#SendNotificationsFlag").prop('checked', false);
            $("#reservationPaymentMethodId").jqxComboBox('selectItem', 0);
            $("#ReservationNote").val('');

            var parent = $("#reservationFeatures").parent();
            $("#reservationFeatures").jqxComboBox('destroy');
            $("<div id='reservationFeatures'></div>").appendTo(parent);

            var parent = $("#reservationFeeCreditCombo").parent();
            $("#reservationFeeCreditCombo").jqxComboBox('destroy');
            $("<div id='reservationFeeCreditCombo'></div>").appendTo(parent);

            $("#popupReservation").jqxWindow('hide');
            loadReservations(thisMemberId);
        }
    });
}


function loadReservationLocationCombo() {
    $("#reservationLocationCombo").jqxComboBox('clear');

    //set up the location combobox
    var locationSource =
    {
        datatype: "json",
        type: "Get",
        root: "data",
        datafields: [
            { name: 'NameOfLocation' },
            { name: 'LocationId' }
        ],
        url: $("#localApiDomain").val() + "Locations/Locations/",

    };
    var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
    $("#reservationLocationCombo").jqxComboBox(
    {
        theme: 'shinyblack',
        width: '100%',
        height: 24,
        source: locationDataAdapter,
        selectedIndex: 0,
        displayMember: "NameOfLocation",
        valueMember: "LocationId"
    });

    $("#reservationLocationCombo").on('change', function (event) {
        var thisLocationId = $("#reservationLocationCombo").jqxComboBox('getSelectedItem').value;
        loadReservationFeatures(thisLocationId)

        var url = $("#localApiDomain").val() + "Locations/GetLocationsAirportID/" + thisLocationId;
        //var url = "http://localhost:52839/api/Locations/GetLocationsAirportID/" + thisLocationId;

        $.ajax({
            type: "GET",
            url: url,
            dataType: "json",
            success: function (data) {
                $("#airportId").val(data[0].AirportId);
            },
            error: function (request, status, error) {
                swal(error);
            }
        });
    });
}

// set up reservation start date
function loadReservationCalendars() {
    $("#reservationStartDate").jqxDateTimeInput({ formatString: 'MM-dd-yyyy hh:mm tt', showTimeButton: true, width: '400px', height: '25px' });
    $('#reservationStartDate').on('change', function (event) {
        var thisDate = event.args.date;
        var type = event.args.type;
        $("#EstimatedReservationCost").val('');
        setReservationFee(thisDate);
    });
    $('#reservationEndDate').on('change', function (event) {
        $("#EstimatedReservationCost").val('');
    });
    $("#reservationEndDate").jqxDateTimeInput({ formatString: 'MM-dd-yyyy hh:mm tt', showTimeButton: true, width: '400px', height: '25px' });
}

function loadReservationFeatures(thisLocationId, checkThese) {
    $("#reservationFeatures").jqxComboBox('clear');

    url = $("#apiDomain").val() + "locations/" + thisLocationId + "/features/";

    $.ajax({
        type: "GET",
        url: url,
        dataType: "json",
        beforeSend: function (jqXHR, settings) {
            jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
            jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
        },
        success: function (thisdata) {

            removeFeatureIsDisplayedOptionalExtraFalse(thisdata);

            var source =
                {
                    localdata: thisdata,
                    datatype: "json",
                    root: "data",
                    datafields: [
                    { name: 'FeatureName', map: 'LocationFeature>FeatureName' },
                    { name: 'LocationHasFeatureId' }
                    ]
                };
            var featureDataAdapter = new $.jqx.dataAdapter(source);
            $("#reservationFeatures").jqxComboBox(
            {
                width: 400,
                height: 25,
                source: featureDataAdapter,
                selectedIndex: 0,
                checkboxes: true,
                autoDropDownHeight: true,
                displayMember: "FeatureName",
                valueMember: "LocationHasFeatureId"
            });

        },
        error: function (request, status, error) {
            $("#popupReservation").jqxWindow('close');
            swal(request.responseJSON.message)
            .then((value) => {
                $("#popupReservation").jqxWindow('open');
            })
        }

    });

    $("#reservationFeatures").on('bindingComplete', function (event) {
        if (checkThese) {
            $.each(checkThese, function (key, value) {
                var items = $("#reservationFeatures").jqxComboBox('getItems');
                var item = $("#reservationFeatures").jqxComboBox('getItemByValue', value.LocationHasFeatureId);
                item.checked = true;
                //$("#reservationFeatures").jqxComboBox('selectItem', item);
            });
        }
    });

    ////set up the ReservationFeatures combobox
    //var featureSource =
    //{
    //    datatype: "json",
    //    type: "Get",
    //    root: "data",
    //    datafields: [
    //        { name: 'FeatureName', map: 'LocationFeature>FeatureName' },
    //        { name: 'LocationHasFeatureId' }
    //    ],
    //    beforeSend: function (jqXHR, settings) {
    //        jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
    //        jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
    //    },
    //    //url: $("#apiDomain").val() + "locations/location-has-feature/" + thisLocationId,
    //    //https://api.thefastpark.com/api/v1/locations/2/features
    //    url: $("#apiDomain").val() + "locations/" + thisLocationId + "/features/",
    //};

    //var featureDataAdapter = new $.jqx.dataAdapter(featureSource);
    //$("#reservationFeatures").jqxComboBox(
    //{
    //    width: 400,
    //    height: 25,
    //    source: featureDataAdapter,
    //    selectedIndex: 0,
    //    checkboxes: true,
    //    displayMember: "FeatureName",
    //    valueMember: "LocationHasFeatureId"
    //});
}

function loadReservationPaymentMethodId() {
    var data = [
                { id: 2, title: "Use My Points" },
                { id: 3, title: "Reservation Fee Credit" },
                { id: 4, title: "Reservation Fee Discount Code" }
    ];

    var source =
    {
        localdata: data,
        datatype: "array",
        datafields: [
        { name: 'id' },
        { name: 'title' }
        ]
    };

    var featureDataAdapter = new $.jqx.dataAdapter(source);
    $("#reservationPaymentMethodId").jqxComboBox(
    {
        width: 400,
        height: 25,
        source: featureDataAdapter,
        selectedIndex: 0,
        displayMember: "title",
        valueMember: "id"
    });

    $("#reservationPaymentMethodId").on('select', function (event) {
        if (event.args) {

            var item = event.args.item;
            if (item) {
                switch(item.value)
                {
                    case "2":

                        break;
                    case "3":
                        getReservationFeeCredit();

                        break;
                    case "4":
                        getReservationFeeDiscountId();
                        break;
                }
            }
        }
    });

    
}

function getReservationFeeDiscountId() {


    //Get discount codes for Member
    var thisMemberId = $("#MemberId").val();
    var url = $("#apiDomain").val() + "discount-codes?MemberId=" + thisMemberId;

    $("#reservationFeeDiscountIdDDB").jqxDropDownButton({
        width: 400, height: 25
    });

    $("#reservationFeeDiscountIdDDB").jqxDropDownButton('setContent', "Please Select");

    var source =
    {
        id: 'CardId',
        type: 'Get',
        datatype: "json",
        url: url,
        beforeSend: function (jqXHR, settings) {
            jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
            jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
        },
        root: "data",
        pagesize: 5,
        datafields:
        [
            { name: 'ReservationFeeDiscountId' },
            { name: 'DiscountCode' },
            { name: 'EffectiveDatetime' },
            { name: 'ExpiresDatetime' },
            { name: 'MaxUseCount' },
            { name: 'ActualUseCount' },
            { name: 'MemberId' },
            { name: 'IsValid' }
        ],

    };
    var dataAdapter = new $.jqx.dataAdapter(source);
    $("#reservationFeeDiscountIdGrid").jqxGrid(
    {
        width: 600,
        source: dataAdapter,
        height: 250,
        columnsresize: true,
        columns: [
                { text: 'ReservationFeeDiscountId', datafield: 'ReservationFeeDiscountId', hidden: true },
                { text: 'DiscountCode', datafield: 'DiscountCode' },
                { text: 'EffectiveDatetime', datafield: 'EffectiveDatetime', cellsrenderer: DateTimeRender },
                { text: 'ExpiresDatetime', datafield: 'ExpiresDatetime', cellsrenderer: DateTimeRender },
                { text: 'MaxUseCount', datafield: 'MaxUseCount', hidden: true },
                { text: 'ActualUseCount', datafield: 'ActualUseCount', hidden: true },
                { text: 'MemberId', datafield: 'MemberId', hidden: true },
                { text: 'IsValid', datafield: 'IsValid' }
        ]
    });

    $("#reservationFeeDiscountIdGrid").on('rowselect', function (event) {
        var args = event.args;
        var row = $("#reservationFeeDiscountIdGrid").jqxGrid('getrowdata', args.rowindex);
        
        var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + row['DiscountCode'] + '<label id="thisDiscountCodeId" style="visibility:hidden">' + row['ReservationFeeDiscountId'] + '</label></div>';
        $("#reservationFeeDiscountIdDDB").jqxDropDownButton('setContent', dropDownContent);
        
        $('#reservationFeeDiscountIdDDB').jqxDropDownButton('close');
    });

}

function setReservationFee(thisDate) {

    var justDate = DateFormat(thisDate);
    var thisLocationId = $('#reservationLocationCombo').jqxComboBox('getSelectedItem').value;
    var thisMemberId = $("#MemberId").val();
    var url = $("#apiDomain").val() + "reservation-fees?locationId=" + thisLocationId + "&startDatetime=" + justDate;


    $.ajax({
        type: "GET",
        url: url,
        dataType: "json",
        beforeSend: function (jqXHR, settings) {
            jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
            jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
        },
        success: function (data) {
            $("#reservationFeeInput").val(data.result.data.FeeDollars);
            $("#reservationFeeInputValue").val(data.result.data.ReservationFeeId);
            $("#reservationFeePointsInput").val(data.result.data.FeePoints);
        },
        error: function (request, status, error) {
            swal(error);
        }
    });


    
}

function getEstCost(MemberId) {
    var thisLocationId = $('#reservationLocationCombo').jqxComboBox('getSelectedItem').value;
    var thisAirport = $("#airportId").val();
    var thisStartDate = $("#reservationStartDate").val();
    var thisEndDate = $("#reservationEndDate").val();
    //var url = $("#apiDomain").val() + "airports/" + thisAirport + "/locations/rates?startDatetime=" + thisStartDate + "&endDatetime=" + thisEndDate;
    var url = $("#apiDomain").val() + "airports/" + thisAirport + "/locations/rates?MemberId=" + MemberId + "&StartDatetime=" + thisStartDate + "&EndDatetime=" + thisEndDate;

    $.ajax({
        type: "GET",
        url: url,
        dataType: "json",
        beforeSend: function (jqXHR, settings) {
            jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
            jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
        },
        success: function (data) {
            for (i = 0; i < data.result.ResultCount; i++) {
                if (data.result.data.Locations[i].LocationId == thisLocationId){
                    $("#EstimatedReservationCost").val(data.result.data.Locations[i].Charges.EstimatedTotalCharges);
                }
            }
        },
        error: function (request, status, error) {
            $("#popupReservation").jqxWindow('close');
            swal(request.responseJSON.message)
            .then((value) => {
                $("#popupReservation").jqxWindow('open');
            })
        }
    });

}

function getReservationFeeCredit() {
    var thisMemberId = $("#MemberId").val();

    var thisURL = $("#apiDomain").val() + "reservation-credits-reservation/members/" + thisMemberId;

    //set up the location combobox
    var locationSource =
    {
        datatype: "json",
        type: "Get",
        root: "data",
        datafields: [
            { name: 'CreatedDatetime' },
            { name: 'ReservationFeeCreditId' }
        ],
        beforeSend: function (jqXHR, settings) {
            jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
        },
        url: $("#apiDomain").val() + "reservation-credits-reservation/members/" + thisMemberId,
    };

    $("#reservationFeeCreditCombo").on('bindingComplete', function (event) {
        var item = $("#reservationFeeCreditCombo").jqxComboBox('getItem', 0);

        if (item == '') {
            return;
        }

        //$("#reservationFeeCreditCombo").jqxComboBox('insertAt', '', 0);
        //$("#reservationFeeCreditCombo").jqxComboBox('selectItem', 0);
    });

    var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
    $("#reservationFeeCreditCombo").jqxComboBox(
    {
        width: 400,
        height: 25,
        source: locationDataAdapter,
        selectedIndex: 0,
        displayMember: "CreatedDatetime",
        valueMember: "ReservationFeeCreditId"
    });

};

function removeFeatureIsDisplayedOptionalExtraFalse(data) {
    for (var i = 0; i < data.result.data.length; i++) {
        if (data.result.data[i].IsDisplayedOptionalExtra == false) {
            data.result.data.splice(i, 1);
            removeFeatureIsDisplayedOptionalExtraFalse(data);
        }
    }
}

function getReservationByID(ReservationId) {

    var url = $("#apiDomain").val() + "reservations/" + ReservationId;

    $.ajax({
        type: "GET",
        url: url,
        dataType: "json",
        beforeSend: function (jqXHR, settings) {
            jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
            jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
        },
        success: function (data) {
            var thisLocationId = data.result.data.LocationInformation.LocationId;
            loadReservationFeatures(thisLocationId);
            

            $("#popupReservation").css('display', 'block');
            $("#popupReservation").css('visibility', 'hidden');

            var offset = $("#jqxMemberInfoTabs").offset();
            $("#popupReservation").jqxWindow({ position: { x: '10%', y: '5%' } });
            $('#popupReservation').jqxWindow({ resizable: false });
            $('#popupReservation').jqxWindow({ draggable: true });
            $('#popupReservation').jqxWindow({ isModal: true });
            $("#popupReservation").css("visibility", "visible");
            $('#popupReservation').jqxWindow({ height: '475px', width: '800px' });
            $('#popupReservation').jqxWindow({ minHeight: '400px', minWidth: '800px' });
            $('#popupReservation').jqxWindow({ maxHeight: '650px', maxWidth: '800px' });
            $('#popupReservation').jqxWindow({ showCloseButton: false });
            $('#popupReservation').jqxWindow({ animationType: 'combined' });
            $('#popupReservation').jqxWindow({ showAnimationDuration: 300 });
            $('#popupReservation').jqxWindow({ closeAnimationDuration: 500 });
            $("#popupReservation").jqxWindow('open');

            getReservationFeeCredit();
            $("#reservationLocationCombo").jqxComboBox('selectItem', thisLocationId);
            $("#reservationPaymentMethodId").jqxComboBox('selectItem', 3);
            $("#reservationFeeCreditCombo").jqxComboBox('selectItem', 3);

            $('#reservationStartDate').jqxDateTimeInput('setDate', new Date(data.result.data.StartDatetime));
            $('#reservationEndDate').jqxDateTimeInput('setDate', new Date(data.result.data.EndDatetime));
            $('#EstimatedReservationCost').val(data.result.data.EstimatedCost);
            $('#ReservationNote').val(data.result.data.MemberNote);
            $('#reservationTermsAndConditionsFlag').attr('checked', data.result.data.SaveReservationPreferencesFlag);
            $('#SendNotificationsFlag').attr('checked', data.result.data.SendNotificationsFlag);

            var checkThese = data.result.data.ReservationFeatures;

            loadReservationFeatures(thisLocationId, checkThese);

            
            
        },
        error: function (request, status, error) {
            $("#popupReservation").jqxWindow('close');
            swal(request.responseJSON.message)
            .then((value) => {
                $("#popupReservation").jqxWindow('open');
            })
        }
    });

}
