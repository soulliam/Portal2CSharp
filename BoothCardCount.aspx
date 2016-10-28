<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="BoothCardCount.aspx.cs" Inherits="BoothCardCount" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

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
            // load main city grid
            loadGrid();
            
            $("#newCount").jqxButton({ width: 80, height: 25 });

            $("#newCount").on("click", function (event) {
                var offset = $("#jqxgrid").offset();
                $("#popupWindow").jqxWindow({ position: { x: parseInt(offset.left) + 400, y: parseInt(offset.top) + 60 } });
                $('#popupWindow').jqxWindow({ resizable: false });
                $("#popupWindow").css("visibility", "visible");
                $("#popupWindow").jqxWindow({ width: '300', height: '200' });
                $("#popupWindow").jqxWindow('open');
            });

            // saving new or changed city
            $("#Save").click(function () {
                Date.prototype.toMMDDYYYYString = function () { return isNaN(this) ? 'NaN' : [this.getMonth() > 8 ? this.getMonth() + 1 : '0' + (this.getMonth() + 1), this.getDate() > 9 ? this.getDate() : '0' + this.getDate(), this.getFullYear()].join('/') }

                $.post($("#localApiDomain").val() + "BoothCardCounts/Post",
                    { 'Shift1': $("#Shift1").val(), 'Shift2': $("#Shift2").val(), 'Shift3': $("#Shift3").val(), 'Total': $("#Total").val(), 'BoothCardCountDate': new Date().toMMDDYYYYString(), 'LocationId': $("#userLocation").val() },
                    function (data, status) {
                        switch (status) {
                            case 'success':
                                alert('Counts were created successfully');
                                break;
                            default:
                                alert('An Error occurred: ' + status + "\n Data:" + data);
                                break;
                        }
                    }
                );

                loadGrid();
                $("#popupWindow").jqxWindow('hide');
                $(".countPost").val('');
                $("#Total").val('');
            });

            //clears city form for new city
            $("#Cancel").click(function () {
                $("#popupWindow").jqxWindow('hide');
                $(".countPost").val('');
                $("#Total").val('');
            });

            $(".countPost").keyup(function () {
                $("#Total").val('');
                $("#Total").val(Number($("#Shift1").val()) + Number($("#Shift2").val()) + Number($("#Shift3").val()));
            });



            $("#Total").keypress(function () {

                $(".countPost").val('');
                
            });
        });
        // ============= Initialize Page ================== End

        //Loads count grid
        function loadGrid() {

            var url = $("#localApiDomain").val() + "BoothCardCounts/GetBoothCardCount";

            var source =
            {
                datafields: [
                    { name: 'BoothCardCountId' },
                    { name: 'Shift1' },
                    { name: 'Shift2' },
                    { name: 'Shift3' },
                    { name: 'Total' },
                    { name: 'BoothCardCountDate' },
                    { name: 'NameOfLocation' }
                ],

                id: 'BoothCardCountId',
                type: 'Get',
                datatype: "json",
                url: url,
                pagesize: 12,
                root: "data"
            };

            // creage jqxgrid
            $("#jqxgrid").jqxGrid(
            {
                width: '100%',
                height: 500,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                pageable: true,
                pagermode: 'simple',
                filterable: true,
                columns: [
                      
                      //loads rest of columns for city
                      { text: 'BoothCardCountId', datafield: 'BoothCardCountId' },
                      { text: 'Shift1', datafield: 'Shift1' },
                      { text: 'Shift2', datafield: 'Shift2' },
                      { text: 'Shift3', datafield: 'Shift3' },
                      { text: 'Total', datafield: 'Total' },
                      { text: 'BoothCardCountDate', datafield: 'BoothCardCountDate' },
                      { text: 'NameOfLocation', datafield: 'NameOfLocation' }
                ]
            });

        }

        //clears city form for new city
        function newCount() {
            var offset = $("#jqxgrid").offset();
            $("#popupWindow").jqxWindow({ position: { x: parseInt(offset.left) + 400, y: parseInt(offset.top) + 60 } });
            $("#popupWindow").css("visibility", "visible");
            $("#popupWindow").jqxWindow('open');
        }

    </script>
    

    <style>

    </style>

    <div id="Cities">      
        <div class="FPR_SearchBox" style="display:block;">
            <div class="FPR_SearchLeft">
            

            </div>
            <div class="FPR_SearchRight">
                <input type="button" id="newCount" value="New Count" />    
            </div>
        </div>
        <div style="visibility:hidden">
            <input id="LocationId" type="text" value="0"  />
        </div>
    </div>      
    
    <div id="jqxgrid">
    </div>

    <%-- html for popup edit box --%>
    <div id="popupWindow" style="visibility:hidden">
            <div>Edit</div>
            <div style="overflow: hidden;">
                <table>
                    <tr>
                        <td>Shift 1:</td>
                        <td><input id="Shift1" class="countPost" /></td>
                    </tr>
                    <tr>
                        <td>Shift 2:</td>
                        <td><input id="Shift2" class="countPost"  /></td>
                    </tr>
                    <tr>
                        <td>Shift 3:</td>
                        <td><input id="Shift3" class="countPost"  /></td>
                    </tr>

                    <tr>
                        <td>Total:</td>
                        <td><input id="Total"  /></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td style="padding-top: 10px;"><input style="margin-right: 5px;" type="button" id="Save" value="Save" /><input id="Cancel" type="button" value="Cancel" /></td>
                    </tr>
                </table>
            </div>

       </div>
       <%-- html for popup edit box END --%>
</asp:Content>

