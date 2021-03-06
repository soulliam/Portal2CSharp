﻿//Security Setup
function Security() {
    var editorArray = new Array();
    var editorCount = 0;
    var parentArray = new Array();

    //Set entire memu to disabled.  Grab the old href if pointer-events not supported
    $('.menuSecurity').each(function () {
        $('.menuSecurity').addClass('disabled');
        var old = $(this).attr('href');
        $(this).attr('temp-hrf', old);   // store real href in data-hrf attribute
        $(this).attr('href', '#');
    });



    $('.editor').each(function () {
        ////this will actually remove editor elements from the dom after creating them
        //var editor = this;
        //var parent = $(this).parent();

        //$(this).detach();

        //editorArray[editorCount] = editor;
        //parentArray[editorCount] = parent;

        //editorCount = editorCount + 1;

        $(this).addClass('disabled');
    });

    $('.RFR').each(function () {
        $(this).addClass('disabled');
        $(this).prop("disabled", true);
    });

    $('.MANAGER').each(function () {
        $(this).addClass('disabled');
        $(this).prop("disabled", true);
    });
    
    // enable all Supreradmin elements set href to stored href in case pointer-events not supported
    if (group.indexOf("Portal_Superadmin") > -1) {
        $('.Portal_Superadmin').each(function () {
            $('.Portal_Superadmin').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', old);
        });

        $('.editor').each(function () {
            $(this).removeClass('disabled');
        });

        $('.MANAGER').each(function () {
            $(this).removeClass('disabled');
            $(this).prop("disabled", false);
        });

        $('.RFR').each(function () {
            $(this).removeClass('disabled');
            $(this).prop("disabled", false);
        });

        $("#nameDropHREF").attr("data-toggle", "dropdown");
        $("#nameDropHREF").addClass("dropdown-toggle");
        $("#nameDropCaret").css("display", "block");

        //// this will reattache removed elements to the Dom
        //var arrayLength = editorArray.length;
        //for (var i = 0; i < arrayLength; i++) {
        //    parentArray[i].append(editorArray[i]);
        //}
    }

    if (group.indexOf("Portal_RFR") > -1) {
        $('.Portal_RFR').each(function () {
            $('.Portal_RFR').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', old);
        });

        $('.editor').each(function () {
            $(this).removeClass('disabled');
        });

        $('.RFR').each(function () {
            $(this).removeClass('disabled');
            $(this).prop("disabled", false);
        });
    }

    if (group.indexOf("Portal_Manager") > -1) {
        $('.Portal_Manager').each(function () {
            $('.Portal_Manager').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', old);
        });

        $('.editor').each(function () {
            $(this).removeClass('disabled');
        });

        $('.MANAGER').each(function () {
            $(this).removeClass('disabled');
            $(this).prop("disabled", false);
        });
    }

    if (group.indexOf("Portal_Asstmanager") > -1) {
        $('.Portal_Asstmanager').each(function () {
            $('.Portal_Asstmanager').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', old);
        });

        $('.editor').each(function () {
            $(this).removeClass('disabled');
        });
    }

    if (group.indexOf("Portal_CarCount") > -1) {
        $('.Portal_CarCount').each(function () {
            $('.Portal_CarCount').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', old);
        });
    }

    if (group.indexOf("Portal_Legal") > -1) {
        $('.Portal_Legal').each(function () {
            $('.Portal_Legal').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', old);
        });
    }

    if (group.indexOf("Portal_Siteadmin") > -1) {
        $('.Portal_Siteadmin').each(function () {
            $('.Portal_Siteadmin').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', old);
        });
    }

    if (group.indexOf("Portal_Auditadmin") > -1) {
        $('.Portal_Auditadmin').each(function () {
            $('.Portal_Auditadmin').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', old);
        });
    }

    if (group.indexOf("Portal_Insurance") > -1) {
        $('.Portal_Insurance').each(function () {
            $('.Portal_Insurance').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', old);
        });
    }

    if (group.indexOf("InsApp_Regional") > -1) {
        $('.InsApp_Regional').each(function () {
            $('.InsApp_Regional').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', old);
        });
    }

    if (group.indexOf("InsApp_Other") > -1) {
        $('.InsApp_Other').each(function () {
            $('.InsApp_Other').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', old);
        });
    }

    if (group.indexOf("Portal_Marketing") > -1) {
        $('.Portal_Marketing').each(function () {
            $('.Portal_Marketing').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', old);
        });
    }

    if (group.indexOf("Portal_Mechanic") > -1) {
        $('.Portal_Mechanic').each(function () {
            $('.Portal_Mechanic').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', old);
        });
    }

    if (group.indexOf("Portal_Users") > -1) {
        $('.Portal_Users').each(function () {
            $('.Portal_Users').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', old);
        });
    }

    if (group.indexOf("Portal_Vehiclesadmin") > -1) {
        $('.Portal_Vehiclesadmin').each(function () {
            $('.Portal_Vehiclesadmin').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', (old));
        });
    }

    if (group.indexOf("Booth") > -1 && group.indexOf("BoothOnly") < 0) {
        $('.Booth').each(function () {
            $('.Booth').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', old);
        });
    }

    if (group.indexOf("Portal_Couponadmin") > -1) {
        $('.Portal_Couponadmin').each(function () {
            $('.Portal_Couponadmin').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', old);
        });
    }

    if (group.indexOf("Portal_Parkplace") > -1) {
        $('.Portal_Parkplace').each(function () {
            $('.Portal_Parkplace').removeClass('disabled');
            var old = $(this).attr('temp-hrf');
            if (old != "") $(this).attr('href', old);
        });
    }
}

function turnOffAutoComplete() {
    if (document.getElementsByTagName) {
        var inputElements = document.getElementsByTagName("input");
        for (i = 0; inputElements[i]; i++) {
            if (!inputElements[i].hasAttribute("autocomplete")) {
                inputElements[i].setAttribute("autocomplete", "smartystreets");
            }
        }
    }
}

function isValidDate(s) {
    var d = new Date(s);
    return d.toString();
}

//render dates for grid
var DateRender = function (row, columnfield, value, defaulthtml, columnproperties) {
    // format date as string due to inconsistant date coversions
    switch (true) {
        case (value == '0001-01-01T00:00:00'):
            return '<div style="margin-top: 10px;margin-left: 5px">&nbsp;</div>';
            break;
        case (value == '1900-01-01T00:00:00'):
            return '<div style="margin-top: 10px;margin-left: 5px">&nbsp;</div>';
            break;
        case (String(value).indexOf("GMT") > -1):
            var date = new Date(value);
            mnth = date.getMonth() + 1;
            day = date.getDate();
            var thisDate = mnth + '/' + day + '/' + date.getFullYear();
            var newDate = '<div style="margin-top: 10px;margin-left: 5px">' + thisDate + '</div>';
            break;
        default:
            var thisDateTime = value;

            if (thisDateTime != "") {
                thisDateTime = thisDateTime.split("T");

                var thisDate = thisDateTime[0].split("-");

                var newDate = '<div style="margin-top: 10px;margin-left: 5px">' + thisDate[1] + "/" + thisDate[2] + "/" + thisDate[0] + '</div>';

                return newDate;
            } else {
                return "";
            }
            break;
    }

};

//render dates for grid
var DateRenderGMT = function (row, columnfield, value, defaulthtml, columnproperties) {
    // format date as string due to inconsistant date coversions
    switch (true) {
        case (value == '0001-01-01T00:00:00'):
            return '<div style="margin-top: 10px;margin-left: 5px">&nbsp;</div>';
            break;
        case (value == '1900-01-01T00:00:00'):
            return '<div style="margin-top: 10px;margin-left: 5px">&nbsp;</div>';
            break;
        case (String(value).indexOf("GMT") > -1):
            var date = new Date(value);
            mnth = date.getMonth() + 1;
            day = date.getDate();
            var thisDate = mnth + '/' + day + '/' + date.getFullYear();
            var newDate = '<div style="margin-top: 10px;margin-left: 5px">' + thisDate + '</div>';
            break;
        default:
            var TempDate = new Date(value);

            TempDate.setHours(TempDate.getHours() - 4);

            if (TempDate != "") {
                
                var newDate = '<div style="margin-top: 10px;margin-left: 5px">' + TempDate.toLocaleDateString() + '</div>';

                return newDate;
            } else {
                return "";
            }
            break;
    }

};

var DateTimeRenderGMT = function (row, columnfield, value, defaulthtml, columnproperties) {
    var valueTest = new Date(value);
    if (valueTest.getFullYear() == '1969') {
        return '<div style="margin-top: 10px;margin-left: 5px">&nbsp;</div>';
    }
    // format date as string due to inconsistant date coversions
    switch (true) {
        case (value == '0001-01-01T00:00:00'):
            return '<div style="margin-top: 10px;margin-left: 5px">&nbsp;</div>';
            break;
        case (value == '1900-01-01T00:00:00'):
            return '<div style="margin-top: 10px;margin-left: 5px">&nbsp;</div>';
            break;
        case (String(value).indexOf("GMT") > -1):
            var date = new Date(value);
            mnth = date.getMonth() + 1;
            day = date.getDate();
            var thisDate = mnth + '/' + day + '/' + date.getFullYear();
            var newDate = '<div style="margin-top: 10px;margin-left: 5px">' + thisDate + '</div>';
            break;
        default:
            var TempDate = new Date(value);
            var offSet = DatesUTCOffSet(value);

            TempDate.setHours(TempDate.getHours() - offSet);

            if (TempDate != "") {

                var newDate = '<div style="margin-top: 10px;margin-left: 5px">' + TempDate.toLocaleDateString() + ' ' + TempDate.toLocaleTimeString() + '</div>';

                return newDate;
            } else {
                return "";
            }
            break;
    }

};

var activityRedemptionDateRenderer = function (row, columnfield, value, defaulthtml, columnproperties) {
    var thisDate = new Date(value);
    thisDate.setHours(thisDate.getHours() - DatesUTCOffSet(thisDate));

    var datarow = $("#jqxMemberActivityGrid").jqxGrid('getrowdata', row);

    if (datarow["Description"] == "Redeemed Points for Free Parking" || datarow["Description"] == "Converted Free Parking Back to Points") {
        return '<div style="margin-top: 10px;margin-left: 5px">' + DateFormat(String(thisDate)) + '</div>';
    } else {
        return '<div style="margin-top: 10px;margin-left: 5px">' + DateFormat(String(value)) + '</div>';
    }
}

var DateTimeRender = function (row, columnfield, value, defaulthtml, columnproperties) {
    // format date as string due to inconsistant date coversions
    switch (value) {
        case '0001-01-01T00:00:00':
            return '<div style="margin-top: 10px;margin-left: 5px">&nbsp;</div>';
            break;
        default:
            var thisDateTime = value;

            if (thisDateTime != "") {

                var newDate = JsonDateTimeFormat(thisDateTime);

                return '<div style="margin-top: 10px;margin-left: 5px">' + newDate + '</div>';
            } else {
                return "";
            }
            break;
    }

};

var DateTimeRenderNotMilitary = function (row, columnfield, value, defaulthtml, columnproperties) {
    // format date as string due to inconsistant date coversions
    switch (value) {
        case '0001-01-01T00:00:00':
            return '<div style="margin-top: 10px;margin-left: 5px">&nbsp;</div>';
            break;
        default:
            var thisDateTime = value;

            if (thisDateTime != "") {

                var newDate = JsonDateTimeFormatNotMilitary(thisDateTime);

                return '<div style="margin-top: 10px;margin-left: 5px">' + newDate + '</div>';
            } else {
                return "";
            }
            break;
    }

};

//Pad number
function padNumber(i, l, s) {
    //leave s blank to return zeros
    var o = i.toString();
    if (!s) { s = '0'; }
    while (o.length < l) {
        o = s + o;
    }
    return o;
}

//Get UTC offset today
function TodaysUTCOffSet() {
    var d = new Date();
    var n = d.getTimezoneOffset() / 60;
    return n;
}

//Get UTC offset of supplied date
function DatesUTCOffSet(thisDate) {
    var d = new Date(thisDate);
    var n = d.getTimezoneOffset() / 60;
    return n;
}

//Difference between dates in Days
function thisDateDiff(date1, date2, Hours) {
    if (Hours == "Hours") {
        var diff = (date2.getTime() - date1.getTime()) / 1000;
        diff /= (60 * 60);
        //return Math.abs(Math.round(diff));
        return Math.round(diff);
    } else {
        dt1 = new Date(date1);
        dt2 = new Date(date2);
        return Math.floor((Date.UTC(dt2.getFullYear(), dt2.getMonth(), dt2.getDate()) - Date.UTC(dt1.getFullYear(), dt1.getMonth(), dt1.getDate())) / (1000 * 60 * 60 * 24));
    }
}

//formats date to 10/16/2016 type
function DateFormat(dateObject) {
    var d = new Date(dateObject);
    var day = d.getDate();
    var month = d.getMonth() + 1;
    var year = d.getFullYear();
    if (day < 10) {
        day = "0" + day;
    }
    if (month < 10) {
        month = "0" + month;
    }
    var date = month + "/" + day + "/" + year;

    return date;
}

function DateFormatForHTML5(dateObject) {
    if (dateObject == null) {
        return null;
    }
    var d = new Date(dateObject);
    var day = d.getDate();
    var month = d.getMonth() + 1;
    var year = d.getFullYear();
    if (day < 10) {
        day = "0" + day;
    }
    if (month < 10) {
        month = "0" + month;
    }
    var date = year + "-" + month + "-" + day;

    return date;
}


//formats date to 10/16/2016 12:12 type
function DateTimeFormat(dateObject) {
    var d = new Date(dateObject);
    var day = d.getDate();
    var month = d.getMonth() + 1;
    var year = d.getFullYear();
    var Hours = padNumber(d.getHours(), 2);
    var Minutes = padNumber(d.getMinutes(), 2);

    if (day < 10) {
        day = "0" + day;
    }
    if (month < 10) {
        month = "0" + month;
    }
    var date = month + "/" + day + "/" + year + ' ' + Hours + ':' + Minutes;

    return date;
}

//formats Json dates to MM/dd/yyyy HH:mm
function JsonDateTimeFormat(dateObject) {
    var thisDate = String(dateObject);

    var day = thisDate.substr(8, 2);
    var month = thisDate.substr(5, 2);
    var year = thisDate.substr(0, 4);
    var Hours = thisDate.substr(11, 2);
    var Minutes = thisDate.substr(14, 2);

    var date = month + "/" + day + "/" + year + ' ' + Hours + ':' + Minutes;

    return date;
}

//formats Json dates to MM/dd/yyyy HH:mm
function JsonDateTimeFormatNotMilitary(dateObject) {
    var thisDate = String(dateObject);

    var day = thisDate.substr(8, 2);
    var month = thisDate.substr(5, 2);
    var year = thisDate.substr(0, 4);
    var Hours = thisDate.substr(11, 2);
    var Minutes = thisDate.substr(14, 2);

    if (Hours > 12) {
        Hours = Hours - 12;
        var date = month + "/" + day + "/" + year + ' ' + Hours + ':' + Minutes + ' pm';
    } else {
        var date = month + "/" + day + "/" + year + ' ' + Hours + ':' + Minutes + ' am';
    }

    return date;
}

//formats Json dates to MM/dd/yyyy HH:mm
function JsonDateNoTimeFormat(dateObject) {
    var thisDate = String(dateObject);

    var day = thisDate.substr(8, 2);
    var month = thisDate.substr(5, 2);
    var year = thisDate.substr(0, 4);


    var date = month + "/" + day + "/" + year;

    return date;
}

//date to JSON format
function DateToJsonDate(thisDate) {
    var event = new Date(thisDate);
    var jsonDate = event.toJSON();

    return jsonDate;
}

//Display PageMethod Results
function DisplayPageMethodResults(ResultString) {
    if (ResultString != "") {
        alert(ResultString);
    }
    
}


//loads points to a label from an AccountID
function loadPoints(thisAccountId, textInput) {
    $.ajax({
        type: 'GET',
        url: $("#apiDomain").val() + "accounts/" + thisAccountId + "/points",
        headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "AccessToken": $("#userGuid").val(),
            "ApplicationKey": $("#AK").val()
        },
        success: function (thisData) {
            textInput.html(thisData.result.data.Points);
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            textInput.html("-9999");
        },
        complete: function () {

        }
    });
}

function getCompanyName(CompanyID, jqxinput) {
    if (CompanyID == null) {
        return 0;
    }
    
    var url = $("#localApiDomain").val() + "CompanyDropDowns/GetCompanyName/" + CompanyID;
    //var url = "http://localhost:52839/api/CompanyDropDowns/GetCompanyName/" + CompanyID;

    $.ajax({
        type: "GET",
        url: url,
        dataType: "json",
        success: function (data) {
            if (data.length > 0) {
                var thisCompanyName = data[0].name;
                jqxinput.val(thisCompanyName);
                jqxinput.attr("disabled", true);
                return thisCompanyName;
            } else {
                return 0;
            }

        },
        error: function (request, status, error) {
            return 0;
        }
    });
}

//Javascript to get query string parameters
function getUrlParameter(name) {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
    var results = regex.exec(location.search);
    return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
};

//Currency formatting
//const formatter = new Intl.NumberFormat('en-US', {
//    style: 'currency',
//    currency: 'USD',
//    minimumFractionDigits: 2
//})

//check Undefined Number
var checkUndefinedNaN = function (x) {
    if (typeof x == 'undefined') return 0;
    if (x == '') return 0;
    if (isNaN(x)) return 0;
    return x;
}

//Check undefined String
var checkUndefinedString = function (x) {
    if (typeof x == 'undefined') return '';
    return x;
}

// Use this to render location names if they only sent the ID
var locatioinCellsrenderer = function (row, columnfield, value, defaulthtml, columnproperties) {
    switch (value) {
        case 1:
            return '<div style="margin-top: 10px;margin-left: 5px">Albuquerque</div>';
            break;
        case 2:
            return '<div style="margin-top: 10px;margin-left: 5px">Austin</div>';
            break;
        case 3:
            return '<div style="margin-top: 10px;margin-left: 5px">Baltimore Elkridge Landing</div>';
            break;
        case 4:
            return '<div style="margin-top: 10px;margin-left: 5px">Baltimore W. Nursery Road</div>';
            break;
        case 5:
            return '<div style="margin-top: 10px;margin-left: 5px">Cincinnati</div>';
            break;
        case 6:
            return '<div style="margin-top: 10px;margin-left: 5px">Cleveland</div>';
            break;
        case 7:
            return '<div style="margin-top: 10px;margin-left: 5px">Cleveland PP</div>';
            break;
        case 8:
            return '<div style="margin-top: 10px;margin-left: 5px">Houston Greens Rd</div>';
            break;
        case 9:
            return '<div style="margin-top: 10px;margin-left: 5px">Cincinnati</div>';
            break;
        case 10:
            return '<div style="margin-top: 10px;margin-left: 5px">Raleigh</div>';
            break;
        case 11:
            return '<div style="margin-top: 10px;margin-left: 5px">Tucson</div>';
            break;
        case 12:
            return '<div style="margin-top: 10px;margin-left: 5px">Orlando</div>';
            break;
        case 13:
            return '<div style="margin-top: 10px;margin-left: 5px">Milwaukee</div>';
            break;
        case 14:
            return '<div style="margin-top: 10px;margin-left: 5px">Miami</div>';
            break;
        case 15:
            return '<div style="margin-top: 10px;margin-left: 5px">Memphis</div>';
            break;
        case 16:
            return '<div style="margin-top: 10px;margin-left: 5px">Houston WC</div>';
            break;
        case 17:
            return '<div style="margin-top: 10px;margin-left: 5px">Indianapolis</div>';
            break;
        case 18:
            return '<div style="margin-top: 10px;margin-left: 5px">Atlanta</div>';
            break;
        case 20:
            return '<div style="margin-top: 10px;margin-left: 5px">Houston Hobby</div>';
            break;
        case 21:
            return '<div style="margin-top: 10px;margin-left: 5px">Chicago Midway</div>';
            break;
        default:
            return 'Error';
    }
}

//verifys whether a card is in the DB for different types of history
function verifyCard(CardNumber, Historytype, cardTest) {
    var cardNumber;

     var url = $("#localApiDomain").val() + 'CardDistHistorys/ConfirmNumbers/' + Historytype + '_' + CardNumber;
    //var url = 'http://localhost:52839/api/CardDistHistorys/ConfirmNumbers/' + Historytype + '_' + CardNumber;

    $.ajax({
        type: 'GET',
        url: url,
        success: function (data) {
            if (data.length > 0) {
                cardTest.css('background-color', '#ff6666');
            } else {
                cardTest.css('background-color', '#ffffff');
            }

        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            swal("Error: " + errorThrown);
            ardTest = false;
        }
    });

    //return $("#LastCardAPIResult").val();
    return cardNumber;
}

function msieversion() {
    var ua = window.navigator.userAgent;
    var msie = ua.indexOf("MSIE ");
    if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) // If Internet Explorer, return true
    {
        return true;
    } else { // If another browser,
        return false;
    }
    return false;
}

function nullToEmpty(value) {
    if (value == null) {
        return ""
    } else {
        return value;
    }
}

function nullToZero(value) {
    if (value == null) {
        return 0;
    } else {
        return value;
    }
}

function exportGridToCsv(Results, fileName, headerString, IncludeID) {
    var CsvString = "";
    var firstTime = true;


    for (var i = 0; i < Results.length; i++) {

        if (IncludeID == false) {
            delete Results[i]["VehicleId"];
        }
        
        delete Results[i]["uid"];
        delete Results[i]["boundindex"];
        delete Results[i]["uniqueid"];
        delete Results[i]["visibleindex"];

        var Result = JSON.stringify(Results[i]);

        var parsed = JSON.parse(Result);

        var arr = [];

        for (var x in parsed) {
            arr.push(parsed[x]);
        }

        for (var j = 0; j < arr.length; j++) {

            var tester = nullToEmpty(arr[j]).toString();

            if (tester == tester.match(/.*-.*-.*T.*:.*:.*\..*Z/g)) {
                CsvString += DateFormat(JsonDateTimeFormat(tester)) + ',';
            } else {
                CsvString += tester + ',';
            }


        }
        CsvString += "\r\n";
    }

    CsvString = headerString + CsvString;

    CsvString = "data:application/csv," + encodeURIComponent(CsvString);
    var x = document.createElement("A");
    x.setAttribute("href", CsvString);
    x.setAttribute("download", fileName);
    document.body.appendChild(x);
    x.click();
}

function keepMeAlive(imgName) {
    myImg = document.getElementById(imgName);
    if (myImg) myImg.src = myImg.src.replace(/\?.*$/, '?' + Math.random());
}



