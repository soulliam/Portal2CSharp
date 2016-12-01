function saveUpdateMemberInfo(phoneType, phoneNumber, thisMemberId, thisUserName, thisFirstName, thisLastName, thisSuffix, thisEmailAddress, thisStreetAddress, thisStreetAddress2,
                                     thisCityName, thisStateId, thisZip, thisCompany, thisTitleId, thisMarketingCode, thisLocationId, thisCompanyId, thisGetEmail) {
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
                url: $("#apiDomain").val() + "members/" + thisMemberId,
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
                    "CorporateDiscountCode": thisMarketingCode,
                    "LocationId": thisLocationId,
                    "PhoneList": [],
                    "GetEmail": thisGetEmail,
                    "EmailReceiptsFlag": true,
                    "CompanyId": thisCompanyId
                }),
                dataType: "json",
                success: function () {
                    $('#jqxLoader').jqxLoader('close');
                    alert("Saved!");
                    
                },
                error: function (request, status, error) {
                    $('#jqxLoader').jqxLoader('close');
                    alert(status);
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
                url: $("#apiDomain").val() + "members/" + thisMemberId,
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
                    "CorporateDiscountCode": thisMarketingCode,
                    "LocationId": thisLocationId,
                    "PhoneList": [
                    {
                        "Number": phoneNumber[0],
                        "PhoneTypeId": phoneType[0]
                    }
                    ],
                    "GetEmail": thisGetEmail,
                    "EmailReceiptsFlag": true,
                    "CompanyId": thisCompanyId
                }),
                dataType: "json",
                success: function () {
                    $('#jqxLoader').jqxLoader('close');
                    alert("Saved!");
                },
                error: function (request, status, error) {
                    $('#jqxLoader').jqxLoader('close');
                    alert(error);
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
                url: $("#apiDomain").val() + "members/" + thisMemberId,
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
                    "CorporateDiscountCode": thisMarketingCode,
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
                    "GetEmail": true,
                    "EmailReceiptsFlag": true,
                    "CompanyId": thisCompanyId
                }),
                dataType: "json",
                success: function () {
                    $('#jqxLoader').jqxLoader('close');
                    alert("Saved!");
                },
                error: function (request, status, error) {
                    $('#jqxLoader').jqxLoader('close');
                    alert(error);
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
                url: $("#apiDomain").val() + "members/" + thisMemberId,
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
                    "CorporateDiscountCode": thisMarketingCode,
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
                    "GetEmail": true,
                    "EmailReceiptsFlag": true,
                    "CompanyId": thisCompanyId
                }),
                dataType: "json",
                success: function () {
                    $('#jqxLoader').jqxLoader('close');
                    alert("Saved!");
                },
                error: function (request, status, error) {
                    $('#jqxLoader').jqxLoader('close');
                    alert(error);
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
                url: $("#apiDomain").val() + "members/" + thisMemberId,
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
                    "CorporateDiscountCode": thisMarketingCode,
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
                    "GetEmail": true,
                    "EmailReceiptsFlag": true,
                    "CompanyId": thisCompanyId
                }),
                dataType: "json",
                success: function () {
                    $('#jqxLoader').jqxLoader('close');
                    alert("Saved!");
                },
                error: function (request, status, error) {
                    $('#jqxLoader').jqxLoader('close');
                    alert(error);
                },
                complete: function () {
                    $('#jqxLoader').jqxLoader('close');
                }
            });
            break;
        default:
            alert("Phone list Error");
    }
}


    