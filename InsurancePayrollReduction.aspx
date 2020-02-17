<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsurancePayrollReduction.aspx.cs" Inherits="InsurancePayrollReduction" %>

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
            $("#incidentDate").jqxDateTimeInput({ width: '175px', height: '25px', formatString: 'd' });
            $("#incidentDate").jqxDateTimeInput({ width: '175px', height: '25px', formatString: 'd' });

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
        .font031799
	        {color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;}
        .font531799
	        {color:red;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;}
        .xl1531799
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
        .xl6731799
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
        .xl6831799
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
        .xl6931799
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
        .xl7031799
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
        .xl7131799
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
        .xl7231799
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
	        text-align:right;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7331799
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
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl7431799
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
        .xl7531799
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
	        border-top:none;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7631799
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:8.0pt;
	        font-weight:400;
	        font-style:italic;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:right;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7731799
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
        .xl7831799
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
        .xl7931799
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
        .xl8031799
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:8.0pt;
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

    </style>

        <div align=center>

        <table border=0 cellpadding=0 cellspacing=0 width=693 style='border-collapse:
         collapse;table-layout:fixed;width:522pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=34 style='mso-width-source:userset;mso-width-alt:1243;width:26pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=51 style='mso-width-source:userset;mso-width-alt:1865;width:38pt'>
         <col width=26 style='mso-width-source:userset;mso-width-alt:950;width:20pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1531799 width=17 style='height:15.75pt;width:13pt'><a
          name="RANGE!A1:I40"></a><a name="RANGE!A1"></a></td>
          <td class=xl1531799 width=177 style='width:133pt'></td>
          <td class=xl1531799 width=17 style='width:13pt'></td>
          <td class=xl1531799 width=177 style='width:133pt'></td>
          <td class=xl1531799 width=34 style='width:26pt'></td>
          <td class=xl1531799 width=177 style='width:133pt'></td>
          <td class=xl1531799 width=51 style='width:38pt'></td>
          <td class=xl1531799 width=26 style='width:20pt'></td>
          <td class=xl1531799 width=17 style='width:13pt'></td>
         </tr>
         <tr height=22 style='height:16.5pt'>
          <td height=22 class=xl1531799 style='height:16.5pt'></td>
          <td colspan=7 class=xl7731799 style='border-right:1.0pt solid black'>PAYROLL
          DEDUCTION FORM</td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr>
             <td class=auto-style1 colspan="9" style="text-align:center">
              <img alt="" src="./images/InsuranceIncidentReportHeader.png" /></td>
         </tr>
         <tr height=18 style='mso-height-source:userset;height:13.5pt'>
          <td height=18 class=xl1531799 style='height:13.5pt'></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl7431799>LOCATION</td>
          <td class=xl1531799></td>
          <td class=xl6731799>
              <select id="location" style="border:none"></select></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl1531799>Employee Name</td>
          <td class=xl1531799></td>
          <td class=xl6731799 style='border-top:none'>
              <input id="IncidentNumber0" type="text" style="border:none" /></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl1531799>Date of Incident</td>
          <td class=xl1531799></td>
          <td class=xl6731799 style='border-top:none'>
              <div id="incidentDate" style="border:none"></div></td>
          <td class=xl1531799></td>
          <td class=xl7031799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl1531799 colspan=2>Customer Name or Vehicle #</td>
          <td class=xl6731799 style='border-top:none'>
              <input id="CustomerNameOrVehicleNumber" type="text" style="border:none" /></td>
          <td class=xl1531799></td>
          <td class=xl7031799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl1531799>Total Due from Employee</td>
          <td class=xl1531799></td>
          <td class=xl6731799 style='border-top:none'>
              <input id="TotalDueFromEmployee" type="text" style="border:none" /></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl7031799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl1531799 colspan=4>TO: PARKING COMPANY OF AMERICA INSURANCE
          DEPARTMENT</td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl7031799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=62 style='mso-height-source:userset;height:46.5pt'>
          <td height=62 class=xl1531799 style='height:46.5pt'></td>
          <td colspan=7 class=xl7331799 width=659 style='width:496pt'>I hereby accept
          responsibility of all cost up to a maximum of <font class="font531799">$500</font><font
          class="font031799"> incurred by Parking Company of America (&quot;PCA&quot;)
          due to the attached incident.<span style='mso-spacerun:yes'>  </span>I hereby
          agree that I owe the amount of $&nbsp;<input id="AmountOwed" type="text" style="border-bottom:solid;border-width:1px;border-top:none;border-left:none;border-right:none;width:45px" /> for LOSS $&nbsp;<input id="Loss" type="checkbox" style="width:25px" /> DAMAGE $&nbsp;<input id="Damage" type="checkbox" style="width:25px" /> THEFT
          <input id="theft" type="checkbox" style="width:25px" /> (Check one).<span style='mso-spacerun:yes'> </span></font></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl7031799></td>
          <td class=xl1531799></td>
          <td class=xl6931799></td>
          <td class=xl7231799></td>
          <td class=xl6931799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=84 style='mso-height-source:userset;height:63.0pt'>
          <td height=84 class=xl1531799 style='height:63.0pt'></td>
          <td colspan=7 class=xl7331799 width=659 style='width:496pt'>I
          <input id="formEmployeeName" type="text" style="border-bottom:solid;border-width:1px;border-top:none;border-left:none;border-right:none;width:275px" /> hereby authorize PCA's Payroll
          Department to withhold the total amount of $<input id="AmountWithHeld" type="text" style="border-bottom:solid;border-width:1px;border-top:none;border-left:none;border-right:none;width:45px" /> from my paychecks.<span
          style='mso-spacerun:yes'>  </span>I agree that this amount will be deducted
          in installments of $<input id="InstallMentAmount" type="text" style="border-bottom:solid;border-width:1px;border-top:none;border-left:none;border-right:none;width:45px" /> per paycheck, beginning with pay period ending
          <input id="AmountOwed" type="text" style="border-bottom:solid;border-width:1px;border-top:none;border-left:none;border-right:none;width:145px" /> and continue until paid in full.<span
          style='mso-spacerun:yes'>  </span></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=9 style='mso-height-source:userset;height:6.75pt'>
          <td height=9 class=xl1531799 style='height:6.75pt'></td>
          <td class=xl7031799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=44 style='mso-height-source:userset;height:33.0pt'>
          <td height=44 class=xl1531799 style='height:33.0pt'></td>
          <td colspan=7 class=xl7331799 width=659 style='width:496pt'>I agree that in I
          leave employement with PCA or my employment is terminated for any reason, any
          balance remaining due and payable will be deducted from my final
          paycheck.<span style='mso-spacerun:yes'> </span></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=13 style='mso-height-source:userset;height:9.75pt'>
          <td height=13 class=xl1531799 style='height:9.75pt'></td>
          <td class=xl7331799 width=177 style='width:133pt'></td>
          <td class=xl7331799 width=17 style='width:13pt'></td>
          <td class=xl7331799 width=177 style='width:133pt'></td>
          <td class=xl7331799 width=34 style='width:26pt'></td>
          <td class=xl7331799 width=177 style='width:133pt'></td>
          <td class=xl7331799 width=51 style='width:38pt'></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=42 style='mso-height-source:userset;height:31.5pt'>
          <td height=42 class=xl1531799 style='height:31.5pt'></td>
          <td colspan=7 class=xl7331799 width=659 style='width:496pt'>I agree that if
          my paycheck is not enough to pay for the balance remaining due and payalbe, I
          will pay PCA the difference within thirty (30) days of the date of the final
          paycheck.<span style='mso-spacerun:yes'> </span></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=11 style='mso-height-source:userset;height:8.25pt'>
          <td height=11 class=xl1531799 style='height:8.25pt'></td>
          <td class=xl7331799 width=177 style='width:133pt'></td>
          <td class=xl7331799 width=17 style='width:13pt'></td>
          <td class=xl7331799 width=177 style='width:133pt'></td>
          <td class=xl7331799 width=34 style='width:26pt'></td>
          <td class=xl7331799 width=177 style='width:133pt'></td>
          <td class=xl7331799 width=51 style='width:38pt'></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=65 style='mso-height-source:userset;height:48.75pt'>
          <td height=65 class=xl1531799 style='height:48.75pt'></td>
          <td colspan=7 class=xl7331799 width=659 style='width:496pt'>I hereby waive
          any rights I have to the above-reference amount under the Fair Labor
          Standards Act, any state Wage Payment Statute, or any other statutory or
          sivil tort claim and release Parking Company of America from any liability
          thereunder.<span style='mso-spacerun:yes'> </span></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl7531799 colspan="3">
              <input id="EmployeeNamePrint" type="text" style="border:none" /></td>
          <td class=xl1531799></td>
          <td class=xl7531799>
              <div id="EmployeeNameDate" style="border:none"></div></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl1531799>(Employee Print full name)</td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799>Date</td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl7531799 colspan="3">
              <input id="EmployeeSignature" type="text" style="border:none" /></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl1531799>(Employee Signature)</td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl7531799 colspan="3">
              <input id="ManagersNamePrint" type="text" style="border:none" /></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl1531799>(Manager Print full name)</td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl7531799 colspan="3">
              <input id="ManagersSignature" type="text" style="border:none" /></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl1531799>(Manager Signature)</td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=12 style='mso-height-source:userset;height:9.0pt'>
          <td height=12 class=xl1531799 style='height:9.0pt'></td>
          <td class=xl1531799 colspan="3"></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td colspan=7 class=xl8031799>Attach copy of Incident Report<span
          style='mso-spacerun:yes'>  </span>any disciplinary action to original signed
          form: Send to Corporate Insurace.<span style='mso-spacerun:yes'>  </span>Give
          copy of signed form to Employee</td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl7131799>SUBMIT</td>
          <td class=xl1531799></td>
          <td class=xl6831799>PRINT</td>
          <td class=xl1531799></td>
          <td class=xl7631799 colspan="4">Revised October 11, 2019</td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1531799 style='height:15.0pt'></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
          <td class=xl1531799></td>
         </tr>
         <![if supportMisalignedColumns]>
         <tr height=0 style='display:none'>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=34 style='width:26pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=51 style='width:38pt'></td>
          <td width=26 style='width:20pt'></td>
          <td width=17 style='width:13pt'></td>
         </tr>
         <![endif]>
        </table>

        </div>
</asp:Content>


