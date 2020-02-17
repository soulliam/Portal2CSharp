 <%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="VehicleWorkOrder.aspx.cs" Inherits="VehicleWorkOrder" %>

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

    <script type="text/javascript" src="CSSReport/js/VehicleWorkOrderReport.js"></script>

    <style>
        .FPR_Content {
            font-size: 10px;
        }

        input[type="text"] {
            color: black;
        }

        .VehicleFormLabel{
            font-weight: bold;
        }

        .formWrapper {
            display: grid;
            grid-gap: 10px;
            grid-template-columns: 60% 40%;
            background-color: #fff;
            color: #444;
            padding: 15px;
        }

        .box {
            background-color: #444;
            color: #fff;
            border-radius: 5px;
            padding: 5px;
            font-size: 150%;

        }

        .VehicleData {
            grid-column: 1;
            grid-row: 1;
        }
        .PMI {
            grid-column: 2;
            grid-row: 1;
        }
        .MaintenanceDesc {
            grid-column: 1 / 3;
            grid-row: 2;
        }
        .Parts {
            grid-column: 1 / 3;
            grid-row: 3;
        }
        .Submit {
            grid-column: 1 / 3;
            grid-row: 4;
        }

        .vehicleDataWrapper {
            display: grid;
            grid-gap: 10px;
            grid-template-columns: auto auto auto auto;
            background-color: #599A1F;
            color: #fff;
            padding: 5px;
            border-radius: 5px;
        }

         .WorkOrder {
            grid-column: 1 / 3;
            grid-row: 1;
        }
        .Mechanic {
            grid-column: 3 / 5;
            grid-row: 1;
        }
        .Year {
            grid-column: 1;
            grid-row: 2;
        }
        .Make {
            grid-column: 2;
            grid-row: 2;
        }
        .Model {
            grid-column: 3;
            grid-row: 2;
        }
        .BusNumber {
            grid-column: 4;
            grid-row: 2;
        }
        .Mileage {
            grid-column: 1;
            grid-row: 4;
        }
        .Hours {
            grid-column: 2;
            grid-row: 4;
        }
        .Date {
            grid-column: 3;
            grid-row: 4;
        }
        .VinNumber {
            grid-column: 4;
            grid-row: 4;
        }

        .MaintenanceDescWrapper {
            display: grid;
            grid-gap: 10px;
            grid-template-columns: auto auto;
            background-color: #599A1F;
            color: #fff;
            padding: 5px;
            border-radius: 5px;
        }

        .Complaint {
            grid-column: 1;
            grid-row: 1;
        }
        .Resolution {
            grid-column: 2;
            grid-row: 1;
        }
       

    </style>

    <script type="text/javascript">
        // ============= Initialize Page ==================== Begin
        var group = '<%= Session["groupList"] %>';
        var render = true;
        var partSelected = true;
        var lastKey;
        var partCostValue = false;
        var partCostTotal = false;
        var editDataField = "";
        var editRow = -1;
        var SelectedLocation = 0;

        $(document).ready(function () {

            $("#workOrderDate").jqxDateTimeInput({ width: '100%', height: '30px', formatString: "MM/dd/yyyy" });
            $('#workOrderDate').on('valueChanged', function (event) {
                var vehicleId = $("#vehiclesCombo").jqxDropDownList('getSelectedItem');
                var maintenanceDate = DateFormat(event.args.date);

                var strMileage = '{ "VehicleId": ' + vehicleId.value + ', "MileageDate": "' + maintenanceDate + '" }';

                MileageObj = JSON.parse(strMileage);

                $.ajax({
                    async: false,
                    type: "POST",
                    url: $("#localApiDomain").val() + "Vehicles/GetVehicleMileageByDate/",
                    //url: "http://localhost:52839/api/Vehicles/GetVehicleMileageByDate/",

                    data: MileageObj,
                    dataType: "json",
                    success: function (thisData) {
                        $("#txtMileage").val(thisData);
                    },
                    error: function (request, status, error) {
                        alert(error);
                    }
                });

                $.ajax({
                    async: false,
                    type: "POST",
                    url: $("#localApiDomain").val() + "Vehicles/GetVehicleHoursByDate/",
                    //url: "http://localhost:52839/api/Vehicles/GetVehicleHoursByDate/",

                    data: MileageObj,
                    dataType: "json",
                    success: function (thisData) {
                        $("#txtHours").val(thisData);
                    },
                    error: function (request, status, error) {
                        alert(error);
                    }
                });
            });

            $("#clear").jqxButton({ width: 150 });
            $("#save").jqxButton({ width: 150 });

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
                var offset = $(".formWrapper").offset();
                $("#popupLocation").jqxWindow({ position: { x: parseInt(offset.left) + 500, y: parseInt(offset.top) - 40 } });
                $('#popupLocation').jqxWindow({ width: "325px", height: "300px" });
                $('#popupLocation').jqxWindow({ isModal: true, modalOpacity: 0.7 });
                $('#popupLocation').jqxWindow({ showCloseButton: false });
                $("#popupLocation").css("visibility", "visible");
                $("#popupLocation").jqxWindow({ title: 'Pick a Location' });
                $("#popupLocation").jqxWindow('open');
            }
            else {
                SelectedLocation = locationString;
                $("#vehicleLocation").val(locationString);
                loadVehicles(locationString);
                loadMechanics(locationString);
            }

            $("#LocationCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {
                        SelectedLocation = item.value;
                        var thisLocationId = item.value;
                        $("#vehicleLocation").val(thisLocationId);
                        $("#popupLocation").jqxWindow('hide');
                        loadVehicles(thisLocationId);
                        loadMechanics(thisLocationId);
                    }
                }
            });

            $("#LocationCombo").on('bindingComplete', function (event) {
                $("#LocationCombo").jqxDropDownList('insertAt', 'Pick a Location', 0);
            });

            $("#vehiclesCombo").on('select', function (event) {
                if (event.args.index > 0) {
                    clearInfo(true);
                    if (event.args) {
                        var item = event.args.item;
                        if (item) {
                            var thisVehicleId = item.value;
                            var thisVehicleNumber = item.label;
                            loadPMIList(thisVehicleId);
                            loadSelectedVehicle(thisVehicleId, thisVehicleNumber);
                        }
                    }
                }
            });

            $("#vehiclesCombo").on('bindingComplete', function (event) {
                $("#vehiclesCombo").jqxDropDownList('insertAt', 'Pick a Vehicle', 0);
            });

            
            $("#mechanicCombo").on('bindingComplete', function (event) {
                $("#mechanicCombo").jqxDropDownList('insertAt', 'Pick a Mechanic', 0);
            });


            var supplierURL = $("#localApiDomain").val() + "VehiclePartSuppliers/GetSuppliers/";
            //var supplierURL = "http://localhost:52839/api/VehiclePartSuppliers/GetSuppliers/";

            //set up the location combobox
            var supplierSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'PartSupplierName' },
                    { name: 'PartSupplierId' }
                ],
                url: supplierURL

            };
            var supplierDataAdapter = new $.jqx.dataAdapter(supplierSource);

            var source =
            {
                datafields: [
                    { name: 'PartId', hidden: true },
                    { name: 'PartDescription', type: 'string' },
                    { name: 'PartNumber', type: 'string' },
                    { name: 'Quantitiy', type: 'number' },
                    { name: 'UnitPrice', type: 'number' },
                    { name: 'InvoiceNumber', type: 'string' },
                    { name: 'Vendor' },
                    { name: 'Warranty' },
                    { name: 'PartCost', type: 'number' },
                    { name: 'Labor', type: 'number' },
                    { name: 'Tax', type: 'number' },
                    { name: 'Total', type: 'number' }
                ]
            };

            $("#partsGrid").jqxGrid(
            {
                width: '100%',
                height: 250,
                source: source,
                rowsheight: 35,
                editable: true,
                showtoolbar: true,
                showstatusbar: true,
                showaggregates: true,
                selectionmode: 'checkbox',
                handlekeyboardnavigation: function (event) {
                    var key = event.charCode ? event.charCode : event.keyCode ? event.keyCode : 0;
                    if (key == 9 && editDataField == "Total") {
                        $("#partsGrid").jqxGrid('begincelledit', editRow + 1, "PartDescription");
                        return true;
                    }
                    return false;
                },
                ready: function () {
                    //Issue with values not appearing in cells. I set the begin edit and the cell values become visible.
                    var rows = $('#partsGrid').jqxGrid('getrows');

                    for (var index = 0; index < rows.length; index++) {
                        $("#partsGrid").jqxGrid('begincelledit', index, "PartDescription");
                    }

                    $("#partsGrid").jqxGrid('begincelledit', 0, "PartDescription");

                },
                rendered: function () {
                    //Begins editing in first column after new row is added
                    var rows = $('#partsGrid').jqxGrid('getrows');
                    $("#partsGrid").jqxGrid('begincelledit', rows.length - 1, "PartDescription");
                },
                rendertoolbar: function (toolbar) {
                    var me = this;
                    var container = $("<div style='margin: 5px;'></div>");
                    toolbar.append(container);
                    container.append('<input id="addrowbutton" type="button" value="Add New Row" /><input id="deleterowbutton" type="button" value="Delete Row" /></div>');
                    $("#addrowbutton").jqxButton({ width: 150 });
                    $("#deleterowbutton").jqxButton({ width: 150 });
                    $("#addrowbutton").on('click', function () {
                        var datarow = generaterow();
                        var commit = $("#partsGrid").jqxGrid('addrow', null, datarow);
                    });
                    $("#deleterowbutton").on('click', function () {
                        var rowindex = $('#partsGrid').jqxGrid('getselectedrowindex');
                        var thisRowId = $('#partsGrid').jqxGrid('getrowid', rowindex);
                        $('#partsGrid').jqxGrid('deleterow', thisRowId);
                    });
                },
                columns: [
                        { text: 'PartId', datafield: 'PartId', hidden: true },
                        { text: 'Part Description', datafield: 'PartDescription', width: '25%' },
                        { text: 'Part Number', datafield: 'PartNumber', width: '10%' },
                        {
                            text: 'Quantity', datafield: 'Quantity', width: 70, columntype: 'numberinput', width: '5%',
                            validation: function (cell, value) {
                                //if (value < 0 || value > 1000) {
                                //    return { result: false, message: "Quantity should be in the 0-150 interval" };
                                //}
                                return true;
                            },
                            createeditor: function (row, cellvalue, editor) {
                                editor.jqxNumberInput({ decimalDigits: 0, digits: 5 });
                            }
                        },
                        {
                            text: 'Unit Price', datafield: 'UnitPrice', cellsformat: 'c2', columntype: 'numberinput', width: '5%',
                            validation: function (cell, value) {
                                //if (value < 0 || value > 15) {
                                //    return { result: false, message: "Price should be in the 0-15 interval" };
                                //}
                                return true;
                            },
                            createeditor: function (row, cellvalue, editor) {
                                editor.jqxNumberInput({ digits: 5 });
                            }
                        },
                        { text: 'Invoice Number', datafield: 'InvoiceNumber', width: '15%' },
                        {
                            text: 'Vendor', width: 150, datafield: 'Vendor', columntype: 'combobox', width: '10%',
                            createeditor: function (row, value, editor) {
                                editor.jqxComboBox({ source: supplierDataAdapter, displayMember: 'PartSupplierName', valueMember: 'PartSupplierName', promptText: "Please Choose:" });
                            },
                            // update the editor's value before saving it.
                            cellvaluechanging: function (row, column, columntype, oldvalue, newvalue) {
                                // return the old value, if the new value is empty.
                                //if (newvalue == "") swal("Pick a Vendor");
                                $("#partsGrid").jqxGrid('begincelledit', row, "Vendor");
                            }
                        },
                        {
                            text: 'Warranty', datafield: 'Warranty', columntype: 'combobox', width: '10%',
                            createeditor: function (row, column, editor) {
                                // assign a new data source to the combobox.
                                var list = ['NA', '1 Month', '6 Month', '12 Month', '2 year', 'Lifetime'];
                                editor.jqxComboBox({ autoDropDownHeight: true, source: list, promptText: "Please Choose:" });
                            },
                            // update the editor's value before saving it.
                            cellvaluechanging: function (row, column, columntype, oldvalue, newvalue) {
                                // return the old value, if the new value is empty.
                                if (newvalue == "") return oldvalue;
                            }
                        },
                        {
                            text: 'Part Cost', datafield: 'PartCost', width: '5%',
                            cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata) {
                                var PartCostTotal = checkUndefinedNaN(parseFloat(rowdata.Quantity)) * checkUndefinedNaN(parseFloat(rowdata.UnitPrice));
                                if (checkUndefinedNaN(rowdata.PartCost) != PartCostTotal) {
                                    $('#partsGrid').jqxGrid('setcellvalue', index, 'PartCost', PartCostTotal);
                                    if (PartCostTotal != 0){
                                        partCostValue = true;
                                    } else {
                                        partCostValue = false;
                                    }
                                }
                                if (partCostValue == false || PartCostTotal == 0) {
                                    return '<div style="margin-top:10px;"><span>$0.00</span></div>';
                                }
                            },
                            // Need to be able to tab into this cell so it updates, but don't want to let the value change
                            cellvaluechanging: function (row, column, columntype, oldvalue, newvalue) {
                                return oldvalue;
                            },
                            aggregates: ['sum'],
                            aggregatesrenderer: function (aggregates) {
                                var value = aggregates['Total'];
                                var renderstring = '<div style="float: left; margin: 4px; overflow: hidden;">' + aggregates.sum + '</div>';
                                return renderstring;
                            },
                            cellsformat: 'c2'
                        },
                        {
                            text: 'Labor', datafield: 'Labor', cellsformat: 'c2', columntype: 'numberinput', width: '5%',
                            validation: function (cell, value) {
                                //if (value < 0 || value > 15) {
                                //    return { result: false, message: "Price should be in the 0-15 interval" };
                                //}
                                return true;
                            },
                            createeditor: function (row, cellvalue, editor) {
                                editor.jqxNumberInput({ digits: 5 });
                            },
                            aggregates: ['sum'],
                            aggregatesrenderer: function (aggregates) {
                                var value = aggregates['Total'];
                                var renderstring = '<div style="float: left; margin: 4px; overflow: hidden;">' + aggregates.sum + '</div>';
                                return renderstring;
                            },
                            cellsformat: 'c2'
                        },
                        {
                            text: 'Tax', datafield: 'Tax', cellsformat: 'c2', columntype: 'numberinput', width: '5%',
                            validation: function (cell, value) {
                                //if (value < 0 || value > 15) {
                                //    return { result: false, message: "Price should be in the 0-15 interval" };
                                //}
                                return true;
                            },
                            createeditor: function (row, cellvalue, editor) {
                                editor.jqxNumberInput({ digits: 5 });
                            },
                            aggregates: ['sum'],
                            aggregatesrenderer: function (aggregates) {
                                var value = aggregates['Total'];
                                var renderstring = '<div style="float: left; margin: 4px; overflow: hidden;">' + aggregates.sum + '</div>';
                                return renderstring;
                            },
                            cellsformat: 'c2'
                        },
                        {
                            text: 'Total', datafield: 'Total', width: '5%',
                            cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata) {
                                var total = checkUndefinedNaN(parseFloat(rowdata.PartCost)) + checkUndefinedNaN(parseFloat(rowdata.Labor)) + checkUndefinedNaN(parseFloat(rowdata.Tax));
                                if ((checkUndefinedNaN(rowdata.Total)) != total) {
                                    $('#partsGrid').jqxGrid('setcellvalue', index, 'Total', total);
                                    if (total != 0) {
                                        partCostTotal = true;
                                    } else {
                                        partCostTotal = false;
                                    }
                                }
                                if (partCostTotal == false  || total == 0) {
                                    return '<div style="margin-top:10px;"><span>$0.00</span></div>';
                                }
                            },
                            // Need to be able to tab into this cell so it updates, but don't want to let the value change
                            cellvaluechanging: function (row, column, columntype, oldvalue, newvalue) {
                                return oldvalue;
                            },
                            aggregates: ['sum'],
                            aggregatesrenderer: function (aggregates) {
                                var value = aggregates['Total'];
                                var renderstring = '<div style="float: left; margin: 4px; overflow: hidden;">' + aggregates.sum + '</div>';
                                return renderstring;
                            },
                            cellsformat: 'c2'
                        }
                ]
            });

            $('#partsGrid').on('rowselect', function (event) {
                if (partSelected == true) {
                    partSelected = false;
                    var selectedRowIndex = event.args.rowindex;
                    $('#partsGrid').jqxGrid('clearselection');
                    $('#partsGrid').jqxGrid('selectrow', selectedRowIndex);
                } else {
                    partSelected = true;
                }
                
            });

            $('#partsGrid').on('cellbeginedit', function (event) {
                var args = event.args;
                editDataField = event.args.datafield;
                editRow = args.rowindex;
            });

            $("#clear").on('click', function () {
                clearInfo();
            });

            $("#save").on("click", function () {
                //check required ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                if ($("#vehiclesCombo").jqxDropDownList('getSelectedItem').label == 'Pick a Vehicle') {
                    swal('Pick a Vehicle');
                    return;
                }

                if ($("#mechanicCombo").jqxDropDownList('getSelectedItem').label == 'Pick a Mechanic') {
                    swal('Pick a Mechanic');
                    return;
                }

                if ($("#complaint").val() == '') {
                    swal('Enter a Compliant');
                    return;
                }

                if ($("#resolution").val() == '') {
                    swal('Enter a Resolution');
                    return;
                }

                var partGridInfo = $("#partsGrid").jqxGrid('getdatainformation');
                var partRowCount = partGridInfo.rowscount;

                if (partRowCount <= 0) {
                    swal('Enter Parts');
                    return;
                }

                //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

                $('#partsGrid').jqxGrid({ showaggregates: false });
                
                //return;
                var vehicle = $("#vehiclesCombo").jqxDropDownList('getSelectedItem');
                var mechanic = $("#mechanicCombo").jqxDropDownList('getSelectedItem');
                var packageId = $("#pmiCombo").jqxDropDownList('getSelectedItem');
                var locationId = SelectedLocation;
                var workOrderDate = $('#workOrderDate').jqxDateTimeInput('getDate');
                var PartsCost = checkUndefinedNaN($("#partsGrid").jqxGrid('getcolumnaggregateddata', 'PartCost', ['sum']).sum);
                var Labor = checkUndefinedNaN($("#partsGrid").jqxGrid('getcolumnaggregateddata', 'Labor', ['sum']).sum);
                var Tax = checkUndefinedNaN($("#partsGrid").jqxGrid('getcolumnaggregateddata', 'Tax', ['sum']).sum);
                var userName = $("#txtLoggedinUsername").val();
                userName = userName.replace(/\\/g, "\\\\");
                var today = new Date();

                if (checkUndefinedString(packageId) != '') {
                    if (checkUndefinedString(packageId.value) == '' || checkUndefinedString(packageId.value) == 'Pick a PMI') {
                        packageId = 0;
                    } else {
                        packageId = packageId.value;
                    }
                } else {
                    packageId = 0;
                }

                var thisComplaint = checkUndefinedString($("#complaint").val())
                thisComplaint = thisComplaint.replace(/'/g, "''");
                thisComplaint = thisComplaint.replace(/\\"/g, '"').replace(/"/g, '\\"');

                var thisResolution = checkUndefinedString($("#resolution").val())
                thisResolution = thisResolution.replace(/'/g, "''");
                thisResolution = thisResolution.replace(/\\"/g, '"').replace(/"/g, '\\"');

                var maintenanceString = '{ "VehicleId": ' + vehicle.value + ', ' +
                                          '"WorkOrder": "' + checkUndefinedString($("#txtWorkOrder").val()) + '", ' +
                                          '"MaintenanceDate": "' + DateTimeFormat(workOrderDate) + '", ' +
                                          '"PartsCost": ' + checkUndefinedNaN(PartsCost) + ', ' +
                                          '"PartsTax": ' + checkUndefinedNaN(Tax) + ', ' +
                                          '"MechanicId": ' + checkUndefinedNaN(mechanic.value) + ', ' +
                                          '"LaborCost": ' + checkUndefinedNaN(Labor) + ', ' +
                                          '"Notes": "' + thisComplaint + '", ' +
                                          '"MaintenanceDescription": "' + thisResolution + '", ' +
                                          '"DateTimeEntered": "' + DateTimeFormat(today) + '", ' +
                                          '"PackageId": ' + packageId + ', ' +
                                          '"WarranyWork": ' + checkUndefinedNaN(0) + ', ' +
                                          '"LocationId": ' + checkUndefinedNaN(locationId) + ', ' +
                                          '"EnteredBy": "' + checkUndefinedString(userName) + '", ' +
                                          '"VehicleMaintenanceParts":['
                '}';

                var partsString = '';
                var firstPart = true;
                var rows = $('#partsGrid').jqxGrid('getrows');
                var partError = false;

                for (var index = 0; index < rows.length; index++) {
                    var row = rows[index];

                    if (checkUndefinedString(row.Vendor) == '') {
                        rowNumber = parseInt(index) + 1;
                        swal("Vendor missing on part row " + rowNumber + '.');
                        partError = true;
                        return;
                    } else {
                        var vendor = checkUndefinedString(row.Vendor);
                        vendor = vendor.replace(/\\"/g, '"').replace(/"/g, '\\"');
                        vendor = vendor.replace(/'/g, "''");
                    }

                    if (firstPart == true) {
                        partsString = '{ ';
                    } else {
                        partsString = ', { ';
                    }

                    var thisPartDesc = checkUndefinedString(row.PartDescription);
                    thisPartDesc = thisPartDesc.replace(/'/g, "''");
                    thisPartDesc = thisPartDesc.replace(/\\"/g, '"').replace(/"/g, '\\"');

                    partsString = partsString + '"PartId": ' + checkUndefinedNaN(row.PartId) + ', ' +
                                  '"PartDescription": "' + thisPartDesc + '", ' +
                                  '"PartModel": "' + checkUndefinedString(row.PartNumber) + '", ' +
                                  '"Quantity": ' + checkUndefinedNaN(row.Quantity) + ', ' +
                                  '"UnitPrice": ' + checkUndefinedNaN(row.UnitPrice) + ', ' +
                                  '"InvoiceNumber": "' + checkUndefinedString(row.InvoiceNumber) + '", ' +
                                  '"Vendor": "' + vendor + '", ' +
                                  '"Warranty": "' + checkUndefinedString(row.Warranty) + '", ' +
                                  '"PartCost": ' + checkUndefinedNaN(row.PartCost) + ', ' +
                                  '"Labor": ' + checkUndefinedNaN(row.Labor) + ', ' +
                                  '"Tax": ' + checkUndefinedNaN(row.Tax) + ', ' +
                                  '"Total": ' + checkUndefinedNaN(row.Total) + ', ' +
                                  '"FueltypeId": ' + checkUndefinedNaN($("#txtFuelTypeId").val()) + ', ' +
                                  '"PartSupplierName": "' + vendor + '", ' +
                                  '"ModelId": ' + checkUndefinedNaN($("#txtModelId").val()) + ' }';

                    maintenanceString = maintenanceString + partsString;
                    partsString = '';
                    firstPart = false;
                }

                if (partError == true) {
                    return;
                }
                PrintWorkOrder();

                maintenanceString = maintenanceString + ']}';

                var maintenanceObj = JSON.parse(maintenanceString);

                $.ajax({
                    async: false,
                    type: "POST",
                    url: $("#localApiDomain").val() + "VehicleMaintenances/InsertVehicleMaintenance/",
                    //url: "http://localhost:52839/api/VehicleMaintenances/InsertVehicleMaintenance/",

                    data: maintenanceObj,
                    dataType: "json",
                    success: function (thisData) {
                        swal(thisData);
                        clearInfo();
                    },
                    error: function (request, status, error) {
                        swal(error);
                    }
                });

                

                $('#partsGrid').jqxGrid({ showaggregates: true });

            });

            $("#tax").attr("placeholder", "$");

            $("#tax").mouseup(function () {
                var amount = $("#tax").val();
                $("#tax").val("");
                $("#tax").val(amount);
            });

            $("#tax").on('focus', function () {
                var amount = $("#tax").val();
                $("#tax").val("");
                $("#tax").val(amount);
            });

            $("#tax").on('input', function (e) {
                var amount = $("#tax").val();

                if (isNaN(amount.substring(amount.length - 1, amount.length))) {
                    $("#tax").val(amount.substring(0, amount.length - 1));
                    return;
                }

                if (lastKey == 8) {
                    var holdAmount = $("#taxHold").val();

                    holdAmount = holdAmount.substring(0, holdAmount.length - 1);
                    $("#taxHold").val(holdAmount);
                    amount = ($("#taxHold").val() / 100).toFixed(2);

                } else {
                    var holdAmount = $("#taxHold").val();

                    $("#taxHold").val(holdAmount.toString() + amount.substring(amount.length - 1, amount.length));

                    amount = ($("#taxHold").val() / 100).toFixed(2);
                }

                amount += '';
                var x = amount.split('.');
                var x1 = x[0];
                var x2 = x.length > 1 ? '.' + x[1] : '';
                var rgx = /(\d+)(\d{3})/;
                while (rgx.test(x1)) {
                    x1 = x1.replace(rgx, '$1' + ',' + '$2');
                }
                amount = x1 + x2;

                lastKey = 8;

                $("#tax").val("$" + amount.toString());
            });


            Security();

        });

        $(document).keyup(function (e) {

            //var keycode = (e.keyCode ? e.keyCode : e.which);
            //if (keycode == '9') {
            //    $("#partsGrid").jqxGrid('updatebounddata', 'cells');
            //}

        });

        var generaterow = function (i) {
            var rows = $("#partsGrid").jqxGrid("getrows");
            var data = $("#partsGrid").jqxGrid("getrowdata", rows.length - 1);

            var row = {};
            
            row["PartDescription"] = '';
            row["PartNumber"] = '';
            row["Quantity"] = '';
            row["UnitPrice"] = '';
            if (rows.length > 0) {
                row["InvoiceNumber"] = data["InvoiceNumber"];
            }
            else
            {
                row["InvoiceNumber"] = '';
            }
            if (rows.length > 0) {
                row["Vendor"] = data["Vendor"];
            }
            else {
                row["Vendor"] = '';
            }
            row["Warranty"] = '';
            row["PartCost"] = '';
            row["Labor"] = '';
            row["Tax"] = '';
            row["total"] = '';
            return row;


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

        function loadPMIList(thisVehicleId) {
            var url = $("#localApiDomain").val() + "MaintenancePackages/GetPMIByVehicleID/" + thisVehicleId;
            //var url = "http://localhost:52839/api/MaintenancePackages/GetPMIByVehicleID/" + thisVehicleId;

            //set up the location combobox
            var PMISource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'PackageId' },
                    { name: 'PackageName' }
                ],
                url: url

            };
            var PMIDataAdapter = new $.jqx.dataAdapter(PMISource);
            $("#pmiCombo").jqxDropDownList(
            {
                width: '100%',
                height: 30,
                itemHeight: 50,
                source: PMIDataAdapter,
                selectedIndex: 0,
                displayMember: "PackageName",
                valueMember: "PackageId"
            });

            $("#pmiCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {
                        var thisPMIId = item.value
                        loadPMIDescription(thisPMIId);
                        loadPMIParts(thisPMIId);
                    }
                }
            });

            $("#pmiCombo").on('bindingComplete', function (event) {
                $("#pmiCombo").jqxDropDownList('insertAt', 'Pick a PMI', 0);
            });
        }

        function loadPMIDescription(thisPMIId) {
            $("#resolution").val('');

            var url = $("#localApiDomain").val() + "MaintenancePackages/GetPMIDescription/" + thisPMIId;
            //var url = "http://localhost:52839/api/MaintenancePackages/GetPMIDescription/" + thisPMIId;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                success: function (data) {
                    $("#resolution").val(data[0].PackageDescription);
                },
                error: function (request, status, error) {
                    swal(error);
                }
            });
        }

        function loadPMIParts(thisPMIId) {

            var parent = $("#partsGrid").parent();
            $("#partsGrid").jqxGrid('destroy');
            $("<div id='partsGrid'></div>").appendTo(parent);

            var supplierURL = $("#localApiDomain").val() + "VehiclePartSuppliers/GetSuppliers/";
            //var supplierURL = "http://localhost:52839/api/VehiclePartSuppliers/GetSuppliers/";

            //set up the location combobox
            var supplierSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'PartSupplierName' },
                    { name: 'PartSupplierId' }
                ],
                url: supplierURL

            };

            var supplierDataAdapter = new $.jqx.dataAdapter(supplierSource);
            
            var url = $("#localApiDomain").val() + "MaintenancePackageParts/GetPartsByPMIId/" + thisPMIId;
            //var url = "http://localhost:52839/api/MaintenancePackageParts/GetPartsByPMIId/" + thisPMIId;

            var source =
            {
                datafields: [
                   { name: 'PartId', hidden: true },
                    { name: 'PartDescription', type: 'string' },
                    { name: 'PartNumber', type: 'string' },
                    { name: 'Quantity', type: 'number' },
                    { name: 'UnitPrice', type: 'number' },
                    { name: 'InvoiceNumber', type: 'string' },
                    { name: 'Vendor' },
                    { name: 'Warranty' },
                    { name: 'PartCost', type: 'number' },
                    { name: 'Labor', type: 'number' },
                    { name: 'Tax', type: 'number' },
                    { name: 'Total', type: 'number' }
                ],
                type: 'Get',
                datatype: "json",
                url: url,
            };

            $("#partsGrid").jqxGrid(
            {
                width: '100%',
                height: 250,
                source: source,
                rowsheight: 35,
                editable: true,
                showtoolbar: true,
                showstatusbar: true,
                showaggregates: true,
                selectionmode: 'checkbox',
                handlekeyboardnavigation: function (event) {
                    var key = event.charCode ? event.charCode : event.keyCode ? event.keyCode : 0;
                    if (key == 9 && editDataField == "Total") {
                        $("#partsGrid").jqxGrid('begincelledit', editRow + 1, "PartDescription");
                        return true;
                    } 
                    return false;
                },
                ready: function () {
                    //Issue with values not appearing in cells. I set the begin edit and the cell values become visible.
                    var rows = $('#partsGrid').jqxGrid('getrows');

                    for (var index = 0; index < rows.length; index++) {
                        $("#partsGrid").jqxGrid('begincelledit', index, "PartDescription");
                    }

                    $("#partsGrid").jqxGrid('begincelledit', 0, "PartDescription");
                    
                },
                rendered: function () {
                    //Begins editing in first column after new row is added
                    var rows = $('#partsGrid').jqxGrid('getrows');
                    $("#partsGrid").jqxGrid('begincelledit', rows.length - 1, "PartDescription");
                },
                rendertoolbar: function (toolbar) {
                    var me = this;
                    var container = $("<div style='margin: 5px;'></div>");
                    toolbar.append(container);
                    container.append('<input id="addrowbutton" type="button" value="Add New Row" /><input id="deleterowbutton" type="button" value="Delete Row" />');
                    $("#addrowbutton").jqxButton({ width: 150 });
                    $("#deleterowbutton").jqxButton({ width: 150 });
                    $("#addrowbutton").on('click', function () {
                        var datarow = generaterow();
                        var commit = $("#partsGrid").jqxGrid('addrow', null, datarow);
                    });
                    $("#deleterowbutton").on('click', function () {
                        var rowindex = $('#partsGrid').jqxGrid('getselectedrowindex');
                        var thisRowId = $('#partsGrid').jqxGrid('getrowid', rowindex);
                        $('#partsGrid').jqxGrid('deleterow', thisRowId);
                    });
                },
                columns: [
                        { text: 'PartId', datafield: 'PartId', hidden: true },
                        { text: 'Part Description', datafield: 'PartDescription', width: '25%' },
                        { text: 'Part Number', datafield: 'PartNumber', width: '10%' },
                        {
                            text: 'Quantity', datafield: 'Quantity', width: 70, columntype: 'numberinput', width: '5%',
                            validation: function (cell, value) {
                                //if (value < 0 || value > 1000) {
                                //    return { result: false, message: "Quantity should be in the 0-150 interval" };
                                //}
                                return true;
                            },
                            createeditor: function (row, cellvalue, editor) {
                                editor.jqxNumberInput({ decimalDigits: 0, digits: 3 });
                            }
                        },
                        {
                            text: 'Unit Price', datafield: 'UnitPrice', cellsformat: 'c2', columntype: 'numberinput', width: '5%',
                            validation: function (cell, value) {
                                //if (value < 0 || value > 15) {
                                //    return { result: false, message: "Price should be in the 0-15 interval" };
                                //}
                                return true;
                            },
                            createeditor: function (row, cellvalue, editor) {
                                editor.jqxNumberInput({ digits: 5 });
                            }
                        },
                        { text: 'Invoice Number', datafield: 'InvoiceNumber', width: '15%' },
                        {
                            text: 'Vendor', width: 150, datafield: 'Vendor', columntype: 'combobox', width: '10%',
                            createeditor: function (row, value, editor) {
                                editor.jqxComboBox({ source: supplierDataAdapter, displayMember: 'PartSupplierName', valueMember: 'PartSupplierName', promptText: "Please Choose:" });
                            },
                            // update the editor's value before saving it.
                            cellvaluechanging: function (row, column, columntype, oldvalue, newvalue) {
                                // return the old value, if the new value is empty.
                                //if (newvalue == "") swal("Pick a Vendor");
                                $("#partsGrid").jqxGrid('begincelledit', row, "Vendor");
                            }
                        },
                        {
                            text: 'Warranty', datafield: 'Warranty', columntype: 'combobox', width: '10%',
                            createeditor: function (row, column, editor) {
                                // assign a new data source to the combobox.
                                var list = ['NA', '1 Month', '6 Month', '12 Month', 'Lifetime'];
                                editor.jqxComboBox({ autoDropDownHeight: true, source: list, promptText: "Please Choose:" });
                            },
                            // update the editor's value before saving it.
                            cellvaluechanging: function (row, column, columntype, oldvalue, newvalue) {
                                // return the old value, if the new value is empty.
                                if (newvalue == "") return oldvalue;
                            }
                        },
                        {
                            text: 'Part Cost', datafield: 'PartCost', width: '5%',
                            cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata) {
                                var PartCostTotal = checkUndefinedNaN(parseFloat(rowdata.Quantity)) * checkUndefinedNaN(parseFloat(rowdata.UnitPrice));
                                if (checkUndefinedNaN(rowdata.PartCost) != PartCostTotal) {
                                    $('#partsGrid').jqxGrid('setcellvalue', index, 'PartCost', PartCostTotal);
                                    if (PartCostTotal != 0) {
                                        partCostValue = true;
                                    } else {
                                        partCostValue = false;
                                    }
                                }
                                if (partCostValue == false || PartCostTotal == 0) {
                                    return '<div style="margin-top:10px;"><span>$0.00</span></div>';
                                }
                                
                            },
                            // Need to be able to tab into this cell so it updates, but don't want to let the value change
                            cellvaluechanging: function (row, column, columntype, oldvalue, newvalue) {
                                return oldvalue;
                            },
                            aggregates: ['sum'],
                            aggregatesrenderer: function (aggregates) {
                                var value = aggregates['Total'];
                                var renderstring = '<div style="float: left; margin: 4px; overflow: hidden;">' + aggregates.sum + '</div>';
                                return renderstring;
                            },
                            cellsformat: 'c2'
                        },
                        {
                            text: 'Labor', datafield: 'Labor', cellsformat: 'c2', columntype: 'numberinput', width: '5%',
                            validation: function (cell, value) {
                                //if (value < 0 || value > 15) {
                                //    return { result: false, message: "Price should be in the 0-15 interval" };
                                //}
                                return true;
                            },
                            createeditor: function (row, cellvalue, editor) {
                                editor.jqxNumberInput({ digits: 5 });
                            },
                            aggregates: ['sum'],
                            aggregatesrenderer: function (aggregates) {
                                var value = aggregates['Total'];
                                var renderstring = '<div style="float: left; margin: 4px; overflow: hidden;">' + aggregates.sum + '</div>';
                                return renderstring;
                            },
                            cellsformat: 'c2'
                        },
                        {
                            text: 'Tax', datafield: 'Tax', cellsformat: 'c2', columntype: 'numberinput', width: '5%',
                            validation: function (cell, value) {
                                //if (value < 0 || value > 15) {
                                //    return { result: false, message: "Price should be in the 0-15 interval" };
                                //}
                                return true;
                            },
                            createeditor: function (row, cellvalue, editor) {
                                editor.jqxNumberInput({ digits: 5 });
                            },
                            aggregates: ['sum'],
                            aggregatesrenderer: function (aggregates) {
                                var value = aggregates['Total'];
                                var renderstring = '<div style="float: left; margin: 4px; overflow: hidden;">' + aggregates.sum + '</div>';
                                return renderstring;
                            },
                            cellsformat: 'c2'
                        },
                        {
                            text: 'Total', datafield: 'Total', width: '5%',
                            cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata) {
                                var total = checkUndefinedNaN(parseFloat(rowdata.PartCost)) + checkUndefinedNaN(parseFloat(rowdata.Labor)) + checkUndefinedNaN(parseFloat(rowdata.Tax));
                                if ((checkUndefinedNaN(rowdata.Total)) != total) {
                                    $('#partsGrid').jqxGrid('setcellvalue', index, 'Total', total);
                                    if (total != 0) {
                                        partCostTotal = true;
                                    } else {
                                        partCostTotal = false;
                                    }
                                }
                                if (partCostTotal == false || total == 0) {
                                    return '<div style="margin-top:10px;"><span>$0.00</span></div>';
                                }
                                
                            },
                            // Need to be able to tab into this cell so it updates, but don't want to let the value change
                            cellvaluechanging: function (row, column, columntype, oldvalue, newvalue) {
                                return oldvalue;
                            },
                            aggregates: ['sum'],
                            aggregatesrenderer: function (aggregates) {
                                var value = aggregates['Total'];
                                var renderstring = '<div style="float: left; margin: 4px; overflow: hidden;">' + aggregates.sum + '</div>';
                                return renderstring;
                            },
                            cellsformat: 'c2'
                        }
                ]
            });

            $('#partsGrid').on('cellendedit', function (event) {
                var args = event.args;
                // column data field.
                var dataField = event.args.datafield;
                // row's data.
                var rowData = args.row;
                if (dataField == "Vendor") {
                    if (rowData.value == '') {
                        swal("Pick a Vendor");
                    }
                }
            });

            $('#partsGrid').on('cellbeginedit', function (event) {
                var args = event.args;
                editDataField = event.args.datafield;
                editRow = args.rowindex;
            });
        }

        function loadVehicles(thisLocationId) {
            var url = $("#localApiDomain").val() + "Vehicles/GetVehiclesByLocation/" + thisLocationId;
            //var url = "http://localhost:52839/api/Vehicles/GetVehiclesByLocation/" + thisLocationId;

            //set up the location combobox
            var vehicleSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'VehicleId' },
                    { name: 'VehicleNumber' }
                ],
                url: url

            };
            var vehicleDataAdapter = new $.jqx.dataAdapter(vehicleSource);
            $("#vehiclesCombo").jqxDropDownList(
            {
                width: 300,
                height: 30,
                itemHeight: 25,
                source: vehicleDataAdapter,
                selectedIndex: 0,
                displayMember: "VehicleNumber",
                valueMember: "VehicleId"
            });
        }

        function loadSelectedVehicle(thisVehicleId, thisVehicleNumber) {
            var url = $("#localApiDomain").val() + "Vehicles/GetVehicleByID/" + thisVehicleId;
            //var url = "http://localhost:52839/api/Vehicles/GetVehicleByID/" + thisVehicleId;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                success: function (data) {
                    if (data.length > 0) {
                        $("#txtYear").val(data[0].Year);
                        $("#txtMake").val(data[0].MakeName);
                        $("#txtModel").val(data[0].ModelName);
                        $("#txtModelId").val(data[0].ModelId);
                        $("#txtFuelTypeId").val(data[0].FuelTypeId);
                        $("#txtBusNumber").val(data[0].VehicleNumber);
                        $("#txtMileage").val(data[0].Mileage);
                        $("#txtHours").val(data[0].Hours);
                        $("#txtVINNumber").val(data[0].VINNumber);
                    }
                    var today = new Date();
                    var thisYear = today.getFullYear();
                    var thisMonth = padNumber(today.getMonth() + 1, 2);
                    var thisDay = padNumber(today.getDate(), 2);
                    var thisHour = padNumber(today.getHours(), 2);
                    var thisMinute = padNumber(today.getMinutes(), 2);

                    $("#txtWorkOrder").val(thisYear + thisVehicleNumber + '-' + thisMonth + thisDay + '-' + thisHour + thisMinute);
                },
                error: function (request, status, error) {
                    swal(error);
                }
            });
        }

        function loadMechanics(thisLocationId) {
            var url = $("#localApiDomain").val() + "Mechanics/GetMechanicsByLocation/" + thisLocationId;
            //var url = "http://localhost:52839/api/Mechanics/GetMechanicsByLocation/" + thisLocationId;

            //set up the mechanic jqxDropDownList
            var MechanicSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'MechanicName' },
                    { name: 'MechanicId' }
                ],
                url: url

            };
            var MechanicDataAdapter = new $.jqx.dataAdapter(MechanicSource);
            $("#mechanicCombo").jqxDropDownList(
            {
                width: '100%',
                height: 30,
                itemHeight: 25,
                source: MechanicDataAdapter,
                selectedIndex: 0,
                displayMember: "MechanicName",
                valueMember: "MechanicId"
            });
        }

        function clearInfo(VehicleSelect) {
            VehicleSelect = VehicleSelect || false;

            var parent;

            var data = $('#partsGrid').jqxGrid('getrowdata', 0);

            if (VehicleSelect == false) {
                $("#vehiclesCombo").jqxDropDownList('selectIndex', 0);
            }
            $("#txtWorkOrder").val('');
            $("#txtYear").val('');
            $("#txtMake").val('');
            $("#txtModel").val('');
            $("#txtModelId").val('');
            $("#txtBusNumber").val('');
            $("#txtMileage").val('');
            $("#txtHours").val('');
            $("#txtVINNumber").val('');
            $("#complaint").val('');
            $("#resolution").val('');
            $('#partsGrid').jqxGrid('clear');
            $("#mechanicCombo").jqxDropDownList('selectIndex', 0);
            var parent = $("#pmiCombo").parent();
            $("#pmiCombo").jqxDropDownList('destroy');
            $("<div id='pmiCombo'></div>").appendTo(parent);
        }

    </script>

    <input type="text" id="vehicleLocation" style="display:none;" />
    <div id="VehicleWorkOrder" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row">
                <div class="col-sm-3">
                    
                </div>
                <div class="col-sm-3">
                    
                </div>
                <div class="col-sm-3">
                    
                </div>
                <div class="col-sm-3">
                    <label for="vehiclesCombo" style="color:white;font-size:medium;font-weight:bold;width:100px;padding:2px;text-shadow: 0px 0px 11px #000000;">*Vehicle</label><div id="vehiclesCombo"></div>
                </div>
            </div>
        </div>
    </div>

    
    <div style="display:none;">
        <input id="LocationId" type="text" value="0"  />
    </div>  
    
    <div class="formWrapper">
        <div class="box VehicleData">
            <div class="vehicleDataWrapper">
                <div class="WorkOrder"><div class="VehicleFormLabel">Work Order</div><input id="txtWorkOrder" type="text" disabled /></div>
                <div class="Mechanic"><div class="VehicleFormLabel" style="color:white;font-weight:bold;text-shadow: 0px 0px 11px #000000;">*Mechanic</div><div id="mechanicCombo"></div></div>
                <div class="Year"><div class="VehicleFormLabel">Year</div><input id="txtYear" type="text" disabled /></div>
                <div class="Make"><div class="VehicleFormLabel">Make</div><input id="txtMake" type="text" disabled /></div>
                <div class="Model"><div class="VehicleFormLabel">Model</div><input id="txtModel" type="text" disabled /><input id="txtModelId" type="text" style="display: none;" /><input id="txtFuelTypeId" type="text" style="display: none;" /></div>
                <div class="BusNumber"><div class="VehicleFormLabel">Bus Number</div><input id="txtBusNumber" type="text" disabled /></div>
                <div class="Mileage"><div class="VehicleFormLabel">Mileage</div><input id="txtMileage" type="text" disabled /></div>
                <div class="Hours"><div class="VehicleFormLabel">Hours</div><input id="txtHours" type="text" disabled /></div>
                <div class="Date"><div class="VehicleFormLabel" style="color:white;font-weight:bold;text-shadow: 0px 0px 11px #000000;">*Date</div><div id="workOrderDate"></div></div>
                <div class="VinNumber"><div class="VehicleFormLabel">VIN Number</div><input id="txtVINNumber" type="text" disabled /></div>
            </div>
        </div>
        <div class="box PMI">PMI<div id="pmiCombo"></div></div>
        <div class="box MaintenanceDesc">
            <div class="MaintenanceDescWrapper">
                <div class="Complaint"><div class="VehicleFormLabel" style="color:white;font-weight:bold;text-shadow: 0px 0px 11px #000000;">*Complaint</div><textarea rows="4" id="complaint" style="color:black"></textarea></div>
                <div class="Resolution"><div class="VehicleFormLabel" style="color:white;font-weight:bold;text-shadow: 0px 0px 11px #000000;">*Resolution</div><textarea rows="4" id="resolution" style="color:black"></textarea></div>
            </div>
        </div>
        <div class="box Parts"><div class="VehicleFormLabel" style="color:white;font-weight:bold;text-shadow: 0px 0px 11px #ffffff;">*Parts</div><div id="partsGrid"></div></div>
        <div class="box Submit"><input type="button" id="clear" value="Clear" /><input type="button" id="save" value="Save" style="float:right;" /></div>
    </div>
    
    <div id="popupLocation" style="display:none">
        <div>
            <div id="LocationCombo" style="float:left;"></div>
        </div>
    </div>
</asp:Content>

