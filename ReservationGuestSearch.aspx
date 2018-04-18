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
            //#endregion

            $("#btnSearch").on("click", function (event) {
                if ($("#emailAddress").val() != "") {
                    loadGrid();
                }
            });

            Security();
        });

        // ============= Initialize Page ================== End

        function cancelReservation(thisReservationId) {
            var result = confirm("Do you want to cancel this reservation!");
            if (result != true) {
                return null;
            }

            $.ajax({
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": $("#userGuid").val(),
                    "ApplicationKey": $("#AK").val()
                },
                type: "DELETE",
                url: $("#apiDomain").val() + "reservations/" + thisReservationId,
                dataType: "json",
                success: function () {
                    alert("Canceled!");
                },
                error: function (request, status, error) {
                    alert(error + " - " + request.responseJSON.message);
                },
                complete: function () {
                    loadGrid();
                }
            });
        }

        function loadGrid()
        {
            var parent = $("#jqxGuests").parent();
            $("#jqxGuests").jqxComboBox('destroy');
            $("<div id='jqxGuests'></div>").appendTo(parent);

            var emailAddress = $("#emailAddress").val();
            var newchar = '~'
            emailAddress = emailAddress.split('.').join(newchar);

            newchar = '`'
            emailAddress = emailAddress.split('@').join(newchar);

            var url = $("#localApiDomain").val() + "ReservationGuestSearch/GetGuestsByEmail/" + emailAddress;
            //var url = "http://localhost:52839/api/ReservationGuestSearch/GetGuestsByEmail/" + emailAddress;

            var source =
            {
                datafields: [
                    { name: 'MemberId' },
                    { name: 'FirstName' },
                    { name: 'LastName' },
                    { name: 'EmailAddress' },
                    { name: 'CreateDatetime' },
                ],
                id: 'MemberId',
                type: 'Get',
                datatype: "json",
                url: url
            };

            var initrowdetails = function (index, parentElement, gridElement, record) {
                var id = record.uid.toString();
                var grid = $($(parentElement).children()[0]);

                //Detail Grid Source
                // load reservations to list
                var url = $("#apiDomain").val() + "members/" + id + "/reservations";

                var detailSource =
                {
                    datafields: [
                        { name: 'ReservationId' },
                        { name: 'ReservationNumber' },
                        { name: 'NameOfLocation', map: 'LocationInformation>NameOfLocation' },
                        { name: 'BrandName', map: 'LocationInformation>BrandInformation>BrandName' },
                        { name: 'EstimatedCost'},
                        { name: 'CreateDatetime' },
                        { name: 'StartDatetime' },
                        { name: 'EndDatetime' },
                        { name: 'ReservationStatusName', map: 'ReservationStatus>ReservationStatusName' },
                        { name: 'MemberNote' }
                    ],
                    datatype: "json",
                    url: url,
                    beforeSend: function (jqXHR, settings) {
                        jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
                        jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                    },
                    root: "data"
                };

                var nestedGridAdapter = new $.jqx.dataAdapter(detailSource);

                if (grid != null) {
                    grid.jqxGrid({
                        source: nestedGridAdapter, width: '95%', height: 200,
                        columns: [
                              {
                                  //creates the edit button
                                  text: '',
                                  pinned: true,
                                  datafield: 'Edit',
                                  width: 50,
                                  columntype: 'button',
                                  columnsresize: true,
                                  cellclassname: "editor",
                                  cellsrenderer: function () {
                                      return "Cancel";
                                  }, buttonclick: function (row, event) {
                                      var button = $(event.currentTarget);
                                      var grid = $('#' + this.owner.element.id);

                                      var rowData = grid.jqxGrid('getrowdata', row);
                                      cancelReservation(rowData.ReservationId);
                                  }
                              },
                              { text: 'ReservationId', datafield: 'ReservationId', hidden: true },
                              { text: 'Reservation Number', datafield: 'ReservationNumber', width: '9%' },
                              { text: 'Location', datafield: 'NameOfLocation', width: '9%' },
                              { text: 'Brand', datafield: 'BrandName', width: '4%' },
                              { text: 'Est Cost', datafield: 'EstimatedCost', width: '6%', cellsformat: 'c2' },
                              { text: 'Create Date', datafield: 'CreateDatetime', width: '12%', cellsrenderer: DateRender },
                              { text: 'Start Date', datafield: 'StartDatetime', width: '12%', cellsrenderer: DateTimeRender },
                              { text: 'End Date', datafield: 'EndDatetime', width: '12%', cellsrenderer: DateTimeRender },
                              { text: 'Status', datafield: 'ReservationStatusName', width: '9%' },
                              { text: 'Note', datafield: 'MemberNote', width: '27%' }
                        ]
                    });
                    //grid.on('rowclick', function(event)
                    //{ 
                    //    alert("Help");
                    //})
                }
            }

            // create jqxgrid
            $("#jqxGuests").jqxGrid(
            {
                pageable: true,
                pagermode: 'simple',
                //pagermode: 'advanced',
                pagesize: 12,
                width: '100%',
                height: 500,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                enablebrowserselection: true,
                columnsresize: true,
                rowdetails: true,
                initrowdetails: initrowdetails,
                rowdetailstemplate: { rowdetails: "<div id='grid' style='margin: 10px;'></div>", rowdetailsheight: 275, rowdetailshidden: true },
                columns: [
                       { text: 'MemberId', datafield: 'MemberId' },
                       { text: 'FirstName#', datafield: 'FirstName' },
                       { text: 'LastName', datafield: 'LastName' },
                       { text: 'EmailAddress', datafield: 'EmailAddress'},
                       { text: 'CreateDatetime', datafield: 'CreateDatetime', cellsrenderer: DateTimeRender, width: '10%' }
                ]
            });
        }

        
      

    </script>

    <div id="ReservationGuestSearch" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-9">
                            <div class="row search-size">
                                <div class="col-sm-12">
                                    <input type="text" id="emailAddress" placeholder="Email Address" />
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
                <div id="jqxGuests"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->
</asp:Content>


