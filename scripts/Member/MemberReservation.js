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
        width: 400,
        height: 25,
        source: locationDataAdapter,
        selectedIndex: 0,
        displayMember: "NameOfLocation",
        valueMember: "LocationId"
    });
    $("#reservationLocationCombo").on('select', function (event) {
        if (event.args) {

            var item = event.args.item;
            if (item) {
                var featureLocation = $('#reservationLocationCombo').jqxComboBox('getSelectedItem').value

                loadReservationFeatures(featureLocation);
            }
        }
    });

}

// set up reservation start date
function loadReservationCalendars() {
    $("#reservationStartDate").jqxDateTimeInput({ formatString: 'MM-dd-yyyy', width: '400px', height: '25px' });
    $('#reservationStartDate').on('change', function (event) {
        var thisDate = event.args.date;
        var type = event.args.type;

        setReservationFee(thisDate);
    });
    $("#reservationEndDate").jqxDateTimeInput({ formatString: 'MM-dd-yyyy', width: '400px', height: '25px' }); reservationEndDate
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
        },
        url: $("#apiDomain").val() + "locations/" + thisLocationId + "/features",

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
                { id: 1, title: "Use New Card" },
                { id: 2, title: "Use My Points" },
                { id: 3, title: "Reservation Fee Credit" },
                { id: 4, title: "Reservation Fee Discount Code" },
                { id: 5, title: "Use Existing Card" }
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
                    case "1":
                        $("#reservationSavedCreditCardInfo").hide(); 
                        $("#reservationFeeDollars").hide();
                        $("#reservationFeePoints").hide();
                        $("#reservationFeeDiscountIdDDB").hide();
                        $("#reservationFeeCreditId").hide();
                        $("#reservationCreditCardInfo").show();
                        break;
                    case "2":

                        break;
                    case "3":
                        getReservationFeeCredit();
                        break;
                    case "4":
                        getReservationFeeDiscountId();
                        break;
                    case "5":
                        getExistingCreditCards();
                        break;
                }
            }
        }
    });

    function getReservationFeeCredit() {
        var thisMemberId = $("#MemberId").val();

        $.ajax({
            headers: {
                "Accept": "application/json",
                "Content-Type": "application/json",
                "AccessToken": $("#userGuid").val(),
                "ApplicationKey": $("#AK").val()
            },
            type: "GET",
            url: $("#apiDomain").val() + "reservation-credits-reservation/members/" + thisMemberId,
            dataType: "json",
            success: function (thisData) {
                reservationFeeDollars
                $("#reservationSavedCreditCardInfo").hide();
                $("#reservationCreditCardInfo").hide();
                $("#reservationFeeDollars").hide();
                $("#reservationFeePoints").hide();
                $("#reservationFeeDiscountIdDDB").hide();
                $("#reservationFeeCreditId").show();
                $("#reservationFeeCreditId").val(thisData.result.data[0].ReservationFeeCreditId);
            },
            error: function (request, status, error) {
                alert("Error retrieving reservation credit fee");
            },
            complete: function () {

            }
        });
    };
}

function getReservationFeeDiscountId() {
    //Get discount codes for Member
    var thisMemberId = $("#MemberId").val();
    var url = $("#apiDomain").val() + "discount-codes?MemberId=" + thisMemberId;

    $("#reservationFeeDiscountIdDDB").jqxDropDownButton({
        width: 400, height: 25
    });
    $("#reservationSavedCreditCardInfo").hide();
    $("#reservationCreditCardInfo").hide();
    $("#reservationFeeDollars").hide();
    $("#reservationFeePoints").hide();
    $("#reservationFeeCreditId").hide();
    $("#reservationFeeDiscountIdDDB").show();
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
        width: 1000,
        source: dataAdapter,
        pageable: true,
        autoheight: true,
        columnsresize: true,
        columns: [
                { text: 'ReservationFeeDiscountId', datafield: 'ReservationFeeDiscountId', hidden: true },
                { text: 'DiscountCode', datafield: 'DiscountCode' },
                { text: 'EffectiveDatetime', datafield: 'EffectiveDatetime' },
                { text: 'ExpiresDatetime', datafield: 'ExpiresDatetime' },
                { text: 'MaxUseCount', datafield: 'MaxUseCount' },
                { text: 'ActualUseCount', datafield: 'ActualUseCount' },
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

function getExistingCreditCards() {
    $("#reservationCreditCardInfo").hide();
    $("#reservationFeeDollars").hide();
    $("#reservationFeePoints").hide();
    $("#reservationFeeDiscountIdDDB").hide();
    $("#reservationFeeCreditId").hide();
    $("#reservationSavedCreditCardInfo").show();

    var thisMemberId = $("#MemberId").val();

    var locationSource =
    {
        datatype: "json",
        type: "Get",
        root: "data",
        datafields: [
            { name: 'CardMaskedNo' },
            { name: 'CreditCardId' }
        ],
        beforeSend: function (jqXHR, settings) {
            jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
            jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
        },
        url: $("#apiDomain").val() + "members/" + thisMemberId + "/credit-cards",

    };
    var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
    $("#reservationSavedCreditCards").jqxComboBox(
    {
        width: 400,
        height: 25,
        source: locationDataAdapter,
        selectedIndex: 0,
        displayMember: "CardMaskedNo",
        valueMember: "CreditCardId"
    });

    $("#reservationSavedCreditCardInfo").show();

}

function setReservationFee(thisDate) {
    var thisLocationId = $('#reservationLocationCombo').jqxComboBox('getSelectedItem').value;

    var justDate = DateFormat(thisDate);

    alert(justDate);
    var reservationFeeIdSource =
    {
        datatype: "json",
        type: "Get",
        root: "data",
        datafields: [
            { name: 'FeeDollars', cellsformat: 'c2' },
            { name: 'ReservationFeeId' }
        ],
        beforeSend: function (jqXHR, settings) {
            jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
            jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
        },
        url: $("#apiDomain").val() + "reservation-fees?locationId=" + thisLocationId + "&startDatetime=" + justDate,

    };
    var reservationFeeIdDataAdapter = new $.jqx.dataAdapter(reservationFeeIdSource);
    $("#reservationFeeIdCombo").jqxComboBox(
    {
        width: 400,
        height: 25,
        source: reservationFeeIdDataAdapter,
        selectedIndex: 0,
        displayMember: "FeeDollars",
        valueMember: "ReservationFeeId"
    });
}

