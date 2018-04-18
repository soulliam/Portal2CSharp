function addReservation() {
    var thisMemberId = $("#MemberId").val();;
    var thisLocationId = $("#reservationLocationCombo").jqxComboBox('getSelectedItem').value;
    var thisStartDatetime = $("#reservationStartDate").val();
    var thisEndDatetime = $("#reservationEndDate").val();;
    var thisReservationFeeId = $("#reservationFeeInputValue").val();
    var thisPaymentMethodId = $("#reservationPaymentMethodId").jqxComboBox('getSelectedItem').value;
    var thisFeeDollars = $("#reservationFeeInput").val();
    var thisFeePoints = $("#reservationFeePointsInput").val();
    if (typeof $("#reservationFeeCreditCombo").jqxComboBox('getSelectedItem') != "undefined" && $("#reservationFeeCreditCombo").jqxComboBox('getSelectedItem') != null && $("#reservationFeeCreditCombo").jqxComboBox('getSelectedItem') != '') {
        var thisReservationFeeCreditId = $("#reservationFeeCreditCombo").jqxComboBox('getSelectedItem').value;
    } else {
        var thisReservationFeeCreditId = "";
    }

    if (typeof $("#reservationFeeDiscountIdGrid").jqxGrid('getselectedrowindex') != "undefined" && $("#reservationFeeDiscountIdGrid").jqxGrid('getselectedrowindex') != null && $("#reservationFeeDiscountIdGrid").jqxGrid('getselectedrowindex') != -1) {
        var data = $('#reservationFeeDiscountIdGrid').jqxGrid('getrowdata', $("#reservationFeeDiscountIdGrid").jqxGrid('getselectedrowindex'));
        var thisReservationFeeDiscountId = data.ReservationFeeDiscountId;
    } else {
        var thisReservationFeeDiscountId = "";
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
        "FeeDollars": thisFeeDollars,
        "FeePoints": thisFeePoints,
        "ReservationFeeCreditId": thisReservationFeeCreditId,
        "ReservationFeeDiscountId": thisReservationFeeDiscountId,
        "CreditCardId": thisCreditCardId,
        "PayPalPaymentId": "",
        "PayPalPayerId": "",
        "EstimatedReservationCost": thisEstimatedReservationCost,
        "MemberNote": thisMemberNote,
        "TermsAndConditionsFlag": thisTermsAndConditionsFlag,
        "SendNotificationsFlag": thisSendNotificationsFlag,
        "SaveReservationPreferencesFlag": thisSaveReservationPreferencesFlag
    };


    data.ReservationFeatures = new Array();
    var items = $("#reservationFeatures").jqxComboBox('getCheckedItems');
    var checkedItems = "";
    $.each(items, function (index) {
        data.ReservationFeatures.push({
            "LocationHasFeatureId": this.value
        });
    });

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
        success: function () {
            swal("Reservation Created.")
        },
        error: function (request, status, error) {
            swal(error);
        },
        complete: function () {
            loadReservations(thisMemberId);
        }
    });
}


function loadReservationLocationCombo() {
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
    $("#reservationStartDate").jqxDateTimeInput({ formatString: 'MM-dd-yyyy HH:mm', showTimeButton: true, width: '400px', height: '25px' });
    $('#reservationStartDate').on('change', function (event) {
        var thisDate = event.args.date;
        var type = event.args.type;

        setReservationFee(thisDate);
    });
    $("#reservationEndDate").jqxDateTimeInput({ formatString: 'MM-dd-yyyy HH:mm', showTimeButton: true, width: '400px', height: '25px' });
}

function loadReservationFeatures(thisLocationId) {
    //set up the location combobox
    var featureSource =
    {
        datatype: "json",
        type: "Get",
        root: "data",
        datafields: [
            { name: 'FeatureName', map: 'LocationFeature>FeatureName' },
            { name: 'FeatureId', map: 'LocationFeature>FeatureId' }
        ],
        beforeSend: function (jqXHR, settings) {
            jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
            jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
        },
        //url: $("#apiDomain").val() + "locations/location-has-feature/" + thisLocationId,
        //https://api.thefastpark.com/api/v1/locations/2/features
        url: $("#apiDomain").val() + "locations/" + thisLocationId + "/features/",
    };

    var featureDataAdapter = new $.jqx.dataAdapter(featureSource);
    $("#reservationFeatures").jqxComboBox(
    {
        width: 400,
        height: 25,
        source: featureDataAdapter,
        selectedIndex: 0,
        checkboxes: true,
        displayMember: "FeatureName",
        valueMember: "FeatureId"
    });
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

function getEstCost() {
    var thisLocationId = $('#reservationLocationCombo').jqxComboBox('getSelectedItem').value;
    var thisAirport = $("#airportId").val();
    var thisStartDate = $("#reservationStartDate").val();
    var thisEndDate = $("#reservationEndDate").val();
    var url = $("#apiDomain").val() + "airports/" + thisAirport + "/locations/rates?startDatetime=" + thisStartDate + "&endDatetime=" + thisEndDate;

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
            swal(request.responseJSON.message);
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
