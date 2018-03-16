<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="VehicleTrackingUpdate.aspx.cs" Inherits="VehicleTrackingUpdate" %>

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

    <style>
        .redCell {
            background-color: lightcoral;
            font-weight: 900;
        }
    </style>

    <script type="text/javascript">
        // ============= Initialize Page ==================== Begin
        var group = '<%= Session["groupList"] %>';
        var updateRows = [];
        var changeBody = "";
        var change = false;

        $(document).ready(function () {

            //#region SetupButtons
            $("#update").jqxButton({ width: '150', height: 26 });
            //#endregion

            var thisUserId = $("#tempUserGuid").val();

            LoadLocationPopup(thisUserId);
            

            $("#popupLocation").css('display', 'block');
            $("#popupLocation").css('visibility', 'hidden');

            var offset = $("#jqxgrid").offset();
            $("#popupLocation").jqxWindow({ position: { x: parseInt(offset.left) + 500, y: parseInt(offset.top) - 40 } });
            $('#popupLocation').jqxWindow({ width: "325px", height: "300px" });
            $('#popupLocation').jqxWindow({ isModal: true, modalOpacity: 0.7 });
            $('#popupLocation').jqxWindow({ showCloseButton: false });
            $("#popupLocation").css("visibility", "visible");
            $("#popupLocation").jqxWindow({ title: 'Pick a Location' });
            $("#popupLocation").jqxWindow('open');

            $("#LocationCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {
                        $("#vehicleLocation").val(item.value);
                        $("#popupLocation").jqxWindow('hide');
                        LoadVehiclesByLocation();
                    }
                }
            });

            $("#LocationVehicles").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {
                        loadGrid(item.value);
                    }
                }
            });

            $("#update").on("click", function (event) {
                saveChanges();
            });

            $("#LocationCombo").on('bindingComplete', function (event) {
                $("#LocationCombo").jqxDropDownList('insertAt', 'Pick a Location', 0);
            });

            $("#LocationVehicles").on('bindingComplete', function (event) {
                $("#LocationVehicles").jqxDropDownList('insertAt', 'Pick a Vehicle', 0);
            });

            Security();
        });

        function LoadVehiclesByLocation() {
            var url = $("#localApiDomain").val() + "Vehicles/GetVehiclesByLocation/" + $("#vehicleLocation").val();
            //var url = "http://localhost:52839/api/Vehicles/GetVehiclesByLocation/" + $("#vehicleLocation").val();

            //set up the location combobox
            var locationSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'VehicleNumber' },
                    { name: 'VehicleId' }
                ],
                url: url

            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#LocationVehicles").jqxDropDownList(
            {
                width: 300,
                height: 50,
                itemHeight: 50,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "VehicleNumber",
                valueMember: "VehicleId"
            });
        }

        function LoadLocationPopup(thisUserId) {
            //var url = $("#localApiDomain").val() + "FleetStatuss/GetLocationsByUserId/" + thisUserId;
            var url = $("#localApiDomain").val() + "FleetStatuss/GetLocationsByUserId/" + "BA1B0B96-30D3-45AB-815D-3527F72B6442";
            //var url = "http://localhost:52839/api/FleetStatuss/GetLocationsByUserId/" + "BA1B0B96-30D3-45AB-815D-3527F72B6442";

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
                width: 300,
                height: 50,
                itemHeight: 50,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });
        }

        function loadGrid(thisVehicleId) {

            var parent = $("#jqxgrid").parent();
            $("#jqxgrid").jqxGrid('destroy');
            $("<div id='jqxgrid'></div>").appendTo(parent);

            var url = $("#localApiDomain").val() + "VehicleTrackings/GetTrackingByLocation/" + thisVehicleId;
            //var url = "http://localhost:52839/api/VehicleTrackings/GetTrackingByLocation/" + thisVehicleId;
           
            var source =
            {
                datafields: [
                    { name: 'VehicleId' },
                    { name: 'VehicleNumber' },
                    { name: 'TrackingDate' },
                    { name: 'StartingMileage' },
                    { name: 'EndingMileage' },
                    { name: 'StartingEngineHours' },
                    { name: 'EndingEngineHours' },
                    { name: 'FuelTotal' },
                    { name: 'FuelPrice' }
                ],
                type: 'Get',
                datatype: "json",
                url: url,
            };


            // create jqxgrid
            $("#jqxgrid").jqxGrid(
            {
                width: '100%',
                height: 700,
                source: source,
                sortable: true,
                altrows: true,
                selectionmode: 'singlecell',
                editable: true,
                editmode: 'click',
                filterable: true,
                columns: [
                      { text: 'VehicleId', datafield: 'VehicleId', hidden: true, },
                      { text: 'VehicleNumber', datafield: 'VehicleNumber', editable: false },
                      {
                          text: 'TrackingDate', datafield: 'TrackingDate', cellsrenderer: DateRender, columntype: 'datetimeinput', cellsformat: 'd', editable: false
                      },
                      { text: 'StartingMileage', datafield: 'StartingMileage' },
                      { text: 'EndingMileage', datafield: 'EndingMileage' },
                      { text: 'StartingEngineHours', datafield: 'StartingEngineHours' },
                      { text: 'EndingEngineHours', datafield: 'EndingEngineHours' },
                      { text: 'FuelTotal', datafield: 'FuelTotal' },
                      { text: 'FuelPrice', datafield: 'FuelPrice' }
                ]
            });

            $("#jqxgrid").on('cellvaluechanged', function (event) {
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


                var data = $('#jqxgrid').jqxGrid('getrowdatabyid', updateRows[i]);

                //var url = "http://localhost:52839/api/VehicleTrackings/UpdateTracking";
                var url = $("#localApiDomain").val() + "VehicleTrackings/UpdateTracking";

                var postData = { 'VehicleId': data["VehicleId"], 'StartingMileage': data["StartingMileage"], 'TrackingDate': data["TrackingDate"], 'StartingMileage': data["StartingMileage"], 'EndingMileage': data["EndingMileage"], 'StartingEngineHours': data["StartingEngineHours"], 'EndingEngineHours': data["EndingEngineHours"], 'FuelTotal': data["FuelTotal"], 'FuelPrice': data["FuelPrice"] }

                postFleetChange(url, postData).done(function (data) {
                    console.log();
                }).fail(function (error) {
                    alert("error " + error);
                });
            }
            
            var item = $("#LocationVehicles").jqxDropDownList('getSelectedItem');

            loadGrid(item.value);
        }

        function postFleetChange(url, postData) {
            
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

    <input type="text" id="vehicleLocation" style="display:none;" />
    <div id="BoothCardCount" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row">
                <div class="col-sm-4">
                    <input type="button" id="update" value="Update Tracking" />
                </div>
                <div class="col-sm-4">
                    
                </div>
                <div class="col-sm-4">
                    <div id="LocationVehicles"></div>
                </div>
            </div>
        </div>
    </div>

    
    <div style="display:none;">
        <input id="LocationId" type="text" value="0"  />
    </div>  
    <div class="row" style="padding:50px">
        <div class="col-sm-12">
            <div id="jqxgrid"></div>
        </div>
    </div>

    <div id="popupLocation" style="display:none">
        <div>
            <div id="LocationCombo" style="float:left;"></div>
        </div>
    </div>
</asp:Content>


