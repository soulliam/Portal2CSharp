<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="Card_Dist.aspx.cs" Inherits="CardInventoryDistribution" %>

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
        /*form coloring received shipment rows*/
        .shimpmentClass
        {
            background-color: aquamarine;
        }
    </style>

    <script type="text/javascript">
        // ============= Initialize Page ==================== Begin
        var group = '<%= Session["groupList"] %>';

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
                var offset = $("#CardDistribution").offset();
                $("#popupLocation").jqxWindow({ position: { x: parseInt(offset.left) + 500, y: parseInt(offset.top) - 40 } });
                $('#popupLocation').jqxWindow({ width: "325px", height: "300px" });
                $('#popupLocation').jqxWindow({ isModal: true, modalOpacity: 0.7 });
                $('#popupLocation').jqxWindow({ showCloseButton: false });
                $("#popupLocation").css("visibility", "visible");
                $("#popupLocation").jqxWindow({ title: 'Pick a Location' });
                $("#popupLocation").jqxWindow('open');
            }
            else {
                $("#distributionLocation").val(locationResult[0]);
            }
            

            //#region SetupButtons
            $("#btnSaveDistribution").jqxButton({ width: '100%', height: 26 });
            //#endregion

            $("#btnSaveDistribution").on("click", function (event) {
                DistributCards();

                loadGrid($("#LocationCombo").jqxComboBox('getSelectedItem').value);
            });

            // set up source combo
            var source = [
                    "Pick a Source",
                    "Booth",
                    //"Bus",
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
                                $("#jqxRep").val('');
                                $("#jqxRep").toggle();
                            }
                        }
                        if (item.label == "Rep") {
                            loadReps();
                            $("#jqxRep").toggle();
                            if ($("#jqxBus").is(":visible")) {
                                $("#jqxBus").val('');
                                $("#jqxBus").toggle();
                            }
                        }
                        if (item.label == "Booth") {
                            if ($("#jqxRep").is(":visible")) {
                                $("#jqxRep").val('');
                                $("#jqxRep").toggle();
                            }
                            if ($("#jqxBus").is(":visible")) {
                                $("#jqxBus").val('');
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


            $("#LocationCombo").on('bindingComplete', function (event) {
                $("#LocationCombo").jqxComboBox('insertAt', 'Pick a Location', 0);
                $("#LocationCombo").jqxComboBox('selectIndex', 0);
            });

            $("#LocationCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item.index <= 0) {
                        return null;
                    }
                    if (item) {
                        loadGrid($("#LocationCombo").jqxComboBox('getSelectedItem').value);
                    }
                }
            });
        
            //Check key strokes for whether card is in DB for different history types Order = 1
            $("#firstCard").keyup(function () {
                var cardVal = $("#firstCard").val();
                var thisLocationId = $("#LocationCombo").jqxComboBox('getSelectedItem').value;
                var data = { 'CardDistLocationID': thisLocationId, 'CardDistStartNumber': cardVal };

                $.ajax({
                    async: false,
                    type: "POST",
                    //url: $("#localApiDomain").val() + "CardDists/Distribute",
                    url: "http://localhost:52839/api/CardDists/ConfirmNumbers",

                    data: data,
                    dataType: "json",
                    success: function (thisData) {
                        if (thisData.length > 0) {
                            $("#firstCard").css('background-color', '#ffffff');
                        } else {
                            $("#firstCard").css('background-color', '#ff6666');
                            
                        }
                    },
                    error: function (request, status, error) {
                        alert(request);
                    },
                    complete: function () {

                    }

                });

            });

            $("#lastCard").keyup(function () {
                var cardVal = $("#lastCard").val();
                var thisLocationId = $("#LocationCombo").jqxComboBox('getSelectedItem').value;
                var data = { 'CardDistLocationID': thisLocationId, 'CardDistEndNumber': cardVal };

                $.ajax({
                    async: false,
                    type: "POST",
                    //url: $("#localApiDomain").val() + "CardDists/Distribute",
                    url: "http://localhost:52839/api/CardDists/ConfirmNumbers",

                    data: data,
                    dataType: "json",
                    success: function (thisData) {
                        if (thisData.length > 0) {
                            $("#lastCard").css('background-color', '#ffffff');
                        } else {
                            $("#lastCard").css('background-color', '#ff6666');

                        }
                    },
                    error: function (request, status, error) {
                        alert(request);
                    },
                    complete: function () {

                    }

                });
            });
            
            Security();

        });

       

        // ============= Initialize Page ================== End

    

        function loadGrid(thisLocationId)
        {

            // loading order histor
            //var url = $("#localApiDomain").val() + "CardDists/GetCardDist/" + thisLocationId;
            var url = "http://localhost:52839/api/CardDists/GetCardDist/" + thisLocationId;

            var source =
            {
                datafields: [
                    { name: 'CardDistID' },
                    { name: 'CardDistRepName' },
                    { name: 'CardDistBusName' },
                    { name: 'CardDistBooth' },
                    { name: 'CardDistStartNumber' },
                    { name: 'CardDistEndNumber' },
                    { name: 'CardDistBy' },
                    { name: 'CardDistDate' }
                ],
                type: 'Get',
                datatype: "json",
                url: url,
            };

            var padCard = function (row, columnfield, value, defaulthtml, columnproperties) {
                var newValue = padNumber(value, 8, '0');
                return '<div style="margin-top: 10px;margin-left: 5px">' + newValue + '</div>';
            }

            var numberOfCards = function (row, columnfield, value, defaulthtml, columnproperties, rowdata) {
                var newValue = rowdata.CardDistEndNumber - rowdata.CardDistStartNumber + 1;
                return '<div style="margin-top: 10px;margin-left: 5px">' + newValue + '</div>';
            }

            var booth = function (row, columnfield, value, defaulthtml, columnproperties) {
                if (value == 1)
                {
                    return '<div style="margin-top: 10px;margin-left: 5px">YES</div>';
                }
                else
                {
                    return '<div style="margin-top: 10px;margin-left: 5px"></div>';
                }
            }

            // creage jqxgrid
            $("#jqxDistribution").jqxGrid(
            {
                width: '100%',
                height: 500,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                selectionmode: 'checkbox',
                columns: [
                       { text: 'CardDistID', datafield: 'CardDistID', hidden: true },
                       { text: 'Marketing Rep', datafield: 'CardDistRepName' },
                       { text: 'Vehicle Name', datafield: 'CardDistBusName', hidden: true },
                       { text: 'Booth', datafield: 'CardDistBooth', cellsrenderer: booth },
                       { text: 'Starting Card', datafield: 'CardDistStartNumber', cellsrenderer: padCard },
                       { text: 'Ending Card', datafield: 'CardDistEndNumber', cellsrenderer: padCard },
                       { text: 'NumberOfCards', datafield: 'NumberOfCards', cellsrenderer: numberOfCards },
                       { text: 'Distributed By', datafield: 'CardDistBy' },
                       { text: 'Distributed Date', datafield: 'CardDistDate', cellsrenderer: DateTimeRender }
                ]
            });
        }


        function DistributCards() {
            if ($("#lastCard").css("background-color") == "rgb(255, 102, 102)" || $("#firstCard").css("background-color") == "rgb(255, 102, 102)") {
                alert("One of your cards has already been ordered!");
                return null;
            };

            if (parseInt($("#lastCard").val()) < parseInt($("#firstCard").val())) {
                alert("Your last card is greater than your first card!");
                return null;
            };


            var StartingNumber = $("#firstCard").val();
            var EndingNumber = $("#lastCard").val();

            if ($("#jqxRep").is(":visible")) {
                var Rep = $("#jqxRep").jqxComboBox('getSelectedItem').value;
                var Booth = 0;
                var Bus = '';
            }
            else {
                var Rep = 0;
                var Booth = 1;
                var Bus = '';
            }
            var thisLocationId = $("#LocationCombo").jqxComboBox('getSelectedItem').value;
            

            var myDate = new Date();

            myDate = DateTimeFormat(myDate);

            var data = { 'CardDistLocationID': thisLocationId, 'CardDistRepLineID': Rep, 'CardDistBooth': Booth, 'CardDistBusName': Bus, 'CardDistStartNumber': StartingNumber, 'CardDistEndNumber': EndingNumber, 'CardDistBy': $("#txtLoggedinUsername").val() };

            $.ajax({
                async: false,
                type: "POST",
                //url: $("#localApiDomain").val() + "CardDists/Distribute",
                url: "http://localhost:52839/api/CardDists/Distribute",

                data: data,
                dataType: "json",
                success: function (thisData) {
                    alert('Cards were distributed.');
                },
                error: function (request, status, error) {
                    alert(request);
                },
                complete: function () {
                    var parent = $("#jqxDistribution").parent();
                    $("#jqxDistribution").jqxGrid('destroy');
                    $("<div id='jqxDistribution'></div>").appendTo(parent);

                    loadGrid($("#LocationCombo").jqxComboBox('getSelectedItem').value);
                }

            });


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
                    { name: 'ID' }
                ],
                //url: $("#localApiDomain").val() + "MarketingReps/Get"
                url: "http://localhost:52839/api/MarketingReps/Get"
            };
            var RepDataAdapter = new $.jqx.dataAdapter(RepSource);

            $("#jqxRep").jqxComboBox(
            {
                width: '100%',
                height: 24,
                source: RepDataAdapter,
                selectedIndex: 0,
                displayMember: "RepName",
                valueMember: "ID"
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
            $("#LocationCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item.index > 0) {
                        if (item) {

                            loadGrid(item.value)
                            $("#distributionLocation").val(item.value);
                            $("#popupLocation").jqxWindow('hide');
                        }
                    }
                }
            });

        }


    </script>
    <input type="text" id="distributionLocation" style="display:none;" />
    <input type="text" id="boothLocation" style="display:none;" />
    <div id="CardDistribution" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-9">
                            <div class="row search-size">
                                <div class="col-sm-4">
                                    <%--<div id="LocationCombo"></div>--%>
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
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <label id="errorMessage" style="color:white;font-size:large;"></label>
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

    <div id="popupLocation" style="visibility: hidden">
        <div>
            <div id="LocationCombo" style="float:left;"></div>
        </div>
    </div>

</asp:Content>

