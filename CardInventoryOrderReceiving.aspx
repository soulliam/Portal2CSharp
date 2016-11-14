<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="CardInventoryOrderReceiving.aspx.cs" Inherits="CardInventoryOrderReceiving" %>

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
    <script type="text/javascript" src="jqwidgets/jqxgrid.edit.js"></script>

    <script type="text/javascript">
        // ============= Initialize Page ==================== Begin

        $(document).ready(function () {

            loadGrid();

            //#region SetupButtons
            $("#btnReceive").jqxButton({ width: '100%', height: 26 });
            //#endregion

            $("#btnReceive").on("click", function (event) {
                var getselectedrowindexes = $('#jqxOrders').jqxGrid('getselectedrowindexes');
                if (getselectedrowindexes.length > 0) {
                    for (var index = 0; index < getselectedrowindexes.length; index++) {
                        var selectedRowData = $('#jqxOrders').jqxGrid('getrowdata', getselectedrowindexes[index]);
                        if (selectedRowData.CardDistributionActivityDescription == "Order Receive") {
                            alert("This is an 'Order Received' row!");
                            return;
                        } else {
                            var rows = $('#jqxOrders').jqxGrid('getrows');
                            for (var i = 0; i < rows.length; i++) {
                                var data = rows[i];
                                if (data.CardDistributionActivityDescription == "Order Receive" && data.StartingNumber == selectedRowData.StartingNumber && data.EndingNumber == selectedRowData.EndingNumber) {
                                    alert("This Order has been received.");
                                    return;
                                }
                            }
                        }
                        ReceiveOrder(selectedRowData.StartingNumber, selectedRowData.EndingNumber);
                    }
                    loadGrid();
                } else {

                    alert("No orders selected!");
                }
            });

            $('#jqxOrders').on('checkChange', function (event) {
                var args = event.args;
                if (args) {
                    // index represents the item's index.                          
                    var index = args.index;
                    if (args.checked) {
                        
                        var value = item.value;
                        for (var i = 0; i < source.length; i++) {
                            if (source[i] != label) {
                                $('#jqxListBox').jqxListBox('uncheckIndex', i);
                            }
                        }
                    }
                }
            });

        });

        // ============= Initialize Page ================== End

        function loadGrid()
        {
            var parent = $("#jqxOrders").parent();
            $("#jqxOrders").jqxGrid('destroy');
            $("<div id='jqxOrders'></div>").appendTo(parent);

            // loading order histor
            var url = $("#localApiDomain").val() + "CardDistHistorys/Get/-1";

            var source =
            {
                datafields: [
                    { name: 'CardHistoryId' },
                    { name: 'ActivityDate' },
                    { name: 'StartingNumber' },
                    { name: 'EndingNumber' },
                    { name: 'NumberOfCards' },
                    { name: 'CardDistributionActivityDescription' },
                    { name: 'RecordedBy' },
                    { name: 'ActivityId' },
                ],
                id: 'ManualEditId',
                type: 'Get',
                datatype: "json",
                url: url,
            };

            // creage jqxgrid
            $("#jqxOrders").jqxGrid(
            {
                //pageable: true,
                //pagermode: 'simple',
                //pagermode: 'advanced',
                //pagesize: 12,
                width: '100%',
                height: 500,
                source: source,
                selectionmode: 'singlerow',
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                ready: function () {
                    // create a filter group for the FirstName column.
                    var ActivityFilterGroup = new $.jqx.filter();
                    // operator between the filters in the filter group. 1 is for OR. 0 is for AND.
                    var filter_or_operator = 1;
                    // create a number filter with 'equal' condition.
                    var filtervalue = 1;
                    var filtercondition = 'equal';
                    var ActivityFilter1 = ActivityFilterGroup.createfilter('numericfilter', filtervalue, filtercondition);
                    // create second number filter with 'equal' condition.
                    filtervalue = '7';
                    filtercondition = 'equal';
                    var ActivityFilter2 = ActivityFilterGroup.createfilter('numericfilter', filtervalue, filtercondition);
                    // add the filters to the filter group.
                    ActivityFilterGroup.addfilter(filter_or_operator, ActivityFilter1);
                    ActivityFilterGroup.addfilter(filter_or_operator, ActivityFilter2);
                    $("#jqxOrders").jqxGrid('addfilter', 'ActivityId', ActivityFilterGroup);
                    $("#jqxOrders").jqxGrid('applyfilters');
                },
                columns: [
                       { text: 'CardHistoryId', datafield: 'CardHistoryId', hidden: true },
                       { text: 'ActivityDate', datafield: 'ActivityDate' },
                       { text: 'StartingNumber', datafield: 'StartingNumber' },
                       { text: 'EndingNumber', datafield: 'EndingNumber' },
                       { text: 'NumberOfCards', datafield: 'NumberOfCards' },
                       { text: 'Activity', datafield: 'CardDistributionActivityDescription' },
                       { text: 'User', datafield: 'RecordedBy' },
                       { text: 'ActivityId', datafield: 'ActivityId', hidden: true }
                ]
            });
        }

        function ReceiveOrder(StartingNumber, EndingNumber) {


            Date.prototype.toMMDDYYYYString = function () { return isNaN(this) ? 'NaN' : [this.getMonth() > 8 ? this.getMonth() + 1 : '0' + (this.getMonth() + 1), this.getDate() > 9 ? this.getDate() : '0' + this.getDate(), this.getFullYear()].join('/') }

            //alert(new Date().toMMDDYYYYString());

            var Quantity = parseInt(EndingNumber) - parseInt(StartingNumber);

            //alert('ADT:' + ActivityDateValue + 'AID:' + ActivityIdValue + 'F:' + $("#FirstCardValue").val() + ' Last:' + $("#LastCardValue").val() + ' Qt:' + $("#QuantityValue").val() + ' OCDt:' + $("#OrderConfirmationDateValue").val() + 'DP:' + $("#DistributionPointValue").val() + ' bus:' + $("#BusOrRepIDValue").val() + ' sft:' + $("#ShiftValue").val() + ' dt:' + new Date().toJSON() + ' Usr:' + $("#txtLoggedinUsername").val())
            $.post($("#localApiDomain").val() + "CardDistHistorys/Post",
                { 'ActivityDate': new Date().toMMDDYYYYString(), 'ActivityId': 7, 'StartingNumber': StartingNumber, 'EndingNumber': EndingNumber, 'NumberOfCards': Quantity, 'OrderConfirmationDate': '1/1/1900', 'DistributionPoint': 0, 'BusOrRepID': null, 'Shift': null, 'RecordDate': new Date().toMMDDYYYYString(), 'RecordedBy': $("#txtLoggedinUsername").val() },
                function (data, status) {
                    switch (status) {
                        case 'success':
                            $("#statusMessage").attr("class", "status");
                            $("#statusMessage").html('Cards were created received');
                            break;
                        default:
                            $("#statusMessage").attr("class", "warning");
                            $("#statusMessage").html('An Error occurred: ' + status + "\n Data:" + data);
                            break;
                    }
                }
            );


        }

    </script>

    <div id="CardInventoryOrder" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-3 col-sm-offset-9">
                            <div class="row search-size">
                                <div class="col-sm-8 col-sm-offset-4">
                                    <div class="row search-size">
                                        <div class="col-sm-12">
                                            <input type="button" id="btnReceive" value="Receive Orders" />
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

    <div class="container-fluid container-970">
        <div class="row ">
            <div class="col-sm-12">
                <div id="jqxOrders"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->

</asp:Content>

