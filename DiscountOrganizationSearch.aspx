<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="DiscountOrganizationSearch.aspx.cs" Inherits="DiscountOrganizationSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <link rel="stylesheet" href="jqwidgets/styles/jqx.base.css" type="text/css" />
    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>

    <script type="text/javascript" src="jqwidgets/globalization/globalize.js"></script>

    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.js"></script>    
    <script type="text/javascript" src="jqwidgets/jqxgrid.aggregates.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdata.js"></script>     
    <script type="text/javascript" src="jqwidgets/jqxgrid.selection.js"></script> 
    <script type="text/javascript" src="jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>   
    <script type="text/javascript" src="jqwidgets/jqxMaskedInput.js"></script>

    <script type="text/javascript">
        // ============= Initialize Page ==================== Begin
        var group = '<%= Session["groupList"] %>';

        $(document).ready(function () {

            $("div.FPR_SearchLeft input:text").keypress(function (e) {

                if (e.keyCode == 13) {
                    if ($("#DONumber").val() != "") {
                        loadGrid();
                    }
                }
            });

            //#region SetupButtons
            $("#btnSearch").jqxButton({ width: '100%', height: 26 });
            //#endregion

            $("#DONumber").jqxMaskedInput({ mask: '###-###-##########' });

            $('#DONumber').on('focus click', function () {
                $(this)[0].setSelectionRange(0, 0);
            })

            $("#btnSearch").on("click", function (event) {
                if ($("#DONumber").val() != "") {
                    loadGrid();
                }
            });

            Security();
        });

        // ============= Initialize Page ================== End

        function loadGrid()
        {
            var DONumber = $("#DONumber").val();


            // loading DO account owners
            var url = $("#localApiDomain").val() + "DiscountOrganizations/SearchDONumber/" + DONumber;
            //var url = "http://localhost:52839/api/DiscountOrganizations/SearchDONumber/" + DONumber;

            var source =
            {
                datafields: [
                    { name: 'MemberName' },
                    { name: 'MemberEmail' },
                    { name: 'MemberCard' },
                    { name: 'CreateDatetime' },
                    { name: 'ExpiresDatetime' }
                ],
                type: 'Get',
                datatype: "json",
                url: url,
            };

            // create jqxgrid
            $("#jqxDOGrid").jqxGrid(
            {
                width: '100%',
                height: 500,
                source: source,
                rowsheight: 35,
                altrows: true,
                enablebrowserselection: true,
                columns: [
                    { text: 'Member Name', datafield: 'MemberName' },
                    { text: 'Member Email', datafield: 'MemberEmail' },
                    { text: 'Member Card', datafield: 'MemberCard' },
                    { text: 'Date DO Added', datafield: 'CreateDatetime', cellsrenderer: DateRender },
                    { text: 'DO Expire Date', datafield: 'ExpiresDatetime', cellsrenderer: DateRender }
                ]
            });
        }

    </script>

    <div id="DOSearch" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-10">
                            <div class="row search-size">
                                <div class="col-sm-12">
                                    <input type="text" id="DONumber" placeholder="Discount Organization #" />
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
                        <div class="col-sm-12">
                            <div class="row search-size">
                                <div class="col-sm-12">
                                    <div id="jqxDOGrid"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
    </div><!-- /.container-fluid -->
</asp:Content>

