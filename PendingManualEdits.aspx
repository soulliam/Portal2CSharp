﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="PendingManualEdits.aspx.cs" Inherits="PendingManualEdits" %>

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
        // ============= Initialize Page ==================== Begin
        var loading = true;

        $(document).ready(function () {

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
                var ProcessList = "BA1B0B96-30D3-45AB-815D-3527F72B6442";
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
                        error: function (jqXHR, textStatus, errorThrown, data) {
                            alert(textStatus); alert(errorThrown);
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
                        error: function (jqXHR, textStatus, errorThrown, data) {
                            alert(textStatus); alert(errorThrown);
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
                    columns: [
                          { text: 'ManualEditId', datafield: 'ManualEditId', hidden: true },
                          { text: 'FPNumber', datafield: 'FPNumber' },
                          { text: 'Full Name', datafield: 'FullName' },
                          { text: 'Points', datafield: 'Points' },
                          { text: 'DateOfRequest', datafield: 'DateOfRequest' },
                          { text: 'Certificate #', datafield: 'CertificateNumber' },
                          { text: 'Explanation', datafield: 'Explanation' }
                    ]
                });


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
                    { name: 'FullName' },
                    { name: 'Points' },
                    { name: 'DateOfRequest' },
                    { name: 'CertificateNumber' },
                    { name: 'Explanation' }
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
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                columns: [
                        { text: 'ManualEditId', datafield: 'ManualEditId', hidden: true },
                        { text: 'Full Name', datafield: 'FullName' },
                        { text: 'Points', datafield: 'Points' },
                        { text: 'DateOfRequest', datafield: 'DateOfRequest' },
                        { text: 'Certificate #', datafield: 'CertificateNumber' },
                        { text: 'Explanation', datafield: 'Explanation' }
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
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-3 col-sm-offset-9">
                            <div class="row search-size">
                                <div class="col-sm-8 col-sm-offset-4">
                                    <div class="row search-size">
                                        <div class="col-sm-12">
                                            <div id="LocationCombo" style="width:250px;"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
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

    <div id="actionButtons"><input id="btnSubmit" value="Submit" type="button" style="margin-top:15px;" /><input id="btnDelete" value="Delete" type="button" style="margin-left:75px; margin-top:15px;" /></div>

    

</asp:Content>

