<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="MarketingCode.aspx.cs" Inherits="MarketingCode" %>

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
    <script type="text/javascript" src="jqwidgets/jqxgrid.edit.js"></script>


    <script type="text/javascript">
        //Mike
        // ============= Initialize Page ==================== Begin
        var group = '<%= Session["groupList"] %>';

        if (group.indexOf("Portal_Superadmin") <= 0) {
            $(location).attr("href", "http://www.thefastpark.com");
        }

        $(document).ready(function () {

            //$("#CreateMarketingCode").jqxButton({ width: '150', height: '26' });

            //set up the to location combobox
            var locationSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'RepName' },
                    { name: 'RepID' }
                ],
                url: $("#localApiDomain").val() + "MarketingReps/Get/",
                //url: "http://localhost:52839/api/MarketingReps/Get/",
            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#MarketingReps").jqxComboBox(
            {
                width: 200,
                height: 21,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "RepName",
                valueMember: "RepID"
            });


            $("#MarketingReps").on('bindingComplete', function (event) {
                $("#MarketingReps").jqxComboBox('insertAt', 'Pick a Rep', 0);
            });

            $("#MarketingReps").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item.index <= 0) {
                        return null;
                    }
                    if (item) {
                        loadGrid(item.value);
                    }
                }
            });

            $("#CreateMarketingCode").click(function () {
                newCode();
            });

            Security();

        });



        // ============= Initialize Page ================== End

        function loadGrid(RepID)
        {
            var parent = $("#MarketinCodes").parent();
            $("#MarketinCodes").jqxComboBox('destroy');
            $("<div id='MarketinCodes'></div>").appendTo(parent);

            //var url = $("#localApiDomain").val() + "MarketingCodes/GetMarketingCodes/" + RepID;
            var url = "http://localhost:52839/api/MarketingCodes/GetMarketingCodes/" + RepID;

            var source =
            {
                datafields: [
                    { name: 'MarketingCodeId' },
                    { name: 'MarketingCode' },
                    { name: 'StartDate', type: 'date' },
                    { name: 'Active' },
                    { name: 'RepID' },
                    { name: 'Notes' },
                    { name: 'ShortNotes' },
                    { name: 'CreateUserId' },
                    { name: 'UpdateExternalUserData' }
                ],
                id: 'ManualEditId',
                type: 'Get',
                datatype: "json",
                url: url,
            };

            // creage jqxgrid
            $("#MarketinCodes").jqxGrid(
            {
                width: '100%',
                height: 500,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,

                columns: [
                       { text: 'MarketingCodeId', datafield: 'MarketingCodeId', hidden: true },
                       { text: 'MarketingCode', datafield: 'MarketingCode' },
                       { text: 'StartDate', datafield: 'StartDate', cellsformat: 'd' },
                       { text: 'Active', datafield: 'Active' },
                       { text: 'RepID', datafield: 'RepID' },
                       { text: 'Notes', datafield: 'Notes' },
                       { text: 'ShortNotes', datafield: 'ShortNotes' },
                       { text: 'CreateUserId', datafield: 'CreateUserId' },
                       { text: 'UpdateExternalUserData', datafield: 'UpdateExternalUserData' }
                ]
            });
        }

        function newCode() {
            var offset = $("#jqxgrid").offset();
            $("#popupMarketingCode").jqxWindow({ position: { x: '25%', y: '30%' } });
            $('#popupMarketingCode').jqxWindow({ resizable: true });
            $('#popupMarketingCode').jqxWindow({ draggable: true });
            $('#popupMarketingCode').jqxWindow({ isModal: true });
            $("#popupMarketingCode").css("visibility", "visible");
            $('#popupMarketingCode').jqxWindow({ height: '194px', width: '601px' });
            $('#popupMarketingCode').jqxWindow({ showCloseButton: true });
            $('#popupMarketingCode').jqxWindow({ animationType: 'combined' });
            $('#popupMarketingCode').jqxWindow({ showAnimationDuration: 300 });
            $('#popupMarketingCode').jqxWindow({ closeAnimationDuration: 500 });
            $("#popupMarketingCode").jqxWindow('open');
        }

    </script>
    
    <div id="CardInventoryShipping" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-12" style="text-align:center">
                            
                        </div>
                    </div>
                    <div class="row search-size">
                        <div class="col-sm-7">
                            <div id="MarketingReps"></div>
                        </div>
                        <div class="col-sm-5">
                           <input type="button" id="CreateMarketingCode" value="New Marketing Code" style="float:right;" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div><!-- /.container-fluid -->
    
    <div class="container-fluid container-970">
        <div class="row ">
            <div class="col-sm-12">
                <div id="MarketinCodes"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->

    <div id="popupMarketingCode" style="display:none">
        <div>
            <div class="container-fluid" style="display:table;height:100%;">
                <div class="row" style="height:33%;">
                  <div class="col-sm-3">Marketing Code</div>
                  <div class="col-sm-3"><input type="text" /></div>
                  <div class="col-sm-3">Start Date</div>
                  <div class="col-sm-3"><input type="text" /></div>
                </div>
                <div class="row" style="height:33%;">
                  <div class="col-sm-3">Notes</div>
                  <div class="col-sm-3"><input type="text" /></div>
                  <div class="col-sm-3">Short Notes</div>
                  <div class="col-sm-3"><input type="text" /></div>
                </div>
                <div class="row" style="height:33%;">
                  <div class="col-sm-6"><input type="button" value="Cancel" id="btnMarketingCodeCancel" /></div>
                  <div class="col-sm-6"><input type="button" value="Save" id="btnMarketingCodeSave" style="float:right;" /></div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

