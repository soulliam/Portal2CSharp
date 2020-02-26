<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceWCClaim.aspx.cs" Inherits="InsuranceWCClaim" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <link rel="stylesheet" href="jqwidgets/styles/jqx.base.css" type="text/css" />
    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>

    <script type="text/javascript" src="jqwidgets/globalization/globalize.js"></script>

    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.edit.js"></script>    
    <script type="text/javascript" src="jqwidgets/jqxgrid.aggregates.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.columnsreorder.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.columnsresize.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcombobox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdata.js"></script>     
    <script type="text/javascript" src="jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.filter.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.grouping.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.pager.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.selection.js"></script> 
    <script type="text/javascript" src="jqwidgets/jqxgrid.sort.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>    
    <script type="text/javascript" src="jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdata.export.js"></script> 
    <script type="text/javascript" src="jqwidgets/jqxgrid.export.js"></script>


    <script>
        var group = '<%= Session["groupList"] %>';
        var WCClaimID = "";

        $(document).ready(function () {
            var noteNumber = 0;

            $("#addNote").on('click', function (e) {
                noteNumber = noteNumber + 1;

                NoteInfoBuild = claimNote;
                NoteInfoBuild = NoteInfoBuild.replace(/ClaimNote1/g, 'ClaimNote' + (noteNumber).toString());
                NoteInfoBuild = NoteInfoBuild.replace('NOTE 1', 'NOTE ' + (noteNumber).toString());
                var insertAt = "#ClaimNote" + (noteNumber - 1).toString();
                if (noteNumber == 1) {
                    $('#topTable').after(NoteInfoBuild);
                } else {
                    $(insertAt).after(NoteInfoBuild);
                }
                var thisFocus = "#noteClaimNote" + (noteNumber).toString();
                $(thisFocus).focus();
                var enteredBy = "#EnteredByClaimNote" + (noteNumber).toString();
                $(enteredBy).val($("#txtLoggedinUsername").val());
                var thisDate = "#DateClaimNote" + (noteNumber).toString();
                $(thisDate).val(DateTimeFormat(new Date()));
            });

            loadPCARep();

            const params = new URLSearchParams(window.location.search);
            WCClaimID = params.get("WCClaimID");
            $("#WCClaimID").val(WCClaimID);

            loadLocations();
            loadWCCLaim(WCClaimID);

            Security();
        });

        function loadWCCLaim(WCClaimID) {
            var url = $("#localApiDomain").val() + "InsuranceWCClaims/GetWCClaimByID/" + WCClaimID;
            //var url = "http://localhost:52839/api/InsuranceWCClaims/GetWCClaimByID/" + WCClaimID;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        $("#IncidentID").val(data[0].IncdidentID);
                        $("#WCClaimNumber").val(data[0].WCClaimNumber);
                        $("#IncidentNumber").val(data[0].IncidentNumber + '-' + data[0].ClaimId);
                        $("#WCIncidentDate").val(DateFormat(data[0].WCIncidentDate));
                        $("#ClaimantName").val(data[0].ClaimantName);
                        var getLocationOption = '#location option[value=' + data[0].LocationId + ']';
                        $(getLocationOption).prop("selected", true);
                        $("#ReportedToCarrierDate").val(DateFormatForHTML5(data[0].ReportedToCarrierDate));
                        $("#PolicyTypeID option[value=" + data[0].PolicyTypeID + "]").prop('selected', true);
                        $("#PCAInsuranceNumber").val(data[0].PCAInsuranceNumber);
                        $("#OSHALog").val(data[0].OSHALog);
                        $("#WCClaimStatusID").val(WCClaimStatusID);
                        $("#WCClaimStatusDate").val(DateFormatForHTML5(data[0].WCClaimStatusDate));
                        $("#DaysMissed").val(data[0].DaysMissed);
                        $("#NumberOfDaysMissed").val(data[0].NumberOfDaysMissed);
                        $("#LiteRelease").val(data[0].LiteRelease);
                        $("#NumberOfLiteDutyDays").val(data[0].NumberOfLiteDutyDays);
                        $("#FullReleaseDate").val(DateFormatForHTML5(data[0].FullReleaseDate));
                        $("#DateReturnedToWork").val(DateFormatForHTML5(data[0].DateReturnedToWork));
                        $("#FollowUpApptDate").val(DateFormatForHTML5(data[0].FollowUpApptDate));
                        $("#ImpairmentRating").val(data[0].ImpairmentRating);
                        $("#JobClass").val(data[0].JobClass);
                        $("#RepFollowUpDate").val(DateFormatForHTML5(data[0].RepFollowUpDate));
                        $("#ModifiedDutyRequired option[value=" + data[0].ModifiedDutyRequired + "]").prop('selected', true);
                        $("#Subro").val(data[0].Subro);
                        $("#IndemnityCompPaid").val(data[0].IndemnityCompPaid);
                        $("#IndemnityCompReserve").val(data[0].IndemnityCompReserve);
                        $("#MedicalPaid").val(data[0].MedicalPaid);
                        $("#MedicalReserve").val(data[0].MedicalReserve);
                        $("#WCClaimExpensePaid").val(data[0].WCClaimExpensePaid);
                        $("#WCExpenseReserve").val(data[0].WCExpenseReserve);
                        $("#SubroAmount").val(data[0].SubroAmount);
                        $("#Settlement").val(data[0].Settlement);
                        $("#PoliceReportNumber").val(data[0].PoliceReportNumber);
                        $("#PCAReceivedClaimDate").val(JsonDateNoTimeFormat(data[0].PCAReceivedClaimDate));
                        $("#PCARepID option[value=" + data[0].PCARepID + "]").prop('selected', true);
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting WC information.");
                }
            }).then(function () {

            });
        }

        function loadLocations() {
            var locationString = $("#userVehicleLocation").val();
            var dropdown = $('#location');

            dropdown.empty();

            dropdown.append('<option selected="true">Location</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/InsuranceLocations/GetUserLocations/" + locationString;
            var url = $("#localApiDomain").val() + "InsuranceLocations/GetUserLocations/" + locationString;

            $.ajax({
                type: "GET",
                async: "false",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append("<option value='" + data[i].LocationID + "' style='font-weight: bold;'>" + data[i].LocationName + "</option>");
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting location information.");
                }
            });
        }

        function loadPCARep() {
            var dropdown = $('#PCARepAssigned');

            dropdown.empty();

            dropdown.append('<option selected="true"></option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/Claims/GetPCAReps/";
            var url = $("#localApiDomain").val() + "Claims/GetPCAReps/";

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append($("<option style='font-weight: bold;'></option>").attr("value", data[i].PCARepID).text(data[i].PCARepName));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting PCA Reps.");
                }
            });
        }
    </script>
    
    <style>
        .jqxDateTimeInputBackground{
          background-color:lightgray;
        }
        .xl1532610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl6732610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl6832610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"_\(\0022$\0022* \#\,\#\#0\.00_\)\;_\(\0022$\0022* \\\(\#\,\#\#0\.00\\\)\;_\(\0022$\0022* \0022-\0022??_\)\;_\(\@_\)";
	        text-align:general;
	        vertical-align:bottom;
	        border:1.0pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl6932610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7032610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7132610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:right;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7232610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7332610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"_\(\0022$\0022* \#\,\#\#0\.00_\)\;_\(\0022$\0022* \\\(\#\,\#\#0\.00\\\)\;_\(\0022$\0022* \0022-\0022??_\)\;_\(\@_\)";
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7432610
	        {padding:0px;
	        mso-ignore:padding;
	        color:white;
	        font-size:11.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        background:black;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl7532610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"Short Date";
	        text-align:general;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7632610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        background:#DBDBDB;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl7732610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"_\(\0022$\0022* \#\,\#\#0\.00_\)\;_\(\0022$\0022* \\\(\#\,\#\#0\.00\\\)\;_\(\0022$\0022* \0022-\0022??_\)\;_\(\@_\)";
	        text-align:general;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        background:#DBDBDB;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl7832610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"_\(\0022$\0022* \#\,\#\#0\.00_\)\;_\(\0022$\0022* \\\(\#\,\#\#0\.00\\\)\;_\(\0022$\0022* \0022-\0022??_\)\;_\(\@_\)";
	        text-align:general;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:.5pt solid windowtext;
	        border-bottom:none;
	        border-left:.5pt solid windowtext;
	        background:#DBDBDB;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl7932610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"mm\/dd\/yy\;\@";
	        text-align:general;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        background:#DBDBDB;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8032610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"mm\/dd\/yy\;\@";
	        text-align:center;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8132610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"_\(\0022$\0022* \#\,\#\#0\.00_\)\;_\(\0022$\0022* \\\(\#\,\#\#0\.00\\\)\;_\(\0022$\0022* \0022-\0022??_\)\;_\(\@_\)";
	        text-align:center;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8232610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"Short Date";
	        text-align:general;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        background:#DBDBDB;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8332610
	        {padding:0px;
	        mso-ignore:padding;
	        color:red;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8432610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        border:1.0pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8532610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"Short Date";
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8632610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        background:#D9D9D9;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8732610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:12.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8832610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:12.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border-top:1.0pt solid windowtext;
	        border-right:none;
	        border-bottom:1.0pt solid windowtext;
	        border-left:1.0pt solid windowtext;
	        background:#92D050;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8932610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:12.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border-top:1.0pt solid windowtext;
	        border-right:none;
	        border-bottom:1.0pt solid windowtext;
	        border-left:none;
	        background:#92D050;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl9032610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:12.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border-top:1.0pt solid windowtext;
	        border-right:1.0pt solid windowtext;
	        border-bottom:1.0pt solid windowtext;
	        border-left:none;
	        background:#92D050;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl9132610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border-top:none;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl9232610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl9332610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl9432610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:.5pt solid windowtext;
	        background:#DBDBDB;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl9532610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        background:#DBDBDB;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl9632610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:.5pt solid windowtext;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        background:#DBDBDB;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl9732610
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:.5pt solid windowtext;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        </style>
        

        <div align=center>
        <input type="text" id="WCCliamID" style="display:none" />
        <table id="topTable" border=0 cellpadding=0 cellspacing=0 width=798 style='border-collapse:collapse;table-layout:fixed;width:601pt'>
         <col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=180 style='mso-width-source:userset;mso-width-alt:6582;width:135pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1532610 width=18 style='height:15.75pt;width:14pt'><a
          name="RANGE!A1:I46"></a><a name="RANGE!A1"></a></td>
          <td class=xl1532610 width=177 style='width:133pt'></td>
          <td class=xl1532610 width=17 style='width:13pt'></td>
          <td class=xl1532610 width=180 style='width:135pt'></td>
          <td class=xl1532610 width=17 style='width:13pt'></td>
          <td class=xl1532610 width=177 style='width:133pt'></td>
          <td class=xl1532610 width=17 style='width:13pt'></td>
          <td class=xl1532610 width=177 style='width:133pt'></td>
          <td class=xl1532610 width=18 style='width:14pt'></td>
         </tr>
         <tr height=22 style='height:16.5pt'>
          <td height=22 class=xl1532610 style='height:16.5pt'></td>
          <td colspan=7 class=xl8832610 style='border-right:1.0pt solid black'>WORKERS
          COMPENSATION CLAIM</td>
          <td class=xl8732610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1532610 style='height:15.75pt'></td>
          <td class=xl7032610>PCA WC CLAIM #</td>
          <td class=xl1532610></td>
          <td class=xl7032610>COMPANION PCA INCIDENT</td>
          <td class=xl1532610></td>
          <td class=xl7032610>EMPLOYEE NAME</td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1532610 style='height:15.75pt'></td>
          <td class=xl8432610><input type='text' id='WCClaimNumber' style='border:none' /></td>
          <td class=xl1532610></td>
          <td class=xl6732610><input type='text' id='IncidentNumber' style='border:none' /></td>
          <td class=xl1532610></td>
          <td colspan=3 class=xl9232610 style='border-right:.5pt solid black'><input type='text' id='ClaimantName' style='border:none' /></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl7032610>DATE OF INCIDENT</td>
          <td class=xl7032610></td>
          <td class=xl7032610>LOCATION<span style='mso-spacerun:yes'> </span></td>
          <td class=xl7032610></td>
          <td class=xl7032610>DATE REPORTED TO CARRIER</td>
          <td class=xl7032610></td>
          <td class=xl7032610>POLICY TYPE</td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl7532610><input type='text' id='WCIncidentDate' style='border:none' /></td>
          <td class=xl1532610></td>
          <td class=xl6732610><select id="location" style="border:none"></select></td>
          <td class=xl1532610></td>
          <td class=xl7632610><div id="ReportedToCarrierDate" style="border:none"></div></td>
          <td class=xl1532610></td>
          <td class=xl7632610>
            <select id="PolicyTypeID" style='border:none;background-color:#DBDBDB'>
                <option value=""></option>
                <option value="Lost Time">Lost Time</option>
                <option value="Medical">Medical</option>
            </select>
          </td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl7032610>PCA INSURANCE NO.</td>
          <td class=xl1532610></td>
          <td class=xl7032610>OSHA LOG</td>
          <td class=xl1532610></td>
          <td class=xl7032610>STATUS</td>
          <td class=xl1532610></td>
          <td class=xl7032610>STATUS DATE</td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl8632610><input type='text' id='PCAInsuranceNumber' style='border:none;background-color:#DBDBDB' /></td>
          <td class=xl1532610></td>
          <td class=xl8632610><input type='text' id='OSHALog' style='border:none;background-color:#DBDBDB' /></td>
          <td class=xl1532610></td>
          <td class=xl7632610>
            <select id="WCClaimStatusID" style='border:none;background-color:#DBDBDB'>
                <option value=""></option>
                <option value="Open">Open</option>
                <option value="Closed">Closed</option>
                <option value="Report Only">Report Only</option>
            </select>
          </td>
          <td class=xl1532610></td>
          <td class=xl8032610><input type="date" id="WCClaimStatusDate" style="border:none"></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl7032610>DAYS MISSED</td>
          <td class=xl1532610></td>
          <td class=xl7032610>NUMBER OF DAYS MISSED</td>
          <td class=xl1532610></td>
          <td class=xl7032610>LITE RELEASE</td>
          <td class=xl1532610></td>
          <td class=xl7032610>NO. OF LITE DUTY DAYS</td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl8632610>
              <select id="DaysMissed" style='border:none;background-color:#DBDBDB'>
                <option value=""></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
            </select>
          </td>
          <td class=xl1532610></td>
          <td class=xl8632610><input type='text' id='NumberOfDaysMissed' style='border:none;background-color:#DBDBDB' /></td>
          <td class=xl1532610></td>
          <td class=xl8632610><input type='text' id='LiteRelease' style='border:none;background-color:#DBDBDB' /></td>
          <td class=xl1532610></td>
          <td class=xl8632610><input type='text' id='NumberOfLiteDutyDays' style='border:none;background-color:#DBDBDB' /></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl7032610>FULL RELEASE DATE</td>
          <td class=xl1532610></td>
          <td class=xl7032610>DATE RETURNED TO WORK</td>
          <td class=xl1532610></td>
          <td class=xl7032610>FOLLOW UP APPT</td>
          <td class=xl1532610></td>
          <td class=xl7032610>IMPAIRMENT RATING</td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl8632610><input type="date" id="FullReleaseDate" style="border:none" /></td>
          <td class=xl1532610></td>
          <td class=xl8632610><input type="date" id="DateReturnedToWork" style="border:none" /></td>
          <td class=xl1532610></td>
          <td class=xl8632610><input type='date' id='FollowUpApptDate' style='border:none;background-color:#DBDBDB' /></td>
          <td class=xl1532610><span style='mso-spacerun:yes'> </span></td>
          <td class=xl8632610><input type='text' id='ImpairmentRating' style='border:none;background-color:#DBDBDB' /></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl7032610>JOB CLASS</td>
          <td class=xl1532610></td>
          <td class=xl7032610>REP FOLLOW UP DATE</td>
          <td class=xl1532610></td>
          <td class=xl7032610>MODIFIED DUTY REQUIRED</td>
          <td class=xl1532610></td>
          <td class=xl7032610>SUBRO</td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl8632610><input type='text' id='JobClass' style='border:none;background-color:#DBDBDB' /></td>
          <td class=xl1532610><span style='mso-spacerun:yes'> </span></td>
          <td class=xl8632610><input type="date" id="repFollowUpDate" style="border:none" /></td>
          <td class=xl1532610></td>
          <td class=xl8632610>
            <select id="ModifiedDutyRequired" style='border:none;background-color:#DBDBDB'>
                <option value=""></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
            </select>
          </td>
          <td class=xl1532610></td>
          <td class=xl8632610><input type='text' id='Subro' style='border:none;background-color:#DBDBDB' /></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl7032610>EXPENSE TYPE</td>
          <td class=xl7232610></td>
          <td class=xl7032610>AMOUNT<span style='mso-spacerun:yes'> </span></td>
          <td class=xl1532610></td>
          <td class=xl7032610><span style='mso-spacerun:yes'> </span></td>
          <td class=xl1532610></td>
          <td class=xl7032610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610>Indemnity Comp Paid</td>
          <td class=xl1532610></td>
          <td class=xl7732610><input type='text' id='IndemnityCompPaid' style='border:none;background-color:#DBDBDB' /></td>
          <td class=xl1532610></td>
          <td class=xl7332610></td>
          <td class=xl1532610></td>
          <td class=xl7332610><span style='mso-spacerun:yes'>   </span></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610>Indemnity Comp Reserve</td>
          <td class=xl1532610></td>
          <td class=xl7732610 style='border-top:none'><input type='text' id='IndemnityCompReserve' style='border:none;background-color:#DBDBDB' /></td>
          <td class=xl1532610></td>
          <td class=xl7332610></td>
          <td class=xl1532610></td>
          <td class=xl7332610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610>Medical Paid</td>
          <td class=xl1532610></td>
          <td class=xl7732610 style='border-top:none'><input type='text' id='MedicalPaid' style='border:none;background-color:#DBDBDB' /></td>
          <td class=xl1532610></td>
          <td class=xl7032610></td>
          <td class=xl1532610></td>
          <td class=xl7332610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610>Medical Reserve</td>
          <td class=xl1532610></td>
          <td class=xl7732610 style='border-top:none'><input type='text' id='MedicalReserve' style='border:none;background-color:#DBDBDB' /></td>
          <td class=xl1532610></td>
          <td class=xl7332610></td>
          <td class=xl1532610></td>
          <td class=xl7332610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610>Claim Expense Paid</td>
          <td class=xl1532610></td>
          <td class=xl7732610 style='border-top:none'><input type='text' id='WCClaimExpensePaid' style='border:none;background-color:#DBDBDB' /></td>
          <td class=xl1532610></td>
          <td class=xl7332610></td>
          <td class=xl1532610></td>
          <td class=xl7332610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610>Claim Expense Reserve</td>
          <td class=xl1532610></td>
          <td class=xl7732610 style='border-top:none'><input type='text' id='WCExpenseReserve' style='border:none;background-color:#DBDBDB' /></td>
          <td class=xl1532610></td>
          <td class=xl7332610></td>
          <td class=xl1532610></td>
          <td class=xl7332610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610>Subro</td>
          <td class=xl1532610></td>
          <td class=xl7732610 style='border-top:none'><input type='text' id='SubroAmount' style='border:none;background-color:#DBDBDB' /></td>
          <td class=xl1532610></td>
          <td class=xl8132610></td>
          <td class=xl1532610></td>
          <td class=xl8132610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1532610 style='height:15.75pt'></td>
          <td class=xl1532610>Settlement</td>
          <td class=xl1532610></td>
          <td class=xl7832610 style='border-top:none'><input type='text' id='Settlement' style='border:none;background-color:#DBDBDB' /></td>
          <td class=xl1532610></td>
          <td class=xl7332610></td>
          <td class=xl1532610></td>
          <td class=xl7332610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1532610 style='height:15.75pt'></td>
          <td class=xl7132610>TOTAL INCURRED</td>
          <td class=xl1532610></td>
          <td class=xl6832610><input type='text' id='TotalIncurred' style='border:none;' /></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl7332610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl7032610>POLICE REPORT #<span style='mso-spacerun:yes'> </span></td>
          <td class=xl7232610></td>
          <td class=xl7032610>DATE PCA RECEIVED CLAIM</td>
          <td class=xl7232610></td>
          <td class=xl7032610>PCA REP ASSIGNED</td>
          <td class=xl7232610></td>
          <td class=xl7032610></td>
          <td class=xl7232610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl7532610><input type='text' id='PoliceReportNumber' style='border:none;' /></td>
          <td class=xl1532610></td>
          <td class=xl7532610><input type="text" id="PCAReceivedClaimDate" style="border:none" /></td>
          <td class=xl1532610></td>
          <td class=xl7932610><select id="PCARepAssigned" style='background-color:#E7E6E6;border:none'></select></td>
          <td class=xl1532610></td>
          <td class=xl8532610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
         </tr>
        </table>
        <table id="bottomTable" border=0 cellpadding=0 cellspacing=0 width=798 style='border-collapse:
         collapse;table-layout:fixed;width:601pt'>
         <col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=180 style='mso-width-source:userset;mso-width-alt:6582;width:135pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl7432610><input id="addNote" type="button" value="ADD NOTE" style="background-color:black;color:white" /></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl6932610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl7432610>CLAIM DOCUMENTS</td>
          <td class=xl1532610></td>
          <td class=xl7432610>SAVE &amp; SUBMIT</td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=0 style='display:none'>
          <td class=xl1532610></td>
          <td class=xl7432610 style='border-top:none'>ADD MULTIPLE CLAIMS</td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=0 style='display:none'>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610><span style='mso-spacerun:yes'> </span></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl7432610>CLOSE CLAIM</td>
          <td class=xl1532610></td>
          <td class=xl8332610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1532610 style='height:15.0pt'></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610></td>
          <td class=xl1532610><span style='mso-spacerun:yes'> </span></td>
          <td class=xl1532610></td>
         </tr>
         <![if supportMisalignedColumns]>
         <tr height=0 style='display:none'>
          <td width=18 style='width:14pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=180 style='width:135pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=18 style='width:14pt'></td>
         </tr>
         <![endif]>
        </table>

        </div>

    <script>
        var claimNote = "<table id='ClaimNote1' border=0 cellpadding=0 cellspacing=0 width=798 style='border-collapse:collapse;table-layout:fixed;width:601pt'>" +
                "<col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>" +
                 "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=180 style='mso-width-source:userset;mso-width-alt:6582;width:135pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>" +
				"<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td colspan=5 class=xl7032610>NOTE 1</td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl7032610>DATE OF NOTE</td>" +
				  "<td class=xl7325500></td>" +
				 "</tr>" +
				 "<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td colspan=5 rowspan=3 class=xl9225500 style='border-right:.5pt solid black'>" +
					  "<textarea id='noteClaimNote1' class='auto-style1' cols='20' style='background-color:#E7E6E6;border:none;margin: 0px; height: 61px;'></textarea></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl6725500>" +
					  "<input id='DateClaimNote1' type='text' style='background-color:#E7E6E6;border:none' disabled/></td>" +
				  "<td class=xl1525500></td>" +
				 "</tr>" +
				 "<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				 "</tr>" +
				 "<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl7032610>NOTE ENTERED BY</td>" +
				  "<td class=xl1525500></td>" +
				 "</tr>" +
				 "<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl6725500>" +
					  "<input id='EnteredByClaimNote1' type='text' style='background-color:#E7E6E6;border:none' disabled/></td>" +
				  "<td class=xl1525500></td>" +
				 "</tr>" +
				 "<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				 "</tr>" +
				 "</table>";
    </script>
</asp:Content>

