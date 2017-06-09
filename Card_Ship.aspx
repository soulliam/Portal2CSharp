<%@ Page Title="" Language="C#" MasterPageFile="Portal2.master" AutoEventWireup="true" CodeFile="Card_Ship.aspx.cs" Inherits="CardInventoryShipping" %>

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
        var locationResult = '';
        var cardShipId = 0;

        var locationString = $("#userLocation").val();
        locationResult = locationString.split(",");

        $(document).ready(function () {
            

            loadGrid(locationResult);

            //#region SetupButtons
            $("#placeShip").jqxButton({ width: '100%', height: 26 });
            $("#receiveShip").jqxButton({ width: '100%', height: 26 });
            $("#editShip").jqxButton({ width: '100%', height: 26 });
            $("#shipType").jqxToggleButton({ width: '100%', height: 26, toggled: false });

            $("#shipType").on('click', function () {
                toggleShipType();
            });
            //#endregion

            GetLastCardShipped();
            GetHighestavailableCard();
            //$("#jqxdatetimeinputShip").jqxDateTimeInput({ width: '100%', height: '24px', formatString: 'MM/dd/yyyy' });
            //$("#jqxdatetimeinputSpecShip").jqxDateTimeInput({ width: '100%', height: '24px', formatString: 'MM/dd/yyyy' });
            
            $("#placeShip").on("click", function (event) {
                placeShip();
            });

            $("#editShip").on("click", function (event) {
                editShip();
                $("#fromlocationCombo").jqxComboBox('selectIndex', 0);
                $("#tolocationCombo").jqxComboBox('selectIndex', 0);
            });

            $("#specShip").toggle();

            $("#confirmShip").on("click", function (event) {
               
                var getselectedrowindexes = $('#jqxShipping').jqxGrid('getselectedrowindexes');
                if (getselectedrowindexes.length > 0) {
                    for (var index = 0; index < getselectedrowindexes.length; index++) {
                        var selectedRowData = $('#jqxShipping').jqxGrid('getrowdata', getselectedrowindexes[index]);
                        confirmShip(selectedRowData.CardHistoryId);
                    }
                    loadGrid(locationResult);
                } else {
                    swal("No orders selected!");
                }
                
            });

            //set up the to location combobox
            var locationSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'NameOfLocation' },
                    { name: 'LocationId' }
                ],
                url: $("#localApiDomain").val() + "CardLocations/Locations/",
                //url: "http://localhost:52839/api/CardLocations/Locations/",
            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#tolocationCombo").jqxComboBox(
            {
                width: 200,
                height: 21,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });


            $("#tolocationCombo").on('bindingComplete', function (event) {
                $("#tolocationCombo").jqxComboBox('insertAt', 'To Location', 0);
            });

            //set up the from location combobox
            var locationSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'NameOfLocation' },
                    { name: 'LocationId' }
                ],
                url: $("#localApiDomain").val() + "CardLocations/Locations/",
                //url: "http://localhost:52839/api/CardLocations/Locations/",

            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#fromlocationCombo").jqxComboBox(
            {
                width: 200,
                height: 21,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });

            $("#fromlocationCombo").on('bindingComplete', function (event) {
                $("#fromlocationCombo").jqxComboBox('insertAt', 'From Location', 0);
                var item = $("#fromlocationCombo").jqxComboBox('getItemByValue', "101");
                $("#fromlocationCombo").jqxComboBox('selectItem', item);
            });

            //Check key strokes for whether card is in DB for different history types Order = 1
            $("#firstCard").keyup(function () {
                if ($("#firstCard").val() == '') { return null; }
                cardVal = $("#firstCard").val();
                verifyOrderedCard(cardVal, $("#firstCard"));
            });

            $("#lastCard").keyup(function () {
                if ($("#lastCard").val() == '') { return null; }
                cardVal = $("#lastCard").val();
                verifyOrderedCard(cardVal, $("#lastCard"));
            });

            $("#shipAmount").keyup(function () {
                if ($("#shipAmount").val() == '') { return null; }
                cardVal = parseInt($("#lastShipped").val()) + parseInt($("#shipAmount").val());
                verifyOrderedCard(cardVal, $("#shipAmount"));

            });

            function verifyOrderedCard(CardNumber, cardTest) {
                var cardNumber;

                var url = $("#localApiDomain").val() + 'CardOrders/ConfirmNumbers/' + CardNumber;
                //var url = 'http://localhost:52839/api/CardOrders/ConfirmNumbers/' + CardNumber;

                $.ajax({
                    type: 'GET',
                    url: url,
                    success: function (data) {
                        //Has the card been ordered
                        if (data.length <= 0) {
                            //No
                            cardTest.css('background-color', '#ff6666');
                        } else {
                            //Yes check to see if it has been shipped
                            cardTest.css('background-color', '#ffffff');
                            verifyShipCard(cardVal, cardTest);
                        }

                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        swal("Error: " + errorThrown);
                        ardTest = false;
                    }
                });

                //return $("#LastCardAPIResult").val();
                return cardNumber;
            }

            function verifyShipCard(CardNumber, cardTest) {
                var cardNumber;

                var url = $("#localApiDomain").val() + 'CardShips/ConfirmNumbers/' + CardNumber;
                //var url = 'http://localhost:52839/api/CardShips/ConfirmNumbers/' + CardNumber;

                $.ajax({
                    type: 'GET',
                    url: url,
                    success: function (data) {
                        //Has the card been shipped
                        if (data.length > 0) {
                            //YES
                            //Is this a special shipment
                            if ($("#shipType")[0].value == 'Ship: Special') {
                                //Yes so check to see if this card is in the from location picked
                                verifyShipLocation(cardVal, cardTest);
                            }
                            else {
                                //No this card has been shipped
                                cardTest.css('background-color', '#ffffff');
                                swal("This card has been shipped.")
                            }
                        } else {
                            //No the card has not been shipped
                            cardTest.css('background-color', '#ffffff');
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        swal("Error: " + errorThrown);
                        ardTest = false;
                    }
                });

                //return $("#LastCardAPIResult").val();
                return cardNumber;
            }

            function verifyShipLocation(CardNumber, cardTest) {
                var cardNumber;

                var url = $("#localApiDomain").val() + 'CardShips/ConfirmShipLocation/' + CardNumber;
                //var url = 'http://localhost:52839/api/CardShips/ConfirmShipLocation/' + CardNumber;

                $.ajax({
                    type: 'GET',
                    url: url,
                    success: function (data) {
                        //Does the card have a location
                        if (data.length <= 0) {
                            //No it hasn't been shipped 
                            cardTest.css('background-color', '#ff6666');
                        } else {
                            //Yes, does the location of the card match the location we are shipping from
                            if (data[0].CardShipTo == $("#fromlocationCombo").jqxComboBox('getSelectedItem').value) {
                                //Yes
                                cardTest.css('background-color', '#ffffff');
                            } else {
                                //No the card is not at this location
                                cardTest.css('background-color', '#ff6666');
                                swal("This Card is not at this location!")
                            }
                        }

                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        swal("Error: " + errorThrown);
                        ardTest = false;
                    }
                });

                //return $("#LastCardAPIResult").val();
                return cardNumber;
            }

            

            $("#receiveShip").on("click", function (event) {
                var getselectedrowindexes = $('#jqxShipping').jqxGrid('getselectedrowindexes');
                if (getselectedrowindexes.length > 0) {
                    for (var index = 0; index < getselectedrowindexes.length; index++) {
                        var selectedRowData = $('#jqxShipping').jqxGrid('getrowdata', getselectedrowindexes[index]);

                        if (selectedRowData.CardShipReceivedBy != null) {
                            swal("This shipment has been received.");
                            return null;
                        }

                        ReceiveShip(selectedRowData.CardShipID, $("#txtLoggedinUsername").val());
                    }
                    loadGrid(locationResult);
                } else {

                    swal("No orders selected!");
                }
            });

            //set up the to Design combobox
            var DesignSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'CardDesignDesc' },
                    { name: 'CardDesignId' }
                ],
                url: $("#localApiDomain").val() + "CardDesigns/GetCardDesigns/",
                //url: "http://localhost:52839/api/CardDesigns/GetCardDesigns/",
            };
            var DesignDataAdapter = new $.jqx.dataAdapter(DesignSource);
            $("#cardDesign").jqxComboBox(
            {
                width: 200,
                source: DesignDataAdapter,
                selectedIndex: 0,
                autoDropDownHeight: true,
                displayMember: "CardDesignDesc",
                valueMember: "CardDesignId"
            });

            $("#cardDesign").on('bindingComplete', function (event) {
                $("#cardDesign").jqxComboBox('insertAt', 'Select Design', 0);
            });

            $("#jqxShipping").bind('rowclick', function (event) {
                var row = event.args.rowindex;
                var dataRecord = $("#jqxShipping").jqxGrid('getrowdata', row);
                cardShipId = dataRecord.CardShipID;
                var CardShipFromID = dataRecord.CardShipFrom;
                var item = $("#fromlocationCombo").jqxComboBox('getItemByValue', CardShipFromID);
                $("#fromlocationCombo").jqxComboBox('selectItem', item);
                var CardShipToID = dataRecord.CardShipTo;
                var item = $("#tolocationCombo").jqxComboBox('getItemByValue', CardShipToID);
                $("#tolocationCombo").jqxComboBox('selectItem', item);
                var CardDesignId = dataRecord.CardDesignId;
                var item = $("#cardDesign").jqxComboBox('getItemByValue', CardDesignId);
                $("#cardDesign").jqxComboBox('selectItem', item);
                if ($("#firstCard").is(":hidden")) {
                    toggleShipType();
                    $('#shipType').jqxToggleButton('toggle');
                }
                $("#firstCard").val(dataRecord.CardShipStartNumber);
                $("#lastCard").val(dataRecord.CardShipEndNumber);
            });

            Security();

        });



        // ============= Initialize Page ================== End

        function toggleShipType() {
            $("#regShip").toggle();
            $("#specShip").toggle();
            var toggled = $("#shipType").jqxToggleButton('toggled');
            if (toggled) {
                $("#shipType")[0].value = 'Ship: Special';
                $("#fromlocationCombo").jqxComboBox('selectIndex', 0);
            }
            else {
                $("#shipType")[0].value = 'Ship: Regular';
                var item = $("#fromlocationCombo").jqxComboBox('getItemByValue', "101");
                $("#fromlocationCombo").jqxComboBox('selectItem', item);
            }
        }

        function loadGrid(locationResult)
        {


            // loading order histor
            var url = $("#localApiDomain").val() + "CardShips/GetShipments/" + locationResult;
            //var url = "http://localhost:52839/api/CardShips/GetShipments/" + locationResult;

            var source =
            {
                datafields: [
                    { name: 'CardShipID' },
                    { name: 'CardShipFromName' },
                    { name: 'CardShipFrom' },
                    { name: 'CardShipShippedBy' },
                    { name: 'CardShipDate' },
                    { name: 'CardDesignDesc' },
                    { name: 'CardShipStartNumber' },
                    { name: 'CardShipEndNumber' },
                    { name: 'NumberOfCards' },
                    { name: 'CardShipReceivedBy' },
                    { name: 'CardShipReceiveDate' },
                    { name: 'CardShipToName' },
                    { name: 'CardShipTo' },
                    { name: 'CardDesignId' },
                    { name: 'CardShipStatus' }
                ],
                id: 'ManualEditId',
                type: 'Get',
                datatype: "json",
                url: url,
            };

            var padCard = function (row, columnfield, value, defaulthtml, columnproperties) {
                var newValue = padNumber(value, 8, '0');
                return '<div style="margin-top: 10px;margin-left: 5px">' + newValue + '</div>';
            }

            var numberOfCards = function (row, columnfield, value, defaulthtml, columnproperties, rowdata) {
                var newValue = rowdata.CardShipEndNumber - rowdata.CardShipStartNumber + 1;
                return '<div style="margin-top: 10px;margin-left: 5px">' + newValue + '</div>';
            }

            // creage jqxgrid
            $("#jqxShipping").jqxGrid(
            {
                width: '100%',
                height: 500,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                selectionmode: 'checkbox',
                editable: true,
                columns: [
                       { text: 'CardShipID', datafield: 'CardShipID', hidden: true },
                       { text: 'Ship Origin', datafield: 'CardShipFromName' },
                       { text: 'CardShipFrom', datafield: 'CardShipFrom', hidden: true },
                       { text: 'Shipped By', datafield: 'CardShipShippedBy' },
                       { text: 'Ship Date', datafield: 'CardShipDate', cellsrenderer: DateRender },
                       { text: 'Design', datafield: 'CardDesignDesc' },
                       { text: 'Start Number', datafield: 'CardShipStartNumber', cellsrenderer: padCard },
                       { text: 'End Number', datafield: 'CardShipEndNumber', cellsrenderer: padCard },
                       { text: 'NumberOfCards', datafield: 'NumberOfCards', cellsrenderer: numberOfCards },
                       { text: 'Received By', datafield: 'CardShipReceivedBy' },
                       { text: 'Receive Date', datafield: 'CardShipReceiveDate', cellsrenderer: DateRender },
                       { text: 'Destination', datafield: 'CardShipToName' },
                       { text: 'CardShipTo', datafield: 'CardShipTo', hidden: true },
                       { text: 'CardDesignId', datafield: 'CardDesignId', hidden: true },
                       { text: 'Status', datafield: 'CardShipStatus' }
                ]
            });
        }

        function GetLastCardShipped() {
            var cardNumber;

            $.ajax({
                type: 'GET',
                url: $("#localApiDomain").val() + 'CardShips/GetLastShipped/',
                //url: 'http://localhost:52839/api/CardShips/GetLastShipped/',
                success: function (data) {
                    $("#lastShipped").val(data[0].maxShipped);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    swal("HELP Error: " + errorThrown);
                }
            });

            //return $("#LastCardAPIResult").val();
            return cardNumber;
        }

        function GetHighestavailableCard() {
            
            var cardNumber;


            $.ajax({
                type: 'GET',
                url: $("#localApiDomain").val() + 'CardDistHistorys/GetHighestCardNumberOrderReceived/',
                //url: "http://localhost:52839/api/CardDistHistorys/GetHighestCardNumberOrderReceived/",
                success: function (data) {
                    $("#availableCard").html(data[0].maxShipped);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    swal("HELP Error: " + errorThrown);
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
                    swal(textStatus); swal(errorThrown);
                }
            });


        }

        function placeShip() {
            if ($("#shipAmount").css("background-color") == "rgb(255, 102, 102)" || $("#lastCard").css("background-color") == "rgb(255, 102, 102)" || $("#firstCard").css("background-color") == "rgb(255, 102, 102)") {
                swal("One of your cards has already been shipped!");
                return null;
            };

            if (parseInt($("#lastCard").val()) < parseInt($("#firstCard").val())) {
                swal("Your last card is greater than your first card!");
                return null;
            };


            if ($("#tolocationCombo").jqxComboBox('selectedIndex') == 0) {
                swal("You must pick a location!");
                return;
            }

            if ($("#cardDesign").jqxComboBox('getSelectedIndex') == 0) {
                swal("Select a Design!");
                return;
            }

            var cardDesignId = $("#cardDesign").jqxComboBox('getSelectedItem').value
            var toLocation = $("#tolocationCombo").jqxComboBox('getSelectedItem').value;
            var fromLocation = $("#fromlocationCombo").jqxComboBox('getSelectedItem').value
            var StartingNumber = 0;
            var EndingNumber = 0;


            if ($("#regShip").is(":visible")) {
                if ($("#shipAmount").val() == "") {
                    swal("You must select an amount of cards to ship!");
                    return;
                }
                StartingNumber = parseInt($("#lastShipped").val()) + 1;
                EndingNumber = parseInt(StartingNumber) + parseInt($("#shipAmount").val()) - 1;
            }

            if ($("#specShip").is(":visible")) {

                StartingNumber = parseInt($("#firstCard").val());
                EndingNumber = parseInt($("#lastCard").val());

                if (StartingNumber == 0 || EndingNumber == 0) {
                    swal("You must set a starting card and an ending card to do a special order.");
                    return;
                }
            }

            $.post($("#localApiDomain").val() + "CardShips/ShipCards",
            //$.post("http://localhost:52839/api/CardShips/ShipCards",
                { 'CardShipFrom': fromLocation, 'CardShipTo': toLocation, 'CardShipShippedBy': $("#txtLoggedinUsername").val(), 'CardShipStartNumber': StartingNumber, 'CardShipEndNumber': EndingNumber, 'CardDesignId': cardDesignId },
                function (data, status) {
                    switch (status) {
                        case 'success':
                            swal('Cards were shipped successfully');
                            GetLastCardShipped();
                            GetHighestavailableCard();
                            $("#shipAmount").val("");
                            $("#firstCard").val("");
                            $("#lastCard").val("");
                            loadGrid(locationResult);
                            break;
                        default:
                            swal('An Error occurred: ' + status + "\n Data:" + data);
                            break;
                    }
                }
            );

        }

        function editShip() {

            if ($("#fromlocationCombo").jqxComboBox('selectedIndex') == 0) {
                swal("You must pick a 'From' location!");
                return;
            }

            if ($("#tolocationCombo").jqxComboBox('selectedIndex') == 0) {
                swal("You must pick a 'To' location!");
                return;
            }

            if ($("#cardDesign").jqxComboBox('getSelectedIndex') == 0) {
                swal("Select a Design!");
                return;
            }

            var cardDesignId = $("#cardDesign").jqxComboBox('getSelectedItem').value
            var toLocation = $("#tolocationCombo").jqxComboBox('getSelectedItem').value;
            var fromLocation = $("#fromlocationCombo").jqxComboBox('getSelectedItem').value
            var StartingNumber = 0;
            var EndingNumber = 0;
            var thisCardShipId = cardShipId;

            if ($("#specShip").is(":visible")) {
                StartingNumber = parseInt($("#firstCard").val());
                EndingNumber = parseInt($("#lastCard").val());

                if (StartingNumber == 0 || EndingNumber == 0) {
                    swal("You must set a starting card and an ending card to do a special order.");
                    return;
                }
            }

            //$.post($("#localApiDomain").val() + "CardShips/edit",
            $.post("http://localhost:52839/api/CardShips/edit",
                { 'CardShipFrom': fromLocation, 'CardShipTo': toLocation, 'CardShipShippedBy': $("#txtLoggedinUsername").val(), 'CardShipStartNumber': StartingNumber, 'CardShipEndNumber': EndingNumber, 'CardDesignId': cardDesignId, 'CardShipID': thisCardShipId },
                function (data, status) {
                    switch (status) {
                        case 'success':
                            swal('Cards were shipped successfully');
                            GetLastCardShipped();
                            GetHighestavailableCard();
                            $("#shipAmount").val("");
                            $("#firstCard").val("");
                            $("#lastCard").val("");
                            loadGrid(locationResult);
                            break;
                        default:
                            swal('An Error occurred: ' + status + "\n Data:" + data);
                            break;
                    }
                }
            );

        }

        function ReceiveShip(CardShipId, ReceivedBy) {
            $.post($("#localApiDomain").val() + "CardShips/Update",
            //$.post("http://localhost:52839/api/CardShips/Update",
                { 'CardShipId': CardShipId, 'CardShipReceivedBy': ReceivedBy },
                function (data, status) {
                    switch (status) {
                        case 'success':
                            loadGrid(locationResult);
                            swal('Cards were received successfully');
                            break;
                        default:
                            swal('An Error occurred: ' + status + "\n Data:" + data);
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
                        <div class="col-sm-12" style="text-align:center">
                            <label style="background-color:white;padding:4px;display:none;">Highest Card Ordered and Received - </label><label id="availableCard" style="background-color:white;padding:4px;display:none;"></label>
                        </div>
                    </div>
                    <div class="row search-size">
                        <div class="col-sm-7">
                            <div class="row search-size">
                                <div>
                                    <div id="fromlocationCombo"></div>
                                    <div id="tolocationCombo"></div>
                                </div>
                                <div class="col-sm-15">
                                    <input type="button" id="shipType" value="Ship: Regular" />
                                </div>
                                <div id="regShip" class="swapfields">
                                    <div class="col-sm-15">
                                        <input type="text" id="lastShipped" placeholder="Last Card Shipped" disabled />
                                    </div>
                                    <div class="col-sm-15">
                                        <input type="text" id="shipAmount" placeholder="Amount to Ship"  />
                                    </div>
                                    <div class="col-sm-15">
                                        <%--<div id="jqxdatetimeinputShip"></div>--%>
                                    </div>
                                </div>
                                <div id="specShip" class="swapfields">
                                    <div class="col-sm-15">
                                        <input type="number" id="firstCard" placeholder="First Card" />
                                    </div>
                                    <div class="col-sm-15">
                                        <input type="number" id="lastCard" placeholder="Last Card"  />
                                    </div>
                                    <div class="col-sm-15">
                                        <%--<div id="jqxdatetimeinputSpecShip"></div>--%>
                                    </div>
                                </div>
                                <div id="cardDesign"></div>
                            </div>
                        </div>
                        <div class="col-sm-5">
                            <div class="row search-size">
                                <div class="row search-size">
                                    <div class="col-sm-4">
                                        <input type="button" id="placeShip" value="Place Shipping" />
                                    </div>
                                    <div class="col-sm-4">
                                        <input type="button" id="receiveShip" value="Receive Shipping" />
                                    </div>
                                    <div class="col-sm-4">
                                        <input type="button" id="editShip" value="Update Shipping" class="RFR" />
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
                <div id="jqxShipping"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->
    
</asp:Content>

