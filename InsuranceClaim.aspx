<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceClaim.aspx.cs" Inherits="InsuranceClaim" %>

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
        var noteNumber = 0;
        var payableNumber = 0;
        var receivableNumber = 0;

        $(document).ready(function () {

            //$("#Button1").on('click', function () {
            //    window.print();
            //});
            
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

            $("#addPayable").on('click', function (e) {
                payableNumber = payableNumber + 1;

                payableInfoBuild = payable;
                payableInfoBuild = payableInfoBuild.replace(/Payable1/g, 'Payable' + (payableNumber).toString());
                var insertAt = "#Payable" + (payableNumber - 1).toString();
                if (payableNumber == 1) {
                    $('#payableTable').after(payableInfoBuild);
                } else {
                    $(insertAt).after(payableInfoBuild);
                }

            });

            $("#addReceivable").on('click', function (e) {
                receivableNumber = receivableNumber + 1;

                receivableInfoBuild = receivable;
                receivableInfoBuild = receivableInfoBuild.replace(/Receivable1/g, 'Receivable' + (receivableNumber).toString());
                var insertAt = "#Receivable" + (receivableNumber - 1).toString();
                if (receivableNumber == 1) {
                    $('#receivableTable').after(receivableInfoBuild);
                } else {
                    $(insertAt).after(receivableInfoBuild);
                }

            });

            loadLocations();
            loadClaimType();
            loadPolicyType();
            loadClaimStatus();
            loadPCARep();
            loadPendingClaimStatus();
            $("#incidentDate").jqxDateTimeInput({ width: '175px', height: '25px', formatString: 'd' });
            $("#statusDate").jqxDateTimeInput({ width: '173px', height: '25px', formatString: 'd' });
        });

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
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append($("<option style='font-weight: bold;'></option>").attr("value", data[i].LocationId).text(data[i].LocationName));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting location information.");
                }
            });
        }

        function loadClaimType() {
            var dropdown = $('#claimType');

            dropdown.empty();

            dropdown.append('<option selected="true">Claim Type</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/Claims/GetClaimTypes/";
            var url = $("#localApiDomain").val() + "Claims/GetClaimTypes/";

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append($("<option style='font-weight: bold;'></option>").attr("value", data[i].ClaimTypeID).text(data[i].ClaimTypeDesc));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting claim type information.");
                }
            });
        }

        function loadPolicyType() {
            var dropdown = $('#policyType');

            dropdown.empty();

            dropdown.append('<option selected="true">Policy Type</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/Claims/GetPolicyTypes/";
            var url = $("#localApiDomain").val() + "Claims/GetPolicyTypes/";

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append($("<option style='font-weight: bold;'></option>").attr("value", data[i].PolicyTypeID).text(data[i].PolicyTypeDesc));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting policy type information.");
                }
            });
        }

        function loadClaimStatus() {
            var dropdown = $('#claimStatus');

            dropdown.empty();

            dropdown.append('<option selected="true">Claim Status</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/Claims/GetClaimStatuses/";
            var url = $("#localApiDomain").val() + "Claims/GetClaimStatuses/";

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append($("<option style='font-weight: bold;'></option>").attr("value", data[i].ClaimStatusID).text(data[i].ClaimStatusDesc));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting claim status information.");
                }
            });
        }

        function loadPendingClaimStatus() {
            var dropdown = $('#pendingClaimStatus');

            dropdown.empty();

            dropdown.append('<option selected="true">Pending Status</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/Claims/GetPendingClaimStatuses/";
            var url = $("#localApiDomain").val() + "Claims/GetPendingClaimStatuses/";

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append($("<option style='font-weight: bold;'></option>").attr("value", data[i].PendingClaimStatusID).text(data[i].PendingClaimStatusDesc));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting pending claim status information.");
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
        .xl1525500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl6725500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl6825500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl6925500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl7025500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl7125500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl7225500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7325500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl7425500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl7525500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl7625500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl7725500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl7825500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl7925500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
	        background:#E7E6E6;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8025500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
	        background:#E7E6E6;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8125500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
	        background:#E7E6E6;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8225500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
	        background:black;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8325500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl8425500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8525500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl8625500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8725500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl8825500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl8925500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl9025500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl9125500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
        .xl9225500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
	        background:#E7E6E6;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl9325500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
	        background:#E7E6E6;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl9425500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
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
	        background:#E7E6E6;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .auto-style1 {
            padding-top: 1px;
            padding-right: 1px;
            padding-left: 1px;
            mso-ignore: padding;
            color: black;
            font-size: 11.0pt;
            font-weight: 400;
            font-style: normal;
            text-decoration: none;
            font-family: Calibri, sans-serif;
            mso-font-charset: 0;
            mso-number-format: General;
            text-align: general;
            vertical-align: bottom;
            mso-background-source: auto;
            mso-pattern: auto;
            white-space: nowrap;
            height: 14pt;
        }
        .auto-style2 {
            padding-top: 1px;
            padding-right: 1px;
            padding-left: 1px;
            mso-ignore: padding;
            color: black;
            font-size: 11.0pt;
            font-weight: 700;
            font-style: normal;
            text-decoration: none;
            font-family: Calibri, sans-serif;
            mso-font-charset: 0;
            mso-number-format: General;
            text-align: center;
            vertical-align: bottom;
            mso-background-source: auto;
            mso-pattern: auto;
            white-space: nowrap;
            height: 14pt;
        }
        .auto-style3 {
            padding-top: 1px;
            padding-right: 1px;
            padding-left: 1px;
            mso-ignore: padding;
            color: black;
            font-size: 11.0pt;
            font-weight: 400;
            font-style: normal;
            text-decoration: none;
            font-family: Calibri, sans-serif;
            mso-font-charset: 0;
            mso-number-format: General;
            text-align: general;
            vertical-align: bottom;
            mso-background-source: auto;
            mso-pattern: auto;
            white-space: nowrap;
            height: 15pt;
        }
        -->
        </style>


        <div id="Main" align=center>

        <table id="topTable" border=0 cellpadding=0 cellspacing=0 width=795 style='border-collapse:collapse;table-layout:fixed;width:598pt'>
         <col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <tr height=16 style='mso-height-source:userset;height:12.0pt'>
          <td height=16 class=xl1525500 width=19 style='height:12.0pt;width:14pt'><a
          name="RANGE!A1"></a></td>
          <td class=xl1525500 width=177 style='width:133pt'></td>
          <td class=xl1525500 width=17 style='width:13pt'></td>
          <td class=xl1525500 width=177 style='width:133pt'></td>
          <td class=xl1525500 width=17 style='width:13pt'></td>
          <td class=xl1525500 width=177 style='width:133pt'></td>
          <td class=xl1525500 width=17 style='width:13pt'></td>
          <td class=xl1525500 width=177 style='width:133pt'></td>
          <td class=xl1525500 width=17 style='width:13pt'></td>
         </tr>
         <tr height=22 style='height:16.5pt'>
          <td height=22 class=xl1525500 style='height:16.5pt'></td>
          <td colspan=7 class=xl8825500 style='border-right:1.0pt solid black'>CLAIMS -
          LIABILITIES/VEHICLES</td>
          <td class=xl8725500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7025500>DATE OF INCIDENT</td>
          <td class=xl7025500></td>
          <td class=xl7025500>CLAIM TYPE</td>
          <td class=xl7025500></td>
          <td class=xl7025500>LOCATION</td>
          <td class=xl7025500></td>
          <td class=xl7025500>POLICY TYPE</td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl6725500>
              <div id="incidentDate" style="border:none"></div></td>
          <td class=xl1525500></td>
          <td class=xl7925500>
              <select id="claimType" style='background-color:#E7E6E6;border:none'></select></td>
          <td class=xl1525500></td>
          <td class=xl6725500><select id="location" style="border:none"></select></td>
          <td class=xl1525500></td>
          <td class=xl7925500>
              <select id="policyType" style='background-color:#E7E6E6;border:none'></select></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl7025500>PCA INCIDENT # - CLAIM #</td>
          <td class=xl1525500></td>
          <td class=xl7025500>PCA EMP INVOLVED</td>
          <td class=xl1525500></td>
          <td class=xl7025500>STATUS</td>
          <td class=xl1525500></td>
          <td class=xl7025500>STATUS DATE</td>
          <td class=xl1525500></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl8325500>
              <input id="IncidentClaimNumber" type="text" style="border:none" /></td>
          <td class=xl1525500></td>
          <td class=xl6725500>
              <input id="EmployeeEnvolved" type="text" style="border:none" /></td>
          <td class=xl1525500></td>
          <td class=xl7925500>
              <select id="claimStatus" style='background-color:#E7E6E6;border:none'></select></td>
          <td class=xl1525500></td>
          <td class=xl7225500>
              <div id="statusDate" style="border:none"></div></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7025500>CLAIMANT NAME</td>
          <td class=xl1525500></td>
          <td class=xl7025500>REP FOLLOW UP DATE</td>
          <td class=xl1525500></td>
          <td class=xl7025500>PENDING STATUS</td>
          <td class=xl1525500></td>
          <td class=xl7025500>PCA VEHICLE NO.</td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl6725500>
              <input id="ClaimantName" type="text" style="border:none" /></td>
          <td class=xl1525500></td>
          <td class=xl8525500>
              <input id="RepFollowUpDate" type="text"  style='background-color:#E7E6E6;border:none' /></td>
          <td class=xl1525500></td>
          <td class=xl7925500>
              <select id="pendingClaimStatus" style='background-color:#E7E6E6;border:none' /></td>
          <td class=xl1525500></td>
          <td class=xl6725500>
              <input id="PCAVehicleNumber" type="text" style="border:none" /></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr>
          <td class=auto-style3></td>
          <td class=auto-style3></td>
          <td class=auto-style3></td>
          <td class=auto-style3></td>
          <td class=auto-style3></td>
          <td class=auto-style3></td>
          <td class=auto-style3></td>
          <td class=auto-style3></td>
          <td class=auto-style3></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7025500>PAID BY</td>
          <td class=xl7325500></td>
          <td class=xl7025500>AMOUNT<span style='mso-spacerun:yes'> </span></td>
          <td class=xl1525500></td>
          <td class=xl7025500>PCA PAYABLES</td>
          <td class=xl1525500></td>
          <td class=xl7725500><span style='mso-spacerun:yes'> </span>MONTHLY
          ALLOCATION<span style='mso-spacerun:yes'> </span></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500>PCA Insurance</td>
          <td class=xl1525500></td>
          <td class=xl8025500>
              <input id="PCAInsurance" type="text"  style='background-color:#E7E6E6;border:none' /></td>
          <td class=xl1525500></td>
          <td class=xl6825500>
              <input id="PCAPayables" type="text" style="border:none" /></td>
          <td class=xl1525500></td>
          <td class=xl8025500>
              <input id="MonthlyAllocation" type="text"  style='background-color:#E7E6E6;border:none' /></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500>3rd Party Insurance</td>
          <td class=xl1525500></td>
          <td class=xl8025500 style='border-top:none'>
              <input id="ThirdPartyInsurance" type="text"  style='background-color:#E7E6E6;border:none' /></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl7425500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500>PCA Deductible</td>
          <td class=xl1525500></td>
          <td class=xl8025500 style='border-top:none'>
              <input id="PCADeductible" type="text"  style='background-color:#E7E6E6;border:none' /></td>
          <td class=xl1525500></td>
          <td class=xl7025500>PCA ACTUAL EXPENSE</td>
          <td class=xl1525500></td>
          <td class=xl7725500><span style='mso-spacerun:yes'> </span>RESERVE<span
          style='mso-spacerun:yes'> </span></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500>PCA Out of Pocket</td>
          <td class=xl1525500></td>
          <td class=xl8025500 style='border-top:none'>
              <input id="PCAOutOfPocket" type="text"  style='background-color:#E7E6E6;border:none' /></td>
          <td class=xl1525500></td>
          <td class=xl6825500>
              <input id="PCAActualExpense" type="text" style="border:none" /></td>
          <td class=xl1525500></td>
          <td class=xl8025500>
              <input id="Reserve" type="text"  style='background-color:#E7E6E6;border:none' /></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl1525500>Employee Paid</td>
          <td class=xl1525500></td>
          <td class=xl8025500 style='border-top:none'>
              <input id="EmployeePaid" type="text"  style='background-color:#E7E6E6;border:none' /></td>
          <td class=xl1525500></td>
          <td class=xl7425500></td>
          <td class=xl1525500></td>
          <td class=xl7425500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=0 style='display:none'>
          <td class=xl1525500></td>
          <td class=xl1525500>PCA Direct</td>
          <td class=xl1525500></td>
          <td class=xl8025500 style='border-top:none'>
              <input id="PCADirect" type="text"  style='background-color:#E7E6E6;border:none' /></td>
          <td class=xl1525500></td>
          <td class=xl7425500></td>
          <td class=xl1525500></td>
          <td class=xl7425500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl7125500>TOTAL CLAIM</td>
          <td class=xl1525500></td>
          <td class=xl6925500>
              <input id="TotalClaim" type="text" style="border:none" /></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl7425500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7025500>PCA INSURANCE CLAIM #</td>
          <td class=xl7325500></td>
          <td class=xl7025500>OTHER INSURANCE CLAIM #</td>
          <td class=xl7325500></td>
          <td class=xl7025500>POLICE REPORT #<span style='mso-spacerun:yes'> </span></td>
          <td class=xl7325500></td>
          <td class=xl7025500>DATE PCA RECEIVED CLAIM</td>
          <td class=xl7325500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7925500>
              <input id="PCAInsuranceClaimNumber" type="text"  style='background-color:#E7E6E6;border:none' /></td>
          <td class=xl1525500></td>
          <td class=xl7925500>
              <input id="OtherInsuranceClaimNumber" type="text"  style='background-color:#E7E6E6;border:none' /></td>
          <td class=xl1525500></td>
          <td class=xl7925500>
              <input id="PoliceReportNumber" type="text"  style='background-color:#E7E6E6;border:none' /></td>
          <td class=xl1525500></td>
          <td class=xl6725500>
              <input id="DatePCAReceivedClaim" type="text" style="border:none" /></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr>
          <td class=auto-style1></td>
          <td class=auto-style2>PCA REP ASSIGNED</td>
          <td class=auto-style1></td>
          <td class=auto-style1></td>
          <td class=auto-style1></td>
          <td class=auto-style1></td>
          <td class=auto-style1></td>
          <td class=auto-style1></td>
          <td class=auto-style1></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7625500>
              <select id="PCARepAssigned" style='background-color:#E7E6E6;border:none'></select>
          </td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl8425500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
        </table>
        <table id='payableTable' border=0 cellpadding=0 cellspacing=0 width=795 style='border-collapse:collapse;table-layout:fixed;width:598pt'>
         <col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl7025500>&nbsp;</td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7525500>
              <input id="addNote" type="button" value="ADD NOTE" style="background-color:black;color:white" /></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500>&nbsp;</td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=0 style='display:none'>
          <td class=xl1525500></td>
          <td class=xl7525500>ADD MULTIPLE CLAIMS</td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=0 style='display:none'>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7525500>CLAIM DOCUMENTS</td>
          <td class=xl1525500></td>
          <td class=xl8225500><a href="#RANGE!A1"><span style='color:white;font-weight:
          700;text-decoration:none'>ADD CLAIM TO INCIDENT</span></a></td>
          <td class=xl8625500></td>
          <td class=xl7525500>SAVE</td>
          <td class=xl8625500><span style='mso-spacerun:yes'> </span></td>
          <td class=xl8625500>
              &nbsp;</td>
          <td class=xl8625500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl7825500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=22 style='height:16.5pt'>
          <td height=22 class=xl1525500 style='height:16.5pt'></td>
          <td colspan=7 class=xl8825500 style='border-right:1.0pt solid black'>PCA
          PAYABLES</td>
          <td class=xl8725500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7025500></td>
          <td class=xl7025500></td>
          <td class=xl7025500></td>
          <td class=xl7025500></td>
          <td class=xl7025500></td>
          <td class=xl7025500></td>
          <td class=xl7025500></td>
          <td class=xl7025500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7025500>VENDOR / PAYEE</td>
          <td class=xl7325500></td>
          <td class=xl7025500>PCA CHECK NUMBER</td>
          <td class=xl7325500></td>
          <td class=xl7025500>CHECK AMOUNT</td>
          <td class=xl1525500></td>
          <td class=xl7025500>MAILED DATE</td>
          <td class=xl1525500></td>
         </tr>
        </table>
        <table id="receivableTable" border=0 cellpadding=0 cellspacing=0 width=795 style='border-collapse:collapse;table-layout:fixed;width:598pt'>
         <col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl7525500><input id="addPayable" type="button" value="ADD PAYABLE" style="background-color:black;color:white" /></td>
          <td class=xl1525500></td>
          <td class=xl7025500>TOTAL PAYABLES</td>
          <td class=xl1525500></td>
          <td class=xl6925500>
              <input id="TotalPayables" type="text" style="border:none" /></td>
          <td class=xl1525500></td>
          <td class=xl1525500><span style='mso-spacerun:yes'> </span></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=22 style='height:16.5pt'>
          <td height=22 class=xl1525500 style='height:16.5pt'></td>
          <td colspan=7 class=xl8825500 style='border-right:1.0pt solid black'>RECEIVABLES</td>
          <td class=xl8725500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7025500>PAYOR</td>
          <td class=xl7325500></td>
          <td class=xl7025500>CHECK NUMBER</td>
          <td class=xl7325500></td>
          <td class=xl7025500>CHECK AMOUNT</td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
        </table>
        <table id="bottomTable" border=0 cellpadding=0 cellspacing=0 width=795 style='border-collapse:collapse;table-layout:fixed;width:598pt'>
         <col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl7525500><input id="addReceivable" type="button" value="ADD PAYABLE" style="background-color:black;color:white" /></td>
          <td class=xl1525500></td>
          <td class=xl7025500>TOTAL RECEIVABLES</td>
          <td class=xl1525500></td>
          <td class=xl6925500>
              <input id="TotalReceivables" type="text" style="border:none" /></td>
          <td class=xl1525500></td>
          <td colspan=2 class=xl8625500></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl7025500>TOTAL EXPENSE TO PCA</td>
          <td class=xl1525500></td>
          <td class=xl6925500>
              <input id="TotalExpenseToPCA" type="text" style="border:none" /></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7525500>CLOSE CLAIM</td>
          <td class=xl1525500></td>
          <td class=xl7525500>SAVE / SUBMIT</td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <![if supportMisalignedColumns]>
         <tr height=0 style='display:none'>
          <td width=19 style='width:14pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
         </tr>
         <![endif]>
        </table>

        </div>




    <script>
        var claimNote = "<table id='ClaimNote1' border=0 cellpadding=0 cellspacing=0 width=795 style='border-collapse:collapse;table-layout:fixed;width:598pt'>" +
                "<col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
				"<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td colspan=5 class=xl9125500>NOTE 1</td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl7025500>DATE OF NOTE</td>" +
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
				  "<td class=xl7025500>NOTE ENTERED BY</td>" +
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

        var payable = "<table id='Payable1' border=0 cellpadding=0 cellspacing=0 width=795 style='border-collapse:collapse;table-layout:fixed;width:598pt'>" +
                "<col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
				"<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td class=xl7925500><input id='PayorPayeePayable1' type='text' style='background-color:#E7E6E6;border:none' /></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl7925500><input id='CheckNumberPayable1' type='text' style='background-color:#E7E6E6;border:none' /></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl8025500><input id='CheckAmountPayable1' type='text' style='background-color:#E7E6E6;border:none' /></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl8125500><input id='MailDatePayable1' type='text' style='background-color:#E7E6E6;border:none' /></td>" +
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

        var receivable = "<table id='Receivable1' border=0 cellpadding=0 cellspacing=0 width=795 style='border-collapse:collapse;table-layout:fixed;width:598pt'>" +
                "<col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
				"<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td class=xl7925500><input id='PayorReceivable1' type='text' style='background-color:#E7E6E6;border:none' /></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl7925500><input id='CheckNumberReceivable1' type='text' style='background-color:#E7E6E6;border:none' /></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl8025500><input id='CheckAmountReceivable1' type='text' style='background-color:#E7E6E6;border:none' /></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
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


