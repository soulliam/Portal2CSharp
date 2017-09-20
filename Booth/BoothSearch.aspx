<%@ Page Title="" Language="C#" MasterPageFile="Portal2Booth.master" AutoEventWireup="true" CodeFile="BoothSearch.aspx.cs" Inherits="Booth_BoothSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
        <style>
        #searchContainer *{
            font-size:20px;
            font-weight: bold;
        }
        
        #popupRedemptionList *{
            font-size:20px;
            font-weight: bold;
        }

        #redemptionContainer *{
            font-size:20px;
            font-weight: bold;
        }

        #popupLocation *{
            font-size:22px;
            font-weight: bold;
        }

        #popupMember *{
            font-size:22px;
            font-weight: bold;
        }

        #popupNewEmail *{
            font-size:22px;
            font-weight: bold;
        }

        #popupReceipt *{
            font-size:22px;
            font-weight: bold;
        }

        .jqx-dropdownlist-content { font-size : 22px;font-weight: bold;}
        .jqx-listitem-state-selected { font-size : 22px;font-weight: bold; }
        .jqx-listitem-state-normal {font-size : 22px;font-weight: bold; }
        .jqx-combobox-content-disabled *{font-size : 22px;font-weight: bold; color: black;}

    </style>
    
    <script type="text/javascript" src="../scripts/jquery.qrcode.min.js"></script>
    

    <link rel="stylesheet" href="../jqwidgets/styles/jqx.base.css" type="text/css" />

    <script type="text/javascript" src="../jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="../jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxgrid.js"></script>    
    <script type="text/javascript" src="../jqwidgets/jqxgrid.aggregates.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcombobox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdata.js"></script>     
    <script type="text/javascript" src="../jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxgrid.filter.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxgrid.pager.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxgrid.selection.js"></script> 
    <script type="text/javascript" src="../jqwidgets/jqxgrid.sort.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>    
    <script type="text/javascript" src="../jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxloader.js"></script>


    <script type="text/javascript">
        var group = '<%= Session["groupList"] %>';

        $(document).ready(function () {
            

            //#region ButtonSetup

            $("#btnSearch").jqxButton({ width: 100, height: 60 });
            $("#btnSearchClear").jqxButton({ width: 100, height: 60 });
            $("#btnSearchEmail").jqxButton({ width: 240, height: 60 });
            $("#btnSearchFPNumber").jqxButton({ width: 240, height: 60 });
            $("#btnSearchName").jqxButton({ width: 240, height: 60 });

            $("#btn1Day").jqxButton({ width: 100, height: 60 });
            $("#btn2Day").jqxButton({ width: 100, height: 60 });
            $("#btn3Day").jqxButton({ width: 100, height: 60 });
            $("#btn4Day").jqxButton({ width: 100, height: 60 });
            $("#btnWeek").jqxButton({ width: 100, height: 60 });
            $("#btnReceipt").jqxButton({ width: 100, height: 60 });

            $("#closeMemberInfo").jqxButton({ width: 100, height: 60 });
            $("#changeEmail").jqxButton({ width: 200, height: 60 });

            $("#newEmailCancel").jqxButton({ width: 100, height: 60 });
            $("#newEmailSubmit").jqxButton({ width: 100, height: 60 });
            $("#showRedemptionList").jqxButton({ width: 175, height: 60 });
            $("#closeRedemptionList").jqxButton({ width: 100, height: 60 });

            //#endregion

            //#region Button Clicks

            //Show redemptoion LIst
            $("#showRedemptionList").on("click", function (event) {

                $("#popupRedemptionList").css('display', 'block');
                $("#popupRedemptionList").css('visibility', 'hidden');

                var offset = $("#jqxSearchGrid").offset();
                var width = $('#jqxSearchGrid').width();

                $('#popupRedemptionList').jqxWindow({ maxHeight: 450, maxWidth: width });
                $("#popupRedemptionList").jqxWindow({ position: { x: parseInt(offset.left) - 10, y: parseInt(offset.top) + 0 } });
                $('#popupRedemptionList').jqxWindow({ height: 450, width: width });
                $('#popupRedemptionList').jqxWindow({ showCloseButton: true });
                $('#popupRedemptionList').jqxWindow({ resizable: false });
                $("#popupRedemptionList").css("visibility", "visible");
                $("#popupRedemptionList").jqxWindow({ title: 'Existing Redemptions' });
                $("#popupRedemptionList").jqxWindow('open');
                $("#popupMember").jqxWindow('hide');
                
                loadRedemptionList();
            });



            $('#closeRedemptionList').on('click', function (event) {
                $("#memberAcctId").html("");
                $("#MemberId").html("");
                $("#memberName").html("");
                $("#memberEmail").html("");
                $("#memberFPNumber").html("");
                $("#memberStreetAddress").html("");
                $("#acctPoints").html("");
                $("#stateCombo").jqxComboBox('selectItem', 0);
                $("#cardCombo").jqxComboBox("clear");
                document.getElementById('qrIframe').src = '';
                $("#qrcode").html("");
                $("#redemptionRow").css("visibility", "hidden");
                $("#popupRedemptionList").jqxWindow('hide');
            });



            //save receipt request
            $("#receiptSave").on("click", function (event) {
                if ($("#receiptNumber").val() == '') {
                    alert("Receipt number is required!")
                    return null;
                }

                var today = new Date();
                today = DateFormat(today);
                var selectedDate = new Date($('#jqxReceiptCalendar').jqxCalendar('getDate'));
                selectedDate = DateFormat(selectedDate);

                if (selectedDate > today) {
                    alert("The receipt entry date must be in the past.");
                    return null;
                }
                
                var thisReceiptNumber = $("#receiptNumber").val();
                var thisReceptDate = $('#jqxReceiptCalendar').jqxCalendar('getDate');
                var thisMemberId = $("#MemberId").html();
                var thisLocationId = $("#boothLocation").val();
                var thisUser = $("#loginLabel").html();

                PageMethods.submitReceipt(thisReceiptNumber, thisReceptDate, thisMemberId, thisLocationId, thisUser, DisplayPageMethodResults);

                $("#receiptNumber").val("");
                $("#popupReceipt").jqxWindow('hide');
            });


            //close receipt popup
            $("#receiptCancel").on("click", function (event) {
                $("#popupReceipt").jqxWindow('hide');
            });

            //open receipt entry
            $("#btnReceipt").on("click", function (event) {

                $("#popupReceipt").css('display', 'block');
                $("#popupReceipt").css('visibility', 'hidden');

                var offset = $("#jqxSearchGrid").offset();
                $("#popupReceipt").jqxWindow({ position: { x: parseInt(offset.left) + 200, y: parseInt(offset.top) - 80 } });
                $('#popupReceipt').jqxWindow({ width: "500px", height: "575px" });
                $('#popupReceipt').jqxWindow({ isModal: true, modalOpacity: 0.7 });
                $('#popupReceipt').jqxWindow({ showCloseButton: false });
                $("#popupReceipt").css("visibility", "visible");
                $("#popupReceipt").jqxWindow({ title: 'Enter Customer Receipt' });
                $("#popupReceipt").jqxWindow('open');
            });

            //redeem 1 day
            $("#btn1Day").on("click", function (event) {
                if ($("#acctPoints").html() < 8) {
                    alert("There are not enough points for this redemption!");
                    return null;
                }
               CreateRedemption(1,3,1)
            });

            $("#btn3Day").on("click", function (event) {
                if ($("#acctPoints").html() < 20) {
                    alert("There are not enough points for this redemption!");
                    return null;
                }
                CreateRedemption(2, 3, 1)
            });

            $("#btnWeek").on("click", function (event) {
                if ($("#acctPoints").html() < 40) {
                    alert("There are not enough points for this redemption!");
                    return null;
                }
                CreateRedemption(3, 3, 1)
            });

            //submit email request
            $("#newEmailSubmit").on("click", function (event) {
                var thisUser = $("#txtLoggedinUsername").val();
                var thisMemberId = $("#MemberId").html();
                var thisOldEmail = $("#oldEmail").val();
                var thisNewEmail = $("#newEmail").val();

                PageMethods.LogEmailChange(thisUser, thisMemberId, thisOldEmail, thisNewEmail, DisplayPageMethodResults);
                
                $("#popupNewEmail").jqxWindow('hide');
                $("#oldEmail").val("");
                $("#newEmail").val("");
            });


            $("#newEmailCancel").on("click", function (event) {
                $("#popupNewEmail").jqxWindow('hide');
            });

            //show email request pop up email chang
            $("#changeEmail").on("click", function (evnet) {
                $("#popupNewEmail").css('display', 'block');
                $("#popupNewEmail").css('visibility', 'hidden');

                $("#oldEmail").val($("#memberEmail").html());

                var offset = $("#jqxSearchGrid").offset();
                $("#popupNewEmail").jqxWindow({ position: { x: parseInt(offset.left) + 500, y: parseInt(offset.top) - 40 } });
                $('#popupNewEmail').jqxWindow({ width: "350px", height: "300px" });
                $('#popupNewEmail').jqxWindow({ isModal: true, modalOpacity: 0.7 });
                $('#popupNewEmail').jqxWindow({ showCloseButton: false });
                $("#popupNewEmail").css("visibility", "visible");
                $("#popupNewEmail").jqxWindow({ title: 'Request Email Update' });
                $("#popupNewEmail").jqxWindow('open');
            });

            $("#closeMemberInfo").on("click", function (event) {
                $("#memberAcctId").html("");
                $("#MemberId").html("");
                $("#memberName").html("");
                $("#memberEmail").html("");
                $("#memberFPNumber").html("");
                $("#memberStreetAddress").html("");
                $("#acctPoints").html("");
                $("#stateCombo").jqxComboBox('selectItem', 0);
                $("#cardCombo").jqxComboBox("clear");
                document.getElementById('qrIframe').src = '';
                $("#qrcode").html("");
                $("#redemptionRow").css("visibility", "hidden");
                $("#popupMember").jqxWindow('hide');
            });

            $("#btnSearch").on("click", function (event) {
                document.getElementById('qrIframe').src = '';
                getParametersAndSearch();

            });


            $("#btnSearchName").on("click", function (event) {
                if ($("#txtSearchLastName").is(":hidden")) {
                    $("#txtSearchLastName").toggle();
                }
                $("#txtSearchEmailFNameFPNumber").prop('type', 'text');
                $("#txtSearchEmailFNameFPNumber").attr("placeholder", "First Name");
                $("#btnSearchName").css("background", "darkgray");
                $("#btnSearchFPNumber").css("background", "#EFEFEF");
                $("#btnSearchEmail").css("background", "#EFEFEF");
                clearSearch();
            });

            $("#btnSearchFPNumber").on("click", function (event) {
                if ($("#txtSearchLastName").is(":visible")) {
                    $("#txtSearchLastName").toggle();
                }
                $("#txtSearchEmailFNameFPNumber").prop('type', 'number');
                $("#txtSearchEmailFNameFPNumber").attr("placeholder", "FPNumber");
                $("#btnSearchFPNumber").css("background", "darkgray");
                $("#btnSearchName").css("background", "#EFEFEF");
                $("#btnSearchEmail").css("background", "#EFEFEF");
                clearSearch();
            });

            $("#btnSearchEmail").on("click", function (event) {
                if ($("#txtSearchLastName").is(":visible")) {
                    $("#txtSearchLastName").toggle();
                }
                $("#txtSearchEmailFNameFPNumber").prop('type', 'email');
                $("#txtSearchEmailFNameFPNumber").attr("placeholder", "Email Address");
                $("#btnSearchEmail").css("background", "darkgray");
                $("#btnSearchName").css("background", "#EFEFEF");
                $("#btnSearchFPNumber").css("background", "#EFEFEF");
                clearSearch();
            });

            $("#btnSearchClear").on("click", function (event) {
                document.getElementById('qrIframe').src = '';
                clearSearch();
            });


            $("#searchContainer").keypress(function (e) {

                if (e.keyCode == 13) {
                    document.getElementById('qrIframe').src = '';
                    getParametersAndSearch();
                }
            });

            //#endregion

            //#region PageSetup

            var carSource = "";
            $("#cardCombo").jqxDropDownList(
            {
                width: 250,
                height: 35,
                itemHeight: 35,
                source: carSource,
                selectedIndex: 0,
                displayMember: "FPNumber",
                valueMember: "CardId"
            });

            $("#cardCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;

                    if (item) {
                        var thisItem = "62711601" + item.label;
                        //Populate the Iframe with QR Code
                        document.getElementById('qrIframe').src = './QRCode.aspx?codeNumber=' + thisItem;
                        //This code is for jqeury version of QR generator
                        //$('#qrcode').html("");
                        //$('#qrcode').qrcode(thisItem.toString());
                    }
                }
            });

            //insert place holder in location combo box
            $("#LocationCombo").on('bindingComplete', function (event) {
                $("#LocationCombo").jqxDropDownList('insertAt', 'Pick a Location', 0);
            });

            

            //Place holder grid

            $("#jqxSearchGrid").jqxGrid(
            {
                width: '100%',
                height: 450,
                columns: [
                    { text: 'MemberId', datafield: 'MemberId', hidden: true },
                    { text: 'First Name', datafield: 'FirstName' },
                    { text: 'Last Name', datafield: 'LastName' },
                    { text: 'FPNumber', datafield: 'FPNumber' },
                    { text: 'Email', datafield: 'EmailAddress' },
                    { text: 'Street Address', datafield: 'StreetAddress' },
                    { text: 'City', datafield: 'City' }
                ]
            });

            var locationString = $("#userLocation").val();
            var locationResult = locationString.split(",");

            if (locationResult.length > 1) {
                var thisLocationString = "";
                for (i = 0; i < locationResult.length; i++) {
                    if (i == locationResult.length - 1) {
                        thisLocationString += locationResult[i];
                    }
                    else
                    {
                        thisLocationString += locationResult[i] + ",";
                    }
                    
                }
                LoadLocationPopup(thisLocationString);
                $("#popupLocation").css('display', 'block');
                $("#popupLocation").css('visibility', 'hidden');

                var offset = $("#jqxSearchGrid").offset();
                $("#popupLocation").jqxWindow({ position: { x: parseInt(offset.left) + 500, y: parseInt(offset.top) - 40 } });
                $('#popupLocation').jqxWindow({ width: "325px", height: "300px" });
                $('#popupLocation').jqxWindow({ isModal: true, modalOpacity: 0.7 });
                $('#popupLocation').jqxWindow({ showCloseButton: false });
                $("#popupLocation").css("visibility", "visible");
                $("#popupLocation").jqxWindow({ title: 'Pick a Location' });
                $("#popupLocation").jqxWindow('open');
            }
            else {
                $("#boothLocation").val(locationResult[0]);
            }

            $("#txtSearchLastName").toggle();

            $("#btnSearchFPNumber").css("background", "darkgray");

            $("#jqxLoader").jqxLoader({ isModal: true, width: 100, height: 60, imagePosition: 'top' });

            $("#jqxReceiptCalendar").jqxCalendar({ width: 400, height: 400 });

            loadStateCombo();

            //#endregion
        });

        //#region Functions




        function loadRate() {
            $("#memberRate").jqxComboBox('clearSelection');
            $("#memberRate").jqxComboBox('clear');
            var parent = $("#memberRate").parent();
            $("#memberRate").jqxComboBox('destroy');
            $("<div id='memberRate'></div>").appendTo(parent);


            //set rate combobox
            var rateSource =
            {
                async: true,
                width: '100%',
                height: 35,
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'LocationId' },
                    { name: 'NameOfLocation' }
                ],
                url: $("#localApiDomain").val() + "Locations/Locations/",

            };
            var rateDataAdapter = new $.jqx.dataAdapter(rateSource);
            $('#memberRate').jqxComboBox({
                selectedIndex: 0, source: rateDataAdapter, displayMember: "NameOfLocation", valueMember: "LocationId", height: 24, width: '100%',
                renderer: function (index, label, value) {
                    var rateObj = { rate: "0" };
                    rateObj = { rateCode: "0" };
                    rateObj = { locationList: "" };

                    getRate(rateObj, value);

                    var homeLocations = String(rateObj.locationList).split("_");

                    if (homeLocations.indexOf(String(value)) > -1) {
                        var table = '<div style="color:black">' + label + ' - ' + rateObj.rateCode + ' - ' + rateObj.rate + ' **</div>';
                    } else {
                        var table = '<div style="color:black">' + label + ' - ' + rateObj.rateCode + ' - ' + rateObj.rate + '</div>';
                    }

                    return table;
                },
                renderSelectedItem: function (index, item) {
                    var rateObj = { rate: "0" };
                    rateObj = { rateCode: "0" };
                    rateObj = { locationList: "" };

                    getRate(rateObj, item.value);

                    var homeLocations = String(rateObj.locationList).split("_");

                    if (homeLocations.indexOf(String(item.value)) > -1) {
                        var table = item.label + ' - ' + rateObj.rateCode + ' - ' + rateObj.rate + ' **';
                    } else {
                        var table = item.label + ' - ' + rateObj.rateCode + ' - ' + rateObj.rate
                    }

                    return table;
                }
            });

            $("#memberRate").on('bindingComplete', function (event) {
                $("#memberRate").jqxComboBox('selectItem', $("#boothLocation").val());
            });
            
        }

        function getRate(obj, thisLocationId) {
            //var thisCompanyId = $("#MailerCompanyCombo").jqxComboBox('getSelectedItem').value;
            var thisCompanyId = $("#CompanyId").html();

            $.ajax({
                async: false,
                type: "POST",
                url: $("#localApiDomain").val() + "Rates/GetRateByLocationAndCompanyId/",
                //url: "http://localhost:52839/api/Rates/GetRateByLocationAndCompanyId/",

                data: { "CompanyId": thisCompanyId, "LocationId": thisLocationId },
                dataType: "json",
                success: function (thisData) {
                    var results = String(thisData).split(",")
                    obj.rate = results[0];
                    obj.rateCode = results[1];
                    obj.locationList = results[2];
                },
                error: function (request, status, error) {
                    alert(error);
                }
            });

        }

        function getParametersAndSearch() {
            var thisReturn = "";


            $("#popupMember").jqxWindow('hide');
            $("#popupNewEmail").jqxWindow('hide');
            $("#popupReceipt").jqxWindow('hide');
            $("#popupRedemptionList").jqxWindow('hide');


            thisReturn = "LocationId=" + $("#boothLocation").val();

            if ($("#btnSearchName").css('backgroundColor') == "rgb(169, 169, 169)") {

                if ($("#txtSearchLastName").val() == "") {
                    alert("You must have a last name to search by name.")
                    return "";
                }

                thisReturn = thisReturn + "&LastName=" + $("#txtSearchLastName").val();

                if ($("#txtSearchEmailFNameFPNumber").val() != "") {
                    thisReturn = thisReturn + "&FirstName=" + $("#txtSearchEmailFNameFPNumber").val();
                }

            }

            if ($("#btnSearchFPNumber").css('backgroundColor') == "rgb(169, 169, 169)") {
                if ($("#txtSearchEmailFNameFPNumber").val() != "") {
                    thisReturn = "&FPNumber=" + $("#txtSearchEmailFNameFPNumber").val();
                }
                else {
                    alert("You must enter a value to search for an FPNumber!")
                    return null;
                }
            }

            if ($("#btnSearchEmail").css('backgroundColor') == "rgb(169, 169, 169)") {
                if ($("#txtSearchEmailFNameFPNumber").val() != "") {
                    thisReturn = "&EmailAddress=" + $("#txtSearchEmailFNameFPNumber").val();
                }
                else {
                    alert("You must enter a value to search for an email!")
                    return null;
                }
            }

            var thisUser = $("#loginLabel").html();

            PageMethods.logSearch(thisUser, 0, $("#txtSearchEmailFNameFPNumber").val(), $("#txtSearchLastName").val(), DisplayPageMethodResults);

            loadSearchResults(thisReturn);
        }

        // send error if logging login fails
        function BoothLogin(ResultString) {
            if (ResultString != "Success") {
                alert(ResultString);
            }
        }

        //Create New Redemption
        function CreateRedemption(thisRedemptionTypeId, thisRedemptionSourceId, NumberToRedeem) {
            var result = confirm("Do you want to create a redemption!");
            if (result != true) {
                return null;
            }

            var thisMemberId = $("#MemberId").html();
            var thisQrCodeString = "";
            $('#popupMember').jqxWindow('hide');

            $('#jqxLoader').jqxLoader('open');

            $.ajax({
                type: 'POST',
                url: $("#apiDomain").val() + "members/" + thisMemberId + "/redemptions?fromBooth=true",
                dataType: "json",
                data: JSON.stringify([{
                    "RedemptionTypeId": thisRedemptionTypeId,
                    "RedemptionSourceId": thisRedemptionSourceId,
                    "NumberToRedeem": NumberToRedeem
                }]),
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": $("#userGuid").val(),
                    "ApplicationKey": $("#AK").val()
                },
                success: function (thisData) {

                    var thisDate = thisData.result.data[0].RedeemDate;
                    var thisCertificateId = thisData.result.data[0].CertificateID;

                    $("#redemptionCertificateID").html(thisCertificateId);
                    $("#redemptionRedeemDate").html(DateFormat(thisDate));
                    $("#redemptionRedemptionType").html(thisData.result.data[0].RedemptionType.RedemptionType);
                    $("#redemptionPointValue").html(thisData.result.data[0].RedemptionType.PointValue);

                    var thisQrCodeString = thisData.result.data[0].QrCodeString;
                    document.getElementById('renderRedemption').src = './QRCode.aspx?codeNumber=' + thisQrCodeString;

                    $("#popupRedemption").css('display', 'block');
                    $("#popupRedemption").css('visibility', 'hidden');

                    var offset = $("#jqxSearchGrid").offset();
                    $("#popupRedemption").jqxWindow({ position: { x: parseInt(offset.left) + 300, y: parseInt(offset.top) - 20 } });
                    $('#popupRedemption').jqxWindow({ width: "320px", height: "425px" });
                    $('#popupRedemption').jqxWindow({ isModal: true, modalOpacity: 0.7 });
                    $('#popupRedemption').jqxWindow({ showCloseButton: true });
                    $("#popupRedemption").css("visibility", "visible");
                    $("#popupRedemption").jqxWindow({ title: 'New Redemption' });
                    $("#popupRedemption").jqxWindow('open');

                    $('#jqxLoader').jqxLoader('close');

                    $('#popupMember').jqxWindow('open');

                    //calls from common.js
                    var acctId = $("#memberAcctId").html();
                    loadPoints(acctId, $("#acctPoints"));

                    MarkRedemptionAsUserd(thisCertificateId);


                    var thisUser = $("#loginLabel").html();

                    PageMethods.logCertificate(thisUser, thisMemberId, NumberToRedeem, thisRedemptionTypeId, DisplayPageMethodResults);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert("Error: " + errorThrown);
                },
                complete: function () {

                }
            });
        }

        function MarkRedemptionAsUserd(thisCertificateId) {
            var thisUser = $("#txtLoggedinUsername").val();

            $.ajax({
                type: "POST",
                //url: "http://localhost:52839/api/Redemptions/SetBeenUsed/",
                url: $("#localApiDomain").val() + "Redemptions/SetBeenUsed/",

                data: {
                    "RedemptionId": thisCertificateId,
                    "UpdateExternalUserData": thisUser,
                },
                dataType: "json",
                success: function (Response) {
                    success = true;
                },
                error: function (request, status, error) {
                    alert(error);
                },
                complete: function () {
                    if (success == true) {

                    }
                }
            });
        }
        

       
        //clear search boxes 
        function clearSearch() {
            $("#popupMember").jqxWindow('hide');
            $("#popupNewEmail").jqxWindow('hide');
            $("#popupReceipt").jqxWindow('hide');
            $("#popupRedemptionList").jqxWindow('hide');
            $("#jqxSearchGrid").jqxGrid("clear");
            $("#txtSearchLastName").val("");
            $("#txtSearchEmailFNameFPNumber").val("");
            $("#redemptionRow").css("visibility", "hidden");
        }

        function loadStateCombo() {
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
                theme: 'shinyblack',
                width: 200,
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
        }


        //Load locationPopup if multiple locations
        function LoadLocationPopup(thisLocationString) {
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
                url: $("#localApiDomain").val() + "Locations/LocationByLocationIds/" + thisLocationString,

            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#LocationCombo").jqxDropDownList(
            {
                width: 300,
                height: 50,
                itemHeight: 50,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });
            $("#LocationCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {
                        $("#boothLocation").val(item.value);
                        $("#popupLocation").jqxWindow('hide');
                    }

                }
            });
        }

        function loadSearchResults(thisParameters) {

            var parent = $("#jqxSearchGrid").parent();
            $("#jqxSearchGrid").jqxGrid('destroy');
            $("<div id='jqxSearchGrid'></div>").appendTo(parent);

            //Loads SearchList from parameters

            var url = $("#apiDomain").val() + "members/search?" + thisParameters;
            var thisAccessToken = $("#userGuid").val();
            var thisApplicatoinKey = $("#AK").val();

            var source =
            {
                datafields: [
                    { name: 'MemberId' },
                    { name: 'FirstName' },
                    { name: 'LastName' },
                    { name: 'FPNumber' },
                    { name: 'StreetAddress' },
                    { name: 'City' },
                    { name: 'EmailAddress' }
                ],
                id: 'MemberId',
                type: 'Get',
                datatype: "json",
                url: url,
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('AccessToken', thisAccessToken);
                    jqXHR.setRequestHeader('ApplicationKey', thisApplicatoinKey);
                },
                root: "data"
            };
            // create Searchlist Grid
            $("#jqxSearchGrid").jqxGrid(
            {
                width: '100%',
                height: 450,
                source: source,
                rowsheight: 60,
                ready: function () {
                },
                columns: [
                        {
                            text: 'Select', pinned: true, datafield: 'Select', width: 50, columntype: 'button', cellsrenderer: function () {
                                return "Select";
                            }, buttonclick: function (row) {

                                editrow = row;

                                var dataRecord = $("#jqxSearchGrid").jqxGrid('getrowdata', editrow);

                                loadMember(dataRecord.MemberId);
                                var offset = $("#jqxSearchGrid").offset();
                                var width = $('#jqxSearchGrid').width();

                                $("#popupMember").css('display', 'block');
                                $("#popupMember").css('visibility', 'hidden');

                                $('#popupMember').jqxWindow({ maxHeight: 450, maxWidth: width });
                                $("#popupMember").jqxWindow({ position: { x: parseInt(offset.left) - 10, y: parseInt(offset.top) + 0 } });
                                $('#popupMember').jqxWindow({ height: 450, width: width });
                                $('#popupMember').jqxWindow({ showCloseButton: false });
                                $("#popupMember").css("visibility", "visible");
                                $("#popupMember").jqxWindow({ title: 'Member Information' });
                                $("#popupMember").jqxWindow('open');

                            },
                            width: '5%'
                        },
                        { text: 'MemberId', datafield: 'MemberId', hidden: true },
                        { text: 'First Name', datafield: 'FirstName', width: '10%' },
                        { text: 'Last Name', datafield: 'LastName', width: '13%' },
                        { text: 'FPNumber', datafield: 'FPNumber', width: '10%' },
                        { text: 'Email', datafield: 'EmailAddress', width: '25%' },
                        { text: 'Street Address', datafield: 'StreetAddress', width: '25%' },
                        { text: 'City', datafield: 'City', width: '12%' }
                ]
            });
        }

        function loadRedemptionList() {

            var parent = $("#jqxRedemptionList").parent();
            $("#jqxRedemptionList").jqxGrid('destroy');
            $("<div id='jqxRedemptionList'></div>").appendTo(parent);

            //Loads redemptions
            var thisMemberId = $("#MemberId").html();

            var url = $("#apiDomain").val() + "members/" + thisMemberId + "/redemptions";

            var source =
            {
                datafields: [
                    { name: 'RedemptionId' },
                    { name: 'CertificateID' },
                    { name: 'RedemptionType', map: 'RedemptionType>RedemptionType' },
                    { name: 'RedeemDate' },
                    { name: 'IsReturned' },
                    { name: 'DateUsed' }
                ],

                id: 'CertificateID',
                type: 'Get',
                datatype: "json",
                url: url,
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                root: "data"
            };

            // create Redemption Grid
            $("#jqxRedemptionList").jqxGrid(
            {
                //pageable: true,
                //pagermode: 'advanced',
                //pagesize: 50,
                //pagesizeoptions: ['10', '20', '50', '100'],
                width: '100%',
                height: 300,
                source: source,
                rowsheight: 60,
                altrows: true,
                columns: [
                      {
                          text: 'Select', pinned: true, datafield: 'Select', width: 50, columntype: 'button', cellsrenderer: function () {
                              return "Select";
                          }, buttonclick: function (row) {
                              editrow = row;

                              var dataRecord = $("#jqxRedemptionList").jqxGrid('getrowdata', editrow);

                              showRedemption(dataRecord.RedemptionId);
                          },
                          width: '5%'
                      },
                      { text: 'RedemptionId', datafield: 'RedemptionId', hidden: true },
                      { text: 'CertificateID', datafield: 'CertificateID' },
                      { text: 'Redemption Type', datafield: 'RedemptionType' },
                      { text: 'Redeem Date', datafield: 'RedeemDate', cellsrenderer: DateRender },
                      { text: 'Returned', datafield: 'IsReturned' },
                      { text: 'DateUsed', datafield: 'DateUsed' }
                ]
            });
        }

        function showRedemption(thisRedemptionId) {

            $("#popupExistingRedemption").css('display', 'block');
            $("#popupExistingRedemption").css('visibility', 'hidden');

            $("#popupExistingRedemption").jqxWindow({ position: { x: '25%', y: '20%' } });
            $('#popupExistingRedemption').jqxWindow({ resizable: false });
            $('#popupExistingRedemption').jqxWindow({ draggable: true });
            $('#popupExistingRedemption').jqxWindow({ isModal: true });
            $("#popupExistingRedemption").css("visibility", "visible");
            $('#popupExistingRedemption').jqxWindow({ height: '290px', width: '290px' });
            $('#popupExistingRedemption').jqxWindow({ showCloseButton: true });
            $('#popupExistingRedemption').jqxWindow({ animationType: 'combined' });
            $('#popupExistingRedemption').jqxWindow({ showAnimationDuration: 300 });
            $('#popupExistingRedemption').jqxWindow({ closeAnimationDuration: 500 });
            $("#popupExistingRedemption").jqxWindow('open');

            var thisMemberId = $("#MemberId").html();

            $.ajax({
                type: 'GET',
                url: $("#apiDomain").val() + "members/" + thisMemberId + "/redemptions/" + thisRedemptionId,
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": $("#userGuid").val(),
                    "ApplicationKey": $("#AK").val()
                },
                success: function (thisData) {
                    var thisCertificateID = thisData.result.data.CertificateID;
                    var thisRedemptionType = thisData.result.data.RedemptionType.RedemptionType;
                    thisRedemptionType = thisRedemptionType.replace(" ", "%20");
                    var thisMemberName = thisData.result.data.Member.FirstName + '%20' + thisData.result.data.Member.LastName;
                    var thisFPNumber = thisData.result.data.Member.PrimaryFPNumber;
                    var thisQRCode = thisData.result.data.QrCodeString;

                    document.getElementById('redemptionIframe').src = './RedemptionDisplay.aspx?thisCertificateID=' + thisCertificateID + '&thisRedemptionType=' + thisRedemptionType + '&thisMemberName=' + thisMemberName + '&thisFPNumber=' + thisFPNumber + '&thisQRCode=' + thisQRCode;
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert("Error: " + errorThrown);
                }
            });
        }

        function loadMember(PageMemberID) {
            var locationId = 0;

            $.ajax({
                type: 'GET',
                url: $("#apiDomain").val() + "members/" + PageMemberID,
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": $("#userGuid").val(),
                    "ApplicationKey": $("#AK").val()
                },
                success: function (thisData) {
                    //Fill out member detail tab info
                    $("#memberAcctId").html(thisData.result.data.AccountId);
                    $("#MemberId").html(thisData.result.data.MemberId);
                    $("#memberName").html(thisData.result.data.FirstName + ' ' + thisData.result.data.LastName);
                    $("#memberEmail").html(thisData.result.data.EmailAddress);
                    $("#memberFPNumber").html(thisData.result.data.FPNumber);
                    $("#memberStreetAddress").html(thisData.result.data.StreetAddress);
                    $("#stateCombo").jqxComboBox('selectItem', thisData.result.data.StateId);
                    $("#stateCombo").jqxComboBox({ disabled: true });
                    $("#CompanyId").html(thisData.result.data.CompanyId);
                    loadRate();
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert("Error: " + errorThrown);
                },
                complete: function () {
                    //calls from common.js
                    var acctId = $("#memberAcctId").html();
                    loadPoints(acctId, $("#acctPoints"));
                    loadCards();
                    $("#redemptionRow").css("visibility", "visible");
                }
            });
        }


        function loadCards() {
            //set up the state combobox

            var thisMemberId = $("#MemberId").html();

            var cardSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'IsPrimary' },
                    { name: 'FPNumber' }
                ],
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                url: $("#apiDomain").val() + "members/" + thisMemberId + "/cards" ,

            };
            var cardDataAdapter = new $.jqx.dataAdapter(cardSource);
            $("#cardCombo").jqxDropDownList(
            {
                width: 250,
                height: 35,
                itemHeight: 35,
                source: cardDataAdapter,
                selectedIndex: 0,
                displayMember: "FPNumber",
                valueMember: "IsPrimary"
            });

            $("#cardCombo").on('bindingComplete', function (event) {
                var item = $("#cardCombo").jqxDropDownList('getItemByValue', "true");
                $("#cardCombo").jqxDropDownList('selectItem', item);
            });

        }

        //#endregion


    </script>

    <input type="text" id="boothLocation" style="display:none;" />
    <div id="searchContainer" class="container-fluid" style="width:100%;border:solid;border-image-width:1px;border-color:darkgreen;background-color:darkgreen;">
        <div class="row">
            <div class="col-sm-2" >
                
            </div>
            <div class="col-sm-9">
                <div id="buttonGroup">
                    <input type="button" id="btnSearchEmail" value="Email" style="margin-right:5px;" />
                    <input type="button" id="btnSearchFPNumber" value="FPNumber" style="margin-right:5px;" />
                    <input type="button" id="btnSearchName" value="Name" />
                </div>
            </div>
            <div class="col-sm-1">
                
            </div>
        </div>
        <div class="row" style="width:99%">
            <div class="col-sm-2">
                <input type="button" id="btnSearchClear" value="Clear" />
            </div>
            <div class="col-sm-9">
                <input type="Number" id="txtSearchEmailFNameFPNumber" style="font-size:x-large;margin-top:10px;" placeholder="FPNumber" />
            
                <input type="text" id="txtSearchLastName" style="font-size:x-large;margin-top:10px;" placeholder="Last Name"  />
            </div>
            <div class="col-sm-1">
                <input type="button" id="btnSearch" value="Search" style="margin-right:10px;float;" />
            </div>
        </div>

        <div class="row">
            <div class="col-sm-12" >
                <div id="jqxSearchGrid" style="margin-top:5px;"></div>
            </div>
        </div>
    
        <div class="row" id="redemptionRow" style="visibility:hidden">
            <div class="col-sm-2" >
                <input type="button" id="btn1Day" value="1 Day" style="margin-right:10px;margin-top:7px;" />
            </div>
            <div class="col-sm-2" >
                <input type="button" id="btn2Day" value="2 Day" style="margin-right:10px;margin-top:7px;display:none;" />
            </div>
            <div class="col-sm-2" >
                <input type="button" id="btn3Day" value="3 Day" style="margin-right:10px;margin-top:7px;" />
            </div>
            <div class="col-sm-2" >
                <input type="button" id="btn4Day" value="4 Day" style="margin-right:10px;margin-top:7px;display:none;" />
            </div>
            <div class="col-sm-2" >
                <input type="button" id="btnWeek" value="Week" style="margin-right:10px;margin-top:7px;" />
            </div>
            <div class="col-sm-2" >
                <input type="button" id="btnReceipt" value="Receipt" style="margin-right:10px;margin-top:7px;" />
            </div>
        </div>
    </div>


    <div id="popupLocation" style="display:none">
        <div>
            <div id="LocationCombo" style="float:left;"></div>
        </div>
    </div>

    <div id="popupMember" style="display:none">
        <div>
            <div id="MemberInfo" style="width: 50%;float:left">
                <div><label id="CompanyId" style="display:none"></label></div>
                <div><label id="MemberId" style="display:none"></label></div>
                <div><label id="memberAcctId"style="display:none"></label></div>
                <div style="margin-top:10px">Name: <label id="memberName" style="float:right"></label></div>
                <div style="margin-top:10px">Email: <label id="memberEmail" style="float:right"></label></div>
                <div style="margin-top:10px">Card: <div id="cardCombo" style="float:right"></div></div>
                <div style="margin-top:10px">Address: <label id="memberStreetAddress" style="float:right"></label></div>
                <div style="margin-top:10px">State: <div id="stateCombo" style="float:right;" ></div></div>  
                <div style="margin-top:10px">
                    <table style="width:100%;" >
                        <tr>
                            <td style="width:30%">Rate:</td>
                            <td style="width:70%"><div id="memberRate" style="float:right;" ></div></td>
                        </tr>
                    </table>
                </div>  
                <div style="margin-top:10px">Points: <label id="acctPoints" style="float:right;color:red;"></label></div>
            </div>
            <div id="MemberInfo2" style="float:right;width:35%;">
                <iframe id="qrIframe" style="border:none;width=255px;height:275px;" ></iframe>
                <!--<div style="margin-top:10px;position:absolute;float:left"><div id="qrcode"></div></div>-->
            </div>
            <div style="margin-top:300px;width = 100%;">
                <div style="float:left;margin-left:50px"><input type="button" id="changeEmail" value="Update Email"  /></div>
                <div><input type="button" id="showRedemptionList" value="Redemptions" style="position:absolute;margin-left:50px;"  /></div>
                <div style="float:right;margin-right:50px"><input type="button" id="closeMemberInfo" value="Back" /></div>
            </div>
        </div>
    </div>

    <div id="popupNewEmail" style="display:none">
        <div>
            <div><input type="email" style="margin-top:20px" id="oldEmail" placeholder="Old Email Address" /></div>
            <div><input type="email" style="margin-top:20px" id="newEmail" placeholder="New Email Address" /></div>
            <div>
                <input type="button" style="float:left;margin-top:70px" id="newEmailCancel" value="Cancel" />
                <input type="button" style="float:right;margin-top:70px" id="newEmailSubmit" value="Submit" />
            </div>
        </div>
    </div>

    <div id="popupRedemption" style="display:none">
        <div>
            <div><iframe id="renderRedemption"  style="border:none;width=255px;height:275px;margin-left:20px;" ></iframe></div>
            <div>Certificate ID: <label id="redemptionCertificateID"></label></div>
            <div>Redeem Date: <label id="redemptionRedeemDate"></label></div>
            <div>Redemption Type: <label id="redemptionRedemptionType"></label></div>
            <div>Point Value: <label id="redemptionPointValue"></label></div>
        </div>
    </div>

    <div id="popupReceipt" style="display:none">
        <div>
            <div style="width:100%;text-align:center">Entry Date</div>
            <div><div id="jqxReceiptCalendar" style="margin-left:40px;"></div></div>
            <div><input type="number" id="receiptNumber" placeholder="Receipt Number" style="margin-left:75px;margin-top:10px;" /></div>
            <div><input type="button" id="receiptSave" value="Save" style="float:left;margin-top:10px;" /><input type="button" id="receiptCancel" value="Cancel" style="float:right;margin-top:10px;" /></div>
        </div>
    </div>

    <div id="popupRedemptionList" style="display:none">
        <div>
            <div id="redemptionListContainer">
                <div id="jqxRedemptionList"></div>
            </div>
            <div style="float:right;margin-top:10px;">
                <input type="button" id="closeRedemptionList" value="Back" />
            </div>
        </div>
    </div>

    <div id="popupExistingRedemption" style="display: none;">
        <div>Redemption Code</div>
        <div>
            <iframe id="redemptionIframe" style="height:325px; width:350px; border:none;"  ></iframe>
        </div>
    </div>

    <div id="jqxLoader"></div>
</asp:Content>

