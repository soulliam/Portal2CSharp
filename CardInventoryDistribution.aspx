<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="CardInventoryDistribution.aspx.cs" Inherits="CardInventoryDistribution" %>

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
            }

            LoadLocationPopup(thisLocationString);

            

            //#region SetupButtons
            $("#btnSaveDistribution").jqxButton({ width: '100%', height: 26 });
            //#endregion

            $("#btnSaveDistribution").on("click", function (event) {
                DistributCards();
            });

            // set up source combo
            var source = [
                    "Pick a Source",
                    "Booth",
                    "Bus",
                    "Rep"];

            $("#jqxDistPoint").jqxComboBox({ source: source, selectedIndex: 0, width: '100%', height: '24' });

            $('#jqxDistPoint').on('select', function (event) {
                var args = event.args;
                if (args != undefined) {
                    var item = event.args.item;
                    if (item != null) {
                        if (item.label == "Bus") {
                            loadBuses();
                            $("#jqxBus").toggle();
                            if ($("#jqxRep").is(":visible")) {
                                $("#jqxRep").toggle();
                            }
                        }
                        if (item.label == "Rep") {
                            loadReps();
                            $("#jqxRep").toggle();
                            if ($("#jqxBus").is(":visible")) {
                                $("#jqxBus").toggle();
                            }
                        }
                        if (item.label == "Booth") {
                            if ($("#jqxRep").is(":visible")) {
                                $("#jqxRep").toggle();
                            }
                            if ($("#jqxBus").is(":visible")) {
                                $("#jqxBus").toggle();
                            }
                        }
                    }
                }
            });

            $("#jqxRep").on('bindingComplete', function (event) {
                $("#jqxRep").jqxComboBox('insertAt', 'Pick Rep', 0);
            });

            $("#jqxBus").on('bindingComplete', function (event) {
                $("#jqxBus").jqxComboBox('insertAt', 'Pick a Bus', 0);
                $("#jqxBus").jqxComboBox('selectIndex', 0);
            });


            $("#jqxBus").toggle();
            $("#jqxRep").toggle();

            $("#LocationCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {
                        loadGrid($("#LocationCombo").jqxComboBox('getSelectedItem').value);
                    }
                }
            });
        });

       

        // ============= Initialize Page ================== End

    

        function loadGrid(thisLocationId)
        {
            var parent = $("#jqxDistribution").parent();
            $("#jqxDistribution").jqxGrid('destroy');
            $("<div id='jqxDistribution'></div>").appendTo(parent);

            // loading order histor
            var url = $("#localApiDomain").val() + "CardDistHistorys/Get/" + thisLocationId;
            //var url = "http://localhost:52839/api/CardDistHistorys/Get/" + thisLocationId;

            var source =
            {
                datafields: [
                    { name: 'CardHistoryId' },
                    { name: 'ActivityDate' },
                    { name: 'StartingNumber' },
                    { name: 'EndingNumber' },
                    { name: 'NumberOfCards' },
                    { name: 'DistributionPoint' },
                    { name: 'BusOrRepId' },
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
            $("#jqxDistribution").jqxGrid(
            {
                //pageable: true,
                //pagermode: 'simple',
                //pagermode: 'advanced',
                //pagesize: 12,
                width: '100%',
                height: 500,
                source: source,
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
                    var filtervalue = 4;
                    var filtercondition = 'equal';
                    var ActivityFilter1 = ActivityFilterGroup.createfilter('numericfilter', filtervalue, filtercondition);
                    // add the filters to the filter group.
                    ActivityFilterGroup.addfilter(filter_or_operator, ActivityFilter1);
                    $("#jqxDistribution").jqxGrid('addfilter', 'ActivityId', ActivityFilterGroup);
                    $("#jqxDistribution").jqxGrid('applyfilters');
                },
                columns: [
                       { text: 'CardHistoryId', datafield: 'CardHistoryId', hidden: true },
                       { text: 'ActivityDate', datafield: 'ActivityDate', cellsrenderer: DateRender },
                       { text: 'StartingNumber', datafield: 'StartingNumber' },
                       { text: 'EndingNumber', datafield: 'EndingNumber' },
                       { text: 'NumberOfCards', datafield: 'NumberOfCards' },
                       { text: 'DistributionPoint', datafield: 'DistributionPoint' },
                       { text: 'BusOrRepId', datafield: 'BusOrRepId' },
                       { text: 'Activity', datafield: 'CardDistributionActivityDescription' },
                       { text: 'User', datafield: 'RecordedBy' },
                       { text: 'ActivityId', datafield: 'ActivityId', hidden: true }
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
                error: function (request, status, error) {
                    alert(error + " - " + request.responseJSON.message);
                }
            })

            //return $("#LastCardAPIResult").val();
            return cardNumber;
        }

        function confirmShip(thisOrder) {

            $.ajax({
                url: $("#localApiDomain").val() + "CardDistHistorys/confirmShip/" + thisOrder,
                type: 'GET',
                success: function (response) {
                   
                },
                error: function (request, status, error) {
                    alert(error + " - " + request.responseJSON.message);
                }
            });


        }

        function DistributCards() {
            var StartingNumber = $("#firstCard").val();
            var EndingNumber = $("#lastCard").val();
            if ($("#jqxBus").val() != "") {
                var Bus = $("#jqxBus").jqxComboBox('getSelectedItem').label;
            }
            if ($("#jqxRep").val() != "") {
                var Rep = $("#jqxRep").jqxComboBox('getSelectedItem').label;
            }
            var thisLocationId = $("#LocationCombo").jqxComboBox('getSelectedItem').value;
            var DistPoint = "";
            
            

            if (typeof Bus == "undefined" && typeof Rep == "undefined") {
                DistPoint = "Booth";
            } else {
                if (typeof Bus != "undefined") {
                    RepBus = Bus;
                    DistPoint = "Bus";
                } else {
                    RepBus = Rep;
                    DistPoint = "Rep";
                }
            }


            Date.prototype.toMMDDYYYYString = function () { return isNaN(this) ? 'NaN' : [this.getMonth() > 8 ? this.getMonth() + 1 : '0' + (this.getMonth() + 1), this.getDate() > 9 ? this.getDate() : '0' + this.getDate(), this.getFullYear()].join('/') }

            //alert(new Date().toMMDDYYYYString());

            var Quantity = parseInt(EndingNumber) - parseInt(StartingNumber);
            
            var data = { 'ActivityDate': new Date().toMMDDYYYYString(), 'ActivityId': 4, 'StartingNumber': StartingNumber, 'EndingNumber': EndingNumber, 'NumberOfCards': Quantity, 'OrderConfirmationDate': '1/1/1900', 'DistributionPoint': DistPoint, 'BusOrRepID': RepBus, 'Shift': null, 'RecordDate': new Date().toMMDDYYYYString(), 'RecordedBy': $("#txtLoggedinUsername").val(), 'LocationId': thisLocationId };

            $.ajax({
                async: false,
                type: "POST",
                url: $("#localApiDomain").val() + "CardDistHistorys/Post",
                //url: "http://localhost:52839/api/CardDistHistorys/Post",

                data: data,
                dataType: "json",
                success: function (thisData) {
                    alert('Cards were distributed.');
                },
                error: function (request, status, error) {
                    alert(error);
                },
                complete: function () {
                    loadGrid($("#LocationCombo").jqxComboBox('getSelectedItem').value);
                }

            });

            //$.post($("#localApiDomain").val() + "CardDistHistorys/Post",
            //    { 'ActivityDate': new Date().toMMDDYYYYString(), 'ActivityId': 4, 'StartingNumber': StartingNumber, 'EndingNumber': EndingNumber, 'NumberOfCards': Quantity, 'OrderConfirmationDate': '1/1/1900', 'DistributionPoint': DistPoint, 'BusOrRepID': RepBus, 'Shift': null, 'RecordDate': new Date().toMMDDYYYYString(), 'RecordedBy': $("#txtLoggedinUsername").val(), 'LocationId': thisLocationId },
            //    function (data, status) {
            //        switch (status) {
            //            case 'success':
            //                $("#statusMessage").attr("class", "status");
            //                $("#statusMessage").html('Cards were created received');
            //                alert('Cards were distributed.');
            //                break;
            //            default:
            //                $("#statusMessage").attr("class", "warning");
            //                $("#statusMessage").html('An Error occurred: ' + status + "\n Data:" + data);
            //                alert('An Error occurred: ' + status + "\n Data:" + data);
            //                break;
            //        }
            //    }
            //);

            $("#jqxBus").jqxComboBox('selectIndex', 0);
            $("#jqxRep").jqxComboBox('selectIndex', 0);
            

        }

        function loadBuses() {

            var parent = $("#jqxBus").parent();
            $("#jqxBus").jqxGrid('destroy');
            $("<div id='jqxBus'></div>").appendTo(parent);

            //setup bus Combo
            
            var busLocID = $("#LocationCombo").val();

            var busSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'VehicleNumber' },
                    { name: 'VehicleId' }
                ],
                url: $("#localApiDomain").val() + "Vehicles/GetVehiclesByLocation/" + busLocID
            };
            var busDataAdapter = new $.jqx.dataAdapter(busSource);

            $("#jqxBus").jqxComboBox(
            {
                width: '100%',
                height: 24,
                source: busDataAdapter,
                selectedIndex: 0,
                displayMember: "VehicleNumber",
                valueMember: "VehicleId"
            });



        }

        function loadReps() {

            var parent = $("#jqxRep").parent();
            $("#jqxRep").jqxGrid('destroy');
            $("<div id='jqxRep'></div>").appendTo(parent);

            //setup Rep Combo
            var RepSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'RepName' },
                    { name: 'RepID' }
                ],
                url: $("#localApiDomain").val() + "MarketingReps/Get"
            };
            var RepDataAdapter = new $.jqx.dataAdapter(RepSource);

            $("#jqxRep").jqxComboBox(
            {
                width: '100%',
                height: 24,
                source: RepDataAdapter,
                selectedIndex: 0,
                displayMember: "RepName",
                valueMember: "RepID"
            });
        }

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
            $("#LocationCombo").jqxComboBox(
            {
                width: '100%',
                height: 25,
                itemHeight: 50,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });

        }


    </script>
    <input type="text" id="boothLocation" style="display:none;" />
    <div id="CardInventoryShipping" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-9">
                            <div class="row search-size">
                                <div class="col-sm-4">
                                    <div id="LocationCombo"></div>
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" id="firstCard" placeholder="First Card" />
                                </div>
                                <div class="col-sm-2">
                                    <input type="text" id="lastCard" placeholder="Last Card"  />
                                </div>
                                <div class="col-sm-2">
                                    <div id="jqxDistPoint"></div>
                                </div>
                                <div class="col-sm-2">
                                    <div id="jqxBus"></div>
                                    <div id="jqxRep"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="row search-size">
                                <div class="col-sm-8 col-sm-offset-4">
                                    <div class="row search-size">
                                        <div class="col-sm-12">
                                            <input type="button" id="btnSaveDistribution" value="Save Distribution" />
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
                <div id="jqxDistribution"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->

</asp:Content>

