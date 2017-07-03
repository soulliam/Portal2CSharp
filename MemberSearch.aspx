<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="MemberSearch.aspx.cs" Inherits="MemberSearch" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
   

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
    <script type="text/javascript" src="jqwidgets/jqxinput.js"></script>

    <script type="text/javascript">
        var PageMemberID = 0;
        var firstMemberID = 0;
        var memberSet = false;
        var AccountId = 0;
        var group = '<%= Session["groupList"] %>';
        var glbCompanyId = 0;
        var glbHomeLocationId = 0;
        var searchCompaniesLoaded = false;
        var memberCompaniesLoaded = false;


        $(document).ready(function () {

            ////Drag function
            //$(function () {
            //    $('body').on('mousedown', '#popupCombineMembers', function () {
            //        $(this).addClass('draggable').parents().on('mousemove', function (e) {
            //            $('.draggable').offset({
            //                top: e.pageY - $('.draggable').outerHeight() / 2,
            //                left: e.pageX - $('.draggable').outerWidth() / 2
            //            }).on('mouseup', function () {
            //                $(this).removeClass('draggable');
            //            });
            //            e.preventDefault();
            //        });
            //    }).on('mouseup', function () {
            //        $('.draggable').removeClass('draggable');
            //    });
            //});

            //#region TabSetup            

            // Create jqxMemberTabs.*****************************************************************
            $('#jqxMemberTabs').jqxTabs({ width: '100%', height: 30, position: 'top' });
            $('#jqxMemberTabs').css('margin-bottom', '10px');
            $('#settings div').css('margin-top', '10px');
            $('#animation').on('change', function (event) {
                var checked = event.args.checked;
                $('#jqxMemberTabs').jqxTabs({ selectionTracker: checked });
            });

            $('#contentAnimation').on('change', function (event) {
                var checked = event.args.checked;
                if (checked) {
                    $('#jqxMemberTabs').jqxTabs({ animationType: 'fade' });
                }
                else {
                    $('#jqxMemberTabs').jqxTabs({ animationType: 'none' });
                }
            });

            // Create jqxMemberInfoTabs.***************************************************************
            $('#jqxMemberInfoTabs').jqxTabs({ width: '100%', position: 'top' });
            $('#settings div').css('margin-top', '10px');

            $('#jqxMemberInfoTabs').on('selected', function (event) {

                var title = $('#jqxMemberInfoTabs').jqxTabs('getTitleAt', event.args.item);

                if (title == "Modified") {
                    loadModified($("#MemberId").val());
                }
            });

            $('#animation').on('change', function (event) {
                var checked = event.args.checked;
                $('#jqxMemberInfoTabs').jqxTabs({ selectionTracker: checked });
            });


            $('#contentAnimation').on('change', function (event) {
                var checked = event.args.checked;
                if (checked) {
                    $('#jqxMemberInfoTabs').jqxTabs({ animationType: 'fade' });
                }
                else {
                    $('#jqxMemberInfoTabs').jqxTabs({ animationType: 'none' });
                }
            });

            // Create jqxAccountTabs.***************************************************************
            $('#jqxAccountTabs').jqxTabs({ width: '100%', height: 570, position: 'top' });
            $('#settings div').css('margin-top', '10px');
            $('#animation').on('change', function (event) {
                var checked = event.args.checked;
                $('#jqxMemberInfoTabs').jqxTabs({ selectionTracker: checked });
            });

            $('#jqxAccountTabs').on('change', function (event) {
                var checked = event.args.checked;
                if (checked) {
                    $('#jqxMemberInfoTabs').jqxTabs({ animationType: 'fade' });
                }
                else {
                    $('#jqxMemberInfoTabs').jqxTabs({ animationType: 'none' });
                }
            });

            // Create jqxManualEditTabs.*****************************************************************
            $('#jqxManualEditTabs').jqxTabs({ width: '100%', height: 500, position: 'top' });
            $('#settings div').css('margin-top', '10px');
            $('#animation').on('change', function (event) {
                var checked = event.args.checked;
                $('#jqxManualEditTabs').jqxTabs({ selectionTracker: checked });
            });

            $('#contentAnimation').on('change', function (event) {
                var checked = event.args.checked;
                if (checked) {
                    $('#jqxManualEditTabs').jqxTabs({ animationType: 'fade' });
                }
                else {
                    $('#jqxManualEditTabs').jqxTabs({ animationType: 'none' });
                }
            });
            //#endregion

            //#region ButtonSetup

                $("#btnSearch").jqxButton();
                $("#btnClear").jqxButton();

                $("#btnMarketing").jqxButton();
                $("#btnImportStatus").jqxButton();
                $("#btnFindTransaction").jqxButton();

                $("#addNote").jqxButton({ width: 120 });

                $("#SendNewPassword").jqxButton();
                $("#SendLoginInstructions").jqxButton();
                $("#editMember").jqxButton();
                $("#updateMemberInfo").jqxButton();
                $("#DisplayQA").jqxButton();

                $("#saveNote").jqxButton();
                $("#cancelNote").jqxButton(); 

                $("#submitReceipt1").jqxButton(); 
                $("#submitReceipt2").jqxButton();

                $("#manualEditSubmit").jqxButton();
                $("#manualEditPending").jqxButton();

                $("#cancelReservation").jqxButton();
                $("#addReservation").jqxButton();

                $("#returnRedemption").jqxButton();

                $("#transferCard").jqxButton();
                $("#addCard").jqxButton();
                $("#deleteCard").jqxButton();
                $("#UnDeleteCard").jqxButton();
                $("#setCardPrimary").jqxButton();
                $("#combineMemberCards").jqxButton();
                $("#saveCombineMember").jqxButton();
                $("#cancelCombineMember").jqxButton();

                $("#addCardSubmit").jqxButton(); 
                $("#cancelCardSubmit").jqxButton();

                $("#saveReservation").jqxButton();
                $("#cancelReservationForm").jqxButton();

                $("#markUsedRedemption").jqxButton();
                $("#1DayRedemption").jqxButton();
                $("#3DayRedemption").jqxButton();
                $("#1WeekRedemption").jqxButton();

                $("#deleteEmail").jqxButton();
                $("#addPhone").jqxButton();

                $("#btnArchiveSearch").jqxButton();


            //#endregion

            //#region RadioButtonEvents

            $("#jqxRadioTypeReceipt").on('change', function (event) {
               
                var checked = event.args.checked;
                if (checked) {
                    //do something
                }
                else // else do soming
                {

                }
            });
            $("#jqxRadioTypeReceipt").on('change', function (event) {
               
                var checked = event.args.checked;
                if (checked) {
                    //do something
                }
                else // else do soming
                {

                }
            });
            $("#jqxRadioTypeNormal").on('change', function (event) {
               
                var checked = event.args.checked;
                if (checked) {
                    //do something
                }
                else // else do soming
                {

                }
            });
            $("#jqxRadioTypeLost").on('change', function (event) {
               
                var checked = event.args.checked;
                if (checked) {
                    //do something
                }
                else // else do soming
                {

                }
            });
            $("#jqxRadioTypeDamaged").on('change', function (event) {
               
                var checked = event.args.checked;
                if (checked) {
                    //do something
                }
                else // else do soming
                {

                }
            });

            //#endregion

            //#region ButtonClicks

            $("#cancelReservationForm").on("click", function (event) {
                $('#reservationFeeDiscountIdGrid').jqxGrid('clearselection');

                $("#reservationFeeDiscountIdDDB").jqxDropDownButton('setContent', "Please Select");

                $("#reservationStartDate").jqxDateTimeInput('today');
                $("#reservationEndDate").jqxDateTimeInput('today');
                $("#reservationFeeInput").val('');
                $("#reservationFeePointsInput").val('');
                $("#reservationFeeInputValue").val('');
                $("#EstimatedReservationCost").val('');
                $("#reservationTermsAndConditionsFlag").prop('checked', false);
                $("#SendNotificationsFlag").prop('checked', false);
                $("#reservationPaymentMethodId").jqxComboBox('selectItem', 0);
                $("#ReservationNote").val('');

                var parent = $("#reservationFeatures").parent();
                $("#reservationFeatures").jqxComboBox('destroy');
                $("<div id='reservationFeatures'></div>").appendTo(parent);

                var parent = $("#reservationFeeCreditCombo").parent();
                $("#reservationFeeCreditCombo").jqxComboBox('destroy');
                $("<div id='reservationFeeCreditCombo'></div>").appendTo(parent);

                $("#popupReservation").jqxWindow('hide'); 
                
            });

            $("#saveReservation").on("click", function (event) {
                addReservation();
            });

            $("#getEstCost").on("click", function (event) {
                getEstCost();
            });

            //Goto pending manualedits button
            $("#manualEditPending").on("click", function (event) {
                var homeLocation = $("#homeLocationCombo").jqxComboBox('getSelectedItem').value;
                window.location = "./PendingManualEdits.aspx?location=" + homeLocation;
            });

            //Button click archive Search
            $("#btnArchiveSearch").on("click", function (event) {
                LoadArchiveSearch();
            });

            //Delte email and set status
            $("#deleteEmail").on("click", function (event) {
                //var result = confirm("Do you want to delete this member's email?");
                //if (result != true) {
                //    return null;
                //}

                swal({
                    title: 'Are you sure?',
                    text: "Do you want to delete this member's email?",
                    type: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, delete it!'
                }).then(function () {
                    var thisMemberId = $("#MemberId").val();
                    var url = $("#localApiDomain").val() + "Members/DeleteEmail/" + thisMemberId;

                    $.ajax({
                        type: "GET",
                        url: url,
                        dataType: "json",
                        success: function (data) {
                            swal(
                              'Deleted!',
                              'Your email has been deleted.',
                              'success'
                            )
                            $("#EmailAddress").val('');
                        },
                        error: function (request, status, error) {
                            swal(error);
                        }
                    });
                    
                })
            });


            //Create Redemptions
            $("#1DayRedemption").on("click", function (event) {
                //var result = confirm("Do you want to create a redemption!");
                //if (result != true) {
                //    return null;
                //}
                swal({
                    title: 'Are you sure?',
                    text: "Do you want to create a redemption!",
                    type: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, create it!'
                }).then(function () {
                    CreateRedemption(1, 3, 1);
                    swal(
                      'Created!',
                      'Your redemption has been created.',
                      'success'
                    )
                })
            });

            $("#3DayRedemption").on("click", function (event) {
                //var result = confirm("Do you want to create a redemption!");
                //if (result != true) {
                //    return null;
                //}
                swal({
                    title: 'Are you sure?',
                    text: "Do you want to create a redemption!",
                    type: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, create it!'
                }).then(function () {
                    CreateRedemption(2, 3, 1);
                    swal(
                      'Created!',
                      'Your redemption has been created.',
                      'success'
                    )
                })
                
            });

            $("#1WeekRedemption").on("click", function (event) {
                //var result = confirm("Do you want to create a redemption!");
                //if (result != true) {
                //    return null;
                //}
                swal({
                    title: 'Are you sure?',
                    text: "Do you want to create a redemption!",
                    type: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, create it!'
                }).then(function () {
                    CreateRedemption(3, 3, 1);
                    swal(
                      'Created!',
                      'Your redemption has been created.',
                      'success'
                    )
                })
                
            });

            // open import status page in new page or tab
            $("#btnImportStatus").on("click", function (event) {
                window.open("./FileImportStatus.aspx");
            });

            //Marketing site
            $("#btnMarketing").on("click", function (event) {
                var oldPortalGuid = "";
                var userName = $("#loginLabel").html();

                userName = userName.replace("PCA\\", "");

                var url = $("#localApiDomain").val() + "OldPortalGuids/getUserId/" + userName;
                //var url = "http://localhost:52839/api/OldPortalGuids/getUserId/" + userName;

                $.ajax({
                    type: "GET",
                    url: url,
                    dataType: "json",
                    success: function (data) {
                        oldPortalGuid = data[0].UserId
                        var marketingURL = 'http://enrollnow.thefastpark.com/linklogin/' + oldPortalGuid;

                        window.open(marketingURL);
                    },
                    error: function (request, status, error) {
                        swal(error);
                    }
                });

                
            });

            //Add Reservation
            $("#addReservation").on("click", function (event) {
                var thisLocationId = $("#homeLocationCombo").jqxComboBox('getSelectedItem').value;

                $("#popupReservation").css('display', 'block');
                $("#popupReservation").css('visibility', 'hidden');

                var offset = $("#jqxMemberInfoTabs").offset();
                $("#popupReservation").jqxWindow({ position: { x: '10%', y: '5%' } });
                $('#popupReservation').jqxWindow({ resizable: false });
                $('#popupReservation').jqxWindow({ draggable: true });
                $('#popupReservation').jqxWindow({ isModal: true });
                $("#popupReservation").css("visibility", "visible");
                $('#popupReservation').jqxWindow({ height: '650px', width: '800px' });
                $('#popupReservation').jqxWindow({ minHeight: '400px', minWidth: '800px' });
                $('#popupReservation').jqxWindow({ maxHeight: '650px', maxWidth: '800px' });
                $('#popupReservation').jqxWindow({ showCloseButton: false });
                $('#popupReservation').jqxWindow({ animationType: 'combined' });
                $('#popupReservation').jqxWindow({ showAnimationDuration: 300 });
                $('#popupReservation').jqxWindow({ closeAnimationDuration: 500 });
                $("#popupReservation").jqxWindow('open');

                getReservationFeeCredit();
                $("#reservationLocationCombo").jqxComboBox('selectItem', thisLocationId);
                $("#reservationPaymentMethodId").jqxComboBox('selectItem', 3);
                $("#reservationFeeCreditCombo").jqxComboBox('selectItem', 3);
            });

            // mark redemption used button click
            $("#markUsedRedemption").on("click", function (event) {
                var getselectedrowindexes = $('#jqxRedemptionGrid').jqxGrid('getselectedrowindexes');
                if (getselectedrowindexes.length <= 0) {
                    swal("You have not selected a redemption.")
                    return null;
                }

                swal({
                    title: 'Are you sure?',
                    text: "Do you want to mark this as used?",
                    type: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, use it!'
                }).then(function () {
                    //Get the selected rows RedemptionID
                    var thisMemberId = $("#MemberId").val();
                    var getselectedrowindexes = $('#jqxRedemptionGrid').jqxGrid('getselectedrowindexes');
                    var thisUser = $("#txtLoggedinUsername").val();
                    var ProcessList = "";
                    var first = true;

                    if (getselectedrowindexes.length > 0) {

                        for (var index = 0; index < getselectedrowindexes.length; index++) {

                            var selectedRowData = $('#jqxRedemptionGrid').jqxGrid('getrowdata', getselectedrowindexes[index]);
                            if (selectedRowData.IsReturned == 1 || selectedRowData.BeenUsed == 1) {
                                swal('You have selected a redemption that has been used or returned.  Please check you list and try again.');
                                return null;
                            }

                            if (first == true) {
                                ProcessList = ProcessList + selectedRowData.RedemptionId;
                                first = false;
                            }
                            else {
                                ProcessList = ProcessList + "," + selectedRowData.RedemptionId;
                            }
                        }

                        var thisRedemptionList = ProcessList.split(",");

                    }
                    else {
                        swal("You must select a redemption to mark used.");
                        return null;
                    }

                    for (var i = 0, len = thisRedemptionList.length; i < len; i++) {

                        $.ajax({
                            type: "POST",
                            //url: "http://localhost:52839/api/Redemptions/SetBeenUsed/",
                            url: $("#localApiDomain").val() + "Redemptions/SetBeenUsed/",

                            data: {
                                "RedemptionId": thisRedemptionList[i],
                                "UpdateExternalUserData": thisUser,
                            },
                            dataType: "json",
                            success: function (Response) {
                                success = true;
                            },
                            error: function (request, status, error) {
                                swal(error);
                            },
                            complete: function () {
                                if (success == true) {
                                    swal(
                                      'Done!',
                                      'Your redemption has been used.',
                                      'success'
                                    )
                                    loadRedemptions(thisMemberId);
                                    loadMemberActivity(thisMemberId);
                                }
                            }
                        });
                    }

                    
                })

            });

            //return redemption
            $("#returnRedemption").on("click", function (event) {
                var getselectedrowindexes = $('#jqxRedemptionGrid').jqxGrid('getselectedrowindexes');
                if (getselectedrowindexes.length <= 0) {
                    swal("You have not selected a redemption.")
                    return null;
                }

                swal({
                    title: 'Are you sure?',
                    text: "Do you want to return this redemption?",
                    type: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, return it!'
                }).then(function () {

                    //Get the selected rows RedemptionID
                    var thisMemberId = $("#MemberId").val();
                    var getselectedrowindexes = $('#jqxRedemptionGrid').jqxGrid('getselectedrowindexes');
                    var ProcessList = "";
                    var first = true;


                    if (getselectedrowindexes.length > 0) {

                        for (var index = 0; index < getselectedrowindexes.length; index++) {
                            var selectedRowData = $('#jqxRedemptionGrid').jqxGrid('getrowdata', getselectedrowindexes[index]);

                            if (selectedRowData.IsReturned == 1 || selectedRowData.BeenUsed == 1) {
                                swal('You have selected a redemption that has been used or returned.  Please check you list and try again.');
                                return null;
                            }

                            if (first == true) {
                                ProcessList = ProcessList + selectedRowData.RedemptionId;
                                first = false;
                            }
                            else {
                                ProcessList = ProcessList + "," + selectedRowData.RedemptionId;
                            }
                        }

                        var thisRedemptionList = ProcessList.split(",");

                    }
                    else {
                        return null;
                    }

                    for (var i = 0, len = thisRedemptionList.length; i < len; i++) {

                        var putUrl = $("#apiDomain").val() + "members/" + thisMemberId + "/redemptions/" + thisRedemptionList[i];

                        $.ajax({
                            headers: {
                                "Accept": "application/json",
                                "Content-Type": "application/json",
                                "AccessToken": $("#userGuid").val(),
                                "ApplicationKey": $("#AK").val()
                            },
                            type: "PUT",
                            url: putUrl,
                            dataType: "json",
                            success: function (response) {
                                //Clear the redemption grid and reload
                                $('#jqxRedemptionGrid').jqxGrid('clearselection');
                                $('#jqxRedemptionGrid').jqxGrid('clear');
                                $("#topPointsBalance").html(loadPoints(AccountId, $("#topPointsBalance")));
                                $("#topPointsBalanceAccountBar").html(loadPoints(AccountId, $("#topPointsBalanceAccountBar")));
                                loadRedemptions(thisMemberId);
                                loadMemberActivity(thisMemberId);
                            },
                            error: function (request, status, error) {
                                swal(error + " - " + request.responseJSON);
                            },
                            complete: function () {
                                
                            }
                        })
                    }

                })
            });

            // Cancel Reservation
            $("#cancelReservation").on("click", function (event) {
                var getselectedrowindexes = $('#jqxReservationGrid').jqxGrid('getselectedrowindexes');
                if (getselectedrowindexes.length <= 0) {
                    swal("You have not selected a reservation.")
                    return null;
                }


                swal({
                    title: 'Are you sure?',
                    text: "Do you want to cancel this reservation?",
                    type: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, cancel it!'
                }).then(function () {
                    var ProcessList = "";
                    var first = true;
                    var getselectedrowindexes = $('#jqxReservationGrid').jqxGrid('getselectedrowindexes');

                    if (getselectedrowindexes.length > 0) {

                        for (var index = 0; index < getselectedrowindexes.length; index++) {
                            var selectedRowData = $('#jqxReservationGrid').jqxGrid('getrowdata', getselectedrowindexes[index]);
                            if (first == true) {
                                ProcessList = ProcessList + selectedRowData.ReservationId;
                                first = false;
                            }
                            else {
                                ProcessList = ProcessList + "," + selectedRowData.ReservationId;
                            }
                        }

                        var thisReservationList = ProcessList.split(",");

                    }
                    else {
                        return null;
                    }

                    for (var i = 0, len = thisReservationList.length; i < len; i++) {

                        $.ajax({
                            headers: {
                                "Accept": "application/json",
                                "Content-Type": "application/json",
                                "AccessToken": $("#userGuid").val(),
                                "ApplicationKey": $("#AK").val()
                            },
                            type: "DELETE",
                            url: $("#apiDomain").val() + "reservations/" + thisReservationList[i],
                            dataType: "json",
                            success: function () {
                            },
                            error: function (request, status, error) {
                                swal(error + " - " + request.responseJSON);
                            },
                            complete: function () {
                                swal(
                                  'Canceled!',
                                  'Your reservation has been canceled.',
                                  'success'
                                )
                                thisMemberId = $("#MemberId").val();
                                $('#jqxReservationGrid').jqxGrid('clearselection');
                                $('#jqxReservationGrid').jqxGrid('clear');
                                loadReservations(thisMemberId);
                            }
                        });
                    }
                    
                })

            });

            $("#addPhone").on("click", function (event) {
                var value = $('#phoneGrid').jqxGrid('addrow', null, {});
            });

            //Save Member Info
            $("#updateMemberInfo").on("click", function (event) {
                $('#jqxLoader').jqxLoader('open');
                var thisUserName = $("#UserName").val();
                var thisFirstName = $("#FirstName").val();
                var thisLastName = $("#LastName").val();
                var thisSuffix = "";
                var thisEmailAddress = $("#EmailAddress").val();
                var thisStreetAddress = $("#StreetAddress").val();
                var thisStreetAddress2 = $("#StreetAddress2").val();
                var thisCityName = $("#CityName").val();
                var thisMarketingMailerCode = $("#MarketingMailerCode").val();

                if ($("#stateCombo").jqxComboBox('getSelectedIndex') == -1) {
                    var thisStateId = 0;
                } else {
                    var thisStateId = $("#stateCombo").jqxComboBox('getSelectedItem').value;
                }

                var thisZip = $("#Zip").val();
                var thisCompany = $("#Company").val();

                if ($("#titleCombo").jqxComboBox('getSelectedIndex') == 0 || $("#titleCombo").jqxComboBox('getSelectedIndex') == -1) {
                    var thisTitleId = 0;
                } else {
                    var thisTitleId = $('#titleCombo').jqxComboBox('selectedIndex');;
                }

                var thisMarketingCode =  $("#MarketingCode").val();
                var thisMemberId = $("#MemberId").val(); 

                if ($("#homeLocationCombo").jqxComboBox('getSelectedIndex') == 0 || $("#homeLocationCombo").jqxComboBox('getSelectedIndex') == -1) {
                    var thisLocationId = 0;
                } else {
                    var thisLocationId = $("#homeLocationCombo").jqxComboBox('getSelectedItem').value;
                }

                if ($("#MailerCompanyComboID").val() == "" || $("#MailerCompanyCombo").val() == "") {
                    var thisCompanyId = 0;
                } else {
                    var thisCompanyId = $("#MailerCompanyComboID").val();
                }
               
                var first = true;
                var rows = $('#phoneGrid').jqxGrid('getrows');
                
                if (rows.length > 4) {
                    swal("Only four phone numbers permitted!")
                    return null;
                }

                var phoneType = new Array();
                var phoneNumber = new Array();

                for (var i = 0; i < rows.length; i++) {
                    phoneType[i] = rows[i].PhoneTypeId;
                    phoneNumber[i] = rows[i].Number;
                }

                var isRFR = false;

                if (group.indexOf("Portal_RFR") > 0) {
                    isRFR = true;
                }

                var thisGetEmail = $("#GetEmail").prop("checked");
                var thisTravelAlert = $("#TravelAlert").prop("checked");
                var thisEmailReceipts = $("#EmailReceipts").prop("checked");
                var thisRedeemEmail = $("#RedeemEmail").prop("checked");
                var thisProfileUpdateEmail = $("#ProfileUpdateEmail").prop("checked");
                var thisReservationChangeEmail = $("#ReservationChangeEmail").prop("checked");
                var thisReservationConfirmationEmail = $("#ReservationConfirmationEmail").prop("checked");
                var thisReservationReminder = $("#ReservationReminder").prop("checked");

                saveEmailPrefs(thisMemberId, thisEmailReceipts, thisGetEmail, thisTravelAlert, thisRedeemEmail, thisProfileUpdateEmail, thisReservationChangeEmail, thisReservationConfirmationEmail, thisReservationReminder)

                saveUpdateMemberInfo(phoneType, phoneNumber, thisMemberId, thisUserName, thisFirstName, thisLastName, thisSuffix, thisEmailAddress, thisStreetAddress, thisStreetAddress2,
                                     thisCityName, thisStateId, thisZip, thisCompany, thisTitleId, thisMarketingCode, thisLocationId, thisCompanyId, thisGetEmail, thisMarketingMailerCode, isRFR);

                var thisLoggedinUsername = $("#txtLoggedinUsername").val();


                PageMethods.LogMemberUpdate(thisLoggedinUsername, thisMemberId, '', '');

                //SaveMarketingCode();

                $("#editMember").trigger("click");
                
            });

            //show add card popup
            $("#addCard").on("click", function (event) {
                $("#addCardWindow").css('display', 'block');
                $("#addCardWindow").css('visibility', 'hidden');
                var offset = $("#jqxMemberInfoTabs").offset();
                $("#addCardWindow").jqxWindow({ position: { x: '25%', y: '30%' } });
                $('#addCardWindow').jqxWindow({ resizable: false });
                $('#addCardWindow').jqxWindow({ draggable: true });
                $('#addCardWindow').jqxWindow({ isModal: true });
                $("#addCardWindow").css("visibility", "visible");
                $('#addCardWindow').jqxWindow({ height: '250px', width: '50%' });
                $('#addCardWindow').jqxWindow({ minHeight: '250px', minWidth: '50%' });
                $('#addCardWindow').jqxWindow({ maxHeight: '500px', maxWidth: '50%' });
                $('#addCardWindow').jqxWindow({ showCloseButton: false });
                $('#addCardWindow').jqxWindow({ animationType: 'combined' });
                $('#addCardWindow').jqxWindow({ showAnimationDuration: 300 });
                $('#addCardWindow').jqxWindow({ closeAnimationDuration: 500 });
                $("#addCardWindow").jqxWindow('open');
            });

            //call add card function on click
            $("#addCardSubmit").on("click", function (event) {
                addCard();
            });

            $("#cancelCardSubmit").on("click", function (event) {
                $("#addCardWindow").jqxWindow('close');
            });

            //Delete Card from Member
            $("#deleteCard").on("click", function (event) {
                //var result = confirm("Do you want to delete this card!");
                //if (result != true) {
                //    return null;
                //}

                swal({
                    title: 'Are you sure?',
                    text: "Do you want to delete this card?",
                    type: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, delete it!'
                }).then(function () {
                    var rowCount = $('#jqxCardGrid').jqxGrid('getrows');

                    if (rowCount.length == 1) {
                        swal("There is only one card assigned to this account!")
                        return null;
                    }

                    var getselectedrowindexes = $('#jqxCardGrid').jqxGrid('getselectedrowindexes');

                    if (getselectedrowindexes.length > 0) {
                        for (var index = 0; index < getselectedrowindexes.length; index++) {
                            var selectedRowData = $('#jqxCardGrid').jqxGrid('getrowdata', getselectedrowindexes[index]);

                            var url = $("#apiDomain").val() + "members/cards/" + selectedRowData.CardId;

                            $.ajax({
                                headers: {
                                    "Accept": "application/json",
                                    "Content-Type": "application/json",
                                    "AccessToken": $("#userGuid").val(),
                                    "ApplicationKey": $("#AK").val()
                                },
                                type: "Delete",
                                url: url,

                                dataType: "json",
                                success: function () {
                                    swal(
                                        'Deleted!',
                                        'Your card has been deleted.',
                                        'success'
                                    )
                                    thisMemberId = $("#MemberId").val();
                                    $('#jqxCardGrid').jqxGrid('clearselection');
                                    $('#jqxCardGrid').jqxGrid('clear');
                                    loadCards(thisMemberId);
                                },
                                error: function (request, status, error) {
                                    swal(error);
                                }
                            });
                        }
                    }
                })
            });

            $("#UnDeleteCard").on("click", function (event) {

                swal({
                    title: 'Are you sure?',
                    text: "Do you want to Un-delete this card?",
                    type: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, Un-delete it!'
                }).then(function () {
                    var rowCount = $('#jqxCardGrid').jqxGrid('getrows');

                    if (rowCount.length == 1) {
                        swal("There is only one card assigned to this account!")
                        return null;
                    }

                    var getselectedrowindexes = $('#jqxCardGrid').jqxGrid('getselectedrowindexes');

                    if (getselectedrowindexes.length > 0) {
                        for (var index = 0; index < getselectedrowindexes.length; index++) {
                            var selectedRowData = $('#jqxCardGrid').jqxGrid('getrowdata', getselectedrowindexes[index]);

                            var url = $("#localApiDomain").val() + "Cards/UnDeleteCard/" + selectedRowData.CardId;
                            //var url = "http://localhost:52839/api/Cards/UnDeleteCard/" + selectedRowData.CardId;

                            $.ajax({
                                type: "GET",
                                url: url,
                                dataType: "json",
                                success: function () {
                                    swal(
                                        'Un-Deleted!',
                                        'Your card has been Un-deleted.',
                                        'success'
                                    )
                                    thisMemberId = $("#MemberId").val();
                                    $('#jqxCardGrid').jqxGrid('clearselection');
                                    $('#jqxCardGrid').jqxGrid('clear');
                                    loadCards(thisMemberId);
                                },
                                error: function (request, status, error) {
                                    swal(error);
                                }
                            });
                        }
                    }
                })
            });

            //Set Card As Primary
            $("#setCardPrimary").on("click", function (event) {

                swal({
                    title: 'Are you sure?',
                    text: "Do you want to set this card as primary?",
                    type: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, set it!'
                }).then(function () {
                    var getselectedrowindexes = $('#jqxCardGrid').jqxGrid('getselectedrowindexes');

                    //We can only do this to one card
                    if (getselectedrowindexes.length > 1) {
                        swal("Please only select one card to set as primary!")
                        return null;
                    }

                    if (getselectedrowindexes.length > 0) {
                        for (var index = 0; index < getselectedrowindexes.length; index++) {
                            var selectedRowData = $('#jqxCardGrid').jqxGrid('getrowdata', getselectedrowindexes[index]);

                            var thisMemberId = $("#MemberId").val();

                            var url = $("#apiDomain").val() + "members/" + thisMemberId + "/cards/" + selectedRowData.CardId + "/primary";

                            $.ajax({
                                headers: {
                                    "Accept": "application/json",
                                    "Content-Type": "application/json",
                                    "AccessToken": $("#userGuid").val(),
                                    "ApplicationKey": $("#AK").val()
                                },
                                type: "Put",
                                url: url,

                                dataType: "json",
                                success: function () {
                                    swal(
                                      'Set!',
                                      'Your card has been set as primary.',
                                      'success'
                                    )
                                    thisMemberId = $("#MemberId").val();
                                    $('#jqxCardGrid').jqxGrid('clearselection');
                                    $('#jqxCardGrid').jqxGrid('clear');
                                    loadCards(thisMemberId);
                                },
                                error: function (request, status, error) {
                                    swal(error);
                                }
                            });

                        }
                    }
                    
                })

                
            });

            // close combine card popup
            $("#cancelCombineMember").on("click", function (event) {
                $("#popupCombineMembers").css('display', 'none');
                $("#popupCombineMembers").jqxWindow('hide');
                $("#targetMember").val('');
            });


            //Open Combine card popup
            $("#combineMemberCards").on("click", function (event) {
                //New Pop up to deal with swal z-index issue
                //$("#popupCombineMembers").css('display', 'block');
                //$("#popupCombineMembers").css('width', '400px');
                //$("#popupCombineMembers").css('position', 'fixed');
                //$("#popupCombineMembers").css('top', '50%');
                //$("#popupCombineMembers").css('left', '50%');
                //$("#popupCombineMembers").css('transform', 'translate(-50%, -50%)');
                //$("#popupCombineMembers").css('background-color', '#F0EDED');
                //$("#popupCombineMembers").css('border-radius', '9px 9px 9px 9px');
                //$("#popupCombineMembers").css('z-index', '999');

                $("#popupCombineMembers").css('visibility', 'hidden');

                var offset = $("#jqxMemberInfoTabs").offset();
                $("#popupCombineMembers").jqxWindow({ position: { x: '30%', y: '30%' } });
                $('#popupCombineMembers').jqxWindow({ resizable: false });
                $('#popupCombineMembers').jqxWindow({ draggable: true });
                $('#popupCombineMembers').jqxWindow({ isModal: false });
                $("#popupCombineMembers").css("visibility", "visible");
                $('#popupCombineMembers').jqxWindow({ height: '15%', width: '30%' });
                $('#popupCombineMembers').jqxWindow({ minHeight: '25%', minWidth: '30%' });
                $('#popupCombineMembers').jqxWindow({ showCloseButton: true });
                $('#popupCombineMembers').jqxWindow({ animationType: 'combined' });
                $('#popupCombineMembers').jqxWindow({ showAnimationDuration: 300 });
                $('#popupCombineMembers').jqxWindow({ closeAnimationDuration: 500 });
                $("#popupCombineMembers").jqxWindow('open');

                
                var cardrows = $('#jqxCardGrid').jqxGrid('getrows');

                if (cardrows.length > 0) {

                    for (var index = 0; index < cardrows.length; index++) {
                        if (cardrows[index].IsPrimary  == true) {
                            $("#targetMember").val(cardrows[index].FPNumber);
                        }
                    }
                }
                else
                {
                    swal("This member doesn't have a card!");
                    return null;
                }
               
            });

            $("#saveCombineMember").on("click", function (event) {

                ////This code is to call the stored procedure with nested roll back
                ////Need to turn back on drag function at top of javascript
                //swal({
                //    title: 'Are you sure?',
                //    text: "Do you want to combine cards?",
                //    type: 'warning',
                //    showCancelButton: true,
                //    confirmButtonColor: '#3085d6',
                //    cancelButtonColor: '#d33',
                //    confirmButtonText: 'Yes, combine them!'
                //}).then(function () {
                //    var thisTargetCard = $("#targetMember").val();
                //    var thisSourceCard = $("#orginMember").val();
                //    var thisCombinedBy = $("#txtLoggedinUsername").val();

                //    PageMethods.combineCards(thisSourceCard, thisTargetCard, thisCombinedBy, DisplayPageMethodResults);
                //    return null;
                //});

                //return null;

                    
                var result = confirm("Do you want to combine these cards!");
                if (result != true) {
                    return null;
                }
                
                var thisTargetCard = $("#targetMember").val();
                var thisSourceCard = $("#orginMember").val();
                var thisCombinedBy = $("#txtLoggedinUsername").val();
                    
                    

                var url = $("#localApiDomain").val() + "CombineMemberCardsController/CombineMemberCards/";
                //var url = "http://localhost:52839/api/CombineMemberCardsController/CombineMemberCards/";

                $.ajax({
                    type: "POST",

                    url: url,

                    data: {
                        "TargetCard": thisTargetCard,
                        "OriginCard": thisSourceCard,
                        "CombinedBy": thisCombinedBy,
                    },
                    dataType: "json",
                    success: function (Response) {
                        swal(
                            'Combined!',
                            Response,
                            'success'
                        )
                        $("#popupCombineMembers").jqxWindow('hide');
                        thisMemberId = $("#MemberId").val();
                        $('#jqxCardGrid').jqxGrid('clearselection');
                        $('#jqxCardGrid').jqxGrid('clear');
                        $("#targetMember").val('');
                        loadCards(thisMemberId);
                        $("#topPointsBalance").html(loadPoints(AccountId, $("#topPointsBalance")));
                        $("#topPointsBalanceAccountBar").html(loadPoints(AccountId, $("#topPointsBalanceAccountBar")));
                    },
                    error: function (request, status, error) {
                        swal(error);
                    }
                });
            });

            //submit manual Edit manualEditSubmit
            $("#manualEditSubmit").on("click", function (event) {
                Date.prototype.toMMDDYYYYString = function () { return isNaN(this) ? 'NaN' : [this.getMonth() > 8 ? this.getMonth() + 1 : '0' + (this.getMonth() + 1), this.getDate() > 9 ? this.getDate() : '0' + this.getDate(), this.getFullYear()].join('/') }

                //var PageMemberID = Number($("#MemberId").val());
                var PageMemberID = $("#MemberId").val();
                var thisLocationId = $("#homeLocationCombo").jqxComboBox('getSelectedItem').value;
                var thisManualEditDate = DateTimeFormat(new Date());
                var thisSubmittedDate = "1/1/1900";
                var thisPerformedBy = $("#txtLoggedinUsername").val();
                var thisSubmittedBy = null;
                var thisExplanationId = $('#manualEditTypesCombo').jqxComboBox('getSelectedItem').value;
                var thisPointsChanged = $("#manualEditPoints").val();
                var thisCertificateNumber = "";
                var thisParkingTransactionNumber = "";
                var thisCompanyId = 0;
                var thisNotes = $("#manualEditNote").val();
                var thisPerformedByUserId = null;
                var thisSubmittedByUserId = null;

                thisNotes = thisNotes.replace("'", "''");

                
                $.ajax({
                    type: "POST",
                    //url: "http://localhost:52839/api/ManualEdits/AddManualEdit/",
                    url: $("#localApiDomain").val() + "ManualEdits/AddManualEdit/",
                    
                    data: { "ManualEditId": 0,
                        "MemberId": PageMemberID,
                        "LocationId": thisLocationId,
                        "ManualEditDate": thisManualEditDate,
                        "SubmittedDate": thisSubmittedDate,
                        "PerformedBy": thisPerformedBy,
                        "SubmittedBy": thisSubmittedBy,
                        "ExplanationId": thisExplanationId,
                        "PointsChanged": thisPointsChanged,
                        "CertificateNumber": thisCertificateNumber,
                        "ParkingTransactionNumber": thisParkingTransactionNumber,
                        "CompanyId": thisCompanyId,
                        "Notes": thisNotes,
                        "PerformedByUserId": thisPerformedByUserId,
                        "SubmittedByUserId": thisSubmittedByUserId,
                        "CreateDatetime": null,
                        "CreateUserId": null,
                        "UpdateDatetime": null,
                        "UpdateUserId": null,
                        "IsDeleted": null,
                        "CreateExternalUserData": null,
                        "UpdateExternalUserData": null,
                    },
                    dataType: "json",
                    success: function (Response) {
                        swal("Saved!");
                        $("#topPointsBalance").html(loadPoints(AccountId, $("#topPointsBalance"))); 
                        $("#topPointsBalanceAccountBar").html(loadPoints(AccountId, $("#topPointsBalanceAccountBar")));
                    },
                    error: function (request, status, error) {
                        swal(error);
                    }
                });
            });

            //Submit Receipt Version 1
            $("#submitReceipt1").on("click", function (event) {
                var newEntryDate = $("#jqxReceiptEntryCalendar").val();
                var newReceiptNumber = $("#receiptNumber").val();
                var PageMemberID = $('#MemberId').val();
                var submittedBy = $("#txtLoggedinUsername").val();
                var thisLocationId = $("#receiptLocationCombo").jqxComboBox('getSelectedItem').value;
                var checked = $('#jqxRadioTypeReceipt').jqxRadioButton('checked');
                var thisGuid = $('#tempUserGuid').val()

                if (checked == true) {
                    PageMethods.SubmitReceipt1(newEntryDate, newReceiptNumber, "", submittedBy, thisLocationId, PageMemberID, thisGuid, DisplayPageMethodResults);
                    function onSucess(result) {
                        swal(result);
                    }
                    function onError(result) {
                        swal('Error Submitting Receipt.');
                    }
                }
                else
                {
                    PageMethods.SubmitReceipt1(newEntryDate, "", newReceiptNumber, submittedBy, thisLocationId, PageMemberID, thisGuid, DisplayPageMethodResults);
                    function onSucess(result) {
                        swal(result);
                    }
                    function onError(result) {
                        swal('Error Submitting Receipt.');
                    }
                }
            });

            //Submit Receipt Version 2
            $("#submitReceipt2").on("click", function (event) {
                var newEntryDate = $("#jqxReceiptDetailEntryCalendar").val();
                var newExitDate = $("#jqxReceiptDetailExitCalendar").val();
                var newAmountPaid = $("#ReceiptDetailAmountPaid").val();
                var PageMemberID = $('#MemberId').val();
                var submittedBy = $("#txtLoggedinUsername").val();
                var thisLocationId = $("#receiptLocationCombo2").jqxComboBox('getSelectedItem').value;
                var checked = $('#jqxRadioTypeReceipt').jqxRadioButton('checked');
                var thisGuid = $('#tempUserGuid').val()

                PageMethods.SubmitReceipt2(PageMemberID, newEntryDate, newExitDate, newAmountPaid, thisLocationId, submittedBy, thisGuid, DisplayPageMethodResults);
                function onSucess(result) {
                    swal(result);
                }
                function onError(result) {
                    swal('Error Submitting Receipt.');
                }
            });

            //Send Login Instructions
            $("#SendLoginInstructions").on("click", function (event)
            {
                var newPasswordBody = "These are login instructions";
                var thisMemberEmail = $("#EmailAddress").val();

                PageMethods.SendEmail(thisMemberEmail, "RFRTeam@thefastpark.com", "APF Login Instructions", newPasswordBody, true, onSucess, onError);
                function onSucess(result) {
                    swal(result);
                }
                function onError(result) {
                    swal('Error instructions not sent.');
                }
            });

            $("#DisplayQA").on("click", function (event) {
                loadDisplayQA();

                $("#popupDisplayQA").css('display', 'block');
                $("#popupDisplayQA").css('visibility', 'hidden');

                var offset = $("#jqxMemberInfoTabs").offset();
                $("#popupDisplayQA").jqxWindow({ position: { x: '5%', y: '10%' } });
                $('#popupDisplayQA').jqxWindow({ resizable: false });
                $('#popupDisplayQA').jqxWindow({ draggable: true });
                $('#popupDisplayQA').jqxWindow({ isModal: true });
                $("#popupDisplayQA").css("visibility", "visible");
                $('#popupDisplayQA').jqxWindow({ height: '80%', width: '90%' });
                $('#popupDisplayQA').jqxWindow({ minHeight: '80%', minWidth: '90%' });
                $('#popupDisplayQA').jqxWindow({ maxHeight: '90%', maxWidth: '90%' });
                $('#popupDisplayQA').jqxWindow({ showCloseButton: true });
                $('#popupDisplayQA').jqxWindow({ animationType: 'combined' });
                $('#popupDisplayQA').jqxWindow({ showAnimationDuration: 300 });
                $('#popupDisplayQA').jqxWindow({ closeAnimationDuration: 500 });
                $("#popupDisplayQA").jqxWindow('open');
            });

            //Send new Password
            $("#SendNewPassword").on("click", function (event) {
                var thisMemberEmail = $("#EmailAddress").val();
                //swal($("#apiDomain").val() + "members/forgot-password?Email=" + thisMemberEmail);

                $.ajax({
                    headers: {
                        "Accept": "application/json",
                        "Content-Type": "application/json",
                        "AccessToken": $("#userGuid").val(),
                        "ApplicationKey": $("#AK").val()
                    },
                    type: "GET",
                    url: $("#apiDomain").val() + "members/forgot-password?Email=" + thisMemberEmail,
                    dataType: "json",
                    success: function () {
                        swal("Forgot Password Instructions Sent!");
                    },
                    error: function (request, status, error) {
                        swal(error + " - " + request.responseJSON);
                    }
                });
            });


            //defines search grid double click to load member info
            $("#jqxSearchGrid").bind('rowdoubleclick', function (event) {
                $('#jqxLoader').jqxLoader('open');
                var row = event.args.rowindex;
                var dataRecord = $("#jqxSearchGrid").jqxGrid('getrowdata', row);
                findMember(dataRecord.MemberId);
                $("#jqxSearchGrid").toggle();
                $("#MemberDetails").toggle();
            });

            //Loads member from hidden field in member name tab labels
            $('#jqxMemberTabs').on('tabclick', function (event) {
                var clickedItem = event.args.item;
                if ($('#jqxMemberTabs').jqxTabs('getTitleAt', clickedItem) == "Account") {
                    $("#AccountTabContent").toggle();
                    $("#jqxMemberInfoTabs").toggle();
                } else {
                    if ($("#jqxMemberInfoTabs").is(":hidden")) {
                        $("#jqxMemberInfoTabs").toggle();
                        $("#AccountTabContent").toggle();

                    }
                    loadMember($("#" + clickedItem).val(), false);
                }
            });

            // button collapse search bar
            $("#collapseSearchBar").on("click", function (event) {
                $(this).toggleClass('dropup dropdown');
                $(".FPR_SearchBox").toggle();

            });

            //Gets member and members acct number to load associated members
            $("#btnSearch").on("click", function (event) {

                //*********This code might be used to select member if only on is returned from search****************
                //loadSearchResults();
                //var datainformations = $("#jqxSearchGrid").jqxGrid("getdatainformation");
                //var rowscounts = datainformations.rowscount;
                //swal(rowscounts);
                //if (rowscounts = 1) {
                //    var dataRecord = $("#jqxSearchGrid").jqxGrid('getrowdata', 0);
                //    findMember(dataRecord.MemberId);
                //    $("#jqxSearchGrid").toggle();
                //    $("#MemberDetails").toggle();
                //}
                //if ($("#jqxSearchGrid").is(":visible")) {
                //    $("#jqxSearchGrid").toggle();
                //    $("#MemberDetails").toggle();
                //}

                $('#jqxMemberInfoTabs').jqxTabs('select', 0);

                clearMemberInfo();

                var thisParameters = GetSearchParameters();

                if ($("#jqxSearchGrid").is(":visible")) {
                    if (thisParameters != "") {
                        loadSearchResults(thisParameters);
                    }       
                }
                else {
                    if (thisParameters != "") {
                        $("#MemberDetails").toggle();
                        $("#jqxSearchGrid").toggle();
                        loadSearchResults(thisParameters);
                    }
                }
               
            });

            $("#btnClear").on("click", function (event) {
                $("div.FPR_SearchLeft input:text").val("");
                $("#SearchFPNumber").val('');
                $("#jqxSearchGrid").jqxGrid('clear');
                
                if ($("#jqxSearchGrid").is(":hidden")) {
                    $("#MemberDetails").toggle();
                    $("#jqxSearchGrid").toggle();
                    clearMemberInfo();
                }
            });

            $("#saveNote").on("click", function (event) {
                saveNote();
            });

            $("#cancelNote").on("click", function (event) {
                $("#popupNote").jqxWindow('close');
                $("#txtNote").val('');
                $("#saveNote").css("visibility", "visible");
            });

            $("#addNote").on("click", function (event) {
                newNote();
            });

            $("#editMember").on("click", function (event) {
                if ($("#editMember").val() == "Cancel Edit") {
                    jQuery("#tabMemberInfo").find("input[type=text]").attr("disabled", true);
                    $("#stateCombo").jqxComboBox({ disabled: true });
                    $("#homeLocationCombo").jqxComboBox({ disabled: true });
                    $("#editMember").val("Edit");
                    $("#updateMemberInfo").css("visibility", "hidden");
                    $("#addPhone").jqxButton({ disabled: true });
                    $("#deleteEmail").jqxButton({ disabled: true });
                    //$("#MailerCompanyCombo").jqxComboBox({ disabled: true });
                    $("#MailerCompanyCombo").attr("disabled", true);
                    $('#phoneGrid').jqxGrid({ editable: false });


                }
                else {
                    jQuery("#tabMemberInfo").find("input[type=text]").attr("disabled", false);
                    $("#stateCombo").jqxComboBox({ disabled: false });
                    $("#homeLocationCombo").jqxComboBox({ disabled: false });
                    $("#editMember").val("Cancel Edit");
                    //$("#MailerCompanyCombo").jqxComboBox({ disabled: false });
                    $("#MailerCompanyCombo").attr("disabled", false);
                    $("#updateMemberInfo").css("visibility", "visible");
                    $("#addPhone").jqxButton({ disabled: false });
                    $("#deleteEmail").jqxButton({ disabled: false });
                    $('#phoneGrid').jqxGrid({ editable: true });

                    //if (group.indexOf("RFR") > -1 || group.indexOf("Portal_Superadmin") > -1) {
                    //    //$("#MailerCompanyCombo").jqxComboBox({ disabled: false });
                    //    $("#MailerCompanyCombo").attr("disabled", false);
                    //}
                    Security();
                }
            });
            //#endregion

            //#region Combobox Event Setup


            $("#homeLocationCombo").on('bindingComplete', function (event) {
                $("#homeLocationCombo").on('change', function (event) {
                    $("#topLocationAccountBar").html($("#homeLocationCombo").jqxComboBox('getSelectedItem').label);
                });
            });

            //Combobox insert placeholder
            $("#LocationCombo").on('bindingComplete', function (event) {
                $("#LocationCombo").jqxComboBox('insertAt', 'Location', 0);
                $("#LocationCombo").on('change', function (event) {
                    //Do nothing for now
                });
            });


            $("#LocationCombo").on('select', function (event) {
                if (event.args) {

                    var item = event.args.item;
                    if (item) {

                    }
                }
            });

            //Combobox insert placeholder
            $("#titleCombo").on('bindingComplete', function (event) {
                $("#titleCombo").jqxComboBox('insertAt', '', 0);
                $("#titleCombo").jqxComboBox('selectIndex', 0);
            });

            //#endregion

            //#region pageSetup



            // make the redemption grid single select
            $('#jqxRedemptionGrid').on('rowselect', function (event) {
                // event arguments.
                var args = event.args;
                var index = args.rowindex;
                var getselectedrowindexes = $('#jqxRedemptionGrid').jqxGrid('getselectedrowindexes');

                ////Force Single select with checkbox
                //if (getselectedrowindexes.length > 0) {
                //    if (getselectedrowindexes != index) {
                //        $("#jqxRedemptionGrid").jqxGrid('clearselection');
                //        $("#jqxRedemptionGrid").jqxGrid('selectrow', index);
                //    }
                //}

            });

            // set key press in search bar to initiate search
            $("div.FPR_SearchLeft input:text").keypress(function (e) {

                if (e.keyCode == 13) {
                    var thisParameters = GetSearchParameters();

                    if ($("#jqxSearchGrid").is(":visible")) {
                        if (thisParameters != "") {
                            loadSearchResults(thisParameters);
                        }
                    }
                    else {
                        if (thisParameters != "") {
                            $("#MemberDetails").toggle();
                            $("#jqxSearchGrid").toggle();
                            loadSearchResults(thisParameters);
                        }
                    }

                }
            });

            $("#SearchFPNumber").keypress(function (e) {

                if (e.keyCode == 13) {
                    var thisParameters = GetSearchParameters();

                    if ($("#jqxSearchGrid").is(":visible")) {
                        if (thisParameters != "") {
                            loadSearchResults(thisParameters);
                        }
                    }
                    else {
                        if (thisParameters != "") {
                            $("#MemberDetails").toggle();
                            $("#jqxSearchGrid").toggle();
                            loadSearchResults(thisParameters);
                        }
                    }

                }
            });

           
            $("#AccountTabContent").toggle();
            $("#updateMemberInfo").css("visibility", "hidden");
            //create loader Icon
            $("#jqxLoader").jqxLoader({ isModal: true, width: 100, height: 60, imagePosition: 'top' });

            //create receipt entry calendar
            $("#jqxReceiptEntryCalendar").jqxDateTimeInput({ formatString: 'MM-dd-yyyy', width: '100%', height: '24px' });

            //create receipt Detail entry and exit date and time inputs
            $("#jqxReceiptDetailEntryCalendar").jqxDateTimeInput({ formatString: 'MM-dd-yyyy HH:mm', showTimeButton: true, width: '100%', height: '24px' });
            $("#jqxReceiptDetailExitCalendar").jqxDateTimeInput({ formatString: 'MM-dd-yyyy HH:mm', showTimeButton: true, width: '100%', height: '24px' });

            //removes place holder tab
            $('#jqxMemberTabs').jqxTabs('removeAt', 0);

            //initializes return to search button and member tabs as not visible
            $("#MemberDetails").toggle();
            //Disables member detail inputs
            jQuery("#tabMemberInfo").find("input[type=text]").attr("disabled", true);
            $("#stateCombo").jqxComboBox({ disabled: true });
            $("#homeLocationCombo").jqxComboBox({ disabled: true });
            $("#addPhone").jqxButton({ disabled: true });
            $("#deleteEmail").jqxButton({ disabled: true });
            //$("#MailerCompanyCombo").jqxComboBox({ disabled: true });
            
            

            // Setup Radio Buttons for simple Receipt Entry form+++++++++++++++++++++++++++++++++++++++++++++
            $("#jqxRadioTypeReceipt").jqxRadioButton({ groupName: 'ReceiptEntry', width: 100, height: 24, checked: true });
            $("#jqxRadioTypeColumn").jqxRadioButton({ groupName: 'ReceiptEntry', width: 100, height: 24 });
            $("#jqxRadioTypeNormal").jqxRadioButton({ groupName: 'ReceiptEntryDetail', width: 100, height: 24, checked: true });
            $("#jqxRadioTypeLost").jqxRadioButton({ groupName: 'ReceiptEntryDetail', width: 100, height: 24 });
            $("#jqxRadioTypeDamaged").jqxRadioButton({ groupName: 'ReceiptEntryDetail', width: 100, height: 24 });

            //this one needs to load on page load
            loadCompaniesSearchCombo();
            
            loadLocationCombo();
            loadTitle();
            loadStateCombo();
            loadHomeLocationCombo();
            loadReceiptLocationCombo();
            loadmanualEditTypesCombo();
            loadStatus();


            
            Security();


            if (getUrlParameter("MemberId") != "") {
                findMember(getUrlParameter("MemberId"));
                $("#MemberDetails").toggle();
                $("#jqxSearchGrid").toggle();
            };
            //#endregion

        });
        
        //#region LoadGrids

        function LoadArchiveSearch() {
            //Loads card list
            var parent = $("#jqxArchiveGrid").parent();
            $("#jqxArchiveGrid").jqxGrid('destroy');
            $("<div id='jqxArchiveGrid'></div>").appendTo(parent);

            var PageMemberID = $("#MemberId").val();

            var url = $("#localApiDomain").val() + "ArchiveActivitysController/GetArchive/" + PageMemberID;
            //var url = "http://localhost:52839/api/ArchiveActivitysController/GetArchive/" + PageMemberID;

            var source =
            {
                datafields: [
                    
                    { name: 'ManualEditId' },
                    { name: 'DateTimeOfEntry' },
                    { name: 'DateTimeOfExit' },
                    { name: 'ManualEditDate' },
                    { name: 'Description' },
                    { name: 'PointsChanged' },
                    { name: 'ParkingTransactionNumber' },
                ],

                type: 'Get',
                datatype: "json",
                url: url
            };

            // create jqxNotesGrid
            $("#jqxArchiveGrid").jqxGrid(
            {
                theme: 'shinyblack',
                width: '100%',
                height: 450,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                columnsresize: true,
                enablebrowserselection: true,
                columns: [
                      { text: 'ManualEditId', datafield: 'ManualEditId', hidden: true },
                      { text: 'Entry', datafield: 'DateTimeOfEntry', width: '15%', cellsrenderer: DateTimeRender },
                      { text: 'Exit', datafield: 'DateTimeOfExit', width: '15%', cellsrenderer: DateTimeRender },
                      { text: 'Manual Edit Date', datafield: 'ManualEditDate', width: '15%', cellsrenderer: DateTimeRender },
                      { text: 'Description', datafield: 'Description', width: '30%' },
                      { text: 'PointsChanged', datafield: 'PointsChanged', width: '10%' },
                      { text: 'ParkingTransactionNumber', datafield: 'ParkingTransactionNumber', width: '20%' },
                ]
            });

        }


        function loadMemberList(acctNum, compareMemberId) {
            
            $.ajax({
                type: 'GET',
                url: $("#apiDomain").val() + "accounts/" + acctNum + "/members",
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": $("#userGuid").val(),
                    "ApplicationKey": $("#AK").val()
                },
                success: function (thisData) {
                    var tabNameContent = "";
                    var FirstName = "";
                    var LastName = "";
                    var MemberId = "";
                    var counter = 0;
                    var memberPicked = 0;
                    for (i = 0; i < thisData.result.ResultCount; i++) {
                        $.each(thisData.result.data[i].MemberInformation, function (key, val) {
                            // gets info to put in member name tab
                            if (key == 'FirstName') {
                                FirstName = val;
                            }
                            if (key == 'LastName') {
                                LastName = val;
                            }
                            if (key == 'MemberId') {
                                MemberId = val;
                                if (compareMemberId == MemberId) {
                                    memberPicked = i;
                                }
                            }

                            if (FirstName != "" && LastName != "" && MemberId != "") {
                                //creates Member Name tab
                                $('#jqxMemberTabs').jqxTabs('addLast', FirstName + ' ' + LastName + '<input type="hidden" id="' + counter + '" value="' + MemberId + '">', '');

                                //clears the variables to the if statement won't catch it again
                                FirstName = "";
                                LastName = "";
                                MemberId = "";
                                counter = counter + 1;
                            }
                        });
                    }

                    //loads the first member in the list
                    $('#jqxMemberTabs').jqxTabs('addLast', 'Account');

                    $('#jqxMemberTabs').jqxTabs('select', memberPicked);
                    loadMember($("#" + memberPicked).val());

                  
                },
                error: function (request, status, error) {
                    swal(error + " - " + request.responseJSON);
                }

            });
        }

        function loadEmailPrefs(PageMemberID) {
            $.ajax({
                type: 'GET',
                url: $("#apiDomain").val() + "members/" + PageMemberID + "/email-preferences",
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": $("#userGuid").val(),
                    "ApplicationKey": $("#AK").val()
                },
                success: function (thisData) {
;
                    $("#GetEmail").prop("checked", thisData.result.data.GetEmail);
                    $("#TravelAlert").prop("checked", thisData.result.data.TravelAlertsEmailFlag);
                    $("#EmailReceipts").prop("checked", thisData.result.data.EmailReceiptsFlag);
                    $("#RedeemEmail").prop("checked", thisData.result.data.RedeemEmailFlag);
                    $("#ProfileUpdateEmail").prop("checked", thisData.result.data.ProfileUpdateEmailFlag);
                    $("#ReservationChangeEmail").prop("checked", thisData.result.data.ReservationChangeEmailFlag);
                    $("#ReservationConfirmationEmail").prop("checked", thisData.result.data.ReservationConfirmationEmailFlag);
                    $("#ReservationReminder").prop("checked", thisData.result.data.ReservationReminderFlag);
                    
                },
                error: function (request, status, error) {
                    swal(error + " - " + request.responseJSON);
                }
            });
        }

        function loadCards(PageMemberID) {

            var parent = $("#jqxCardGrid").parent();
            $("#jqxCardGrid").jqxGrid('destroy');
            $("<div id='jqxCardGrid'></div>").appendTo(parent);


            //Loads card list
            //var url = $("#apiDomain").val() + "Members/" + PageMemberID + "/Cards";
            //var url = "http://localhost:52839/api/Cards/GetCards/" + PageMemberID;
            var url = $("#localApiDomain").val() + "Cards/GetCards/" + PageMemberID;

            var source =
            {
                datafields: [
                    { name: 'CardId' },
                    { name: 'MemberId' },
                    { name: 'FPNumber' },
                    { name: 'IsPrimary' },
                    { name: 'IsActive' },
                    { name: 'IsDeleted' },
                    { name: 'CreateDatetime' },
                    { name: 'UpdateDatetime' }
                ],

                id: 'CardId',
                type: 'Get',
                datatype: "json",
                url: url,
                //beforeSend: function (jqXHR, settings) {
                //    jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
                //    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                //},
                root: "data"
            };

            var RenderTrueFalse = function (row, columnfield, value, defaulthtml, columnproperties) {
                // format date as string due to inconsistant date coversions
                switch (value) {
                    case 0:
                        return '<div style="margin-top: 10px;margin-left: 5px"></div>';
                        break;
                    case 1:
                        return '<div style="margin-top: 10px;margin-left: 5px">Yes</div>';
                        break;
                    default:
                        return '<div style="margin-top: 10px;margin-left: 5px"></div>';
                        break;
                }

            };

            // create jqxCardGrid
            $("#jqxCardGrid").jqxGrid(
            {
                pageable: true,
                pagermode: 'advanced',
                pagesize: 50,
                pagesizeoptions: ['10', '20', '50', '100'],
                width: '100%',
                height: 450,
                selectionmode: 'checkbox',
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                enablebrowserselection: true,
                columns: [
                      { text: 'Card Id', datafield: 'CardId', hidden: true },
                      { text: 'Member Id', datafield: 'MemberId', hidden: true },
                      {
                          text: 'FPNumber', datafield: 'FPNumber', cellsalign: 'right',
                          cellsrenderer: function (row, column, value) {
                              var orig = value;
                              var firstThree = "";
                              var lastFive = "";

                              //checks to see if the number is 8 digits if not it pads with zeros
                              if (orig.length < 8) {
                                  orig = padNumber(orig, 8)
                              }

                              //breaks the fpnumber into three digits then 5 digits then returns the number to the grid
                              firstThree = orig.substring(0, 3);
                              lastFive = orig.substring(3, 8);
                              return "<div style='margin-top:10px;margin-left:5px;'>" + firstThree + "-" + lastFive + "</div>";
                          }
                      },
                      { text: 'Primary', datafield: 'IsPrimary', cellsrenderer: RenderTrueFalse },
                      { text: 'Active', datafield: 'IsActive', cellsrenderer: RenderTrueFalse },
                      { text: 'Deleted', datafield: 'IsDeleted', cellsrenderer: RenderTrueFalse },
                      { text: 'Date Added', datafield: 'CreateDatetime', cellsrenderer: DateTimeRender },
                      { text: 'Date updated', datafield: 'UpdateDatetime', cellsrenderer: DateTimeRender }
                ]
            });
        }

        function loadDisplayQA() {


            var parent = $("#jqxDisplayQAGrid").parent();
            $("#jqxDisplayQAGrid").jqxGrid('destroy');
            $("<div id='jqxDisplayQAGrid'></div>").appendTo(parent);

            //Loads card list
            var PageMemberID = $("#MemberId").val();

            var url = $("#apiDomain").val() + "members/" + PageMemberID + "/security-questions";

            var source =
            {
                datafields: [
                    { name: 'MemberHasSecurityQuestionId' },
                    { name: 'MemberId' },
                    { name: 'Answer' },
                    { name: 'SecurityQuestionId', map: 'SecurityQuestion>SecurityQuestionId' },
                    { name: 'SecurityQuestionText', map: 'SecurityQuestion>SecurityQuestionText' },
                    { name: 'IsDisplayed', map: 'SecurityQuestion>IsDisplayed' },
                    { name: 'IsUsed', map: 'SecurityQuestion>IsUsed' }
                ],

                id: 'MemberHasSecurityQuestionId',
                type: 'Get',
                datatype: "json",
                url: url,
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                root: "data"
            };

            // create jqxCardGrid
            $("#jqxDisplayQAGrid").jqxGrid(
            {
                width: '100%',
                source: source,
                columnsresize: true,
                columns: [
                      { text: 'Question', datafield: 'SecurityQuestionText', width: '50%' },
                      { text: 'Answer', datafield: 'Answer', width: '30%' },
                      { text: 'IsDisplayed', datafield: 'IsDisplayed', width: '10%' },
                      { text: 'IsUsed', datafield: 'IsUsed', width: '10%' },
                      { text: 'MemberHasSecurityQuestionId', datafield: 'MemberHasSecurityQuestionId', hidden: true },
                      { text: 'MemberId', datafield: 'MemberId', hidden: true },
                      { text: 'SecurityQuestionId', datafield: 'SecurityQuestionId', hidden: true }
                ]
            });
        }

        function loadMemberActivity(PageMemberID) {

            var parent = $("#jqxMemberActivityGrid").parent();
            $("#jqxMemberActivityGrid").jqxGrid('destroy');
            $("<div id='jqxMemberActivityGrid'></div>").appendTo(parent);

            //Loads card list
            var url = $("#apiDomain").val() + "accounts/" + AccountId + "/activity?StartDate=1/1/1900&EndDate=1/1/9999&Limit=";

            var source =
            {
                datafields: [
                    { name: 'MemberId' },
                    { name: 'ParkingTransactionNumber' },
                    { name: 'ManualEditsId' },
                    { name: 'RedemptionId' },
                    { name: 'PointsChanged' },
                    { name: 'Points'},
                    { name: 'Description' },
                    { name: 'LocationId' },
                    { name: 'Date', type: 'date' }
                ],

                type: 'Get',
                datatype: 'json',
                url: url,
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                root: 'result>data>ActivityHistory'
            };

            var dataAdapter = new $.jqx.dataAdapter(source);
            
            // create member Activity Grid
            $("#jqxMemberActivityGrid").jqxGrid(
            {
                //pageable: true,
                //pagermode: 'advanced',
                //pagesize: 50,
                //pagesizeoptions: ['10', '20', '50', '100'],
                width: '100%',
                height: 500,
                source: dataAdapter,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                columnsresize: true,
                selectionmode: 'multiplecells',
                ready: function (records) {
                    var rows = $("#jqxMemberActivityGrid").jqxGrid('getrows');

                    // get the total member points
                    var thisTotal = parseInt($("#topPointsBalanceAccountBar").html());
                    var thisPointsChanged = 0;
                    var thisFirst = true;

                    var length = rows.length;
                    for (var i = 0; i < length ; i++) {
                        var record = rows[i];
                        //get pointschanged for this row
                        thisPointsChanged = parseInt(record["PointsChanged"]);
                        // put the current thistotal in the current row.  The first row will have the members actual total
                        $("#jqxMemberActivityGrid").jqxGrid('setcellvalue', i, 'Points', thisTotal);

                        //subtract this rows points changed from the total and it will go on the next line.
                        thisTotal = thisTotal - thisPointsChanged;
                    }

                    // create a filter group for the FirstName column.
                    var fnameFilterGroup = new $.jqx.filter();
                    // operator between the filters in the filter group. 1 is for OR. 0 is for AND.
                    var filter_or_operator = 1;
                    // create a string filter with 'contains' condition.
                    var filtervalue = PageMemberID;
                    var filtercondition = 'contains';
                    var fnameFilter1 = fnameFilterGroup.createfilter('stringfilter', filtervalue, filtercondition);
                    fnameFilterGroup.addfilter(filter_or_operator, fnameFilter1);
                    $("#jqxMemberActivityGrid").jqxGrid('addfilter', 'MemberId', fnameFilterGroup);
                    $("#jqxMemberActivityGrid").jqxGrid('applyfilters');
                },
                columns:[ 
                      { text: 'Member Id', datafield: 'MemberId', hidden: true },
                      { text: 'ParkingTransactionNumber', datafield: 'ParkingTransactionNumber', width: '20%' },
                      { text: 'ManualEditsId', datafield: 'ManualEditsId', hidden: true },
                      { text: 'RedemptionId', datafield: 'RedemptionId', hidden: true },
                      { text: 'Points Changed', datafield: 'PointsChanged', width: '10%' },
                      { text: 'Balance', datafield: 'Points', width: '10%' },
                      { text: 'Description', datafield: 'Description', width: '40%' },
                      { text: 'Location', datafield: 'LocationId', width: '10%', cellsrenderer: locatioinCellsrenderer },
                      //{ text: 'Date', datafield: 'Date', width: '10%', cellsrenderer: DateRender }
                      { text: 'Date', datafield: 'Date', width: '10%', cellsformat: 'MM/dd/yyyy' }
                ]
            });

            // defines activity grid double click
            $("#jqxMemberActivityGrid").bind('rowdoubleclick', function (event) {
                var row = event.args.rowindex;
                var dataRecord = $("#jqxMemberActivityGrid").jqxGrid('getrowdata', row);
                var isReceipt = dataRecord.ParkingTransactionNumber;
                var isRedemption = dataRecord.RedemptionId;
                var thisManualEditId = dataRecord.ManualEditsId;
                var offset = $("#jqxMemberInfoTabs").offset();
                var toAddress = $("#EmailAddress").val();

                var thisMemberId = $("#MemberId").val();

                if (isReceipt != null) {
                    //This will show the Receipt
                    var row = event.args.rowindex;
                    var dataRecord = $("#jqxMemberActivityGrid").jqxGrid('getrowdata', row);
                    var thisLocationId = dataRecord.LocationId;

                    $("#popupReceipt").css('display', 'block');
                    $("#popupReceipt").css('visibility', 'hidden');

                    var offset = $("#jqxMemberInfoTabs").offset();

                    $("#popupReceipt").jqxWindow({ position: { x: parseInt(offset.left) + 350, y: parseInt(offset.top) - 150 } });
                    $('#popupReceipt').jqxWindow({ maxHeight: 525, maxWidth: 250 });
                    $('#popupReceipt').jqxWindow({ width: "950px", height: "600px" });
                    $("#popupReceipt").css("visibility", "visible");
                    $("#popupReceipt").jqxWindow('open');
                    document.getElementById('receiptIframe').src = './ReceiptDisplay.aspx?MemberId=' + thisMemberId + '&ParkingTransactionNumber=' + isReceipt + '&LocationId=' + thisLocationId + '&EmailAddress=' + toAddress;
                    return null;
                }
                //This will show the Redemption

                if (isRedemption != null) {
                    //get redemption data and send to display
                    var thisRedemptionId = dataRecord.RedemptionId

                    $.ajax({
                        type: 'GET',
                        url: $("#apiDomain").val() + "members/" + thisMemberId + "/redemptions/" + thisRedemptionId,
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
                            swal(error + " - " + request.responseJSON);
                        }
                    });
                    return null;
                }

                if (thisManualEditId != null) {
                    //get redemption data and send to display
                    var thisManualEditId = dataRecord.ManualEditsId

                    var url = $("#localApiDomain").val() + "ManualEdits/ManualEditById/" + thisManualEditId;
                    //var url = "http://localhost:52839/api/ManualEdits/ManualEditById/" + thisManualEditId;
                    $.ajax({
                        type: 'GET',
                        url: url,
                        
                        success: function (thisData) {
                            var notes = String(thisData[0].Notes);
                            var explanation = String(thisData[0].Explanation);

                            $("#ManualEditNote").html(notes);

                            $("#popupViewManualEdit").css('display', 'block');
                            $("#popupViewManualEdit").css('visibility', 'hidden');

                            $("#popupViewManualEdit").jqxWindow({ position: { x: '25%', y: '7%' } });
                            $('#popupViewManualEdit').jqxWindow({ resizable: false });
                            $('#popupViewManualEdit').jqxWindow({ draggable: true });
                            $('#popupViewManualEdit').jqxWindow({ isModal: true });
                            $("#popupViewManualEdit").css("visibility", "visible");
                            $('#popupViewManualEdit').jqxWindow({ height: '300px', width: '35%' });
                            $('#popupViewManualEdit').jqxWindow({ minHeight: '270px', minWidth: '10%' });
                            $('#popupViewManualEdit').jqxWindow({ maxHeight: '700px', maxWidth: '50%' });
                            $('#popupViewManualEdit').jqxWindow({ showCloseButton: true });
                            $('#popupViewManualEdit').jqxWindow({ animationType: 'combined' });
                            $('#popupViewManualEdit').jqxWindow({ showAnimationDuration: 300 });
                            $('#popupViewManualEdit').jqxWindow({ closeAnimationDuration: 500 });
                            $("#popupViewManualEdit").jqxWindow('open');

                            //var thisCertificateID = thisData.result.data.CertificateID;
                        },
                        error: function (request, status, error) {
                            swal(error + " - " + request.responseJSON);
                        }
                    });
                    return null;
                }
            });
        }

        function loadAccountActivity() {

            var parent = $("#jqxAccountActivityGrid").parent();
            $("#jqxAccountActivityGrid").jqxGrid('destroy');
            $("<div id='jqxAccountActivityGrid'></div>").appendTo(parent);

            //Loads card list
            var url = $("#apiDomain").val() + "accounts/" + AccountId + "/activity?StartDate=1/1/1900&EndDate=1/1/9999&Limit=";


            var source =
            {
                datafields: [
                    { name: 'MemberId' },
                    { name: 'ParkingTransactionNumber' },
                    { name: 'ManualEditsId' },
                    { name: 'RedemptionId' },
                    { name: 'PointsChanged' },
                    { name: 'Description' },
                    { name: 'LocationId' },
                    { name: 'Date' }
                ],

                type: 'Get',
                datatype: 'json',
                url: url,
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                root: 'result>data>ActivityHistory'
            };

            // create Account Activity Grid
            $("#jqxAccountActivityGrid").jqxGrid(
            {

                pageable: true,
                pagermode: 'simple',
                pagesize: 12,
                width: '100%',
                height: 500,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                columnsresize: true,
                columns: [
                      { text: 'Member Id', datafield: 'MemberId', hidden: true },
                      { text: 'ParkingTransactionNumber', datafield: 'ParkingTransactionNumber', width: '20%' },
                      { text: 'ManualEditsId', datafield: 'ManualEditsId', hidden: true },
                      { text: 'RedemptionId', datafield: 'RedemptionId', hidden: true },
                      { text: 'Points Changed', datafield: 'PointsChanged', width: '10%' },
                      { text: 'Description', datafield: 'Description', width: '50%' },
                      { text: 'Location', datafield: 'LocationId', width: '10%', cellsrenderer: locatioinCellsrenderer },
                      { text: 'Date', datafield: 'Date', width: '10%', cellsrenderer: DateRender }
                ]
            });
        }

        function loadSearchResults(thisParameters) {
            

            var parent = $("#jqxSearchGrid").parent();
            $("#jqxSearchGrid").jqxGrid('destroy');
            $("<div id='jqxSearchGrid'></div>").appendTo(parent);

            //Loads SearchList from parameters

            //var url = $("#apiDomain").val() + "members/search?" + thisParameters;
            var url = $("#localApiDomain").val() + "members/search";
            //var url = "http://localhost:52839/api/members/search";

            if ($("#SearchFPNumber").val() != '') {
                var thisFPNumber = $("#SearchFPNumber").val();

                thisFPNumber = thisFPNumber.replace(/\D/g, '');

                thisFPNumber = padNumber(thisFPNumber, 8, "0");
            } else {
                thisFPNumber = "";
            }

            if ($("#SearchFirstName").val() == "") {
               
            }

            var data = { "FPNumber": thisFPNumber, "FirstName": $("#SearchFirstName").val(), "LastName": $("#SearchLastName").val(), "EmailAddress": $("#SearchEmail").val(), "HomePhone": $("#SearchPhoneNumber").val(), "Company": $("#SearchCompany").val(), "MailerCompany": $("#MailerCompanySearchCombo").jqxInput('val').value, "MarketingCode": $("#SearchMailerCode").val(), "UserName": $("#SearchUserName").val() };

            var source =
            {
                datafields: [
                    { name: 'FirstName' },
                    { name: 'LastName' },
                    { name: 'FPNumber' },
                    { name: 'Company' },
                    { name: 'EmailAddress' },
                    { name: 'Home' },
                    { name: 'UserName' },
                    { name: 'CompanyId' },
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
                //pageable: true,
                //pagermode: 'advanced',
                //pagesize: 50,
                //pagesizeoptions: ['10', '20', '50', '100'],
                width: '100%',
                height: 500,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                columnsresize: true,
                enablebrowserselection: true,
                ready: function ()
                {
                    loadCompaniesCombo();
                    //var datainformations = $("#jqxSearchGrid").jqxGrid("getdatainformation");
                    //var rowscounts = datainformations.rowscount;
                    //swal(rowscounts);
                    //if (rowscounts = 1) {
                    //    var dataRecord = $("#jqxSearchGrid").jqxGrid('getrowdata', 0);
                    //    findMember(dataRecord.MemberId);
                    //    $("#jqxSearchGrid").toggle();
                    //    $("#MemberDetails").toggle();
                    //}
                },
                columns: [
                      {
                          text: 'Select', pinned: true, datafield: 'Select', width: 50, columntype: 'button', cellsrenderer: function () {
                              return "Select";
                          }, buttonclick: function (row) {
                              $('#jqxLoader').jqxLoader('open');
                              editrow = row;

                              var dataRecord = $("#jqxSearchGrid").jqxGrid('getrowdata', editrow);
                              
                              findMember(dataRecord.MemberId);
                              $("#jqxSearchGrid").toggle();
                              $("#MemberDetails").toggle();

                          }
                      },
                      { text: 'First Name', datafield: 'FirstName', width: '10%' },
                      { text: 'Last Name', datafield: 'LastName', width: '12%' },
                      { text: 'Primary Card', datafield: 'FPNumber', width: '8%' },
                      { text: 'Company', datafield: 'Company', width: '14%' },
                      { text: 'Email', datafield: 'EmailAddress', width: '18%' },
                      { text: 'Home', datafield: 'Home', width: '10%' },
                      { text: 'UserName', datafield: 'UserName', width: '10%' },
                      { text: 'CompanyId', datafield: 'CompanyId', width: '7%' },
                      { text: 'MemberId', datafield: 'MemberId', width: '8%'},
                ]
            });

           
        }

        function loadNotes(PageMemberID) {
            //Loads card list
            var parent = $("#jqxNotesGrid").parent();
            $("#jqxNotesGrid").jqxGrid('destroy');
            $("<div id='jqxNotesGrid'></div>").appendTo(parent);

            var url = $("#localApiDomain").val() + "MemberNotes/NotesByMemberId/" + PageMemberID;
            //var url = "http://localhost:52839/api/MemberNotes/NotesByMemberId/" + PageMemberID;

            var source =
            {
                datafields: [
                    { name: 'Date' },
                    { name: 'Note' },
                    { name: 'SubmittedBy' }
                ],

                id: 'NotesId',
                type: 'Get',
                datatype: "json",
                url: url
            };

            // create jqxNotesGrid
            $("#jqxNotesGrid").jqxGrid(
            {
                theme: 'shinyblack',
                width: '100%',
                height: 140,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                enabletooltips: true,
                columns: [
                      { text: 'Date', datafield: 'Date', width: '20%', cellsrenderer: DateRender },
                      { text: 'Note', datafield: 'Note', width: '60%' },
                      { text: 'SubmittedBy', datafield: 'SubmittedBy', width: '20%' }
                ]
            });



            // defines redemption grid double click
            $("#jqxNotesGrid").bind('rowdoubleclick', function (event) {
                var row = event.args.rowindex;
                var dataRecord = $("#jqxNotesGrid").jqxGrid('getrowdata', row);

                $("#popupNote").css('display', 'block');
                $("#popupNote").css('visibility', 'hidden');

                var offset = $("#jqxMemberInfoTabs").offset();
                $("#popupNote").jqxWindow({ position: { x: '25%', y: '30%' } });
                $('#popupNote').jqxWindow({ resizable: false });
                $('#popupNote').jqxWindow({ draggable: true });
                $('#popupNote').jqxWindow({ isModal: true });
                $("#popupNote").css("visibility", "visible");
                $('#popupNote').jqxWindow({ height: '195px', width: '50%' });
                $('#popupNote').jqxWindow({ minHeight: '195px', minWidth: '50%' });
                $('#popupNote').jqxWindow({ maxHeight: '500px', maxWidth: '50%' });
                $('#popupNote').jqxWindow({ showCloseButton: true });
                $('#popupNote').jqxWindow({ animationType: 'combined' });
                $('#popupNote').jqxWindow({ showAnimationDuration: 300 });
                $('#popupNote').jqxWindow({ closeAnimationDuration: 500 });
                $("#popupNote").jqxWindow('open');

                $("#txtNote").val(dataRecord.Note);
                $("#saveNote").css("visibility", "hidden");
            });
        }

        function loadModified(PageMemberID) {
            //Loads card list
            var parent = $("#jqxModifiedGrid").parent();
            $("#jqxModifiedGrid").jqxGrid('destroy');
            $("<div id='jqxModifiedGrid'></div>").appendTo(parent);

            var url = $("#localApiDomain").val() + "Audits/GetAudits/" + PageMemberID;
            //var url = "http://localhost:52839/api/Audits/GetAudits/" + PageMemberID;

            var source =
            {
                datafields: [
                    { name: 'MemberId' },
                    { name: 'FirstName' },
                    { name: 'LastName' },
                    { name: 'DataChanged' },
                    { name: 'OldValue' },
                    { name: 'NewValue' },
                    { name: 'ChangeType' },
                    { name: 'changeUser' },
                    { name: 'changeDate' }
                ],

                type: 'Get',
                datatype: "json",
                url: url
            };

            // create jqxNotesGrid
            $("#jqxModifiedGrid").jqxGrid(
            {
                theme: 'shinyblack',
                width: '100%',
                height: 450,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                enabletooltips: true,
                columns: [
                      { text: 'MemberId', datafield: 'MemberId', hidden: true },
                      { text: 'FirstName', datafield: 'FirstName', width: '10%' },
                      { text: 'LastName', datafield: 'LastName', width: '10%' },
                      { text: 'DataChanged', datafield: 'DataChanged', width: '15%' },
                      { text: 'OldValue', datafield: 'OldValue', width: '15%' },
                      { text: 'NewValue', datafield: 'NewValue', width: '15%' },
                      { text: 'Who', datafield: 'ChangeType', width: '10%' },
                      { text: 'changeUser', datafield: 'changeUser', width: '10%' },
                      { text: 'changeDate', datafield: 'changeDate', width: '15%', cellsrenderer: DateTimeRender }
                ]
            });
        }

        function loadRedemptions(PageMemberID) {

            $("#jqxRedemptionGrid").jqxComboBox('clear');
            var parent = $("#jqxRedemptionGrid").parent();
            $("#jqxRedemptionGrid").jqxComboBox('destroy');
            $("<div id='jqxRedemptionGrid'></div>").appendTo(parent);

            var redemptionRenderer = function (row, columnfield, value, defaulthtml, columnproperties) {
                switch (value) {
                    case 0:
                        return '<div style="margin-top: 10px;margin-left: 5px">NO</div>';
                        break;
                    case 1:
                        return '<div style="margin-top: 10px;margin-left: 5px">YES</div>';
                        break;
                    case '0001-01-01T00:00:00':
                        return '<div style="margin-top: 10px;margin-left: 5px">&nbsp;</div>';
                        break;
                    default:
                        var thisDateTime = value;

                        if (thisDateTime != "") {
                            thisDateTime = thisDateTime.split("T");

                            var thisDate = thisDateTime[0].split("-");

                            var newDate = '<div style="margin-top: 10px;margin-left: 5px">' + thisDate[1] + "/" + thisDate[2] + "/" + thisDate[0] + '</div>';

                            return newDate;
                        } else {
                            return "";
                        }
                        break;
                }
            }

            //Loads redemptions
            //var url = $("#apiDomain").val() + "members/" + PageMemberID + "/redemptions";
            var url = $("#localApiDomain").val() + "Redemptions/GetMemberRedemption/" + PageMemberID;
            //var url = "http://localhost:52839/api/Redemptions/GetMemberRedemption/" + PageMemberID;

            var source =
            {
                datafields: [
                    { name: 'RedemptionId' },
                    { name: 'CertificateId' },
                    //{ name: 'RedemptionType', map: 'RedemptionType>RedemptionType' },
                    { name: 'RedemptionTypeName' },
                    { name: 'RedeemDate' },
                    { name: 'IsReturned' },
                    { name: 'BeenUsed' },
                    { name: 'DateUsed' },
                    { name: 'RedemptionSourceName' }
                ],

                id: 'RedemptionId',
                type: 'Get',
                datatype: "json",
                url: url,
                //beforeSend: function (jqXHR, settings) {
                //    jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
                //    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                //},
                root: "data"
            };

            // create Redemption Grid
            $("#jqxRedemptionGrid").jqxGrid(
            {
                //pageable: true,
                //pagermode: 'advanced',
                //pagesize: 50,
                //pagesizeoptions: ['10', '20', '50', '100'],
                width: '100%',
                height: 450,
                source: source,
                selectionmode: 'checkbox',
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                enablebrowserselection: true,
                columns: [
                      { text: 'RedemptionId', datafield: 'RedemptionId', hidden: true },
                      { text: 'CertificateId', datafield: 'CertificateId' },
                      { text: 'Redemption Type', datafield: 'RedemptionTypeName' },
                      { text: 'Redeem Date', datafield: 'RedeemDate', cellsrenderer: DateRender },
                      { text: 'Returned', datafield: 'IsReturned', cellsrenderer: redemptionRenderer },
                      { text: 'BeenUsed', datafield: 'BeenUsed', cellsrenderer: redemptionRenderer },
                      { text: 'DateUsed', datafield: 'DateUsed', cellsrenderer: redemptionRenderer },
                      { text: 'Source', datafield: 'RedemptionSourceName' }
                ]
            });

            // defines redemption grid double click
            $("#jqxRedemptionGrid").bind('rowdoubleclick', function (event) {
                var row = event.args.rowindex;
                var dataRecord = $("#jqxRedemptionGrid").jqxGrid('getrowdata', row);
                var thisRedemptionId = dataRecord.RedemptionId;
                var offset = $("#jqxMemberInfoTabs").offset();
                var toAddress = $("#EmailAddress").val();
                var thisMemberId = $("#MemberId").val();

                showRedemption(thisRedemptionId, toAddress, thisMemberId);
            });
        }

        function loadReservations(PageMemberID) {

            var parent = $("#jqxReservationGrid").parent();
            $("#jqxReservationGrid").jqxComboBox('destroy');
            $("<div id='jqxReservationGrid'></div>").appendTo(parent);

            // load reservations to list
            var url = $("#apiDomain").val() + "members/" + PageMemberID + "/reservations";

            var source =
            {
                datafields: [
                    { name: 'ReservationId' },
                    { name: 'ReservationNumber' },
                    { name: 'NameOfLocation', map: 'LocationInformation>NameOfLocation' },
                    { name: 'BrandName', map: 'LocationInformation>BrandInformation>BrandName' },
                    { name: 'CreateDatetime' },
                    { name: 'StartDatetime' },
                    { name: 'EndDatetime' },
                    { name: 'ReservationStatusName', map: 'ReservationStatus>ReservationStatusName' },
                    { name: 'MemberNote' }
                ],

                id: 'CertificateID',
                type: 'Get',
                datatype: "json",
                url: url,
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                root: "data"
            };

            // create Reservation Grid
            $("#jqxReservationGrid").jqxGrid(
            {
                //pageable: true,
                //pagermode: 'advanced',
                //pagesize: 50,
                //pagesizeoptions: ['10', '20', '50', '100'],
                width: '100%',
                height: 450,
                source: source,
                selectionmode: 'checkbox',
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                enablebrowserselection: true,
                columns: [
                      { text: 'ReservationId', datafield: 'ReservationId', hidden: true },
                      { text: 'Reservation Number', datafield: 'ReservationNumber', width: '10%' },
                      { text: 'Location', datafield: 'NameOfLocation', width: '10%' },
                      { text: 'Brand', datafield: 'BrandName', width: '5%' },
                      { text: 'Create Date', datafield: 'CreateDatetime', width: '13%', cellsrenderer: DateRender },
                      { text: 'Start Date', datafield: 'StartDatetime', width: '13%', cellsrenderer: DateRender },
                      { text: 'End Date', datafield: 'EndDatetime', width: '13%', cellsrenderer: DateRender },
                      { text: 'Status', datafield: 'ReservationStatusName', width: '9%' },
                      { text: 'Note', datafield: 'MemberNote', width: '24%' }
                ]
            });
        }

        function loadReferrals(PageMemberID) {

            var parent = $("#jqxReferralGrid").parent();
            $("#jqxReferralGrid").jqxComboBox('destroy');
            $("<div id='jqxReferralGrid'></div>").appendTo(parent);

            // load reservations to list
            var url = $("#apiDomain").val() + "members/" + PageMemberID + "/referrals";

            var source =
            {
                datafields: [
                    { name: 'Name' },
                    { name: 'ReferralType' },
                    { name: 'ReferralDate' },
                    { name: 'SignedDate' },
                    { name: 'ParkingDate' },
                    { name: 'PointsAwarded' }
                ],

                id: 'CertificateID',
                type: 'Get',
                datatype: "json",
                url: url,
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                root: "data"
            };

            // create Reservation Grid
            $("#jqxReferralGrid").jqxGrid(
            {
                width: '100%',
                height: 450,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                enablebrowserselection: true,
                columns: [
                      { text: 'Name', datafield: 'Name', width: '26%' },
                      { text: 'ReferralType', datafield: 'ReferralType', width: '10%' },
                      { text: 'ReferralDate', datafield: 'ReferralDate', width: '16%', cellsrenderer: DateRender },
                      { text: 'SignedDate', datafield: 'SignedDate', width: '16%', cellsrenderer: DateRender },
                      { text: 'ParkingDate', datafield: 'ParkingDate', width: '16%', cellsrenderer: DateRender },
                      { text: 'PointsAwarded', datafield: 'PointsAwarded', width: '16%' }
                ]
            });
        }

        //#endregion

        //#region LoadComboBoxes

        function loadStatus() {
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
        }

        function loadCompaniesCombo() {
            if (memberCompaniesLoaded == true) {
                return null;
            }

            ////set companies combobox
            //var companySource =
            //{
            //    datatype: "json",
            //    type: "Get",
            //    root: "data",
            //    datafields: [
            //        { name: 'id' },
            //        { name: 'name' }
            //    ],
            //    //url: $("#localApiDomain").val() + "CompanyDropDowns/GetCompanies/",
            //    url: "http://localhost:52839/api/CompanyDropDowns/GetCompanies/",

            //};
            //var companyDataAdapter = new $.jqx.dataAdapter(companySource);

            //$("#MailerCompanyCombo").jqxComboBox(
            //{
            //    width: '100%',
            //    height: 24,
            //    source: companyDataAdapter,
            //    selectedIndex: 0,
            //    displayMember: "name",
            //    valueMember: "id"
            //});


            //$("#MailerCompanyCombo").on('bindingComplete', function (event) {
            //    $("#MailerCompanyCombo").jqxComboBox('insertAt', '', 0);
            //    memberCompaniesLoaded = true;
            //});

            //********************************************************************

            // prepare the data
            var source = {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'id' },
                    { name: 'name' }
                ],
                url: $("#localApiDomain").val() + "CompanyDropDowns/GetCompanies/",
                //url: "http://localhost:52839/api/CompanyDropDowns/GetCompanies/",

            };
            var companies = new Array();
            var dataAdapter = new $.jqx.dataAdapter(source, {
                autoBind: true,
                loadComplete: function (data) {
                    for (var i = 0; i < data.length; i++) {
                        companies.push({
                            label: data[i].name,
                            value: data[i].id
                        });
                    };
                }
            });

            // Create a jqxInput
            $("#MailerCompanyCombo").jqxInput({
                placeHolder: "",
                displayMember: "name",
                valueMember: "id",
                width: '100%',
                height: 25,
                disabled:false,
                source: function (query, response) {
                    var item = query.split(/,\s*/).pop();
                    // update the search query.
                    $("#MailerCompanyCombo").jqxInput({
                        query: item
                    });
                    response(companies);
                },
                renderer: function (itemValue, inputValue) {
                    var terms = inputValue.split(/,\s*/);
                    // remove the current input
                    terms.pop();
                    // add the selected item
                    terms.push(itemValue);
                    // add placeholder to get the comma-and-space at the end
                    terms.push("");
                    var value = terms.join(" ");
                    return value;
                },

            });
            $("#MailerCompanyCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {
                        //swal("Value: " + item.value + ", " + "Label: " + item.label);
                        $("#MailerCompanyComboID").val(item.value);
                    }
                }
            });

        }

        function loadCompaniesSearchCombo() {
            if (searchCompaniesLoaded == true) {
                return null;
            }

            ////set companies combobox
            //var companySource =
            //{
            //    datatype: "json",
            //    type: "Get",
            //    root: "data",
            //    datafields: [
            //        { name: 'id' },
            //        { name: 'name' }
            //    ],
            //    //url: $("#localApiDomain").val() + "CompanyDropDowns/GetCompanies/",
            //    url: "http://localhost:52839/api/CompanyDropDowns/GetCompanies/",

            //};
            //var companyDataAdapter = new $.jqx.dataAdapter(companySource);

            //$("#MailerCompanySearchCombo").jqxComboBox(
            //{
            //    width: '100%',
            //    height: 24,
            //    source: companyDataAdapter,
            //    selectedIndex: 0,
            //    displayMember: "name",
            //    valueMember: "id"
            //});


            //$("#MailerCompanySearchCombo").on('bindingComplete', function (event) {
            //    $("#MailerCompanySearchCombo").jqxComboBox('insertAt', '', 0);
            //    $("#MailerCompanySearchCombo").jqxComboBox({ dropDownWidth: 300 });
            //    searchCompaniesLoaded = true
            //});

            //************************************************************************

            // prepare the data
            var source = {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'id' },
                    { name: 'name' }
                ],
                url: $("#localApiDomain").val() + "CompanyDropDowns/GetCompanies/",
                //url: "http://localhost:52839/api/CompanyDropDowns/GetCompanies/",

            };
            var companies = new Array();
            var dataAdapter = new $.jqx.dataAdapter(source, {
                autoBind: true,
                loadComplete: function (data) {
                    for (var i = 0; i < data.length; i++) {
                        companies.push({
                            label: data[i].name,
                            value: data[i].id
                        });
                    };
                }
            });

            // Create a jqxInput
            $("#MailerCompanySearchCombo").jqxInput({
                placeHolder: "Company:",
                displayMember: "name",
                valueMember: "id",
                width: 200,
                height: 25,
                source: function (query, response) {
                    var item = query.split(/,\s*/).pop();
                    // update the search query.
                    $("#MailerCompanySearchCombo").jqxInput({
                        query: item
                    });
                    response(companies);
                },
                renderer: function (itemValue, inputValue) {
                    var terms = inputValue.split(/,\s*/);
                    // remove the current input
                    terms.pop();
                    // add the selected item
                    terms.push(itemValue);
                    // add placeholder to get the comma-and-space at the end
                    terms.push("");
                    var value = terms.join(" ");
                    return value;
                }
            });

            //$('#getValueMember').jqxButton({
            //    template: 'warning'
            //}).click(function () {
            //    var valueMember = $("#stuName").jqxInput('val').value;
            //    swal(valueMember);
            //});

        }

        function loadRate() {
            $("#rateCombo").jqxComboBox('clearSelection');
            $("#rateCombo").jqxComboBox('clear');
            var parent = $("#rateCombo").parent();
            $("#rateCombo").jqxComboBox('destroy');
            $("<div id='rateCombo'></div>").appendTo(parent);

            
            //set rate combobox
            var rateSource =
            {
                async: true,
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'LocationId' },
                    { name: 'NameOfLocation' }
                ],
                url: $("#localApiDomain").val() + "Locations/Locations/",

            };
            var rateDataAdapter = new $.jqx.dataAdapter(rateSource);
            $('#rateCombo').jqxComboBox({
                selectedIndex: 0, source: rateDataAdapter, displayMember: "NameOfLocation", valueMember: "LocationId", height: 24, width: '100%',
                renderer: function (index, label, value) {
                    var rateObj = { rate: "0" };
                    rateObj = { rateCode: "0" };
                    rateObj = { locationList: "" };

                    getRate(rateObj, value);

                    var homeLocations = String(rateObj.locationList).split("_");
                    
                    if (homeLocations.indexOf(String(value)) > -1) {
                        var table = '<div style="color:black">' + label + ' - ' + rateObj.rateCode + ' - ' + rateObj.rate + ' **</div>';
                    } else {
                        var table = '<div style="color:black">' + label + ' - ' + rateObj.rateCode + ' - ' + rateObj.rate + '</div>';
                    }
    
                    return table;
                },
                renderSelectedItem: function (index, item) {
                    var rateObj = { rate: "0" };
                    rateObj = { rateCode: "0" };
                    rateObj = { locationList: "" };

                    getRate(rateObj, item.value);

                    var homeLocations = String(rateObj.locationList).split("_");

                    if (homeLocations.indexOf(String(item.value)) > -1) {
                        var table =  item.label + ' - ' + rateObj.rateCode + ' - ' + rateObj.rate + ' **';
                    } else {
                        var table = item.label + ' - ' + rateObj.rateCode + ' - ' + rateObj.rate
                    }

                    return table;
                }
            });

            $("#rateCombo").on('bindingComplete', function (event) {
                $("#rateCombo").jqxComboBox('selectItem', glbHomeLocationId);
            });

            
            $('#jqxLoader').jqxLoader('close');
        }

        function getRate(obj, thisLocationId) {
            //var thisCompanyId = $("#MailerCompanyCombo").jqxComboBox('getSelectedItem').value;
            var thisCompanyId = glbCompanyId;

            $.ajax({
                async: false,
                type: "POST",
                url: $("#localApiDomain").val() + "Rates/GetRateByLocationAndCompanyId/",
                //url: "http://localhost:52839/api/Rates/GetRateByLocationAndCompanyId/",

                data: { "CompanyId": thisCompanyId, "LocationId": thisLocationId },
                dataType: "json",
                success: function (thisData) {
                    var results = String(thisData).split(",")
                    obj.rate = results[0];
                    obj.rateCode = results[1];
                    obj.locationList = results[2];
                },
                error: function (request, status, error) {
                    swal(error);
                }
            });

        }

        function loadmanualEditTypesCombo() {
            //set manualedit type combobox
            var metSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'ExplanationID' },
                    { name: 'Explanation' }
                ],
                url: $("#localApiDomain").val() + "ManualEdits/GetManualEditTypes",

            };
            var metDataAdapter = new $.jqx.dataAdapter(metSource);
            $("#manualEditTypesCombo").jqxComboBox(
            {
                width: 200,
                height: 24,
                source: metDataAdapter,
                selectedIndex: 0,
                displayMember: "Explanation",
                valueMember: "ExplanationID"
            });
            $("#manualEditTypesCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {

                    }
                }
            });
        }

        function loadmanualEditTypesCombo() {
            //set manualedit type combobox
            var metSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'ExplanationID' },
                    { name: 'Explanation' }
                ],
                url: $("#localApiDomain").val() + "ManualEdits/GetManualEditTypes",

            };
            var metDataAdapter = new $.jqx.dataAdapter(metSource);
            $("#manualEditTypesCombo").jqxComboBox(
            {
                width: '100%',
                height: 24,
                source: metDataAdapter,
                selectedIndex: 0,
                displayMember: "Explanation",
                valueMember: "ExplanationID"
            });
            $("#manualEditTypesCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {

                    }
                }
            });
        }

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

        function loadTitle() {
            //set up the title combobox
            var titleSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'TitleName' },
                    { name: 'TitleId' }
                ],
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                url: $("#apiDomain").val() + "titles/",

            };
            var titleDataAdapter = new $.jqx.dataAdapter(titleSource);
            $("#titleCombo").jqxComboBox(
            {
                theme: 'shinyblack',
                width: '100%',
                height: 24,
                source: titleDataAdapter,
                selectedIndex: 0,
                displayMember: "TitleName",
                valueMember: "TitleId"
            });
            
        }

        function loadStateCombo() {
            //set up the state combobox
            var stateSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'StateName' },
                    { name: 'StateId' }
                ],
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                url: $("#apiDomain").val() + "States",

            };
            var stateDataAdapter = new $.jqx.dataAdapter(stateSource);
            $("#stateCombo").jqxComboBox(
            {
                theme: 'shinyblack',
                width: '100%',
                height: 24,
                source: stateDataAdapter,
                selectedIndex: 0,
                displayMember: "StateName",
                valueMember: "StateId"
            });
            $("#stateCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {

                    }
                }
            });
        }

        function loadHomeLocationCombo() {
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
            $("#homeLocationCombo").jqxComboBox(
            {
                width: '100%',
                height: 24,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });
            $("#homeLocationCombo").on('bindingComplete', function (event) {
                $("#homeLocationCombo").jqxComboBox('insertAt', 'Location', 0);
            });
        }

        function loadReceiptLocationCombo() {
            //set up the receipt find location combobox
            var locationSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'NameOfLocation' },
                    { name: 'LocationId' }
                ],
                url: $("#localApiDomain").val() + "Locations/LocationsAll/",

            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#receiptLocationCombo").jqxComboBox(
            {
                theme: 'shinyblack',
                width: '100%',
                height: 24,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });

            //set up the Receipt find 2 location combobox
            var locationSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'NameOfLocation' },
                    { name: 'LocationId' }
                ],
                url: $("#localApiDomain").val() + "Locations/LocationsAll/",

            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#receiptLocationCombo2").jqxComboBox(
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


        //#endregion

        //#region SaveFunctions

        function SaveMarketingCode() {

            if ($("#MarketingCode").val() == $("#OldMarketingCode").val()) {
                return null;
            }

            var thisMemberId = $("#MemberId").val();
            var thisMarketingcode = $("#MarketingCode").val();
            var thisOldMarketingCode = $("#OldMarketingCode").val();
            var thisChangeUser = $("#txtLoggedinUsername").val();

            var url = $("#localApiDomain").val() + "MarketingCodeSaves/SaveMarketingCode/";
            //var url = "http://localhost:52839/api/MarketingCodeSaves/SaveMarketingCode/";

            $.ajax({
                type: "POST",

                url: url,

                data: {
                    "MemberId": thisMemberId,
                    "MarketingCode": thisMarketingcode,
                    "OldMarketingCode": thisOldMarketingCode,
                    "ChangedBy": thisChangeUser,
                },
                dataType: "json",
                success: function (Response) {

                },
                error: function (request, status, error) {
                    swal(error);
                }
            });
        }

        function addCard() {
            var thisFPNumber = $("#addCardFPNumber").val();
            var thisIsPrimary = $("#addCardIsPrimary").is(':checked');
            var thisIsActive = $("#addCardIsActive").is(':checked');
            var thisCreateDigitalCard = $("#addCardCreateDigitalCard").is(':checked');
            var PageMemberID = $("#MemberId").val();

            $.ajax({
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": $("#userGuid").val(),
                    "ApplicationKey": $("#AK").val()
                },
                type: "POST",
                url: $("#apiDomain").val() + "members/" + PageMemberID + "/cards/",
                data: JSON.stringify({
                    "FPNumber": thisFPNumber,
                    "IsPrimary": thisIsPrimary,
                    "IsActive": true,
                    "CreateDigitalCard": thisCreateDigitalCard
                }),
                dataType: "json",
                success: function () {
                    swal("Card Added!");
                },
                error: function (request, status, error) {
                    swal(error + " - " + request.responseJSON);
                },
                complete: function () {
                    thisMemberId = $("#MemberId").val();
                    $('#jqxCardGrid').jqxGrid('clearselection');
                    $('#jqxCardGrid').jqxGrid('clear');
                    $("#addCardWindow").jqxWindow('hide');
                    loadCards(thisMemberId);
                }
            });
        }


        function saveNote() {
            Date.prototype.toMMDDYYYYString = function () { return isNaN(this) ? 'NaN' : [this.getMonth() > 8 ? this.getMonth() + 1 : '0' + (this.getMonth() + 1), this.getDate() > 9 ? this.getDate() : '0' + this.getDate(), this.getFullYear()].join('/') }
            var thisDate = new Date().toMMDDYYYYString();
            var memberId = Number($("#MemberId").val());
            var note = $("#txtNote").val();
            var submittedBy = $("#txtLoggedinUsername").val();

            note = note.replace("'", "''");

            var testURL = $("#localApiDomain").val() + "MemberNotes/AddNote/";

            $.ajax({
                type: "POST",
                url: $("#localApiDomain").val() + "MemberNotes/AddNote/",
                //url: "http://localhost:52839/api/MemberNotes/AddNote/",
                data: { "MemberId": memberId, "Note": note, "Date": thisDate, "SubmittedBy": submittedBy, "CreateDatetime": thisDate, "CreateUserId": -1, "UpdateDatetime": null, "UpdateUserId": null, "IsDeleted": 0, "CreateExternalUserData": null, "UpdateExternalUserData": null },
                dataType: "json",
                success: function () {
                    swal("Saved!");
                    loadNotes($("#MemberId").val());
                },
                error: function (request, status, error) {
                    swal(error);
                }
            });

            $("#txtNote").val('');
            $("#popupNote").jqxWindow('hide');
            
        }


        //#endregion

        //#region ShowPopups
        function newNote() {

            $("#popupNote").css('display', 'block');
            $("#popupNote").css('visibility', 'hidden');

            var offset = $("#jqxMemberInfoTabs").offset();
            $("#popupNote").jqxWindow({ position: { x: '25%', y: '30%' } });
            $('#popupNote').jqxWindow({ resizable: false });
            $('#popupNote').jqxWindow({ draggable: true });
            $('#popupNote').jqxWindow({ isModal: true });
            $("#popupNote").css("visibility", "visible");
            $('#popupNote').jqxWindow({ height: '195px', width: '50%' });
            $('#popupNote').jqxWindow({ minHeight: '195px', minWidth: '50%' });
            $('#popupNote').jqxWindow({ maxHeight: '500px', maxWidth: '50%' });
            $('#popupNote').jqxWindow({ showCloseButton: true });
            $('#popupNote').jqxWindow({ animationType: 'combined' });
            $('#popupNote').jqxWindow({ showAnimationDuration: 300 });
            $('#popupNote').jqxWindow({ closeAnimationDuration: 500 });
            $("#popupNote").jqxWindow('open');
        }
        //#endregion

        //#region Functions
        
        //Create New Redemption
        function CreateRedemption(thisRedemptionTypeId, thisRedemptionSourceId, NumberToRedeem) {

            var thisMemberId = $("#MemberId").val();
            var thisQrCodeString = "";
            var thisRedemptionId = "";
            var toAddress = $("#EmailAddress").val();

            $('#jqxLoader').jqxLoader('open');

            $.ajax({
                type: 'POST',
                url: $("#apiDomain").val() + "members/" + thisMemberId + "/redemptions",
                dataType: "json",
                data: JSON.stringify([{
                    "RedemptionTypeId": thisRedemptionTypeId,
                    "RedemptionSourceId": thisRedemptionSourceId,
                    "NumberToRedeem": NumberToRedeem
                }]),
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": $("#userGuid").val(),
                    "ApplicationKey": $("#AK").val()
                },
                success: function (thisData) {
                    thisRedemptionId = thisData.result.data[0].RedemptionId;
                    var toAddress = $("#EmailAddress").val();
                    var thisUser = $("#loginLabel").html();
                    PageMethods.logCertificate(thisUser, thisMemberId, NumberToRedeem, thisRedemptionTypeId);
                },
                error: function (request, status, error) {
                    swal(error + " - " + request.responseJSON);
                },
                complete: function () {
                    $("#topPointsBalance").html(loadPoints(AccountId, $("#topPointsBalance"))); 
                    $("#topPointsBalanceAccountBar").html(loadPoints(AccountId, $("#topPointsBalanceAccountBar")));
                    loadRedemptions(thisMemberId);
                    $('#jqxLoader').jqxLoader('close');
                    if (thisRedemptionId != "") {
                        //var result = confirm("A redemption has been sent to the member.  Do you want to view it?");
                        //if (result == true) {
                        //    showRedemption(thisRedemptionId, toAddress, thisMemberId);
                        //}
                        swal({
                            title: 'A redemption has been sent to the member.',
                            text: "Do you want to view it?",
                            type: 'question',
                            showCancelButton: true,
                            confirmButtonColor: '#3085d6',
                            cancelButtonColor: '#d33',
                            confirmButtonText: 'Yes, I want to see it!'
                        }).then(function () {
                            showRedemption(thisRedemptionId, toAddress, thisMemberId);
                        })
                    }
                }
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
                    swal(error + " - " + request.responseJSON);
                }
            });
        }



        //clear memberinfo
        function clearMemberInfo() {
            $('.tabMemberInfo').find('input:text').val('');
            $("#topPointsBalance").html("");
            $("#topPointsBalanceAccountBar").html("");
            $("#topMemberSince").html("");
            $("#topLastLogin").html
            $("#topName").html("");
            $("#phoneGrid").jqxGrid('clear');
            $("#jqxAccountActivityGrid").jqxGrid('clear');
            $("#jqxMemberActivityGrid").jqxGrid('clear'); 
            $("#jqxRedemptionGrid").jqxGrid('clear');
            $("#jqxReservationGrid").jqxGrid('clear');
            $("#jqxCardGrid").jqxGrid('clear');
            $("#titleCombo").jqxComboBox('selectItem', 0);
            $("#GetEmail").prop("checked", false);
            $("#TravelAlert").prop("checked", false);
            $("#EmailReceipts").prop("checked", false);
            $("#RedeemEmail").prop("checked", false);
            $("#ProfileUpdateEmail").prop("checked", false);
            $("#ReservationChangeEmail").prop("checked", false);
            $("#ReservationConfirmationEmail").prop("checked", false);
            $("#ReservationReminder").prop("checked", false);
            $("#reservationFeeCreditCombo").jqxComboBox("clear");
        }

        function findMember(PageMemberID) {
            //gets member by memberID
            $.ajax({
                type: 'GET',
                url: $("#apiDomain").val() + "members/" + PageMemberID,
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": $("#userGuid").val(),
                    "ApplicationKey": $("#AK").val()
                },
                success: function (thisData) {
                    var acctNum = thisData.result.data.AccountId;

                    //set global page variable
                    AccountId = acctNum;
                    
                    //gets tab count to clear all tabs if the member is found
                    var tabsCount = $("#jqxMemberTabs").jqxTabs('length');
                    //is member found
                    if (thisData.result.ResultCount > 0) {
                        //does member have account
                        if (thisData.result.data.AccountId > 0) {

                            for (var i = tabsCount - 1; i >= 0; i--) {
                                $("#jqxMemberTabs").jqxTabs('removeAt', i);
                            };
                            //loads members from account number
                            loadMemberList(acctNum, thisData.result.data.MemberId);
                        } else {
                            swal("Member has no account assigned!")
                        }
                    }
                },
                error: function (request, status, error) {
                    swal(error + " - " + request.responseJSON);
                }
            });
        }

        function loadMember(PageMemberID) {
            
            ////// setup reservation popup these are in Member/Scripts/MemberReservation.js
            loadReservationLocationCombo();
            loadReservationCalendars();
            loadReservationPaymentMethodId();
            
            
            clearMemberInfo();
            
            var thisURL = $("#apiDomain").val() + "members/" + PageMemberID;

            //load member Phone lit
            var MemberSource =
            {
                datatype: "json",
                type: "Get",
                root: "result>data>PhoneList",
                datafields: [
                    { name: 'PhoneTypeId' },
                    { name: 'Number' }
                ],
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                url: $("#apiDomain").val() + "members/" + PageMemberID,
            };
            var MemberDataAdapter = new $.jqx.dataAdapter(MemberSource);
            var cellsrenderer = function (row, columnfield, value, defaulthtml, columnproperties) {
                switch(value) {
                    case 1:
                        return 'Home';
                        break;
                    case 2:
                        return 'Work';
                        break;
                    case 3:
                        return 'Mobile';
                        break;
                    case 4:
                        return 'Fax';
                        break;
                    default:
                        return 'Pick';
                }
            }
            $("#phoneGrid").jqxGrid(
                {
                    width: '100%',
                    height: 168,
                    source: MemberDataAdapter,
                    rowsheight: 20,
                    selectionmode: 'singlerow',
                    editmode: 'selectedrow',
                    editable: false,
                    columns: [
                      {
                          text: 'Type', datafield: 'PhoneTypeId', width: 70, columntype: 'combobox',
                          createeditor: function (row, column, editor) {
                              // assign a new data source to the combobox.
                              var phoneTypeSource =
                                {
                                    datatype: "json",
                                    type: "Get",
                                    root: "data",
                                    datafields: [
                                        { name: 'PhoneTypeId' },
                                        { name: 'Description' }
                                    ],
                                    beforeSend: function (jqXHR, settings) {
                                        jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                                    },
                                    url: $("#apiDomain").val() + "phone-types/",
                                };
                              var phoneTypeAdapter = new $.jqx.dataAdapter(phoneTypeSource);
                              editor.jqxComboBox({
                                  autoDropDownHeight: true,
                                  source: phoneTypeAdapter,
                                  promptText: "Please Choose:",
                                  displayMember: "Description",
                                  valueMember: "PhoneTypeId"
                              });
                          },
                          initeditor: function (row, cellvalue, editor, celltext, cellwidth, cellheight) {
                              editor.jqxComboBox('selectItem', cellvalue);
                          },
                          // update the editor's value before saving it.
                          cellvaluechanging: function (row, column, columntype, oldvalue, newvalue) {
                              // return the old value, if the new value is empty.
                              if (newvalue == "") return oldvalue;
                          },
                          cellsrenderer: cellsrenderer
                      },
                      { text: 'Number', datafield: 'Number' }
                    ]
            });
            


            var locationId = 0;

            //Get member detail information
            var url = $("#apiDomain").val() + "members/" + PageMemberID;
            //var url = "http://localhost:52839/api/members/" + PageMemberID;

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
                    //Fill out member detail tab info

                    $("#topMemberSince").html(DateFormat(thisData.result.data.MemberSince));
                    if (thisData.result.data.Title != null) {
                        $("#Title").val(thisData.result.data.Title.TitleName);
                        $("#topName").html(thisData.result.data.Title.TitleName + " " + thisData.result.data.FirstName + " " + thisData.result.data.LastName)
                    }
                    else
                    {
                        $("#topName").html(thisData.result.data.FirstName + " " + thisData.result.data.LastName)
                    }

                    if (thisData.result.data.TitleId == null) {
                        $("#titleCombo").jqxComboBox('selectItem', 0);
                    } else {
                        $("#titleCombo").jqxComboBox('selectItem', thisData.result.data.TitleId);
                    }

                    $("#MemberId").val(thisData.result.data.MemberId);
                    $("#FirstName").val(thisData.result.data.FirstName);
                    $("#LastName").val(thisData.result.data.LastName);
                    $("#EmailAddress").val(thisData.result.data.EmailAddress);
                    $("#UserName").val(thisData.result.data.UserName);
                    $("#IsActive").prop( "checked", thisData.result.data.IsActive);
                    $("#StreetAddress").val(thisData.result.data.StreetAddress);
                    $("#StreetAddress2").val(thisData.result.data.StreetAddress2);
                    if (thisData.result.data.StateId == null) {
                        $("#stateCombo").jqxComboBox('selectItem', 0);
                    }
                    else
                    {
                        $("#stateCombo").jqxComboBox('selectItem', thisData.result.data.StateId);
                    }
                    $("#CityName").val(thisData.result.data.CityName);
                    $("#Zip").val(thisData.result.data.Zip);
                    $("#Company").val(thisData.result.data.Company);
                    $("#homeLocationCombo").jqxComboBox('selectItem', thisData.result.data.LocationId);
                    glbHomeLocationId = thisData.result.data.LocationId;
                    $("#MarketingCode").val(thisData.result.data.MarketingCode);
                    $("#OldMarketingCode").val(thisData.result.data.MarketingCode);
                    $("#MarketingMailerCode").val(thisData.result.data.MarketingMailerCode);

                    //if (thisData.result.data.CompanyId == null) {
                    //    $("#MailerCompanyCombo").jqxComboBox('selectItem', 0);
                    //}
                    //else
                    //{
                    //    $("#MailerCompanyCombo").jqxComboBox('selectItem', thisData.result.data.CompanyId);
                    //}
                    
                    getCompanyName(thisData.result.data.CompanyId, $("#MailerCompanyCombo"));

                    //$("#MailerCompanyCombo").val(thisCompanyName);
                    $("#MailerCompanyCombo").attr("data-value", thisData.result.data.CompanyId);
                    $("#MailerCompanyComboID").val(thisData.result.data.CompanyId);

                    glbCompanyId = thisData.result.data.CompanyId;
                    $("#statusCombo").jqxComboBox('selectItem', thisData.result.data.PreferredStatusName);
                    
                },
                error: function (request, status, error) {
                    swal(error + " - " + request.responseJSON);
                },
                complete: function () {

                    loadRedemptions(PageMemberID);
                    loadReservations(PageMemberID);
                    loadCards(PageMemberID);
                    loadNotes(PageMemberID);
                    loadEmailPrefs(PageMemberID);
                    loadMemberActivity(PageMemberID);
                    loadAccountActivity();
                    loadReferrals(PageMemberID);

                    $("#topPointsBalance").html(loadPoints(AccountId, $("#topPointsBalance")));
                    $("#topPointsBalanceAccountBar").html(loadPoints(AccountId, $("#topPointsBalanceAccountBar")));
                    //$("#topLocationAccountBar").html($("#homeLocationCombo").jqxComboBox('getSelectedItem').label);
                    loadRate();
                    
                }
            });
        }

        function GetSearchParameters() {
            var thisReturn = ""

            if ($("#SearchFirstName").val() != "") {
                thisReturn = thisReturn + "FirstName=" + $("#SearchFirstName").val();
            }
            if ($("#SearchLastName").val() != "") {
                if (thisReturn == "") {
                    thisReturn = thisReturn + "LastName=" + $("#SearchLastName").val();
                } else {
                    thisReturn = thisReturn + "&LastName=" + $("#SearchLastName").val();
                }
            }

            if ($("#SearchFPNumber").val() != '') {
                var thisFPNumber = $("#SearchFPNumber").val();

                thisFPNumber = thisFPNumber.replace(/\D/g, '');

                thisFPNumber = padNumber(thisFPNumber, 8, "0");

                if (thisReturn == "") {
                    thisReturn = thisReturn + "FPNumber=" + thisFPNumber;
                } else {
                    thisReturn = thisReturn + "&FPNumber=" + thisFPNumber;
                }
            }
            if ($("#SearchPhoneNumber").val() != "") {
                if (thisReturn == "") {
                    thisReturn = thisReturn + "PhoneNumber=" + $("#SearchPhoneNumber").val();
                } else {
                    thisReturn = thisReturn + "&PhoneNumber=" + $("#SearchPhoneNumber").val();
                }
            }
            if ($("#SearchUserName").val() != "") {
                if (thisReturn == "") {
                    thisReturn = thisReturn + "UserName=" + $("#SearchUserName").val();
                } else {
                    thisReturn = thisReturn + "&UserName=" + $("#SearchUserName").val();
                }
            }
            if ($("#SearchCompany").val() != "") {
                if (thisReturn == "") {
                    thisReturn = thisReturn + "Company=" + $("#SearchCompany").val();
                } else {
                    thisReturn = thisReturn + "&Company=" + $("#SearchCompany").val();
                }
            }
            if ($("#MailerCompanySearchCombo").val() != "") {
                if (thisReturn == "") {
                    thisReturn = thisReturn + "MailerCompany=" + $("#MailerCompanySearchCombo").jqxInput('val').value;
                } else {
                    thisReturn = thisReturn + "&MailerCompany=" + $("#MailerCompanySearchCombo").jqxInput('val').value;
                }
            }
            if ($("#SearchEmail").val() != "") {
                if (thisReturn == "") {
                    thisReturn = thisReturn + "EmailAddress=" + $("#SearchEmail").val();
                } else {
                    thisReturn = thisReturn + "&EmailAddress=" + $("#SearchEmail").val();
                }
            }
            if ($("#SearchMailerCode").val() != "") {
                if (thisReturn == "") {
                    thisReturn = thisReturn + "MarketingMailerCode=" + $("#SearchMailerCode").val();
                } else {
                    thisReturn = thisReturn + "&MarketingMailerCode=" + $("#SearchMailerCode").val();
                }
            }
            if ($("#SearchSteetAddress").val() != "") {
                if (thisReturn == "") {
                    thisReturn = thisReturn + "SteetAddress=" + $("#SearchSteetAddress").val();
                } else {
                    thisReturn = thisReturn + "&SteetAddress=" + $("#SearchSteetAddress").val();
                }
            }
            //if ($('#LocationCombo').jqxComboBox('getSelectedItem').label != "Pick a Location") {

            //    if (thisReturn == "") {
            //        thisReturn = thisReturn + "LocationId=" + $('#LocationCombo').jqxComboBox('getSelectedItem').value;
            //    } else {
            //        thisReturn = thisReturn + "&LocationId=" + $('#LocationCombo').jqxComboBox('getSelectedItem').value;
            //    }
            //}

            return thisReturn;
        }

        //#endregion
       
    </script>

    <div id="MemberSearch" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-9">
                            <div class="row search-size">
                                <div class="col-sm-15">
                                    <input type="text" id="SearchFPNumber" placeholder="Card Number" />
                                </div>
                                <div class="col-sm-15">
                                    <input type="text" id="SearchFirstName" placeholder="First Name" />
                                </div>
                                <div class="col-sm-15">
                                    <input type="text" id="SearchLastName" placeholder="Last Name"  />
                                </div>
                                <div class="col-sm-15">
                                    <input type="text" id="SearchEmail" placeholder="Email" />
                                </div>
                                <div class="col-sm-15">
                                    <input type="text" id="SearchSteetAddress" placeholder="Street Address" style="visibility:hidden" />
                                </div>
                            </div>
                            <div class="row search-size">
                                <div class="col-sm-15">
                                    <input type="text" id="SearchPhoneNumber" placeholder="Phone xxx-xxx-xxxx"  />
                                </div>
                                <div class="col-sm-15">
                                    <input type="text" id="SearchCompany" placeholder="Company" />
                                </div>
                                <div class="col-sm-15">
                                    <%--<div id="MailerCompanySearchCombo"></div>--%>
                                    <input type="text" id="MailerCompanySearchCombo" />
                                </div>
                                <div class="col-sm-15">
                                    <input type="text" id="SearchMailerCode" placeholder="Mailer Code"  />
                                </div>
                                <div class="col-sm-15">
                                    <input type="text" id="SearchUserName" placeholder="User Name"  />
                                </div>
                            </div>
                            <div class="row search-size">
                                <div class="col-sm-15">
                                    <div id="LocationCombo" style="visibility:hidden;"></div>
                                </div>
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                </div>
                                <div class="col-sm-15">
                                    <input type="button" id="btnSearch" value="Search" /> 
                                </div>
                                <div class="col-sm-15">
                                    <input type="button" id="btnClear" value="Clear" />
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="row search-size">
                                <div class="col-sm-8 col-sm-offset-4">
                                    <div class="row search-size">
                                        <div class="col-sm-12 market">
                                            <input type="button" id="btnMarketing" value="Marketing"  />
                                        </div>
                                    </div>
                                    <div class="row search-size">
                                        <div class="col-sm-12">
                                            <input type="button" id="btnImportStatus" value="Import Status" />
                                        </div>
                                    </div>
                                    <div class="row search-size">
                                        <div class="col-sm-12">
                                            <input type="button" id="btnFindTransaction" value="Find Transaction" style="display:none;" />
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
                <div id="jqxSearchGrid"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->

    <div class="container-fluid container-970">
        <div class="row ">
            <div class="col-sm-12">
                <div id="MemberDetails">
                    <div>
                        <div id="jqxMemberTabs">
                                
                            <ul>
                                <li>Account</li>
                                <div style="float:right;width:25%">
                                    <label id="pointsLabelAccountBar" class="strong">Points Balance:</label>
                                    <label id="topPointsBalanceAccountBar" class="strong font-red right-buffer-15"></label>
                                    <div class="collaspeButton dropup" id="collapseSearchBar">Search <span class="caret"></span></div>
                                </div>
                            </ul>
                            <div>
                                YO
                            </div>    
                        </div>
                        <%--Account Tab Content --%>
                        <div id="AccountTabContent">
                            <div id="jqxAccountTabs" class="tab-system">
                                <ul>
                                    <li>Activity</li>
                                    <li>Join/Split</li>
                                </ul>
                    
                                <div id="AccountActivity" class="tab-body">
                                    <div id="jqxAccountActivityGrid"></div>
                                </div>
                                <div id="JoinSplit" class="tab-body">

                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="jqxMemberInfoTabs" class="tab-system">
                        <ul>
                            <li>Member Info</li>
                            <li>Activity</li>
                            <li>Manual Edits</li>
                            <li>Redemptions</li>
                            <li>Reservations</li>
                            <li>Referrals</li>
                            <li>Cards</li>
                            <li>Archive</li>
                            <li>Modified</li>
                            <div style="float:right">
                                <label id="LocationLabelAccountBar" class="strong">Preferred Location:</label>
                                <label id="topLocationAccountBar" class="strong font-red right-buffer-15"></label>
                            </div>
                        </ul>
                        <div id="tabMemberInfo" class="tab-body tabMemberInfo">
                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="bottom-divider">
                                        <div>
                                            <Label id="topName" class="strong right-buffer-15"></Label>
                                            <label id="pointsLabel" class="strong">Points Balance:</label>
                                            <label id="topPointsBalance" class="strong font-red right-buffer-15"></label>
                                            <label id="lastLoginLabel" class="strong">Last Login:</label>
                                            <label id="topLastLogin" class="font-normal right-buffer-15"></label>
                                            <label id="memberSinceLabel" class="strong">Member Since:</label>
                                            <label id="topMemberSince" class="font-normal"></label>
                                            <div style="margin-left:50px;float:right;">
                                                <label id="statusLabel" class="strong" style="float:left">Member Status:</label>
                                                <div id="statusCombo" style="position:relative;margin-left:120px;"></div>
                                            </div>
                                        </div>
                                    
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-4">
                                    <div class="form-horizontal">
                                        <input id="MemberId" type="hidden"  />
                                        <div class="form-group">
                                            <label for="Title" class="col-sm-3 col-md-4 control-label">Title:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <div id="titleCombo"></div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="FirstName" class="col-sm-3 col-md-4 control-label">First Name:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <input type="text" class="form-control NoAsstMgr" id="FirstName" placeholder="">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="LastName" class="col-sm-3 col-md-4 control-label">Last Name:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <input type="text" class="form-control NoAsstMgr" id="LastName" placeholder="">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="EmailAddress" class="col-sm-3 col-md-4 control-label">Email:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <input type="text" class="form-control" id="EmailAddress" placeholder="">
                                                <div><input type="button" id="deleteEmail" value="Delete Email" class="editor" /></div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="homeLocationCombo" class="col-sm-3 col-md-4 control-label">Home:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <div id="homeLocationCombo"></div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="Company" class="col-sm-3 col-md-4 control-label">Company:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <input type="text" class="form-control" id="Company" placeholder="">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="Rate" class="col-sm-3 col-md-4 control-label">Rate:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <div id="rateCombo"></div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="AlwaysPrice" class="col-sm-3 col-md-4 control-label"></label>
                                            <div class="col-sm-9 col-md-8">
                                                
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="IsActive" class="col-sm-3 col-md-4 control-label">Active:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <div class="checkbox">
                                                    <label>
                                                        <input type="checkbox" class="form-control" id="IsActive" >
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                        
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <div class="form-horizontal">
                                        <div class="form-group">
                                            <label for="UserName" class="col-sm-3 col-md-4 control-label">UserName:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <input type="text" class="form-control" id="UserName" placeholder="">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="phoneGrid" class="col-sm-3 col-md-4 control-label">Phones:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <div id="phoneGrid"></div>
                                                <div><input type="button" id="addPhone" value="Add Phone" class="editor" /></div>
                                            </div>
                                            
                                        </div>
                                        <div class="form-group">
                                            <label for="RepCode" class="col-sm-3 col-md-4 control-label">Rep Code:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <input type="text" class="form-control RFR" id="MarketingCode" placeholder=""><input type="text" style="display:none" id="OldMarketingCode" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="MailerCo" class="col-sm-3 col-md-4 control-label">Mailer Company:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <%--<div id="MailerCompanyCombo" class="NoAsstMgr"></div>--%>
                                                <input type="text" id="MailerCompanyCombo" class="RFR MANAGER" />
                                                <input type="text" id="MailerCompanyComboID" style="display:none;" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="MailerCode" class="col-sm-3 col-md-4 control-label">Mailer Code:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <input type="text" class="form-control" id="MarketingMailerCode" placeholder="">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <div class="form-horizontal">
                                        <div class="form-group">
                                            <label for="AddressType" class="col-sm-3 col-md-4 control-label">Address Type:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <input type="text" class="form-control" id="AddressType" placeholder="">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="StreetAddress" class="col-sm-3 col-md-4 control-label">Address 1:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <input type="text" class="form-control" id="StreetAddress" placeholder="">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="StreetAddress2" class="col-sm-3 col-md-4 control-label">Address 2:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <input type="text" class="form-control" id="StreetAddress2" placeholder="">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="CityName" class="col-sm-3 col-md-4 control-label">City:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <input type="text" class="form-control" id="CityName" placeholder="">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="stateCombo" class="col-sm-3 col-md-4 control-label">State Id:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <div id="stateCombo"></div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="Zip" class="col-sm-3 col-md-4 control-label">Zip:</label>
                                            <div class="col-sm-9 col-md-8">
                                                <input type="text" class="form-control" id="Zip" placeholder="Zip Code">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="GetEmail" class="col-sm-4 col-md-4 control-label">Newsletters:</label>
                                            <div class="col-sm-2 col-md-2">
                                                <div class="checkbox">
                                                    <label>
                                                        <input type="checkbox" class="form-control communicationType " id="GetEmail" />
                                                    </label>
                                                </div>
                                            </div>
                                            <label for="TravelAlert" class="col-sm-4 col-md-4 control-label">Travel Alert:</label>
                                            <div class="col-sm-2 col-md-2">
                                                <div class="checkbox">
                                                    <label>
                                                        <input type="checkbox" class="form-control communicationType" id="TravelAlert"  />
                                                    </label>
                                                </div>
                                            </div>
                                            <label for="EmailReceipts" class="col-sm-4 col-md-4 control-label">E-Receipts:</label>
                                            <div class="col-sm-2 col-md-2">
                                                <div class="checkbox">
                                                    <label>
                                                        <input type="checkbox" class="form-control communicationType" id="EmailReceipts"  />
                                                    </label>
                                                </div>
                                            </div>
                                            <label for="RedeemEmail" class="col-sm-4 col-md-4 control-label">Redeem Email:</label>
                                            <div class="col-sm-2 col-md-2">
                                                <div class="checkbox">
                                                    <label>
                                                        <input type="checkbox" class="form-control communicationType RFR MANAGER" id="RedeemEmail"  />
                                                    </label>
                                                </div>
                                            </div>
                                            <label for="ProfileUpdateEmail" class="col-sm-4 col-md-4 control-label">Profile Update:</label>
                                            <div class="col-sm-2 col-md-2">
                                                <div class="checkbox">
                                                    <label>
                                                        <input type="checkbox" class="form-control communicationType RFR MANAGER" id="ProfileUpdateEmail"  />
                                                    </label>
                                                </div>
                                            </div>
                                            <label for="ReservationChangeEmail" class="col-sm-4 col-md-4 control-label">Reservation Changes:</label>
                                            <div class="col-sm-2 col-md-2">
                                                <div class="checkbox">
                                                    <label>
                                                        <input type="checkbox" class="form-control communicationType" id="ReservationChangeEmail"  />
                                                    </label>
                                                </div>
                                            </div>
                                            <label for="ReservationConfirmationEmail" class="col-sm-4 col-md-4 control-label">Reservation Confirm:</label>
                                            <div class="col-sm-2 col-md-2">
                                                <div class="checkbox">
                                                    <label>
                                                        <input type="checkbox" class="form-control communicationType" id="ReservationConfirmationEmail"  />
                                                    </label>
                                                </div>
                                            </div>
                                            <label for="ReservationReminder" class="col-sm-4 col-md-4 control-label">Reservation Remind:</label>
                                            <div class="col-sm-2 col-md-2">
                                                <div class="checkbox">
                                                    <label>
                                                        <input type="checkbox" class="form-control communicationType" id="ReservationReminder"  />
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-8">
                                    <div class="section-content-header-controls">
                                        <label class="control-label">Notes:</label>
                                        <input id="addNote" value="Add Note" type="button" style="float:right" class="editor" />
                                        <div id="jqxNotesGrid"></div>
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <input type="button" id="SendNewPassword" value="Send New Password" />
                                        </div>
                                        <div class="col-sm-12">
                                            <input type="button" id="SendLoginInstructions" value="Send Login Instructions" style="display:none;" />
                                        </div>
                                        <div class="col-sm-6">
                                            <input type="button" id="DisplayQA" value="Display Q &amp; A" class="editor" />
                                        </div>
                                        <div class="col-sm-6">
                                            <input type="button" id="editMember" value="Edit" class="editor" style="display:block;" />
                                        </div>
                                        <div class="col-sm-12">
                                            <input type="button" id="updateMemberInfo" value="Save Member Info" />
                                        </div>
                                    </div>
                                </div>
                            </div>



                            <div id="content-box5">

                            </div>
                        </div>
                        <div id="tabActivity" class="tab-body">
                            <div id="jqxMemberActivityGrid"></div>
                        </div>
                        <div id="tabManualEdits" class="tab-nested-body">
                            <div id="jqxManualEditTabs">
                                <ul>
                                    <li>Receipt Entry</li>
                                    <li>Points</li>
                                    <li>Coupons</li>
                                </ul>
                                <div id="tabReceiptEntry" class="tab-body">
                                    <div class="row">
                                        <div class="col-sm-6 col-md-5" id="ReceiptEntry">
                                            <div class="form-horizontal">
                                                <div class="form-group">
                                                    <label class="col-sm-3 col-md-4 control-label">Type:</label>
                                                    <div class="col-sm-9 col-md-8">
                                                        <div id='jqxRadioTypeReceipt'>
                                                            Receipt
                                                        </div>
                                                        <div id='jqxRadioTypeColumn'>
                                                            Column
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="receiptLocationCombo" class="col-sm-3 col-md-4 control-label">Visit Location:</label>
                                                    <div class="col-sm-9 col-md-8">
                                                        <div id="receiptLocationCombo"></div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="jqxReceiptEntryCalendar" class="col-sm-3 col-md-4 control-label">Entry Date:</label>
                                                    <div class="col-sm-9 col-md-8">
                                                        <div id="jqxReceiptEntryCalendar"></div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="receiptNumber" class="col-sm-3 col-md-4 control-label">Number:</label>
                                                    <div class="col-sm-9 col-md-8">
                                                        <input type="text" id="receiptNumber" />
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col-sm-3 col-md-4 control-label"></label>
                                                    <div class="col-sm-9 col-md-8">
                                                        <input type ="button" value="Submit Receipt" id="submitReceipt1" class="editor" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-6 col-md-5" id="ReceiptEntryDetail">
                                            <div class="form-horizontal">
                                                <div class="form-group">
                                                    <label class="col-sm-3 col-md-4 control-label">Type:</label>
                                                    <div class="col-sm-9 col-md-8">
                                                        <div id='jqxRadioTypeNormal'>
                                                            Normal
                                                        </div>
                                                        <div id='jqxRadioTypeLost'>
                                                            Lost
                                                        </div>
                                                        <div id='jqxRadioTypeDamaged'>
                                                            Damaged
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="receiptLocationCombo" class="col-sm-3 col-md-4 control-label">Visit Location:</label>
                                                    <div class="col-sm-9 col-md-8">
                                                        <div id="receiptLocationCombo2"></div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="jqxReceiptEntryCalendar" class="col-sm-3 col-md-4 control-label">Entry Date:</label>
                                                    <div class="col-sm-9 col-md-8">
                                                        <div id="jqxReceiptDetailEntryCalendar"></div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="jqxReceiptEntryCalendar" class="col-sm-3 col-md-4 control-label">Exit Date:</label>
                                                    <div class="col-sm-9 col-md-8">
                                                        <div id="jqxReceiptDetailExitCalendar"></div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="receiptNumber" class="col-sm-3 col-md-4 control-label">Amount Paid:</label>
                                                    <div class="col-sm-9 col-md-8">
                                                        <input type="text" id="ReceiptDetailAmountPaid" />
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col-sm-3 col-md-4 control-label"></label>
                                                    <div class="col-sm-9 col-md-8">
                                                        <input type ="button" value="Submit Receipt" id="submitReceipt2" class="editor" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-0 col-md-2">
                                        </div>
                                    </div>
                                </div>
                                <div id="tabPoints" class="tab-body">
                                    <div class="row">
                                        <div class="col-sm-6 col-md-5">
                                            <div class="form-horizontal">
                                                <div class="form-group">
                                                    <label for="manualEditTypesCombo" class="col-sm-3 col-md-4 control-label">Edit Type:</label>
                                                    <div class="col-sm-9 col-md-8">
                                                        <div id="manualEditTypesCombo"></div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="manualEditPoints" class="col-sm-3 col-md-4 control-label">Points:</label>
                                                    <div class="col-sm-9 col-md-8">
                                                        <input type="text" id="manualEditPoints" />
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col-sm-3 col-md-4 control-label"></label>
                                                    <div class="col-sm-9 col-md-8">
                                                        <input type="button" value="Submit Manual Edit" id="manualEditSubmit" class="editor" />
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col-sm-3 col-md-4 control-label"></label>
                                                    <div class="col-sm-9 col-md-8">
                                                        <input type="button" value="View Pending Manual Edits" id="manualEditPending" class="editor" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-6 col-md-5">
                                            <div class="form-horizontal">
                                                <div class="form-group">
                                                    <label for="manualEditNote" class="col-sm-3 col-md-4 control-label">Add Note:</label>
                                                    <div class="col-sm-9 col-md-8">
                                                        <textarea rows="8" id="manualEditNote"></textarea>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-0 col-md-2">
                                        </div>
                                    </div>
                                </div>

                                <div id="tabCoupons" class="tab-body">
                                </div>
                            </div>
                        </div>
                        <div id="tabRedemptions" class="tab-body">
                            <div class="row">
                                <div class="col-sm-9 col-md-10">
                                    <div id="jqxRedemptionGrid"></div>
                                </div>
                                <div class="col-sm-3 col-md-2">
                                    <input type="button" id="returnRedemption" value="Return Redemption" class="editor" />
                                    <input type="button" id="markUsedRedemption" value="Mark Used" class="editor" />
                                    <input type="button" id="1DayRedemption" value="1 Day" class="editor" />
                                    <input type="button" id="3DayRedemption" value="3 Day" class="editor" />
                                    <input type="button" id="1WeekRedemption" value="1 Week" class="editor" />
                                </div>
                            </div>
                        </div>
                        <div id="tabReservations" class="tab-body">
                            <div class="row">
                                <div class="col-sm-9 col-md-10">
                                    <div id="jqxReservationGrid"></div>
                                </div>
                                <div class="col-sm-3 col-md-2">
                                    <input type="button" id="addReservation" value="Add Reservation" class="editor" />
                                    <input type="button" id="cancelReservation" value="Cancel Reservation" class="editor" />
                                </div>
                            </div>
                        </div>
                        <div id="tabReferrals" class="tab-body">
                            <div class="row">
                                <div class="col-sm-12 col-md-12">
                                    <div id="jqxReferralGrid"></div>
                                </div>
                            </div>
                        </div>
                        <div id="tabCards" class="tab-body">
                            <div class="row">
                                <div class="col-sm-9 col-md-10">
                                    <div id="jqxCardGrid"></div>
                                </div>
                                <div class="col-sm-3 col-md-2">
                                <input type="button" id="transferCard" value="Transfer" class="editor" style="display:none;" />
                                <input type="button" id="deleteCard" value="Delete" class="editor" />
                                <input type="button" id="UnDeleteCard" value="UnDelete" class="editor" />
                                <input type="button" id="addCard" value="Add" class="editor" />
                                <input type="button" id="setCardPrimary" value="Set as Primary" class="editor" />
                                <input type="button" id="combineMemberCards" value="Combine Member Cards" class="RFR" />
                                </div>
                            </div>
                        </div>
                        <div id="tabArchive" class="tab-body">
                            <div class="row">
                                <div class="col-sm-9 col-md-10">
                                    <div id="jqxArchiveGrid"></div>
                                </div>
                                <div class="col-sm-3 col-md-2">
                                <input type="button" id="btnArchiveSearch" value="Search" class="editor" />
                                </div>
                            </div>
                        </div>
                        <div id="tabModified" class="tab-body">
                            <div class="col-sm-12 col-md-12">
                                <div id="jqxModifiedGrid"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div><!-- /.container-fluid -->




    
    <div id="jqxLoader"></div>

    <%-- html for popup Note box --%>
    <div id="popupNote" style="display:none">
        <div>Add Note</div>
        <div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-12">
                        <textarea rows="4" cols="50" id="txtNote"></textarea>
                    </div>
                    <div class="col-sm-6">
                        <input id="saveNote" type="button" value="Save" />
                    </div>
                    <div class="col-sm-6">
                        <input id="cancelNote" type="button" value="Cancel" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- html for popup Add Card --%>
    <div id="addCardWindow" style="display:none">
        <div>Card Details</div>
        <div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="addCardFPNumber" class="col-sm-3 col-md-4 control-label">FP Number:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="addCardFPNumber" placeholder="FPNumber" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="addCardIsPrimary" class="col-sm-3 col-md-4 control-label">Is Primary:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" class="form-control" id="addCardIsPrimary" />
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <%--<div class="form-group">
                                <label for="addCardIsActive" class="col-sm-3 col-md-4 control-label">Is Active:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" class="form-control" id="addCardIsActive" />
                                        </label>
                                    </div>
                                </div>
                            </div>--%>
                            <div class="form-group">
                                <label for="addCardCreateDigitalCard" class="col-sm-3 col-md-4 control-label">Create Digital:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" class="form-control" id="addCardCreateDigitalCard" />
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="top-divider">
                            <div class="col-sm-6">
                                <input type="button" class="form-control" id="cancelCardSubmit" value="Cancel" />
                            </div>
                            <div class="col-sm-6">
                                <input type="button" class="form-control" id="addCardSubmit" value="Add" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <%-- html for popup Add Reservation --%>
    <div id="popupReservation" class="popupReservation" style="display:none">
        <div>Reservation Details
        </div>
        <div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-12">
                        
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="reservationLocationCombo" class="col-sm-2 col-md-3 control-label">Location:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div id="reservationLocationCombo"></div><input id="airportId" style="display:none;" />
                                </div>
                                <div class="col-sm-1 col-md-1"></div>
                            </div>
                            <div class="form-group">
                                <label for="reservationStartDate" class="col-sm-2 col-md-3 control-label">Start Date:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div id="reservationStartDate"></div>
                                </div>
                                <div class="col-sm-1 col-md-1"></div>
                            </div>
                            <div class="form-group">
                                <label for="reservationEndDate" class="col-sm-2 col-md-3 control-label">End Date:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div id="reservationEndDate"></div>
                                </div>
                                <div class="col-sm-1 col-md-1"></div>
                            </div>
                            <div class="form-group">
                                <label for="reservationFeeIdCombo" class="col-sm-3 col-md-3 control-label">Fee in $:</label>
                                <div class="col-sm-3 col-md-3">
                                    <input id="reservationFeeInput" /><input id="reservationFeeInputValue" style="display:none;" />
                                </div>
                                <label for="reservationFeePoints" class="col-sm-2 col-md-2 control-label">Fee in Points:</label>
                                <div class="col-sm-3 col-md-3">
                                    <input type="text" id="reservationFeePointsInput" />
                                </div>
                                <div class="col-sm-1 col-md-1"></div>
                            </div>
                            <%--<div class="form-group">
                                <label for="reservationFeePoints" class="col-sm-2 col-md-3 control-label">Fee in Points:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" id="" />
                                </div>
                                <div class="col-sm-1 col-md-1"></div>
                            </div>--%>
                            <div class="form-group">
                                <label for="reservationFeatures" class="col-sm-2 col-md-3 control-label">Features:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div id="reservationFeatures"></div>
                                </div>
                                <div class="col-sm-1 col-md-1"></div>
                            </div>
                            <div class="form-group">
                                <label for="reservationPaymentMethodId" class="col-sm-2 col-md-3 control-label">Payment Method:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div id="reservationPaymentMethodId"></div>
                                </div>
                                <div class="col-sm-1 col-md-1"></div>
                            </div>
                            <div class="form-group">
                                <label for="reservationFeeCreditCombo" class="col-sm-2 col-md-3 control-label">Credits:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div id="reservationFeeCreditCombo"></div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="reservationFeeDiscountIdGrid" class="col-sm-2 col-md-3 control-label">Discounts:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div id="reservationFeeDiscountIdDDB">
                                        <div id="reservationFeeDiscountIdGrid"></div>
                                    </div>
                                    <div class="col-sm-1 col-md-1"></div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="EstimatedReservationCost" class="col-sm-2 col-md-3 control-label">Est. Cost:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" id="EstimatedReservationCost" placeholder="Estimated Reservation Cost" /><input type="button" id="getEstCost" value="Get Cost" />
                                </div>
                                <div class="col-sm-1 col-md-1"></div>
                            </div>
                            <div class="form-group">
                                <label for="ReservationNote" class="col-sm-2 col-md-3 control-label">Notes:</label>
                                <div class="col-sm-9 col-md-8">
                                    <textarea id="ReservationNote" rows="4"></textarea>
                                </div>
                                <div class="col-sm-1 col-md-1"></div>
                            </div>
                            <div class="form-group">
                                <label for="reservationTermsAndConditionsFlag" class="col-sm-3 col-md-3 control-label">Terms:</label>
                                <div class="col-sm-2 col-md-2">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" class="form-control" id="reservationTermsAndConditionsFlag" checked />
                                        </label>
                                    </div>
                                </div>
                                <label for="SendNotificationsFlag" class="col-sm-3 col-md-3 control-label">Send Notification:</label>
                                <div class="col-sm-3 col-md-3">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" class="form-control" id="SendNotificationsFlag" checked />
                                        </label>
                                    </div>
                                </div>
                                <div class="col-sm-1 col-md-1"></div>
                            </div>
                            <%--<div class="form-group">
                                <label for="SendNotificationsFlag" class="col-sm-2 col-md-3 control-label">Send Notification:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" class="form-control" id="SendNotificationsFlag" />
                                        </label>
                                    </div>
                                </div>
                                <div class="col-sm-1 col-md-1"></div>
                            </div>--%>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="top-divider">
                            <div class="col-sm-2 col-md-3">
                            </div>
                            <div class="col-sm-4 col-md-3">
                                <input type="button" id="saveReservation" value="Save" />
                            </div>
                            <div class="col-sm-4 col-md-3">
                                <input type="button" id="cancelReservationForm" value="Cancel" />
                            </div>
                            <div class="col-sm-2 col-md-3">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <!--Not Used right now.  this popup would display a jquery created QRCode-->
    <%-- html for popup QA box --%>
    <div id="popupDisplayQA" style="display:none">
        <div>Questions &amp; Answers</div>
        <div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-12">
                        <div id="jqxDisplayQAGrid"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>



    <div id='phoneContextMenu' style="display: none">
        <ul>
            <li>Delete Selected Row</li>
        </ul>
    </div>

    <div id="popupReceipt" style="display:none;overflow:hidden;">
        <div>Reciept Details</div>
        <div style="margin-left:30px;margin-top:20px;overflow:hidden;">
            <iframe id="receiptIframe" style="border:none;width:240px;height:465px;" ></iframe>
        </div>
    </div>

    <div id="popupRedemption" style="display: none;">
        <div>Redemption Details</div>
        <div style="margin-left:20px;margin-top:10px;overflow:hidden;">
            <iframe id="redemptionIframe" style="border:none;width:450px;height:700px;" ></iframe>
        </div>
    </div>

    <%-- html for combine cards --%>
    <div id="popupCombineMembers" class="popupCombineMembers" style="display:none;border:1px solid black;">
        <div style="background-color:#ccc;width:100%;border-radius:9px 9px 0px 0px;font-weight:bold;text-align:center">Combine Members</div>
        <div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-12">
                        
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="combineMemberTransferFrom" class="col-sm-3 col-md-4 control-label">Transfer from:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" id="orginMember"  />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="combineMemberTransferTo" class="col-sm-3 col-md-4 control-label">Transfer to:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" id="targetMember" />
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
                                <input type="button" id="saveCombineMember" value="Save" />
                            </div>
                            <div class="col-sm-4 col-md-3">
                                <input type="button" id="cancelCombineMember" value="Cancel" />
                            </div>
                            <div class="col-sm-2 col-md-3">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- html for popup view manual edit --%>
    <div id="popupViewManualEdit" style="display:none">
        <div>Manual Edit Notes</div>
        <div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-12">
                        <textarea id="ManualEditNote" cols="50" rows="10"></textarea>  
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

