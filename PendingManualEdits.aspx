<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="PendingManualEdits.aspx.cs" Inherits="PendingManualEdits" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <link rel="stylesheet" href="jqwidgets/styles/jqx.base.css" type="text/css" />
    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>

    <script type="text/javascript" src="jqwidgets/globalization/globalize.js"></script>

    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>

    
    <script type="text/javascript" src="jqwidgets/jqxgrid.js"></script>    
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
    <script type="text/javascript" src="jqwidgets/jqxmaskedinput.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>    
    <script type="text/javascript" src="jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>

    <script type="text/javascript">
        var group = '<%= Session["groupList"] %>';

        // ============= Initialize Page ==================== Begin
        var loading = true;

        $(document).ready(function () {

            $("#btnSubmit").jqxButton();
            $("#btnDelete").jqxButton();

            loadLocationCombo();

            $("#LocationCombo").on('bindingComplete', function (event) {
                $("#LocationCombo").jqxComboBox('insertAt', 'Pick a Location', 0);
                $("#LocationCombo").on('change', function (event) {
                    loadGrid();
                });
            });

            $("#jqxgrid").bind('cellendedit', function (event) {
                if (event.args.value) {
                    $("#jqxgrid").jqxGrid('selectrow', event.args.rowindex);
                }
                else {
                    $("#jqxgrid").jqxGrid('unselectrow', event.args.rowindex);
                }
            });

            
            $("#btnSubmit").on('click', function () {
                //var ProcessList = $("#tempUserGuid").val();
                
                var ProcessList = $("#txtLoggedinUsername").val();

                var getselectedrowindexes = $('#jqxgrid').jqxGrid('getselectedrowindexes');

                if (getselectedrowindexes.length > 0) {
                    for (var index = 0; index < getselectedrowindexes.length; index++) {
                        var selectedRowData = $('#jqxgrid').jqxGrid('getrowdata', getselectedrowindexes[index]);

                        ProcessList = ProcessList + "," + selectedRowData.ManualEditID;

                    }


                    var processingList = {
                        "ProcessList": ProcessList 
                    };
                    
                    var jsonText = JSON.stringify(processingList);

                    $.ajax({
                        url: $("#localApiDomain").val() + "ProcessPendingManualEditsController/SubmitManualEdits",
                        //url: "http://localhost:52839/api/ProcessPendingManualEditsController/SubmitManualEdits",
                        type: 'POST',
                        data: processingList,
                        success: function (response) {
                            alert("Saved!");
                            loadGrid();
                        },
                        error: function (request, status, error) {
                            alert(error);
                        }
                    });
                }
            });

            $("#btnDelete").on('click', function () {
                var ProcessList = "";
                var first = true;
                var getselectedrowindexes = $('#jqxgrid').jqxGrid('getselectedrowindexes');
                if (getselectedrowindexes.length > 0) {
                    for (var index = 0; index < getselectedrowindexes.length; index++) {
                        var selectedRowData = $('#jqxgrid').jqxGrid('getrowdata', getselectedrowindexes[index]);
                        if (first == true) {
                            ProcessList = ProcessList + selectedRowData.ManualEditID;
                            first = false;
                        }
                        else {
                            ProcessList = ProcessList + "," + selectedRowData.ManualEditID;
                        }
                    }


                    var processingList = {
                        "ProcessList": ProcessList
                    };

                    var jsonText = JSON.stringify(processingList);

                    $.ajax({
                        url: $("#localApiDomain").val() + "ProcessPendingManualEditsController/DeleteManualEdits",
                        type: 'POST',
                        data: processingList,
                        success: function (response) {
                            alert("Deleted!");
                            loadGrid();
                        },
                        error: function (request, status, error) {
                            alert(error);
                        }
                    });
                }
            });

            //Place holder grid
            var data = new Array();

            var source =
            {
                localdata: data,
                datatype: "array"
            };

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
                          { text: 'ManualEditId', datafield: 'ManualEditId', hidden: true },
                          { text: 'FPNumber', datafield: 'FPNumber', width: '10%' },
                          { text: 'Full Name', datafield: 'FullName', width: '15%' },
                          { text: 'Points', datafield: 'Points', width: '5%' },
                          { text: 'DateOfRequest', datafield: 'DateOfRequest', width: '6%', cellsrenderer: DateRender },
                          { text: 'Certificate #', datafield: 'CertificateNumber', width: '10%' },
                          { text: 'Notes', datafield: 'Notes', width: '34%' },
                          { text: 'Explanation', datafield: 'Explanation', width: '10%' },
                          { text: 'Submitted By', datafield: 'UpdateExternalUserData', width: '10%' }
                    ]
                });



            Security();

        });
        // ============= Initialize Page ================== End

        //loads main airport grid
        function loadGrid() {

            var parent = $("#jqxgrid").parent();
            $("#jqxgrid").jqxGrid('destroy');
            $("<div id='jqxgrid'></div>").appendTo(parent);

            var thisLocationID = $('#LocationCombo').jqxComboBox('getSelectedItem').value;

            var url = $("#localApiDomain").val() + "PendingManualEdits/PendingManualEditsByLocation/" + thisLocationID;
            //var url = "http://localhost:52839/api/PendingManualEdits/PendingManualEditsByLocation/" + thisLocationID;

            var source =
            {
                datafields: [
                    { name: 'ManualEditID' },
                    { name: 'FPNumber' },
                    { name: 'FullName' },
                    { name: 'Points' },
                    { name: 'DateOfRequest' },
                    { name: 'CertificateNumber' },
                    { name: 'Notes' },
                    { name: 'Explanation' },
                    { name: 'UpdateExternalUserData' }
                ],

                id: 'ManualEditId',
                type: 'Get',
                datatype: "json",
                url: url,
            };

            // creage jqxgrid
            $("#jqxgrid").jqxGrid(
            {
                width: '100%',
                height: 500,
                source: source,
                selectionmode: 'checkbox',
                autorowheight: true,
		rowsheight: 35,
		pageable: true,
                sortable: true,
                altrows: true,
                filterable: true,
                columnsresize: true,
                columns: [
                          { text: 'ManualEditId', datafield: 'ManualEditId', hidden: true },
                          { text: 'FPNumber', datafield: 'FPNumber', width: '10%' },
                          { text: 'Full Name', datafield: 'FullName', width: '15%' },
                          { text: 'Points', datafield: 'Points', width: '5%' },
                          { text: 'DateOfRequest', datafield: 'DateOfRequest', width: '6%', cellsrenderer: DateRender },
                          { text: 'Certificate #', datafield: 'CertificateNumber', width: '10%' },
                          { text: 'Notes', datafield: 'Notes', width: '34%' },
                          { text: 'Explanation', datafield: 'Explanation', width: '10%' },
                          { text: 'Submitted By', datafield: 'UpdateExternalUserData', width: '10%' }
                ]
            });
        }

        function loadLocationCombo() {
            //set up the location combobox
            var locationSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'NameOfLocation' },
                    { name: 'LocationId' }
                ],
                loadComplete: function () {
                    thisLocationId = getUrlParameter('location');
                    $("#LocationCombo").jqxComboBox('selectItem', thisLocationId);
                },
                url: $("#localApiDomain").val() + "Locations/Locations/",

            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#LocationCombo").jqxComboBox(
            {
                theme: 'shinyblack',
                width: '100%',
                height: 24,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });
        }

    </script>
    
    <div id="Locations" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-2">
                    <div id="LocationCombo" style="width:250px;"></div>
                </div>
                <div class="col-sm-2">
                </div>
                <div class="col-sm-2">
                </div>
                <div class="col-sm-2">
                </div>
            </div>
        </div>
    </div><!-- /.container-fluid -->
    
    <div style="display:none;">
        <input id="LocationId" type="text" value="0"  />
    </div>

    <div class="container-fluid container-970">
        <div class="row ">
            <div class="col-sm-12">
                <div id="jqxgrid"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->

    <div id="actionButtons">
        <input id="btnSubmit" value="Submit" type="button" style="margin-left:50px;margin-top:15px;width:200px;" />
        <input id="btnDelete" value="Delete" type="button" style="margin-right:50px; margin-top:15px;width:200px;float:right;" />
    </div>

    

</asp:Content>

