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

    <script type="text/javascript">
        // ============= Initialize Page ==================== Begin
        $(document).ready(function () {
            
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

                            loadGridOut(item.value);
                            loadGrid(item.value);
                        }
                    }
                });
            });

            


        });
        // ============= Initialize Page ================== End

        //Loads city grid
        function loadGrid(thisLocationId) {
            if (thisLocationId == 0) {
                return null;
            }

            var url = $("#apiDomain").val() + "locations/" + thisLocationId + "/reservations";

            var source =
            {
                datafields: [
                    { name: 'ReservationId' },
                    { name: 'ReservationNumber' },
                    { name: 'StartDatetime', type: 'date' },
                    { name: 'EndDatetime', type: 'date' },
                    { name: 'LastName', map: 'MemberInformation>LastName' }
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
                var today = new Date();

                var weekago = new Date();

                weekago.setDate((today.getDate() - 7));

                var filtervalue = weekago;
                var filtercondition = 'GREATER_THAN_OR_EQUAL';
                var filter1 = datefiltergroup.createfilter('datefilter', filtervalue, filtercondition);

                filtervalue = today;
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
                      { text: 'ReservationId', datafield: 'ReservationId' },
                      { text: 'ReservationNumber', datafield: 'ReservationNumber' },
                      { text: 'StartDatetime', datafield: 'StartDatetime', cellsformat: 'MM/dd/yyyy HH:mm', filtertype: 'range' },
                      { text: 'EndDatetime', datafield: 'EndDatetime', cellsformat: 'MM/dd/yyyy HH:mm' },
                      { text: 'LastName', datafield: 'LastName' }
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
                    { name: 'StartDatetime', type: 'date' },
                    { name: 'EndDatetime', type: 'date' },
                    { name: 'LastName', map: 'MemberInformation>LastName' }
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
                var today = new Date();

                var weekago = new Date();

                weekago.setDate((today.getDate() - 7));

                var filtervalue = weekago;
                var filtercondition = 'GREATER_THAN_OR_EQUAL';
                var filter1 = datefiltergroup.createfilter('datefilter', filtervalue, filtercondition);

                filtervalue = today;
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
                      { text: 'ReservationId', datafield: 'ReservationId' },
                      { text: 'ReservationNumber', datafield: 'ReservationNumber' },
                      { text: 'StartDatetime', datafield: 'StartDatetime', cellsformat: 'MM/dd/yyyy HH:mm', filtertype: 'range' },
                      { text: 'EndDatetime', datafield: 'EndDatetime', cellsformat: 'MM/dd/yyyy HH:mm' },
                      { text: 'LastName', datafield: 'LastName' }
                ]
            });

        }


    </script>
    

    <style>

    </style>

    <div id="Cities">      
        <div class="FPR_SearchBox" style="display:block;">
            <div class="FPR_SearchLeft">
            

            </div>
            <div class="FPR_SearchRight">
                <a href="javascript:" onclick="newCity();" id="btnNew">New City</a>     
            </div>
        </div>
        <div style="visibility:hidden">
            <input id="LocationId" type="text" value="0"  />
        </div>
    </div>  
    <div class="container-fluid container-970">
        <div class="row ">
            <div class="col-sm-2">
                <div id="locationCombo"></div>
            </div>
            <div class="col-sm-2">
                <div id="calendar"></div>
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

