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
    alert(ResultString);
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
