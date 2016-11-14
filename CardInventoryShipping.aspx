<%@ Page Title="" Language="C#" MasterPageFile="Portal2.master" AutoEventWireup="true" CodeFile="CardInventoryShipping.aspx.cs" Inherits="CardInventoryShipping" %>

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

            //#region SetupButtons
            $("#placeShip").jqxButton({ width: '100%', height: 26 });
            $("#shipType").jqxToggleButton({ width: '100%', height: 26, toggled: false });
            $("#shipType").on('click', function () {
                $("#regShip").toggle();
                $("#specShip").toggle();
                var toggled = $("#shipType").jqxToggleButton('toggled');
                if (toggled) {
                    $("#shipType")[0].value = 'Ship: Special';
                }
                else $("#shipType")[0].value = 'Ship: Regular';
            });
            //#endregion

            GetLastCardShipped();
            GetHighestavailableCard();
            $("#jqxdatetimeinputShip").jqxDateTimeInput({ width: '100%', height: '24px', formatString: 'MM/dd/yyyy' });
            $("#jqxdatetimeinputSpecShip").jqxDateTimeInput({ width: '100%', height: '24px', formatString: 'MM/dd/yyyy' });
            
            $("#placeShip").on("click", function (event) {
                placeShip();
                loadGrid();
                GetLastCardShipped();
                GetHighestavailableCard();
                $("#shipAmount").val("");
                $("#firstCard").val("");
                $("#lastCard").val("");
            });

            $("#specShip").toggle();

            $("#confirmShip").on("click", function (event) {
               
                var getselectedrowindexes = $('#jqxShipping').jqxGrid('getselectedrowindexes');
                if (getselectedrowindexes.length > 0) {
                    for (var index = 0; index < getselectedrowindexes.length; index++) {
                        var selectedRowData = $('#jqxShipping').jqxGrid('getrowdata', getselectedrowindexes[index]);
                        confirmShip(selectedRowData.CardHistoryId);
                    }
                    loadGrid();
                } else {
                    alert("No orders selected!");
                }
                
            });

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
                url: $("#localApiDomain").val() + "Locations/Locations/",

            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#locationCombo").jqxComboBox(
            {
                width: 200,
                height: 21,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });


            $("#locationCombo").on('bindingComplete', function (event) {
                $("#locationCombo").jqxComboBox('insertAt', 'Pick a Location', 0);
            });



        });



        // ============= Initialize Page ================== End

        function loadGrid()
        {

            var parent = $("#jqxShipping").parent();
            $("#jqxShipping").jqxGrid('destroy');
            $("<div id='jqxShipping'></div>").appendTo(parent);

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
                    { name: 'NameOfLocation' },
                ],
                id: 'ManualEditId',
                type: 'Get',
                datatype: "json",
                url: url,
            };

            // creage jqxgrid
            $("#jqxShipping").jqxGrid(
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
                    var filtergroup = new $.jqx.filter();

                    var filtervalue = 2;
                    var filtercondition = 'EQUAL';
                    var filter1 = filtergroup.createfilter('numericfilter', filtervalue, filtercondition);

                    // operator between the filters in the filter group. 1 is for OR. 0 is for AND.
                    var filter_or_operator = 1;

                    filtergroup.addfilter(filter_or_operator, filter1);

                    $("#jqxShipping").jqxGrid('addfilter', 'ActivityId', filtergroup);
                    $("#jqxShipping").jqxGrid('applyfilters');
                },
                columns: [
                       { text: 'CardHistoryId', datafield: 'CardHistoryId', hidden: true },
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

        function GetLastCardShipped() {
            var cardNumber;


            $.ajax({
                type: 'GET',
                url: $("#localApiDomain").val() + 'CardDistHistorys/GetLastShipped/',
                success: function (data) {
                    $("#lastShipped").val(data[0].maxShipped);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert("HELP Error: " + errorThrown);
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
                success: function (data) {
                    $("#availableCard").html(data[0].maxShipped);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert("HELP Error: " + errorThrown);
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
            if ($("#locationCombo").jqxComboBox('selectedIndex') == 0) {
                alert("You must pick a location!");
                return;
            }

            var ActivityDateCode = $('#jqxdatetimeinputShip').jqxDateTimeInput('getDate');
            var ActivityDateValue = ActivityDateCode.toJSON();
            var ActivityIdValue = $("#Card_Activity").val();
            var StartingNumber = 0;
            var EndingNumber = 0;
            var Quantiy = 0;

            if ($("#regShip").is(":visible")) {
                if ($("#shipAmount").val() == "") {
                    alert("You must select an amount of cards to ship!");
                    return;
                }
                StartingNumber = parseInt($("#lastShipped").val()) + 1;
                EndingNumber = parseInt(StartingNumber) + parseInt($("#shipAmount").val());
                Quantiy = $("#shipAmount").val();
            }
            if ($("#specShip").is(":visible")) {
                if (StartingNumber == 0 || EndingNumber == 0) {
                    alert("You must set a starting card and an ending card to do a special order.");
                    return;
                }

                StartingNumber = $("#firstCard").val();
                EndingNumber = $("#lastCard").val();
                Quantity = parseInt(EndingNumber) - parseInt(StartingNumber);
            }
            

            //alert('ADT:' + ActivityDateValue + 'AID:' + ActivityIdValue + 'F:' + $("#FirstCardValue").val() + ' Last:' + $("#LastCardValue").val() + ' Qt:' + $("#QuantityValue").val() + ' OCDt:' + $("#OrderConfirmationDateValue").val() + 'DP:' + $("#DistributionPointValue").val() + ' bus:' + $("#BusOrRepIDValue").val() + ' sft:' + $("#ShiftValue").val() + ' dt:' + new Date().toJSON() + ' Usr:' + $("#txtLoggedinUsername").val())
            $.post($("#localApiDomain").val() + "CardDistHistorys/Post",
                { 'ActivityDate': ActivityDateValue, 'ActivityId': 2, 'StartingNumber': StartingNumber, 'EndingNumber': EndingNumber, 'NumberOfCards': Quantiy, 'OrderConfirmationDate': '1/1/1900', 'DistributionPoint': 0, 'BusOrRepID': null, 'Shift': null, 'RecordDate': new Date(), 'RecordedBy': $("#txtLoggedinUsername").val(), 'LocationId': $("#locationCombo").jqxComboBox('getSelectedItem').value },
                function (data, status) {
                    switch (status) {
                        case 'success':
                            $("#statusMessage").attr("class", "status");
                            $("#statusMessage").html('Cards were created successfully');
                            alert('Cards were created successfully');
                            break;
                        default:
                            $("#statusMessage").attr("class", "warning");
                            $("#statusMessage").html('An Error occurred: ' + status + "\n Data:" + data);
                            alert('An Error occurred: ' + status + "\n Data:" + data);
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
                            <label style="background-color:white;padding:4px;">Highest Card Ordered and Received - </label><label id="availableCard" style="background-color:white;padding:4px;"></label>
                        </div>
                    </div>
                    <div class="row search-size">
                        <div class="col-sm-3">
                            <div id="locationCombo"></div>
                        </div>
                        <div class="col-sm-7">
                            <div class="row search-size">
                                <div class="col-sm-15">
                                    <input type="button" id="shipType" value="Ship: Regular" />
                                </div>
                                <div id="regShip" class="swapfields">
                                    <div class="col-sm-15">
                                        <input type="text" id="lastShipped" placeholder="Last Card Shipped" />
                                    </div>
                                    <div class="col-sm-15">
                                        <input type="text" id="shipAmount" placeholder="Amount to Ship"  />
                                    </div>
                                    <div class="col-sm-15">
                                        <div id="jqxdatetimeinputShip"></div>
                                    </div>
                                </div>
                                <div id="specShip" class="swapfields">
                                    <div class="col-sm-15">
                                        <input type="text" id="firstCard" placeholder="First Card" />
                                    </div>
                                    <div class="col-sm-15">
                                        <input type="text" id="lastCard" placeholder="Last Card"  />
                                    </div>
                                    <div class="col-sm-15">
                                        <div id="jqxdatetimeinputSpecShip"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-2">
                            <div class="row search-size">
                                <div class="col-sm-8 col-sm-offset-4">
                                    <div class="row search-size">
                                        <div class="col-sm-12">
                                            <input type="button" id="placeShip" value="Place Shipping" />
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
                <div id="jqxShipping"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->
    
</asp:Content>

