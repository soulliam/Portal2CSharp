<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="CardInventoryShipmentReceiving.aspx.cs" Inherits="CardInventoryShipmentReceiving" %>

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

            var locationString = $("#userLocation").val();
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
                var offset = $("#jqxShipments").offset();
                $("#popupLocation").jqxWindow({ position: { x: parseInt(offset.left) + 500, y: parseInt(offset.top) - 40 } });
                $('#popupLocation').jqxWindow({ width: "325px", height: "300px" });
                $('#popupLocation').jqxWindow({ isModal: true, modalOpacity: 0.7 });
                $('#popupLocation').jqxWindow({ showCloseButton: false });
                $("#popupLocation").css("visibility", "visible");
                $("#popupLocation").jqxWindow({ title: 'Pick a Location' });
                $("#popupLocation").jqxWindow('open');
            }
            else {
                $("#shipReceiveLocation").val(locationResult[0]);
            }

            //insert place holder in location combo box
            $("#LocationCombo").on('bindingComplete', function (event) {
                $("#LocationCombo").jqxDropDownList('insertAt', 'Pick a Location', 0);
            });

            

            //#region SetupButtons
            $("#btnReceive").jqxButton({ width: '100%', height: 26 });
            //#endregion

            $("#btnReceive").on("click", function (event) {
                var getselectedrowindexes = $('#jqxShipments').jqxGrid('getselectedrowindexes');
                if (getselectedrowindexes.length > 0) {
                    for (var index = 0; index < getselectedrowindexes.length; index++) {
                        var selectedRowData = $('#jqxShipments').jqxGrid('getrowdata', getselectedrowindexes[index]);
                        if (selectedRowData.CardDistributionActivityDescription == "Ship Receive") {
                            alert("This is an 'Shipment Received' row!");
                            return;
                        } else {
                            var rows = $('#jqxShipments').jqxGrid('getrows');
                            for (var i = 0; i < rows.length; i++) {
                                var data = rows[i];
                                if (data.CardDistributionActivityDescription == "Ship Receive" && data.StartingNumber == selectedRowData.StartingNumber && data.EndingNumber == selectedRowData.EndingNumber) {
                                    alert("This Order has been received.");
                                    return;
                                }
                            }
                        }
                        ReceiveShip(selectedRowData.StartingNumber, selectedRowData.EndingNumber, selectedRowData.CardHistoryId);
                    }
                    loadGrid();
                } else {

                    alert("No orders selected!");
                }
            });

        });

        // ============= Initialize Page ================== End

        //Load locationPopup if multiple locations
        function LoadLocationPopup(thisLocationString) {
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
                url: $("#localApiDomain").val() + "Locations/LocationByLocationIds/" + thisLocationString,

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
            $("#LocationCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item.index > 0) {
                        if (item) {
                            loadGrid(item.value)
                            $("#shipReceiveLocation").val(item.value);
                            $("#popupLocation").jqxWindow('hide');
                        }
                    }
                }
            });
        }

        function loadGrid(thisLocationnId) {
            var parent = $("#jqxShipments").parent();
            $("#jqxShipments").jqxGrid('destroy');
            $("<div id='jqxShipments'></div>").appendTo(parent);

            // loading order histor
            var url = $("#localApiDomain").val() + "CardDistHistorys/Get/-4_" + thisLocationnId;
            //var url = "http://localhost:52839/api/CardDistHistorys/Get/-4_" + thisLocationnId;

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

            // creage jqxgrid
            $("#jqxShipments").jqxGrid(
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
                       { text: 'Ship Date', datafield: 'ActivityDate', cellsrenderer: DateRender },
                       { text: 'Starting Card', datafield: 'StartingNumber' },
                       { text: 'Ending Card', datafield: 'EndingNumber' },
                       { text: 'Number Of Cards', datafield: 'NumberOfCards' },
                       { text: 'Shipped By', datafield: 'RecordedBy' },
                       { text: 'Received Date', datafield: 'ReceivedDate', cellsrenderer: receiveDateRenderer },
                       { text: 'Received By', datafield: 'ReceviedBy' },
                       { text: 'ActivityId', datafield: 'ActivityId', hidden: true }
                ]
            });
        }

        function ReceiveShip(StartingNumber, EndingNumber, CardHistoryId) {
            var myDate = new Date();

            myDate = DateTimeFormat(myDate);

            var Quantity = parseInt(EndingNumber) - parseInt(StartingNumber);

            var thisLocationId = $("#shipReceiveLocation").val();


            $.post($("#localApiDomain").val() + "CardDistHistorys/Post",
            //$.post("http://localhost:52839/api/CardDistHistorys/Post",
                { 'ActivityDate': myDate, 'ActivityId': 7, 'StartingNumber': StartingNumber, 'EndingNumber': EndingNumber, 'NumberOfCards': Quantity, 'OrderConfirmationDate': '1/1/1900', 'DistributionPoint': "", 'BusOrRepID': null, 'Shift': null, 'RecordDate': myDate, 'RecordedBy': $("#txtLoggedinUsername").val(), 'CardHistoryId': CardHistoryId, 'LocationId': thisLocationId },
                function (data, status) {
                    switch (status) {
                        case 'success':
                            alert('Cards have been received!');
                            loadGrid(thisLocationId);
                            break;
                        default:
                            alert('An Error occurred: ' + status + "\n Data:" + data);
                            break;
                    }
                }
            );


        }

    </script>
    <input type="text" id="shipReceiveLocation" style="display:none;" />
    <div id="CardInventoryShipmentReceiving" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-3 col-sm-offset-9">
                            <div class="row search-size">
                                <div class="col-sm-8 col-sm-offset-4">
                                    <div class="row search-size">
                                        <div class="col-sm-12">
                                            <input type="button" id="btnReceive" value="Receive Shipments" />
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
                <div id="jqxShipments"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->

    <div id="popupLocation" style="visibility: hidden">
        <div>
            <div id="LocationCombo" style="float:left;"></div>
        </div>
    </div>

</asp:Content>

