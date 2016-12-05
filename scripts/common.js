//Security Setup
function Security() {
    if (group.indexOf("Booth") <= -1) {
        $("#BoothLink").remove();
    }

    if (group.indexOf("Portal_Auditadmin") <= -1) {
        $("#ReservationMaintenanceLink").remove();
    }

    //if (group.indexOf("Portal_Admin") <= -1 && group.indexOf("Portal_Auditadmin") <= -1 && group.indexOf("Portal_Manager") <= -1 && group.indexOf("Portal_RFR") <= -1 && group.indexOf("Portal_Superadmin") <= -1) {
    if (group.indexOf("Portal_Edit") <= -1) {
        var elements = document.getElementsByClassName('editor')

        for (var i = 0; i < elements.length; i++) {
            elements[i].style.display = "none";
        }
    }
}

//render dates for grid
var DateRender = function (row, columnfield, value, defaulthtml, columnproperties) {
    // format date as string due to inconsistant date coversions
    var thisDateTime = value;

    if (thisDateTime != "") {
        thisDateTime = thisDateTime.split("T");

        var thisDate = thisDateTime[0].split("-");

        var newDate = thisDate[1] + "/" + thisDate[2] + "/" + thisDate[0];

        return newDate;
    } else {
        return "";
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


//formats date to 10/16/2016 12:12 type
function DateTimeFormat(dateObject) {
    var d = new Date(dateObject);
    var day = d.getDate();
    var month = d.getMonth() + 1;
    var year = d.getFullYear();
    var Hours = d.getHours();
    var Minutes = d.getMinutes();
    var minutes = d.getHours

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
            return '<div style="margin-top: 10px;margin-left: 5px">Houston</div>';
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
        default:
            return 'Error';
    }
}
