<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceClaim.aspx.cs" Inherits="InsuranceClaim" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <link rel="stylesheet" href="jqwidgets/styles/jqx.base.css" type="text/css" />
    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>

    <script type="text/javascript" src="jqwidgets/globalization/globalize.js"></script>

    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.edit.js"></script>    
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
    <script type="text/javascript" src="jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>    
    <script type="text/javascript" src="jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdata.export.js"></script> 
    <script type="text/javascript" src="jqwidgets/jqxgrid.export.js"></script>

    <script>
        var group = '<%= Session["groupList"] %>';
        var noteNumber = 0;
        var payableNumber = 0;
        var receivableNumber = 0;
        var PaidByInsuranceCount = 0;
        var PaidByThridPartyInsuranceCount = 0;
        var PCADeductibleCount = 0;
        var PCAOutOfPocketCount = 0;
        var EmployeePaidCount = 0;
        var MonthlyAllocationCount = 0;
        var ReserveCount = 0;

        $(document).ready(function () {

            //************************* Currency Mask **************************************
            $("#Main").delegate('.MoneyFormat', 'blur', function (e) {

                var Globals = Object.keys(window);

                for (var i = 600; i <= Globals.length - 1 ; i++) {
                    if (Globals[i].match(/.*Count/)) {
                        var thisVariable = Globals[i].match(/.*Count/)
                        eval(thisVariable + " = 0");
                    }
                }
                
            })

            $("#Main").delegate('.MoneyFormat', 'keydown', function (e) {
                var KeyID = e.keyCode;

                if (document.activeElement.classList.contains('MoneyFormat')) {
                    switch (KeyID) {
                        case 8:
                            $("#" + document.activeElement.id).val('');
                            $("#" + document.activeElement.id).focus();
                            var thisElementName = document.activeElement.id.toString();
                            eval(thisElementName + "Count = 0");
                            break;
                        default:
                            break;
                    }
                }
            });

            $("#Main").delegate('.MoneyFormat', 'input', function (e) {
                $(this).val(parseFloat($(this).val()).toFixed(2));

                if (e.originalEvent.target.value.includes('..')) {
                    e.originalEvent.target.value.replace('..', '.');
                }

                var thisElementName = document.activeElement.id.toString();
                var thisCursorCount = eval(thisElementName + "Count = " + thisElementName + "Count + 1");

                setCursorPosition(this, thisCursorCount);

                var TotalClaimAmount = AddPaidByAmounts();

                $("#TotalClaim").val(TotalClaimAmount);
                $("#TotalClaim").val(parseFloat($(TotalClaim).val()).toFixed(2));

                var TotalPayableAmount = AddPayableAmounts();

                $("#TotalPayables").val(TotalPayableAmount);
                $("#TotalPayables").val(parseFloat($(TotalPayables).val()).toFixed(2));

                $("#PCAPayables").val(TotalPayableAmount);
                $("#PCAPayables").val(parseFloat($(PCAPayables).val()).toFixed(2));

                var TotalReceivableAmount = AddReceivableAmounts();

                $("#TotalReceivables").val(TotalReceivableAmount);
                $("#TotalReceivables").val(parseFloat($(TotalReceivables).val()).toFixed(2));
                $("#TotalReceivables").val('(' + $("#TotalReceivables").val() + ')');

               
                var TotalExpense = 0;

                TotalExpense = parseFloat(TotalPayableAmount) - parseFloat(TotalReceivableAmount);
                $("#TotalExpenseToPCA").val(TotalExpense.toFixed(2));
                $("#PCAActualExpense").val(TotalExpense.toFixed(2));
                
            });

            $(".MoneyFormat").keypress(function (e) {
                var keyCode = e.which;

                if ((keyCode != 8 || keyCode == 32 || keyCode == 46) && ((keyCode < 48 && keyCode != 46) || keyCode > 57)) {
                    return false;
                }
            });

            $("#Main").delegate('.MoneyFormat', 'dblclick', function (e) {
                $(this).val(parseFloat($(this).val()).toFixed(2));
                
                var TotalClaimNumber = AddPaidByAmounts();

                $("#TotalClaim").val(TotalClaimNumber);
                $("#TotalClaim").val(parseFloat($(TotalClaim).val()).toFixed(2));

                var TotalPayableAmount = AddPayableAmounts();

                $("#TotalPayables").val(TotalPayableAmount);
                $("#TotalPayables").val(parseFloat($(TotalPayables).val()).toFixed(2));

                $("#PCAPayables").val(TotalPayableAmount);
                $("#PCAPayables").val(parseFloat($(PCAPayables).val()).toFixed(2));

                var TotalReceivableAmount = AddReceivableAmounts();

                $("#TotalReceivables").val(TotalReceivableAmount);
                $("#TotalReceivables").val(parseFloat($(TotalReceivables).val()).toFixed(2));
                $("#TotalReceivables").val('(' + $("#TotalReceivables").val() + ')');

                var TotalExpense = 0;

                TotalExpense = parseFloat(TotalPayableAmount) - parseFloat(TotalReceivableAmount);
                $("#TotalExpenseToPCA").val(TotalExpense.toFixed(2));
                $("#PCAActualExpense").val(TotalExpense.toFixed(2));
            });

            function setCursorPosition(ctrl, pos) {
                // Modern browsers
                if (ctrl.setSelectionRange) {
                    ctrl.focus();
                    ctrl.setSelectionRange(pos, pos);

                    // IE8 and below
                } else if (ctrl.createTextRange) {
                    var range = ctrl.createTextRange();
                    range.collapse(true);
                    range.moveEnd('character', pos);
                    range.moveStart('character', pos);
                    range.select();
                }
            }

            // ************************* end currency mask *****************************************************

            $("#saveSubmit").on("click", function () {
                SaveClaim();
            });

            $("#addNote").on('click', function (e) {
                addClaimNote();
            });

            $("#addPayable").on('click', function (e) {
                addClaimPayable();
            });

            $("#addReceivable").on('click', function (e) {
                addClaimReceivable();
            });

            loadLocations();
            
            const params = new URLSearchParams(window.location.search);
            const ClaimID = params.get("ClaimID");
            $("#ClaimID").val(ClaimID);

            LoadClaimInfo(ClaimID);
        });

        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++  Start Claim Section +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        
        function LoadClaimInfo(ClaimID) {
            //var url = "http://localhost:52839/api/InsuranceClaims/GetClaimByID/" + ClaimID;
            var url = $("#localApiDomain").val() + "InsuranceClaims/GetClaimByID/" + ClaimID;

            var ClaimantName = "";
            var ClaimantNameID = 0;
            var EmployeeInvolvedClaimID = 0;
            var EmployeeInvolvedName = "";

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    ClaimantName = data[0].ClaimantName;
                    ClaimantNameID = data[0].ClaimantNameClaimID;
                    EmployeeInvolvedClaimID = data[0].EmployeeInvolvedClaimID;
                    EmployeeInvolvedName = data[0].DriverName;

                    $("#IncidentID").val(data[0].IncidentID);

                    $.when(loadClaimType().then(function (thisData) {
                        $("#claimType").val(data[0].ClaimTypeID);
                    }).fail(function (error) {
                        alert("error " + error);
                    })
                    );

                    $.when(loadPolicyType().then(function (thisData) {
                        $("#PolicyType").val(data[0].PolicyTypeID);
                    }).fail(function (error) {
                        alert("error " + error);
                    })
                    );

                    $("#IncidentClaimNumber").val(data[0].ClaimNumber);

                    $.when(loadClaimStatus().then(function (thisData) {
                        $("#claimStatus").val(data[0].ClaimStatusID);
                    }).fail(function (error) {
                        alert("error " + error);
                    })
                    );


                    $("#ClaimStatusDate").val(DateFormatForHTML5(data[0].ClaimStatusDate));
                    $("#PCAVehicleNumber").val(data[0].VehicleNumber);
                    $("#PaidByInsurance").val(data[0].PaidByInsurance).trigger('dblclick');
                    $("#PaidByThridPartyInsurance").val(data[0].PaidByThridPartyInsurance).trigger('dblclick');
                    $("#PCADeductible").val(data[0].PCADeductible).trigger('dblclick');
                    $("#PCAOutOfPocket").val(data[0].PCAOutOfPocket).trigger('dblclick');
                    $("#EmployeePaid").val(data[0].EmployeePaid).trigger('dblclick');
                    $("#IncidentDate").val(DateFormatForHTML5(data[0].IncidentDate));
                    $("#location").val(data[0].IncidentLocationName);
                    $("#RepFollowUpDate").val(DateFormatForHTML5(data[0].RepFollowUpDate));
                    $("#PCAInsuranceClaimNumber").val(data[0].PCAInsuranceClaimNumber);
                    $("#OtherInsuranceClaimNumber").val(data[0].OtherInsuranceClaimNumber);
                    $("#PoliceReportNumber").val(data[0].PoliceReportNumber);
                    $("#PCAReceiveDate").val(DateFormat(data[0].PCAReceiveDate));

                    $.when(loadPCARep().then(function (thisData) {
                        $("#PCARepAssigned").val(data[0].PCARepID);
                    }).fail(function (error) {
                        alert("error " + error);
                    })

                    );

                    $("#MonthlyAllocation").val(data[0].MonthlyAllocation).trigger('dblclick');
                    $("#Reserve").val(data[0].Reserve).trigger('dblclick');

                    $.when(loadPendingClaimStatus().then(function (thisData) {
                        $("#pendingClaimStatus").val(data[0].PendingStatusID);
                    }).fail(function (error) {
                        alert("error " + error);
                    })
                    );

                    $("#Closed").val(data[0].Closed);
                },
                error: function (request, status, error) {
                    swal("There was an issue getting claim information.");
                }
            }).then(function () {
                loadEmployeeInvolved(EmployeeInvolvedName, EmployeeInvolvedClaimID);
                loadThirdPartyEnvolved(ClaimantName, ClaimantNameID);
                loadClaimNote();
                loadClaimPayable();
                loadClaimReceivable();
            });
        }

        function SaveClaim() {

            var url = $("#localApiDomain").val() + "InsuranceClaims/PutInsuranceClaim/";
            //var url = "http://localhost:52839/api/InsuranceClaims/PutInsuranceClaim/";


            $.ajax({
                type: "POST",
                url: url,
                data: {
                    "ClaimTypeID": $("#claimType").val(),
                    "PolicyTypeID": $("#PolicyType").val(),
                    "IncidentClaimNumber": $("#IncidentClaimNumber").val(),
                    "ClaimStatusID": $("#claimStatus").val(),
                    "ClaimStatusDate": $("#ClaimStatusDate").val(),
                    "PCAVehicleNumber": $("#PCAVehicleNumber").val(),
                    "PaidByInsurance": $("#PaidByInsurance").val(),
                    "PaidByThridPartyInsurance": $("#PaidByThridPartyInsurance").val(),
                    "PCADeductible": $("#PCADeductible").val(),
                    "PCAOutOfPocket": $("#PCAOutOfPocket").val(),
                    "EmployeePaid": $("#EmployeePaid").val(),
                    "IncidentDate": $("#IncidentDate").val(),
                    "location": $("#location").val(),
                    "RepFollowUpDate": $("#RepFollowUpDate").val(),
                    "PCARepID": $("#PCARepAssigned").val(),
                    "ClaimantNameClaimID": $("#ClaimantName").val(),
                    "ClaimantName": $('#ClaimantName').find(":selected").text(),
                    "MonthlyAllocation": $("#MonthlyAllocation").val(),
                    "Reserve": $("#Reserve").val(),
                    "ClaimID": $("#ClaimID").val(),
                    "PendingStatusID": $('#pendingClaimStatus').val(),
                    "PCAInsuranceClaimNumber": $("#PCAInsuranceClaimNumber").val(),
                    "OtherInsuranceClaimNumber": $("#OtherInsuranceClaimNumber").val(),
                    "EmployeeInvolvedName": $('#EmployeeInvolvedClaimID').find(":selected").text(),
                    "EmployeeInvolvedClaimID": $("#EmployeeInvolvedClaimID").val(),
                    "Closed": $("#Closed").val()

                },
                dataType: "json",
                success: function (data) {

                },
                error: function (request, status, error) {
                    swal("Error saving Claim Info");
                }
            }).then(function () {
                SaveClaimNotes();
                SaveClaimPayable();
                SaveClaimReceivable();
                swal("Saved");
            });
        }

        function AddPaidByAmounts() {
            var PaidByInsuranceAmount = 0;
            var PaidByThridPartyInsuranceAmount = 0;
            var PCADeductibleAmount = 0;
            var PCAOutOfPocketAmount = 0;
            var EmployeePaidAmount = 0;


            if ($("#PaidByInsurance").val() != '') {
                PaidByInsuranceAmount = parseFloat($("#PaidByInsurance").val());
            }

            if ($("#PaidByThridPartyInsurance").val() != '') {
                PaidByThridPartyInsuranceAmount = parseFloat($("#PaidByThridPartyInsurance").val());
            }

            if ($("#PCADeductible").val() != '') {
                PCADeductibleAmount = parseFloat($("#PCADeductible").val());
            }

            if ($("#PCAOutOfPocket").val() != '') {
                PCAOutOfPocketAmount = parseFloat($("#PCAOutOfPocket").val());
            }

            if ($("#EmployeePaid").val() != '') {
                EmployeePaidAmount = parseFloat($("#EmployeePaid").val());
            }

            var TotalClaimNumber = parseFloat(PaidByInsuranceAmount + PaidByThridPartyInsuranceAmount + PCADeductibleAmount + PCAOutOfPocketAmount + EmployeePaidAmount);

            return TotalClaimNumber;
        }

        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++End Claim Section +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


        // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Start Note Section +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        function SaveClaimNotes() {
            for (var i = 1; i <= noteNumber; i++) {

                if ($("#NoteIDClaimNote" + i.toString()).val() == '') {

                    var url = $("#localApiDomain").val() + "InsuranceClaims/PostClaimNote/";
                    //var url = "http://localhost:52839/api/InsuranceClaims/PostClaimNote/";

                    $.ajax({
                        type: "POST",
                        url: url,
                        data: {
                            "ClaimID": $("#ClaimID").val(),
                            "ClaimNoteContent": $("#noteClaimNote" + i.toString()).val(),
                            "ClaimNoteEnteredBy": $("#EnteredByClaimNote" + i.toString()).val(),
                            "ClaimNoteDate": $("#DateClaimNote" + i.toString()).val()
                        },
                        dataType: "json",
                        success: function (data) {

                        },
                        error: function (request, status, error) {
                            swal("Error saving note " + i);
                        }
                    }).then(function () {
                        
                    });;
                }
            }
        }

        function loadClaimNote() {
            var ClaimID = $("#ClaimID").val();

            //var url = "http://localhost:52839/api/InsuranceClaims/GetClaimNote/" + ClaimID;
            var url = $("#localApiDomain").val() + "InsuranceClaims/GetClaimNote/" + ClaimID;

            return $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        addClaimNote(data[i].ClaimNoteID, data[i].ClaimNoteContent, data[i].ClaimNoteEnteredBy, data[i].ClaimNoteDate);
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting claim notes.");
                }
            }).then(function () {
                
            });
        }

        function addClaimNote(NoteIDClaimNote, ClaimNoteContent, ClaimNoteEnteredBy, ClaimNoteDate) {
            noteNumber = noteNumber + 1;

            NoteInfoBuild = claimNote;
            NoteInfoBuild = NoteInfoBuild.replace(/ClaimNote1/g, 'ClaimNote' + (noteNumber).toString());
            NoteInfoBuild = NoteInfoBuild.replace('NOTE 1', 'NOTE ' + (noteNumber).toString());
            var insertAt = "#ClaimNote" + (noteNumber - 1).toString();
            if (noteNumber == 1) {
                $('#topTable').after(NoteInfoBuild);
            } else {
                $(insertAt).after(NoteInfoBuild);
            }
            var thisFocus = "#noteClaimNote" + (noteNumber).toString();
            $(thisFocus).focus();

            if (NoteIDClaimNote === undefined) {
                var enteredBy = "#EnteredByClaimNote" + (noteNumber).toString();
                $(enteredBy).val($("#txtLoggedinUsername").val());
                var thisDate = "#DateClaimNote" + (noteNumber).toString();
                $(thisDate).val(DateTimeFormat(new Date()));
            } else {
                var enteredBy = "#EnteredByClaimNote" + (noteNumber).toString();
                $(enteredBy).val(ClaimNoteEnteredBy);
                var thisDate = "#DateClaimNote" + (noteNumber).toString();
                $(thisDate).val(DateTimeFormat(ClaimNoteDate));
                var thisContent = "#noteClaimNote" + (noteNumber).toString();
                $(thisContent).val((ClaimNoteContent));
                var ClaimNoteID = "#NoteIDClaimNote" + (noteNumber).toString();
                $(ClaimNoteID).val(NoteIDClaimNote);
            }
            
        }

        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++End Note Section +++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Start Payable Section ++++++++++++++++++++++++++++++++++++++++++++++++++++

        function loadClaimPayable() {
            var ClaimID = $("#ClaimID").val();

            //var url = "http://localhost:52839/api/InsuranceClaims/GetClaimPayable/" + ClaimID;
            var url = $("#localApiDomain").val() + "InsuranceClaims/GetClaimPayable/" + ClaimID;

            return $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        addClaimPayable(data[i].ClaimPayableID, data[i].ClaimPayablePayee, data[i].ClaimPayableCheckNumber, data[i].ClaimPayableCheckAmount, data[i].ClaimPayableMailedDate);
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting claim notes.");
                }
            }).then(function () {

            });
        }


        function addClaimPayable(ClaimPayableID, ClaimPayablePayee, ClaimPayableCheckNumber, ClaimPayableCheckAmount, ClaimPayableMailedDate) {
            payableNumber = payableNumber + 1;

            payableInfoBuild = payable;
            payableInfoBuild = payableInfoBuild.replace(/Payable1/g, 'Payable' + (payableNumber).toString());
            var insertAt = "#Payable" + (payableNumber - 1).toString();
            if (payableNumber == 1) {
                $('#payableTable').after(payableInfoBuild);
            } else {
                $(insertAt).after(payableInfoBuild);
            }

            eval("window.CheckAmountPayable" + payableNumber + "Count = 0");

            if (ClaimPayableID === undefined) {
                
            } else {
                var ClaimPayableID = "#ClaimPayableIDPayable" + (payableNumber).toString();
                $(ClaimPayableID).val(ClaimPayableID);
                var PayorPayeePayable = "#PayorPayeePayable" + (payableNumber).toString();
                $(PayorPayeePayable).val(ClaimPayablePayee);
                var CheckAmountPayable = "#CheckAmountPayable" + (payableNumber).toString();
                $(CheckAmountPayable).val((ClaimPayableCheckAmount)).trigger('dblclick');
                var CheckNumberPayable = "#CheckNumberPayable" + (payableNumber).toString();
                $(CheckNumberPayable).val(ClaimPayableCheckNumber);
                var MailDatePayable = "#MailDatePayable" + (payableNumber).toString();
                $(MailDatePayable).val(DateFormat(ClaimPayableMailedDate));
            }
        }

        
        function SaveClaimPayable() {
            for (var i = 1; i <= payableNumber; i++) {

                if ($("#ClaimPayableIDPayable" + i.toString()).val() == '' && $("#PayorPayeePayable" + i.toString()).val() != '') {

                    var url = $("#localApiDomain").val() + "InsuranceClaims/PostPayable/";
                    //var url = "http://localhost:52839/api/InsuranceClaims/PostPayable/";

                    $.ajax({
                        type: "POST",
                        url: url,
                        data: {
                            "ClaimID": $("#ClaimID").val(),
                            "ClaimPayablePayee": $("#PayorPayeePayable" + i.toString()).val(),
                            "CheckNumberPayable": $("#EnteredByClaimNote" + i.toString()).val(),
                            "ClaimPayableCheckNumber": $("#CheckNumberPayable" + i.toString()).val(),
                            "ClaimPayableCheckAmount": $("#CheckAmountPayable" + i.toString()).val(),
                            "ClaimPayableMailedDate": $("#MailDatePayable" + i.toString()).val()
                        },
                        dataType: "json",
                        success: function (data) {

                        },
                        error: function (request, status, error) {
                            swal("Error saving payable " + i);
                        }
                    }).then(function () {

                    });;
                }
            }
        }

        function AddPayableAmounts() {
            var TotalPayables = 0;

            for (var i = 1; i <= payableNumber; i++) {

                if ($("#CheckAmountPayable" + i.toString()).val() != '') {
                    TotalPayables = parseFloat(TotalPayables) + parseFloat($("#CheckAmountPayable" + i.toString()).val());
                }
            }

            return TotalPayables;
        }
        
        //+++++++++++++++++++++++++++++++++++++++++++  End Payable Section ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        //++++++++++++++++++++++++++++++++++++++++++++ Start Receivable Section ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        function loadClaimReceivable() {
            var ClaimID = $("#ClaimID").val();

            //var url = "http://localhost:52839/api/InsuranceClaims/GetClaimReceivable/" + ClaimID;
            var url = $("#localApiDomain").val() + "InsuranceClaims/GetClaimReceivable/" + ClaimID;

            return $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        addClaimReceivable(data[i].ClaimReceivableID, data[i].ClaimReceivablePayor, data[i].ClaimReceivableCheckNumber, data[i].ClaimReceivableCheckAmount);
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting claim notes.");
                }
            }).then(function () {

            });
        }

        function addClaimReceivable(ClaimReceivableID, ClaimReceivablePayor, ClaimReceivableCheckNumber, ClaimReceivableCheckAmount) {
            receivableNumber = receivableNumber + 1;

            receivableInfoBuild = receivable;
            receivableInfoBuild = receivableInfoBuild.replace(/Receivable1/g, 'Receivable' + (receivableNumber).toString());
            var insertAt = "#Receivable" + (receivableNumber - 1).toString();
            if (receivableNumber == 1) {
                $('#receivableTable').after(receivableInfoBuild);
            } else {
                $(insertAt).after(receivableInfoBuild);
            }

            eval("window.CheckAmountReceivable" + receivableNumber + "Count = 0");

            if (ClaimReceivableID === undefined) {

            } else {
                var ClaimReceivableIDReceivable = "#ClaimReceivableIDReceivable" + (receivableNumber).toString();
                $(ClaimReceivableIDReceivable).val(ClaimReceivableID);
                var PayorReceivable = "#PayorReceivable" + (receivableNumber).toString();
                $(PayorReceivable).val(ClaimReceivablePayor);
                var CheckNumberReceivable = "#CheckNumberReceivable" + (receivableNumber).toString();
                $(CheckNumberReceivable).val(ClaimReceivableCheckNumber);
                var CheckAmountReceivable = "#CheckAmountReceivable" + (receivableNumber).toString();
                $(CheckAmountReceivable).val((ClaimReceivableCheckAmount)).trigger('dblclick');
            }
        }

        function SaveClaimReceivable() {
            for (var i = 1; i <= receivableNumber; i++) {

                if ($("#ClaimReceivableIDReceivable" + i.toString()).val() == '' && $("#PayorReceivable" + i.toString()).val() != '') {

                    var url = $("#localApiDomain").val() + "InsuranceClaims/PostReceivable/";
                    //var url = "http://localhost:52839/api/InsuranceClaims/PostReceivable/";

                    $.ajax({
                        type: "POST",
                        url: url,
                        data: {
                            "ClaimID": $("#ClaimID").val(),
                            "ClaimReceivablePayor": $("#PayorReceivable" + i.toString()).val(),
                            "ClaimReceivableCheckNumber": $("#CheckNumberReceivable" + i.toString()).val(),
                            "ClaimReceivableCheckAmount": $("#CheckAmountReceivable" + i.toString()).val()
                        },
                        dataType: "json",
                        success: function (data) {

                        },
                        error: function (request, status, error) {
                            swal("Error saving receivable " + i);
                        }
                    }).then(function () {

                    });;
                }
            }
        }

        function AddReceivableAmounts() {
            var TotalReceivables = 0;
           
            for (var i = 1; i <= receivableNumber; i++) {

                if ($("#CheckAmountReceivable" + i.toString()).val() != '') {
                    TotalReceivables = parseFloat(TotalReceivables) + parseFloat($("#CheckAmountReceivable" + i.toString()).val());
                } 
            }

            return TotalReceivables;
        }


        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ End Receivable Section ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        function loadEmployeeInvolved(EmployeeInvolvedName, EmployeeInvolvedClaimID) {
            var dropdown = $('#EmployeeInvolvedClaimID');

            dropdown.empty();

            dropdown.append('<option value="0">Pick Employee</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/InsuranceClaims/GetEmployeeInvolved/" + $("#IncidentID").val();
            var url = $("#localApiDomain").val() + "InsuranceClaims/GetEmployeeInvolved/" + $("#IncidentID").val();

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append($("<option style='font-weight: bold;'></option>").prop("value", data[i].ClaimID).text(data[i].DriverName));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting envolved employee information.");
                },
                complete: function () {
                    
                }
            }).then(function () {
                if (EmployeeInvolvedClaimID == null || EmployeeInvolvedClaimID === undefined || EmployeeInvolvedClaimID == "0") {
                    if (EmployeeInvolvedName != "") {
                        $("#EmployeeInvolvedClaimID option:contains(" + EmployeeInvolvedName + ")").attr('selected', 'selected').trigger('change');
                    }
                } else {
                    $("#EmployeeInvolvedClaimID").val(EmployeeInvolvedClaimID).trigger('change');
                }
            });

            $('#EmployeeInvolvedClaimID').on('change', function () {
                //var url = "http://localhost:52839/api/InsuranceClaims/GetPCAInvolvedVehicleNumber/" + $("#EmployeeInvolvedClaimID").val();
                var url = $("#localApiDomain").val() + "InsuranceClaims/GetPCAInvolvedVehicleNumber/" + $("#EmployeeInvolvedClaimID").val();

                $.ajax({
                    type: "GET",
                    url: url,
                    dataType: "json",
                    beforeSend: function (jqXHR, settings) {
                    },
                    success: function (data) {
                        $("#PCAVehicleNumber").val(data);
                    },
                    error: function (request, status, error) {
                        swal("There was an issue getting PCA involved VehicleNumber.");
                    }
                })
            });
        }

        function loadThirdPartyEnvolved(ClaimantName, ClaimantNameID) {
            var dropdown = $('#ClaimantName');

            dropdown.empty();

            dropdown.append('<option value="0">Pick Claimant</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/InsuranceClaims/GetThirdPartyEnvolved/" + $("#IncidentID").val();
            var url = $("#localApiDomain").val() + "InsuranceClaims/GetThirdPartyEnvolved/" + $("#IncidentID").val();

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append($("<option style='font-weight: bold;'></option>").prop("value", data[i].ClaimID).text(data[i].ClaimantName));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting envolved employee information.");
                }
            }).then(function () {
                if (ClaimantNameID == null || ClaimantNameID === undefined || ClaimantNameID == "0") {
                    if (ClaimantName != "") {
                        $("#ClaimantName option:contains(" + ClaimantName + ")").prop('selected', 'selected');
                    }
                } else {
                    $("#ClaimantName").val(ClaimantNameID);
                }
            });
        }

        function loadLocations() {
            var locationString = $("#userVehicleLocation").val();
            var dropdown = $('#location');

            dropdown.empty();

            dropdown.append('<option selected="true">Location</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/InsuranceLocations/GetUserLocations/" + locationString;
            var url = $("#localApiDomain").val() + "InsuranceLocations/GetUserLocations/" + locationString;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append("<option value='" + data[i].LocationID + "' style='font-weight: bold;'>" + data[i].LocationName + "</option>");
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting location information.");
                }
            });
        }

        function loadClaimType() {
            var dropdown = $('#claimType');

            dropdown.empty();

            dropdown.append('<option value="0">Claim Type</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/InsuranceClaims/GetClaimTypes/";
            var url = $("#localApiDomain").val() + "InsuranceClaims/GetClaimTypes/";

            return $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append($("<option style='font-weight: bold;'></option>").prop("value", data[i].ClaimTypeID).text(data[i].ClaimTypeDesc));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting claim type information.");
                }
            });
        }

        function loadPolicyType() {
            var dropdown = $('#PolicyType');

            dropdown.empty();

            dropdown.append('<option selected="true" value="0">Policy Type</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/InsuranceClaims/GetPolicyTypes/";
            var url = $("#localApiDomain").val() + "InsuranceClaims/GetPolicyTypes/";

            return $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append($("<option style='font-weight: bold;'></option>").prop("value", data[i].PolicyTypeID).text(data[i].PolicyTypeDesc));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting policy type information.");
                }
            });
        }

        function loadClaimStatus() {
            var dropdown = $('#claimStatus');

            dropdown.empty();

            dropdown.append('<option selected="true" value="0">Claim Status</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/InsuranceClaims/GetClaimStatuses/";
            var url = $("#localApiDomain").val() + "InsuranceClaims/GetClaimStatuses/";

            return $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append($("<option style='font-weight: bold;'></option>").prop("value", data[i].ClaimStatusID).text(data[i].ClaimStatusDesc));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting claim status information.");
                }
            });
        }

        function loadPendingClaimStatus() {
            var dropdown = $('#pendingClaimStatus');

            dropdown.empty();

            dropdown.append('<option selected="true" value="0">Pending Status</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/InsuranceClaims/GetPendingClaimStatuses/";
            var url = $("#localApiDomain").val() + "InsuranceClaims/GetPendingClaimStatuses/";

            return $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append($("<option style='font-weight: bold;'></option>").prop("value", data[i].PendingClaimStatusID).text(data[i].PendingClaimStatusDesc));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting pending claim status information.");
                }
            });
        }

        function loadPCARep() {
            var dropdown = $('#PCARepAssigned');

            dropdown.empty();

            dropdown.append('<option selected="true" value="0"></option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/InsuranceClaims/GetPCAReps/";
            var url = $("#localApiDomain").val() + "InsuranceClaims/GetPCAReps/";

            return $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append($("<option style='font-weight: bold;'></option>").prop("value", data[i].PCARepID).text(data[i].PCARepName));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting PCA Reps.");
                }
            });
        }

    </script>

    <style>
        .MoneyFormat{
            text-align: right;
        }
        .xl1525500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl6725500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl6825500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"_\(\0022$\0022* \#\,\#\#0\.00_\)\;_\(\0022$\0022* \\\(\#\,\#\#0\.00\\\)\;_\(\0022$\0022* \0022-\0022??_\)\;_\(\@_\)";
	        text-align:general;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl6925500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"_\(\0022$\0022* \#\,\#\#0\.00_\)\;_\(\0022$\0022* \\\(\#\,\#\#0\.00\\\)\;_\(\0022$\0022* \0022-\0022??_\)\;_\(\@_\)";
	        text-align:general;
	        vertical-align:bottom;
	        border:1.0pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7025500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7125500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:right;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7225500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"mm\/dd\/yy\;\@";
	        text-align:general;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7325500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7425500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"_\(\0022$\0022* \#\,\#\#0\.00_\)\;_\(\0022$\0022* \\\(\#\,\#\#0\.00\\\)\;_\(\0022$\0022* \0022-\0022??_\)\;_\(\@_\)";
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7525500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:white;
	        font-size:11.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        background:black;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl7625500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"mm\/dd\/yy\;\@";
	        text-align:general;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        background:#DBDBDB;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl7725500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"_\(\0022$\0022* \#\,\#\#0\.00_\)\;_\(\0022$\0022* \\\(\#\,\#\#0\.00\\\)\;_\(\0022$\0022* \0022-\0022??_\)\;_\(\@_\)";
	        text-align:center;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7825500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:red;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7925500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        background:#E7E6E6;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8025500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"_\(\0022$\0022* \#\,\#\#0\.00_\)\;_\(\0022$\0022* \\\(\#\,\#\#0\.00\\\)\;_\(\0022$\0022* \0022-\0022??_\)\;_\(\@_\)";
	        text-align:general;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        background:#E7E6E6;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8125500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"Short Date";
	        text-align:general;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        background:#E7E6E6;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8225500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:white;
	        font-size:11.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        background:black;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8325500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        border:1.0pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8425500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:"mm\/dd\/yy\;\@";
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8525500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        background:#D9D9D9;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8625500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8725500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:12.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8825500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:12.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border-top:1.0pt solid windowtext;
	        border-right:none;
	        border-bottom:1.0pt solid windowtext;
	        border-left:1.0pt solid windowtext;
	        background:#92D050;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8925500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:12.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border-top:1.0pt solid windowtext;
	        border-right:none;
	        border-bottom:1.0pt solid windowtext;
	        border-left:none;
	        background:#92D050;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl9025500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:12.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border-top:1.0pt solid windowtext;
	        border-right:1.0pt solid windowtext;
	        border-bottom:1.0pt solid windowtext;
	        border-left:none;
	        background:#92D050;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl9125500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border-top:none;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl9225500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:.5pt solid windowtext;
	        background:#E7E6E6;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl9325500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        background:#E7E6E6;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl9425500
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:.5pt solid windowtext;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        background:#E7E6E6;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .auto-style1 {
            padding-top: 1px;
            padding-right: 1px;
            padding-left: 1px;
            mso-ignore: padding;
            color: black;
            font-size: 11.0pt;
            font-weight: 400;
            font-style: normal;
            text-decoration: none;
            font-family: Calibri, sans-serif;
            mso-font-charset: 0;
            mso-number-format: General;
            text-align: general;
            vertical-align: bottom;
            mso-background-source: auto;
            mso-pattern: auto;
            white-space: nowrap;
            height: 14pt;
        }
        .auto-style2 {
            padding-top: 1px;
            padding-right: 1px;
            padding-left: 1px;
            mso-ignore: padding;
            color: black;
            font-size: 11.0pt;
            font-weight: 700;
            font-style: normal;
            text-decoration: none;
            font-family: Calibri, sans-serif;
            mso-font-charset: 0;
            mso-number-format: General;
            text-align: center;
            vertical-align: bottom;
            mso-background-source: auto;
            mso-pattern: auto;
            white-space: nowrap;
            height: 14pt;
        }
        .auto-style3 {
            padding-top: 1px;
            padding-right: 1px;
            padding-left: 1px;
            mso-ignore: padding;
            color: black;
            font-size: 11.0pt;
            font-weight: 400;
            font-style: normal;
            text-decoration: none;
            font-family: Calibri, sans-serif;
            mso-font-charset: 0;
            mso-number-format: General;
            text-align: general;
            vertical-align: bottom;
            mso-background-source: auto;
            mso-pattern: auto;
            white-space: nowrap;
            height: 15pt;
        }
        -->
        </style>
        
        <input type="text" id="IncidentID" style="display:none" />
        <input type="text" id="ClaimID" style="display:none" />
        <div id="Main" align=center>

        <table id="topTable" border=0 cellpadding=0 cellspacing=0 width=795 style='border-collapse:collapse;table-layout:fixed;width:598pt'>
         <col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <tr height=16 style='mso-height-source:userset;height:12.0pt'>
          <td height=16 class=xl1525500 width=19 style='height:12.0pt;width:14pt'><a
          name="RANGE!A1"></a></td>
          <td class=xl1525500 width=177 style='width:133pt'></td>
          <td class=xl1525500 width=17 style='width:13pt'></td>
          <td class=xl1525500 width=177 style='width:133pt'></td>
          <td class=xl1525500 width=17 style='width:13pt'></td>
          <td class=xl1525500 width=177 style='width:133pt'></td>
          <td class=xl1525500 width=17 style='width:13pt'></td>
          <td class=xl1525500 width=177 style='width:133pt'></td>
          <td class=xl1525500 width=17 style='width:13pt'></td>
         </tr>
         <tr height=22 style='height:16.5pt'>
          <td height=22 class=xl1525500 style='height:16.5pt'></td>
          <td colspan=7 class=xl8825500 style='border-right:1.0pt solid black'>CLAIMS -
          LIABILITIES/VEHICLES</td>
          <td class=xl8725500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7025500>DATE OF INCIDENT</td>
          <td class=xl7025500></td>
          <td class=xl7025500>CLAIM TYPE</td>
          <td class=xl7025500></td>
          <td class=xl7025500>LOCATION</td>
          <td class=xl7025500></td>
          <td class=xl7025500>POLICY TYPE</td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl6725500>
              <input type='text' id='IncidentDate' style='border:none' tabindex="1" disabled /></td>
          <td class=xl1525500></td>
          <td class=xl7925500>
              <select id="claimType" style='background-color:#E7E6E6;border:none' tabindex="2"></select></td>
          <td class=xl1525500></td>
          <td class=xl6725500><input type="text" id="location" style="border:none" tabindex="3" disabled/></td>
          <td class=xl1525500></td>
          <td class=xl7925500>
              <select id="PolicyType" style='background-color:#E7E6E6;border:none' tabindex="4"></select></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl7025500>PCA INCIDENT # - CLAIM #</td>
          <td class=xl1525500></td>
          <td class=xl7025500>PCA EMP INVOLVED</td>
          <td class=xl1525500></td>
          <td class=xl7025500>STATUS</td>
          <td class=xl1525500></td>
          <td class=xl7025500>STATUS DATE</td>
          <td class=xl1525500></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl8325500>
              <input id="IncidentClaimNumber" type="text" style="border:none" tabindex="5" disabled/></td>
          <td class=xl1525500></td>
          <td class=xl6725500>
              <select id="EmployeeInvolvedClaimID" style='background-color:#E7E6E6;border:none;' tabindex="6"></select>
          <td class=xl1525500></td>
          <td class=xl7925500>
              <select id="claimStatus" style='background-color:#E7E6E6;border:none' tabindex="7"></select></td>
          <td class=xl1525500></td>
          <td class=xl7225500>
              <input type='date' id='ClaimStatusDate' style='border:none' tabindex="8" /></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7025500>CLAIMANT NAME</td>
          <td class=xl1525500></td>
          <td class=xl7025500>REP FOLLOW UP DATE</td>
          <td class=xl1525500></td>
          <td class=xl7025500>PENDING STATUS</td>
          <td class=xl1525500></td>
          <td class=xl7025500>PCA VEHICLE NO.</td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl6725500>
              <select id="ClaimantName" style='background-color:#E7E6E6;border:none;' tabindex="9"></select>
          <td class=xl1525500></td>
          <td class=xl8525500>
              <input id="RepFollowUpDate" type="date"  style='background-color:#E7E6E6;border:none' tabindex="10" /></td>
          <td class=xl1525500></td>
          <td class=xl7925500>
              <select id="pendingClaimStatus" style='background-color:#E7E6E6;border:none' tabindex="11" /></td>
          <td class=xl1525500></td>
          <td class=xl6725500>
              <input id="PCAVehicleNumber" type="text" style="border:none" tabindex="12" /></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr>
          <td class=auto-style3></td>
          <td class=auto-style3></td>
          <td class=auto-style3></td>
          <td class=auto-style3></td>
          <td class=auto-style3></td>
          <td class=auto-style3></td>
          <td class=auto-style3></td>
          <td class=auto-style3></td>
          <td class=auto-style3></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7025500>PAID BY</td>
          <td class=xl7325500></td>
          <td class=xl7025500>AMOUNT<span style='mso-spacerun:yes'> </span></td>
          <td class=xl1525500></td>
          <td class=xl7025500>PCA PAYABLES</td>
          <td class=xl1525500></td>
          <td class=xl7725500><span style='mso-spacerun:yes'> </span>MONTHLY
          ALLOCATION<span style='mso-spacerun:yes'> </span></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500>PCA Insurance</td>
          <td class=xl1525500></td>
          <td class=xl8025500>
              <input id="PaidByInsurance" type="text"  style='background-color:#E7E6E6;border:none' class="MoneyFormat" tabindex="13" /></td>
          <td class=xl1525500></td>
          <td class=xl6825500>
              <input id="PCAPayables" type="text" style="border:none" class="MoneyFormat" disabled /></td>
          <td class=xl1525500></td>
          <td class=xl8025500>
              <input id="MonthlyAllocation" type="text"  style='background-color:#E7E6E6;border:none' class="MoneyFormat" tabindex="19" /></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500>3rd Party Insurance</td>
          <td class=xl1525500></td>
          <td class=xl8025500 style='border-top:none'>
              <input id="PaidByThridPartyInsurance" type="text"  style='background-color:#E7E6E6;border:none' class="MoneyFormat" tabindex="14" /></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl7425500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500>PCA Deductible</td>
          <td class=xl1525500></td>
          <td class=xl8025500 style='border-top:none'>
              <input id="PCADeductible" type="text"  style='background-color:#E7E6E6;border:none' class="MoneyFormat" tabindex="15" /></td>
          <td class=xl1525500></td>
          <td class=xl7025500>PCA ACTUAL EXPENSE</td>
          <td class=xl1525500></td>
          <td class=xl7725500><span style='mso-spacerun:yes'> </span>RESERVE<span
          style='mso-spacerun:yes'> </span></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500>PCA Out of Pocket</td>
          <td class=xl1525500></td>
          <td class=xl8025500 style='border-top:none'>
              <input id="PCAOutOfPocket" type="text"  style='background-color:#E7E6E6;border:none' class="MoneyFormat" tabindex="16" /></td>
          <td class=xl1525500></td>
          <td class=xl6825500>
              <input id="PCAActualExpense" type="text" style="border:none" class="MoneyFormat" disabled /></td>
          <td class=xl1525500></td>
          <td class=xl8025500>
              <input id="Reserve" type="text"  style='background-color:#E7E6E6;border:none' class="MoneyFormat" tabindex="20" /></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl1525500>Employee Paid</td>
          <td class=xl1525500></td>
          <td class=xl8025500 style='border-top:none'>
              <input id="EmployeePaid" type="text"  style='background-color:#E7E6E6;border:none' class="MoneyFormat" tabindex="17" /></td>
          <td class=xl1525500></td>
          <td class=xl7425500></td>
          <td class=xl1525500></td>
          <td class=xl7425500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=0 style='display:none'>
          <td class=xl1525500></td>
          <td class=xl1525500>PCA Direct</td>
          <td class=xl1525500></td>
          <td class=xl8025500 style='border-top:none'>
              <input id="PCADirect" type="text"  style='background-color:#E7E6E6;border:none' class="MoneyFormat" tabindex="18" /></td>
          <td class=xl1525500></td>
          <td class=xl7425500></td>
          <td class=xl1525500></td>
          <td class=xl7425500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl7125500>TOTAL CLAIM</td>
          <td class=xl1525500></td>
          <td class=xl6925500>
              <input id="TotalClaim" type="text" style="border:none" class="MoneyFormat" disabled /></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl7425500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7025500>PCA INSURANCE CLAIM #</td>
          <td class=xl7325500></td>
          <td class=xl7025500>OTHER INSURANCE CLAIM #</td>
          <td class=xl7325500></td>
          <td class=xl7025500>POLICE REPORT #<span style='mso-spacerun:yes'> </span></td>
          <td class=xl7325500></td>
          <td class=xl7025500>DATE PCA RECEIVED CLAIM</td>
          <td class=xl7325500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7925500>
              <input id="PCAInsuranceClaimNumber" type="text"  style='background-color:#E7E6E6;border:none' tabindex="21" /></td>
          <td class=xl1525500></td>
          <td class=xl7925500>
              <input id="OtherInsuranceClaimNumber" type="text"  style='background-color:#E7E6E6;border:none' tabindex="22" /></td>
          <td class=xl1525500></td>
          <td class=xl6825500>
              <input id="PoliceReportNumber" type="text"  style='border:none' disabled /></td>
          <td class=xl1525500></td>
          <td class=xl6725500>
              <input id="PCAReceiveDate" type="text" style="border:none" disabled /></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr>
          <td class=auto-style1></td>
          <td class=auto-style2>PCA REP ASSIGNED</td>
          <td class=auto-style1></td>
          <td class=auto-style1></td>
          <td class=auto-style1></td>
          <td class=auto-style1></td>
          <td class=auto-style1></td>
          <td class=auto-style1></td>
          <td class=auto-style1></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7625500>
              <select id="PCARepAssigned" style='background-color:#E7E6E6;border:none' tabindex="23"></select>
          </td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl8425500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
        </table>
        <table id='payableTable' border=0 cellpadding=0 cellspacing=0 width=795 style='border-collapse:collapse;table-layout:fixed;width:598pt'>
         <col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl7025500>&nbsp;</td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7525500>
              <input id="addNote" type="button" value="ADD NOTE" style="background-color:black;color:white" tabindex="25" /></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500>&nbsp;</td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=22 style='height:16.5pt'>
          <td height=22 class=xl1525500 style='height:16.5pt'></td>
          <td colspan=7 class=xl8825500 style='border-right:1.0pt solid black'>PCA
          PAYABLES</td>
          <td class=xl8725500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7025500></td>
          <td class=xl7025500></td>
          <td class=xl7025500></td>
          <td class=xl7025500></td>
          <td class=xl7025500></td>
          <td class=xl7025500></td>
          <td class=xl7025500></td>
          <td class=xl7025500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7025500>VENDOR / PAYEE</td>
          <td class=xl7325500></td>
          <td class=xl7025500>PCA CHECK NUMBER</td>
          <td class=xl7325500></td>
          <td class=xl7025500>CHECK AMOUNT</td>
          <td class=xl1525500></td>
          <td class=xl7025500>MAILED DATE</td>
          <td class=xl1525500></td>
         </tr>
        </table>
        <table id="receivableTable" border=0 cellpadding=0 cellspacing=0 width=795 style='border-collapse:collapse;table-layout:fixed;width:598pt'>
         <col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl7525500><input id="addPayable" type="button" value="ADD PAYABLE" style="background-color:black;color:white" /></td>
          <td class=xl1525500></td>
          <td class=xl7025500>TOTAL PAYABLES</td>
          <td class=xl1525500></td>
          <td class=xl6925500>
              <input id="TotalPayables" type="text" style="border:none" class="MoneyFormat" disabled /></td>
          <td class=xl1525500></td>
          <td class=xl1525500><span style='mso-spacerun:yes'> </span></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=22 style='height:16.5pt'>
          <td height=22 class=xl1525500 style='height:16.5pt'></td>
          <td colspan=7 class=xl8825500 style='border-right:1.0pt solid black'>RECEIVABLES</td>
          <td class=xl8725500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7025500>PAYOR</td>
          <td class=xl7325500></td>
          <td class=xl7025500>CHECK NUMBER</td>
          <td class=xl7325500></td>
          <td class=xl7025500>CHECK AMOUNT</td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
        </table>
        <table id="bottomTable" border=0 cellpadding=0 cellspacing=0 width=795 style='border-collapse:collapse;table-layout:fixed;width:598pt'>
         <col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl7525500><input id="addReceivable" type="button" value="ADD RECEIVABLE" style="background-color:black;color:white" tabindex="26" /></td>
          <td class=xl1525500></td>
          <td class=xl7025500>TOTAL RECEIVABLES</td>
          <td class=xl1525500></td>
          <td class=xl6925500>
              <input id="TotalReceivables" type="text" class="MoneyFormat" style="border:none" disabled /></td>
          <td class=xl1525500></td>
          <td colspan=2 class=xl8625500></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1525500 style='height:15.75pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl7025500>TOTAL EXPENSE TO PCA</td>
          <td class=xl1525500></td>
          <td class=xl6925500>
              <input id="TotalExpenseToPCA" type="text" class="MoneyFormat" style="border:none" disabled /></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7025500>Claim Closed?</td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl7925500>
              <select id="Closed" style='background-color:#E7E6E6;border:none' tabindex="4">
                  <option value="0">No</option>
                  <option value="1">Yes</option>
              </select></td>
          <td class=xl1525500></td>
          <td class=xl7525500><input id="saveSubmit" type="button" value="SAVE" style="background-color:black;color:white;font-weight:bold" tabindex="27" /></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1525500 style='height:15.0pt'></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
          <td class=xl1525500></td>
         </tr>
         <![if supportMisalignedColumns]>
         <tr height=0 style='display:none'>
          <td width=19 style='width:14pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
         </tr>
         <![endif]>
        </table>

        </div>




    <script>
        var claimNote = "<table id='ClaimNote1' border=0 cellpadding=0 cellspacing=0 width=795 style='border-collapse:collapse;table-layout:fixed;width:598pt'>" +
                "<col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
				"<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td colspan=5 class=xl9125500>NOTE 1</td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl7025500>DATE OF NOTE</td>" +
				  "<td class=xl7325500></td>" +
				 "</tr>" +
				 "<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td colspan=5 rowspan=3 class=xl9225500 style='border-right:.5pt solid black'>" +
					  "<textarea id='noteClaimNote1' class='auto-style1' cols='20' style='background-color:#E7E6E6;border:none;margin: 0px; height: 61px;'></textarea><input type='text' id='NoteIDClaimNote1' style='display:none' /></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl6725500>" +
					  "<input id='DateClaimNote1' type='text' style='background-color:#E7E6E6;border:none' disabled/></td>" +
				  "<td class=xl1525500></td>" +
				 "</tr>" +
				 "<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				 "</tr>" +
				 "<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl7025500>NOTE ENTERED BY</td>" +
				  "<td class=xl1525500></td>" +
				 "</tr>" +
				 "<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl6725500>" +
					  "<input id='EnteredByClaimNote1' type='text' style='background-color:#E7E6E6;border:none' disabled/></td>" +
				  "<td class=xl1525500></td>" +
				 "</tr>" +
				 "<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				 "</tr>" +
				 "</table>";

        var payable = "<table id='Payable1' border=0 cellpadding=0 cellspacing=0 width=795 style='border-collapse:collapse;table-layout:fixed;width:598pt'>" +
                "<col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
				"<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td class=xl7925500><input id='PayorPayeePayable1' type='text' style='background-color:#E7E6E6;border:none' /><input type='text' id='ClaimPayableIDPayable1' style='display:none' /></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl7925500><input id='CheckNumberPayable1' type='text' style='background-color:#E7E6E6;border:none' /></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl8025500><input id='CheckAmountPayable1' type='text' style='background-color:#E7E6E6;border:none' class='MoneyFormat' /></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl8125500><input id='MailDatePayable1' type='text' style='background-color:#E7E6E6;border:none' /></td>" +
				  "<td class=xl1525500></td>" +
				 "</tr>" +
				 "<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				 "</tr>" +
				 "</table>";

        var receivable = "<table id='Receivable1' border=0 cellpadding=0 cellspacing=0 width=795 style='border-collapse:collapse;table-layout:fixed;width:598pt'>" +
                "<col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
				"<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td class=xl7925500><input id='PayorReceivable1' type='text' style='background-color:#E7E6E6;border:none' /><input type='text' id='ClaimReceivableIDReceivable1' style='display:none' /></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl7925500><input id='CheckNumberReceivable1' type='text' style='background-color:#E7E6E6;border:none' /></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl8025500><input id='CheckAmountReceivable1' type='text' class='MoneyFormat' style='background-color:#E7E6E6;border:none' /></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				 "</tr>" +
				 "<tr height=20 style='height:15.0pt'>" +
				  "<td height=20 class=xl1525500 style='height:15.0pt'></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				  "<td class=xl1525500></td>" +
				 "</tr>" +
				 "</table>";
    </script>
</asp:Content>


