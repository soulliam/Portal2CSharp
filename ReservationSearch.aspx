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
        var group = '<%= Session["groupList"] %>';

        $(document).ready(function () {

            //#region SetupButtons
            $("#btnSearch").jqxButton({ width: '100%', height: 26 });
            $("#cancelReservation").jqxButton({ width: '100%', height: 26 });
            $("#addReservation").jqxButton({ width: '100%', height: 26 });
            //#endregion

            $("#btnSearch").on("click", function (event) {
                if ($("#ReservationId").val() != "") {
                    loadGrid();
                }
            });

            // Cancel Reservation
            $("#cancelReservation").on("click", function (event) {
                var result = confirm("Do you want to cancel this reservation!");
                if (result != true) {
                    return null;
                }

                var ProcessList = "";
                var first = true;
                var getselectedrowindexes = $('#jqxReservationGrid').jqxGrid('getselectedrowindexes');

                if (getselectedrowindexes.length > 0) {

                    for (var index = 0; index < getselectedrowindexes.length; index++) {
                        var selectedRowData = $('#jqxReservationGrid').jqxGrid('getrowdata', getselectedrowindexes[index]);
                        if (first == true) {
                            ProcessList = ProcessList + selectedRowData.ReservationId;
                            first = false;
                        }
                        else {
                            ProcessList = ProcessList + "," + selectedRowData.ReservationId;
                        }
                    }

                    var thisReservationList = ProcessList.split(",");

                }
                else {
                    return null;
                }

                for (var i = 0, len = thisReservationList.length; i < len; i++) {

                    $.ajax({
                        headers: {
                            "Accept": "application/json",
                            "Content-Type": "application/json",
                            "AccessToken": $("#userGuid").val(),
                            "ApplicationKey": $("#AK").val()
                        },
                        type: "DELETE",
                        url: $("#apiDomain").val() + "reservations/" + thisReservationList[i],
                        dataType: "json",
                        success: function () {
                            alert("Canceled!");
                        },
                        error: function (request, status, error) {
                            alert(error + " - " + request.responseJSON.message);
                        },
                        complete: function () {
                            thisMemberId = $("#MemberId").val();
                            $('#jqxReservationGrid').jqxGrid('clearselection');
                            $('#jqxReservationGrid').jqxGrid('clear');
                            loadReservations();
                        }
                    });
                }
            });

            Security();
        });

        // ============= Initialize Page ================== End

        function loadGrid()
        {
            var ReservationId = $("#ReservationId").val();


            // loading order histor
            var url = $("#localApiDomain").val() + "Reservations/GetReservation/" + ReservationId;
            //var url = "http://localhost:52839/api/Reservations/GetReservation/" + ReservationId;

            var source =
            {
                datafields: [
                    { name: 'ReservationId' },
                    { name: 'ReservationNumber' },
                    { name: 'ShortLocationName' },
                    { name: 'EstimatedCost' },
                    { name: 'StartDatetime' },
                    { name: 'EndDatetime' },
                    { name: 'CanceledDate' },
                    { name: 'FirstName' },
                    { name: 'LastName' },
                    { name: 'FPNumber' },
                    { name: 'MemberId' },
                ],
                id: 'RedemptionId',
                type: 'Get',
                datatype: "json",
                url: url,
            };

            // create jqxgrid
            $("#jqxReservationGrid").jqxGrid(
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
                columnsresize: true,
                columns: [
                       { text: 'ReservationId', datafield: 'ReservationId', hidden: true },
                       { text: 'Reservation#', datafield: 'ReservationNumber', width: '13%' },
                       { text: 'Location', datafield: 'ShortLocationName', width: '9.5%' },
                       { text: 'Est Cost', datafield: 'EstimatedCost', width: '6%', cellsformat: 'c2' },
                       { text: 'Start Date', datafield: 'StartDatetime', cellsrenderer: DateTimeRender, width: '10%' },
                       { text: 'End Date', datafield: 'EndDatetime', cellsrenderer: DateTimeRender, width: '10%' },
                       { text: 'Canceled Date', datafield: 'CanceledDate', cellsrenderer: DateTimeRender, width: '10%' },
                       { text: 'First Name', datafield: 'FirstName', width: '9%' },
                       { text: 'Last Name', datafield: 'LastName', width: '10%' },
                       { text: 'FPNumber', datafield: 'FPNumber', width: '10%' },
                       { text: 'MemberId', datafield: 'MemberId', width: '10%' },
                ]
            });
        }

        
      

    </script>

    <div id="ReservationSearch" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-10">
                            <div class="row search-size">
                                <div class="col-sm-12">
                                    <input type="text" id="ReservationId" placeholder="Reservation #" />
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-2">
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
        <div class="row">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-10">
                            <div class="row search-size">
                                <div class="col-sm-12">
                                    <div id="jqxReservationGrid"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-2">
                            <div class="row search-size">
                                <div class="col-sm-8 col-sm-offset-4">
                                    <div class="row search-size">
                                        <div class="col-sm-12">
                                            <input type="button" id="addReservation" value="Add Reservation" class="editor" style="display:none;" />
                                            <input type="button" id="cancelReservation" value="Cancel Reservation" class="editor" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
    </div><!-- /.container-fluid -->
</asp:Content>


