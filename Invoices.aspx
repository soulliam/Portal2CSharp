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

    <script type="text/javascript">
        var group = '<%= Session["groupList"] %>';

        // ============= Initialize Page ==================== Begin
        var loading = true;

        $(document).ready(function () {

            loadLocationCombo();
            loadVendorCombo();
            loadCategoryCombo();

            $("#ProcessDate").jqxDateTimeInput({ width: '300px', height: '25px', formatString: "MM/dd/yyyy" });
            $("#InvoiceDate").jqxDateTimeInput({ width: '300px', height: '25px', formatString: "MM/dd/yyyy" });
            $("#newInvoice").jqxButton();
            $("#cancelInvoice").jqxButton();
            $("#saveInvoice").jqxButton();
            $("#findInvoice").jqxButton();

            $("#LocationCombo").on('bindingComplete', function (event) {
                $("#LocationCombo").jqxComboBox('insertAt', 'Pick a Location', 0);
                $("#LocationCombo").on('change', function (event) {
                    loadGrid();
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
                    selectionmode: 'singlerow',
                    columns: [
                            { text: 'InvoiceID', datafield: 'InvoiceID', hidden: true },
                            { text: 'Process Date', datafield: 'ProcessDate' },
                            { text: 'Invoice Date', datafield: 'InvoiceDate' },
                            { text: 'Vendor Name', datafield: 'VendorName' },
                            { text: 'Invoice Item', datafield: 'InvoiceItem' },
                            { text: 'Invoice Number', datafield: 'InvoiceNumber' },
                            { text: 'Invoice Amount #', datafield: 'InvoiceAmount' },
                            { text: 'Unit', datafield: 'Unit' },
                            { text: 'Category', datafield: 'ExpenseCategory' },
                            { text: 'ExpenseCategoryID', datafield: 'ExpenseCategoryID ' },
                            { text: 'VendorID', datafield: 'VendorID'}
                    ]
                });

            $("#newInvoice").on("click", function (event) {
                clearInvoice();

                openInvoicePopup();
            });

            $("#cancelInvoice").on("click", function (event) {
                $("#popupInvoice").jqxWindow('hide');
            });

            $("#saveInvoice").on("click", function (event) {
                if ($('#LocationCombo').val() == '') {
                    $("#popupInvoice").jqxWindow('hide');
                    swal("Pleas pick a Location");
                    return null;
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
                var thisInvoiceNumber = $('#InvoiceNumber').val();
                var thisUnit = $('#Unit').val();
                var thisInvoiceAmount = $('#InvoiceAmount').val();
                var thisExpenseCategoryID = $('#CategorySearchCombo').val().value;
                var thisLocationID = $('#LocationCombo').jqxComboBox('getSelectedItem').value;

                $.ajax({
                    type: "POST",
                    url: "http://localhost:52839/api/AFPFieldInvoices/PostInvoice/",
                    //url: $("#localApiDomain").val() + "AFPFieldInvoices/PostInvoice/",

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
                clearInvoice();
                var thisInvoiceNumber = $("#findInvoiceNumber").val();
                loadInvoiceByNumber(thisInvoiceNumber);
                
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

            //var url = $("#localApiDomain").val() + "AFPFieldInvoices/GetInvoices/" + thisLocationID;
            var url = "http://localhost:52839/api/AFPFieldInvoices/GetInvoices/" + thisLocationID;

            var source =
            {
                datafields: [
                    { name: 'InvoiceID' },
                    { name: 'ProcessDate' },
                    { name: 'InvoiceDate' },
                    { name: 'VendorName' },
                    { name: 'InvoiceItem' },
                    { name: 'InvoiceNumber' },
                    { name: 'InvoiceAmount' },
                    { name: 'Unit' },
                    { name: 'ExpenseCategory' },
                    { name: 'ExpenseCategoryID' },
                    { name: 'VendorID' }
                ],

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
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                selectionmode: 'singlerow',
                columns: [
                          { text: 'InvoiceID', datafield: 'InvoiceID', hidden: true },
                          { text: 'Process Date', datafield: 'ProcessDate' },
                          { text: 'Invoice Date', datafield: 'InvoiceDate' },
                          { text: 'Vendor Name', datafield: 'VendorName' },
                          { text: 'Invoice Item', datafield: 'InvoiceItem' },
                          { text: 'Invoice Number', datafield: 'InvoiceNumber' },
                          { text: 'Invoice Amount #', datafield: 'InvoiceAmount' },
                          { text: 'Unit', datafield: 'Unit' },
                          { text: 'Category', datafield: 'ExpenseCategory' },
                          { text: 'ExpenseCategoryID', datafield: 'ExpenseCategoryID', hidden: true },
                          { text: 'VendorID', datafield: 'VendorID', hidden: true }
                ]
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

        function loadVendorCombo() {

            // prepare the data
            var source = {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'VendorID' },
                    { name: 'VendorName' }
                ],
                //url: $("#localApiDomain").val() + "AFPFieldInvoices/GetVendors/",
                url: "http://localhost:52839/api/AFPFieldInvoices/GetVendors/",

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

        function loadCategoryCombo() {

            // prepare the data
            var source = {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'ExpenseCategoryID' },
                    { name: 'ExpenseCategory' }
                ],
                //url: $("#localApiDomain").val() + "AFPFieldInvoices/GetCategories/",
                url: "http://localhost:52839/api/AFPFieldInvoices/GetCategories/",

            };

            var categories = new Array();
            var dataAdapter = new $.jqx.dataAdapter(source, {
                autoBind: true,
                loadComplete: function (data) {
                    for (var i = 0; i < data.length; i++) {
                        categories.push({
                            label: data[i].name,
                            value: data[i].id
                        });
                    };
                }
            });

            // Create a jqxInput
            $("#CategorySearchCombo").jqxInput({ source: dataAdapter, placeHolder: "Pick a Category", displayMember: "ExpenseCategory", valueMember: "ExpenseCategoryID", width: 385, height: 25 });

        }


        function loadInvoice(thisInvoiceId) {

            //var url = $("#localApiDomain").val() + "AFPFieldInvoices/GetInvoicesByID/" + thisInvoiceId;
            var url = "http://localhost:52839/api/AFPFieldInvoices/GetInvoicesByID/" + thisInvoiceId;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                success: function (data) {$("#InvoiceId").val(data[0].InvoiceID);
                    $("#InvoiceDate").jqxDateTimeInput('setDate', data[0].InvoiceDate);
                    $("#ProcessDate").jqxDateTimeInput('setDate', data[0].ProcessDate);
                    $('#VendorSearchCombo').val(data[0].VendorName);
                    $('#InvoiceItem').val(data[0].InvoiceItem);
                    $('#InvoiceNumber').val(data[0].InvoiceNumber);
                    $('#Unit').val(data[0].Unit);
                    $('#InvoiceAmount').val(data[0].InvoiceAmount);
                    $('#CategorySearchCombo').val(data[0].ExpenseCategory);
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

            //var url = $("#localApiDomain").val() + "AFPFieldInvoices/GetInvoicesByNumber/" + thisInvoiceNumber;
            var url = "http://localhost:52839/api/AFPFieldInvoices/GetInvoicesByNumber/" + thisInvoiceNumber;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                async: false,
                success: function (data) {
                    dataLength = data.length;
                    if (data.length > 0) {
                        $("#InvoiceId").val(data[0].InvoiceID);
                        $("#InvoiceDate").jqxDateTimeInput('setDate', data[0].InvoiceDate);
                        $("#ProcessDate").jqxDateTimeInput('setDate', data[0].ProcessDate);
                        $('#VendorSearchCombo').val(data[0].VendorName);
                        $('#InvoiceItem').val(data[0].InvoiceItem);
                        $('#InvoiceNumber').val(data[0].InvoiceNumber);
                        $('#Unit').val(data[0].Unit);
                        $('#InvoiceAmount').val(data[0].InvoiceAmount);
                        $('#CategorySearchCombo').val(data[0].ExpenseCategory);
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
            $('#CategorySearchCombo').val("");
            $("#saveInvoice").val("Save");
            $("#VendorId").val(""); 
            $("#ExpenseCategoryID").val("");
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
            var thisVendorId = $('#VendorID').val();
            var thisInvoiceItem = $('#InvoiceItem').val();
            var thisInvoiceNumber = $('#InvoiceNumber').val();
            var thisUnit = $('#Unit').val();
            var thisInvoiceAmount = $('#InvoiceAmount').val();
            var thisExpenseCategoryID = $('#ExpenseCategoryID').val();
            var thisLocationID = $('#LocationCombo').jqxComboBox('getSelectedItem').value;

            $.ajax({
                type: "POST",
                url: "http://localhost:52839/api/AFPFieldInvoices/PutInvoice/",
                //url: $("#localApiDomain").val() + "AFPFieldInvoices/PutInvoice/",

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

    </script>
    
    <div id="Locations" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-2">
                    <div id="LocationCombo" style="width:250px;"></div>
                </div>
                <div class="col-sm-2">
                    <input type ="button" value="Find" id="findInvoice" /><input type="text" id="findInvoiceNumber" />
                </div>
                <div class="col-sm-2">
                </div>
                <div class="col-sm-2">
                </div>
                <div class="col-sm-2">
                </div>
                <div class="col-sm-2">
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
                                <label class="col-sm-3 col-md-4 control-label">Vendor:</label>
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
                                    <input type="Text" id="InvoiceAmount" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 col-md-4 control-label">Expense Category:</label>
                                <div class="col-sm-9 col-md-8">
                                     <input type="text" id="CategorySearchCombo" /><input type="text" id="ExpenseCategoryID" style ="display:none" />
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

</asp:Content>


