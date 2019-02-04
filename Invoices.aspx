<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="Invoices.aspx.cs" Inherits="Invoices" %>

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
    <script type="text/javascript" src="jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>    
    <script type="text/javascript" src="jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxnumberinput.js"></script>

    <script type="text/javascript">
        var group = '<%= Session["groupList"] %>';

        // ============= Initialize Page ==================== Begin
        var loading = true;
        var thisNegativeAmount = false;

        $(document).ready(function () {
            var lastKey;

            loadLocationCombo();
            loadCategoryCombo();
            loadFindCategoryCombo();

            $("#ProcessDate").jqxDateTimeInput({ width: '300px', height: '25px', formatString: "MM/dd/yyyy" });
            $("#InvoiceDate").jqxDateTimeInput({ width: '300px', height: '25px', formatString: "MM/dd/yyyy" });
            $("#newInvoice").jqxButton();
            $("#cancelInvoice").jqxButton();
            $("#saveInvoice").jqxButton();
            $("#findInvoice").jqxButton();
            $("#saveVendor").jqxButton();

            $(".search :input").attr("disabled", true);
            $('#findInvoice').jqxButton({ disabled: true });
            $('#newInvoice').jqxButton({ disabled: true });
            $('#findCategoryID').jqxComboBox({ disabled: true });

            $(document).on('keypress', function(e){
                lastKey = e.which;
            });

            $("#InvoiceAmount").attr("placeholder", "$");

            $("#InvoiceAmount").mouseup(function () {
                var amount = $("#InvoiceAmount").val();
                $("#InvoiceAmount").val("");
                $("#InvoiceAmount").val(amount);
            });

            $("#InvoiceAmount").on('focus', function () {
                var amount = $("#InvoiceAmount").val();
                $("#InvoiceAmount").val("");
                $("#InvoiceAmount").val(amount);
            });

            $("#InvoiceAmount").on('input', function (e) {
                var amount = $("#InvoiceAmount").val();

                if (amount.substring(amount.length - 1, amount.length) == '-') {
                    thisNegativeAmount = true;
                } else if (amount == '') {
                    thisNegativeAmount = false;
                    $("#InvoiceAmountHold").val('');
                    $("#InvoiceAmount").val('');
                } else if (amount.substring(1, amount.length) == '-0.0') {
                    thisNegativeAmount = false;
                    $("#InvoiceAmountHold").val('');
                    $("#InvoiceAmount").val('');
                }

                if (isNaN(amount.substring(amount.length - 1, amount.length))) {
                    $("#InvoiceAmount").val(amount.substring(0, amount.length - 1));
                    return;
                }

                if (lastKey == 8) {
                    var holdAmount = $("#InvoiceAmountHold").val();

                    holdAmount = holdAmount.substring(0, holdAmount.length - 1);
                    $("#InvoiceAmountHold").val(holdAmount);
                    amount = ($("#InvoiceAmountHold").val() / 100).toFixed(2);
                    
                } else {
                    var holdAmount = $("#InvoiceAmountHold").val();

                    $("#InvoiceAmountHold").val(holdAmount.toString() + amount.substring(amount.length - 1, amount.length));

                    amount = ($("#InvoiceAmountHold").val() / 100).toFixed(2);
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

                if (thisNegativeAmount == false) {
                    $("#InvoiceAmount").val("$" + amount.toString());
                } else {
                    $("#InvoiceAmount").val("$-" + amount.toString());
                }

                
            });

            $("#LocationCombo").on('bindingComplete', function (event) {
                $("#LocationCombo").jqxComboBox('insertAt', 'Pick a Location', 0);
                $("#LocationCombo").on('change', function (event) {
                    //loadGrid();
                    var thisLocationID = $('#LocationCombo').jqxComboBox('getSelectedItem').value;
                    loadVendorCombo(thisLocationID);
                    loadFindVendorCombo(thisLocationID);
                    $(".search :input").attr("disabled", false);
                    $('#findInvoice').jqxButton({ disabled: false });
                    $('#newInvoice').jqxButton({ disabled: false });
                    $('#findCategoryID').jqxComboBox({ disabled: false });
                });
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
                    rowsheight: 35,
                    sortable: true,
                    altrows: true,
                    filterable: true,
                    selectionmode: 'checkbox',
                    showtoolbar: true,
                    columns: [
                            { text: 'InvoiceID', datafield: 'InvoiceID', hidden: true },
                            { text: 'Process Date', datafield: 'ProcessDate' },
                            { text: 'Invoice Date', datafield: 'InvoiceDate' },
                            { text: 'Vendor Name', datafield: 'VendorName' },
                            { text: 'Invoice Item', datafield: 'InvoiceItem' },
                            { text: 'Invoice Number', datafield: 'InvoiceNumber' },
                            { text: 'Invoice Amount #', datafield: 'InvoiceAmount', cellsformat: 'c2' },
                            { text: 'Unit', datafield: 'Unit' },
                            { text: 'Category', datafield: 'ExpenseCategory' },
                            { text: 'ExpenseCategoryID', datafield: 'ExpenseCategoryID ' },
                            { text: 'VendorID', datafield: 'VendorID'}
                    ],
                    rendertoolbar: function (toolbar) {
                        var me = this;
                        var container = $("<div style='margin: 5px;'></div>");
                        toolbar.append(container);
                        container.append('<input id="deleterowbutton" type="button" value="Delete Invoice" /></div>');
                        $("#deleterowbutton").jqxButton({ width: 150 });
                        $("#deleterowbutton").on('click', function () {
                            var rowindex = $('#jqxgrid').jqxGrid('getselectedrowindex');
                            var thisRowdata = $('#jqxgrid').jqxGrid('getrowdata', rowindex);
                            DeleteInvoice(thisRowdata.InvoiceID);
                        });
                    }
                });

            $("#newInvoice").on("click", function (event) {
                clearInvoice();

                openInvoicePopup();
            });

            $("#cancelInvoice").on("click", function (event) {
                $("#popupInvoice").jqxWindow('hide');
            });

            $("#saveVendor").on("click", function (event) {
                saveVendor();
            });

            $("#saveInvoice").on("click", function (event) {
                if ($('#LocationCombo').val() == '') {
                    $("#popupInvoice").jqxWindow('hide');
                    swal("Pleas pick a Location");
                    return null;
                }

                if (checkUndefinedNaN($('#VendorSearchCombo').val().value) <= 0) {
                    $("#popupInvoice").jqxWindow('hide');
                    swal("Please pick a vendor!").then(function () {
                        $("#popupInvoice").jqxWindow('show');
                    });
                    return;
                }

                if ($('#InvoiceItem').val() == '') {
                    $("#popupInvoice").jqxWindow('hide');
                    swal("Enter an invoice item!").then(function () {
                        $("#popupInvoice").jqxWindow('show');
                    });
                    return;
                }

                if ($('#InvoiceNumber').val() == '') {
                    $("#popupInvoice").jqxWindow('hide');
                    swal("Enter an Invoice Number!").then(function () {
                        $("#popupInvoice").jqxWindow('show');
                    });
                    return;
                }

                if ($('#CategorySearchCombo').jqxComboBox('getSelectedItem').value <= 0) {
                    $("#popupInvoice").jqxWindow('hide');
                    swal("Please pick a category!").then(function () {
                        $("#popupInvoice").jqxWindow('show');
                    });
                    return;
                }

                var thisInvoiceId = $("#InvoiceId").val();

                if ($("#saveInvoice").val() == "Edit")
                {
                    editInvoice(thisInvoiceId);
                    return null;
                };

                
                var thisProcessDate = $("#ProcessDate").val();
                var thisInvoiceDate = $("#InvoiceDate").val();
                var thisVendorId = $('#VendorSearchCombo').val().value;
                var thisInvoiceItem = $('#InvoiceItem').val();
                thisInvoiceItem = thisInvoiceItem.replace(/'/g, "''");
                var thisInvoiceNumber = $('#InvoiceNumber').val();
                var thisUnit = $('#Unit').val();
                var thisInvoiceAmount = $('#InvoiceAmount').val();
                var thisExpenseCategoryID = $('#CategorySearchCombo').jqxComboBox('getSelectedItem').value;
                var thisLocationID = $('#LocationCombo').jqxComboBox('getSelectedItem').value;

                

                thisInvoiceAmount = thisInvoiceAmount.replace("$", "");

                if (thisInvoiceAmount == "") {
                    thisInvoiceAmount = "0";
                }

                $.ajax({
                    type: "POST",
                    //url: "http://localhost:52839/api/AFPFieldInvoices/PostInvoice/",
                    url: $("#localApiDomain").val() + "AFPFieldInvoices/PostInvoice/",

                    data: {
                        "InvoiceId": thisInvoiceId,
                        "ProcessDate": thisProcessDate,
                        "InvoiceDate": thisInvoiceDate,
                        "VendorID": thisVendorId,
                        "InvoiceItem": thisInvoiceItem,
                        "InvoiceNumber": thisInvoiceNumber,
                        "Unit": thisUnit,
                        "InvoiceAmount": thisInvoiceAmount,
                        "ExpenseCategoryID": thisExpenseCategoryID,
                        "LocationID": thisLocationID
                    },
                    dataType: "json",
                    success: function (Response) {
                        $("#popupInvoice").jqxWindow('hide');
                        loadGrid();
                        swal("Saved!");
                    },
                    error: function (request, status, error) {
                        $("#popupInvoice").jqxWindow('hide');
                        swal(error);
                    }
                });
            });

            $("#findInvoice").on("click", function (event) {
                try {
                    clearInvoice();
                    var thisInvoiceNumber = $("#findInvoiceNumber").val();
                    //loadInvoiceByNumber(thisInvoiceNumber);
                    loadGrid()
                }
                catch (err) {
                    swal(err);
                }
            });
            
            Security();

        });
        // ============= Initialize Page ================== End

        //loads main airport grid
        function loadGrid() {
            try {
                var parent = $("#jqxgrid").parent();
                $("#jqxgrid").jqxGrid('destroy');
                $("<div id='jqxgrid'></div>").appendTo(parent);

                var thisLocationID = $('#LocationCombo').jqxComboBox('getSelectedItem').value;
                var processDate = "null";
                var invoiceDate = "null";

                var data = {
                    "InvoiceNumber": $("#findInvoiceNumber").val(),
                    "InvoiceItem": $("#findInvoiceItem").val(),
                    "VendorID": $('#findVendorID').val().value,
                    "LocationID": thisLocationID
                };

                if ($('#findCategoryID').jqxComboBox('selectedIndex') > 0) {
                    data.ExpenseCategoryID = $("#findCategoryID").jqxComboBox('getSelectedItem').value;
                }

                if ($("#findProcessDate").val() != '') {
                    if (isValidDate($("#findProcessDate").val()) == "Invalid Date") {
                        swal("Process Date is not a valid date.")
                        return;
                    }
                    data.ProcessDate = $("#findProcessDate").val()
                }

                if ($("#findInvoiceDate").val() != '') {
                    if (isValidDate($("#findInvoiceDate").val()) == "Invalid Date") {
                        swal("Invoice Date is not a valid date.")
                        return;
                    }
                    data.InvoiceDate = $("#findInvoiceDate").val();
                }

                var url = $("#localApiDomain").val() + "AFPFieldInvoices/SearchInvoices/";
                //var url = "http://localhost:52839/api/AFPFieldInvoices/SearchInvoices/";

                var source =
                {
                    datafields: [
                        { name: 'InvoiceID' },
                        { name: 'ProcessDate' },
                        { name: 'InvoiceDate' },
                        { name: 'VendorName' },
                        { name: 'InvoiceItem' },
                        { name: 'InvoiceNumber' },
                        { name: 'InvoiceAmount', type: 'float' },
                        { name: 'Unit' },
                        { name: 'ExpenseCategory' },
                        { name: 'ExpenseCategoryID' },
                        { name: 'VendorID' }
                    ],

                    type: 'POST',
                    datatype: "json",
                    data: data,
                    url: url,
                };

                // creage jqxgrid
                $("#jqxgrid").jqxGrid(
                {
                    width: '100%',
                    height: 500,
                    source: source,
                    rowsheight: 35,
                    sortable: true,
                    altrows: true,
                    filterable: true,
                    selectionmode: 'checkbox',
                    showstatusbar: true,
                    showaggregates: true,
                    showtoolbar: true,
                    columns: [
                              { text: 'InvoiceID', datafield: 'InvoiceID', hidden: true },
                              { text: 'Process Date', datafield: 'ProcessDate', cellsrenderer: DateRender },
                              { text: 'Invoice Date', datafield: 'InvoiceDate', cellsrenderer: DateRender },
                              { text: 'Vendor Name', datafield: 'VendorName' },
                              { text: 'Invoice Item', datafield: 'InvoiceItem' },
                              { text: 'Invoice Number', datafield: 'InvoiceNumber' },
                              {
                                  text: 'Invoice Amount #', datafield: 'InvoiceAmount', cellsformat: 'c2',
                                  aggregates: ['sum'],
                                  aggregatesrenderer: function (aggregates) {
                                      var renderstring = '<div style="float: left; margin: 4px; overflow: hidden;">Total: ' + aggregates.sum + '</div>';
                                      return renderstring;
                                  }
                              },
                              { text: 'Unit', datafield: 'Unit' },
                              { text: 'Category', datafield: 'ExpenseCategory' },
                              { text: 'ExpenseCategoryID', datafield: 'ExpenseCategoryID', hidden: true },
                              { text: 'VendorID', datafield: 'VendorID', hidden: true }
                    ],
                    rendertoolbar: function (toolbar) {
                        var me = this;
                        var container = $("<div style='margin: 5px;'></div>");
                        toolbar.append(container);
                        container.append('<input id="deleterowbutton" type="button" value="Delete Invoice" /></div>');
                        $("#deleterowbutton").jqxButton({ width: 150 });
                        $("#deleterowbutton").on('click', function () {
                            var rowindex = $('#jqxgrid').jqxGrid('getselectedrowindex');
                            var thisRowdata = $('#jqxgrid').jqxGrid('getrowdata', rowindex);
                            DeleteInvoice(thisRowdata.InvoiceID);
                        });
                    }
                });

                //defines search grid double click to load Invoice info
                $("#jqxgrid").on('rowdoubleclick', function (event) {
                    clearInvoice();

                    $("#saveInvoice").val("Edit");

                    var row = event.args.rowindex;
                    var dataRecord = $("#jqxgrid").jqxGrid('getrowdata', row);

                    loadInvoice(dataRecord.InvoiceID);

                    openInvoicePopup();
                });
            }
            catch (err) {
                swal(err);
            }
        }

        function DeleteInvoice(thisInvoiceId) {
            var url = $("#localApiDomain").val() + "AFPFieldInvoices/DeleteInvoice/" + thisInvoiceId;
            //var url = "http://localhost:52839/api/AFPFieldInvoices/DeleteInvoice/" + thisInvoiceId

            $.ajax({
                type: "GET",
                //url: $("#localApiDomain").val() + "Vehicles/GetVehicleMileageByDate/",
                url: url,
                dataType: "json",
                success: function (thisData) {
                    swal(thisData.toString());
                    loadGrid();
                },
                error: function (request, status, error) {
                    alert(error);
                }
            });
        }

        function loadLocationCombo() {
            var locationString = $("#userLocation").val();
            var locationResult = locationString.split(",");

            var thisLocationString = "";
            for (i = 0; i < locationResult.length; i++) {
                if (i == locationResult.length - 1) {
                    thisLocationString += locationResult[i];
                }
                else {
                    thisLocationString += locationResult[i] + ",";
                }

            }

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
                url: $("#localApiDomain").val() + "Locations/LocationByLocationIds/" + thisLocationString

            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#LocationCombo").jqxComboBox(
            {
                theme: 'shinyblack',
                width: '100%',
                height: 24,
                source: locationDataAdapter,
                selectedIndex: 0,
                autoDropDownHeight: true,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });
        }

        function loadVendorCombo(thisLocationID) {

            // prepare the data
            var source = {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'VendorID' },
                    { name: 'VendorName' }
                ],
                url: $("#localApiDomain").val() + "AFPFieldInvoices/GetVendors/" + thisLocationID,
                //url: "http://localhost:52839/api/AFPFieldInvoices/GetVendors/" + thisLocationID,

            };
            var vendors = new Array();
            var dataAdapter = new $.jqx.dataAdapter(source, {
                autoBind: true,
                loadComplete: function (data) {
                    for (var i = 0; i < data.length; i++) {
                        vendors.push({
                            label: data[i].name,
                            value: data[i].id
                        });
                    };
                }
            });

            // Create a jqxInput
            $("#VendorSearchCombo").jqxInput({ source: dataAdapter, placeHolder: "Pick a Vendor", displayMember: "VendorName", valueMember: "VendorID", width: 385, height: 25 });
          
        }

        function loadEditVendorCombo(thisLocationID) {

            // prepare the data
            var source = {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'VendorID' },
                    { name: 'VendorName' }
                ],
                url: $("#localApiDomain").val() + "AFPFieldInvoices/GetVendors/" + thisLocationID,
                //url: "http://localhost:52839/api/AFPFieldInvoices/GetVendors/" + thisLocationID,

            };
            var vendors = new Array();
            var dataAdapter = new $.jqx.dataAdapter(source, {
                autoBind: true,
                loadComplete: function (data) {
                    for (var i = 0; i < data.length; i++) {
                        vendors.push({
                            label: data[i].name,
                            value: data[i].id
                        });
                    };
                }
            });

            // Create a jqxInput
            $("#VendorEditSearch").jqxInput({ source: dataAdapter, placeHolder: "Search a Vendor", displayMember: "VendorName", valueMember: "VendorID", width: 385, height: 25 });

        }

        function loadFindVendorCombo(thisLocationID) {

            // prepare the data
            var source = {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'VendorID' },
                    { name: 'VendorName' }
                ],
                url: $("#localApiDomain").val() + "AFPFieldInvoices/GetVendors/" + thisLocationID,
                //url: "http://localhost:52839/api/AFPFieldInvoices/GetVendors/" + thisLocationID,

            };
            var vendors = new Array();
            var dataAdapter = new $.jqx.dataAdapter(source, {
                autoBind: true,
                loadComplete: function (data) {
                    for (var i = 0; i < data.length; i++) {
                        vendors.push({
                            label: data[i].name,
                            value: data[i].id
                        });
                    };
                }
            });

            // Create a jqxInput
            $("#findVendorID").jqxInput({ source: dataAdapter, placeHolder: "Pick a Vendor", displayMember: "VendorName", valueMember: "VendorID", width: 385, height: 25 });

        }

        function loadCategoryCombo() {

            var source =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'ExpenseCategory' },
                    { name: 'ExpenseCategoryID' }
                ],
                loadComplete: function () {
                    
                },
                url: $("#localApiDomain").val() + "AFPFieldInvoices/GetCategories/",
                //url: "http://localhost:52839/api/AFPFieldInvoices/GetCategories/",

            };

            var categoryDataAdapter = new $.jqx.dataAdapter(source);
            $("#CategorySearchCombo").jqxComboBox(
            {
                theme: 'shinyblack',
                width: '100%',
                height: 24,
                source: categoryDataAdapter,
                selectedIndex: 0,
                displayMember: "ExpenseCategory",
                valueMember: "ExpenseCategoryID"
            });

            $("#CategorySearchCombo").on('bindingComplete', function (event) {
                $("#CategorySearchCombo").jqxComboBox('insertAt', '', 0);
                $("#CategorySearchCombo").jqxComboBox('selectIndex', 0);
            });

        }

        function loadFindCategoryCombo() {

            var source =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'ExpenseCategory' },
                    { name: 'ExpenseCategoryID' }
                ],
                loadComplete: function () {

                },
                url: $("#localApiDomain").val() + "AFPFieldInvoices/GetCategories/",

            };

            var categoryDataAdapter = new $.jqx.dataAdapter(source);
            $("#findCategoryID").jqxComboBox(
            {
                theme: 'shinyblack',
                width: '100%',
                height: 24,
                source: categoryDataAdapter,
                selectedIndex: 0,
                displayMember: "ExpenseCategory",
                valueMember: "ExpenseCategoryID"
            });

            $("#findCategoryID").on('bindingComplete', function (event) {
                $("#findCategoryID").jqxComboBox('insertAt', 'Select Category', 0);
                $("#findCategoryID").jqxComboBox('selectIndex', 0);
            });

        }


        function loadInvoice(thisInvoiceId) {

            var url = $("#localApiDomain").val() + "AFPFieldInvoices/GetInvoicesByID/" + thisInvoiceId;
            //var url = "http://localhost:52839/api/AFPFieldInvoices/GetInvoicesByID/" + thisInvoiceId;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                success: function (data) {$("#InvoiceId").val(data[0].InvoiceID);
                    $("#InvoiceDate").jqxDateTimeInput('setDate', new Date(data[0].InvoiceDate));
                    $("#ProcessDate").jqxDateTimeInput('setDate', new Date(data[0].ProcessDate));
                    $('#VendorSearchCombo').val(data[0].VendorName);
                    $('#InvoiceItem').val(data[0].InvoiceItem);
                    $('#InvoiceNumber').val(data[0].InvoiceNumber);
                    $('#Unit').val(data[0].Unit);
                    $('#InvoiceAmount').val(data[0].InvoiceAmount);
                    var item = $("#CategorySearchCombo").jqxComboBox('getItemByValue', data[0].ExpenseCategoryID);
                    $("#CategorySearchCombo").jqxComboBox('selectItem', item);
                    $("#VendorID").val(data[0].VendorID);
                    $("#ExpenseCategoryID").val(data[0].ExpenseCategoryID);
                },
                error: function (request, status, error) {
                    swal("There was an issue getting the information.");
                }
            });
            
        }

        function loadInvoiceByNumber(thisInvoiceNumber) {
            var dataLength = 0;

            thisInvoiceNumber = thisInvoiceNumber.replace(/\//g, '~');

            var url = $("#localApiDomain").val() + "AFPFieldInvoices/GetInvoicesByNumber/" + thisInvoiceNumber;
            //var url = "http://localhost:52839/api/AFPFieldInvoices/GetInvoicesByNumber/" + thisInvoiceNumber;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                async: false,
                success: function (data) {
                    dataLength = data.length;
                    if (data.length > 0) {
                        $("#InvoiceId").val(data[0].InvoiceID);
                        $("#InvoiceDate").jqxDateTimeInput('setDate', new Date(data[0].InvoiceDate));
                        $("#ProcessDate").jqxDateTimeInput('setDate', new Date(data[0].ProcessDate));
                        $('#VendorSearchCombo').val(data[0].VendorName);
                        $('#InvoiceItem').val(data[0].InvoiceItem);
                        $('#InvoiceNumber').val(data[0].InvoiceNumber);
                        $('#Unit').val(data[0].Unit);
                        $('#InvoiceAmount').val(data[0].InvoiceAmount);
                        var item = $("#CategorySearchCombo").jqxComboBox('getItemByValue', data[0].ExpenseCategoryID);
                        $("#CategorySearchCombo").jqxComboBox('selectItem', item);
                        $("#VendorID").val(data[0].VendorID);
                        $("#ExpenseCategoryID").val(data[0].ExpenseCategoryID);
                    }
                   
                }
            })
            .done(function () { if (dataLength > 0) { openInvoicePopup(); } else { swal("Not Found"); } })
            .fail(function () { swal("The was an error connecting to the DB"); })
            .always(function () {});

            
        }

        function clearInvoice() {
            var d = new Date();

            $("#InvoiceId").val(0);
            $("#InvoiceDate").jqxDateTimeInput('setDate', d);
            $("#ProcessDate").jqxDateTimeInput('setDate', d);
            $('#VendorSearchCombo').val("");
            $('#InvoiceItem').val("");
            $('#InvoiceNumber').val("");
            $('#Unit').val("");
            $('#InvoiceAmount').val("");
            $("#CategorySearchCombo").jqxComboBox('selectIndex', 0);
            $("#saveInvoice").val("Save");
            $("#VendorId").val(""); 
            $("#ExpenseCategoryID").val("");
            $("#InvoiceAmountHold").val("");
        }

        function openInvoicePopup() {
            $("#popupInvoice").css('display', 'block');
            $("#popupInvoice").css('visibility', 'hidden');

            $("#popupInvoice").jqxWindow({ position: { x: '25%', y: '7%' } });
            $('#popupInvoice').jqxWindow({ draggable: true });
            $('#popupInvoice').jqxWindow({ isModal: true });
            $('#popupInvoice').jqxWindow({ resizable: false });
            $("#popupInvoice").css("visibility", "visible");
            $('#popupInvoice').jqxWindow({ height: 525, width: 525 });
            $('#popupInvoice').jqxWindow({ showCloseButton: true });
            $('#popupInvoice').jqxWindow({ animationType: 'combined' });
            $('#popupInvoice').jqxWindow({ showAnimationDuration: 300 });
            $('#popupInvoice').jqxWindow({ closeAnimationDuration: 500 });
            $("#popupInvoice").jqxWindow('open');
        }

        function editInvoice(thisInvoiceId) {
            var thisInvoiceId = $("#InvoiceId").val();
            var thisProcessDate = $("#ProcessDate").val();
            var thisInvoiceDate = $("#InvoiceDate").val();
            var thisVendorId = $('#VendorSearchCombo').val().value;
            var thisInvoiceItem = $('#InvoiceItem').val();
            var thisInvoiceNumber = $('#InvoiceNumber').val();
            var thisUnit = $('#Unit').val();
            var thisInvoiceAmount = $('#InvoiceAmount').val();
            var thisExpenseCategoryID = $('#CategorySearchCombo').jqxComboBox('getSelectedItem').value;
            var thisLocationID = $('#LocationCombo').jqxComboBox('getSelectedItem').value;

            $.ajax({
                type: "POST",
                //url: "http://localhost:52839/api/AFPFieldInvoices/PutInvoice/",
                url: $("#localApiDomain").val() + "AFPFieldInvoices/PutInvoice/",

                data: {
                    "InvoiceId": thisInvoiceId,
                    "ProcessDate": thisProcessDate,
                    "InvoiceDate": thisInvoiceDate,
                    "VendorID": thisVendorId,
                    "InvoiceItem": thisInvoiceItem,
                    "InvoiceNumber": thisInvoiceNumber,
                    "Unit": thisUnit,
                    "InvoiceAmount": thisInvoiceAmount,
                    "ExpenseCategoryID": thisExpenseCategoryID,
                    "LocationID": thisLocationID
                },
                dataType: "json",
                success: function (Response) {
                    $("#popupInvoice").jqxWindow('hide');
                    loadGrid();
                    swal("Saved!");
                },
                error: function (request, status, error) {
                    $("#popupInvoice").jqxWindow('hide');
                    swal(error);
                }
            });
        };

        function openVendorEdit() {
            var thisLocationID = $('#LocationCombo').jqxComboBox('getSelectedItem').value;
            loadEditVendorCombo(thisLocationID);

            $("#popupVendor").css('display', 'block');
            $("#popupVendor").css('visibility', 'hidden');
            var offset = $("#jqxgrid").offset();
            $("#popupVendor").jqxWindow({ position: { x: '25%', y: '30%' } });
            $('#popupVendor').jqxWindow({ resizable: false });
            $('#popupVendor').jqxWindow({ draggable: true });
            $('#popupVendor').jqxWindow({ isModal: true });
            $("#popupVendor").css("visibility", "visible");
            $('#popupVendor').jqxWindow({ height: '250px', width: '25%' });
            $('#popupVendor').jqxWindow({ minHeight: '250px', minWidth: '25%' });
            $('#popupVendor').jqxWindow({ maxHeight: '500px', maxWidth: '25%' });
            $('#popupVendor').jqxWindow({ showCloseButton: true });
            $('#popupVendor').jqxWindow({ animationType: 'combined' });
            $('#popupVendor').jqxWindow({ showAnimationDuration: 300 });
            $('#popupVendor').jqxWindow({ closeAnimationDuration: 500 });
            $("#popupVendor").jqxWindow('open');
        }

        function saveVendor() {
            if ($("#VendorEditSearch").val().value > 0) {
                $("#VendorEditSearch").val().value = 0;
                $("#VendorEditSearch").val('');
                alert("This vendor exist already.");
                return;
            }

            var thisVendorName = $("#VendorEditSearch").val();
            var thisLocationID = $('#LocationCombo').jqxComboBox('getSelectedItem').value;

            $.ajax({
                type: "POST",
                //url: "http://localhost:52839/api/AFPFieldInvoices/InsertVendor/",
                url: $("#localApiDomain").val() + "AFPFieldInvoices/InsertVendor/",

                data: {
                    "VendorName": thisVendorName,
                    "LocationId": thisLocationID
                },
                dataType: "json",
                success: function (Response) {
                    var thisLocationID = $('#LocationCombo').jqxComboBox('getSelectedItem').value;
                    $("#VendorEditSearch").val('');
                    loadEditVendorCombo(thisLocationID);
                    loadVendorCombo(thisLocationID);
                    $("#popupVendor").jqxWindow('hide');
                    alert("Saved!");
                },
                error: function (request, status, error) {
                    alert(error);
                }
            });
        }

    </script>
    
    <div id="Locations" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-2">
                    <div id="LocationCombo" style="width:250px;"></div>
                </div>
                <div class="col-sm-2 search">
                    <input type="text" id="findInvoiceNumber" placeholder="Invoice Number" /><input type="text" id="findProcessDate" placeholder="Process Date mm/dd/yyyy" />
                </div>
                <div class="col-sm-2 search">
                    <input type="text" id="findInvoiceDate" placeholder="Invoice Date mm/dd/yyyy" /><div id="findCategoryID"></div>
                </div>
                <div class="col-sm-2 search">
                    <input type="text" id="findVendorID" placeholder="Vendor" /><input type="text" id="findInvoiceItem" placeholder="Invoice Description" />
                </div>
                <div class="col-sm-2 search">
                    <input type ="button" value="Find" id="findInvoice" />
                </div>
                <div class="col-sm-2 search">
                    <input type ="button" value="New Invoice" id="newInvoice" />
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

    <%-- html for Invoice create --%>
    <div id="popupInvoice" style="display:none;">
        <div style="background-color:#ccc;width:100%;border-radius:9px 9px 0px 0px;font-weight:bold;text-align:center">Invoice</div>
        <div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <input type="text" id="InvoiceId" style="display: none" />
                                <label class="col-sm-3 col-md-4 control-label">Process Date:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div  id="ProcessDate"></div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 col-md-4 control-label">Invoice Date:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div  id="InvoiceDate"></div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 col-md-4 control-label"><a href="javascript:void(0);" onclick="openVendorEdit();">Vendor</a>:</label>
                                <div class="col-sm-9 col-md-8">
                                     <input type="text" id="VendorSearchCombo" /><input type="text" id="VendorID" style ="display:none" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 col-md-4 control-label">Invoice Item:</label>
                                <div class="col-sm-9 col-md-8" style="margin-top: 10px;">
                                    <textarea id="InvoiceItem" rows="6" cols="35"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 col-md-4 control-label">Unit:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="Text" id="Unit" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 col-md-4 control-label">Invoice Number:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="Text" id="InvoiceNumber" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 col-md-4 control-label">Invoice Amount:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" id="InvoiceAmount" />
                                    <input type="text" id="InvoiceAmountHold" style="display:none" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 col-md-4 control-label">Expense Category:</label>
                                <div class="col-sm-9 col-md-8">
                                     <div id="CategorySearchCombo"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="top-divider">
                            <div class="col-sm-2 col-md-3">
                            </div>
                            <div class="col-sm-4 col-md-3">
                                <input type="button" id="saveInvoice" value="Save" />
                            </div>
                            <div class="col-sm-4 col-md-3">
                                <input type="button" id="cancelInvoice" value="Cancel" />
                            </div>
                            <div class="col-sm-2 col-md-3">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

     <%-- html for popup edit Vendor --%>
    <div id="popupVendor" style="display:none;" oncontextmenu='return false;'>
        <div>Location Image</div>
        <div>
            <div class="modal-body">
                <input type="text" id="VendorEditSearch" />
            </div>
            <div class="modal-body">
                <input type="button" id="saveVendor" value="Save" />
            </div>
        </div>
    </div>

</asp:Content>


