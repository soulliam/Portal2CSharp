<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="PendingReceipts.aspx.cs" Inherits="PendingReceipts" %>

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
    // ============= Initialize Page ==================== Begin
        var group = '<%= Session["groupList"] %>';

        $(document).ready(function () {

            $("#Save").jqxButton();
            $("#Refresh").jqxButton();

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
                var offset = $("#jqxPendingReceipts").offset();
                $("#popupLocation").jqxWindow({ position: { x: parseInt(offset.left) + 500, y: parseInt(offset.top) - 40 } });
                $('#popupLocation').jqxWindow({ width: "325px", height: "300px" });
                $('#popupLocation').jqxWindow({ isModal: true, modalOpacity: 0.7 });
                $('#popupLocation').jqxWindow({ showCloseButton: false });
                $("#popupLocation").css("visibility", "visible");
                $("#popupLocation").jqxWindow({ title: 'Pick a Location' });
                $("#popupLocation").jqxWindow('open');
            }
            else {
                loadGrid(locationResult[0]);
                $("#pendingReceiptLocation").val(locationResult[0]);
            }

            //insert place holder in location combo box
            $("#LocationCombo").on('bindingComplete', function (event) {
                $("#LocationCombo").jqxDropDownList('insertAt', 'Pick a Location', 0);
            });

            $("#Save").on("click", function (event) {
                

                var rows = $("#jqxPendingReceipts").jqxGrid('getrows');

                var length = rows.length;

                for (var i = 0; i < length ; i++) {
                    $("#jqxPendingReceipts").jqxGrid('endcelledit', i, "ReceiptNumber", false);
                    $("#jqxPendingReceipts").jqxGrid('endcelledit', i, "EntryDate", false);

                    if (rows[i].thisSelect == true) {
                        UpdateReceipt(rows[i]);
                    }
                }

                swal("Updates request completed!", "Click refresh.", 'success');
            });

            $("#Refresh").on("click", function (event) {
                var thisLocationID = $("#pendingReceiptLocation").val();
                loadGrid(thisLocationID);
            });

            Security();
        });

        //Load locationPopup if multiple locations
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
            $("#LocationCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item.index > 0) {
                        if (item) {
                            loadGrid(item.value);
                            $("#pendingReceiptLocation").val(item.value);
                            $("#popupLocation").jqxWindow('hide');
                        }
                    }
                }
            });
        }

        function loadGrid(thisLocationnId) {
            var parent = $("#jqxPendingReceipts").parent();
            $("#jqxPendingReceipts").jqxGrid('destroy');
            $("<div id='jqxPendingReceipts'></div>").appendTo(parent);

            // loading order histor
            var url = $("#localApiDomain").val() + "PendingReceipts/getPendingReceipts/" + thisLocationnId;
            //var url = "http://localhost:52839/api/PendingReceipts/getPendingReceipts/" + thisLocationnId;

            var rowEdit = function (row, event) {
                var data = $('#jqxPendingReceipts').jqxGrid('getrowdata', row);
                if (data.thisSelect == false) {
                    swal("To Edit:", "You must check a rows checkbox.", "warning");
                    return false;
                }
                return true;
            }

            var checkBoxRowEdit = function (row, event) {
                var data = $('#jqxPendingReceipts').jqxGrid('getrowdata', row);
                if (data.thisSelect == true) {
                    var oldReceiptValue = data.ReceiptNumber;
                    var oldReceiptEntryDate = data.EntryDate;
                    $("#jqxPendingReceipts").jqxGrid('endcelledit', row, "ReceiptNumber", false);
                    $("#jqxPendingReceipts").jqxGrid('endcelledit', row, "EntryDate", false);
                    $("#jqxPendingReceipts").jqxGrid('setcellvalue', row, 'ReceiptNumber', oldReceiptValue);
                    $("#jqxPendingReceipts").jqxGrid('setcellvalue', row, 'EntryDate', oldReceiptEntryDate);
                }
                return true;
            }

            var source =
            {
                datafields: [
                    { name: 'thisSelect', type: 'boolean' },
                    { name: 'PendingReceiptId' },
                    { name: 'memberName' },
                    { name: 'ReceiptNumber' },
                    { name: 'EntryDate' },
                    { name: 'SubmittedDate' },
                    { name: 'UpdateExternalUserData' },
                ],
                type: 'Get',
                datatype: "json",
                url: url,
                updaterow: function (rowid, rowdata, commit) {
                    commit(true);
                }
            };

            // creage jqxgrid
            $("#jqxPendingReceipts").jqxGrid(
            {
                width: '100%',
                height: 500,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                editable: true,
                columns: [
                       { text: 'Select', datafield: 'thisSelect', columntype: 'checkbox', cellbeginedit: checkBoxRowEdit, width: '5%' },
                       { text: 'PendingReceiptId', datafield: 'PendingReceiptId', editable: false, hidden: true },
                       { text: 'Member Name', datafield: 'memberName', editable: false, width: '20%' },
                       { text: 'Receipt Number', datafield: 'ReceiptNumber', cellbeginedit: rowEdit, width: '10%' },
                       //{ text: 'Entry Date', datafield: 'EntryDate', cellsrenderer: DateTimeRender },
                       {
                           text: 'Entry Date', datafield: 'EntryDate', cellsrenderer: DateRender, columntype: 'datetimeinput', cellbeginedit: rowEdit, width: '15%', cellsformat: 'MM/dd/yyyy',
                           validation: function (cell, value) {
                               if (value == "")
                                   return true;
                               return true;
                           }
                       },
                       { text: 'Submitted Date', datafield: 'SubmittedDate', cellsrenderer: DateTimeRender, editable: false, width: '15%' },
                       { text: 'Submitted By', datafield: 'UpdateExternalUserData', editable: false, width: '25%' },
                       {
                           text: 'Delete', datafield: 'Delete', columntype: 'button', width: '10%', cellsrenderer: function () {
                               return "Delete Receipt";
                           }, buttonclick: function (row) {
                               var data = $('#jqxPendingReceipts').jqxGrid('getrowdata', row);
                               if (data.thisSelect == false) {
                                   swal("To Edit:", "You must check a rows checkbox.", "warning");
                                   return false;
                               }
                               data = $("#jqxPendingReceipts").jqxGrid('getrowdata', row);
                               DeleteReceipt(data.PendingReceiptId);
                           }
                       },
                ]
            });
        }

        function DeleteReceipt(ReceiptId) {
            swal({
                title: 'Are you sure?',
                text: "Do you want to delete this receipt?",
                type: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#16c90a',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, delete it!'
            }).then(function () {
                $.ajax({
                    type: "GET",
                    dataType: 'json',
                    //url: "http://localhost:52839/api/PendingReceipts/deletePendingReceipts/" + ReceiptId,
                    url: $("#localApiDomain").val() + "PendingReceipts/deletePendingReceipts/" + ReceiptId,
                    success: function (status) {
                        // update command is executed.
                        swal("Receipt", "Deleted!", "success");
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        // update failed.
                        swal("Delete Error:", errorThrown.toString(), "error");
                    },
                    complete: function () {
                        var thisLocationID = $("#pendingReceiptLocation").val();
                        loadGrid(thisLocationID);
                    }
                });
            })
        }

        function UpdateReceipt(rowdata) {

            var thisEntryDate = rowdata.EntryDate;
            var thisSubmittedDate = JsonDateTimeFormat(rowdata.SubmittedDate);

            var date = new Date(thisEntryDate);
            mnth = date.getMonth() + 1;
            day = date.getDate();
            thisEntryDate = mnth + '/' + day + '/' + date.getFullYear();
                    
            var data = {
                'PendingReceiptId': rowdata.PendingReceiptId,
                'memberName': rowdata.memberName,
                'ReceiptNumber': rowdata.ReceiptNumber,
                'EntryDate': thisEntryDate,
                'SubmittedDate': thisSubmittedDate,
                'UpdateExternalUserData': rowdata.UpdateExternalUserData
            };
            $.ajax({
                type: "POST",
                dataType: 'json',
                //url: "http://localhost:52839/api/PendingReceipts/UpdatePendingReceipt/",
                url: $("#localApiDomain").val() + "PendingReceipts/UpdatePendingReceipt/",
                data: data,
                success: function (data, status, xhr) {
                    
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    // update failed.
                    swal(errorThrown);
                },
                complete: function () {
                    
                }
            });

        }

    </script>
    
    <input type="text" id="pendingReceiptLocation" style="display:none;" />
    <div id="CardInventoryShipmentReceiving" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-3 col-sm-offset-9">
                            <div class="row search-size">
                                <div class="col-sm-8 col-sm-offset-4">
                                    <div class="row search-size">
                                        <div class="col-sm-12">
                                            
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
            <div class="col-sm-9 col-md-10">
                <div id="jqxPendingReceipts"></div>
            </div>
            <div class="col-sm-3 col-md-2">
                <input type="button" id="Save" value="Save" class="editor" />
                <input style="margin-top:15px;" type="button" id="Refresh" value="Refresh" class="editor" />
            </div>
        </div>
    </div><!-- /.container-fluid -->

    <div id="popupLocation" style="visibility: hidden">
        <div>
            <div id="LocationCombo" style="float:left;"></div>
        </div>
    </div>


</asp:Content>
