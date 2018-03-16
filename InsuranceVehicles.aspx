<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceVehicles.aspx.cs" Inherits="InsuranceVehicles" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <link rel="stylesheet" href="/jqwidgets/styles/jqx.base.css" type="text/css" />


    <script type="text/javascript" src="scripts/Member/UpdateMember.js"></script>
    <script type="text/javascript" src="scripts/Member/MemberReservation.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.js"></script>
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
    <script type="text/javascript" src="jqwidgets/jqxgrid.selection.js"></script> c
    <script type="text/javascript" src="jqwidgets/jqxgrid.sort.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>    
    <script type="text/javascript" src="jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxtabs.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxloader.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxradiobutton.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.edit.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdropdownbutton.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdata.export.js"></script> 
    <script type="text/javascript" src="jqwidgets/jqxgrid.export.js"></script> 

    <script type="text/javascript">
        var calendarChanged = false;
        var group = '<%= Session["groupList"] %>';
        var gblCheckedItems = "";
        var updateRows = [];

        $(document).ready(function () {
            $("#btnSearch").jqxButton({ width: 120, height: 30 });
            $("#export").jqxButton({ width: 120, height: 30 });
            $("#selectAll").jqxButton({ width: 120, height: 30 });
            $("#unSelectAll").jqxButton({ width: 120, height: 30 });
            $("#update").jqxButton({ width: 120, height: 30 });

            $("#btnSearch").on("click", function (event) {
                loadSearchResults(gblCheckedItems);
            });

            $("#export").on("click", function (event) {
                $("#jqxSearchGrid").jqxGrid('exportdata', 'xls', 'jqxGrid');
            });

            $("#unSelectAll").on("click", function (event) {
                $("#LocationCombo").jqxDropDownList('uncheckAll');
            });

            $("#selectAll").on("click", function (event) {
                $("#LocationCombo").jqxDropDownList('checkAll');
            });

            $("#update").on("click", function (event) {
                saveChanges();
            });

            LoadLocation();

            $("#LocationCombo").bind('checkChange', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {
                        var valueelement = $("<div></div>");
                        valueelement.html("Value: " + item.value);
                        var labelelement = $("<div></div>");
                        labelelement.html("Label: " + item.label);
                        var checkedelement = $("<div></div>");
                        checkedelement.html("Checked: " + item.checked);
                        $("#selectionlog").children().remove();
                        $("#selectionlog").append(labelelement);
                        $("#selectionlog").append(valueelement);
                        $("#selectionlog").append(checkedelement);
                        var items = $("#LocationCombo").jqxDropDownList('getCheckedItems');
                        var checkedItems = "";
                        var first = true;
                        $.each(items, function (index) {
                            if (first == true) {
                                checkedItems = this.value;
                                first = false;
                            } else {
                                checkedItems = checkedItems + "_" + this.value;
                            }
                        });
                        $("#checkedItemsLog").text(checkedItems);
                        gblCheckedItems = checkedItems;
                    }
                }
            });

            Security();
        });

        function LoadLocation() {
            var url = $("#localApiDomain").val() + "Vehicles/GetLocations/";
            //var url = "http://localhost:52839/api/Vehicles/GetLocations/";

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
                url: url
            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#LocationCombo").jqxDropDownList(
            {
                checkboxes: true,
                itemHeight: 50,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });
        }

        function loadSearchResults(Locations) {

            var parent = $("#jqxSearchGrid").parent();
            $("#jqxSearchGrid").jqxGrid('destroy');
            $("<div id='jqxSearchGrid'></div>").appendTo(parent);

            var coverageSource =
             {
                 datatype: "json",
                 datafields: [
                     { name: 'VehicleCoverageId' },
                     { name: 'VehicleCoveragename' }
                 ],
                 url: $("#localApiDomain").val() + "InsuranceVehicles/GetCoverageTypes/",
                 //url: "http://localhost:52839/api/InsuranceVehicles/GetCoverageTypes/"
             };

            var coverageAdapter = new $.jqx.dataAdapter(coverageSource, {
                autoBind: true
            });

            var insuranceValues = [
                { value: "1", label: "Active" },
                { value: "0", label: "In-Active" }
            ];

            var insuranceSource =
            {
                datatype: "array",
                datafields: [
                    { name: 'label', type: 'string' },
                    { name: 'value', type: 'string' }
                ],
                localdata: insuranceValues
            };

            var insuranceValuesAdapter = new $.jqx.dataAdapter(insuranceSource, {
                autoBind: true
            });

            var url = $("#localApiDomain").val() + "InsuranceVehicles/GetVehiclesByLocation/" + Locations;
            //var url = "http://localhost:52839/api/InsuranceVehicles/GetVehiclesByLocation/" + Locations;
            
            var source =
            {
                datafields: [
                    { name: 'VehicleId' },
                    { name: 'VehicleNumber', type: 'string' },
                    { name: 'StatusDescription' },
                    { name: 'Year' },
                    { name: 'MakeName' },
                    { name: 'ModelName' },
                    { name: 'VINNumber' },
                    { name: 'Garaged' },
                    { name: 'OriginalCost' },
                    { name: 'Class' },
                    { name: 'Coverage', value: 'CoverageCode', values: { source: coverageAdapter.records, value: 'VehicleCoverageId', name: 'VehicleCoveragename' } },
                    { name: 'CoverageCode' },
                    { name: 'DriverName' },
                    { name: 'AddDate', type: 'date' },
                    { name: 'DeleteDate', type: 'date' },
                    { name: 'Insurance', value: 'InsuranceCode', values: { source: insuranceValuesAdapter.records, value: 'value', name: 'label' } },
                    { name: 'InsuranceCode' }
                ],
                type: 'GET',
                datatype: "json",
                url: url
            };

            // create Searchlist Grid
            $("#jqxSearchGrid").jqxGrid(
            {
                width: '100%',
                height: 700,
                source: source,
                columnsresize: true,
                sortable: true,
                altrows: true,
                selectionmode: 'singlecell',
                editable: true,
                editmode: 'click',
                filterable: true,
                columns: [
                      { text: 'VehicleId', datafield: 'VehicleId', hidden: true },
                      { text: 'VehicleNumber', datafield: 'VehicleNumber', width: '6%' },
                      { text: 'StatusDescription', datafield: 'StatusDescription', width: '8%' },
                      { text: 'Year', datafield: 'Year', width: '3%' },
                      { text: 'MakeName', datafield: 'MakeName', width: '6%' },
                      { text: 'ModelName', datafield: 'ModelName', width: '6%' },
                      { text: 'VINNumber', datafield: 'VINNumber', width: '14%' },
                      { text: 'Garaged', datafield: 'Garaged', width: '10%' },
                      { text: 'OriginalCost', datafield: 'OriginalCost', width: '5%' },
                      { text: 'Class', datafield: 'Class', width: '5%' },
                      {
                          text: 'Coverage', datafield: 'CoverageCode', displayfield: 'Coverage', width: '5%', columntype: 'dropdownlist',
                          createeditor: function (row, value, editor) {
                              editor.jqxDropDownList({ source: coverageAdapter, displayMember: 'VehicleCoveragename', valueMember: 'VehicleCoverageId', autoDropDownHeight: true });
                          }
                      },
                      { text: 'DriverName', datafield: 'DriverName', width: '6%' },
                      { text: 'AddDate', datafield: 'AddDate', width: '10%', cellsformat: 'MM/dd/yyyy' },
                      { text: 'DeleteDate', datafield: 'DeleteDate', width: '10%', cellsformat: 'MM/dd/yyyy' },
                      {
                          text: 'Insurance', datafield: 'InsuranceCode', displayfield: 'Insurance', width: '6%', columntype: 'dropdownlist',
                          createeditor: function (row, value, editor) {
                              editor.jqxDropDownList({ source: insuranceValuesAdapter, displayMember: 'label', valueMember: 'value', autoDropDownHeight: true });
                          }
                      }
                ]
            });

            $("#jqxSearchGrid").on('cellvaluechanged', function (event) {
                // event arguments.
                var args = event.args;
                // column data field.
                var datafield = event.args.datafield;
                // row's bound index.
                var rowBoundIndex = args.rowindex;
                // new cell value.
                var value = args.newvalue;
                // old cell value.
                var oldvalue = args.oldvalue;


                var arrayLength = updateRows.length;

                if (updateRows.length == 0) {
                    updateRows.push(rowBoundIndex);
                } else {
                    for (var i = 0; i < arrayLength; i++) {
                        if (updateRows.indexOf(rowBoundIndex) == -1) {
                            updateRows.push(rowBoundIndex);
                        }
                    }
                }
            });

        }

        function saveChanges() {

            for (var i = 0; i < updateRows.length; i++) {
                var data = $('#jqxSearchGrid').jqxGrid('getrowdatabyid', updateRows[i]);

                //var url = "http://localhost:52839/api/InsuranceVehicles/UpdateInsuranceVehicleStatus/";
                var url = $("#localApiDomain").val() + "InsuranceVehicles/UpdateInsuranceVehicleStatus/";

                var postData = { 'VehicleId': data["VehicleId"], 'Coverage': data["CoverageCode"], 'Insurance': data["InsuranceCode"] }

                postInsuranceChange(url, postData).done(function (data) {
                    console.log();
                }).fail(function (error) {
                    alert("error " + error);
                });
            }

            loadSearchResults(gblCheckedItems);
        }

        function postInsuranceChange(url, postData) {

            return $.ajax({
                async: true,
                type: "POST",
                data: postData,
                url: url,
                dataType: "json",
                success: function (data) {

                },
                error: function (request, status, error) {
                    alert(error);
                }
            });
        }

    </script>

    <div class="row">
        <div class="col-sm-3">
            <input type="button"  id="export" value="Export" /><input type="button"  id="update" value="Update" />
        </div>
        <div class="col-sm-3">
            <div id="LocationCombo"></div>
        </div>
        <div class="col-sm-3">
            <input type="button"  id="selectAll" value="Select All" /><input type="button"  id="unSelectAll" value="Un-Select All" />
        </div>  
        <div class="col-sm-3">
            <input type="button" id="btnSearch" value="Search" />
        </div> 
    </div>

    <div class="container-fluid container-970">
        <div class="row ">
            <div class="col-sm-12">
                <div id="jqxSearchGrid"></div>
            </div>
        </div>
    </div>
</asp:Content>
