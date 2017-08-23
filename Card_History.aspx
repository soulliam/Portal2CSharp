<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="Card_History.aspx.cs" Inherits="CardInventoryHistory" %>

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

    <style>
        .yellowCell {
            background-color: yellow;
        }
    </style>

    <script type="text/javascript">
        // ============= Initialize Page ==================== Begin
        var group = '<%= Session["groupList"] %>';

        $(document).ready(function () {

            //#region SetupButtons
            $("#btnSearch").jqxButton({ width: '100%', height: 26 });
            //#endregion

            $("#btnSearch").on("click", function (event) {
                if ($("#cardNumber").val() != "") {
                    loadGrid();
                }
            });

            Security();
        });

        // ============= Initialize Page ================== End

        function loadGrid()
        {
            var carId = $("#cardNumber").val();


            // loading order histor
            var url = $("#localApiDomain").val() + "CardHistorys/GetHistory/" + carId;
            //var url = "http://localhost:52839/api/CardHistorys/GetHistory/" + carId;

            var source =
            {
                datafields: [
                    { name: 'Action' },
                    { name: 'ActivityDate' },
                    { name: 'InitialUser' },
                    { name: 'StartingCard' },
                    { name: 'EndingCard' },
                    { name: 'ReceivedDate' },
                    { name: 'ReceiveUser' },
                    { name: 'Status' },
                    { name: 'Location' },
                    { name: 'IsActive' }
                ],
                id: 'ManualEditId',
                type: 'Get',
                datatype: "json",
                url: url,
            };

            var cellclassname = function (row, column, value, data) {
                var val = $('#jqxHistory').jqxGrid('getcellvalue', row, "IsActive");
                if (val == 0) {
                    return "yellowCell";
                }
            }

            // creage jqxgrid
            $("#jqxHistory").jqxGrid(
            {
                //pageable: true,
                //pagermode: 'simple',
                //pagermode: 'advanced',
                pagesize: 12,
                width: '100%',
                height: 500,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                columns: [
                       { text: 'Action', datafield: 'Action', width: '10%', cellclassname: cellclassname },
                       { text: 'Activity Date', datafield: 'ActivityDate', cellsrenderer: DateRender, width: '15%', cellclassname: cellclassname },
                       { text: 'Initial User', datafield: 'InitialUser', width: '10%', cellclassname: cellclassname },
                       { text: 'Starting Card', datafield: 'StartingCard', width: '10%', cellclassname: cellclassname },
                       { text: 'Ending Card', datafield: 'EndingCard', width: '10%', cellclassname: cellclassname },
                       { text: 'Received Date', datafield: 'ReceivedDate', cellsrenderer: DateRender, width: '15%', cellclassname: cellclassname },
                       { text: 'Receive User', datafield: 'ReceiveUser', width: '10%', cellclassname: cellclassname },
                       { text: 'Status', datafield: 'Status', width: '10%', cellclassname: cellclassname },
                       { text: 'Location', datafield: 'Location', width: '10%', cellclassname: cellclassname },
                       { text: 'IsActive', datafield: 'IsActive', width: '10%', hidden: true }
                ]
            });
        }

        function GetLastCardShipped() {
            var cardNumber;

            $.ajax({
                type: 'GET',
                url: '$("#localApiDomain").val() + "CardDistHistorys/GetLastShipped/',
                success: function (data) {
                    $("#lastShipped").val(data[0].maxShipped);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert("Error: " + errorThrown);
                }
            });

            //return $("#LastCardAPIResult").val();
            return cardNumber;
        }

        function confirmShip(thisOrder) {

            $.ajax({
                url: $("#localApiDomain").val() + "CardDistHistorys/confirmShip/" + thisOrder,
                type: 'GET',
                success: function (response) {
                   
                },
                error: function (jqXHR, textStatus, errorThrown, data) {
                    alert(textStatus); alert(errorThrown);
                }
            });


        }

        function placeShip() {
            var ActivityDateCode = $('#jqxdatetimeinputShip').jqxDateTimeInput('getDate');
            var ActivityDateValue = ActivityDateCode.toJSON();
            var ActivityIdValue = $("#Card_Activity").val();
            var StartingNumber = 0;
            var EndingNumber = 0;
            var Quantiy = 0;

            if ($("#regShip").is(":visible")) {
                StartingNumber = parseInt($("#lastShipped").val()) + 1;
                EndingNumber = parseInt(StartingNumber) + parseInt($("#ShipAmount").val());
                Quantiy = $("#ShipAmount").val();
            }
            if ($("#specShip").is(":visible")) {
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
                { 'ActivityDate': ActivityDateValue, 'ActivityId': 2, 'StartingNumber': StartingNumber, 'EndingNumber': EndingNumber, 'NumberOfCards': Quantiy, 'OrderConfirmationDate': '1/1/1900', 'DistributionPoint': 0, 'BusOrRepID': null, 'Shift': null, 'RecordDate': new Date(), 'RecordedBy': $("#txtLoggedinUsername").val() },
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

    <div id="CardInventoryShipping" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-9">
                            <div class="row search-size">
                                <div class="col-sm-12">
                                    <input type="text" id="cardNumber" />
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="row search-size">
                                <div class="col-sm-8 col-sm-offset-4">
                                    <div class="row search-size">
                                        <div class="col-sm-12">
                                            <input type="button" id="btnSearch" value="Search" />
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
                <div id="jqxHistory"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->

</asp:Content>

