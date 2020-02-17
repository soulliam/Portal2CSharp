<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceIncidentChecklist.aspx.cs" Inherits="InsuranceIncidentChecklist" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
        <script>
            $(document).ready(function () {

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
            .font03793
	            {color:black;
	            font-size:11.0pt;
	            font-weight:400;
	            font-style:normal;
	            text-decoration:none;
	            font-family:Calibri, sans-serif;
	            mso-font-charset:0;}
            .xl153793
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
            .xl673793
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
            .xl683793
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
            .xl693793
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
            .xl703793
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
            .xl713793
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
	            background:black;
	            mso-pattern:black none;
	            white-space:nowrap;}
            .xl723793
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
            .xl733793
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
            .xl743793
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
            .xl753793
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
            .xl763793
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
	            vertical-align:top;
	            border:.5pt solid windowtext;
	            mso-background-source:auto;
	            mso-pattern:auto;
	            white-space:normal;}
            .auto-style1 {
                height: 56px;
            }
            .auto-style2 {
                padding: 0px;
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
            .auto-style3 {
                padding: 0px;
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
                border: .5pt solid windowtext;
                mso-background-source: auto;
                mso-pattern: auto;
                white-space: nowrap;
                height: 15pt;
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
              <td height=21 class=xl153793 width=18 style='height:15.75pt;width:14pt'></td>
              <td class=xl153793 width=191 style='width:143pt'></td>
              <td class=xl153793 width=17 style='width:13pt'></td>
              <td class=xl153793 width=177 style='width:133pt'></td>
              <td class=xl153793 width=17 style='width:13pt'></td>
              <td class=xl153793 width=177 style='width:133pt'></td>
              <td class=xl153793 width=17 style='width:13pt'></td>
              <td class=xl153793 width=157 style='width:118pt'></td>
              <td class=xl153793 width=18 style='width:14pt'></td>
             </tr>
             <tr height=22 style='height:16.5pt'>
              <td height=22 class=xl153793 style='height:16.5pt'></td>
              <td colspan=7 class=xl733793 style='border-right:1.0pt solid black'>PCA
              INCIDENT/CLAIMS CHECKLIST</td>
              <td class=xl683793></td>
             </tr>
             <tr height=21 style='height:15.75pt'>
              <td height=21 class=xl153793 style='height:15.75pt'></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=21 style='height:15.75pt'>
              <td height=21 class=xl153793 style='height:15.75pt'></td>
              <td class=xl683793>PCA INCIDENT #</td>
              <td class=xl153793></td>
              <td class=xl723793><input type='text' id='IncidentNumber' style='border:none' /></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl683793>LOCATION OF INCIDENT</td>
              <td class=xl153793></td>
              <td class=xl673793><select id="location" style="border:none"></select></td>
              <td class=xl153793></td>
              <td class=xl683793>INCIDENT DETAILS</td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Street Address</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'><input type='text' id='IncidentAddress' style='border:none' /></td>
              <td class=xl153793></td>
              <td class=xl153793>Date of Incident<span style='mso-spacerun:yes'> </span></td>
              <td class=xl153793></td>
              <td class=xl673793><input type='text' id='IncidentDate' style='border:none' /></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>City<span style='mso-spacerun:yes'> </span></td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'><input type='text' id='IncidentCity' style='border:none' /></td>
              <td class=xl153793></td>
              <td class=xl153793>Time of Incident</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'><input type='text' id='IncidentTime' style='border:none' /></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>State</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'><input type='text' id='IncidentState' style='border:none' /></td>
              <td class=xl153793></td>
              <td class=xl153793>Duration of stay in Lot</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'><input type='text' id='IncidentStayDuration' style='border:none' /></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Zip Code</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'><input type='text' id='IncidentZip' style='border:none' /></td>
              <td class=xl153793></td>
              <td class=xl153793>Any Injuries</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id="injuries" style="border:none">
                      <option value="1">Yes</option>
                      <option value="0" selected>No</option>
                      <option value="2">Unknown</option>
                    </select>
              </td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Phone</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'><input type='text' id='IncidentPhone' style='border:none' /></td>
              <td class=xl153793></td>
              <td class=xl153793>Police Report #</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'><input type='text' id='IncidentPoliceReportNumber' style='border:none' /></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Lot--Row--Space</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'><input type='text' id='IncidentLRS' style='border:none' /></td>
              <td class=xl153793></td>
              <td class=xl153793>Date of Report</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'><input type='text' id='IncidentPoliceReportDate' style='border:none' /></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Operation Type</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'><input name="operationType" type="radio" value="1" style="width:25px" />Self Park<input name="operationType" type="radio" value="0" style="width:25px" />Valet</td>
              <td class=xl153793></td>
              <td class=xl153793>Officer's Name</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'><input type='text' id='IncidentPoliceName' style='border:none' /></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793><span style='mso-spacerun:yes'> </span></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl683793>CLAIM INFORMATION:</td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl683793>ALL CLAIMS</td>
              <td class=xl153793></td>
              <td class=xl693793>LOCATION MANAGER</td>
              <td class=xl693793></td>
              <td class=xl693793>CLAIMS REP</td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Employee Statement</td>
              <td class=xl153793></td>
              <td class=xl673793>
                <select id='ManagerEmployeeStatement' style="border:none">
                    <option value="1">Yes</option>
                    <option value="0" selected>No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793>
                  <select id='RepEmployeeStatement' style="border:none">
                    <option></option>
                    <option value="1">Received</option>
                    <option value="0" >N/A</option>
                </select>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Customer Statement</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='ManagerCustomerStatement' style="border:none">
                    <option value="1">Yes</option>
                    <option value="0" selected>No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='RepCustomerStatement' style="border:none">
                    <option></option>
                    <option value="1">Received</option>
                    <option value="0" >N/A</option>
                </select>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Witness Statements</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='ManagerWitnessStatement' style="border:none">
                    <option value="1">Yes</option>
                    <option value="0" selected>No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='RepWitnessStatement' style="border:none">
                    <option></option>
                    <option value="1">Received</option>
                    <option value="0" >N/A</option>
                </select>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Manager Statement</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='ManagerStatement' style="border:none">
                    <option value="1">Yes</option>
                    <option value="0" selected>No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='RepManagerStatement' style="border:none">
                    <option></option>
                    <option value="1">Received</option>
                    <option value="0" >N/A</option>
                </select>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Pictures</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='ManagerPictures' style="border:none">
                    <option value="1">Yes</option>
                    <option value="0" selected>No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='RepPictures' style="border:none">
                    <option></option>
                    <option value="1">Received</option>
                    <option value="0" >N/A</option>
                </select>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Original Documents Received</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='ManagerDocumentsReceived' style="border:none">
                    <option value="1">Yes</option>
                    <option value="0" selected>No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='RepDocumentsReceived' style="border:none">
                    <option></option>
                    <option value="1">Received</option>
                    <option value="0" >N/A</option>
                </select>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793><span style='mso-spacerun:yes'> </span></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl683793 colspan=3>*All statements signed and dated</td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=22 style='mso-height-source:userset;height:16.5pt'>
              <td height=22 class=xl153793 style='height:16.5pt'></td>
              <td class=xl683793 colspan=5>CLAIMS WITH DAMAGE OR INVOLVE ANOTHER PARTY (in
              addition to All Claims):</td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=22 style='mso-height-source:userset;height:16.5pt'>
              <td height=22 class=xl153793 style='height:16.5pt'></td>
              <td class=xl683793></td>
              <td class=xl153793></td>
              <td class=xl693793>LOCATION MANAGER</td>
              <td class=xl693793></td>
              <td class=xl693793>CLAIMS REP</td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr>
              <td class=auto-style2></td>
              <td class=auto-style2>Bus Estimate</td>
              <td class=auto-style2></td>
              <td class=auto-style3>
                  <select id='MangerBusEst' style="border:none">
                    <option value="1">Yes</option>
                    <option value="0" selected>No</option>
                    <option value="2">Requested</option>
                    <option value="3">Repaired In-house</option>
                </select>
              <td class=auto-style2></td>
              <td class=auto-style3>
                  <select id='RepBusEst' style="border:none" name="D1">
                    <option></option>
                    <option value="1">Received</option>
                    <option value="0" >N/A</option>
                </select></td>
              <td class=auto-style2></td>
              <td class=auto-style2></td>
              <td class=auto-style2></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Bus Invoice</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='MangerBusInvoice' style="border:none">
                    <option value="1">Yes</option>
                    <option value="0" selected>No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='RepBusInvoice' style="border:none" name="D2">
                    <option></option>
                    <option value="1">Received</option>
                    <option value="0" >N/A</option>
                </select></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Police Report</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                   <select id='MangerPoliceReport' style="border:none">
                    <option value="1">Yes</option>
                    <option value="0" selected>No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='RepPoliceReport' style="border:none" name="D3">
                    <option></option>
                    <option value="1">Received</option>
                    <option value="0" >N/A</option>
                </select></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr>
              <td class=auto-style2></td>
              <td class=auto-style2>Customer Estimate</td>
              <td class=auto-style2></td>
              <td class=auto-style3 style='border-top:none'>
                  <select id='MangerCustomerEst' style="border:none">
                    <option value="1">Yes</option>
                    <option value="0" selected>No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=auto-style2></td>
              <td class=auto-style3 style='border-top:none'>
                  <select id='RepCustomerEst' style="border:none" name="D4">
                    <option></option>
                    <option value="1">Received</option>
                    <option value="0" >N/A</option>
                </select></td>
              <td class=auto-style2></td>
              <td class=auto-style2></td>
              <td class=auto-style2></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Customer Invoice</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='MangerCustomerInvoice' style="border:none">
                    <option value="1">Yes</option>
                    <option value="0" selected>No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='RepCustomerInvoice' style="border:none" name="D5">
                    <option></option>
                    <option value="1">Received</option>
                    <option value="0" >N/A</option>
                </select></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Slip &amp; Fall Weather Report</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='MangerSlipFall' style="border:none">
                    <option value="1">Yes</option>
                    <option value="0" selected>No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='RepSlipFall' style="border:none" name="D6">
                    <option></option>
                    <option value="1">Received</option>
                    <option value="0" >N/A</option>
                </select></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Driver MVR</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='MangerMVR' style="border:none">
                    <option value="1">Yes</option>
                    <option value="0" selected>No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='RepMVR' style="border:none" name="D7">
                    <option></option>
                    <option value="1">Received</option>
                    <option value="0" >N/A</option>
                </select></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Drug Test Obtained</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='ManagerDrugTestObtained' style="border:none">
                    <option value="1">Yes</option>
                    <option value="0" selected>No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='RepDrugTestObtained' style="border:none" name="D8">
                    <option></option>
                    <option value="1">Received</option>
                    <option value="0" >N/A</option>
                </select></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl683793 colspan=5>AT-FAULT ACCIDENTS (in addition to All Claims,
              Claims w/ Damage):</td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl683793></td>
              <td class=xl153793></td>
              <td class=xl693793>LOCATION MANAGER</td>
              <td class=xl153793></td>
              <td class=xl693793>CLAIMS REP<span style='mso-spacerun:yes'> </span></td>
              <td class=xl153793></td>
              <td class=xl153793><span style='mso-spacerun:yes'> </span></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Payroll deduction<span style='mso-spacerun:yes'> </span></td>
              <td class=xl153793></td>
              <td class=xl673793>
                  <select id='ManagerPayrollReduction' style="border:none" name="D9">
                    <option value="1">Yes</option>
                    <option value="0" selected>No</option>
                    <option value="2">Maybe</option>
                </select></td>
              <td class=xl153793></td>
              <td class=xl673793>
                  <select id='RepPayrollReduction' style="border:none" name="D11">
                    <option></option>
                    <option value="1">Received</option>
                    <option value="0" >N/A</option>
                </select></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Other Person's Insurance Info</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='ManagerOtherInsurance' style="border:none" name="D10">
                    <option value="1">Yes</option>
                    <option value="0" selected>No</option>
                    <option value="2">Requested</option>
                </select></td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='RepOtherInsurance' style="border:none" name="D12">
                    <option></option>
                    <option value="1">Received</option>
                    <option value="0" >N/A</option>
                </select></td>
              <td class=xl153793><span style='mso-spacerun:yes'> </span></td>
              <td class=xl153793></td>
              <td class=xl153793><span style='mso-spacerun:yes'> </span></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>COMMENTS/PENDING:</td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=68 style='mso-height-source:userset;height:51.0pt'>
              <td height=68 class=xl153793 style='height:51.0pt'></td>
              <td colspan=7 class=xl763793 width=753 style='width:566pt'>
                  <textarea id="Comments" class="auto-style1" cols="20" name="S1" style="border:none"></textarea></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl703793>SAVE &amp; SUBMIT</td>
              <td class=xl153793></td>
              <td class=xl713793>PRINT</td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
              <td class=xl153793></td>
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

