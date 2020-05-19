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
            var group = '<%= Session["groupList"] %>';

            $(document).ready(function () {
                turnOffAutoComplete();

                $("#Next").on('click', function () {
                    var thisIncidentID = $("#IncidentID").val();
                    window.location.href = './InsuranceWitnessStatement.aspx?IncidentID=' + thisIncidentID;
                });

                $("#Previous").on('click', function () {
                    var thisIncidentID = $("#IncidentID").val();
                    window.location.replace("./InsuranceEmployeeStatement.aspx?IncidentID=" + thisIncidentID);
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
                        window.location.href = './InsuranceWitnessStatement.aspx?IncidentID=' + thisIncidentID;
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
                    loadThirdPartyName(thisIncidentID);
                });

                Security();
            });


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

            function loadThirdPartyName(id) {
                var dropdown = $('#ThirdPartyName');

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
                    complete: function (data) {
                        $("#ThirdPartyName").on("change", function (e) {
                            loadThirdPartyIncidentInfo(e.currentTarget.value);
                            loadThirdPartyStatementInfo(e.currentTarget.value);
                        });
                    },
                    error: function (request, status, error) {
                        swal("There was an issue getting third party information.");
                    }
                }).then(function () {

                });
            }

            function loadThirdPartyIncidentInfo(id) {

                //var url = "http://localhost:52839/api/InsuranceIncidents/GetThirdPartyClaimVehiclesByClaim/" + id;
                var url = $("#localApiDomain").val() + "InsuranceIncidents/GetThirdPartyClaimVehiclesByClaim/" + id;

                $.ajax({
                    type: "GET",
                    url: url,
                    dataType: "json",
                    beforeSend: function (jqXHR, settings) {
                    },
                    success: function (data) {
                        for (i = data.length - 1 ; i >= 0; i--) {
                            $("#ClaimID").val(data[i].ClaimID);
                            $("#ThirdPartyName").val(data[i].ClaimID);
                            $("#ThirdPartyAddress").val(data[i].CustomerStreetAddress);
                            $("#ThirdPartyCity").val(data[i].CustomerCity);
                            $("#ThirdPartyState").val(data[i].CustomerState);
                            $("#ThirdPartyZip").val(data[i].CustomerZip);
                            $("#ThirdPartyMobilePhone").val(data[i].CustomerPhoneMobile);
                            $("#ThirdPartyHomePhone").val(data[i].CustomerPhoneHome);
                            $("#ThirdPartyEmail").val(data[i].CustomerEmailAddress);
                            $("input[name=Injuries][value=" + data[i].Injuries + "]").prop('checked', true);
                        }
                    },
                    error: function (request, status, error) {
                        swal("There was an issue getting third party information.");
                    }
                });
            }

            function loadThirdPartyStatementInfo(id) {

                //var url = "http://localhost:52839/api/InsuranceIncidents/GetThirdPartyStatementByClaimID/" + id;
                var url = $("#localApiDomain").val() + "InsuranceIncidents/GetThirdPartyStatementByClaimID/" + id;

                $.ajax({
                    type: "GET",
                    url: url,
                    dataType: "json",
                    beforeSend: function (jqXHR, settings) {
                    },
                    success: function (data) {
                        if (data.length == 0) {
                            clearThirdPartyStatement();
                        }
                        for (i = data.length - 1 ; i >= 0; i--) {
                            $("#ThirdPartyStatementID").val(data[i].ThirdPartyStatementID);
                            $("#StayDuration").val(data[i].StayDuration);
                            $("#LotRowSpace").val(data[i].LotRowSpace);
                            $("#IncidentDesc").val(data[i].IncidentDesc);
                            $("#ThirdPartySignature").val(data[i].ThirdPartySignature);
                            $("#SignatureDate").val(DateFormatForHTML5(data[i].SignatureDate));
                        }
                    },
                    error: function (request, status, error) {
                        swal("There was an issue getting third party information.");
                    }
                });
            }

            function clearThirdPartyStatement() {
                $("#ThirdPartyStatementID").val("");
                $("#StayDuration").val("");
                $("#LotRowSpace").val("");
                $("#IncidentDesc").val("");
                $("#ThirdPartySignature").val("");
                $("#SignatureDate").val("");
            }

            function saveStatement(save) {

                var CustClaimID = $("#ClaimID").val();
                var StayDuration = $("#StayDuration").val();
                var LotRowSpace = $("#LotRowSpace").val();
                var IncidentDesc = $("#IncidentDesc").val();
                var ThirdPartySignature = $("#ThirdPartySignature").val();
                var SignatureDate = $("#SignatureDate").val();

                if ($("#ThirdPartyStatementID").val() != "") {
                    var url = $("#localApiDomain").val() + "InsuranceIncidents/PutThirdPartyStatement/";
                    //var url = "http://localhost:52839/api/InsuranceIncidents/PutThirdPartyStatement/";
                } else {
                    var url = $("#localApiDomain").val() + "InsuranceIncidents/PostThirdPartyStatement/";
                    //var url = "http://localhost:52839/api/InsuranceIncidents/PostThirdPartyStatement/";
                }

                return $.ajax({
                    type: "POST",
                    url: url,
                    data: {
                        "CustClaimID": CustClaimID,
                        "StayDuration": StayDuration,
                        "LotRowSpace": LotRowSpace,
                        "IncidentDesc": IncidentDesc,
                        "ThirdPartySignature": ThirdPartySignature,
                        "SignatureDate": SignatureDate
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
        <input type="text" id="IncidentID" style="display:none" />
        <input type="text" id="ClaimID" style="display:none" />
        <input type="text" id="ThirdPartyStatementID" style="display:none" />
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
          <td class=xl6817237>ThirdParty NAME</td>
          <td class=xl1517237></td>
          <td colspan=3 class=xl7617237>
              <select id="ThirdPartyName" style="border:none"></select></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl6817237>ADDRESS</td>
          <td class=xl1517237></td>
          <td colspan=3 class=xl7617237>
              <input id="ThirdPartyAddress" type="text" style="border:none" /></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl6817237>CITY</td>
          <td class=xl1517237></td>
          <td class=xl6717237 style='border-top:none'>
              <input id="ThirdPartyCity" type="text" style="border:none" /></td>
          <td class=xl1517237></td>
          <td class=xl6817237>STATE</td>
          <td class=xl1517237></td>
          <td class=xl6717237>
              <input id="ThirdPartyState" type="text" style="border:none" /></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl6817237>ZIP CODE</td>
          <td class=xl1517237></td>
          <td class=xl6717237 style='border-top:none'>
              <input id="ThirdPartyZip" type="text" style="border:none" /></td>
          <td class=xl1517237></td>
          <td class=xl6817237>DATE OF INCIDENT</td>
          <td class=xl1517237></td>
          <td class=xl6717237 style='border-top:none'>
              <input type="date" id="IncidentDate" style="border:none"></input></td>
          <td class=xl1517237></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl6817237>HOME PHONE</td>
          <td class=xl1517237></td>
          <td class=xl6717237 style='border-top:none'>
              <input id="ThirdPartyHomePhone" type="text" style="border:none" /></td>
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
              <input id="ThirdPartyMobilePhone" type="text" style="border:none" /></td>
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
              <input id="ThirdPartyEmail" type="text" style="border:none" /></td>
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
              <input id="SignatureDate" type="date" style="border:none" /></td>
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
          <td class=xl1517237><input id="save" type="button" value="Save" style="height:26px;background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl1517237></td>
          <td class=xl1517237><input id="saveContinue" type="button" value="Save & Continue" style="height:26px;background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl1517237></td>
          <td class=xl1517237><input id="printReport" type="button" value="Print Report" style="background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl1517237></td>
          <td class=xl7217237>SECTION 4 OF 5</td>
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
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl6817237><input id="Previous" type="button" value="&larr; Previous" style="background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl1527147></td>
          <td class=xl7627147></td>
          <td class=xl1527147></td>
          <td class=xl8227147></td>
          <td class=xl1527147></td>
          <td class=xl6817237><input id="Next" type="button" value="NEXT &rarr;" style="background-color:black;color:white;font-weight:bold" /></td>
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

