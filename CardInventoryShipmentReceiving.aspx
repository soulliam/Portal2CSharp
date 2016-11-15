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
                        ReceiveShip(selectedRowData.StartingNumber, selectedRowData.EndingNumber);
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
                    if (item) {
                        loadGrid(item.value)
                        $("#shipReceiveLocation").val(item.value);
                        $("#popupLocation").jqxWindow('hide');
                    }

                }
            });
        }

        function loadGrid(thisLocationID)
        {
            var parent = $("#jqxShipments").parent();
            $("#jqxShipments").jqxGrid('destroy');
            $("<div id='jqxShipments'></div>").appendTo(parent);

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
                    { name: 'LocationId' },
                    { name: 'NameOfLocation' }
                ],
                id: 'ManualEditId',
                type: 'Get',
                datatype: "json",
                url: url,
            };

            // creage jqxgrid
            $("#jqxShipments").jqxGrid(
            {
                editable: true,
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
                    // create a filter group for the ActivityId column.
                    var ActivityFilterGroup = new $.jqx.filter();
                    // operator between the filters in the filter group. 1 is for OR. 0 is for AND.
                    var filter_or_operator = 1;
                    var filtercondition = 'equal';

                    var ActivityType_1 = 2;
                    var ActivityFilter = ActivityFilterGroup.createfilter('numericfilter', ActivityType_1, filtercondition);

                    var ActivityType_2 = 3;
                    var ActivityFilter1 = ActivityFilterGroup.createfilter('numericfilter', ActivityType_2, filtercondition);

                    var ActivityFilterGroup1 = new $.jqx.filter();
                    var filter_or_operator1 = 0;
                    var filterLocationId = thisLocationID;
                    var ActivityFilter2 = ActivityFilterGroup.createfilter('numericfilter', filterLocationId, filtercondition);

                    // add the filters to the filter group.
                    ActivityFilterGroup.addfilter(filter_or_operator, ActivityFilter);
                    ActivityFilterGroup.addfilter(filter_or_operator, ActivityFilter1);
                    ActivityFilterGroup1.addfilter(filter_or_operator1, ActivityFilter2);
                    
                    $("#jqxShipments").jqxGrid('addfilter', 'ActivityId', ActivityFilterGroup);
                    $("#jqxShipments").jqxGrid('addfilter', 'LocationId', ActivityFilterGroup1);
                    $("#jqxShipments").jqxGrid('applyfilters');
                },
                columns: [
                       { text: 'CardHistoryId', datafield: 'CardHistoryId', hidden: true },
                       { text: 'LocationId', datafield: 'LocationId' },
                       { text: 'ActivityDate', datafield: 'ActivityDate' },
                       { text: 'StartingNumber', datafield: 'StartingNumber' },
                       { text: 'EndingNumber', datafield: 'EndingNumber' },
                       { text: 'NumberOfCards', datafield: 'NumberOfCards' },
                       { text: 'Activity', datafield: 'CardDistributionActivityDescription' },
                       { text: 'User', datafield: 'RecordedBy' },
                       { text: 'Location', datafield: 'NameOfLocation' },
                       { text: 'ActivityId', datafield: 'ActivityId', hidden: true }
                ]
            });
        }

        function ReceiveShip(StartingNumber, EndingNumber) {
            Date.prototype.toMMDDYYYYString = function () { return isNaN(this) ? 'NaN' : [this.getMonth() > 8 ? this.getMonth() + 1 : '0' + (this.getMonth() + 1), this.getDate() > 9 ? this.getDate() : '0' + this.getDate(), this.getFullYear()].join('/') }

            //alert(new Date().toMMDDYYYYString());

            var Quantity = parseInt(EndingNumber) - parseInt(StartingNumber);

            //alert('ADT:' + ActivityDateValue + 'AID:' + ActivityIdValue + 'F:' + $("#FirstCardValue").val() + ' Last:' + $("#LastCardValue").val() + ' Qt:' + $("#QuantityValue").val() + ' OCDt:' + $("#OrderConfirmationDateValue").val() + 'DP:' + $("#DistributionPointValue").val() + ' bus:' + $("#BusOrRepIDValue").val() + ' sft:' + $("#ShiftValue").val() + ' dt:' + new Date().toJSON() + ' Usr:' + $("#txtLoggedinUsername").val())
            $.post($("#localApiDomain").val() + "CardDistHistorys/Post",
                { 'ActivityDate': new Date().toMMDDYYYYString(), 'ActivityId': 3, 'StartingNumber': StartingNumber, 'EndingNumber': EndingNumber, 'NumberOfCards': Quantity, 'OrderConfirmationDate': '1/1/1900', 'DistributionPoint': 0, 'BusOrRepID': null, 'Shift': null, 'RecordDate': new Date().toMMDDYYYYString(), 'RecordedBy': $("#txtLoggedinUsername").val(), 'LocationId': $("#userLocation").val() },
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

