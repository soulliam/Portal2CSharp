<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="MailerCodeSearch.aspx.cs" Inherits="MailerCodeSearch" %>

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
        var group = '<%= Session["groupList"] %>';

        $(document).ready(function () {

            $("div.FPR_SearchLeft input:text").keypress(function (e) {
                if (e.keyCode == 13) {
                    loadSearchResults();
                }
            });

            $("#btnSearch").jqxButton();

            $("#btnSearch").on("click", function (event) {
                loadSearchResults();
            });
            Security();
        });

        

        function loadSearchResults() {

            var parent = $("#jqxSearchGrid").parent();
            $("#jqxSearchGrid").jqxGrid('destroy');
            $("<div id='jqxSearchGrid'></div>").appendTo(parent);

            var thisMailerCode = $("#MailerCode").val();

            //var url = "http://localhost:52839/api/MailerCodes/GetMailerCode/" + thisMailerCode;
            var url = $("#localApiDomain").val() + "MailerCodes/GetMailerCode/" + thisMailerCode;


            var source =
            {
                datafields: [
                    { name: 'flyer_id' },
                    { name: 'promo_code' },
                    { name: 'CompanyName' },
                    { name: 'ShortLocationName' },
                    { name: 'FirstName' },
                    { name: 'LastName' },
                    { name: 'rate_code' },
                    { name: 'created_at' },
                    { name: 'updated_at' },
                    { name: 'deleted_at' }
                ],
                id: 'flyer_id',
                type: 'GET',
                datatype: "json",
                url: url
            };

            var initrowdetails = function (index, parentElement, gridElement, record) {
                var id = record.uid.toString();
                var grid = $($(parentElement).children()[0]);

                //Detail Grid Source
                var url = $("#localApiDomain").val() + "MailerCodes/GetMailerCodeSends/" + id;
                //var url = "http://localhost:52839/api/MailerCodes/GetMailerCodeSends/" + id;

                var detailSource =
                {
                    datafields: [
                        { name: 'contact_email' },
                        { name: 'created_at' },
                        { name: 'updated_at' }
                    ],
                    datatype: "json",
                    url: url
                };

                var nestedGridAdapter = new $.jqx.dataAdapter(detailSource);

                if (grid != null) {
                    grid.jqxGrid({
                        source: nestedGridAdapter, width: '95%', height: 200,
                        columns: [
                            { text: 'Contact Email', datafield: 'contact_email' },
                            { text: 'Sent Date', datafield: 'created_at', cellsrenderer: DateTimeRender },
                            { text: 'Updated Date', datafield: 'updated_at', cellsrenderer: DateTimeRender }
                        ]
                    });
                }
            }

            // create Searchlist Grid
            $("#jqxSearchGrid").jqxGrid(
            {
                width: '100%',
                height: 500,
                source: source,
                columnsresize: true,
                enablebrowserselection: true,
                rowdetails: true,
                initrowdetails: initrowdetails,
                rowdetailstemplate: { rowdetails: "<div id='grid' style='margin: 10px;'></div>", rowdetailsheight: 275, rowdetailshidden: true },
                columns: [
                      { text: 'flyer_id', datafield: 'flyer_id', hidden: true },
                      { text: 'Mailer Code', datafield: 'promo_code', width: '11%' },
                      { text: 'Company Name', datafield: 'CompanyName', width: '12%' },
                      { text: 'Location', datafield: 'ShortLocationName', width: '11%' },
                      { text: 'Rate', datafield: 'rate_code', width: '11%' },
                      { text: 'Create Date', datafield: 'created_at', cellsrenderer: DateTimeRender, width: '11%' },
                      { text: 'Update Date', datafield: 'updated_at', cellsrenderer: DateTimeRender, width: '11%' },
                      { text: 'Deleted Date', datafield: 'deleted_at', cellsrenderer: DateTimeRender, width: '11%' },
                      { text: 'First Name', datafield: 'FirstName', width: '11%' },
                      { text: 'Last Name', datafield: 'LastName', width: '11%' },
                ]
            });

            $("#jqxSearchGrid").bind('rowdoubleclick', function (event) {
                
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
                                </div>
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                    <input type="text" id="MailerCode" placeholder="Mailer Code"  />
                                </div>
                                <div class="col-sm-15">
                                    <input type="button" id="btnSearch" value="Search" />
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
                <div id="jqxSearchGrid"></div>
            </div>
            <%--<div class="col-sm-2">
                
                <div style="margin-top:40px;margin-right:20px;display:none;">
                    <input type="text" id="txtAssignTransaction" placeholder="Add to Card" />
                    <input type="button" id="btnAssignTransaction" style="margin-top:15px;"" value="Add to Card" class="editor" />
                </div>
                            
            </div>--%>
        </div>
       
    </div><!-- /.container-fluid -->
</asp:Content>
