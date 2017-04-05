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
        var group = '<%= Session["groupList"] %>';

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
                        if (selectedRowData.ReceviedBy != null) {
                            alert("This order has been received!");
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
                        ReceiveOrder(selectedRowData.StartingNumber, selectedRowData.EndingNumber, selectedRowData.CardHistoryId);
                    }
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

            Security();

        });

        // ============= Initialize Page ================== End

        function loadGrid()
        {
            var parent = $("#jqxOrders").parent();
            $("#jqxOrders").jqxGrid('destroy');
            $("<div id='jqxOrders'></div>").appendTo(parent);

            // loading order histor
            var url = $("#localApiDomain").val() + "CardDistHistorys/Get/-2";
            //var url = "http://localhost:52839/api/CardDistHistorys/Get/-2";

            var source =
            {
                datafields: [
                    { name: 'CardHistoryId' },
                    { name: 'ActivityDate' },
                    { name: 'StartingNumber' },
                    { name: 'EndingNumber' },
                    { name: 'NumberOfCards' },
                    { name: 'RecordedBy' },
                    { name: 'RecordedBy' },
                    { name: 'ActivityId' },
                    { name: 'ReceivedDate' },
                    { name: 'ReceviedBy' },
                ],
                type: 'Get',
                datatype: "json",
                url: url,
            };

            var receiveDateRenderer = function (row, columnfield, value, defaulthtml, columnproperties) {
                if (value == '0001-01-01T00:00:00') {
                    return '<div style="margin-top: 10px;margin-left: 5px">&nbsp;</div>'
                } else {
                    var thisDateTime = value;

                    if (thisDateTime != "") {
                        thisDateTime = thisDateTime.split("T");

                        var thisDate = thisDateTime[0].split("-");

                        var newDate = '<div style="margin-top: 10px;margin-left: 5px">' + thisDate[1] + "/" + thisDate[2] + "/" + thisDate[0] + '</div>';

                        return newDate;
                    }
                }
            }

            var padCard = function (row, columnfield, value, defaulthtml, columnproperties) {
                var newValue = padNumber(value, 8, '0');
                return '<div style="margin-top: 10px;margin-left: 5px">' + newValue + '</div>';
            }

            // creage jqxgrid
            $("#jqxOrders").jqxGrid(
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
                       { text: 'CardHistoryId', datafield: 'CardHistoryId' },
                       { text: 'Order Date', datafield: 'ActivityDate', cellsrenderer: DateRender },
                       { text: 'Starting Card', datafield: 'StartingNumber', cellsrenderer: padCard },
                       { text: 'Ending Card', datafield: 'EndingNumber', cellsrenderer: padCard },
                       { text: 'Number Of Cards', datafield: 'NumberOfCards', cellsformat: 'n' },
                       { text: 'Order By', datafield: 'RecordedBy' },
                       { text: 'Received Date', datafield: 'ReceivedDate', cellsrenderer: receiveDateRenderer },
                       { text: 'Received By', datafield: 'ReceviedBy' },
                       { text: 'ActivityId', datafield: 'ActivityId', hidden: true }
                ]
            });
        }

        function ReceiveOrder(StartingNumber, EndingNumber, CardHistoryId) {

            var myDate = new Date();

            myDate = DateTimeFormat(myDate);

            var Quantity = parseInt(EndingNumber) - parseInt(StartingNumber);

            
            $.post($("#localApiDomain").val() + "CardDistHistorys/Post",
            //$.post("http://localhost:52839/api/CardDistHistorys/Post",
                { 'ActivityDate': myDate, 'ActivityId': 3, 'StartingNumber': StartingNumber, 'EndingNumber': EndingNumber, 'NumberOfCards': Quantity, 'OrderConfirmationDate': '1/1/1900', 'DistributionPoint': "", 'BusOrRepID': null, 'Shift': null, 'RecordDate': myDate, 'RecordedBy': $("#txtLoggedinUsername").val(), 'CardHistoryId': CardHistoryId },
                function (data, status) {
                    switch (status) {
                        case 'success':
                            alert('Cards have been received!');
                            loadGrid();
                            break;
                        default:
                            alert('An Error occurred: ' + status + "\n Data:" + data);
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

