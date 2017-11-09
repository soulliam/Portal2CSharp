<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="ReservationMaintenance.aspx.cs" Inherits="ReservationMaintenance" %>

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
    <script type="text/javascript" src="jqwidgets/jqxtabs.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>

    <style>
        .displayBlock{
            display: none;
        }
    </style>

    <script type="text/javascript">

        var thisNewCity = false; //determines whether a new City is being made so the feature grid doesn't get set 
        var group = '<%= Session["groupList"] %>';

        // ============= Initialize Page ==================== Begin
        $(document).ready(function () {

            $("#feeIsDefault").change(function () {
                if (this.checked) {
                    $("#ExpiresDatetime").hide();
                    $("#ExpiresDatetimeLabel").hide();
                } else {
                    $("#ExpiresDatetime").show();
                    $("#ExpiresDatetimeLabel").show();
                }
            });
            
            $('#jqxTabs').jqxTabs({ width: '100%', height: 600, position: 'top' });

            loadReservationRestrictions();
            loadrestrictionLocationCombo();

            var locationString = $("#userLocation").val();
            var locationResult = locationString.split(",");

            var thisLocationString = "";
            for (i = 0; i < locationResult.length; i++) {
                if (i == locationResult.length - 1) {
                    thisLocationString += locationResult[i];
                }
                else {
                    thisLocationString += locationResult[i] + ",";
                }
            }

            loadfeeLocationCombo(thisLocationString);
            loadStatus();

            $("#EffectiveDatetime").jqxDateTimeInput({ width: '300px', height: '25px' });
            $('#EffectiveDatetime').jqxDateTimeInput({ formatString: "MM/dd/yyyy" });
            $('#EffectiveDatetime ').val(new Date());
            $("#ExpiresDatetime").jqxDateTimeInput({ width: '300px', height: '25px' });
            $('#ExpiresDatetime').jqxDateTimeInput({ formatString: "MM/dd/yyyy" });
            $('#ExpiresDatetime ').val(new Date());

            $("#addRestriction").jqxButton();
            $("#addFee").jqxButton();
            $("#blockReservation").jqxButton();
            $("#feeSave").jqxButton();
            $("#feeCancel").jqxButton();
            $("#popupRestrictionCancel").jqxButton();
            $("#restrictionSave").jqxButton();

            $("#popupRestrictionCancel").on("click", function (event) {
                $("#popupRestriction").jqxWindow('close');
            });

            $("#feeCancel").on("click", function (event) {

                //$("#ReservationFeeId").val("");
                //$('#EffectiveDatetime ').val(new Date());
                //$('#ExpiresDatetime ').val(new Date());
                //$("#feeIsDefault").prop("checked", false);
                //$("#FeeDollars").val("");
                //$("#FeePoints").val("");
                //$("#CancellationGracePeriodHours").val("");
                //$("#CancellationFeeDollars").val("");
                //$("#NoShowFeeDollars").val("");
                //$("#MaxReservationCount").val("");

                $("#feeSave").css('visibility', 'visible');

                $("#popupFee").jqxWindow('close');
            });

            $('#popupFee').on('close', function (event) {
                //$("#ReservationFeeId").val("");
                //$('#EffectiveDatetime ').val("1/1/1900");
                //$('#ExpiresDatetime ').val("1/1/1900");
                //$("#feeIsDefault").prop("checked", false);
                //$("#FeeDollars").val("");
                //$("#FeePoints").val("");
                //$("#CancellationGracePeriodHours").val("");
                //$("#CancellationFeeDollars").val("");
                //$("#NoShowFeeDollars").val("");
                //$("#MaxReservationCount").val("");

                $("#feeSave").css('visibility', 'visible');
            });

            $("#addRestriction").on("click", function (event) {
                $("#popupRestriction").css('display', 'block');
                $("#popupRestriction").css('visibility', 'hidden');

                var offset = $("#jqxMemberInfoTabs").offset();
                $("#popupRestriction").jqxWindow({ position: { x: '25%', y: '30%' } });
                $('#popupRestriction').jqxWindow({ resizable: false });
                $('#popupRestriction').jqxWindow({ draggable: true });
                $('#popupRestriction').jqxWindow({ isModal: true });
                $("#popupRestriction").css("visibility", "visible");
                $('#popupRestriction').jqxWindow({ height: '235px', width: '50%' });
                $('#popupRestriction').jqxWindow({ minHeight: '235px', minWidth: '50%' });
                $('#popupRestriction').jqxWindow({ maxHeight: '500px', maxWidth: '50%' });
                $('#popupRestriction').jqxWindow({ showCloseButton: true });
                $('#popupRestriction').jqxWindow({ animationType: 'combined' });
                $('#popupRestriction').jqxWindow({ showAnimationDuration: 300 });
                $('#popupRestriction').jqxWindow({ closeAnimationDuration: 500 });
                $("#popupRestriction").jqxWindow('open');
            });

            $("#addFee, #blockReservation").on("click", function (event) {
                $("#popupFee").css('display', 'block');
                $("#popupFee").css('visibility', 'hidden');

                $("#feeSave").css('display', 'block');

                var offset = $("#jqxMemberInfoTabs").offset();
                $("#popupFee").jqxWindow({ position: { x: '25%', y: '10%' } });
                $('#popupFee').jqxWindow({ resizable: false });
                $('#popupFee').jqxWindow({ draggable: true });
                $('#popupFee').jqxWindow({ isModal: true });
                $("#popupFee").css("visibility", "visible");
                $('#popupFee').jqxWindow({ height: '500px', width: '50%' });
                $('#popupFee').jqxWindow({ minHeight: '400px', minWidth: '50%' });
                $('#popupFee').jqxWindow({ maxHeight: '500px', maxWidth: '50%' });
                $('#popupFee').jqxWindow({ showCloseButton: true });
                $('#popupFee').jqxWindow({ animationType: 'combined' });
                $('#popupFee').jqxWindow({ showAnimationDuration: 300 });
                $('#popupFee').jqxWindow({ closeAnimationDuration: 500 });
                $("#popupFee").jqxWindow('open');
            });

            // saving new or changed Restriction
            $("#restrictionSave").on("click", function (event) {
                // If restrictionID is nothing then we are adding a new Airport and we need a post
                if ($("#restrictionId").val() == "") {
                    var newLocationId = $("#restrictionLocationCombo").jqxComboBox('getSelectedItem').value;
                    var newIsClosed = $("#IsClosed").is(':checked');
                    var newMaxStatus = $("#statusCombo").jqxComboBox('getSelectedItem').value;

                    $.ajax({
                        headers: {
                            "Accept": "application/json",
                            "Content-Type": "application/json",
                            "AccessToken": $("#userGuid").val(),
                            "ApplicationKey": $("#AK").val()
                        },
                        type: "POST",
                        url: $("#apiDomain").val() + "restriction",
                        data: JSON.stringify({
                            "LocationId": newLocationId,
                            "IsClosed": newIsClosed,
                            "MaximumPreferredStatusRank": newMaxStatus
                        }),
                        dataType: "json",
                        success: function (response) {
                            alert("Saved!");
                        },
                        error: function (request, status, error) {
                            alert(error + " - " + request.responseJSON.message);
                        },
                        complete: function () {
                            loadReservationRestrictions();
                        }
                    })

                    $("#popupRestriction").jqxWindow('hide');

                } else {
                    var newRescrtrictionId = $("#restrictionId").val();
                    var newLocationId = $("#restrictionLocationCombo").jqxComboBox('getSelectedItem').value;
                    var newIsClosed = $("#IsClosed").is(':checked');
                    var newMaxStatus = $("#statusCombo").jqxComboBox('getSelectedItem').value;

                    var putUrl = $("#apiDomain").val() + "restriction/" + newRescrtrictionId

                    $.ajax({
                        headers: {
                            "Accept": "application/json",
                            "Content-Type": "application/json",
                            "AccessToken": $("#userGuid").val(),
                            "ApplicationKey": $("#AK").val()
                        },
                        type: "PUT",
                        url: putUrl,
                        data: JSON.stringify({
                            "LocationId": newLocationId,
                            "IsClosed": newIsClosed,
                            "MaximumPreferredStatusRank": newMaxStatus
                        }),
                        dataType: "json",
                        success: function (response) {
                            alert("Saved!");
                        },
                        error: function (request, status, error) {
                            alert(error + " - " + request.responseJSON.message);
                        },
                        complete: function () {
                            loadReservationRestrictions();
                        }
                    })
                    $("#popupRestriction").jqxWindow('hide');
                }

                
            });

            //////// saving new or changed Restriction
            //////$("#feeSave").on("click", function (event) {
            //////    var newLocationId = $("#feeLocationCombo").jqxComboBox('getSelectedItem').value;
            //////    var newEffectiveDatetime = $("#EffectiveDatetime").val();
            //////    var newExpiresDatetime = $("#ExpiresDatetime").val();
            //////    var newIsDefault = $("#feeIsDefault").is(':checked');
            //////    var newFeeDollars = $("#FeeDollars").val();
            //////    var newFeePoints = $("#FeePoints").val();
            //////    var newCancellationGracePeriodHours = $("#CancellationGracePeriodHours").val();
            //////    var newCancellationFeeDollars = $("#CancellationFeeDollars").val();
            //////    var newNoShowFeeDollars = $("#NoShowFeeDollars").val();
            //////    var newMaxReservationCount = $("#MaxReservationCount").val();

            //////    var test = JSON.stringify({
            //////        "LocationId": newLocationId,
            //////        "EffectiveDatetime": newEffectiveDatetime,
            //////        "ExpiresDatetime": newExpiresDatetime,
            //////        "IsDefault": newIsDefault,
            //////        "FeeDollars": newFeeDollars,
            //////        "FeePoints": newFeePoints,
            //////        "CancellationGracePeriodHours": newCancellationGracePeriodHours,
            //////        "CancellationFeeDollars": newCancellationFeeDollars,
            //////        "NoShowFeeDollars": newNoShowFeeDollars,
            //////        "MaxReservationCount": newMaxReservationCount,
            //////    });

            //////    $.ajax({
            //////        headers: {
            //////            "Accept": "application/json",
            //////            "Content-Type": "application/json",
            //////            "AccessToken": $("#userGuid").val(),
            //////            "ApplicationKey": $("#AK").val()
            //////        },
            //////        type: "POST",
            //////        url: $("#apiDomain").val() + "reservation-fees",
            //////        data: JSON.stringify({
            //////            "LocationId": newLocationId,
            //////            "EffectiveDatetime": newEffectiveDatetime,
            //////            "ExpiresDatetime": newExpiresDatetime,
            //////            "IsDefault": newIsDefault,
            //////            "FeeDollars": newFeeDollars,
            //////            "FeePoints": newFeePoints,
            //////            "CancellationGracePeriodHours": newCancellationGracePeriodHours,
            //////            "CancellationFeeDollars": newCancellationFeeDollars,
            //////            "NoShowFeeDollars": newNoShowFeeDollars,
            //////            "MaxReservationCount": newMaxReservationCount,
            //////        }),
            //////        dataType: "json",
            //////        success: function (response) {
            //////            alert("Saved!");
            //////        },
            //////        error: function (request, status, error) {
            //////            alert(error + " - " + request.responseJSON.message);
            //////        },
            //////        complete: function () {
            //////            loadReservationFees(newLocationId);
            //////        }
            //////    })

            //////    $("#popupRestriction").jqxWindow('hide');
            //////});

            // saving new or changed Restriction
            $("#feeSave").on("click", function (event) {
                

                var newLocationId = $("#feeLocationCombo").jqxComboBox('getSelectedItem').value;
                var newEffectiveDatetime = $("#EffectiveDatetime").val();
                var newExpiresDatetime = $("#ExpiresDatetime").val();
                var newMaxReservationCount = $("#MaxReservationCount").val();

                var thisUrl = $("#apiDomain").val() + "reservation-fees/IsValidMaxReservationCount?locationId=" + newLocationId + "&MaxReservationCount=" + newMaxReservationCount + "&startDatetime=" + newEffectiveDatetime + "&endDatetime=" + newExpiresDatetime;

                $.ajax({
                    headers: {
                        "Content-Type": "application/json",
                        "AccessToken": $("#userGuid").val(),
                        "ApplicationKey": $("#AK").val()
                    },
                    type: "GET",
                    url: thisUrl,
                    dataType: "json",
                    success: function (request) {
                        $("#popupFee").jqxWindow('hide');
                        if (request.message = "Success") {
                            SaveFee(false);
                        }
                    },
                    error: function (request, status, error) {
                        $("#popupFee").jqxWindow('hide');
                        if (request.responseJSON.message = "Records Found") {
                            swal({
                                title: 'Are you sure?',
                                text: "This will make one of the dates in your range negative?",
                                type: 'warning',
                                showCancelButton: true,
                                confirmButtonColor: '#3085d6',
                                cancelButtonColor: '#d33',
                                confirmButtonText: 'Yes, set the limit!'
                            }).then(function () {
                                SaveFee(true);
                            });
                        } else {
                            alert(request.responseJSON.message);
                        }
                    }
                })

               
            });


            function SaveFee(negative) {
                var newIsDefault = $("#feeIsDefault").is(':checked');
                var newLocationId = $("#feeLocationCombo").jqxComboBox('getSelectedItem').value;
                var newEffectiveDatetime = $("#EffectiveDatetime").val();

                if (newIsDefault == true) {
                    var newExpiresDatetime = "";
                } else {
                    var newExpiresDatetime = $("#ExpiresDatetime").val();
                }
                
                var newFeeDollars = $("#FeeDollars").val();
                var newFeePoints = $("#FeePoints").val();
                var newCancellationGracePeriodHours = $("#CancellationGracePeriodHours").val();
                var newCancellationFeeDollars = $("#CancellationFeeDollars").val();
                var newNoShowFeeDollars = $("#NoShowFeeDollars").val();
                var newMaxReservationCount = $("#MaxReservationCount").val();

                var test = JSON.stringify({
                    "LocationId": newLocationId,
                    "EffectiveDatetime": newEffectiveDatetime,
                    "ExpiresDatetime": newExpiresDatetime,
                    "IsDefault": newIsDefault,
                    "FeeDollars": newFeeDollars,
                    "FeePoints": newFeePoints,
                    "CancellationGracePeriodHours": newCancellationGracePeriodHours,
                    "CancellationFeeDollars": newCancellationFeeDollars,
                    "NoShowFeeDollars": newNoShowFeeDollars,
                    "MaxReservationCount": newMaxReservationCount,
                });

                var thisUrl = "";

                if (negative == false) {
                    thisUrl = $("#apiDomain").val() + "reservation-fees";
                } else {
                    thisUrl = $("#apiDomain").val() + "reservation-fees?UpdateReservationMaxCountToNegative=true";
                }

                $.ajax({
                    headers: {
                        "Accept": "application/json",
                        "Content-Type": "application/json",
                        "AccessToken": $("#userGuid").val(),
                        "ApplicationKey": $("#AK").val()
                    },
                    type: "POST",
                    url: thisUrl,
                    data: JSON.stringify({
                        "LocationId": newLocationId,
                        "EffectiveDatetime": newEffectiveDatetime,
                        "ExpiresDatetime": newExpiresDatetime,
                        "IsDefault": newIsDefault,
                        "FeeDollars": newFeeDollars,
                        "FeePoints": newFeePoints,
                        "CancellationGracePeriodHours": newCancellationGracePeriodHours,
                        "CancellationFeeDollars": newCancellationFeeDollars,
                        "NoShowFeeDollars": newNoShowFeeDollars,
                        "MaxReservationCount": newMaxReservationCount,
                    }),
                    dataType: "json",
                    success: function (response) {
                        swal("Saved!");
                    },
                    error: function (request, status, error) {
                        alert(error + " - " + request.responseJSON.message);
                    },
                    complete: function () {
                        loadReservationFees(newLocationId);
                    }
                })

                $("#popupRestriction").jqxWindow('hide');
            };

            //Delete restriction button click event
            $("#restrictionDelete").on("click", function (event) {
                var delRescrtrictionId = $("#restrictionId").val();

                $.ajax({
                    headers: {
                        "Accept": "application/json",
                        "Content-Type": "application/json",
                        "AccessToken": $("#userGuid").val(),
                        "ApplicationKey": $("#AK").val()
                    },
                    type: "delete",
                    url: $("#apiDomain").val() + "restriction/" + delRescrtrictionId,
                    dataType: "json",
                    success: function (response) {
                        alert("Deleted!");
                    },
                    error: function (request, status, error) {
                        alert(error + " - " + request.responseJSON.message);
                    },
                    complete: function () {
                        loadReservationRestrictions();
                        $("#popupRestriction").jqxWindow('hide');
                    }
                })
            })

            $('#popupRestriction').on('close', function (event) {
                $("#restrictionLocationCombo").jqxComboBox('selectIndex', 0);
                $("#statusCombo").jqxComboBox('selectIndex', 0);
                $("#IsClosed").prop("checked", false);
                $("#restrictionId").val("");
            });

            Security();

            LocalSecurity();

        })//end document ready ***************************

        //Loads city grid
        function loadReservationRestrictions() {

            var statusCellsrenderer = function (row, columnfield, value, defaulthtml, columnproperties) {
                switch (value) {
                    case 1:
                        return '<div style="margin-top: 10px;margin-left: 5px">VIP</div>';
                        break;
                    case 2:
                        return '<div style="margin-top: 10px;margin-left: 5px">Top 10</div>';
                        break;
                    default:
                        return 'Error';
                }
            }

            var parent = $("#reservationRestrictionGrid").parent();
            $("#reservationRestrictionGrid").jqxGrid('destroy');
            $("<div id='reservationRestrictionGrid'></div>").appendTo(parent);

            var url = $("#apiDomain").val() + "restriction";

            var source =
            {
                datafields: [
                    { name: 'RestrictionId' },
                    { name: 'LocationId' },
                    { name: 'IsClosed' },
                    { name: 'MaximumPreferredStatusRank' }
                ],
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                id: 'RestrictionId',
                type: 'Get',
                datatype: "json",
                url: url,
                root: "data"
            };

            // creage jqxgrid
            $("#reservationRestrictionGrid").jqxGrid(
            {
                width: '100%',
                height: 500,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                columns: [
                       {
                           //creates edit button for each row in city grid
                           text: '', pinned: true, datafield: 'Edit', width: 50, columntype: 'button', cellsrenderer: function () {
                               return "Edit";
                           }, buttonclick: function (row) {
                               // open the popup window when the user clicks a button.
                               editrow = row;
                               var offset = $("#reservationRestrictionGrid").offset();
                               $("#popupRestriction").jqxWindow({ position: { x: '25%', y: '30%' } });
                               $('#popupRestriction').jqxWindow({ resizable: false });
                               $('#popupRestriction').jqxWindow({ draggable: true });
                               $('#popupRestriction').jqxWindow({ isModal: true });
                               $("#popupRestriction").css("visibility", "visible");
                               $('#popupRestriction').jqxWindow({ height: '235px', width: '50%' });
                               $('#popupRestriction').jqxWindow({ minHeight: '235px', minWidth: '50%' });
                               $('#popupRestriction').jqxWindow({ maxHeight: '500px', maxWidth: '50%' });
                               $('#popupRestriction').jqxWindow({ showCloseButton: true });
                               $('#popupRestriction').jqxWindow({ animationType: 'combined' });
                               $('#popupRestriction').jqxWindow({ showAnimationDuration: 300 });
                               $('#popupRestriction').jqxWindow({ closeAnimationDuration: 500 });
                               $("#popupRestriction").jqxWindow('open');


                               // get the clicked row's data and initialize the input fields.
                               var dataRecord = $("#reservationRestrictionGrid").jqxGrid('getrowdata', editrow);
                               $("#restrictionId").val(dataRecord.RestrictionId);
                               $("#restrictionLocationCombo").jqxComboBox('selectItem', dataRecord.LocationId);
                               $("#IsClosed").prop("checked", dataRecord.IsClosed);
                               $("#statusCombo").jqxComboBox('selectItem', dataRecord.MaximumPreferredStatusRank);

                           }
                       },
                      { text: 'RestrictionId', datafield: 'RestrictionId', hidden: true },
                      { text: 'Location', datafield: 'LocationId', cellsrenderer: locatioinCellsrenderer, width: '30%' },
                      { text: 'Closed', datafield: 'IsClosed', width: '30%' },
                      { text: 'Maximum Status', datafield: 'MaximumPreferredStatusRank', cellsrenderer: statusCellsrenderer, width: '30%' }
                ]
            });
        }

        //Loads city grid
        function loadReservationFees(thisLocationId) {

            var parent = $("#reservationFeesGrid").parent();
            $("#reservationFeesGrid").jqxGrid('destroy');
            $("<div id='reservationFeesGrid'></div>").appendTo(parent);

            var url = $("#apiDomain").val() + "reservation-fees/admin?locationId=" + thisLocationId;

            var source = 
            {
                datafields: [
                    { name: 'ReservationFeeId' },
                    { name: 'LocationId' },
                    { name: 'EffectiveDatetime' },
                    { name: 'ExpiresDatetime' },
                    { name: 'IsDefault' },
                    { name: 'FeeDollars' },
                    { name: 'FeePoints' },
                    { name: 'CancellationGracePeriodHours' },
                    { name: 'CancellationFeeDollars' },
                    { name: 'NoShowFeeDollars' },
                    { name: 'MaxReservationCount' }
                ],
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                id: 'RestrictionId',
                type: 'Get',
                datatype: "json",
                url: url,
                root: "data"
            };

            // creage jqxgrid
            $("#reservationFeesGrid").jqxGrid(
            {
                width: '100%',
                height: 500,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                columns: [
                      {
                          //creates edit button for each row in city grid
                          text: '', pinned: true, datafield: 'Edit', width: 50, columntype: 'button', cellsrenderer: function () {
                              return "View";
                          }, buttonclick: function (row) {
                              // open the popup window when the user clicks a button.
                              editrow = row;
                              var offset = $("#reservationFeesGrid").offset();
                              $("#popupFee").jqxWindow({ position: { x: '25%', y: '10%' } });
                              $('#popupFee').jqxWindow({ resizable: false });
                              $('#popupFee').jqxWindow({ draggable: true });
                              $('#popupFee').jqxWindow({ isModal: true });
                              $("#popupFee").css("visibility", "visible");
                              $('#popupFee').jqxWindow({ height: '500px', width: '50%' });
                              $('#popupFee').jqxWindow({ minHeight: '400px', minWidth: '50%' });
                              $('#popupFee').jqxWindow({ maxHeight: '500px', maxWidth: '50%' });
                              $('#popupFee').jqxWindow({ showCloseButton: true });
                              $('#popupFee').jqxWindow({ animationType: 'combined' });
                              $('#popupFee').jqxWindow({ showAnimationDuration: 300 });
                              $('#popupFee').jqxWindow({ closeAnimationDuration: 500 });

                              $("#feeSave").css('display', 'none');

                              // get the clicked row's data and initialize the input fields.
                              var dataRecord = $("#reservationFeesGrid").jqxGrid('getrowdata', editrow);
                              $("#ReservationFeeId").val(dataRecord.ReservationFeeId);
                              var effectiveDate = new Date(dataRecord.EffectiveDatetime);
                              $('#EffectiveDatetime ').val(DateFormat(effectiveDate));
                              
                              if (dataRecord.ExpiresDatetime == null) {
                                  $('#ExpiresDatetime ').val("1/1/1900");
                              } else {
                                  var expiresDate = new Date(dataRecord.ExpiresDatetime);
                                  $('#ExpiresDatetime ').val(DateFormat(expiresDate));
                              }

                              $("#feeIsDefault").prop("checked", dataRecord.IsDefault);
                              $("#FeeDollars").val(dataRecord.FeeDollars);
                              $("#FeePoints").val(dataRecord.FeePoints);
                              $("#CancellationGracePeriodHours").val(dataRecord.CancellationGracePeriodHours);
                              $("#CancellationFeeDollars").val(dataRecord.CancellationFeeDollars);
                              $("#NoShowFeeDollars").val(dataRecord.NoShowFeeDollars);
                              $("#MaxReservationCount").val(dataRecord.MaxReservationCount);

                              $("#popupFee").jqxWindow('open');
                          }
                      },
                      { text: 'ReservationFeeId', datafield: 'ReservationFeeId', hidden: true },
                      { text: 'LocationId', datafield: 'LocationId', hidden: true },
                      { text: 'Effective', datafield: 'EffectiveDatetime', width: '15%', cellsrenderer: DateRender },
                      { text: 'Expires', datafield: 'ExpiresDatetime', width: '15%', cellsrenderer: DateRender },
                      { text: 'Default', datafield: 'IsDefault', width: '5%' },
                      { text: 'Fee Dollars', datafield: 'FeeDollars', width: '10%' },
                      { text: 'Points', datafield: 'FeePoints', width: '10%' },
                      { text: 'Grace Period', datafield: 'CancellationGracePeriodHours', width: '10%' },
                      { text: 'Cancel Fee', datafield: 'CancellationFeeDollars', width: '10%' },
                      { text: 'No Show Fee', datafield: 'NoShowFeeDollars', width: '10%' },
                      { text: 'Max Count', datafield: 'MaxReservationCount', width: '10%'}
                ]
            });



        }

        function loadrestrictionLocationCombo() {
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
            $("#restrictionLocationCombo").jqxComboBox(
            {
                theme: 'shinyblack',
                width: '100%',
                height: 24,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });
            $("#restrictionLocationCombo").on('bindingComplete', function (event) {
                $("#restrictionLocationCombo").jqxComboBox('insertAt', 'Location', 0);
            });
        }

        function loadfeeLocationCombo(thisLocationString) {

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
            $("#feeLocationCombo").jqxComboBox(
            {
                width: '100%',
                height: 25,
                itemHeight: 50,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });

            $("#feeLocationCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {
                        loadReservationFees(item.value);
                    }
                }
            });
        }

        function loadStatus() {
            //set companies combobox
            var statusSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'PreferredStatusId' },
                    { name: 'PreferredStatusName' }
                ],
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                url: $("#apiDomain").val() + "status-levels",
            };
            var statusDataAdapter = new $.jqx.dataAdapter(statusSource);
            $("#statusCombo").jqxComboBox(
            {
                width: 100,
                height: 24,
                source: statusDataAdapter,
                selectedIndex: 0,
                displayMember: "PreferredStatusName",
                valueMember: "PreferredStatusId"
            });

            $("#statusCombo").on('bindingComplete', function (event) {
                $("#statusCombo").jqxComboBox('insertAt', 'Status', 0);
            });
        }

        function LocalSecurity() {
            $('.reservationSecurity').each(function () {
                $('.reservationSecurity').addClass('disabled');
            });

            $('.managerSecurity').each(function () {
                $('.managerSecurity').addClass('disabled');
            }); 

            $('.blockReservationHidden').each(function () {
                $('.blockReservationHidden').addClass('displayBlock');
            });

            if (group.indexOf("Portal_RFR") > -1 || group.indexOf("Portal_Manager") > -1) {
                $('.managerSecurity').removeClass('disabled');
            }

            if (group.indexOf("Portal_Auditadmin") > -1 || group.indexOf("Portal_Superadmin") > -1) {
                $('.reservationSecurity').removeClass('disabled');
                $('.managerSecurity').removeClass('disabled');
                $('.blockReservationHidden').removeClass('displayBlock');
            }
        }

    </script>
    
    <div id="ReservationMaintenance" class="container-fluid container-970 wrap-search-options">
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
    
    <div style="display:none;">
        <input id="LocationId" type="text" value="0"  />
    </div>

    <div class="container-fluid container-970">
        <div class="row ">
            <div class="col-sm-12">
                <div id='jqxTabs'>
                    <ul>
                        <li style="margin-left: 30px;">Reservation Management</li>
                        <li>Reservation Status</li>
                    </ul>
                    <div id="tabReservationFees" class="tab-body">
                        <div class="row">
                            <div class="col-sm-9 col-md-10">
                                <div id="reservationFeesGrid"></div>
                            </div>
                            <div class="col-sm-3 col-md-2">
                                <div id="feeLocationCombo"></div>
                                <input type="button" id="addFee" value="Admin" class="reservationSecurity" />
                            </div>
                            <div class="col-sm-3 col-md-2">
                                <input type="button" id="blockReservation" value="Block Reservations" class="managerSecurity" />
                            </div>
                        </div>
                    </div>
                    <div id="tabRestrictions" class="tab-body">
                        <div class="row">
                            <div class="col-sm-9 col-md-10">
                                <div id="reservationRestrictionGrid"></div>
                            </div>
                            <div class="col-sm-3 col-md-2">
                                <input type="button" id="addRestriction" value="Admin" class="reservationSecurity" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div><!-- /.container-fluid -->

    <%-- html for popup Restriction Edit box --%>
    <div id="popupRestriction" style="display:none">
        <div>Reservation Restriction</div>
        <div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="restrictionLocation" class="col-sm-3 col-md-4 control-label">Location:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" id="restrictionId" style="display:none" />
                                    <div id="restrictionLocationCombo"></div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="isClosed" class="col-sm-3 col-md-4 control-label">Closed:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" class="form-control" id="IsClosed" >
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="allowedStatus" class="col-sm-3 col-md-4 control-label">Status Allowed:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div class="checkbox">
                                        <div id="statusCombo"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="top-divider">
                            <div class="col-sm-4 col-md-4">
                                <input type="button" id="restrictionSave" value="Save" class="editor" />
                            </div>
                            <div class="col-sm-4 col-md-4">
                                
                            </div>
                            <div class="col-sm-4 col-md-4">
                                <input type="button" id="popupRestrictionCancel" value="Cancel" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- html for popup edit box END --%>

    <%-- html for popup Restriction Edit box --%>
    <div id="popupFee" style="display:none">
        <div>Reservation Fee</div>
        <div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="EffectiveDatetime" class="col-sm-3 col-md-4 control-label">Effective:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" id="reservationFeeId" style="display:none" />
                                    <div id="EffectiveDatetime"></div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label id="ExpiresDatetimeLabel" for="ExpiresDatetime" class="col-sm-3 col-md-4 control-label">Expires:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div id="ExpiresDatetime"></div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="IsDefualt" class="col-sm-3 col-md-4 control-label blockReservationHidden">Default:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" class="form-control  blockReservationHidden" id="feeIsDefault" />
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="FeeDollars" class="col-sm-3 col-md-4 control-label blockReservationHidden" >Fee $:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" id="FeeDollars" class="blockReservationHidden" value="4.95" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="FeePoints" class="col-sm-3 col-md-4 control-label blockReservationHidden">Fee Points:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" id="FeePoints" class="blockReservationHidden" value="4" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="CancellationGracePeriodHours" class="col-sm-3 col-md-4 control-label blockReservationHidden">Grace Period:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" id="CancellationGracePeriodHours" class="blockReservationHidden" value="1" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="CancellationFeeDollars" class="col-sm-3 col-md-4 control-label blockReservationHidden">Cancellation Fee:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" id="CancellationFeeDollars" class="blockReservationHidden" value="0.00" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="NoShowFeeDollars" class="col-sm-3 col-md-4 control-label blockReservationHidden">No Show Fee:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" id="NoShowFeeDollars" class="blockReservationHidden" value="0.00" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="MaxReservationCount" class="col-sm-3 col-md-4 control-label">Max Reservations:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" id="MaxReservationCount" value="1" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-12">
                        <div class="top-divider">
                            <div class="col-sm-2 col-md-4">
                                <input type="button" id="feeSave" value="Save" class="editor" />
                            </div>
                            <div class="col-sm-4 col-md-4">
                                
                            </div>
                            <div class="col-sm-4 col-md-4">
                                <input type="button" id="feeCancel" value="Cancel" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- html for popup edit box END --%>
</asp:Content>


