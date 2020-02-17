<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceWCChecklist.aspx.cs" Inherits="InsuranceWCChecklist" %>

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
        $(document).ready(function () {
            $("#incidentTime").jqxDateTimeInput({ width: '150px', height: '25px', formatString: 'h:mm tt', showTimeButton: true, showCalendarButton: false });
            $("#incidentDate").jqxDateTimeInput({ width: '150px', height: '25px', formatString: 'd' });

            loadLocations();
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
    </script>
    <style>
        .xl1515917
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
        .xl6715917
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
        .xl6815917
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
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl6915917
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
        .xl7015917
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
        .xl7115917
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
        .xl7215917
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
        .xl7315917
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:windowtext;
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
        .xl7415917
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
        .xl7515917
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:windowtext;
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
        .xl7615917
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:#0070C0;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:underline;
	        text-underline-style:single;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7715917
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:#0563C1;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:underline;
	        text-underline-style:single;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7815917
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
        .xl7915917
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
        .xl8015917
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
        .xl8115917
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
	        vertical-align:top;
	        border:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .auto-style1 {
            height: 56px;
        }
        </style>
        

        <div align=center>

        <table border=0 cellpadding=0 cellspacing=0 width=789 style='border-collapse:
         collapse;table-layout:fixed;width:594pt'>
         <col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>
         <col width=191 style='mso-width-source:userset;mso-width-alt:6985;width:143pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=157 style='mso-width-source:userset;mso-width-alt:5741;width:118pt'>
         <col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1515917 width=18 style='height:15.75pt;width:14pt'><a
          name="RANGE!A1:I40"></a><a name="RANGE!A1"></a></td>
          <td class=xl1515917 width=191 style='width:143pt'></td>
          <td class=xl1515917 width=17 style='width:13pt'></td>
          <td class=xl1515917 width=177 style='width:133pt'></td>
          <td class=xl1515917 width=17 style='width:13pt'></td>
          <td class=xl1515917 width=177 style='width:133pt'></td>
          <td class=xl1515917 width=17 style='width:13pt'></td>
          <td class=xl1515917 width=157 style='width:118pt'></td>
          <td class=xl1515917 width=18 style='width:14pt'></td>
         </tr>
         <tr height=22 style='height:16.5pt'>
          <td height=22 class=xl1515917 style='height:16.5pt'></td>
          <td colspan=7 class=xl7815917 style='border-right:1.0pt solid black'>WORKERS
          COMPENSATION CHECKLIST</td>
          <td class=xl6815917></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1515917 style='height:15.75pt'></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1515917 style='height:15.75pt'></td>
          <td class=xl6815917>PCA WC #</td>
          <td class=xl1515917></td>
          <td class=xl7415917>
              <input id="WCNumber" type="text" style="border:none" /></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1515917 style='height:15.75pt'></td>
          <td class=xl6815917>COMPANION PCA INCIDENT #</td>
          <td class=xl1515917></td>
          <td class=xl7415917 style='border-top:none'>
              <input id="IncidentNumber" type="text" style="border:none" /></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917><span style='mso-spacerun:yes'> </span></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl6815917>LOCATION OF INCIDENT</td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl6815917>INCIDENT DETAILS</td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl7515917>LOCATION</td>
          <td class=xl1515917></td>
          <td class=xl6715917><select id="location" style="border:none"></select></td>
          <td class=xl1515917></td>
          <td class=xl6815917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>Street Address</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <input id="StreetAddress" type="text" style="border:none" /></td>
          <td class=xl1515917></td>
          <td class=xl1515917>Date of Incident<span style='mso-spacerun:yes'> </span></td>
          <td class=xl1515917></td>
          <td class=xl6715917><div id="incidentDate" style="border:none"></div></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>City<span style='mso-spacerun:yes'> </span></td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <input id="City" type="text" style="border:none" /></td>
          <td class=xl1515917></td>
          <td class=xl1515917>Time of Incident</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'><div id="incidentTime" style="border:none"></div></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>State</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <input id="State" type="text" style="border:none" /></td>
          <td class=xl1515917></td>
          <td class=xl7115917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>Zip Code</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <input id="Zip" type="text" style="border:none" /></td>
          <td class=xl1515917></td>
          <td class=xl7115917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>Phone</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <input id="Phone" type="text" style="border:none" /></td>
          <td class=xl1515917></td>
          <td class=xl7115917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917><span style='mso-spacerun:yes'> </span></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl7715917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl6815917>CLAIM INFORMATION:</td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl6815917>ALL CLAIMS</td>
          <td class=xl1515917></td>
          <td class=xl6915917>LOCATION MANAGER</td>
          <td class=xl6915917></td>
          <td class=xl6915917>CLAIMS REP</td>
          <td class=xl1515917></td>
          <td class=xl6915917>FORMS</td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>Investigation of Accident</td>
          <td class=xl1515917></td>
          <td class=xl6715917>
              <select id="ManagerAccidentInvestigation" style='border:none;'>
                <option value=""></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl6715917>
              <select id="RepAccidentInvestigation" style='border:none;'>
                <option value=""></option>
                <option value="1">Received</option>
                <option value="0">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl7615917><a href=".\InsuranceWCInvestigation.aspx"><span style='color:#0070C0'>Investigation
          form</span></a></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>Ohio CF1 BWC FROI</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="ManagerOhioCf1BwcFroi" style='border:none;'>
                <option value=""></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">N/A</option>
            </select></td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="RepOhioCf1BwcFroi" style='border:none;'>
                <option value=""></option>
                <option value="1">Received</option>
                <option value="0">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl7615917><a href=".\InsuranceForms\Form & Incident Reports\incident forms\2019 Incident Forms\forms used for new form\Work Comp\ALL Checklist Forms\OHIO_CF1 BWC FROI 2014_FINAL.pdf" target="_blank"><span
          style='color:#0070C0'>Ohio BWC FROI</span></a></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>Modified Duty Schedule</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="ManagerModifiedDuty" style='border:none;'>
                <option value=""></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="RepModifiedDuty" style='border:none;'>
                <option value=""></option>
                <option value="1">Received</option>
                <option value="0">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl7615917><a href=".\InsuranceForms\Form & Incident Reports\incident forms\2019 Incident Forms\forms used for new form\Work Comp\ALL Checklist Forms\GA modified duty wc240 revised 2014_FINAL.pdf" target="_blank"><span
          style='color:#0070C0'>Modified Duty Schedule</span></a></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>Payroll Deduction Form</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="ManagerPayrollDeductionForm" style='border:none;'>
                <option value=""></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="RepPayrollDeductionForm" style='border:none;'>
                <option value=""></option>
                <option value="1">Received</option>
                <option value="0">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl7615917><a href="InsuranceForms\Form & Incident Reports\incident forms\2019 Incident Forms\forms used for new form\Liability\6_Payroll Deduction Form FINAL (Rev10.25.19).pdf" target="_blank"><span
          style='color:#0070C0'>Payroll Deduction Form</span></a></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>Concentra Employee Auth</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="ManagerConcentra" style='border:none;'>
                <option value=""></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="RepConcentra" style='border:none;'>
                <option value=""></option>
                <option value="1">Received</option>
                <option value="0">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl7615917 colspan=2><a
          href=".\InsuranceForms\Form & Incident Reports\incident forms\2019 Incident Forms\forms used for new form\Work Comp\ALL Checklist Forms\08 concentraemployerauthorizationform-0309_FINAL.pdf" target="_blank"><span
          style='color:#0070C0'>Concentra Employee Auth</span></a></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>Ohio RD1 TWB-2 Offer</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="ManagerRd1Twb2Offer" style='border:none;'>
                <option value=""></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="RepRd1Twb2Offer" style='border:none;'>
                <option value=""></option>
                <option value="1">Received</option>
                <option value="0">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl7615917><a
          href=".\InsuranceForms\Form & Incident Reports\incident forms\2019 Incident Forms\forms used for new form\Work Comp\ALL Checklist Forms\Ohio RD1 TWB-2 offer form_FINAL.pdf" target="_blank"><span
          style='color:#0070C0'>Ohio RD1 TWB-2 Offer</span></a></td>
          <td class=xl1515917><span style='mso-spacerun:yes'> </span></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>Georgia Travelers Panel</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="ManagerGATravelersPanel" style='border:none;'>
                <option value=""></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="RepGATravelersPanel" style='border:none;'>
                <option value=""></option>
                <option value="1">Received</option>
                <option value="0">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl7615917><a
          href=".\InsuranceForms\Form & Incident Reports\incident forms\2019 Incident Forms\forms used for new form\Work Comp\ALL Checklist Forms\GA Dwtnw Travelers Panel-1920_FINAL.pdf" target="_blank"><span
          style='color:#0070C0'>GA Travelers Panel</span></a></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>GA Job Analysis WC240A</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="ManagerGAJobAnalysis" style='border:none;'>
                <option value=""></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="RepGAJobAnalysis" style='border:none;'>
                <option value=""></option>
                <option value="1">Received</option>
                <option value="0">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl7615917><a
          href=".\InsuranceForms\Form & Incident Reports\incident forms\2019 Incident Forms\forms used for new form\Work Comp\ALL Checklist Forms\GA WC 240a JOB ANALYSIS FINAL.pdf" target="_blank"><span
          style='color:#0070C0'>GA Job Analysis</span></a></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>GA Modified Duty WC240A</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="ManagerGAModifiedDuty" style='border:none;'>
                <option value=""></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">N/A</option>
            </select></td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="RepGAModifiedDuty" style='border:none;'>
                <option value=""></option>
                <option value="1">Received</option>
                <option value="0">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl7615917><a
          href=".\InsuranceForms\Form & Incident Reports\incident forms\2019 Incident Forms\forms used for new form\Work Comp\ALL Checklist Forms\GA modified duty wc240 revised 2014_FINAL.pdf" target="_blank"><span
          style='color:#0070C0'>GA Modified Duty</span></a></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>ATLFP Travelers Panel</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="ManagerATLFPTravelersPanel" style='border:none;'>
                <option value=""></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="RepATLFPTravelersPanel" style='border:none;'>
                <option value=""></option>
                <option value="1">Received</option>
                <option value="0">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl7615917><a
          href=".\InsuranceForms\Form & Incident Reports\incident forms\2019 Incident Forms\forms used for new form\Work Comp\ALL Checklist Forms\ATLFP Travelers Panels 19-20_FINAL.pdf" target="_blank"><span
          style='color:#0070C0'>ATLFP Travelers Panel</span></a></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>Texas E02a EmpAck Spanish</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="ManagerTXE02aEmpAckSpanish" style='border:none;'>
                <option value=""></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="RepTXE02aEmpAckSpanish" style='border:none;'>
                <option value=""></option>
                <option value="1">Received</option>
                <option value="0">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl7615917><a
          href=".\InsuranceForms\Form & Incident Reports\incident forms\2019 Incident Forms\forms used for new form\Work Comp\ALL Checklist Forms\Texas E02a EmployeeAcknowledgmentLetterSpanish_FINAL.pdf" target="_blank"><span
          style='color:#0070C0'>Texas E02a Spanish</span></a></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>Texas E01a EmpAck English</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="ManagerTXE01aEmpAckEnglish" style='border:none;'>
                <option value=""></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">N/A</option>
            </select></td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="RepTXE01aEmpAckEnglish" style='border:none;'>
                <option value=""></option>
                <option value="1">Received</option>
                <option value="0">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl7615917><a
          href=".\InsuranceForms\Form & Incident Reports\incident forms\2019 Incident Forms\forms used for new form\Work Comp\ALL Checklist Forms\Texas E01a EmployeeAcknowledgmentLetterEnglish_FINAL.pdf" target="_blank"><span
          style='color:#0070C0'>Texas E01a English</span></a></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>Texas E02 Emp Notice Spanish</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="ManagerTXE02EmpNoticeSpanish" style='border:none;'>
                <option value=""></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="RepTXE02EmpNoticeSpanish" style='border:none;'>
                <option value=""></option>
                <option value="1">Received</option>
                <option value="0">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl7615917><a
          href=".\InsuranceForms\Form & Incident Reports\incident forms\2019 Incident Forms\forms used for new form\Work Comp\ALL Checklist Forms\Texas E02 EmployeeNotice.Espanol_FINAL.pdf" target="_blank"><span
          style='color:#0070C0'>Texas E02 Spanish</span></a></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>Texas E01 Emp Notice English</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="ManagerTXE01EmpNoticeEnglish" style='border:none;'>
                <option value=""></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="RepTXE01EmpNoticeEnglish" style='border:none;'>
                <option value=""></option>
                <option value="1">Received</option>
                <option value="0">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl7615917><a
          href=".\InsuranceForms\Form & Incident Reports\incident forms\2019 Incident Forms\forms used for new form\Work Comp\ALL Checklist Forms\Texas E01 EmployeeNotice.English_FINAL.pdf" target="_blank"><span
          style='color:#0070C0'>Texas E01 English</span></a></td>
          <td class=xl1515917><span style='mso-spacerun:yes'> </span></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl7315917>OSHA Log</td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="ManagerOshaLog" style='border:none;'>
                <option value=""></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl6715917 style='border-top:none'>
              <select id="RepOshaLog" style='border:none;'>
                <option value=""></option>
                <option value="1">Received</option>
                <option value="0">N/A</option>
            </select>
          </td>
          <td class=xl1515917></td>
          <td class=xl7615917><a
          href=""><span
          style='color:#0070C0'>OSHA Log</span></a></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl7115917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917>COMMENTS/PENDING:</td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=68 style='mso-height-source:userset;height:51.0pt'>
          <td height=68 class=xl1515917 style='height:51.0pt'></td>
          <td colspan=7 class=xl8115917 width=753 style='width:566pt'>
              <textarea id="Comments" class="auto-style1" cols="20" name="S1"></textarea></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=0 style='display:none'>
          <td class=xl1515917></td>
          <td class=xl7015917>PRINT</td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=0 style='display:none'>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=0 style='display:none'>
          <td class=xl1515917></td>
          <td class=xl7215917>SAVE</td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl7015917>SAVE &amp; SUBMIT</td>
          <td class=xl1515917></td>
          <td class=xl7215917>PRINT</td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515917 style='height:15.0pt'></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
          <td class=xl1515917></td>
         </tr>
         <![if supportMisalignedColumns]>
         <tr height=0 style='display:none'>
          <td width=18 style='width:14pt'></td>
          <td width=191 style='width:143pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=157 style='width:118pt'></td>
          <td width=18 style='width:14pt'></td>
         </tr>
         <![endif]>
        </table>

        </div>

</asp:Content>


