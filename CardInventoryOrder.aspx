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
    <script type="text/javascript" src="jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>    
    <script type="text/javascript" src="jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxloader.js"></script>

    <script type="text/javascript">
        // ============= Initialize Page ==================== Begin
        var group = '<%= Session["groupList"] %>';

        $(document).ready(function () {
            loadGrid();

            $("#jqxLoader").jqxLoader({ width: 100, height: 60, imagePosition: 'top' });

            //#region SetupButtons
            $("#placeOrder").jqxButton({ width: '100%', height: 26 });
            $("#orderType").jqxToggleButton({ width: '100%', height: 26, toggled: false });
            $("#orderType").on('click', function () {
                $("#regOrder").toggle();
                $("#specOrder").toggle();
                var toggled = $("#orderType").jqxToggleButton('toggled');
                if (toggled) {
                    $("#orderType")[0].value = 'Order: Special';
                }
                else $("#orderType")[0].value = 'Order: Regular';
            });
            //#endregion

            $("#lastOrdered").val(GetLastCardOrdered());
            $("#jqxdatetimeinputOrder").jqxDateTimeInput({ width: '100%', height: '24px', formatString: 'MM/dd/yyyy' });
            $("#jqxdatetimeinputSpecOrder").jqxDateTimeInput({ width: '100%', height: '24px', formatString: 'MM/dd/yyyy' });
            
            $("#placeOrder").on("click", function (event) {
                placeOrder();
                loadGrid();
            });

            $("#specOrder").toggle();

            //Check key strokes for whether card is in DB for different history types Order = 1
            $("#firstCard").keyup(function () {
                cardVal = $("#firstCard").val();
                verifyCard(cardVal, '1', $("#firstCard"));
            });

            $("#lastCard").keyup(function () {
                cardVal = $("#lastCard").val();
                verifyCard(cardVal, '1', $("#lastCard"));
            });

            $("#orderAmount").keyup(function () {
                cardVal = parseInt($("#lastOrdered").val()) + parseInt($("#orderAmount").val());
                verifyCard(cardVal, '1', $("#orderAmount"));
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
            //var url = $("#localApiDomain").val() + "CardDistHistorys/Get/-1";
            var url = "http://localhost:52839/api/CardDistHistorys/Get/-1";

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
                    { name: 'Notes' },
                    { name: 'ActivityId' }
                ],
                type: 'Get',
                datatype: "json",
                url: url,
            };

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
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                columns: [
                       { text: 'CardHistoryId', datafield: 'CardHistoryId', hidden: true },
                       { text: 'Order Date', datafield: 'ActivityDate', cellsrenderer: DateRender, width: '15%' },
                       { text: 'Starting Card', datafield: 'StartingNumber', width: '15%', cellsrenderer: padCard },
                       { text: 'Ending Card', datafield: 'EndingNumber', width: '15%', cellsrenderer: padCard },
                       { text: 'Number Of Cards', datafield: 'NumberOfCards', width: '12%', cellsformat: 'n' },
                       { text: 'Activity', datafield: 'CardDistributionActivityDescription', width: '15%' },
                       { text: 'Order By', datafield: 'RecordedBy', width: '13%' },
                       { text: 'Notes', datafield: 'Notes', width: '15%' },
                       { text: 'ActivityId', datafield: 'ActivityId', hidden: true }
                ]
            });
        }

        function GetLastCardOrdered() {
            var cardNumber;

            $.ajax({
                type: 'GET',
                url: $("#localApiDomain").val() + 'CardDistInventorys/GetLastCardOrdered/',
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
            if ($("#orderAmount").css("background-color") == "rgb(255, 102, 102)" || $("#lastCard").css("background-color") == "rgb(255, 102, 102)" || $("#firstCard").css("background-color") == "rgb(255, 102, 102)") {
                alert("One of your cards has already been ordered!");
                return null;
            };

            if (parseInt($("#lastCard").val()) < parseInt($("#firstCard").val())) {
                alert("Your last card is greater than your first card!");
                return null;
            };
            

            var ActivityDateCode = $('#jqxdatetimeinputOrder').jqxDateTimeInput('getDate');
            var ActivityDateValue = ActivityDateCode.toJSON();
            var ActivityIdValue = $("#Card_Activity").val();
            var StartingNumber = 0;
            var EndingNumber = 0;
            var Quantiy = 0;

            if ($("#regOrder").is(":visible")) {
                StartingNumber = parseInt($("#lastOrdered").val()) + 1;
                EndingNumber = parseInt(StartingNumber) + parseInt($("#orderAmount").val() - 1);
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

            $('#jqxLoader').jqxLoader('open');
            var thisDate = new Date();
            $.post($("#localApiDomain").val() + "CardDistHistorys/Post",
            //$.post("http://localhost:52839/api/CardDistHistorys/Post",
                { 'ActivityDate': ActivityDateValue, 'ActivityId': 1, 'StartingNumber': StartingNumber, 'EndingNumber': EndingNumber, 'NumberOfCards': Quantiy, 'OrderConfirmationDate': '1/1/1900', 'DistributionPoint': "", 'BusOrRepID': null, 'Shift': null, 'RecordDate': null, 'RecordedBy': $("#txtLoggedinUsername").val(), 'CreateDatetime': null, 'CreateUserId': -1 },
                function (data, status) {
                    switch (status) {
                        case 'success':
                            loadGrid();
                            $("#lastOrdered").val(EndingNumber);
                            alert('Cards were created successfully');
                            $('#jqxLoader').jqxLoader('close');
                            break;
                        default:
                            alert('An Error occurred: ' + status + "\n Data:" + data);
                            break;
                    }
                }
            );
        }

    </script>
    <div id="jqxLoader"></div>
    <div id="CardInventoryOrder" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-8">
                            <div class="row search-size">
                                <div class="col-sm-15">
                                    <input type="button" id="orderType" value="Order: Regular" />
                                </div>
                                <div id="regOrder" class="swapfields">
                                    <div class="col-sm-15">
                                        <input type="text" id="lastOrdered" placeholder="Last Card Ordered" disabled />
                                    </div>
                                    <div class="col-sm-15">
                                        <input type="text" id="orderAmount" placeholder="Amount to Order"  />
                                    </div>
                                    <div class="col-sm-15">
                                        <div id="jqxdatetimeinputOrder"></div>
                                    </div>
                                </div>
                                <div id="specOrder" class="swapfields">
                                    <div class="col-sm-15">
                                        <input type="text" id="firstCard" placeholder="First Card" />
                                    </div>
                                    <div class="col-sm-15">
                                        <input type="text" id="lastCard" placeholder="Last Card"  />
                                    </div>
                                    <div class="col-sm-15">
                                        <div id="jqxdatetimeinputSpecOrder"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-2">
                            <input type="text" id="notes" placeholder="Notes" />
                        </div>
                        <div class="col-sm-2">
                            <div class="row search-size">
                                <div class="col-sm-8 col-sm-offset-4">
                                    <div class="row search-size">
                                        <div class="col-sm-12">
                                            <input type="button" id="placeOrder" value="Place Order" />
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

