<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceIncidentList.aspx.cs" Inherits="InsuranceClaims" %>

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
    <script type="text/javascript" src="jqwidgets/jqxnumberinput.js"></script>

    <style>
        .search1 { grid-area: search1; }
        .search2 { grid-area: search2; }
        .search3 { grid-area: search3; }
        .search4 { grid-area: search4; }
        .search5 { grid-area: search5; }
        .search6 { grid-area: search6; }
        .search7 { grid-area: search7; }
        .search8 { grid-area: search8; }
        .search9 { grid-area: search9; }
        .search10 { grid-area: search10; }
        .search11 { grid-area: search11; }
        .search12 { grid-area: search12; }
        .search13 { grid-area: search13; }
        .search14 { grid-area: search14; }
        .search15 { grid-area: search15; }
        .search16 { grid-area: search16; }
        .search17 { grid-area: search17; }
        .search18 { grid-area: search18; }
        .search19 { grid-area: search19; }
        .search20 { grid-area: search20; }
        .search21 { grid-area: search21; }
        .search22 { grid-area: search22; }
        .search23 { grid-area: search23; }
        .search24 { grid-area: search24; }
        .search25 { grid-area: search25; }
        .search26 { grid-area: search26; }
        .search27 { grid-area: search27; }
        .search28 { grid-area: search28; }

        .main { grid-area: main; }
        
        .grid-container {
          display: grid;
          grid-template-areas:
            'search1 search2 search3 search4 search5 search6 search7'
            'search8 search9 search10 search11 search12 search13 search14'
            'search15 search16 search17 search18 search19 search20 search21'
            'search22 search23 search24 search25 search26 search27 search28'
            'main main main main main main main';
          grid-gap: 4px;
          padding: 4px;
          margin:20px;
        }

        .grid-container > div {
          text-align: center;
          padding: 2px 0;
        }

        .search {
            height:140px;
        }

        .main {
            height:100%;
            margin-top:40px;
        }

        incidentClass
        {
            background-color: lightblue;
        }

    </style>

    <script>
        window.setInterval("keepMeAlive('keepAliveIMG')", 100000);
        var group = '<%= Session["groupList"] %>';

        $(window).focus(function () {
            loadGrid(false);
        });

        $('document').ready(function () {
            $("#Search").jqxButton();
            $("#ClearSearch").jqxButton();
            $("#newIncident").jqxButton();

            $("#Search").on("click", function () {
                loadGrid(true);
            });

            $("#ClearSearch").on("click", function () {
                location.reload();
            });

            $("#newIncident").on("click", function () {
                //window.location.href = './InsuranceIncidentReport.aspx'
                window.open('./InsuranceIncidentReport.aspx', '_blank');
            });

            loadClaimStatus();
            loadLocations();
            loadLocations();

            const params = new URLSearchParams(window.location.search);
            var IncidentNumber = params.get("IncidentNumber");
            $("#SearchIncidentNumber").val(IncidentNumber);

            if (IncidentNumber == "" || IncidentNumber == null) {
                loadGrid(false);
            } else {
                loadGrid(true);
            }
            

            Security();
        });

        function loadGrid(search) {
            var locationString = $("#userVehicleLocation").val();

            if (group.indexOf("InsApp_Regional") > -1 || group.indexOf("InsApp_Facility") > -1 || group.indexOf("Portal_Insurance") > -1) {
                var viewSettings = locationString;
            } else {
                var viewSettings = locationString + "~" + $("#txtLoggedinUsername").val();
                viewSettings = viewSettings.replace('PCA\\', '');
            }

            var parent = $("#jqxgrid").parent();
            $("#jqxgrid").jqxGrid('destroy');
            $("<div id='jqxgrid'></div>").appendTo(parent);

            if (search != true) {
                var url = $("#localApiDomain").val() + "InsuranceIncidents/GetIncidentList/" + viewSettings;
                //var url = "http://localhost:52839/api/InsuranceIncidents/GetIncidentList/" + viewSettings;

                var data = "";
                var type = "Get";
            } else {
                var url = $("#localApiDomain").val() + "InsuranceIncidents/SearchIncidentList/" ;
                //var url = "http://localhost:52839/api/InsuranceIncidents/SearchIncidentList/";

                var data = {
                    "IncidentNumber": $("#SearchIncidentNumber").val(),
                    "ClaimNumber": $("#SearchClaimNumber").val(),
                    "WCClaimNumber": $("#SearchWCClaimNumber").val(),
                    "IncidentDate": $("#SearchDateOfIncident").val(),
                    "IncidentStatus": $("#SearchIncidentStatus").val(),
                    "ClaimStatusID": $("#SearchClaimStatus").val(),
                    "LocationId": $("#SearchIncidentLocation").val(),
                    "ClaimantName": $("#SearchClaimantname").val(),
                    "PCAInsuranceClaimNumber": $("#SearchInsClaimNumber").val(),
                    "Closed": $("#SearchClaimClosed").val(),
                    "viewSettings":viewSettings
                };
                var type = "Post";
            }
            

            var source =
            {
                datafields: [
                    { name: 'IncidentID' },
                    { name: 'IncidentNumber' },
                    { name: 'ClaimNumber' },
                    { name: 'WCClaimNumber' },
                    { name: 'WCInvestigationID' },
                    { name: 'ClaimID' },
                    { name: 'IncidentDate' },
                    { name: 'IncidentStatus' },
                    { name: 'ClaimStatusDesc' },
                    { name: 'LocationName' },
                    { name: 'ClaimantName' },
                    { name: 'PCAInsuranceClaimNumber' },
                    { name: 'Documents' },
                    { name: 'Checklist' },
                    { name: 'Closed' }
                ],

                type: type,
                datatype: "json",
                data: data,
                url: url,
            };

            var ClaimLinkRenderer = function (row, column, value) {
                var data = $('#jqxgrid').jqxGrid('getrowdata', row);

                html = "<div style='margin-top:9px'><a href='./InsuranceClaim.aspx?ClaimID=" + data.ClaimID + "' target='_blank'>" + data.ClaimNumber + "</a></div>"

                return html;
            }

            var WCLinkRenderer = function (row, column, value) {
                var data = $('#jqxgrid').jqxGrid('getrowdata', row);
                var html = '';

                if (data.WCInvestigationID != 0) {
                    html = "<div style='margin-top:9px'><a href='./InsuranceWCClaim.aspx?WCInvestigationID=" + data.WCInvestigationID + "' target='_blank'>" + data.WCClaimNumber + "</a></div>"
                }


                return html;
            }

            var DocUploadRenderer = function (row, column, value) {
                var data = $('#jqxgrid').jqxGrid('getrowdata', row);
                var html = '';
                var WCClaimNumber = [];

                if (data.WCClaimNumber == null) {
                    WCClaimNumber.push('0');
                } else {
                    WCClaimNumber = data.WCClaimNumber.split('-');
                }

                html = "<div style='margin-top:9px'><a href='./InsuranceFileUploadDownload.aspx?IncidentNumber=PCA " + data.IncidentNumber + "&WCNumber=WC " + WCClaimNumber[0] + "' target='_blank'>Upload Docs</a></div>"

                return html;
            }

            var cellclassname = function (row, column, value, data) {
                datarow = row;
                var dataRecord = $("#jqxgrid").jqxGrid('getrowdata', datarow);

                if (FirstColorRowCount == true) {
                    FirstColorRowCount = false;
                    return "incidentClass";
                }
            };

            var UploadCount = '';
            var FirstRowCount = '';
            var FirstColorRowCount = true;
            var AddClaimcount = '';

            $("#jqxgrid").jqxGrid(
                {
                    width: '100%',
                    height: 500,
                    source: source,
                    //selectionmode: 'checkbox',
                    rowsheight: 35,
                    sortable: true,
                    //altrows: true,
                    filterable: true,
                    columnsresize: true,
                    columns: [
                          { text: 'IncidentID', datafield: 'IncidentID', hidden: true },
                          {
                              text: 'Incident Number',
                              cellsrenderer: function (row, column, value) {
                                  datarow = row;
                                  var dataRecord = $("#jqxgrid").jqxGrid('getrowdata', datarow);

                                  if (dataRecord.IncidentNumber != FirstRowCount) {
                                      html = "<div style='margin-top:9px'><a href='./InsuranceIncidentReport.aspx?IncidentID=" + dataRecord.IncidentID + "' target='_blank'>" + dataRecord.IncidentNumber + "</a></div>"
                                      return html;
                                  }
                              }, cellclassname: cellclassname
                          },
                          { text: 'Claims #', datafield: 'ClaimNumber', cellsrenderer: ClaimLinkRenderer, cellclassname: cellclassname },
                          { text: 'WC Claim', datafield: 'WCClaimNumber', cellsrenderer: WCLinkRenderer, cellclassname: cellclassname },
                          { text: 'WCInvestigationID', datafield: 'WCInvestigationID', hidden: true },
                          { text: 'ClaimID', datafield: 'ClaimID', hidden: true },
                          { text: 'Date of Incident', datafield: 'IncidentDate', cellsrenderer: DateRender, cellclassname: cellclassname },
                          {
                              text: 'Incident Status',
                              cellsrenderer: function (row, column, value) {
                                  datarow = row;
                                  var dataRecord = $("#jqxgrid").jqxGrid('getrowdata', datarow);

                                  if (dataRecord.IncidentNumber != FirstRowCount) {
                                      return "<div style='margin-top:9px'>" + dataRecord.IncidentStatus + "</div>";
                                  }
                              }, cellclassname: cellclassname
                          },
                          { text: 'Claim Status', datafield: 'ClaimStatusDesc', cellclassname: cellclassname },
                          { text: 'Location', datafield: 'LocationName', cellclassname: cellclassname },
                          { text: 'Claimant Name', datafield: 'ClaimantName', cellclassname: cellclassname },
                          { text: 'Ins Claim #', datafield: 'PCAInsuranceClaimNumber', cellclassname: cellclassname },
                          { text: 'Upload Docs', cellsrenderer: DocUploadRenderer },
                          {
                              text: 'Check List',
                              cellsrenderer: function (row, column, value) {
                                  datarow = row;
                                  var dataRecord = $("#jqxgrid").jqxGrid('getrowdata', datarow);

                                  if (dataRecord.IncidentNumber != FirstRowCount) {
                                      FirstRowCount = dataRecord.IncidentNumber;
                                      return "<div style='margin-top:9px'><a href='./InsuranceIncidentChecklist.aspx?IncidentID=" + dataRecord.IncidentID + "' target='_blank'>Check List</a></div>";
                                  }
                              }, cellclassname: cellclassname
                          },
                          { text: 'Closed', datafield: 'Closed', cellclassname: cellclassname }
                    ]
                });
        }

        function LoadLocationPopup(thisLocationString) {

            var url = $("#localApiDomain").val() + "InsuranceLocations/GetUserLocations/" + thisLocationString;
            //var url = "http://localhost:52839/api/InsuranceLocations/GetUserLocations/" + thisLocationString;

            //set up the location combobox
            var locationSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'LocationName' },
                    { name: 'LocationID' }
                ],
                url: url

            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#LocationCombo").jqxDropDownList(
            {
                width: 300,
                height: 50,
                itemHeight: 50,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "LocationName",
                valueMember: "LocationID"
            });
        }

        function loadClaimStatus() {
            var dropdown = $('#SearchClaimStatus');

            dropdown.empty();

            dropdown.append('<option selected="true" value="0">Claim Status</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/InsuranceClaims/GetClaimStatuses/";
            var url = $("#localApiDomain").val() + "InsuranceClaims/GetClaimStatuses/";

            return $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append($("<option style='font-weight: bold;'></option>").prop("value", data[i].ClaimStatusID).text(data[i].ClaimStatusDesc));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting claim status information.");
                }
            });
        }

        function loadLocations() {
            var locationString = $("#userVehicleLocation").val();
            var dropdown = $('#SearchIncidentLocation');

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
                        dropdown.append("<option value='" + data[i].LocationID + "' style='font-weight: bold;'>" + data[i].LocationName + "</option>");
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting location information.");
                }
            });
        }

        
    </script>
    <img id="keepAliveIMG" width="1" height="1" src="./images/FastPark.png?" style="display:none" />
    <input type="text" id="InsuranceLocation" style="display:none" />

    <div class="grid-container">        
        <div class="search1"><span style="color:white;font-size:large">Incident Number</span></div>
        <div class="search2"><span style="color:white;font-size:large">WC Claim Number</span></div>
        <div class="search3"><span style="color:white;font-size:large">Date of Incident</span></div>
        <div class="search4"><span style="color:white;font-size:large">Incident Status</span></div>
        <div class="search5"><span style="color:white;font-size:large">Claim Status</span></div>
        <div class="search15"><span style="color:white;font-size:large">Location</span></div>
        <div class="search16"><span style="color:white;font-size:large">Claimant Name</span></div>
        <div class="search17"><span style="color:white;font-size:large">Insurance Claim Number</span></div>
        <div class="search18"><span style="color:white;font-size:large">Closed</span></div>
        <div class="search19"></div>
        <div class="search20"></div>

        <div class="search14"><input type="button" id="Search" value="Search" /></div>
        <div class="search21"><input id="newIncident" type="button" value="New Incident" /></div>
        <div class="search28"><input type="button" id="ClearSearch" value="Clear" /></div>

        <div class="search8"><input type="text" id="SearchIncidentNumber" /></div>
        <div class="search9"><input type="text" id="SearchWCClaimNumber" /></div>
        <div class="search10"><input type="date" id="SearchDateOfIncident" /></div>
        <div class="search11"><input type="text" id="SearchIncidentStatus" /></div>
        <div class="search12"><select id="SearchClaimStatus" style="font-size:larger"></select></div>
        <div class="search22"><select id="SearchIncidentLocation" style="font-size:larger"></select></div>
        <div class="search23"><input type="text" id="SearchClaimantname" /></div>
        <div class="search24"><input type="text" id="SearchInsClaimNumber" /></div>
        <div class="search25">
            <select id="SearchClaimClosed" style="font-size:larger">
                <option value=""></option>
                <option value="0">No</option>
                <option value="1">Yes</option>
            </select>
        </div>


        <div class="main">
            <div id="jqxgrid"></div>
        </div>  
    </div>
    
    
</asp:Content>


