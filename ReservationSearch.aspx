<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="ReservationSearch.aspx.cs" Inherits="ReservationSearch" %>

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

            //#region SetupButtons
            $("#btnSearch").jqxButton({ width: '100%', height: 26 });
            //#endregion

            $("#btnSearch").on("click", function (event) {
                if ($("#ReservationId").val() != "") {
                    loadGrid();
                }
            });
        });

        // ============= Initialize Page ================== End

        function loadGrid()
        {
            var ReservationId = $("#ReservationId").val();


            // loading order histor
            //var url = $("#localApiDomain").val() + "Reservations/GetReservation/" + ReservationId;
            var url = "http://localhost:52839/api/Reservations/GetReservation/" + ReservationId;

            var source =
            {
                datafields: [
                    { name: 'ReservationId' },
                    { name: 'ReservationNumber' },
                    { name: 'ShortNameLocation' },
                    { name: 'StartDatetime' },
                    { name: 'EndDatetime' },
                    { name: 'CanceledDate' },
                    { name: 'FirstName' },
                    { name: 'LastName' },
                    { name: 'MemberId' },
                ],
                id: 'RedemptionId',
                type: 'Get',
                datatype: "json",
                url: url,
            };

            // create jqxgrid
            $("#jqxReservation").jqxGrid(
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
                enablebrowserselection: true,
                columns: [
                       { text: 'ReservationId', datafield: 'ReservationId' },
                       { text: 'ReservationNumber', datafield: 'ReservationNumber' },
                       { text: 'ShortNameLocation', datafield: 'ShortNameLocation' },
                       { text: 'StartDatetime', datafield: 'StartDatetime', cellsrenderer: DateRender },
                       { text: 'EndDatetime', datafield: 'EndDatetime', cellsrenderer: DateTimeRender },
                       { text: 'CanceledDate', datafield: 'CanceledDate', cellsrenderer: DateTimeRender },
                       { text: 'FirstName', datafield: 'FirstName' },
                       { text: 'LastName', datafield: 'LastName' },
                       { text: 'MemberId', datafield: 'MemberId' },
                ]
            });
        }

        
      

    </script>

    <div id="ReservationSearch" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-9">
                            <div class="row search-size">
                                <div class="col-sm-12">
                                    <input type="text" id="ReservationId" placeholder="Reservation #" />
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="row search-size">
                                <div class="col-sm-8 col-sm-offset-4">
                                    <div class="row search-size">
                                        <div class="col-sm-12">
                                            <input type="button" id="btnSearch" value="Search" />
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
                <div id="jqxReservation"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->
</asp:Content>


