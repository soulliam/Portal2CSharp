<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="TransactionSearch.aspx.cs" Inherits="TransactionSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <link rel="stylesheet" href="/jqwidgets/styles/jqx.base.css" type="text/css" />


    <script type="text/javascript" src="scripts/Member/UpdateMember.js"></script>
    <script type="text/javascript" src="scripts/Member/MemberReservation.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.js"></script>
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
    <script type="text/javascript" src="jqwidgets/jqxgrid.selection.js"></script> c
    <script type="text/javascript" src="jqwidgets/jqxgrid.sort.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>    
    <script type="text/javascript" src="jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxtabs.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxloader.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxradiobutton.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.edit.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdropdownbutton.js"></script>

    <script type="text/javascript">
        var calendarChanged = false;

        $(document).ready(function () {
            $("#btnSearch").jqxButton();
            $("#btnClear").jqxButton();
            $("#btnAssignTransaction").jqxButton();

            $("#jqxEntryCalendar").jqxDateTimeInput({ formatString: 'MM-dd-yyyy', showTimeButton: false, width: '100%', height: '24px' });
            $("#jqxExitCalendar").jqxDateTimeInput({ formatString: 'MM-dd-yyyy', showTimeButton: false, width: '100%', height: '24px' });

            loadLocationCombo();

            $("#btnSearch").on("click", function (event) {
                loadSearchResults();
            });

            $('#jqxEntryCalendar').on('change', function (event) {
                calendarChanged = true;
            });

            $('#jqxExitCalendar').on('change', function (event) {
                calendarChanged = true;
            });

            $("#jqxCheckBox").jqxCheckBox({ width: 120, height: 25 });

            $("#jqxSearchGrid").bind('rowdoubleclick', function (event) {
                var getselectedrowindexes = $('#jqxSearchGrid').jqxGrid('getselectedrowindexes');
                if (getselectedrowindexes.length > 0) {
                    // returns the selected row's data.
                    var selectedRowData = $('#jqxgrid').jqxGrid('getrowdata', getselectedrowindexes[0]);

                    var thisMemberId = selectedRowData.MemberId;
                }

                var MemberSearchURL = './MemberSearch.aspx?' + thisMemberId;
                window.open(MemberSearchURL);
            });

        });

        function loadLocationCombo() {
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
            $("#LocationCombo").jqxComboBox(
            {
                theme: 'shinyblack',
                width: '100%',
                height: 24,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });
        }

        function loadSearchResults() {

            var parent = $("#jqxSearchGrid").parent();
            $("#jqxSearchGrid").jqxGrid('destroy');
            $("<div id='jqxSearchGrid'></div>").appendTo(parent);

            //Loads SearchList from parameters

            //var url = $("#apiDomain").val() + "members/search?" + thisParameters;
            //var url = "http://localhost:52839/api/SearchTransactions/SearchTransactions/";
            var url = $("#localApiDomain").val() + "SearchTransactions/SearchTransactions/";

            if (calendarChanged == false) {
                var thisEntryDate = '';
                var thisExitDate = '';
            }
            else
            {
                var thisEntryDate = $("#jqxEntryCalendar").val();
                //var thisExitDate = $("#jqxExitCalendar").val();
            }

            var thisReceiptNumber = $("#ReceiptNumber").val();
            var thisColumnNumber = $("#ColumnNumber").val();

            var data = { "EntryDate": thisEntryDate, "ExitDate": thisExitDate, "ReceiptNumber": thisReceiptNumber, "ColumnNumber": thisColumnNumber, "ShortTermNumber": '', "LocationId": $("#LocationCombo").jqxComboBox('getSelectedItem').value, "Archive": $('#jqxCheckBox').jqxCheckBox('checked') };

            var source =
            {
                datafields: [
                    { name: 'EntryDate' },
                    { name: 'DateTimeOfTransaction' },
                    { name: 'FPNumber' },
                    { name: 'AmountPaid' },
                    { name: 'Status' },
                    { name: 'ReceiptNumber' },
                    { name: 'MemberId' }
                ],
                id: 'MemberId',
                type: 'POST',
                datatype: "json",
                data: data,
                url: url
            };

            // create Searchlist Grid
            $("#jqxSearchGrid").jqxGrid(
            {
                width: '100%',
                height: 500,
                source: source,
                columnsresize: true,
                enablebrowserselection: true,
                ready: function () {

                },
                columns: [
                      { text: 'Entry Date', datafield: 'EntryDate', width: '15%', cellsrenderer: DateTimeRender },
                      { text: 'Exit Date', datafield: 'DateTimeOfTransaction', width: '15%', cellsrenderer: DateTimeRender },
                      { text: 'FPNumber', datafield: 'FPNumber', width: '10%' },
                      { text: 'Amount Paid', datafield: 'AmountPaid', width: '10%' },
                      { text: 'Status', datafield: 'Status', width: '30%' },
                      { text: 'Receipt #', datafield: 'ReceiptNumber', width: '10%' },
                      { text: 'MemberId', datafield: 'MemberId', width: '10%' },
                ]
            });


        }

    </script>

    <div id="MemberSearch" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-12">
                            <div class="row search-size">
                                <div class="col-sm-15">
                                    <label style="font-size:large;color:white;display:none;">Exit date</label>
                                </div>
                                <div class="col-sm-15">
                                    <label style="font-size:large;color:white;">Entry date</label>
                                </div>
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                </div>
                            </div>
                            <div class="row search-size">
                                <div class="col-sm-15">
                                    <div id="jqxExitCalendar" style="display:none;"></div>
                                </div>
                                <div class="col-sm-15">
                                    <div id="jqxEntryCalendar"></div>
                                </div>
                                <div class="col-sm-15">
                                    <input type="text" id="ReceiptNumber" placeholder="Receipt Number" />
                                </div>
                                <div class="col-sm-15">
                                    <input type="text" id="ColumnNumber" placeholder="Column Number"  />
                                </div>
                                <div class="col-sm-15">
                                    <div id="LocationCombo"></div>
                                </div>
                            </div>
                            <div class="row search-size">
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                    <div>
                                        <div style="float:left;" id='jqxCheckBox'></div>
                                        <div style="float:left;position:absolute;margin-left:30px;"><label style="font-size:large;color:white;">Archive</label></div>
                                    </div>
                                    
                                </div>
                                <div class="col-sm-15"> 
                                    <input type="button" id="btnSearch" value="Search" />
                                </div>
                                <div class="col-sm-15">
                                    <input type="button" id="btnClear" value="Clear" />
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
            <div class="col-sm-10">
                <div id="jqxSearchGrid"></div>
            </div>
            <div class="col-sm-2">
                
                <div style="margin-top:40px;margin-right:20px;display:none;">
                    <input type="text" id="txtAssignTransaction" placeholder="Add to Card" />
                    <input type="button" id="btnAssignTransaction" style="margin-top:15px;"" value="Add to Card" class="editor" />
                </div>
                            
            </div>
        </div>
       
    </div><!-- /.container-fluid -->
</asp:Content>
