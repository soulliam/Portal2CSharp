<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceWitnessStatement.aspx.cs" Inherits="InsuranceWitnessStatement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
        <script>
            var group = '<%= Session["groupList"] %>';

            $(document).ready(function () {

                $("#saveContinue").on("click", function () {
                    saveStatement(true);
                    swal({
                        title: 'Save',
                        text: "Successful",
                        confirmButtonColor: '#3085d6',
                        confirmButtonText: 'OK'
                    }).then(function () {
                        var thisIncidentID = $("#IncidentID").val();
                        window.close();
                    });

                });

                $("#Save").on("click", function () {
                    saveStatement(false);
                    swal({
                        title: 'Save',
                        text: "Successful",
                        confirmButtonColor: '#3085d6',
                        confirmButtonText: 'OK'
                    }).then(function () {
                        var thisIncidentID = $("#IncidentID").val();
                    });

                });

                $("#printReport").on('click', function () {
                    $("#printReport").hide();
                    $("#saveContinue").hide();
                    window.print();
                    $(document).one('click', function () {
                        $("#printReport").show();
                        $("#saveContinue").show();
                        $("#save").show();
                    });
                });

                const params = new URLSearchParams(window.location.search);
                $("#IncidentID").val(params.get("IncidentID"));

                loadLocations().then(function () {
                    var thisIncidentID = $("#IncidentID").val();
                    loadStates()
                    loadIncident(thisIncidentID);
                    loadWitnessList(thisIncidentID);
                });

                Security();
            });

            function loadStates() {
                var dropdown = $("#WitnessState");

                dropdown.empty();

                dropdown.append('<option selected="true">State</option>');
                dropdown.prop('selectedIndex', 0);

                //var url = "http://localhost:52839/api/InsuranceLocations/GetStates/";
                var url = $("#localApiDomain").val() + "InsuranceLocations/GetStates/";

                $.ajax({
                    type: "GET",
                    url: url,
                    dataType: "json",
                    beforeSend: function (jqXHR, settings) {
                    },
                    success: function (data) {
                        for (i = 0; i < data.length; i++) {
                            dropdown.append("<option value='" + data[i].LocationStateID + "' style='font-weight: bold;'>" + data[i].StateAbbreviation + "</option>");
                        }
                    },
                    error: function (request, status, error) {
                        swal("There was an issue getting state information.");
                    }
                });
            }


            function loadLocations() {
                var locationString = $("#userVehicleLocation").val();
                var dropdown = $('#IncidentLocation');

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
                            var getLocationOption = '#IncidentLocation option[value=' + data[0].LocationId + ']';
                            $(getLocationOption).prop("selected", true);
                            $("#IncidentNumber").val(data[0].IncidentNumber);
                            $("#IncidentDate").val(DateFormatForHTML5(data[0].IncidentDate));
                            $("#WitnessState").val(data[0].WitnessStateID);

                        }
                    },
                    error: function (request, status, error) {
                        swal("There was an issue getting location information.");
                    }
                }).then(function () {

                });
            }

            function loadWitnessList(id) {
                var dropdown = $('#WitnessName');

                dropdown.empty();

                dropdown.append('<option value="0">Pick Witness</option>');
                dropdown.prop('selectedIndex', 0);

                //var url = "http://localhost:52839/api/InsuranceIncidents/GetIncidentWitnessByManagerInvestigationID/" + id;
                var url = $("#localApiDomain").val() + "InsuranceIncidents/GetIncidentWitnessByManagerInvestigationID/" + id;

                $.ajax({
                    type: "GET",
                    url: url,
                    dataType: "json",
                    beforeSend: function (jqXHR, settings) {
                    },
                    success: function (data) {
                        for (i = 0; i < data.length; i++) {
                            dropdown.append($("<option style='font-weight: bold;'></option>").prop("value", data[i].WitnessID).text(data[i].WitnessName));
                        }
                    },
                    complete: function (data) {
                        $("#WitnessName").on("change", function (e) {
                            clearThirdPartyStatement();
                            loadIncidentWitness(e.currentTarget.value);
                            loadIncidentWitnessStatement(e.currentTarget.value);
                        });
                    },
                    error: function (request, status, error) {
                        swal("There was an issue getting third party information.");
                    }
                }).then(function () {

                });
            }

            function loadIncidentWitness(id) {

                //var url = "http://localhost:52839/api/InsuranceIncidents/GetWitnessByWitnessID/" + id;
                var url = $("#localApiDomain").val() + "InsuranceIncidents/GetWitnessByWitnessID/" + id;

                $.ajax({
                    type: "GET",
                    url: url,
                    dataType: "json",
                    beforeSend: function (jqXHR, settings) {
                    },
                    success: function (data) {
                        $("#WitnessAddress").val(data[0].WitnessAddress);
                        $("#WitnessCity").val(data[0].WitnessCity);
                        $("#WitnessZip").val(data[0].WitnessZip);
                        $("#WitnessPhone").val(data[0].WitnessPhone);
                        $("#WitnessState").val(data[0].WitnessStateID);
                        $("input[name=" + "Passenger" + "][value=" + data[0].Passenger + "]").prop('checked', true);
                    },
                    error: function (request, status, error) {
                        swal("There was an issue getting PCA witness information.");
                    }
                });
            }

            function loadIncidentWitnessStatement(id) {

                //var url = "http://localhost:52839/api/InsuranceIncidents/GetWitnessStatementByWitnessID/" + id;
                var url = $("#localApiDomain").val() + "InsuranceIncidents/GetWitnessStatementByWitnessID/" + id;

                $.ajax({
                    type: "GET",
                    url: url,
                    dataType: "json",
                    beforeSend: function (jqXHR, settings) {
                    },
                    success: function (data) {
                        if (data.length != 0) {
                            $("#WitnessID").val(data[0].WitnessID);
                            $("#IncidentDesc").val(data[0].IncidentDesc);
                            $("#WitnessSignature").val(data[0].WitnessSignature);
                            $("#SignatureDate").val(DateFormat(data[0].SignatureDate));
                        } 
                    },
                    error: function (request, status, error) {
                        swal("There was an issue getting PCA witness information.");
                    }
                });
            }


            function clearThirdPartyStatement() {
                $("#WitnessID").val("");
                $("#WitnessAddress").val("");
                $("#WitnessCity").val("");
                $("#WitnessState").val(0);
                $("#WitnessZip").val("");
                $("#WitnessPhone").val("");
                $("input[name=" + "Passenger" + "][value=0]").prop('checked', true);
                $("#IncidentDesc").val("");
                $("#WitnessSignature").val('');
                $("#SignatureDate").val('');
            }

            function saveStatement(submit) {

                var WitnessID = $("#WitnessID").val();
                var IncidentDesc = $("#IncidentDesc").val();
                var WitnessSignature = $("#WitnessSignature").val();
                var SignatureDate = $("#SignatureDate").val();

                if ($("#WitnessID").val() != "") {
                    var url = $("#localApiDomain").val() + "InsuranceIncidents/PutWitnessStatement/";
                    //var url = "http://localhost:52839/api/InsuranceIncidents/PutWitnessStatement/";
                } else {
                    var url = $("#localApiDomain").val() + "InsuranceIncidents/PostWitnessStatement/";
                    WitnessID = $("#WitnessName").val();
                    //var url = "http://localhost:52839/api/InsuranceIncidents/PostWitnessStatement/";
                }

                return $.ajax({
                    type: "POST",
                    url: url,
                    data: {
                        "WitnessID": WitnessID,
                        "IncidentDesc": IncidentDesc,
                        "WitnessSignature": WitnessSignature,
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
                    if (submit == true) {
                        updateIncidentStatus();
                    }
                });
            }

            function updateIncidentStatus() {
                var url = $("#localApiDomain").val() + "InsuranceIncidents/UpdateIncidentStatus/";
                //var url = "http://localhost:52839/api/InsuranceIncidents/PutWitnessStatement/";
                
                var thisIncidentID = $("#IncidentID").val();

                return $.ajax({
                    type: "POST",
                    url: url,
                    data: {
                        "IncidentStatusID": 2,
                        "IncidentID": thisIncidentID
                    },
                    dataType: "json",
                    success: function (data) {
                    },
                    error: function (request, status, error) {
                        swal("Error updating incident status");
                    }
                }).then(function () {
                    
                });
            }

        </script>    

        <input type="text" id="IncidentID" style="display:none" />
        <input type="text" id="WitnessID" style="display:none" />
        <style>
            .xl1527937
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
            .xl6727937
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
            .xl6827937
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
            .xl6927937
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
            .xl7027937
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
            .xl7127937
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
            .xl7227937
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
	            border-right:.5pt solid windowtext;
	            border-bottom:.5pt solid windowtext;
	            border-left:.5pt solid windowtext;
	            mso-background-source:auto;
	            mso-pattern:auto;
	            white-space:nowrap;}
            .xl7327937
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
            .xl7427937
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
	            border-right:.5pt solid windowtext;
	            border-bottom:.5pt solid windowtext;
	            border-left:.5pt solid windowtext;
	            mso-background-source:auto;
	            mso-pattern:auto;
	            white-space:nowrap;}
            .xl7527937
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
            .xl7627937
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
            .xl7727937
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
            .xl7827937
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
            .xl7927937
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
            .xl8027937
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
            .xl8127937
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
                height: 74px;
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
              <td height=21 class=xl1527937 width=18 style='height:15.75pt;width:14pt'><a
              name="RANGE!A1:I24"></a></td>
              <td class=xl1527937 width=182 style='width:137pt'></td>
              <td class=xl1527937 width=17 style='width:13pt'></td>
              <td class=xl1527937 width=177 style='width:133pt'></td>
              <td class=xl1527937 width=17 style='width:13pt'></td>
              <td class=xl1527937 width=177 style='width:133pt'></td>
              <td class=xl1527937 width=17 style='width:13pt'></td>
              <td class=xl1527937 width=177 style='width:133pt'></td>
              <td class=xl1527937 width=18 style='width:14pt'></td>
             </tr>
             <tr height=22 style='height:16.5pt'>
              <td height=22 class=xl1527937 style='height:16.5pt'></td>
              <td colspan=7 class=xl7627937 style='border-right:1.0pt solid black'>WITNESS
              STATEMENT</td>
              <td class=xl1527937></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl1527937 style='height:15.0pt'></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
             </tr>
             <tr>
              <td class=auto-style1 colspan="9" style="text-align:center">
                  <img alt="" src="./images/InsuranceIncidentReportHeader.png" /></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl1527937 style='height:15.0pt'></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
             </tr>
             <tr height=21 style='height:15.75pt'>
              <td height=21 class=xl1527937 style='height:15.75pt'></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl6827937>PCA INCIDENT #</td>
              <td class=xl1527937></td>
              <td class=xl7127937><input type='text' id='IncidentNumber' style='border:none' /></td>
              <td class=xl1527937></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl1527937 style='height:15.0pt'></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl1527937 style='height:15.0pt'></td>
              <td class=xl6827937>WITNESS NAME<span style='mso-spacerun:yes'> </span></td>
              <td class=xl1527937></td>
              <td colspan=3 class=xl7927937><select id='WitnessName' style='border:none'></select></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl1527937 style='height:15.0pt'></td>
              <td class=xl6827937>STREET ADDRESS</td>
              <td class=xl1527937></td>
              <td colspan=3 class=xl7927937><input type='text' id='WitnessAddress' style='border:none' /></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl1527937 style='height:15.0pt'></td>
              <td class=xl6827937>CITY</td>
              <td class=xl1527937></td>
              <td class=xl6727937 style='border-top:none'><input type='text' id='WitnessCity' style='border:none' /></td>
              <td class=xl1527937></td>
              <td class=xl6827937>STATE</td>
              <td class=xl1527937></td>
              <td class=xl6727937><select id='WitnessState' style='border:none''></select></td>
              <td class=xl1527937></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl1527937 style='height:15.0pt'></td>
              <td class=xl6827937>ZIP CODE</td>
              <td class=xl1527937></td>
              <td class=xl7427937><input type='text' id='WitnessZip' style='border:none' /></td>
              <td class=xl7527937></td>
              <td class=xl6827937>DATE OF INCIDENT</td>
              <td class=xl1527937></td>
              <td class=xl6727937 style='border-top:none'><input type='text' id='IncidentDate' style='border:none' /></td>
              <td class=xl1527937></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl1527937 style='height:15.0pt'></td>
              <td class=xl6827937>PHONE</td>
              <td class=xl1527937></td>
              <td class=xl7227937><input type='text' id='WitnessPhone' style='border:none' /></td>
              <td class=xl1527937></td>
              <td class=xl6827937>LOCATION OF INCIDENT</td>
              <td class=xl1527937></td>
              <td class=xl6727937 style='border-top:none'><select  id='IncidentLocation' style='border:none'></select></td>
              <td class=xl1527937></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl1527937 style='height:15.0pt'></td>
              <td class=xl6827937>PASSENGER</td>
              <td class=xl1527937></td>
              <td class=xl6727937 style='border-top:none'><input name='Passenger' type='radio' value='1' style='width:25px' />Yes<input name='Passenger' type='radio' value='0' style='width:25px' />No</td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl1527937 style='height:15.0pt'></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl1527937 style='height:15.0pt'></td>
              <td class=xl6827937 colspan=3>DESCRIPTION OF INCIDENT, DAMAGE AND/OR INJURY:</td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
             </tr>
             <tr height=87 style='mso-height-source:userset;height:65.25pt'>
              <td height=87 class=xl1527937 style='height:65.25pt'></td>
              <td colspan=7 class=xl8127937 width=764 style='width:575pt'>
                  <textarea id="IncidentDesc" class="auto-style1" cols="20" name="S1" style="border:none"></textarea></td>
              <td class=xl1527937></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl1527937 style='height:15.0pt'></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl1527937 style='height:15.0pt'></td>
              <td colspan=3 class=xl8027937><input type='text' id='WitnessSignature' style='border:none' /></td>
              <td class=xl1527937></td>
              <td class=xl6927937><input type='text' id='SignatureDate' style='border:none' /></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl1527937 style='height:15.0pt'></td>
              <td class=xl6827937>Witness Signature</td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl6827937>Date</td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl1527937 style='height:15.0pt'></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl1527937 style='height:15.0pt'></td>
              <td class=xl1527937><input id="Save" type="button" value="Save" style="height:26px;background-color:black;color:white;font-weight:bold" /></td>
              <td class=xl1527937></td>
              <td class=xl1527937><input id="saveContinue" type="button" value="Save & Submit" style="height:26px;background-color:black;color:white;font-weight:bold" /></td>
              <td class=xl1527937></td>
              <td class=xl1527937><input id="printReport" type="button" value="Print Report" style="background-color:black;color:white;font-weight:bold" /></td>
              <td class=xl1527937></td>
              <td class=xl7327937>PAGE 5 OF 5</td>
              <td class=xl1527937></td>
             </tr>
             <tr height=20 style='height:15.0pt'>
              <td height=20 class=xl1527937 style='height:15.0pt'></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937><span style='mso-spacerun:yes'> </span></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
              <td class=xl1527937></td>
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

