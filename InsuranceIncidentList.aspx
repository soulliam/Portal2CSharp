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
        .search { grid-area: search; }
        .main { grid-area: main; }

        .grid-container {
          display: grid;
          grid-template-areas:
            'search search search search search search'
            'main main main main main main';
          grid-gap: 10px;
          padding: 10px;
        }

        .grid-container > div {
          text-align: center;
          padding: 20px 0;
          font-size: 30px;
        }

        .search {
            height:140px;
        }

        .main {
            height:100%;
        }

    </style>

    <script>
        var group = '<%= Session["groupList"] %>';

        onload = function () {
            onfocus = function () {
                onfocus = function () { }
                location.reload(true)
            }
        }

        $('document').ready(function () {
            
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


            var url = $("#localApiDomain").val() + "InsuranceIncidents/GetIncidentList/" + viewSettings;
            //var url = "http://localhost:52839/api/InsuranceIncidents/GetIncidentList/" + viewSettings;
            
            var source =
            {
                datafields: [
                    { name: 'IncidentID' },
                    { name: 'IncidentNumber' },
                    { name: 'ClaimNumber' },
                    { name: 'ClaimID' },
                    { name: 'WCClaimNumber' },
                    { name: 'WCClaimID' },
                    { name: 'IncidentDate' },
                    { name: 'IncidentStatus' },
                    { name: 'ClaimStatusDesc' },
                    { name: 'LocationName' },
                    { name: 'ClaimantName' },
                    { name: 'PCAInsuranceClaimNumber' },
                    { name: 'Documents' },
                    { name: 'Checklist' }
                ],

                id: 'ManualEditId',
                type: 'Get',
                datatype: "json",
                url: url,
            };

            var IncidentLinkRenderer = function (row, column, value) {
                var data = $('#jqxgrid').jqxGrid('getrowdata', row);

                html = "<a href='./InsuranceIncidentReport.aspx?IncidentID=" + data.IncidentID + "' target='_blank'>" + data.IncidentNumber + "</a>"

                return html;
            }

            var ClaimLinkRenderer = function (row, column, value) {
                var data = $('#jqxgrid').jqxGrid('getrowdata', row);

                html = "<a href='./InsuranceClaim.aspx?ClaimID=" + data.ClaimID + "' target='_blank'>" + data.ClaimNumber + "</a>"

                return html;
            }

            var WCLinkRenderer = function (row, column, value) {
                var data = $('#jqxgrid').jqxGrid('getrowdata', row);
                var html = '';

                if (data.WCClaimID != 0) {
                    html = "<a href='./InsuranceWCClaim.aspx?WCClaimID=" + data.WCClaimID + "' target='_blank'>" + data.WCClaimNumber + "</a>"
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
                
                html = "<a href='./InsuranceFileUploadDownload.aspx?IncidentNumber=PCA " + data.IncidentNumber + "&WCNumber=WC " + WCClaimNumber[0] + "' target='_blank'>Upload Docs</a>"
                
                return html;
            }

            var ChecklistRenderer = function (row, column, value) {
                var data = $('#jqxgrid').jqxGrid('getrowdata', row);
                var html = '';

                html = "<a href='./InsuranceIncidentChecklist.aspx?IncidentID=" + data.IncidentID + "' target='_blank'>Check List</a>"

                return html;
            }

            $("#jqxgrid").jqxGrid(
                {
                    width: '100%',
                    height: 500,
                    source: source,
                    selectionmode: 'checkbox',
                    rowsheight: 35,
                    sortable: true,
                    altrows: true,
                    filterable: true,
                    columnsresize: true,
                    columns: [
                          { text: 'IncidentID', datafield: 'IncidentID', hidden: true },
                          { text: 'Incident Number', datafield: 'IncidentNumber', cellsrenderer: IncidentLinkRenderer },
                          { text: 'Claims #', datafield: 'ClaimNumber', cellsrenderer: ClaimLinkRenderer },
                          { text: 'ClaimID', datafield: 'ClaimID', hidden: true },
                          { text: 'WC Claim', datafield: 'WCClaimNumber', cellsrenderer: WCLinkRenderer },
                          { text: 'WCClaimID', datafield: 'WCClaimID', hidden: true },
                          { text: 'Date of Incident', datafield: 'IncidentDate', cellsrenderer: DateRender },
                          { text: 'Incident Status', datafield: 'IncidentStatus' },
                          { text: 'Claim Status', datafield: 'ClaimStatusDesc' },
                          { text: 'Location', datafield: 'LocationName' },
                          { text: 'Claimant Name', datafield: 'ClaimantName' },
                          { text: 'Ins Claim #', datafield: 'PCAInsuranceClaimNumber' },
                          { text: 'Documents', cellsrenderer: DocUploadRenderer },
                          { text: 'Checklist', cellsrenderer:ChecklistRenderer }
                    ]
                });

            $("#newIncident").on("click", function () {
                //window.location.href = './InsuranceIncidentReport.aspx'
                window.open('./InsuranceIncidentReport.aspx', '_blank');
            });

            Security();
        });

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
    </script>
    <input type="text" id="InsuranceLocation" style="display:none" />

    <div class="grid-container">
        <div class="search">Header</div>
        <div class="main">
            <div id="jqxgrid"></div>
        </div>  
    </div>
    <input id="newIncident" type="button" value="New Incident" style="background-color:black;color:white;font-weight:bold;width:200px;margin-left:10px" />
</asp:Content>


