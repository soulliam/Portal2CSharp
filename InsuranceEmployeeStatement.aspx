<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceEmployeeStatement.aspx.cs" Inherits="InsuranceEmployeeStatement" %>

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

            $(document).ready(function () {

                turnOffAutoComplete();

                $("#Next").on('click', function () {
                    var thisIncidentID = $("#IncidentID").val();
                    window.location.href = './InsuranceThirdPartyStatement.aspx?IncidentID=' + thisIncidentID;
                });

                $("#Previous").on('click', function () {
                    var thisIncidentID = $("#IncidentID").val();
                    window.location.replace("./InsuranceManagerInvestigation.aspx?IncidentID=" + thisIncidentID);
                });
               
                $("#save").on("click", function () {
                    saveStatement();
                    swal({
                        title: 'Save',
                        text: "Successful",
                        confirmButtonColor: '#3085d6',
                        confirmButtonText: 'OK'
                    }).then(function () {
                        var thisIncidentID = $("#IncidentID").val();
                    });
                    
                });

                $("#saveContinue").on("click", function () {
                    saveStatement();
                    swal({
                        title: 'Save',
                        text: "Successful",
                        confirmButtonColor: '#3085d6',
                        confirmButtonText: 'OK'
                    }).then(function () {
                        var thisIncidentID = $("#IncidentID").val();
                        window.location.href = './InsuranceThirdPartyStatement.aspx?IncidentID=' + thisIncidentID;
                    });

                });

                $("#printReport").on('click', function () {
                    $("#printReport").hide();
                    $("#saveContinue").hide();
                    $("#save").hide();
                    $("#Next").hide();
                    $("#Previous").hide();
                    window.print();
                    $(document).one('click', function () {
                        $("#printReport").show();
                        $("#saveContinue").show();
                        $("#save").show();
                        $("#Next").show();
                        $("#Previous").show();
                    });
                });

                const params = new URLSearchParams(window.location.search);
                $("#IncidentID").val(params.get("IncidentID"));

                loadLocations().then(function () {
                    var thisIncidentID = $("#IncidentID").val();
                    loadIncident(thisIncidentID);
                    loadIncidentPCAEmployees(thisIncidentID);
                    loadCustomer(thisIncidentID);
                });
                
                Security();
            });

            function saveStatement(save) {

                var EmpClaimID = $("#EmployeeName").val();
                var CustClaimID = $("#CustomerName").val();
                var Position = $("#Position").val();
                var IncidentDesc = $("#IncidentDescription").val();
                var InjuryDesc = $("#InjuriesDescription").val();
                var EmpSignature = $("#EmployeeSignature").val();
                var StatementDate = $("#SignatureDate").val();

                if ($("#EmpClaimID").val() != 0) {
                    var url = $("#localApiDomain").val() + "InsuranceIncidents/PutEmployeeStatement/";
                    //var url = "http://localhost:52839/api/InsuranceIncidents/PutEmployeeStatement/";
                } else {
                    var url = $("#localApiDomain").val() + "InsuranceIncidents/PostEmployeeStatement/";
                    //var url = "http://localhost:52839/api/InsuranceIncidents/PostEmployeeStatement/";
                }

                return $.ajax({
                    type: "POST",
                    url: url,
                    data: {
                        "EmpClaimID": EmpClaimID,
                        "CustClaimID": CustClaimID,
                        "Position": Position,
                        "IncidentDesc": IncidentDesc,
                        "InjuryDesc": InjuryDesc,
                        "EmpSignature": EmpSignature,
                        "StatementDate": StatementDate
                    },
                    dataType: "json",
                    success: function (data) {
                        ManagerInvestigationID = data;
                    },
                    error: function (request, status, error) {
                        swal("Error saving statement " + error.toString());
                    }
                }).then(function () {

                });
            }

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
                            var getLocationOption = '#location option[value=' + data[0].LocationId + ']';
                            $(getLocationOption).prop("selected", true);
                            $("#IncidentNumber").val(data[0].IncidentNumber);
                            $("#IncidentDate").val(DateFormatForHTML5(data[0].IncidentDate));
                            
                        }
                    },
                    error: function (request, status, error) {
                        swal("There was an issue getting location information.");
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

                return $.ajax({
                    type: "GET",
                    url: url,
                    dataType: "json",
                    beforeSend: function (jqXHR, settings) {
                    },
                    success: function (data) {
                        for (i = 0; i < data.length; i++) {
                            dropdown.append($("<option style='font-weight: bold;'></option>").attr("value", data[i].LocationID).text(data[i].LocationName));
                        }
                    },
                    error: function (request, status, error) {
                        swal("There was an issue getting location information.");
                    }
                });
            }

            function loadIncidentPCAEmployees(id) {
                var dropdown = $('#EmployeeName');

                dropdown.empty();

                dropdown.append('<option selected="true">Pick an Employee</option>');
                dropdown.prop('selectedIndex', 0);

                //var url = "http://localhost:52839/api/InsuranceIncidents/GetPCAClaimVehiclesByIncident/" + id;
                var url = $("#localApiDomain").val() + "InsuranceIncidents/GetPCAClaimVehiclesByIncident/" + id;

                return $.ajax({
                    type: "GET",
                    url: url,
                    dataType: "json",
                    beforeSend: function (jqXHR, settings) {
                    },
                    success: function (data) {
                        for (i = 0; i < data.length; i++) {
                            dropdown.append($("<option style='font-weight: bold;'></option>").attr("value", data[i].EmpClaimID).text(data[i].DriverName));
                        }
                    },
                    
                    complete: function (data) {
                        $("#EmployeeName").on("change", function (e) {
                            loadEmpoyeeStatement(e.currentTarget.value);
                        });
                    },
                    error: function (request, status, error) {
                        swal("There was an issue getting location information.");
                    }
                });
            }

            function loadEmpoyeeStatement(ClaimID) {
                var url = $("#localApiDomain").val() + "InsuranceIncidents/GetEmployeeStatementByClaimID/" + ClaimID;
                //var url = "http://localhost:52839/api/InsuranceIncidents/GetEmployeeStatementByClaimID/" + ClaimID;

                $.ajax({
                    type: "GET",
                    url: url,
                    dataType: "json",
                    beforeSend: function (jqXHR, settings) {
                    },
                    success: function (data) {
                        if (data.length == 0) {
                            clearEmployeeStatement();
                        }

                        for (i = 0; i < data.length; i++) {
                            //var getLocationOption = '#location option[value=' + data[0].LocationId + ']';
                            //$(getLocationOption).prop("selected", true);
                            $("#EmployeeName").val(data[0].EmpClaimID);
                            $("#EmpClaimID").val(data[0].EmpClaimID);
                            $("#ClaimID").val(data[0].ClaimID);
                            $("#CustomerName").val(data[0].CustClaimID);
                            $("#Position").val(data[0].Position);
                            $("#IncidentDescription").val(data[0].IncidentDesc);
                            $("#InjuriesDescription").val(data[0].InjuryDesc);
                            $("#EmployeeSignature").val(data[0].EmpSignature);
                            $("#SignatureDate").val(DateFormatForHTML5(data[0].StatementDate));
                        }
                    },
                    error: function (request, status, error) {
                        swal("There was an issue getting location information.");
                    }
                }).then(function () {

                });
            }

            function clearEmployeeStatement() {
                $("#CustomerName").val(0);
                $("#Position").val("");
                $("#IncidentDescription").val("");
                $("#InjuriesDescription").val("");
            }

            function loadCustomer(id) {
                var dropdown = $('#CustomerName');

                dropdown.empty();

                dropdown.append('<option value="0">Pick Customer</option>');
                dropdown.prop('selectedIndex', 0);

                //var url = "http://localhost:52839/api/InsuranceClaims/GetThirdPartyEnvolved/" + id;
                var url = $("#localApiDomain").val() + "InsuranceClaims/GetThirdPartyEnvolved/" + id;

                $.ajax({
                    type: "GET",
                    url: url,
                    dataType: "json",
                    beforeSend: function (jqXHR, settings) {
                    },
                    success: function (data) {
                        for (i = 0; i < data.length; i++) {
                            dropdown.append($("<option style='font-weight: bold;'></option>").prop("value", data[i].ClaimID).text(data[i].ClaimantName));
                        }
                    },
                    error: function (request, status, error) {
                        swal("There was an issue getting customer information.");
                    }
                }).then(function () {
                    
                });
            }
        </script>

    <style>
        .xl1513889
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
        .xl6713889
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
        .xl6813889
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
        .xl6913889
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
        .xl7013889
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
        .xl7113889
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
        .xl7213889
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
        .xl7313889
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
        .xl7413889
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
        .xl7513889
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
        .xl7613889
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
        .xl7713889
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
        .xl7813889
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
        .xl7913889
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
            height: 108px;
        }

    </style>
        <input type="text" id="ClaimID" style="display:none" />
        <input type="text" id="EmpClaimID" style="display:none" />
        <div align=center>
        <input type="text" id="IncidentID" style="display:none" />
        <table border=0 cellpadding=0 cellspacing=0 width=802 style='border-collapse:
         collapse;table-layout:fixed;width:603pt'>
         <col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>
         <col width=182 style='mso-width-source:userset;mso-width-alt:6656;width:137pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1513889 width=19 style='height:15.75pt;width:14pt'><a
          name="RANGE!A1:I29"></a></td>
          <td class=xl1513889 width=182 style='width:137pt'></td>
          <td class=xl1513889 width=17 style='width:13pt'></td>
          <td class=xl1513889 width=177 style='width:133pt'></td>
          <td class=xl1513889 width=17 style='width:13pt'></td>
          <td class=xl1513889 width=177 style='width:133pt'></td>
          <td class=xl1513889 width=17 style='width:13pt'></td>
          <td class=xl1513889 width=177 style='width:133pt'></td>
          <td class=xl1513889 width=19 style='width:14pt'></td>
         </tr>
         <tr height=22 style='height:16.5pt'>
          <td height=22 class=xl1513889 style='height:16.5pt'></td>
          <td colspan=7 class=xl7213889 style='border-right:1.0pt solid black'>EMPLOYEE
          STATEMENT</td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr>
             <td class=auto-style1 colspan="9" style="text-align:center">
              <img alt="" src="./images/InsuranceIncidentReportHeader.png" /></td>
         </tr>
         <tr height=9 style='mso-height-source:userset;height:6.75pt'>
          <td height=9 class=xl1513889 style='height:6.75pt'></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1513889 style='height:15.75pt'></td>
          <td class=xl6713889 colspan=3>PCA EMPLOYEE - DRIVER / CASHIER STATEMENT</td>
          <td class=xl1513889></td>
          <td class=xl6713889>PCA INCIDENT #</td>
          <td class=xl1513889></td>
          <td class=xl7013889>
              <input id="IncidentNumber" type="text" style="border:none" /></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl6713889>EMPLOYEE NAME</td>
          <td class=xl1513889></td>
          <td colspan=3 class=xl7513889>
              <select id="EmployeeName" style="border:none"></select></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl6713889>POSITION</td>
          <td class=xl1513889></td>
          <td colspan=3 class=xl7513889>
              <input id="Position" type="text" style="border:none" /></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl6713889>DATE OF INCIDENT<span style='mso-spacerun:yes'> </span></td>
          <td class=xl1513889></td>
          <td colspan=3 class=xl7513889>
              <input type="date" id="IncidentDate" style="border:none" /></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl6713889>LOCATION OF INCIDENT</td>
          <td class=xl1513889></td>
          <td colspan=3 class=xl7513889>
              <select id="location" style="border:none"></select></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl6713889>CUSTOMER NAME</td>
          <td class=xl1513889></td>
          <td colspan=3 class=xl7513889>
              <select id="CustomerName" style="border:none"></select></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl6713889 colspan=5>DESCRIPTION OF WHAT HAPPENED AND/OR WHAT YOU
          WITNESSED: (FACTS ONLY):</td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=118 style='mso-height-source:userset;height:88.5pt'>
          <td height=118 class=xl1513889 style='height:88.5pt'></td>
          <td colspan=7 class=xl7613889 width=764 style='border-right:.5pt solid black;
          width:575pt'>
              <textarea id="IncidentDescription" class="auto-style1" cols="20" name="S1" style="border:none"></textarea></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl6713889 colspan=3>WERE THERE ANY INJURIES? If so, please
          describe:</td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=118 style='mso-height-source:userset;height:88.5pt'>
          <td height=118 class=xl1513889 style='height:88.5pt'></td>
          <td colspan=7 class=xl7613889 width=764 style='border-right:.5pt solid black;
          width:575pt'><textarea id="InjuriesDescription" class="auto-style1" cols="20" name="S1" style="border:none"></textarea></td></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td colspan=3 class=xl7913889>
              <input id="EmployeeSignature" type="text" style="border:none" /></td>
          <td class=xl1513889></td>
          <td class=xl6813889>
              <input id="SignatureDate" type="date" style="border:none" /></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl6713889>Employee's Signature</td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl6713889>Date</td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl1513889><input id="save" type="button" value="Save" style="height:26px;background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl1513889></td>
          <td class=xl1513889><input id="saveContinue" type="button" value="Save & Continue" style="height:26px;background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl1513889></td>
          <td class=xl1513889><input id="printReport" type="button" value="Print Report" style="background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl1513889></td>
          <td class=xl7113889>SECTION 3 OF 5</td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1513889 style='height:15.0pt'></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
          <td class=xl1513889></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl6713889><input id="Previous" type="button" value="&larr; Previous" style="background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl1527147></td>
          <td class=xl7627147></td>
          <td class=xl1527147></td>
          <td class=xl8227147></td>
          <td class=xl1527147></td>
          <td class=xl6713889><input id="Next" type="button" value="NEXT &rarr;" style="background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl1527147></td>
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
          <td width=19 style='width:14pt'></td>
          <td width=182 style='width:137pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=19 style='width:14pt'></td>
         </tr>
         <![endif]>
        </table>

        </div>

</asp:Content>


