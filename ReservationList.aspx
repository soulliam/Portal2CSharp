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

    <script type="text/javascript">
        var group = '<%= Session["groupList"] %>';

        // ============= Initialize Page ==================== Begin
        $(document).ready(function () {
            
            $("#pdfExportIn").jqxButton();
            $("#pdfExportIn").click(function () {
                $("#jqxgrid").jqxGrid('exportdata', 'pdf', 'jqxGrid');
            });

            $("#pdfExportOut").jqxButton();
            $("#pdfExportOut").click(function () {
                $("#jqxgridOUT").jqxGrid('exportdata', 'pdf', 'jqxGrid');
            });

            $("#btnView").jqxButton();


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
                            var parent = $("#jqxgrid").parent();
                            $("#jqxgrid").jqxGrid('destroy');
                            $("<div id='jqxgrid'></div>").appendTo(parent);

                            var parent = $("#jqxgridOUT").parent();
                            $("#jqxgridOUT").jqxGrid('destroy');
                            $("<div id='jqxgridOUT'></div>").appendTo(parent);

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
            if (thisLocationId == 0) {
                return null;
            }

            var url = $("#apiDomain").val() + "locations/" + thisLocationId + "/reservations";

            var source =
            {
                datafields: [
                    { name: 'ReservationId',  type: 'string' },
                    { name: 'ReservationNumber' },
                    { name: 'StartDatetime' },
                    { name: 'EndDatetime' },
                    { name: 'FirstName', map: 'MemberInformation>FirstName' },
                    { name: 'LastName', map: 'MemberInformation>LastName' },
                    { name: 'IsGuest', map: 'MemberInformation>IsGuest', type: 'boolean' }
                ],
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                id: 'CityID',
                type: 'Get',
                datatype: "json",
                url: url,
                pagesize: 6,
                root: "data"
            };

            var addDefaultfilter = function () {
                var datefiltergroup = new $.jqx.filter();
                var operator = 0;
                var strToday = "";
                var strNextDay = "";
                var today = new Date($("#calendar").val());
                var NextDay = new Date($("#calendar").val());

                NextDay = DateFormat(NextDay)
                strNextDay = NextDay.toString() + ' 23:59:59'

                today = DateFormat(today);
                strToday = today.toString() + ' 00:00:00'

                var filtervalue = strToday;
                var filtercondition = 'GREATER_THAN_OR_EQUAL';
                var filter1 = datefiltergroup.createfilter('datefilter', filtervalue, filtercondition);

                filtervalue = strNextDay;
                filtercondition = 'LESS_THAN_OR_EQUAL';
                var filter2 = datefiltergroup.createfilter('datefilter', filtervalue, filtercondition);

                datefiltergroup.addfilter(operator, filter1);
                datefiltergroup.addfilter(operator, filter2);

                //$("#jqxProgress").jqxGrid('addfilter', 'Status', statusfiltergroup);
                $("#jqxgrid").jqxGrid('addfilter', 'StartDatetime', datefiltergroup);
                $("#jqxgrid").jqxGrid('applyfilters');
            }

            // creage jqxgrid
            $("#jqxgrid").jqxGrid(
            {
                width: '100%',
                height: 300,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                pageable: true,
                pagermode: 'simple',
                filterable: true,
                ready: function () {
                    addDefaultfilter();
                },
                columns: [
                      { text: 'ReservationId', datafield: 'ReservationId', hidden: true },
                      { text: 'ReservationNumber', datafield: 'ReservationNumber' },
                      { text: 'StartDatetime', datafield: 'StartDatetime', filtertype: 'range', cellsrenderer: DateRenderWithTime },
                      { text: 'EndDatetime', datafield: 'EndDatetime', cellsrenderer: DateRenderWithTime },
                      { text: 'First Name', datafield: 'FirstName' },
                      { text: 'LastName', datafield: 'LastName' },
                      { text: 'IsGuest', datafield: 'IsGuest', columntype: 'checkbox' }
                ]
            });

        }

        function loadGridOut(thisLocationId) {
            if (thisLocationId == 0) {
                return null;
            }

            var url = $("#apiDomain").val() + "locations/" + thisLocationId + "/reservations";

            var source =
            {
                datafields: [
                    { name: 'ReservationId' },
                    { name: 'ReservationNumber' },
                    { name: 'StartDatetime' },
                    { name: 'EndDatetime' },
                    { name: 'FirstName', map: 'MemberInformation>FirstName' },
                    { name: 'LastName', map: 'MemberInformation>LastName' },
                    { name: 'IsGuest', map: 'MemberInformation>IsGuest', type: 'boolean' }
                ],
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                id: 'CityID',
                type: 'Get',
                datatype: "json",
                url: url,
                pagesize: 6,
                root: "data"
            };

            var addDefaultfilter = function () {
                var datefiltergroup = new $.jqx.filter();
                var operator = 0;
                var strToday = "";
                var strNextDay = "";
                var today = new Date($("#calendar").val());
                var NextDay = new Date($("#calendar").val());

                NextDay = DateFormat(NextDay)
                strNextDay = NextDay.toString() + ' 23:59:59'

                today = DateFormat(today);
                strToday = today.toString() + ' 00:00:00'

                var filtervalue = strToday;
                var filtercondition = 'GREATER_THAN_OR_EQUAL';
                var filter1 = datefiltergroup.createfilter('datefilter', filtervalue, filtercondition);

                filtervalue = strNextDay;
                filtercondition = 'LESS_THAN_OR_EQUAL';
                var filter2 = datefiltergroup.createfilter('datefilter', filtervalue, filtercondition);

                datefiltergroup.addfilter(operator, filter1);
                datefiltergroup.addfilter(operator, filter2);

                //$("#jqxProgress").jqxGrid('addfilter', 'Status', statusfiltergroup);
                $("#jqxgridOUT").jqxGrid('addfilter', 'EndDatetime', datefiltergroup);
                $("#jqxgridOUT").jqxGrid('applyfilters');
            }

            // creage jqxgrid
            $("#jqxgridOUT").jqxGrid(
            {
                width: '100%',
                height: 300,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                pageable: true,
                pagermode: 'simple',
                filterable: true,
                ready: function () {
                    addDefaultfilter();
                },
                columns: [
                      { text: 'ReservationId', datafield: 'ReservationId', hidden: true },
                      { text: 'ReservationNumber', datafield: 'ReservationNumber' },
                      { text: 'StartDatetime', datafield: 'StartDatetime', filtertype: 'range', cellsrenderer: DateRenderWithTime },
                      { text: 'EndDatetime', datafield: 'EndDatetime', cellsrenderer: DateRenderWithTime },
                      { text: 'First Name', datafield: 'FirstName' },
                      { text: 'LastName', datafield: 'LastName' },
                      { text: 'IsGuest', datafield: 'IsGuest', columntype: 'checkbox' }
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
                    <input type="button" value="Export Exits" id='pdfExportOut' />
                </div>
            </div>
        </div>
    </div>  
    
    <div id="holdIn">
        <div id="jqxgrid"></div>
    </div>
    <br />
    <div id="holdOut">
        <div id="jqxgridOUT"></div>
    </div>
</asp:Content>

