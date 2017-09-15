function saveUpdateMemberInfo(phoneType, phoneNumber, thisMemberId, thisUserName, thisFirstName, thisLastName, thisSuffix, thisEmailAddress, thisStreetAddress, thisStreetAddress2,
                                     thisCityName, thisStateId, thisZip, thisCompany, thisTitleId, thisMarketingCode, thisLocationId, thisCompanyId, thisGetEmail, thisMarketingMailerCode, RFR) {
    if (RFR == true) {
        url = $("#apiDomain").val() + "members/" + thisMemberId + "?SendEmail=false";
    } else {
        url = $("#apiDomain").val() + "members/" + thisMemberId;
    }

    var thisTEST = JSON.stringify({
        "UserName": thisUserName,
        "FirstName": thisFirstName,
        "LastName": thisLastName,
        "Suffix": "",
        "EmailAddress": thisEmailAddress,
        "StreetAddress": thisStreetAddress,
        "StreetAddress2": thisStreetAddress2,
        "CityName": thisCityName,
        "StateId": thisStateId,
        "Zip": thisZip,
        "Password": "",
        "VerifyPassword": "",
        "Company": thisCompany,
        "TitleId": thisTitleId,
        "CorporateDiscountCode": "",
        "LocationId": thisLocationId,
        "PhoneList": [],
        "CompanyId": thisCompanyId,
        "MarketingCode": thisMarketingCode,
        "CorporateDiscountCode": thisMarketingMailerCode
    });

    //data = JSON.stringify({
    //    "UserName": thisUserName,
    //    "FirstName": thisFirstName,
    //    "LastName": thisLastName,
    //    "Suffix": "",
    //    "EmailAddress": thisEmailAddress,
    //    "StreetAddress": thisStreetAddress,
    //    "StreetAddress2": thisStreetAddress2,
    //    "CityName": thisCityName,
    //    "StateId": thisStateId,
    //    "Zip": thisZip,
    //    "Password": "",
    //    "VerifyPassword": "",
    //    "Company": thisCompany,
    //    "TitleId": thisTitleId,
    //    "MarketingCode": thisMarketingCode,
    //    "LocationId": thisLocationId,
    //    "PhoneList": [
    //    {
    //        "Number": phoneNumber[0],
    //        "PhoneTypeId": phoneType[0]
    //    }
    //    ],
    //    "GetEmail": thisGetEmail,
    //    "EmailReceiptsFlag": true,
    //    "CompanyId": thisCompanyId
    //});
    

    switch (phoneType.length) {
        case 0:
            $.ajax({
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": $("#userGuid").val(),
                    "ApplicationKey": $("#AK").val()
                },
                type: "PUT",
                url: url,
                data: JSON.stringify({
                    "UserName": thisUserName,
                    "FirstName": thisFirstName,
                    "LastName": thisLastName,
                    "Suffix": "",
                    "EmailAddress": thisEmailAddress,
                    "StreetAddress": thisStreetAddress,
                    "StreetAddress2": thisStreetAddress2,
                    "CityName": thisCityName,
                    "StateId": thisStateId,
                    "Zip": thisZip,
                    "Password": "",
                    "VerifyPassword": "",
                    "Company": thisCompany,
                    "TitleId": thisTitleId,
                    "CorporateDiscountCode": "",
                    "LocationId": thisLocationId,
                    "PhoneList": [],
                    "CompanyId": thisCompanyId,
                    "MarketingCode": thisMarketingCode,
                    "CorporateDiscountCode": thisMarketingMailerCode
                }),
                dataType: "json",
                success: function () {
                    $('#jqxLoader').jqxLoader('close');
                    swal("Saved!");
                    
                },
                error: function (request, status, error) {
                    $('#jqxLoader').jqxLoader('close');
                    swal(error + " - " + request.responseJSON.message);
                },
                complete: function () {
                    $('#jqxLoader').jqxLoader('close');
                }
            });
            break;
        case 1:
            $.ajax({
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": $("#userGuid").val(),
                    "ApplicationKey": $("#AK").val()
                },
                type: "PUT",
                url: url,
                data: JSON.stringify({
                    "UserName": thisUserName,
                    "FirstName": thisFirstName,
                    "LastName": thisLastName,
                    "Suffix": "",
                    "EmailAddress": thisEmailAddress,
                    "StreetAddress": thisStreetAddress,
                    "StreetAddress2": thisStreetAddress2,
                    "CityName": thisCityName,
                    "StateId": thisStateId,
                    "Zip": thisZip,
                    "Password": "",
                    "VerifyPassword": "",
                    "Company": thisCompany,
                    "TitleId": thisTitleId,
                    "CorporateDiscountCode": "",
                    "LocationId": thisLocationId,
                    "PhoneList": [
                    {
                        "Number": phoneNumber[0],
                        "PhoneTypeId": phoneType[0]
                    }
                    ],
                    "CompanyId": thisCompanyId,
                    "MarketingCode": thisMarketingCode,
                    "CorporateDiscountCode": thisMarketingMailerCode
                }),
                dataType: "json",
                success: function () {
                    $('#jqxLoader').jqxLoader('close');
                    swal("Saved!");
                },
                error: function (request, status, error) {
                    $('#jqxLoader').jqxLoader('close');
                    swal(error + " - " + request.responseJSON.message);
                },
                complete: function () {
                    $('#jqxLoader').jqxLoader('close');
                }
            });
            break;
        case 2:
            $.ajax({
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": $("#userGuid").val(),
                    "ApplicationKey": $("#AK").val()
                },
                type: "PUT",
                url: url,
                data: JSON.stringify({
                    "UserName": thisUserName,
                    "FirstName": thisFirstName,
                    "LastName": thisLastName,
                    "Suffix": "",
                    "EmailAddress": thisEmailAddress,
                    "StreetAddress": thisStreetAddress,
                    "StreetAddress2": thisStreetAddress2,
                    "CityName": thisCityName,
                    "StateId": thisStateId,
                    "Zip": thisZip,
                    "Password": "",
                    "VerifyPassword": "",
                    "Company": thisCompany,
                    "TitleId": thisTitleId,
                    "CorporateDiscountCode": "",
                    "LocationId": thisLocationId,
                    "PhoneList": [
                    {
                        "Number": phoneNumber[0],
                        "PhoneTypeId": phoneType[0]
                    },
                    {
                        "Number": phoneNumber[1],
                        "PhoneTypeId": phoneType[1]
                    }
                    ],
                    "CompanyId": thisCompanyId,
                    "MarketingCode": thisMarketingCode,
                    "CorporateDiscountCode": thisMarketingMailerCode
                }),
                dataType: "json",
                success: function () {
                    $('#jqxLoader').jqxLoader('close');
                    swal("Saved!");
                },
                error: function (request, status, error) {
                    $('#jqxLoader').jqxLoader('close');
                    swal(error + " - " + request.responseJSON.message);
                },
                complete: function () {
                    $('#jqxLoader').jqxLoader('close');
                }
            });
            break;
        case 3:
            $.ajax({
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": $("#userGuid").val(),
                    "ApplicationKey": $("#AK").val()
                },
                type: "PUT",
                url: url,
                data: JSON.stringify({
                    "UserName": thisUserName,
                    "FirstName": thisFirstName,
                    "LastName": thisLastName,
                    "Suffix": "",
                    "EmailAddress": thisEmailAddress,
                    "StreetAddress": thisStreetAddress,
                    "StreetAddress2": thisStreetAddress2,
                    "CityName": thisCityName,
                    "StateId": thisStateId,
                    "Zip": thisZip,
                    "Password": "",
                    "VerifyPassword": "",
                    "Company": thisCompany,
                    "TitleId": thisTitleId,
                    "CorporateDiscountCode": "",
                    "LocationId": thisLocationId,
                    "PhoneList": [
                    {
                        "Number": phoneNumber[0],
                        "PhoneTypeId": phoneType[0]
                    },
                    {
                        "Number": phoneNumber[1],
                        "PhoneTypeId": phoneType[1]
                    },
                    {
                        "Number": phoneNumber[2],
                        "PhoneTypeId": phoneType[2]
                    }
                    ],
                    "CompanyId": thisCompanyId,
                    "MarketingCode": thisMarketingCode,
                    "CorporateDiscountCode": thisMarketingMailerCode
                }),
                dataType: "json",
                success: function () {
                    $('#jqxLoader').jqxLoader('close');
                    swal("Saved!");
                },
                error: function (request, status, error) {
                    $('#jqxLoader').jqxLoader('close');
                    swal(error + " - " + request.responseJSON.message);
                },
                complete: function () {
                    $('#jqxLoader').jqxLoader('close');
                }
            });
            break;
        case 4:
            $.ajax({
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": $("#userGuid").val(),
                    "ApplicationKey": $("#AK").val()
                },
                type: "PUT",
                url: url,
                data: JSON.stringify({
                    "UserName": thisUserName,
                    "FirstName": thisFirstName,
                    "LastName": thisLastName,
                    "Suffix": "",
                    "EmailAddress": thisEmailAddress,
                    "StreetAddress": thisStreetAddress,
                    "StreetAddress2": thisStreetAddress2,
                    "CityName": thisCityName,
                    "StateId": thisStateId,
                    "Zip": thisZip,
                    "Password": "",
                    "VerifyPassword": "",
                    "Company": thisCompany,
                    "TitleId": thisTitleId,
                    "CorporateDiscountCode": "",
                    "LocationId": thisLocationId,
                    "PhoneList": [
                    {
                        "Number": phoneNumber[0],
                        "PhoneTypeId": phoneType[0]
                    },
                    {
                        "Number": phoneNumber[1],
                        "PhoneTypeId": phoneType[1]
                    },
                    {
                        "Number": phoneNumber[2],
                        "PhoneTypeId": phoneType[2]
                    },
                    {
                        "Number": phoneNumber[3],
                        "PhoneTypeId": phoneType[3]
                    }
                    ],
                    "CompanyId": thisCompanyId,
                    "MarketingCode": thisMarketingCode,
                    "CorporateDiscountCode": thisMarketingMailerCode
                }),
                dataType: "json",
                success: function () {
                    $('#jqxLoader').jqxLoader('close');
                    swal("Saved!");
                },
                error: function (request, status, error) {
                    $('#jqxLoader').jqxLoader('close');
                    swal(error + " - " + request.responseJSON.message);
                },
                complete: function () {
                    $('#jqxLoader').jqxLoader('close');
                }
            });
            break;
        default:
            swal("Phone list Error");
    }
}

function saveEmailPrefs(thisMemberId, EmailReceiptsFlag, GetEmail, TravelAlertsEmailFlag, RedeemEmailFlag, ProfileUpdateEmailFlag, ReservationChangeEmailFlag, ReservationConfirmationEmailFlag, ReservationReminderFlag) {
    var url = $("#apiDomain").val() + "members/" + thisMemberId + "/email-preferences";

    $.ajax({
        headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "AccessToken": $("#userGuid").val(),
            "ApplicationKey": $("#AK").val()
        },
        type: "PUT",
        url: url,
        data: JSON.stringify({
            "EmailReceiptsFlag": EmailReceiptsFlag,
            "GetEmail": GetEmail,
            "TravelAlertsEmailFlag": TravelAlertsEmailFlag,
            "RedeemEmailFlag": RedeemEmailFlag,
            "ProfileUpdateEmailFlag": ProfileUpdateEmailFlag,
            "ReservationChangeEmailFlag": ReservationChangeEmailFlag,
            "ReservationConfirmationEmailFlag": ReservationConfirmationEmailFlag,
            "ReservationReminderFlag": ReservationReminderFlag
        }),
        dataType: "json",
        success: function () {
        },
        error: function (request, status, error) {
            swal(error + " - " + request.responseJSON.message);
        },
        complete: function () {
        }
    });
}


    