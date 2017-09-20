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
    <script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>

    <script type="text/javascript">
        // ============= Initialize Page ==================== Begin
       var group = '<%= Session["groupList"] %>';

        $(document).ready(function () {
            $("#date").jqxDateTimeInput({ formatString: 'MM-dd-yyyy', width: '100%', height: '24px' });
            
            var locationString = $("#userLocation").val();
            var locationResult = locationString.split(",");

            $("#jqxCheckBox").jqxCheckBox({ width: 120, height: 25 });

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
            }

            LoadLocationPopup(thisLocationString);

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
                $('#popupWindow').jqxWindow({ height: '300px', width: '50%' });
                $('#popupWindow').jqxWindow({ minHeight: '300px', minWidth: '50%' });
                $('#popupWindow').jqxWindow({ maxHeight: '500px', maxWidth: '50%' });
                $('#popupWindow').jqxWindow({ showCloseButton: true });
                $('#popupWindow').jqxWindow({ animationType: 'combined' });
                $('#popupWindow').jqxWindow({ showAnimationDuration: 300 });
                $('#popupWindow').jqxWindow({ closeAnimationDuration: 500 });
                $("#popupWindow").jqxWindow('open');
            });

            // saving new or changed city
            $("#Save").click(function () {
                var myDate = new Date();
                var adjustment = 0;

                if ($('#jqxCheckBox').jqxCheckBox('checked'))
                {
                    adjustment = 1;
                }

                myDate = $("#date").val();

                var data = { 'Shift1': $("#Shift1").val(), 'Shift2': $("#Shift2").val(), 'Shift3': $("#Shift3").val(), 'Total': $("#Total").val(), 'BoothCardCountDate': myDate, 'LocationId': $("#boothLocation").val(), 'Adjustment': adjustment };

                $.ajax({
                    type: "POST",
                    //url: "http://localhost:52839/api/BoothCardCounts/Post",
                    url: $("#localApiDomain").val() + "BoothCardCounts/Post/",

                    data: data,
                    dataType: "json",
                    success: function (Response) {
                        swal("Saved!");
                        success = true;
                    },
                    error: function (request, status, error) {
                        swal(error + " - " + request.responseText);
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

            $("#Total").focus(function () {
                if ($("#Shift1").val() != '' || $("#Shift2").val() != '' || $("#Shift3").val() != '')
                {
                    $("#popupWindow").jqxWindow('close');
                    swal({
                        title: "Changing Total",
                        text: "If you want to manually enter the total, you cannot enter shift amounts.  Please clear them.",
                        buttons: true
                    }).then(function (data) {
                        $("#popupWindow").jqxWindow('open');
                        $("#Total").blur();
                    });
                    
                }
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
                loadGrid($("#boothLocation").val());
            }

            $("#LocationCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {
                        $("#boothLocation").val(item.value);
                        $("#popupLocation").jqxWindow('hide');
                        loadGrid(item.value);
                        LoadCardLevel();
                    }
                }
            });

            Security();

            if (group.indexOf("Portal_Superadmin") > -1 || group.indexOf("Portal_Auditadmin") > -1) {
                $("#hideAdjustment").css('display', 'block');
            }

        });
        // ============= Initialize Page ================== End

        //Loads count grid
        function loadGrid(thisLocationId) {

            var url = $("#localApiDomain").val() + "BoothCardCounts/GetBoothCardCount/" + thisLocationId;;
            //var url = "http://localhost:52839/api/BoothCardCounts/GetBoothCardCount/" + thisLocationId;


            var source =
            {
                datafields: [
                    { name: 'BoothCardCountId' },
                    { name: 'Shift1' },
                    { name: 'Shift2' },
                    { name: 'Shift3' },
                    { name: 'Total' },
                    { name: 'BoothCardCountDate' },
                    { name: 'Adjustment' },
                    { name: 'NameOfLocation' }
                ],

                id: 'BoothCardCountId',
                type: 'Get',
                datatype: "json",
                url: url,
                pagesize: 12,
                root: "data"
            };

            var Adjustment = function (row, columnfield, value, defaulthtml, columnproperties) {
                // format date as string due to inconsistant date coversions
                switch (true) {
                    case (value == 0):
                        return '<div style="margin-top: 10px;margin-left: 5px">&nbsp;</div>';
                        break;
                    case (value == 1):
                        return '<div style="margin-top: 10px;margin-left: 5px">True</div>';
                        break;
                }
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
                selectionmode: 'singlecell',
                //editable: true,
                filterable: true,
                columns: [
                      { text: 'BoothCardCountId', datafield: 'BoothCardCountId', hidden: true },
                      { text: 'Shift1', datafield: 'Shift1' },
                      { text: 'Shift2', datafield: 'Shift2' },
                      { text: 'Shift3', datafield: 'Shift3' },
                      { text: 'Total', datafield: 'Total' },
                      { text: 'BoothCardCountDate', datafield: 'BoothCardCountDate', cellsrenderer: DateRender },
                      { text: 'Adjustment', datafield: 'Adjustment', cellsrenderer: Adjustment },
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
            //$('#popupWindow').jqxWindow({ isModal: true });
            $("#popupWindow").css("visibility", "visible");
            $('#popupWindow').jqxWindow({ height: '300px', width: '50%' });
            $('#popupWindow').jqxWindow({ minHeight: '300px', minWidth: '50%' });
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
                url: $("#localApiDomain").val() + "Locations/LocationByLocationIds/" + thisLocationString

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

        function LoadCardLevel() {
            var thisLocation = $("#boothLocation").val();

            var url = $("#localApiDomain").val() + "BoothCardCounts/GetBoothLevel/" + thisLocation;
            //var url = "http://localhost:52839/api/BoothCardCounts/GetBoothLevel/" + thisLocation;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                success: function (data) {
                    $("#boothLevel").val(data[0].Level);
                },
                error: function (request, status, error) {
                    swal(status);
                }
            });

        }

    </script>
    <input type="text" id="boothLocation" style="display:none;" />
    <div id="BoothCardCount" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-2">
                    <label style="color:white;">Card Level</label>
                    <input type="text" id="boothLevel" value="New Count" />
                </div>
                <div class="col-sm-10 col-md-10 col-md-offset-1">
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
                            <div class="form-group">
                                <label for="Date" class="col-sm-3 col-md-4 control-label">Date:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div id="date"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="top-divider">
                            <div class="col-sm-1 col-md-3">
                            </div>
                            <div class="col-sm-4 col-md-3">
                                <input type="button" id="Save" value="Save" />
                            </div>
                            <div class="col-sm-4 col-md-3">
                                <input type="button" id="Cancel" value="Cancel" />
                            </div>
                            <div class="col-sm-3 col-md-3">
                                <div id="hideAdjustment" style="display:none"><div id='jqxCheckBox' style='margin-left: 10px; float: left;'>Ajustment</div></div>
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

