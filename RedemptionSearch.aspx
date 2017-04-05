<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="RedemptionSearch.aspx.cs" Inherits="RedemptionSearch" %>

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
                if ($("#RedeptionId").val() != "") {
                    loadGrid();
                }
            });

            $("#jqxRedemption").bind('rowdoubleclick', function (event) {
                var row = event.args.rowindex;
                var dataRecord = $("#jqxRedemption").jqxGrid('getrowdata', row);
                var thisRedemptionId = dataRecord.RedemptionId;
                var offset = $("#jqxRedemption").offset();
                var thisMemberId = dataRecord.MemberId;
                var toAddress = dataRecord.EmailAddress;

                showRedemption(thisRedemptionId, toAddress, thisMemberId);
            });

            Security();
        });

        // ============= Initialize Page ================== End

        function loadGrid()
        {
            var RedemptionId = $("#RedeptionId").val();


            // loading order histor
            var url = $("#localApiDomain").val() + "Redemptions/GetRedemption/" + RedemptionId;
            //var url = "http://localhost:52839/api/Redemptions/GetRedemption/" + RedemptionId;

            var source =
            {
                datafields: [
                    { name: 'RedemptionId' },
                    { name: 'CertificateId' },
                    { name: 'RedeemDate' },
                    { name: 'DateUsed' },
                    { name: 'RedemptionTypeName' },
                    { name: 'IsReturned' },
                    { name: 'FirstName' },
                    { name: 'LastName' },
                    { name: 'MemberId' },
                    { name: 'EmailAddress' },
                ],
                id: 'RedemptionId',
                type: 'Get',
                datatype: "json",
                url: url,
            };

            // create jqxgrid
            $("#jqxRedemption").jqxGrid(
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
                columns: [
                       { text: 'RedemptionId', datafield: 'RedemptionId' },
                       { text: 'CertificateId', datafield: 'CertificateId' },
                       { text: 'RedeemDate', datafield: 'RedeemDate', cellsrenderer: DateTimeRender },
                       { text: 'DateUsed', datafield: 'DateUsed', cellsrenderer: DateRender },
                       { text: 'RedemptionTypeName', datafield: 'RedemptionTypeName' },
                       { text: 'IsReturned', datafield: 'IsReturned' },
                       { text: 'FirstName', datafield: 'FirstName' },
                       { text: 'LastName', datafield: 'LastName' },
                       { text: 'MemberId', datafield: 'MemberId' },
                       { text: 'EmailAddress', datafield: 'EmailAddress' },
                ]
            });
        }

        function showRedemption(thisRedemptionId, toAddress, thisMemberId) {

            var url = $("#apiDomain").val() + "members/" + thisMemberId + "/redemptions/" + thisRedemptionId

            $.ajax({
                type: 'GET',
                url: url,
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": $("#userGuid").val(),
                    "ApplicationKey": $("#AK").val()
                },
                success: function (thisData) {
                    $("#popupRedemption").css('display', 'block');
                    $("#popupRedemption").css('visibility', 'hidden');

                    $("#popupRedemption").jqxWindow({ position: { x: '25%', y: '7%' } });
                    $('#popupRedemption').jqxWindow({ resizable: false });
                    $('#popupRedemption').jqxWindow({ draggable: true });
                    $('#popupRedemption').jqxWindow({ isModal: true });
                    $("#popupRedemption").css("visibility", "visible");
                    $('#popupRedemption').jqxWindow({ height: '675px', width: '35%' });
                    $('#popupRedemption').jqxWindow({ minHeight: '270px', minWidth: '10%' });
                    $('#popupRedemption').jqxWindow({ maxHeight: '700px', maxWidth: '50%' });
                    $('#popupRedemption').jqxWindow({ showCloseButton: true });
                    $('#popupRedemption').jqxWindow({ animationType: 'combined' });
                    $('#popupRedemption').jqxWindow({ showAnimationDuration: 300 });
                    $('#popupRedemption').jqxWindow({ closeAnimationDuration: 500 });
                    $("#popupRedemption").jqxWindow('open');

                    var thisCertificateID = thisData.result.data.CertificateID;
                    var thisRedemptionType = thisData.result.data.RedemptionType.RedemptionType;
                    thisRedemptionType = thisRedemptionType.replace(" ", "%20");
                    var thisMemberName = thisData.result.data.Member.FirstName + '%20' + thisData.result.data.Member.LastName;
                    var thisFPNumber = thisData.result.data.Member.PrimaryFPNumber;
                    var thisQRCode = thisData.result.data.QrCodeString;
                    var toAddress = $("#EmailAddress").val();

                    document.getElementById('redemptionIframe').src = './RedemptionDisplay.aspx?thisCertificateID=' + thisCertificateID + '&thisRedemptionType=' + thisRedemptionType + '&thisMemberName=' + thisMemberName + '&thisFPNumber=' + thisFPNumber + '&thisQRCode=' + thisQRCode + '&EmailAddress=' + toAddress;
                },
                error: function (request, status, error) {
                    alert(error + " - " + request.responseJSON.message);
                }
            });
        }
      

    </script>

    <div id="RedemptionSearch" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-9">
                            <div class="row search-size">
                                <div class="col-sm-12">
                                    <input type="text" id="RedeptionId" placeholder="Certificate #" />
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
                <div id="jqxRedemption"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->

    <div id="popupRedemption" style="display: none;">
        <div>Redemption Details</div>
        <div style="margin-left:20px;margin-top:10px;overflow:hidden;">
            <iframe id="redemptionIframe" style="border:none;width:450px;height:700px;" ></iframe>
        </div>
    </div>
</asp:Content>
