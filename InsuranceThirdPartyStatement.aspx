<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceThirdPartyStatement.aspx.cs" Inherits="InsuranceThirdPartyStatement" %>

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

                $("#saveContinue").on("click", function () {
                    window.location.href = './InsuranceWitnessStatement.aspx'
                });

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
        .xl1517237
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
        .xl6717237
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
        .xl6817237
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
        .xl6917237
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
        .xl7017237
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
        .xl7117237
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
        .xl7217237
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
	        text-align:center;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        background:#92D050;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl7317237
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
        .xl7417237
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
        .xl7517237
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
        .xl7617237
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
	        border:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7717237
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
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl7817237
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
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl7917237
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
	        border-top:.5pt solid windowtext;
	        border-right:.5pt solid windowtext;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl8017237
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
	        border-top:none;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
            .auto-style1 {
                height: 73px;
            }
            .auto-style2 {
                height: 79px;
            }
        </style>
        

        <div align=center>

        <table border=0 cellpadding=0 cellspacing=0 width=800 style='border-collapse:
         collapse;table-layout:fixed;width:603pt'>
         <col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>
         <col width=182 style='mso-width-source:userset;mso-width-alt:6656;width:137pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1517237 width=18 style='height:15.75pt;width:14pt'><a
          name="RANGE!A1:I27"></a></td>
          <td class=xl1517237 width=182 style='width:137pt'></td>
          <td class=xl1517237 width=17 style='width:13pt'></td>
          <td class=xl1517237 width=177 style='width:133pt'></td>
          <td class=xl1517237 width=17 style='width:13pt'></td>
          <td class=xl1517237 width=177 style='width:133pt'></td>
          <td class=xl1517237 width=17 style='width:13pt'></td>
          <td class=xl1517237 width=177 style='width:133pt'></td>
          <td class=xl1517237 width=18 style='width:14pt'></td>
         </tr>
         <tr height=22 style='height:16.5pt'>
          <td height=22 class=xl1517237 style='height:16.5pt'></td>
          <td colspan=7 class=xl7317237 style='border-right:1.0pt solid black'>THIRD
          PARTY STATEMENT</td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
         </tr>
         <tr>
             <td class=auto-style1 colspan="9" style="text-align:center">
              <img alt="" src="./images/InsuranceIncidentReportHeader.png" /></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1517237 style='height:15.75pt'></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl6817237>PCA INCIDENT #</td>
          <td class=xl1517237></td>
          <td class=xl7117237>
              <input id="IncidentNumber" type="text" style="border:none" /></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl6817237>CUSTOMER NAME</td>
          <td class=xl1517237></td>
          <td colspan=3 class=xl7617237>
              <input id="CustomerName" type="text" style="border:none" /></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl6817237>ADDRESS</td>
          <td class=xl1517237></td>
          <td colspan=3 class=xl7617237>
              <input id="CustomerAddress" type="text" style="border:none" /></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl6817237>CITY</td>
          <td class=xl1517237></td>
          <td class=xl6717237 style='border-top:none'>
              <input id="CustomerCity" type="text" style="border:none" /></td>
          <td class=xl1517237></td>
          <td class=xl6817237>STATE</td>
          <td class=xl1517237></td>
          <td class=xl6717237>
              <input id="CustomerState" type="text" style="border:none" /></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl6817237>ZIP CODE</td>
          <td class=xl1517237></td>
          <td class=xl6717237 style='border-top:none'>
              <input id="CustomerZip" type="text" style="border:none" /></td>
          <td class=xl1517237></td>
          <td class=xl6817237>DATE OF INCIDENT</td>
          <td class=xl1517237></td>
          <td class=xl6717237 style='border-top:none'>
              <div id="incidentDate" style="border:none"></div></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl6817237>HOME PHONE</td>
          <td class=xl1517237></td>
          <td class=xl6717237 style='border-top:none'>
              <input id="CustomerHomePhone" type="text" style="border:none" /></td>
          <td class=xl1517237></td>
          <td class=xl6817237>LOCATION OF INCIDENT</td>
          <td class=xl1517237></td>
          <td class=xl6717237 style='border-top:none'>
              <select id="location" style="border:none"></select></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl6817237>MOBILE PHONE</td>
          <td class=xl1517237></td>
          <td class=xl6717237 style='border-top:none'>
              <input id="CustomerMobilePhone" type="text" style="border:none" /></td>
          <td class=xl1517237></td>
          <td class=xl6817237>DURATION OF STAY IN LOT</td>
          <td class=xl1517237></td>
          <td class=xl6717237 style='border-top:none'>
              <input id="StayDuration" type="text" style="border:none" /></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl6817237>EMAIL ADDRESS</td>
          <td class=xl1517237></td>
          <td class=xl6717237 style='border-top:none'>
              <input id="CustomerEmail" type="text" style="border:none" /></td>
          <td class=xl1517237></td>
          <td class=xl6817237>LOT-ROW-SPACE</td>
          <td class=xl1517237></td>
          <td class=xl6717237 style='border-top:none'>
              <input id="LotRowSpace" type="text" style="border:none" /></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl6817237>ANY INJURIES</td>
          <td class=xl1517237></td>
          <td class=xl6717237 style='border-top:none'><input name='Injuries' type='radio' value='1' style='width:25px' />Yes<input name='Injuries' type='radio' value='0' style='width:25px' />No</td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl6817237 colspan=3>DESCRIPTION OF INCIDENT, DAMAGE AND/OR INJURY:</td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=87 style='mso-height-source:userset;height:65.25pt'>
          <td height=87 class=xl1517237 style='height:65.25pt'></td>
          <td colspan=7 class=xl7717237 width=764 style='border-right:.5pt solid black;
          width:575pt'>
              <textarea id="IncidentDesc" class="auto-style2" cols="20" name="S1" style="border:none"></textarea></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td colspan=3 class=xl8017237>
              <input id="ThirdPartySignature" type="text" style="border:none" /></td>
          <td class=xl1517237></td>
          <td class=xl6917237>
              <input id="SignatureDate" type="text" style="border:none" /></td>
          <td class=xl1517237></td>
          <td class=xl1517237><span style='mso-spacerun:yes'> </span></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl6817237>Third Party Signature</td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl6817237>Date</td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl7017237><input id="saveContinue" type="button" value="Save & Continue" style="height:26px;background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl1517237></td>
          <td class=xl7017237>PRINT REPORT</td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl7217237>PAGE 4 OF 5</td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
         </tr>
         <![if supportMisalignedColumns]>
         <tr height=0 style='display:none'>
          <td width=18 style='width:14pt'></td>
          <td width=182 style='width:137pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=18 style='width:14pt'></td>
         </tr>
         <![endif]>
        </table>

        </div>

</asp:Content>

