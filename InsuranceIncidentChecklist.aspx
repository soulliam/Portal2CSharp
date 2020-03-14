<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceIncidentChecklist.aspx.cs" Inherits="InsuranceIncidentChecklist" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
        <script>
            var group = '<%= Session["groupList"] %>';
            var IncidentID = "";

            $(document).ready(function () {

                $("#printReport").on('click', function () {
                    $("#printReport").hide();
                    $("#saveSubmit").hide();
                    window.print();
                    $(document).one('click', function () {
                        $("#printReport").show();
                        $("#saveSubmit").show();
                    });
                });

                $("#saveSubmit").on('click', function () {

                    var creator = $("#txtLoggedinUsername").val().replace('PCA\\', '');

                    //var url = "http://localhost:52839/api/InsuranceIncidents/PutIncidentCheckList/";
                    var url = $("#localApiDomain").val() + "InsuranceIncidents/PutIncidentCheckList/";

                    $.ajax({
                        type: "POST",
                        url: url,
                        data: {
                            "EmployeeStatementManager": $("#EmployeeStatementManager").val(),
                            "EmployeeStatementRep": $("#EmployeeStatementRep").val(),
                            "CustomerStatementManager": $("#CustomerStatementManager").val(),
                            "CustomerStatementRep": $("#CustomerStatementRep").val(),
                            "WitnessStatementManger": $("#WitnessStatementManger").val(),
                            "WitnessStatementRep": $("#WitnessStatementRep").val(),
                            "ManagerStatementManager": $("#ManagerStatementManager").val(),
                            "ManagerStatementRep": $("#ManagerStatementRep").val(),
                            "PicturesManager": $("#PicturesManager").val(),
                            "PicturesRep": $("#PicturesRep").val(),
                            "OrigDocsManager": $("#OrigDocsManager").val(),
                            "OrigDocsRep": $("#OrigDocsRep").val(),
                            "BusEstManager": $("#BusEstManager").val(),
                            "BusEstRep": $("#BusEstRep").val(),
                            "BusInvManager": $("#BusInvManager").val(),
                            "BusInvRep": $("#BusInvRep").val(),
                            "PoliceReportManager": $("#PoliceReportManager").val(),
                            "PoliceReportRep": $("#PoliceReportRep").val(),
                            "CustEstManager": $("#CustEstManager").val(),
                            "CustEstRep": $("#CustEstRep").val(),
                            "CustInvManager": $("#CustInvManager").val(),
                            "CustInvRep": $("#CustInvRep").val(),
                            "SlipFallWeatherManager": $("#SlipFallWeatherManager").val(),
                            "SlipFallWeatherRep": $("#SlipFallWeatherRep").val(),
                            "DriverMVRManager": $("#DriverMVRManager").val(),
                            "DriverMVRRep": $("#DriverMVRRep").val(),
                            "DrugTestManager": $("#DrugTestManager").val(),
                            "DrugTestRep": $("#DrugTestRep").val(),
                            "PayrollDeductManager": $("#PayrollDeductManager").val(),
                            "PayrollDeductRep": $("#PayrollDeductRep").val(),
                            "OtherPersonInsuranceManager": $("#OtherPersonInsuranceManager").val(),
                            "OtherPersonInsuranceRep": $("#OtherPersonInsuranceRep").val(),
                            "Comments": $("#Comments").val(),
                            "IncidentID": IncidentID
                        },
                        dataType: "json",
                        success: function (Response) {
                            swal({
                                title: 'Save',
                                text: "Successful",
                                confirmButtonColor: '#3085d6',
                                confirmButtonText: 'OK'
                            }).then(function () {
                                window.location.href = "InsuranceIncidentChecklist.aspx?IncidentID=" + IncidentID;
                            });
                        },
                        error: function (request, status, error) {
                            swal("Error Creating Checklist - " + error );
                        },
                        complete: function (data) {
                            
                        }
                    });
                });

                const params = new URLSearchParams(window.location.search);
                IncidentID = params.get("IncidentID");
                $("#IncidentID").val(IncidentID);

                loadLocations();
                loadCheckList(IncidentID);
            });

            function loadIncident(id) {
                var url = $("#localApiDomain").val() + "InsuranceIncidents/GetIncidentByID/" + id;
                //var url = "http://localhost:52839/api/InsuranceIncidents/GetIncidentByID/" + id;

                $.ajax({
                    type: "GET",
                    url: url,
                    dataType: "json",
                    beforeSend: function (jqXHR, settings) {
                    },
                    success: function (data) {
                        for (i = 0; i < data.length; i++) {
                            $("#location").val(data[0].LocationName);
                            $("#IncidentNumber").val(data[0].IncidentNumber);
                            $("#IncidentAddress").val(data[0].IncidentStreetAddress);
                            $("#IncidentCity").val(data[0].IncidentCity);
                            $("#IncidentZip").val(data[0].IncidentZip);
                            $("#IncidentPhone").val(data[0].IncidentPhone);
                            $("#IncidentState").val(data[0].StateAbbreviation);
                            $("#IncidentLRS").val(data[0].IncidentLotRowSpace);
                            $("input[name=operationType][value=" + data[0].OperationTypeID + "]").prop('checked', true);
                            var thisIncidentDate = new Date(data[0].IncidentDate)
                            $("#IncidentDate").val(DateFormatForHTML5(thisIncidentDate));
                            $("#IncidentTime").val(data[0].IncidentTime);
                            $("#IncidentStayDuration").val(data[0].StayDuration);
                            $("#Injuries option[value=" + data[0].IncidentInjuries + "]").prop('selected', true);
                            $("#IncidentPoliceReportNumber").val(data[0].PoliceReportNumber);
                            var thisPoliceReportDate = new Date(data[0].PoliceReportDate)
                            $("#IncidentPoliceReportDate").val(DateFormatForHTML5(thisPoliceReportDate));
                            $("#IncidentPoliceName").val(data[0].OfficerName);
                        }
                    },
                    error: function (request, status, error) {
                        swal("There was an issue getting location information.");
                    }
                }).done(function () {

                });
            }

            function loadCheckList(IncidentID) {
                var url = $("#localApiDomain").val() + "InsuranceIncidents/getIncidentCheckListByID/" + IncidentID;
                //var url = "http://localhost:52839/api/InsuranceIncidents/getIncidentCheckListByID/" + IncidentID;

                $.ajax({
                    type: "GET",
                    url: url,
                    dataType: "json",
                    beforeSend: function (jqXHR, settings) {
                    },
                    success: function (data) {
                        for (i = 0; i < data.length; i++) {
                            $("#EmployeeStatementManager option[value=" + data[0].EmployeeStatementManager + "]").prop('selected', true);
                            $("#EmployeeStatementRep option[value=" + data[0].EmployeeStatementRep + "]").prop('selected', true);
                            $("#CustomerStatementManager option[value=" + data[0].CustomerStatementManager + "]").prop('selected', true);
                            $("#CustomerStatementRep option[value=" + data[0].CustomerStatementRep + "]").prop('selected', true);
                            $("#WitnessStatementManger option[value=" + data[0].WitnessStatementManger + "]").prop('selected', true);
                            $("#WitnessStatementRep option[value=" + data[0].WitnessStatementRep + "]").prop('selected', true);
                            $("#ManagerStatementManager option[value=" + data[0].ManagerStatementManager + "]").prop('selected', true);
                            $("#ManagerStatementRep option[value=" + data[0].ManagerStatementRep + "]").prop('selected', true);
                            $("#PicturesManager option[value=" + data[0].PicturesManager + "]").prop('selected', true);
                            $("#PicturesRep option[value=" + data[0].PicturesRep + "]").prop('selected', true);
                            $("#OrigDocsManager option[value=" + data[0].OrigDocsManager + "]").prop('selected', true);
                            $("#OrigDocsRep option[value=" + data[0].OrigDocsRep + "]").prop('selected', true);
                            $("#BusEstManager option[value=" + data[0].BusEstManager + "]").prop('selected', true);
                            $("#BusEstRep option[value=" + data[0].BusEstRep + "]").prop('selected', true);
                            $("#BusInvManager option[value=" + data[0].BusInvManager + "]").prop('selected', true);
                            $("#BusInvRep option[value=" + data[0].BusInvRep + "]").prop('selected', true);
                            $("#PoliceReportManager option[value=" + data[0].PoliceReportManager + "]").prop('selected', true);
                            $("#PoliceReportRep option[value=" + data[0].PoliceReportRep + "]").prop('selected', true);
                            $("#CustEstManager option[value=" + data[0].CustEstManager + "]").prop('selected', true);
                            $("#CustEstRep option[value=" + data[0].CustEstRep + "]").prop('selected', true);
                            $("#CustInvManager option[value=" + data[0].CustInvManager + "]").prop('selected', true);
                            $("#CustInvRep option[value=" + data[0].CustInvRep + "]").prop('selected', true);
                            $("#SlipFallWeatherManager option[value=" + data[0].SlipFallWeatherManager + "]").prop('selected', true);
                            $("#SlipFallWeatherRep option[value=" + data[0].SlipFallWeatherRep + "]").prop('selected', true);
                            $("#DriverMVRManager option[value=" + data[0].DriverMVRManager + "]").prop('selected', true);
                            $("#DriverMVRRep option[value=" + data[0].DriverMVRRep + "]").prop('selected', true);
                            $("#DrugTestManager option[value=" + data[0].DrugTestManager + "]").prop('selected', true);
                            $("#DrugTestRep option[value=" + data[0].DrugTestRep + "]").prop('selected', true);
                            $("#PayrollDeductManager option[value=" + data[0].PayrollDeductManager + "]").prop('selected', true);
                            $("#PayrollDeductRep option[value=" + data[0].PayrollDeductRep + "]").prop('selected', true);
                            $("#OtherPersonInsuranceManager option[value=" + data[0].OtherPersonInsuranceManager + "]").prop('selected', true);
                            $("#OtherPersonInsuranceRep option[value=" + data[0].OtherPersonInsuranceRep + "]").prop('selected', true);
                            $("#Comments").val(data[0].Comments);
                        }
                    },
                    error: function (request, status, error) {
                        swal("There was an issue getting checklist information.");
                    }
                }).done(function () {

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
                }).then(function () {
                    loadIncident(IncidentID);
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
            <input type="text" id="IncidentID" style="display:none" />
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
              <td class=xl673793><input type="text" id="location" style="border:none" /></td>
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
              <td class=xl673793><input type='date' id='IncidentDate' style='border:none' /></td>
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
              <td class=xl673793 style='border-top:none'><input type='time' id='IncidentTime' style='border:none' /></td>
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
                  <select id="Injuries" style="border:none">
                      <option value="-1" selected></option><option value="1">Yes</option>
                      <option value="0" >No</option>
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
              <td class=xl673793 style='border-top:none'><input type='date' id='IncidentPoliceReportDate' style='border:none' /></td>
              <td class=xl153793></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl153793 style='height:15.0pt'></td>
              <td class=xl153793>Operation Type</td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'><input name="operationType" type="radio" value="0" style="width:25px" />Self Park<input name="operationType" type="radio" value="1" style="width:25px" />Valet</td>
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
                <select id='EmployeeStatementManager' style="border:none">
                    <option value="-1" selected></option><option value="1">Yes</option>
                    <option value="0" >No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793>
                  <select id='EmployeeStatementRep' style="border:none">
                    <option value="-1"></option>
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
                  <select id='CustomerStatementManager' style="border:none">
                    <option value="-1" selected></option><option value="1">Yes</option>
                    <option value="0" >No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='CustomerStatementRep' style="border:none">
                    <option value="-1"></option>
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
                  <select id='WitnessStatementManger' style="border:none">
                    <option value="-1" selected></option><option value="1">Yes</option>
                    <option value="0" >No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='WitnessStatementRep' style="border:none">
                    <option value="-1"></option>
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
                  <select id='ManagerStatementManager' style="border:none">
                    <option value="-1" selected></option><option value="1">Yes</option>
                    <option value="0" >No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='ManagerStatementRep' style="border:none">
                    <option value="-1"></option>
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
                  <select id='PicturesManager' style="border:none">
                    <option value="-1" selected></option><option value="1">Yes</option>
                    <option value="0" >No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='PicturesRep' style="border:none">
                    <option value="-1"></option>
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
                  <select id='OrigDocsManager' style="border:none">
                    <option value="-1" selected></option><option value="1">Yes</option>
                    <option value="0" >No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='OrigDocsRep' style="border:none">
                    <option value="-1"></option>
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
                  <select id='BusEstManager' style="border:none">
                    <option value="-1" selected></option><option value="1">Yes</option>
                    <option value="0" >No</option>
                    <option value="2">Requested</option>
                    <option value="3">Repaired In-house</option>
                </select>
              <td class=auto-style2></td>
              <td class=auto-style3>
                  <select id='BusEstRep' style="border:none" name="D1">
                    <option value="-1"></option>
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
                  <select id='BusInvManager' style="border:none">
                    <option value="-1" selected></option><option value="1">Yes</option>
                    <option value="0" >No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='BusInvRep' style="border:none" name="D2">
                    <option value="-1"></option>
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
                   <select id='PoliceReportManager' style="border:none">
                    <option value="-1" selected></option><option value="1">Yes</option>
                    <option value="0" >No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='PoliceReportRep' style="border:none" name="D3">
                    <option value="-1"></option>
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
                  <select id='CustEstManager' style="border:none">
                    <option value="-1" selected></option><option value="1">Yes</option>
                    <option value="0" >No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=auto-style2></td>
              <td class=auto-style3 style='border-top:none'>
                  <select id='CustEstRep' style="border:none" name="D4">
                    <option value="-1"></option>
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
                  <select id='CustInvManager' style="border:none">
                    <option value="-1" selected></option><option value="1">Yes</option>
                    <option value="0" >No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='CustInvRep' style="border:none" name="D5">
                    <option value="-1"></option>
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
                  <select id='SlipFallWeatherManager' style="border:none">
                    <option value="-1" selected></option><option value="1">Yes</option>
                    <option value="0" >No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='SlipFallWeatherRep' style="border:none" name="D6">
                    <option value="-1"></option>
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
                  <select id='DriverMVRManager' style="border:none">
                    <option value="-1" selected></option><option value="1">Yes</option>
                    <option value="0" >No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='DriverMVRRep' style="border:none" name="D7">
                    <option value="-1"></option>
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
                  <select id='DrugTestManager' style="border:none">
                    <option value="-1" selected></option><option value="1">Yes</option>
                    <option value="0" >No</option>
                    <option value="2">Requested</option>
                </select>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='DrugTestRep' style="border:none" name="D8">
                    <option value="-1"></option>
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
                  <select id='PayrollDeductManager' style="border:none" name="D9">
                    <option value="-1" selected></option><option value="1">Yes</option>
                    <option value="0" >No</option>
                    <option value="2">Maybe</option>
                </select></td>
              <td class=xl153793></td>
              <td class=xl673793>
                  <select id='PayrollDeductRep' style="border:none" name="D11">
                    <option value="-1"></option>
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
                  <select id='OtherPersonInsuranceManager' style="border:none" name="D10">
                    <option value="-1" selected></option><option value="1">Yes</option>
                    <option value="0" >No</option>
                    <option value="2">Requested</option>
                </select></td>
              <td class=xl153793></td>
              <td class=xl673793 style='border-top:none'>
                  <select id='OtherPersonInsuranceRep' style="border:none" name="D12">
                    <option value="-1"></option>
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
              <td class=xl153793><input id="saveSubmit" type="button" value="SAVE &amp; SUBMIT" style="background-color:black;color:white;font-weight:bold" /></td>
              <td class=xl153793></td>
              <td class=xl153793><input id="printReport" type="button" value="Print Report" style="background-color:black;color:white;font-weight:bold" /></td>
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

