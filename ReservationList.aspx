<%@ Page Title="" Language="C#" MasterPageFile="Portal2.master" AutoEventWireup="true" CodeFile="ReservationList.aspx.cs" Inherits="ReservationList" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
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
    <script type="text/javascript" src="jqwidgets/jqxdata.export.js"></script> 
    <script type="text/javascript" src="jqwidgets/jqxgrid.export.js"></script> 
    <script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxtabs.js"></script>

    <script type="text/javascript">
        var group = '<%= Session["groupList"] %>';

        // ============= Initialize Page ==================== Begin
        $(document).ready(function () {
            var count = 0;

            $('#jqxTabs').jqxTabs({ width: '100%', height: 600, position: 'top' });

            $("#pdfExportIn").jqxButton();
            $("#pdfExportIn").click(function () {
                $("#jqxgrid").jqxGrid('exportdata', 'pdf', 'jqxGrid');
            });

            $("#pdfExportOut").jqxButton();
            $("#pdfExportOut").click(function () {
                $("#jqxgridOUT").jqxGrid('exportdata', 'pdf', 'jqxGrid');
            });

            $("#btnView").jqxButton();

            $("#setComplete").jqxButton();
            $("#setComplete").on("click", function () {
                
                var rowindexes = $('#jqxgrid').jqxGrid('getselectedrowindexes');

                if (rowindexes.length > 0) {
                    for (var index = 0; index < rowindexes.length; index++) {
                        var dataRecord = $("#jqxgrid").jqxGrid('getrowdata', rowindexes[index]);
                        $.ajax({
                            async: false,
                            url: $("#localApiDomain").val() + "Reservations/CompleteReservation/" + dataRecord.ReservationId,
                            //url: "http://localhost:52839/api/Reservations/CompleteReservation/" + dataRecord.ReservationId,
                            type: 'Get',
                            success: function (response) {
                                
                            },
                            error: function (request, status, error) {
                                alert(error);
                            },
                            complete: function () {
                                
                            }
                        });

                        count = count + 1;
                    }
                    loadGrid($("#locationCombo").jqxComboBox('getSelectedItem').value);
                    
                    var thisUser = $("#txtLoggedinUsername").val();
                    var thisLocationID = $("#locationCombo").jqxComboBox('getSelectedItem').value;
                    var d = new Date();
                    var thisDate = DateFormat(d);

                    PageMethods.LogSetComplete(thisUser, thisLocationID, thisDate, 'There were ' + count + ' set as complete', DisplayPageMethodResults);
                    swal("Complete");
                }
            });

            $("#calendar").jqxDateTimeInput({ formatString: 'MM-dd-yyyy', width: '100%', height: '24px' });

            //Place holder grid
            var placeholderSource = {};
            $("#jqxgrid").jqxGrid(
            {
                width: '100%',
                height: 300,
                source: placeholderSource,
                
            });

            $("#jqxgridOUT").jqxGrid(
            {
                width: '100%',
                height: 300,
                source: placeholderSource,

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
                theme: 'shinyblack',
                width: '100%',
                height: 24,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });

            $("#locationCombo").on('bindingComplete', function (event) {
                $("#locationCombo").jqxComboBox('insertAt', 'Location', 0);
                $("#locationCombo").on('select', function (event) {
                    if (event.args) {
                        var item = event.args.item;
                        if (item) {

                            if ($('#calendar').jqxDateTimeInput('disabled') == true) {
                                $("#calendar").jqxDateTimeInput({ disabled: false });
                                $("#btnView").jqxButton({ disabled: false });
                            }
                            
                            
                        }
                    }
                });
            });

            $('#calendar').on('change', function (event) {
                var parent = $("#jqxgrid").parent();
                $("#jqxgrid").jqxGrid('destroy');
                $("<div id='jqxgrid'></div>").appendTo(parent);

                var parent = $("#jqxgridOUT").parent();
                $("#jqxgridOUT").jqxGrid('destroy');
                $("<div id='jqxgridOUT'></div>").appendTo(parent);
            });

            $("#btnView").on("click", function (event) {
                loadGridOut($("#locationCombo").jqxComboBox('getSelectedItem').value);
                loadGrid($("#locationCombo").jqxComboBox('getSelectedItem').value);
            });

            $("#calendar").jqxDateTimeInput({ disabled: true });
            $("#btnView").jqxButton( { disabled: true });
            
            Security();

        });
        // ============= Initialize Page ================== End

        var DateRenderWithTime = function (row, columnfield, value, defaulthtml, columnproperties) {
            // format date as string due to inconsistant date coversions
            var thisDateTime = value;

            if (thisDateTime != "") {
                thisDateTime = thisDateTime.split("T");

                var thisDate = thisDateTime[0].split("-");
                var thisTime = thisDateTime[1].split(":");

                var newDate = thisDate[1] + "/" + thisDate[2] + "/" + thisDate[0] + ' ' + thisTime[0] + ':' + thisTime[1];

                return newDate;
            } else {
                return "";
            }

        };

        function loadGrid(thisLocationId) {
            var parent = $("#jqxgrid").parent();
            $("#jqxgrid").jqxGrid('destroy');
            $("<div id='jqxgrid'></div>").appendTo(parent);

            if (thisLocationId == 0) {
                return null;
            }

            var thisDay = new Date($("#calendar").val());

            thisDay = DateFormat(thisDay)
            thisDay = thisDay.replace(/\//g, "A");

            //Master Grid
            var url = $("#localApiDomain").val() + "Reservations/GetReservationIncomingDate/" + thisDay + "_" + thisLocationId;
            //var url = "http://localhost:52839/api/Reservations/GetReservationIncomingDate/" + thisDay + "_" + thisLocationId;

            var source =
            {
                datafields: [
                    { name: 'ReservationId',  type: 'string' },
                    { name: 'ReservationNumber' },
                    { name: 'StartDatetime' },
                    { name: 'EndDatetime' },
                    { name: 'FirstName', },
                    { name: 'LastName', },
                    { name: 'FPNumber', },
                    { name: 'IsGuest', type: 'boolean' },
                    { name: 'Options', type: 'boolean' },
                    { name: 'ReservationStatusName' }
                ],
                id: 'ReservationId',
                type: 'Get',
                datatype: "json",
                url: url,
                pagesize: 6
            };

            var initrowdetails = function (index, parentElement, gridElement, record) {
                var id = record.uid.toString();
                var grid = $($(parentElement).children()[0]);

                //Detail Grid Source
                var url = $("#localApiDomain").val() + "LocationHasFeatures/GetFeature/" + id;
                //var url = "http://localhost:52839/api/LocationHasFeatures/GetFeature/" + id;

                var detailSource =
                {
                    datafields: [
                        { name: 'LocationHasFeatureId' },
                        { name: 'OptionalExtrasName' }
                    ],
                    datatype: "json",
                    url: url
                };

                var nestedGridAdapter = new $.jqx.dataAdapter(detailSource);

                if (grid != null) {
                    grid.jqxGrid({
                        source: nestedGridAdapter, //width: 780, height: 200,
                        columns: [
                          { text: 'LocationHasFeatureId', datafield: 'LocationHasFeatureId', hidden: true },
                          { text: 'Optional Extras', datafield: 'OptionalExtrasName' }
                        ]
                    });
                }
            }

            // creage jqxgrid
            $("#jqxgrid").jqxGrid(
            {
                width: '100%',
                height: 550,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                rowdetails: true,
                initrowdetails: initrowdetails,
                selectionmode: 'checkbox',
                enablebrowserselection: true,
                rowdetailstemplate: { rowdetails: "<div id='grid' style='margin: 10px;'></div>", rowdetailsheight: 220, rowdetailshidden: true },
                //ready: function () {
                //    $("#jqxgrid").jqxGrid('showrowdetails', 1);
                //},
                columns: [
                      { text: 'ReservationId', datafield: 'ReservationId', hidden: true },
                      { text: 'ReservationNumber', datafield: 'ReservationNumber' },
                      { text: 'StartDatetime', datafield: 'StartDatetime', filtertype: 'range', cellsrenderer: DateRenderWithTime },
                      { text: 'EndDatetime', datafield: 'EndDatetime', cellsrenderer: DateRenderWithTime },
                      { text: 'First Name', datafield: 'FirstName' },
                      { text: 'LastName', datafield: 'LastName' },
                      { text: 'FPNumber', datafield: 'FPNumber' },
                      { text: 'IsGuest', datafield: 'IsGuest', columntype: 'checkbox' },
                      { text: 'Options', datafield: 'Options', columntype: 'checkbox' },
                      { text: 'Status', datafield: 'ReservationStatusName' }
                ]
            });
        }

        function loadGridOut(thisLocationId) {
            var parent = $("#jqxgridOUT").parent();
            $("#jqxgridOUT").jqxGrid('destroy');
            $("<div id='jqxgridOUT'></div>").appendTo(parent);

            if (thisLocationId == 0) {
                return null;
            }

            var thisDay = new Date($("#calendar").val());

            thisDay = DateFormat(thisDay)
            thisDay = thisDay.replace(/\//g, "A");

            var url = $("#localApiDomain").val() + "Reservations/GetReservationOutGoingDate/" + thisDay + "_" + thisLocationId;
            //var url = "http://localhost:52839/api/Reservations/GetReservationOutGoingDate/" + thisDay + "_" + thisLocationId;

            var source =
            {
                datafields: [
                    { name: 'ReservationId', type: 'string' },
                    { name: 'ReservationNumber' },
                    { name: 'StartDatetime' },
                    { name: 'EndDatetime' },
                    { name: 'FirstName', },
                    { name: 'LastName', },
                    { name: 'FPNumber', },
                    { name: 'IsGuest', type: 'boolean' },
                    { name: 'ReservationStatusName' }
                ],
                id: 'ReservationId',
                type: 'Get',
                datatype: "json",
                url: url,
                pagesize: 6
            };


            // creage jqxgrid
            $("#jqxgridOUT").jqxGrid(
            {
                width: '100%',
                height: 550,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                columns: [
                      { text: 'ReservationId', datafield: 'ReservationId', hidden: true },
                      { text: 'ReservationNumber', datafield: 'ReservationNumber' },
                      { text: 'StartDatetime', datafield: 'StartDatetime', filtertype: 'range', cellsrenderer: DateRenderWithTime },
                      { text: 'EndDatetime', datafield: 'EndDatetime', cellsrenderer: DateRenderWithTime },
                      { text: 'First Name', datafield: 'FirstName' },
                      { text: 'LastName', datafield: 'LastName' },
                      { text: 'FPNumber', datafield: 'FPNumber' },
                      { text: 'IsGuest', datafield: 'IsGuest', columntype: 'checkbox' },
                      { text: 'Status', datafield: 'ReservationStatusName' }
                ]
            });

        }


    </script>
    

    <style>

    </style>

    <div id="ReservationList">      
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-2">
                    <div id="locationCombo"></div>
                </div>
                <div class="col-sm-3">
                    <div id="calendar"></div>
                    <input type="button" value="View" id='btnView' />
                </div>
                <div class="col-sm-3">
                </div>
                <div class="col-sm-2">
                    <input type="button" value="Export Entrances" id='pdfExportIn' />
                </div>
                <div class="col-sm-2">
                    <div><input type="button" value="Export Exits" id='pdfExportOut' /></div>
                    <div><input type="button" value="Set Completed" id="setComplete" /></div>
                </div>
            </div>
        </div>
    </div>  
    
    <div  style="margin:15px;">
        <div id='jqxTabs'>
            <ul>
                <li style="margin-left: 30px;">Entrances</li>
                <li>Exits</li>
            </ul>
            <div>
                <div id="holdIn">
                    <div id="jqxgrid"></div>
                </div>
            </div>
            <div>
                <div id="holdOut">
                    <div id="jqxgridOUT"></div>
                </div>
            </div>
        </div>
    </div>
    
</asp:Content>

