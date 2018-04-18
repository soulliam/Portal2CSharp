<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="FleetStatus.aspx.cs" Inherits="FleetStatus" %>

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

    <style>
        .redCell {
            background-color: lightcoral;
            font-weight: 900;
        }

        .yellowCell {
            background-color: yellow;
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
            var vehicleTypeValues = [
                { value: "1", label: "Bus" },
                { value: "0", label: "Other" }
            ];

            var vehicleTypeSource =
            {
                datatype: "array",
                datafields: [
                    { name: 'label', type: 'string' },
                    { name: 'value', type: 'string' }
                ],
                localdata: vehicleTypeValues
            };

            var vehicleTypeValuesAdapter = new $.jqx.dataAdapter(vehicleTypeSource, {
                autoBind: true
            });

            $("#vehicleType").jqxDropDownList({ source: vehicleTypeValuesAdapter, selectedIndex: 0, width: '200', autoDropDownHeight: true });

            $('#vehicleType').on('change', function (event) {
                loadGrid();
            });

            var locationString = $("#userVehicleLocation").val();
            var locationResult = locationString.split(",");

            if (locationResult.length > 1) {
                var thisLocationString = "";
                for (i = 0; i < locationResult.length; i++) {
                    if (i == locationResult.length - 1) {
                        thisLocationString += locationResult[i];
                    }
                    else {
                        thisLocationString += locationResult[i] + ",";
                    }

                }
                LoadLocationPopup(thisLocationString);
                var offset = $("#jqxgrid").offset();
                $("#popupLocation").jqxWindow({ position: { x: parseInt(offset.left) + 500, y: parseInt(offset.top) - 40 } });
                $('#popupLocation').jqxWindow({ width: "325px", height: "300px" });
                $('#popupLocation').jqxWindow({ isModal: true, modalOpacity: 0.7 });
                $('#popupLocation').jqxWindow({ showCloseButton: false });
                $("#popupLocation").css("visibility", "visible");
                $("#popupLocation").jqxWindow({ title: 'Pick a Location' });
                $("#popupLocation").jqxWindow('open');
            }
            else {
                $("#vehicleLocation").val(locationResult[0]);
                loadGrid($("#distributionLocation").val());
                //loadGrid(9);
            }

            //#region SetupButtons
            $("#newVehicle").jqxButton({ width: '150', height: 26 });
            $("#update").jqxButton({ width: '150', height: 26 });
            $("#sendFleetStatus").jqxButton({ width: '150', height: 26 });
            //#endregion

            $("#sendFleetStatus").on("click", function (event) {
                

                var rows = $('#jqxgrid').jqxGrid('getrows');
                var thisLength = rows.length - 1;

                for (i = 0; i <= thisLength; i++) {
                    if (rows[i].OOSDate != null) {
                        rows[i].OOSDate = DateFormat(rows[i].OOSDate);
                    }
                    if (rows[i].EstReturn != null) {
                        rows[i].EstReturn = DateFormat(rows[i].EstReturn);
                    }
                }
                
                $('#jqxgrid').jqxGrid('exportdata', 'xls', 'FleetStatus', true, rows, false, null, 'utf-8');
               
                openEmail();
            });

            $("#newVehicle").on("click", function (event) {

                //var offset = $("#jqxgrid").offset();
                //$("#popupWindow").jqxWindow({ position: { x: '25%', y: '30%' } });
                //$('#popupWindow').jqxWindow({ resizable: false });
                //$('#popupWindow').jqxWindow({ draggable: true });
                //$('#popupWindow').jqxWindow({ isModal: true });
                //$("#popupWindow").css("visibility", "visible");
                //$('#popupWindow').jqxWindow({ height: '250px', width: '550px' });
                //$('#popupWindow').jqxWindow({ minHeight: '250px', minWidth: '550px' });
                //$('#popupWindow').jqxWindow({ maxHeight: '500px', maxWidth: '550px' });
                //$('#popupWindow').jqxWindow({ showCloseButton: true });
                //$('#popupWindow').jqxWindow({ animationType: 'combined' });
                //$('#popupWindow').jqxWindow({ showAnimationDuration: 300 });
                //$('#popupWindow').jqxWindow({ closeAnimationDuration: 500 });
                //$("#popupWindow").jqxWindow('open');
            });


            $("#LocationCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {
                        $("#vehicleLocation").val(item.value);
                        $("#popupLocation").jqxWindow('hide');
                        LoadAddVehicleCombo();
                        loadGrid();
                    }
                }
            });

            $("#update").on("click", function (event) {
                saveChanges();
            });

            $("#SaveNew").on("click", function (event) {
                $("#popupWindow").jqxWindow('close');
                insertVehicle();
            });

            $("#CancelNew").on("click", function (event) {
                $("#popupWindow").jqxWindow('close');
            });

            $("#LocationCombo").on('bindingComplete', function (event) {
                $("#LocationCombo").jqxDropDownList('insertAt', 'Pick a Location', 0);
            });

            $("#addVehicleCombo").on('bindingComplete', function (event) {
                $("#addVehicleCombo").jqxDropDownList('insertAt', 'Pick a Vehicle', 0);
            });


            Security();
        });

        function openEmail() {
            var addresses = "";
            var first = true;

            //var url = "http://localhost:52839/api/FleetStatuss/GetFleetStatusEmailAddresses/" + $("#vehicleLocation").val();
            var url = $("#localApiDomain").val() + "FleetStatuss/GetFleetStatusEmailAddresses/" + $("#vehicleLocation").val();

            $.ajax({
                async: true,
                type: "GET",
                url: url,
                dataType: "json",
                success: function (data) {
                    for (i = 0; i <= data.length - 1; i++) {
                        if (first == true) {
                            addresses = data[i].ToEmailAddress;
                            first = false;
                        } else {
                            addresses = addresses + ';' + data[i].ToEmailAddress;
                        }
                        
                    }
                    var thisLocation = "mailto:" + addresses + "?subject=Fleet Status&body=Details%20go%20here";

                    var wnd = window.open(thisLocation);
                    setTimeout(function () {
                        wnd.close();
                    }, 1000);
                },
                error: function (request, status, error) {
                    alert(error);
                }
            });

        }

        function LoadAddVehicleCombo() {
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
            $("#addVehicleCombo").jqxDropDownList(
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

        function LoadLocationPopup(thisLocationString) {
            
            var url = $("#localApiDomain").val() + "FleetStatuss/LocationByLocationIds/" + thisLocationString;
            //var url = "http://localhost:52839/api/FleetStatuss/LocationByLocationIds/" + thisLocationString;

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

        function loadGrid() {

            var thisLocationId = $("#vehicleLocation").val();
            $('#jqxgrid').jqxGrid('clear');
            var parent = $("#jqxgrid").parent();
            $("#jqxgrid").jqxGrid('destroy');
            $("<div id='jqxgrid'></div>").appendTo(parent);

            if ($("#vehicleType").jqxDropDownList('getSelectedItem').value == '1') {
                var url = $("#localApiDomain").val() + "FleetStatuss/GetFleetStatusBus/" + thisLocationId;;
                //var url = "http://localhost:52839/api/FleetStatuss/GetFleetStatusBus/" + thisLocationId;
            } else {
                var url = $("#localApiDomain").val() + "FleetStatuss/GetFleetStatusOther/" + thisLocationId;;
                //var url = "http://localhost:52839/api/FleetStatuss/GetFleetStatusOther/" + thisLocationId;
            }

            var source =
            {
                datafields: [
                    { name: 'FleetStatusID' },
                    { name: 'VehicleNumber' },
                    { name: 'VehicleId' },
                    { name: 'FrontACStatus' },
                    { name: 'RearACStatus' },
                    { name: 'LastExWash' },
                    { name: 'LastInExWash' },
                    { name: 'Status' },
                    { name: 'OOSDate' },
                    { name: 'EstReturn' },
                    { name: 'Notes' },
                    { name: 'Change'}
                ],
                type: 'Get',
                datatype: "json",
                url: url,
            };

            var thisCellRenderer = function (row, column, value, data) {
                var lastExDate = new Date();
                var thisToday = new Date();
                var lastExDateDiff = 0;

                switch(column) {
                    case "FrontACStatus":
                        var val = $('#jqxgrid').jqxGrid('getcellvalue', row, "FrontACStatus");
                        if (val == "Issue") {
                            return "redCell";
                        }
                        break;
                    case "RearACStatus":
                        val = $('#jqxgrid').jqxGrid('getcellvalue', row, "RearACStatus");
                        if (val == "Issue") {
                            return "redCell";
                        }
                        break;
                    case "LastExWash":
                        val = $('#jqxgrid').jqxGrid('getcellvalue', row, "LastExWash");
                        lastExDate = new Date(val);
                        thisToday = new Date();
                        lastExDateDiff = thisDateDiff(lastExDate, thisToday);

                        if (lastExDateDiff >= 5 && lastExDateDiff < 7) {
                            return "yellowCell";
                        }

                        if (lastExDateDiff >= 7) {
                            return "redCell";
                        }
                        break;
                    case "LastInExWash":
                        val = $('#jqxgrid').jqxGrid('getcellvalue', row, "LastInExWash");
                        lastInExDate = new Date(val);
                        thisToday = new Date();
                        LastInExDateDiff = thisDateDiff(lastInExDate, thisToday);

                        if (LastInExDateDiff >= 31 && LastInExDateDiff < 35) {
                            return "yellowCell";
                        }

                        if (LastInExDateDiff >= 35) {
                            return "redCell";
                        }
                        break
                    case "Status":
                        val = $('#jqxgrid').jqxGrid('getcellvalue', row, "Status");
                        if (val == "Out of Service") {
                            return "redCell";
                        } 
                        break;
                    default:
                        return val;
                }

            }

            var issueValues = [
                { value: "1", label: "Good" },
                { value: "0", label: "Issue" }
            ];

            var issueSource =
            {
                datatype: "array",
                datafields: [
                    { name: 'label', type: 'string' },
                    { name: 'value', type: 'string' }
                ],
                localdata: issueValues
            };

            var issueValuesAdapter = new $.jqx.dataAdapter(issueSource, {
                autoBind: true
            });

            var statusValues = [
                { value: "1", label: "In Service" },
                { value: "0", label: "Out of Service" }
            ];

            var statusSource =
            {
                datatype: "array",
                datafields: [
                    { name: 'label', type: 'string' },
                    { name: 'value', type: 'string' }
                ],
                localdata: statusValues
            };

            var statusValuesAdapter = new $.jqx.dataAdapter(statusSource, {
                autoBind: true
            });

            // create jqxgrid
            $("#jqxgrid").jqxGrid(
            {
                width: '100%',
                //height: 700,
                autoheight: true,
                source: source,
                sortable: true,
                altrows: true,
                selectionmode: 'singlecell',
                editable: true,
                editmode: 'click',
                filterable: true,
                showaggregates: true,
                showstatusbar: true,
                columns: [
                      { text: 'Change', datafield: 'Change', hidden: true, },
                      { text: 'FleetStatusID', datafield: 'FleetStatusID', hidden: true, },
                      { text: 'VehicleId', datafield: 'VehicleId', hidden: true, },
                      { text: 'VehicleNumber', datafield: 'VehicleNumber', width: '7%' },
                      {
                          text: 'Front AC', datafield: 'FrontACStatus', cellclassname: thisCellRenderer, width: '5%', columntype: 'dropdownlist',
                          createeditor: function (row, value, editor) {
                              editor.jqxDropDownList({ source: issueValuesAdapter, displayMember: 'label', valueMember: 'value', autoDropDownHeight: true });
                          }
                      },
                      {
                          text: 'Rear AC', datafield: 'RearACStatus', cellclassname: thisCellRenderer, width: '5%', columntype: 'dropdownlist',
                          createeditor: function (row, value, editor) {
                              editor.jqxDropDownList({ source: issueValuesAdapter, displayMember: 'label', valueMember: 'value', autoDropDownHeight: true });
                          }
                      },
                      {
                          text: 'Last Ext Wash', datafield: 'LastExWash', cellclassname: thisCellRenderer, cellsrenderer: DateRender, width: '8%', columntype: 'datetimeinput', cellsformat: 'd'
                      },
                      {
                          text: 'Last Int/Ext Wash', datafield: 'LastInExWash', cellclassname: thisCellRenderer, cellsrenderer: DateRender, width: '8%', columntype: 'datetimeinput', cellsformat: 'd',
                          validation: function (cell, value) {
                              $("#jqxgrid").jqxGrid('setcellvalue', cell.row, "LastExWash", value);
                              return true;
                          }
                      },
                      {
                          text: 'Status', datafield: 'Status', cellclassname: thisCellRenderer, width: '6%', columntype: 'dropdownlist',
                          createeditor: function (row, value, editor) {
                              editor.jqxDropDownList({ source: statusValuesAdapter, displayMember: 'label', valueMember: 'value', autoDropDownHeight: true });
                          }, aggregates: [{
                              '':
                                function (aggregatedValue, currentValue, column, record) {
                                    if (currentValue == 'In Service') {
                                        return aggregatedValue + 1;
                                    }
                                    else
                                    {
                                        return aggregatedValue;
                                    }
                                }
                          }]
                      },
                      {
                          text: 'OOS Date', datafield: 'OOSDate', cellsrenderer: DateRender, width: '10%', columntype: 'datetimeinput', cellsformat: 'd',
                          validation: function (cell, value) {
                              if (value == "")
                                  return true;
                              //var year = value.getFullYear();
                              //if (year >= 2020) {
                              //    return { result: false, message: "Date should be before 1/1/2020" };
                              //}
                              return true;
                          }
                      },
                      {
                          text: 'Est Return', datafield: 'EstReturn', cellsrenderer: DateRender, width: '10%', columntype: 'datetimeinput', cellsformat: 'd',
                          validation: function (cell, value) {
                              if (value == "")
                                  return true;
                              //var year = value.getFullYear();
                              //if (year >= 2020) {
                              //    return { result: false, message: "Date should be before 1/1/2020" };
                              //}
                              return true;
                          }
                      },
                      { text: 'Notes', datafield: 'Notes', width: '41%' }
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
                
                if (String(value).indexOf('Jan 01 1900') > -1) {
                    $("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex, datafield, null);
                }

                if (String(value).indexOf('In Service') > -1) {
                    $("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex, "OOSDate", null);
                    $("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex, "EstReturn", null);
                    $("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex, "Notes", "");
                }

                if (String(value).indexOf('Out of Service') > -1) {
                    $("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex, "OOSDate", new Date());
                    $("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex, "Change", "true");
                    change = true;
                } 

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

        function insertVehicle() {
            var vehicleId = $("#addVehicleCombo").jqxDropDownList('getSelectedItem').value;
            $.post($("#localApiDomain").val() + "FleetStatuss/InsertFleetStatus/" + vehicleId,
            //$.post("http://localhost:52839/api/FleetStatuss/InsertFleetStatus/" + vehicleId,
                function (data, status) {
                    switch (status) {
                        case 'success':
                            swal('Vehicle was added successfully.');
                            loadGrid();
                            break;
                        default:
                            swal('An Error occurred: ' + status + "\n Data:" + data);
                            break;
                    }
                }
            );
        }
        

        function saveChanges() {

            for (var i = 0; i < updateRows.length; i++) {

                var last = updateRows.length;

                var sendemail = false;
                var thisLocation = $("#vehicleLocation").val();

                var data = $('#jqxgrid').jqxGrid('getrowdatabyid', updateRows[i]);

                var thisOOSDate = "";
                var thisEstReturn = "";
                var thisLastExWash = "";
                var thisLastInExWash = "";

                if (data["OOSDate"] == null) {
                    thisOOSDate = "NULL";
                } else {
                    var thisOOSDate = DateFormat(data["OOSDate"]);
                    sendemail = true;
                }

                if (data["EstReturn"] == null) {
                    thisEstReturn = "NULL";
                } else {
                    thisEstReturn = DateFormat(data["EstReturn"]);
                }

                if (data["LastExWash"] == null) {
                    thisLastExWash = "NULL";
                } else {
                    thisLastExWash = DateFormat(data["LastExWash"]);
                }

                if (data["LastInExWash"] == null) {
                    thisLastInExWash = "NULL";
                } else {
                    thisLastInExWash = DateFormat(data["LastInExWash"]);
                }

                //if (change == true) {
                //    changeBody = changeBody + data["VehicleNumber"] + " has been taken out of service. <br/>Note: " + data["Notes"] + "<br/>Out of Service date: " + thisOOSDate + "<br/>Estimated Return: " + thisEstReturn + "<br/><br/>";
                //}

                if (data["Change"] == "true") {
                    changeBody = changeBody + data["VehicleNumber"] + " has been taken out of service. <br/>Note: " + data["Notes"] + "<br/>Out of Service date: " + thisOOSDate + "<br/>Estimated Return: " + thisEstReturn + "<br/><br/>";
                }

                //$.post($("#localApiDomain").val() + "FleetStatuss/UpdateFleetStatus",
                ////$.post("http://localhost:52839/api/FleetStatuss/UpdateFleetStatus",
                //    { 'FleetStatusID': data["FleetStatusID"], 'VehicleID': data["VehicleId"], 'FrontACStatus': data["FrontACStatus"], 'RearACStatus': data["RearACStatus"], 'LastExWash': thisLastExWash, 'LastInExWash': thisLastInExWash, 'OOSDate': thisOOSDate, 'EstReturn': thisEstReturn, 'Notes': data["Notes"], 'Status': data["Status"] },
                //    function (data, status) {
                //        switch (status) {
                //            case 'success':
                //                swal('Vehicle Statuses were updated successfully.');
                //                loadGrid($("#vehicleLocation").val(thisLocation));
                //                break;
                //            default:
                //                swal('An Error occurred: ' + status + "\n Data:" + data);
                //                break;
                //        }
                //    }
                //);

                //var url = "http://localhost:52839/api/FleetStatuss/UpdateFleetStatus";

                var url = $("#localApiDomain").val() + "FleetStatuss/UpdateFleetStatus";

                var postData = { 'FleetStatusID': data["FleetStatusID"], 'VehicleID': data["VehicleId"], 'FrontACStatus': data["FrontACStatus"], 'RearACStatus': data["RearACStatus"], 'LastExWash': thisLastExWash, 'LastInExWash': thisLastInExWash, 'OOSDate': thisOOSDate, 'EstReturn': thisEstReturn, 'Notes': data["Notes"], 'Status': data["Status"] }

                postFleetChange(url, postData).done(function (data) {
                    console.log();
                    if (i == last) {
                        swal("Saved");
                        loadGrid();
                    }
                }).fail(function (error) {
                    alert("error " + error);
                });
            }

            if (change == true) {
                PageMethods.SendEmail(changeBody, thisLocation);
                change = false;
                changeBody = "";
            }
            
            
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
                    <input type="button" id="update" value="Update Status" class="editor" />
                </div>
                <div class="col-sm-4">
                    <div id="vehicleType"></div>
                </div>
                <div class="col-sm-4">
                    <input style="float:right" type="button" id="newVehicle" value="New Vehicle" />
                    <input style="float:right" type="button" id="sendFleetStatus" value="Send Status" />
                </div>
            </div>
        </div>
    </div>

    
    <div style="display:none;">
        <input id="LocationId" type="text" value="0"  />
    </div>  
    
    
        <div class="row ">
            <div class="col-sm-12">
                <div id="jqxgrid"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->

    <%-- html for popup Edit box --%>
    <div id="popupWindow" style="display:none">
        <div>Add Vehicle</div>
        <div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-horizontal">
                            <div class="form-group" style="margin-left:100px">
                                <div id="addVehicleCombo"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="top-divider">
                            <div class="col-sm-1 col-md-3">
                            </div>
                            <div class="col-sm-4 col-md-3">
                                <input type="button" id="SaveNew" value="Save" />
                            </div>
                            <div class="col-sm-4 col-md-3">
                                <input type="button" id="CancelNew" value="Cancel" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- html for popup edit box END --%>


    <div id="popupLocation" style="display:none">
        <div>
            <div id="LocationCombo" style="float:left;"></div>
        </div>
    </div>
</asp:Content>


