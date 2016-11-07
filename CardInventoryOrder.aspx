<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="CardInventoryOrder.aspx.cs" Inherits="CardInventoryOrder" %>

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

        $(document).ready(function () {
            loadGrid();

            $("#lastOrdered").val(GetLastCardOrdered());
            $("#jqxdatetimeinputOrder").jqxDateTimeInput({ width: '150px', height: '19px', formatString: 'MM/dd/yyyy' }); 
            $("#jqxdatetimeinputSpecOrder").jqxDateTimeInput({ width: '150px', height: '19px', formatString: 'MM/dd/yyyy' });
            

            $("#showSpecOrder").on("click", function (event) {
                $("#regOrder").toggle();
                $("#specOrder").toggle();
            });

            $("#placeOrder").on("click", function (event) {
                placeOrder();
                loadGrid();
            });

            $("#specOrder").toggle();
        });

        // ============= Initialize Page ================== End

        function loadGrid()
        {
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
                    { name: 'ActivityId' }
                ],
                id: 'ManualEditId',
                type: 'Get',
                datatype: "json",
                url: url,
            };

            // creage jqxgrid
            $("#jqxOrders").jqxGrid(
            {
                pageable: true,
                pagermode: 'simple',
                //pagermode: 'advanced',
                pagesize: 12,
                width: '100%',
                height: 500,
                source: source,
                selectionmode: 'checkbox',
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                ready: function () {
                    // create a filter group for the FirstName column.
                    var fnameFilterGroup = new $.jqx.filter();
                    // operator between the filters in the filter group. 1 is for OR. 0 is for AND.
                    var filter_or_operator = 1;
                    // create a string filter with 'contains' condition.
                    var filtervalue = 1;
                    var filtercondition = 'contains';
                    var fnameFilter1 = fnameFilterGroup.createfilter('stringfilter', filtervalue, filtercondition);
                    fnameFilterGroup.addfilter(filter_or_operator, fnameFilter1);
                    $("#jqxOrders").jqxGrid('addfilter', 'ActivityId', fnameFilterGroup);
                    $("#jqxOrders").jqxGrid('applyfilters');
                },
                columns: [
                       { text: 'CardHistoryId', datafield: 'CardHistoryId' },
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

        function GetLastCardOrdered() {
            var cardNumber;

            $.ajax({
                type: 'GET',
                url: '$("#localApiDomain").val() + "CardDistInventorys/GetLastCardOrdered/',
                success: function (data) {
                    $("#lastOrdered").val(data[0].orderedMax);
                   
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert("Error: " + errorThrown);
                }
            });

            //return $("#LastCardAPIResult").val();
            return cardNumber;
        }



        function placeOrder() {
            var ActivityDateCode = $('#jqxdatetimeinputOrder').jqxDateTimeInput('getDate');
            var ActivityDateValue = ActivityDateCode.toJSON();
            var ActivityIdValue = $("#Card_Activity").val();
            var StartingNumber = 0;
            var EndingNumber = 0;
            var Quantiy = 0;

            if ($("#regOrder").is(":visible")) {
                StartingNumber = parseInt($("#lastOrdered").val()) + 1;
                EndingNumber = parseInt(StartingNumber) + parseInt($("#orderAmount").val());
                Quantiy = $("#orderAmount").val();
            }
            if ($("#specOrder").is(":visible")) {
                StartingNumber = $("#firstCard").val();
                EndingNumber = $("#lastCard").val();
                Quantity = parseInt(EndingNumber) - parseInt(StartingNumber);
            }
            if (StartingNumber == 0) {
                alert("The starting number for the order has not been set");
                return;
            }
            if (EndingNumber == 0) {
                alert("The ending number for the order has not been set");
                return;
            }

            //alert('ADT:' + ActivityDateValue + 'AID:' + ActivityIdValue + 'F:' + $("#FirstCardValue").val() + ' Last:' + $("#LastCardValue").val() + ' Qt:' + $("#QuantityValue").val() + ' OCDt:' + $("#OrderConfirmationDateValue").val() + 'DP:' + $("#DistributionPointValue").val() + ' bus:' + $("#BusOrRepIDValue").val() + ' sft:' + $("#ShiftValue").val() + ' dt:' + new Date().toJSON() + ' Usr:' + $("#txtLoggedinUsername").val())
            $.post($("#localApiDomain").val() + "CardDistHistorys/Post",
                { 'ActivityDate': ActivityDateValue, 'ActivityId': 1, 'StartingNumber': StartingNumber, 'EndingNumber': EndingNumber, 'NumberOfCards': Quantiy, 'OrderConfirmationDate': '1/1/1900', 'DistributionPoint': 0, 'BusOrRepID': null, 'Shift': null, 'RecordDate': new Date(), 'RecordedBy': $("#txtLoggedinUsername").val() },
                function (data, status) {
                    switch (status) {
                        case 'success':
                            $("#statusMessage").attr("class", "status");
                            $("#statusMessage").html('Cards were created successfully');
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

    <div id="CardInventoryOrder">      
        <div class="FPR_SearchBox" style="display:block;">
            <div class="FPR_SearchLeft" style="margin-left:10px;">
                <div id="regOrder">
                    <span style="color:white;">Last Card Ordered:</span>
                    <input type="text" id="lastOrdered" />
                    <input type="text" id="orderAmount" placeholder="Amout to Order" />
                    <div id='jqxdatetimeinputOrder' style="float:right;" ></div>
                </div>
                <div id="specOrder">
                    <input type="text" id="firstCard" placeholder="First Card" />
                    <input type="text" id="lastCard" placeholder="Last Card" />
                    <div id='jqxdatetimeinputSpecOrder' style="float:right;" ></div>
                </div>
            </div>
            <div class="FPR_SearchRight" style="width:20%;">
                <input type="button" id="showSpecOrder" value="Special Order" style="float:left;" />
                <input type="button" id="placeOrder" value="Place Order" style="float:right;" />
            </div>
        </div>
    </div>
   
    <div class="container-fluid container-970">
        <div class="row ">
            <div class="col-sm-12">
                <div id="jqxOrders"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->

</asp:Content>

