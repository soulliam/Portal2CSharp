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
            loadGrid();

            $("#btnSaveDistribution").on("click", function (event) {
                DistributCards();
            });

            // set up source combo
            var source = [
                    "Pick a Source",
                    "Booth",
                    "Bus",
                    "Rep"];

            $("#jqxDistPoint").jqxComboBox({ source: source, selectedIndex: 0, width: '200', height: '21' });

            $('#jqxDistPoint').on('select', function (event) {
                var args = event.args;
                if (args != undefined) {
                    var item = event.args.item;
                    if (item != null) {
                        if (item.label == "Bus") {
                            $("#jqxBus").toggle();
                            if ($("#jqxRep").is(":visible")) {
                                $("#jqxRep").toggle();
                            }
                        }
                        if (item.label == "Rep") {
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
                width: 200,
                height: 21,
                source: RepDataAdapter,
                selectedIndex: 0,
                displayMember: "RepName",
                valueMember: "RepID"
            });
            $("#jqxRep").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {

                    }
                }
            });

            $("#jqxRep").on('bindingComplete', function (event) {
                $("#jqxRep").jqxComboBox('insertAt', 'Pick a Rep', 0);
                $("#jqxRep").on('change', function (event) {
                    //Do nothing for now
                });
            });

            //set up the location combobox
            var locationSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'DisplayName' },
                    { name: 'LocationId' }
                ],
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                url: $("#apiDomain").val() + "locations",

            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#LocationCombo").jqxComboBox(
            {
                width: 200,
                height: 21,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "DisplayName",
                valueMember: "LocationId"
            });
            $("#LocationCombo").on('select', function (event) {
                if (event.args) {

                    var item = event.args.item;
                    if (item) {

                    }
                }
            });

            $("#LocationCombo").on('bindingComplete', function (event) {
                $("#LocationCombo").jqxComboBox('insertAt', 'Pick a Location', 0);
                $("#LocationCombo").on('change', function (event) {
                    loadBuses();
                });
            });

            $("#jqxBus").toggle();
            $("#jqxRep").toggle();
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
                       { text: 'ActivityDate', datafield: 'ActivityDate' },
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

        function DistributCards() {
            var StartingNumber = $("#firstCard").val();
            var EndingNumber = $("#lastCard").val();
            var Bus = "";
            var Rep = "";
            var Booth = "";
            var RepBus = "";

            Bus = $("#jqxBus").jqxComboBox('getSelectedItem').label;
            Rep = $("#jqxRep").jqxComboBox('getSelectedItem').label;

            if (Bus == "Pick a Bus" && Rep == "Pick a Rep") {
                Booth = "Booth";
            } else {
                if (Bus != "Pick a Bus") {
                    RepBus = Bus;
                } else {
                    RepBus = Rep;
                }
            }


            Date.prototype.toMMDDYYYYString = function () { return isNaN(this) ? 'NaN' : [this.getMonth() > 8 ? this.getMonth() + 1 : '0' + (this.getMonth() + 1), this.getDate() > 9 ? this.getDate() : '0' + this.getDate(), this.getFullYear()].join('/') }

            //alert(new Date().toMMDDYYYYString());

            var Quantity = parseInt(EndingNumber) - parseInt(StartingNumber);
            
            $.post($("#localApiDomain").val() + "CardDistHistorys/Post",
                { 'ActivityDate': new Date().toMMDDYYYYString(), 'ActivityId': 4, 'StartingNumber': StartingNumber, 'EndingNumber': EndingNumber, 'NumberOfCards': Quantity, 'OrderConfirmationDate': '1/1/1900', 'DistributionPoint': Booth, 'BusOrRepID': RepBus, 'Shift': null, 'RecordDate': new Date().toMMDDYYYYString(), 'RecordedBy': $("#txtLoggedinUsername").val() },
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
            $("#jqxBus").jqxComboBox('selectIndex', 0);
            $("#jqxRep").jqxComboBox('selectIndex', 0);

        }

        function loadBuses() {
            //setup bus Combo
            
            var busLocID = $("#LocationCombo").jqxComboBox('getSelectedItem').value;

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
                width: 200,
                height: 21,
                source: busDataAdapter,
                selectedIndex: 0,
                displayMember: "VehicleNumber",
                valueMember: "VehicleId"
            });
            $("#jqxBus").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {

                    }
                }
            });

            $("#jqxBus").on('bindingComplete', function (event) {
                $("#jqxBus").jqxComboBox('insertAt', 'Pick a Bus', 0);
                $("#jqxBus").on('change', function (event) {
                    //Do nothing for now
                });
            });
        }

    </script>

    <div id="CardInventoryShipping">      
        <div class="FPR_SearchBox" style="display:block;">
            <div class="FPR_SearchLeft" style="margin-left:10px;">
                <div>
                    <div id="LocationCombo" style="float:left;" ></div>
                    <input type="text" id="firstCard" placeholder="First Card" />
                    <input type="text" id="lastCard" placeholder="Last Card" />
                    <div id='jqxBus' style="float:right;" ></div>
                    <div id='jqxRep' style="float:right;" ></div>
                    <div id='jqxDistPoint' style="float:right;" ></div>
                </div>
            </div>
            <div class="FPR_SearchRight" style="width:20%;">
                <input type="button" id="btnSaveDistribution" value="Save Distribution" style="float:right;" />
            </div>
        </div>
        
    </div> 
   
    <div class="container-fluid container-970">
        <div class="row ">
            <div class="col-sm-12">
                <div id="jqxDistribution"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->

</asp:Content>

