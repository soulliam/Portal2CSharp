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
            
            LoadLocationPopup();

            //#region SetupButtons
            $("#newCount").jqxButton({ width: '100%', height: 26 });
            $("#Save").jqxButton();
            $("#Cancel").jqxButton();
            //#endregion

            $("#newCount").on("click", function (event) {
                var offset = $("#jqxgrid").offset();
                $("#popupWindow").jqxWindow({ position: { x: '25%', y: '30%' } });
                $('#popupWindow').jqxWindow({ resizable: false });
                $('#popupWindow').jqxWindow({ draggable: true });
                $('#popupWindow').jqxWindow({ isModal: true });
                $("#popupWindow").css("visibility", "visible");
                $('#popupWindow').jqxWindow({ height: '270px', width: '50%' });
                $('#popupWindow').jqxWindow({ minHeight: '270px', minWidth: '50%' });
                $('#popupWindow').jqxWindow({ maxHeight: '500px', maxWidth: '50%' });
                $('#popupWindow').jqxWindow({ showCloseButton: true });
                $('#popupWindow').jqxWindow({ animationType: 'combined' });
                $('#popupWindow').jqxWindow({ showAnimationDuration: 300 });
                $('#popupWindow').jqxWindow({ closeAnimationDuration: 500 });
                $("#popupWindow").jqxWindow('open');
            });

            // saving new or changed city
            $("#Save").click(function () {
                Date.prototype.toMMDDYYYYString = function () { return isNaN(this) ? 'NaN' : [this.getMonth() > 8 ? this.getMonth() + 1 : '0' + (this.getMonth() + 1), this.getDate() > 9 ? this.getDate() : '0' + this.getDate(), this.getFullYear()].join('/') }

                var data = { 'Shift1': $("#Shift1").val(), 'Shift2': $("#Shift2").val(), 'Shift3': $("#Shift3").val(), 'Total': $("#Total").val(), 'BoothCardCountDate': new Date().toMMDDYYYYString(), 'LocationId': $("#boothLocation").val() };

                $.ajax({
                    type: "POST",
                    url: "http://localhost:52839/api/BoothCardCounts/Post",
                    //url: $("#localApiDomain").val() + "BoothCardCounts/Post/",

                    data: data,
                    dataType: "json",
                    success: function (Response) {
                        alert("Saved!");
                        success = true;
                    },
                    error: function (request, status, error) {
                        alert(error + " - " + request.responseText);
                    },
                    complete: function () {
                        loadGrid($("#boothLocation").val());
                    }
                });

                
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


            var locationString = $("#userLocation").val();
            var locationResult = locationString.split(",");

            if (locationResult.length > 1) {
                var thisLocationString = "";
                for (i = 0; i < locationResult.length; i++) {
                    if (i == locationResult.length - 1) {
                        thisLocationString += locationResult[i];
                    }
                    else {
                        thisLocationString += locationResult[i] + ",";
                    }

                }
                LoadLocationPopup(thisLocationString);
                $("#popupLocation").css('display', 'block');
                $("#popupLocation").css('visibility', 'hidden');

                var offset = $("#jqxgrid").offset();
                $("#popupLocation").jqxWindow({ position: { x: parseInt(offset.left) + 500, y: parseInt(offset.top) - 40 } });
                $('#popupLocation').jqxWindow({ width: "325px", height: "300px" });
                $('#popupLocation').jqxWindow({ isModal: true, modalOpacity: 0.7 });
                $('#popupLocation').jqxWindow({ showCloseButton: false });
                $("#popupLocation").css("visibility", "visible");
                $("#popupLocation").jqxWindow({ title: 'Pick a Location' });
                $("#popupLocation").jqxWindow('open');
            }
            else {
                $("#boothLocation").val(locationResult[0]);
            }

            $("#LocationCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {
                        $("#boothLocation").val(item.value);
                        $("#popupLocation").jqxWindow('hide');
                        loadGrid(item.value);
                    }

                }
            });

        });
        // ============= Initialize Page ================== End

        //Loads count grid
        function loadGrid(thisLocationId) {

            //var url = $("#localApiDomain").val() + "BoothCardCounts/GetBoothCardCount";
            var url = "http://localhost:52839/api/BoothCardCounts/GetBoothCardCount/" + thisLocationId;


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
            $("#popupWindow").jqxWindow({ position: { x: '25%', y: '30%' } });
            $('#popupWindow').jqxWindow({ resizable: false });
            $('#popupWindow').jqxWindow({ draggable: true });
            $('#popupWindow').jqxWindow({ isModal: true });
            $("#popupWindow").css("visibility", "visible");
            $('#popupWindow').jqxWindow({ height: '270px', width: '50%' });
            $('#popupWindow').jqxWindow({ minHeight: '270px', minWidth: '50%' });
            $('#popupWindow').jqxWindow({ maxHeight: '500px', maxWidth: '50%' });
            $('#popupWindow').jqxWindow({ showCloseButton: true });
            $('#popupWindow').jqxWindow({ animationType: 'combined' });
            $('#popupWindow').jqxWindow({ showAnimationDuration: 300 });
            $('#popupWindow').jqxWindow({ closeAnimationDuration: 500 });
            $("#popupWindow").jqxWindow('open');
        }

        function LoadLocationPopup(thisLocationString) {
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
                url: $("#localApiDomain").val() + "Locations/LocationByLocationIds/" + thisLocationString,

            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#LocationCombo").jqxDropDownList(
            {
                width: 300,
                height: 50,
                itemHeight: 50,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });
           
        }

    </script>
    <input type="text" id="boothLocation" style="display:none;" />
    <div id="BoothCardCount" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-3 col-sm-offset-9">
                            <div class="row search-size">
                                <div class="col-sm-8 col-sm-offset-4">
                                    <div class="row search-size">
                                        <div class="col-sm-12">
                                            <input type="button" id="newCount" value="New Count" />
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
    
    <div style="display:none;">
        <input id="LocationId" type="text" value="0"  />
    </div>  
    
    <div class="container-fluid container-970">
        <div class="row ">
            <div class="col-sm-12">
                <div id="jqxgrid"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->

    <%-- html for popup Edit box --%>
    <div id="popupWindow" style="display:none">
        <div>Count Details</div>
        <div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="Shift1" class="col-sm-3 col-md-4 control-label">Shift 1:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control countPost" id="Shift1" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="Shift2" class="col-sm-3 col-md-4 control-label">Shift 2:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control countPost" id="Shift2" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="Shift3" class="col-sm-3 col-md-4 control-label">Shift 3:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control countPost" id="Shift3" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="Total" class="col-sm-3 col-md-4 control-label">Total:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="Total" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="top-divider">
                            <div class="col-sm-2 col-md-3">
                            </div>
                            <div class="col-sm-4 col-md-3">
                                <input type="button" id="Save" value="Save" />
                            </div>
                            <div class="col-sm-4 col-md-3">
                                <input type="button" id="Cancel" value="Cancel" />
                            </div>
                            <div class="col-sm-2 col-md-3">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- html for popup edit box END --%>


    <div id="popupLocation" style="display:none">
        <div>
            <div id="LocationCombo" style="float:left;"></div>
        </div>
    </div>
</asp:Content>

