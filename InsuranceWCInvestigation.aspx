<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceWCInvestigation.aspx.cs" Inherits="InsuranceWCInvestigation" %>

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
        var witnessArray = [];

        $(document).ready(function () {
            $("#printReport").on('click', function () {
                $("#save").hide();
                $("#submit").hide();
                $("#printReport").hide();
                window.print();
                $(document).one('click', function () {
                    $("#save").show();
                    $("#submit").show();
                    $("#printReport").show();
                });
            });

            $("#EmployeeSSN").on("keyup", function () {
                if (!Number.isInteger(Number(this.value)) || this.value.slice(-1) == ".") {
                    this.value = this.value.slice(0, -1);
                }
            });

            $(document).on('keypress', function (e) {
                if (e.keyCode == 13) {
                    if (document.activeElement.id == 'NumberOfWitnesses') {
                        if (isNaN($("#NumberOfWitnesses").val()) == false) {
                            var witnessNumber = $("#NumberOfWitnesses").val();
                            if (witnessNumber == 0) {
                                witnessArray.length = 0;
                                $(".witnessSection").remove();
                            } else if (witnessNumber > witnessArray.length && witnessArray.length != 0) {
                                for (i = witnessNumber - witnessArray.length ; i > 0; i--) {
                                    witnessInfoBuild = InvestigationWitnessInfo;
                                    witnessInfoBuild = witnessInfoBuild.replace(/witness1/g, 'witness' + (witnessArray.length + 1).toString());
                                    witnessInfoBuild = witnessInfoBuild.replace('NO. 1', 'NO.' + (witnessArray.length + 1).toString());
                                    var placementTable = '#Infowitness' + (witnessArray.length).toString();
                                    $(placementTable).after(witnessInfoBuild);
                                    var newWitness = '#Infowitness' + (witnessArray.length + 1).toString();
                                    witnessArray.splice(0, 0, newWitness);

                                    loadWitnessState(witnessArray.length + 1, '');
                                }
                            } else if (witnessNumber < witnessArray.length) {
                                var arrayLength = witnessArray.length;
                                for (i = 0; i <= arrayLength - witnessNumber - 1; i++) {
                                    $(witnessArray[0]).remove();
                                    witnessArray.splice(0, 1);
                                }
                            } else if (witnessArray.length == 0) {
                                for (i = $("#NumberOfWitnesses").val() ; i > 0; i--) {
                                    witnessInfoBuild = InvestigationWitnessInfo;
                                    witnessInfoBuild = witnessInfoBuild.replace(/witness1/g, 'witness' + (i).toString());
                                    witnessInfoBuild = witnessInfoBuild.replace('NO. 1', 'NO.' + (i).toString());
                                    if (i == 1) {
                                        witnessInfoBuild = witnessInfoBuild.replace("'~'", "autofocus");
                                    }
                                    $("#mainTable").after(witnessInfoBuild);
                                    var newWitness = '#Infowitness' + (i).toString();
                                    witnessArray.push(newWitness);

                                    loadWitnessState(i, '');
                                }
                            }
                        }
                    }
                }
            });

            $("#NumberOfWitnesses").blur(function () {
                if (isNaN($("#NumberOfWitnesses").val()) == false) {
                    var witnessNumber = $("#NumberOfWitnesses").val();
                    if (witnessNumber == 0) {
                        witnessArray.length = 0;
                        $(".witnessSection").remove();
                    } else if (witnessNumber > witnessArray.length && witnessArray.length != 0) {
                        for (i = witnessNumber - witnessArray.length ; i > 0; i--) {
                            witnessInfoBuild = InvestigationWitnessInfo;
                            witnessInfoBuild = witnessInfoBuild.replace(/witness1/g, 'witness' + (witnessArray.length + 1).toString());
                            witnessInfoBuild = witnessInfoBuild.replace('NO. 1', 'NO.' + (witnessArray.length + 1).toString());
                            var placementTable = '#Infowitness' + (witnessArray.length).toString();
                            $(placementTable).after(witnessInfoBuild);
                            var newWitness = '#Infowitness' + (witnessArray.length + 1).toString();
                            witnessArray.splice(0, 0, newWitness);
                            var thisFocus = "#witness" + (i).toString() + "name";
                            $(thisFocus).focus();

                            loadWitnessState(witnessArray.length + 1, '');
                        }
                    } else if (witnessNumber < witnessArray.length) {
                        var arrayLength = witnessArray.length;
                        for (i = 0; i <= arrayLength - witnessNumber - 1; i++) {
                            $(witnessArray[0]).remove();
                            witnessArray.splice(0, 1);
                        }
                    } else if (witnessArray.length == 0) {
                        for (i = $("#NumberOfWitnesses").val() ; i > 0; i--) {
                            witnessInfoBuild = InvestigationWitnessInfo;
                            witnessInfoBuild = witnessInfoBuild.replace(/witness1/g, 'witness' + (i).toString());
                            witnessInfoBuild = witnessInfoBuild.replace('NO. 1', 'NO.' + (i).toString());
                            if (i == 1) {
                                witnessInfoBuild = witnessInfoBuild.replace("'~'", "autofocus");
                            }
                            $("#mainTable").after(witnessInfoBuild);
                            var newWitness = '#Infowitness' + (i).toString();
                            witnessArray.push(newWitness);
                            var thisFocus = "#witness" + (i).toString() + "name";
                            $(thisFocus).focus();

                            loadWitnessState(i, '');
                        }
                    }
                }
            });

            const params = new URLSearchParams(window.location.search);
            $("#WCClaimID").val(params.get("WCClaimID"));

            $.when(loadLocations('#employeeWorkLocation').then(function (thisData) {
                    $.when(loadLocations('#accidentLocation').then(function (thisData) {
                        if ($("#WCClaimID").val() == '') {
                            //do nothiing
                        } else {
                            loadWCInvestigation($("#WCClaimID").val());
                        }

                        }).fail(function (error) {
                            alert("error " + error);
                        })
                    );
                }).fail(function (error) {
                    alert("error " + error);
                })
            );

            loadStates();

            Security();
        });

        function loadWCInvestigation(WCClaimID) {
            var url = "http://localhost:52839/api/InsuranceWCClaims/GetWCInvestigationByWCClaimID/" + WCClaimID;
            //var url = $("#localApiDomain").val() + "InsuranceWCClaims/GetWCInvestigationByWCClaimID/" + WCClaimID;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    $("#WCInvestigationID").val(data[0].WCInvestigationID);
                    loadWCIncidentWitness(data[0].WCInvestigationID);
                    $("#IncidentNumber").val(data[0].IncidentNumber + "-" + data[0].ClaimNumber);
                    $("#WorkerCompNumber").val(data[0].WCInvestigationNumber + '-' + data[0].WCClaimNumber);
                    $("#EmployeeName").val(data[0].EmployeeName);
                    $("#EmployeeAddress").val(data[0].EmployeeAddress);
                    $("#EmployeeCity").val(data[0].EmployeeCity);
                    var getEmployseeLocationOption = '#EmployeeState option[value=' + data[0].EmployeeStateID + ']';
                    $(getEmployseeLocationOption).prop("selected", true);
                    $("#EmployeeSSN").val(data[0].EmployeeSS);
                    $("#EmployeeZip").val(data[0].EmployeeZip);
                    $("#EmployeeDOB").val(data[0].EmployeeDOB);
                    $("#EmployeeHomePhone").val(data[0].EmployeeHomePhone);
                    $("#EmployeeAge").val(data[0].EmployeeAge);
                    $("input[name=marital][value=" + data[0].EmployeeMaritalStatus + "]").prop('checked', true);
                    $("#EmployeeNumberOfDependents").val(data[0].EmployeeNumberOfDependents);
                    $("#sex").val(data[0].EmployeeNumberOfDependents);
                    var getEmployeeWorkLocation = '#employeeWorkLocation option[value=' + data[0].RegularEmploymentLocationID + ']';
                    $(getEmployeeWorkLocation).prop("selected", true);
                    $("#employeeDateHire").val(data[0].EmployeeDateOfHire);
                    var getEmployeeMissWork = '#employeeMissWork option[value=' + data[0].RequiredToMissWork + ']';
                    $(getEmployeeMissWork).prop("selected", true);
                    $("#employeeDateReturned").val(data[0].MissedWorkReturnDate); 
                    var getPaidDayOfInjury = '#paidDayOfInjury option[value=' + data[0].PaidForDayOfInjury + ']';
                    $(getPaidDayOfInjury).prop("selected", true);
                    $("#EmployeeWageRate").val(data[0].EmployeeWageRate);
                    $("#EmployeeHowLongWorkedAtLocation").val(data[0].IncidentLocationWorkLength);
                    $("#EmployeeAverageHoursWorkedPerDay").val(data[0].AveHoursWorkedPerDay);
                    $("#EmployeeAverageDaysWorkedPerWeek").val(data[0].AveDaysWorkedPerWeek);
                    $("#EmployeeUsualDaysOff").val(data[0].NormalDaysOff);
                    var getAccidentLocation = '#accidentLocation option[value=' + data[0].InjuryLocationId + ']';
                    $(getAccidentLocation).prop("selected", true); 
                    $("#accidentInjuryDateTime").val(data[0].InjuryDateTime);
                    $("AccidentLocationSpecific").val(data[0].InjuryLocation);
                    $("input[name=onEmployersPremises][value=" + data[0].InjuryOnPremises + "]").prop('checked', true);
                    $("#accidentShiftBeginDateTime").val(data[0].TimeShiftBegain);
                    $("#accidentEmployerNotifiedDate").val(data[0].EmployerNotifiedDate);
                    $("#accidentWhoWasNotified").val(data[0].NotiefiedName);
                    $("#injuryBodyPart").val(data[0].InjuryBodyPart);
                    $("#injuryNature").val(data[0].InjuryNature);
                    $("#injuryCause").val(data[0].InjuryCause);
                    $("#injuryImmediatelyBefore").val(data[0].ActioinBeforInjury);
                    $("input[name=awareHandicap][value=" + data[0].AnyPriorHandicap + "]").prop('checked', true);
                    $("#injuryAwareOfHandicap").val(data[0].HandicapDescription);
                    $("input[name=propertyDamage][value=" + data[0].PropertyDamage + "]").prop('checked', true);
                    $("#injuryPropertyDamageDesc").val(data[0].PropertyDamageDescription);
                    $("input[name=safetyEquipmentProvided][value=" + data[0].SaftyEquipmentInvolved + "]").prop('checked', true);
                    $("input[name=safetyEquipmentUsed][value=" + data[0].SaftyEquipmentUsed + "]").prop('checked', true);
                    $("input[name=treatmentFacility][value=" + data[0].MedicalFacilityID + "]").prop('checked', true);
                    $("#treatmentFirstAidDescWhom").val(data[0].FirstAidAdministered);
                    $("#treatmentFacility").val(data[0].NameOfMedicalFacility);
                    $("#treatmentPhysician").val(data[0].NameOfTreatingPhysician);
                    $("input[name=employeeDrugTest][value=" + data[0].DrugTest + "]").prop('checked', true);
                    $("#treatmentDrugTestFacility").val(data[0].DrugTestFacility);
                    $("input[name=documentSigned][value=" + data[0].NoticesExplained + "]").prop('checked', true);
                    $("#causeDesc").val(data[0].CauseOfIllnessIncident);
                    $("input[name=policyInAffect][value=" + data[0].CausePolicyInAffect + "]").prop('checked', true); 
                    $("input[name=employeeAwareOfPolicy][value=" + data[0].PolicyInAffectEmployeeAware + "]").prop('checked', true); 
                    $("#causePolicyDesc").val(data[0].PolicyInAffectDescription);
                    $("#causePolicyNotificationType").val(data[0].PolicyInAffectHowNotified);
                    $("#employeeComments").val(data[0].EmpoyeeComments);
                    $("#supervisorComments").val(data[0].SupervisorComments);
                    $("#employeeSignature").val(data[0].EmployeeSignature);
                    $("#employeeSignatureDate").val(data[0].EmployeeSignatureDate);
                    $("#supervisorSignature").val(data[0].SupervisorSignature);
                    $("#supervisorSignatureDate").val(data[0].SupervisorSignatureDate);
                },
                error: function (request, status, error) {
                    swal("There was an issue getting state information.");
                }
            });
        }

        $("#saveWCInvestigation").on('click', function () {

            var url = "http://localhost:52839/api/InsuranceWCClaims/PutWCInvestigation/";
            //var url = $("#localApiDomain").val() + "InsuranceWCClaims/PutWCInvestigation/";

            $.ajax({
                type: "PUT",
                url: url,
                data: {
                    "WCInvestigationID": $("#WCInvestigationID").val(),
                    "EmployeeName": $("#EmployeeName").val(),
                    "EmployeeAddress": $("#EmployeeAddress").val(),
                    "EmployeeCity": $("#EmployeeCity").val(),
                    "EmployeeStateID": $("#EmployeeState").children("option:selected").val(),
                    "EmployeeSS": $("#EmployeeSSN").val(),
                    "EmployeeHomePhone": $("#EmployeeHomePhone").val(),
                    "EmployeeSex": $("input[name='sex']:checked").val(),
                    "EmployeeMaritalStatus": $("input[name='marital']:checked").val(),
                    "EmployeeDOB": $("#EmployeeDOB").val(),
                    "EmployeeAge": $("#EmployeeAge").val(),
                    "EmployeeNumberOfDependents": $("#EmployeeNumberOfDependents").val(),
                    "RegularEmploymentLocationID": $("#employeeWorkLocation").children("option:selected").val(),
                    "EmployeeDateOfHire": $("#employeeDateHire").val(),
                    "MissedWorkReturnDate": $("#employeeDateReturned").val(),
                    "RequiredToMissWork": $("input[name='employeeMissWork']:checked").val(),
                    "PaidForDayOfInjury": $("input[name='paidDayOfInjury']:checked").val(),
                    "IncidentLocationWorkLength": $("#EmployeeHowLongWorkedAtLocation").val(),
                    "AveHoursWorkedPerDay": $("#EmployeeAverageHoursWorkedPerDay").val(),
                    "AveDaysWorkedPerWeek": $("#EmployeeAverageDaysWorkedPerWeek").val(),
                    "NormalDaysOff": $("#EmployeeUsualDaysOff").val(),
                    "InjuryLocationId": $("#accidentLocation").children("option:selected").val(),
                    "InjuryDateTime": $("#accidentInjuryDateTime").val(),
                    "InjuryOnPremises": $("input[name='onEmployersPremises']:checked").val(),
                    "InjuryLocation": $("#AccidentLocationSpecific").val(),
                    "TimeShiftBegain": $("#accidentShiftBeginDateTime").val(),
                    "EmployerNotifiedDate": $("#accidentEmployerNotifiedDate").val(),
                    "NotifiedName": $("#accidentWhoWasNotified").val(),
                    "InjuryBodyPart": $("#injuryBodyPart").val(),
                    "InjuryNature": $("#injuryNature").val(),
                    "InjuryCause": $("#injuryCause").val(),
                    "ActioinBeforInjury": $("#injuryImmediatelyBefore").val(),
                    "AnyPriorHandicap": $("input[name='awareHandicap']:checked").val(),
                    "HandicapDescription": $("#injuryAwareOfHandicap").val(),
                    "PropertyDamage": $("input[name='propertyDamage']:checked").val(), 
                    "PropertyDamageDescription": $("#injuryPropertyDamageDesc").val(),
                    "SaftyEquipmentInvolved": $("input[name='safetyEquipmentProvided']:checked").val(), 
                    "SaftyEquipmentUsed": $("input[name='safetyEquipmentUsed']:checked").val(), 
                    "MedicalFacilityID": $("input[name='treatmentFacility']:checked").val(),
                    "FirstAidAdministered": $("#treatmentFirstAidDescWhom").val(),
                    "NameOfMedicalFacility": $("#treatmentFacility").val(),
                    "DrugTest": $("input[name='employeeDrugTest']:checked").val(), 
                    "DrugTestFacility": $("#treatmentDrugTestFacility").val(),
                    "NoticesExplained": $("input[name='documentSigned']:checked").val(), 
                    "CauseOfIllnessIncident": $("#causeDesc").val(),
                    "CausePolicyInAffect": $("input[name='policyInAffect']:checked").val(), 
                    "PolicyInAffectDescription": $("#causePolicyDesc").val(),
                    "PolicyInAffectEmployeeAware": $("input[name='employeeAwareOfPolicy']:checked").val(), 
                    "PolicyInAffectHowNotified": $("#causePolicyNotificationType").val(),
                    "EmpoyeeComments": $("#employeeComments").val(),
                    "SupervisorComments": $("#supervisorComments").val(),
                    "EmployeeSignature": $("#employeeSignature").val(),
                    "SupervisorSignature": $("#supervisorSignature").val(),
                    "EmployeeSignatureDate": $("#employeeSignatureDate").val(),
                    "SupervisorSignature": $("#supervisorSignatureDate").val()
                },
                dataType: "json",
                success: function (Response) {
                    success = true;
                },
                error: function (request, status, error) {
                    swal("Error Creating Incident");
                }
            }).then(function (data) {
                for (i = 0; i <= witnessArray.length - 1; i++) {
                    saveIncidentWitness(witnessArray[i]);
                }
            });

        });

        function loadWCIncidentWitness(id) {

            var url = "http://localhost:52839/api/InsuranceWCClaims/GetWCInvestigationWitnessByWCInvestigaionID/" + id;
            //var url = $("#localApiDomain").val() + "InsuranceWCClaims/GetWCInvestigationWitnessByWCInvestigaionID/" + id;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    $("#NumberOfWitnesses").val(data.length);
                    var thisElementNum = 0;
                    var WitnessInfoBuild = "";

                    for (i = data.length - 1; i >= 0; i--) {
                        WitnessInfoBuild = InvestigationWitnessInfo;
                        WitnessInfoBuild = WitnessInfoBuild.replace(/witness1/g, 'witness' + (i + 1).toString());
                        WitnessInfoBuild = WitnessInfoBuild.replace('NO. 1', 'NO.' + (i + 1).toString());

                        $("#mainTable").after(WitnessInfoBuild);
                        var newWitness = '#Infowitness' + (i + 1).toString();
                        witnessArray.push(newWitness);
                        
                        $("#witness" + (i + 1).toString() + "name").val(data[i].WCIWitnessName);
                        $("#witness" + (i + 1).toString() + "Address").val(data[i].WCIWitnessAddress);
                        $("#witness" + (i + 1).toString() + "City").val(data[i].WCIWitnessCity);
                        $("#witness" + (i + 1).toString() + "Zip").val(data[i].WCIWitnessZip);
                        $("#witness" + (i + 1).toString() + "HomePhone").val(data[i].WCIWitnessHomePhone);
                        $("#witness" + (i + 1).toString() + "BusinessPhone").val(data[i].WCIWitnessBusinessPhone);

                        if (thisElementNum == 0) {
                            thisElementNum = $("#NumberOfWitnesses").val();
                        } else {
                            thisElementNum = thisElementNum - 1;
                        }
                        var thisVehicleNumber = data[i].VehicleNumber;
                        var thisState = data[i].StateAbbreviation;

                        $.when(loadWitnessState(thisElementNum, thisState).then(function (thisData) {
                            $("#witness" + thisData[thisData.length - 2].toString() + "State" + " option:contains(" + thisData[thisData.length - 1].toString() + ")").prop('selected', true);
                        }).fail(function (error) {
                            alert("error " + error);
                        })
                        );
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting witness information information.");
                }
            });
        }

        function loadWitnessState(elementNumber, thisState) {
            var dropdown = $('#witness' + elementNumber + 'State');
            dropdown.empty();

            dropdown.append('<option selected="true">State</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/InsuranceLocations/GetStates/";
            var url = $("#localApiDomain").val() + "InsuranceLocations/GetStates/";

            return $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append("<option value='" + data[i].LocationStateID + "' style='font-weight: bold;'>" + data[i].StateAbbreviation + "</option>");
                    }
                    data.push(elementNumber);
                    data.push(thisState);
                },
                error: function (request, status, error) {
                    swal("There was an issue getting witness state information.");
                }
            });
        }

        function saveIncidentWitness(claimID, item, edit) {
            if (edit == false) {
                var thisClaimID = claimID;
                //var url = "http://localhost:52839/api/InsuranceIncidents/PostThirdPartyVehicle/";
                var url = $("#localApiDomain").val() + "InsuranceIncidents/PostThirdPartyVehicle/";
            } else {
                var thisClaimID = $(item).find("input[id*='ClaimID']").val();
                //var url = "http://localhost:52839/api/InsuranceIncidents/PutThirdPartyVehicle/";
                var url = $("#localApiDomain").val() + "InsuranceIncidents/PutThirdPartyVehicle/";
            }

            var CustomerName = $(item).find("input[id*='CustomerName']").val();
            var CustomerEmailAddress = $(item).find("input[id*='CustomerEmail']").val();;
            var CustomerStreetAddress = $(item).find("input[id*='CStreetAddress']").val();
            var CustomerCity = $(item).find("input[id*='City']").val();
            var CustomerStateID = $(item).find("select[id*='State']").val();;
            var CustomerZip = $(item).find("input[id*='Zip']").val();
            var CustomerPhoneMobile = $(item).find("input[id*='PhoneMobile']").val();
            var CustomerPhoneHome = $(item).find("input[id*='PhoneHome']").val();
            var CustomerDriverLicenseNumber = $(item).find("input[id*='DriversLicenseNumber']").val();
            var InsuranceCompany = $(item).find("input[id*='InsuranceCompany']").val();
            var InsCompAddress = $(item).find("input[id*='InsuranceAddress']").val();
            var InsCompPhone = $(item).find("input[id*='InsurancePhone']").val();
            var InsCompAgentName = $(item).find("input[id*='AgentName']").val();
            var InsCompEmailAddress = '';
            var InsCompPolicyNumber = $(item).find("input[id*='PolicyNumber']").val();
            var VehicleYear = $(item).find("input[id*='VehicleYear']").val();
            var VehicleMake = $(item).find("input[id*='Make']").val();
            var VehicleModel = $(item).find("input[id*='Model']").val();
            var VehicleColor = $(item).find("input[id*='Color']").val();
            var VehicleVIN = $(item).find("input[id*='VIN']").val();
            var VehicleLicensePlate = $(item).find("input[id*='LicensePlate']").val();
            var VehicleLicensePlateStateID = $(item).find("select[id*='PlateState']").val();
            var Injuries = $(item).find("input[name*='CInjuries']:checked").val();


            $.ajax({
                type: "POST",
                url: url,
                data: {
                    "ClaimID": thisClaimID,
                    "CustomerName": CustomerName,
                    "CustomerEmailAddress": CustomerEmailAddress,
                    "CustomerStreetAddress": CustomerStreetAddress,
                    "CustomerCity": CustomerCity,
                    "CustomerStateID": CustomerStateID,
                    "CustomerZip": CustomerZip,
                    "CustomerPhoneMobile": CustomerPhoneMobile,
                    "CustomerPhoneHome": CustomerPhoneHome,
                    "CustomerDriverLicenseNumber": CustomerDriverLicenseNumber,
                    "InsuranceCompany": InsuranceCompany,
                    "InsCompAddress": InsCompAddress,
                    "InsCompPhone": InsCompPhone,
                    "InsCompAgentName": InsCompAgentName,
                    "InsCompEmailAddress": InsCompEmailAddress,
                    "InsCompPolicyNumber": InsCompPolicyNumber,
                    "VehicleYear": VehicleYear,
                    "VehicleMake": VehicleMake,
                    "VehicleModel": VehicleModel,
                    "VehicleColor": VehicleColor,
                    "VehicleVIN": VehicleVIN,
                    "VehicleLicensePlate": VehicleLicensePlate,
                    "VehicleLicensePlateStateID": VehicleLicensePlateStateID,
                    "Injuries": Injuries,

                },
                dataType: "json",
                success: function (data) {

                },
                error: function (request, status, error) {
                    swal("Error saving third party vehicle");
                },
                complete: function () {

                }
            });
        }

        function loadStates() {
            var dropdown = $('#EmployeeState');

            dropdown.empty();

            dropdown.append('<option selected="true">State</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/InsuranceLocations/GetStates/";
            var url = $("#localApiDomain").val() + "InsuranceLocations/GetStates/";

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append("<option value='" + data[i].LocationStateID + "' style='font-weight: bold;'>" + data[i].StateAbbreviation + "</option>");
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting state information.");
                }
            });
        }


        function loadLocations(element) {
            var locationString = $("#userVehicleLocation").val();
            var dropdown = $(element);

            dropdown.empty();

            dropdown.append('<option selected="true">Location</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/InsuranceLocations/GetUserLocations/" + locationString;
            var url = $("#localApiDomain").val() + "InsuranceLocations/GetUserLocations/" + locationString;

            return $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append($("<option style='font-weight: bold;'></option>").attr("value", data[i].LocationId).text(data[i].LocationName));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting location information.");
                }
            });
        }
    </script>
    <style>
        .font0342
	        {color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;}
        .xl15342
	        {padding:0px;
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
        .xl67342
	        {padding:0px;
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
        .xl68342
	        {padding:0px;
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
        .xl69342
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
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
        .xl70342
	        {padding:0px;
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
        .xl71342
	        {padding:0px;
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
        .xl72342
	        {padding:0px;
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
        .xl73342
	        {padding:0px;
	        mso-ignore:padding;
	        color:white;
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
        .xl74342
	        {padding:0px;
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
        .xl75342
	        {padding:0px;
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
        .xl76342
	        {padding:0px;
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
        .xl77342
	        {padding:0px;
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
        .xl78342
	        {padding:0px;
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
        .xl79342
	        {padding:0px;
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
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl80342
	        {padding:0px;
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
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl81342
	        {padding:0px;
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
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl82342
	        {padding:0px;
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
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl83342
	        {padding:0px;
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
	        border-bottom:none;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl84342
	        {padding:0px;
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
	        white-space:normal;}
        .xl85342
	        {padding:0px;
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
	        border-top:none;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl86342
	        {padding:0px;
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
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:none;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl87342
	        {padding:0px;
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
	        border-top:none;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl88342
	        {padding:0px;
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
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl89342
	        {padding:0px;
	        mso-ignore:padding;
	        color:white;
	        font-size:11.0pt;
	        font-weight:400;
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
        .xl90342
	        {padding:0px;
	        mso-ignore:padding;
	        color:red;
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
        .xl91342
	        {padding:0px;
	        mso-ignore:padding;
	        color:windowtext;
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
        .xl92342
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        background:#D9D9D9;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl93342
	        {padding:0px;
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
	        border-top:.5pt solid windowtext;
	        border-right:.5pt solid windowtext;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl94342
	        {padding:0px;
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
	        border-bottom:none;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl95342
	        {padding:0px;
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
	        border-bottom:none;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl96342
	        {padding:0px;
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
	        border-top:none;
	        border-right:none;
	        border-bottom:none;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl97342
	        {padding:0px;
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
	        border-top:none;
	        border-right:.5pt solid windowtext;
	        border-bottom:none;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl98342
	        {padding:0px;
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
	        border-top:none;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl99342
	        {padding:0px;
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
	        border-top:none;
	        border-right:.5pt solid windowtext;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl100342
	        {padding:0px;
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
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:none;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl101342
	        {padding:0px;
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
	        border-top:.5pt solid windowtext;
	        border-right:.5pt solid windowtext;
	        border-bottom:none;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl102342
	        {padding:0px;
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
	        border-top:none;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl103342
	        {padding:0px;
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
	        border-top:none;
	        border-right:.5pt solid windowtext;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl104342
	        {padding:0px;
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
	        vertical-align:top;
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl105342
	        {padding:0px;
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
	        vertical-align:top;
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl106342
	        {padding:0px;
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
	        vertical-align:top;
	        border-top:.5pt solid windowtext;
	        border-right:.5pt solid windowtext;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl107342
	        {padding:0px;
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
	        border:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}

        .auto-style1 {
            height: 20px;
        }

        .auto-style2 {
            height: 52px;
        }

        .auto-style3 {
            height: 81px;
        }

    </style>
        

        <div align=center>
        <input type="text" id="WCClaimID" style ="display:none" />
            <input type="text" id="WCInvestigationID" style ="display:none" />
        <table id="mainTable" border=0 cellpadding=0 cellspacing=0 width=794 style='border-collapse:
         collapse;table-layout:fixed;width:598pt'>
         <col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>
         <col width=191 style='mso-width-source:userset;mso-width-alt:6985;width:143pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=162 style='mso-width-source:userset;mso-width-alt:5924;width:122pt'>
         <col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl15342 width=18 style='height:15.75pt;width:14pt'><a
          name="RANGE!A1:I110"></a></td>
          <td class=xl15342 width=191 style='width:143pt'></td>
          <td class=xl15342 width=17 style='width:13pt'></td>
          <td class=xl15342 width=177 style='width:133pt'></td>
          <td class=xl15342 width=17 style='width:13pt'></td>
          <td class=xl15342 width=177 style='width:133pt'></td>
          <td class=xl15342 width=17 style='width:13pt'></td>
          <td class=xl15342 width=162 style='width:122pt'></td>
          <td class=xl15342 width=18 style='width:14pt'></td>
         </tr>
         <tr height=22 style='height:16.5pt'>
          <td height=22 class=xl15342 style='height:16.5pt'></td>
          <td colspan=7 class=xl76342 style='border-right:1.0pt solid black'>WORKERS
          COMPENSATION - INVESTIGATION OF ACCIDENT</td>
          <td class=xl69342></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl15342 style='height:15.75pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl15342 style='height:15.75pt'></td>
          <td class=xl69342>PCA WC #</td>
          <td class=xl15342></td>
          <td class=xl72342><input type='text' id='WorkerCompNumber' style='border:none' /></td>
          <td class=xl15342></td>
          <td class=xl69342>PCA INCIDENT/CLAIMS #</td>
          <td class=xl15342></td>
          <td class=xl72342><input type='text' id='IncidentNumber' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=7 class=xl89342>EMPLOYEE INFORMATION</td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl73342></td>
          <td class=xl73342></td>
          <td class=xl73342></td>
          <td class=xl73342></td>
          <td class=xl73342></td>
          <td class=xl73342></td>
          <td class=xl73342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>Name</td>
          <td class=xl15342></td>
          <td colspan=5 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='EmployeeName' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>Street Address</td>
          <td class=xl15342></td>
          <td colspan=5 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='EmployeeAddress' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>City</td>
          <td class=xl15342></td>
          <td class=xl67342 style='border-top:none'><input type='text' id='EmployeeCity' style='border:none' /></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>State</td>
          <td class=xl15342></td>
          <td class=xl67342 style='border-top:none'><select id="EmployeeState" style="border:none"></select></td>
          <td class=xl75342></td>
          <td class=xl75342>Zip Code</td>
          <td class=xl75342></td>
          <td class=xl67342><input type='text' id='EmployeeZip' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>Social Security No.<span style='mso-spacerun:yes'> </span></td>
          <td class=xl15342></td>
          <td class=xl67342 style='border-top:none'><input type='text' id='EmployeeSSN' style='border:none' maxlength='4' placeholder="SSN Last 4" /></td>
          <td class=xl15342></td>
          <td class=xl15342>Date of Birth</td>
          <td class=xl15342></td>
          <td class=xl67342 style='border-top:none'><input type='date' id='EmployeeDOB' style='border:none' class="auto-style1" /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>Home Phone No.<span style='mso-spacerun:yes'> </span></td>
          <td class=xl15342></td>
          <td class=xl67342 style='border-top:none'><input type='text' id='EmployeeHomePhone' style='border:none' /></td>
          <td class=xl15342></td>
          <td class=xl15342>Age</td>
          <td class=xl15342></td>
          <td class=xl67342 style='border-top:none'><input type='text' id='EmployeeAge' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>Marital Status</td>
          <td class=xl15342></td>
          <td class=xl67342 style='border-top:none'><input name="marital" type="radio" value="married" style="width:25px" />Married<input name="marital" type="radio" value="single" style="width:25px" />Single</td>
          <td class=xl15342></td>
          <td class=xl15342>Number of Dependents</td>
          <td class=xl15342></td>
          <td class=xl67342 style='border-top:none'><input type='text' id='EmployeeNumberOfDependents' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl67342><input name="sex" type="radio" value="male" style="width:25px" />Male<input name="sex" type="radio" value="female" style="width:25px" />Female</td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=3>City and facility/lot where regularly employed:</td>
          <td class=xl15342></td>
          <td colspan=3 class=xl79342 style='border-right:.5pt solid black'><select id="employeeWorkLocation" style="border:none"></select></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>Date of Hire</td>
          <td class=xl15342></td>
          <td class=xl67342><input type="date" id="employeeDateHire" style="border:none" /></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=3>Was employee required to miss any work?<input name="employeeMissWork" type="radio" value="1" style="width:25px" />Yes<input name="employeeMissWork" type="radio" value="0" style="width:25px" />No</td>
          <td class=xl15342></td>
          <td class=xl15342 colspan=2>If yes, date employee returned<span
          style='display:none'>:</span></td>
          <td class=xl67342><input type="date" id="employeeDateReturned" style="border:none" /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=3>Was employee paid for the day of injury?<input name="paidDayOfInjury" type="radio" value="1" style="width:25px" />Yes<input name="paidDayOfInjury" type="radio" value="0" style="width:25px" />No</td>
          <td class=xl15342></td>
          <td class=xl15342>Wage Rate</td>
          <td class=xl15342></td>
          <td class=xl68342 style='border-top:none'><input type='text' id='EmployeeWageRate' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=3>How long has employee worked at the location of
          incident?</td>
          <td class=xl15342></td>
          <td colspan=3 class=xl81342 style='border-right:.5pt solid black'><input type='text' id='EmployeeHowLongWorkedAtLocation' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>Average hours worked per day:</td>
          <td class=xl15342></td>
          <td class=xl67342><input type='text' id='EmployeeAverageHoursWorkedPerDay' style='border:none' /></td>
          <td class=xl15342></td>
          <td class=xl15342>Average days per week:</td>
          <td class=xl15342></td>
          <td class=xl67342 style='border-top:none'><input type='text' id='EmployeeAverageDaysWorkedPerWeek' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=2>Employee's usual days off work:</td>
          <td class=xl67342 style='border-top:none'><input type='text' id='EmployeeUsualDaysOff' style='border:none' /></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=7 class=xl89342>ACCIDENT INFORMATION</td>
          <td class=xl15342></td>
         </tr>
         <tr class=xl15342 height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl90342></td>
          <td class=xl73342></td>
          <td class=xl73342></td>
          <td class=xl73342></td>
          <td class=xl73342></td>
          <td class=xl73342></td>
          <td class=xl73342></td>
          <td class=xl15342></td>
         </tr>
         <tr class=xl15342 height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl91342>LOCATION<span style='mso-spacerun:yes'>  </span></td>
          <td class=xl73342></td>
          <td class=xl67342><select id="accidentLocation" style="border:none"></select></td>
          <td class=xl73342></td>
          <td class=xl73342></td>
          <td class=xl73342></td>
          <td class=xl73342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>Injury Date and Time</td>
          <td class=xl15342></td>
          <td class=xl67342 style='border-top:none'><input type="datetime-local" id="accidentInjuryDateTime" style="border:none;font-size: 11.5px;" /></td>
          <td class=xl15342></td>
          <td class=xl15342 colspan=3>Was the accident on employer's premises?<input name="onEmployersPremises" type="radio" value="1" style="width:25px" />Yes<input name="onEmployersPremises" type="radio" value="0" style="width:25px" />No</td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=2>Location where accident occurred</td>
          <td colspan=5 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='AccidentLocationSpecific' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342>Time Shift Began</td>
          <td class=xl15342></td>
          <td class=xl67342 style='border-top:none'><input type="datetime-local" id="accidentShiftBeginDateTime" style="border:none;font-size: 11.5px;" /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>Date employer was notified</td>
          <td class=xl15342></td>
          <td class=xl15342 style=''><input type="date" id="accidentEmployerNotifiedDate" style="" /></td>
          <td class=xl15342></td>
          <td class=xl15342>Who was notified?</td>
          <td class=xl73342></td>
          <td class=xl67342 style='border-top:none'><input type='text' id='accidentWhoWasNotified' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=7 class=xl89342>DESCRIPTION OF INJURY</td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342><span style='mso-spacerun:yes'> </span></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=7>What part of the body was injured?<span
          style='mso-spacerun:yes'>  </span>(Be SPECIFIC: i.e., right index finger,
          right upper arm, lower back, left knee, etc.)</td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=7 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='injuryBodyPart' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=4>What was the nature of injury? (i.e., burn,
          fracture, strain, etc.)</td>
          <td colspan=3 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='injuryNature' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=3>Describe what happened. Be SPECIFIC</td>
          <td class=xl15342></td>
          <td colspan=3 class=xl15342</td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=7 rowspan=3 class=xl94342 width=758 style='border-right:.5pt solid black;
          border-bottom:.5pt solid black;width:570pt'>
              <textarea id="injuryCause" class="auto-style2" cols="20" name="S1" style="border:none"></textarea></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=4>What was the employee doing immediately preceding
          the incident<span style='display:none'>nt?</span></td>
          <td colspan=3 class=xl75342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=7 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='injuryImmediatelyBefore' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=5>Are you aware of any handicap this employee had
          prior to the injury?<input name="awareHandicap" type="radio" value="1" style="width:25px" />Yes<input name="awareHandicap" type="radio" value="0" style="width:25px" />No</td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>If yes, describe:</td>
          <td class=xl15342></td>
          <td colspan=5 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='injuryAwareOfHandicap' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>Was any property damaged?</td>
          <td class=xl15342></td>
          <td class=xl15342><input name="propertyDamage" type="radio" value="1" style="width:25px" />Yes<input name="propertyDamage" type="radio" value="0" style="width:25px" />No</td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>If yes, describe:</td>
          <td class=xl15342></td>
          <td colspan=5 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='injuryPropertyDamageDesc' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=3>Was safety equipment provided?<input name="safetyEquipmentProvided" type="radio" value="1" style="width:25px" />Yes<input name="safetyEquipmentProvided" type="radio" value="0" style="width:25px" />No</td>
          <td class=xl15342></td>
          <td class=xl15342>Was it used?<span style='mso-spacerun:yes'> </span></td>
          <td class=xl15342></td>
          <td class=xl15342><input name="safetyEquipmentUsed" type="radio" value="1" style="width:25px" />Yes<input name="safetyEquipmentUsed" type="radio" value="0" style="width:25px" />No</td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl69342>NUMBER OF WITNESSES:</td>
          <td class=xl15342></td>
          <td class=xl67342><input type='text' id='NumberOfWitnesses' style='border:none' /></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
        </table>
        <table border=0 cellpadding=0 cellspacing=0 width=794 style='border-collapse:
         collapse;table-layout:fixed;width:598pt'>
         <col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>
         <col width=191 style='mso-width-source:userset;mso-width-alt:6985;width:143pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=162 style='mso-width-source:userset;mso-width-alt:5924;width:122pt'>
         <col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=7 class=xl89342>TREATMENT</td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>Employee Name:</td>
          <td class=xl15342></td>
          <td colspan=5 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='treatmentEmployeeName' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=2>Employee went to (check one):</td>
          <td class=xl15342 colspan="5">
              <input name="treatmentFacility" type="radio" value="Clinic" style="width:25px" checked="checked" />Clinic
              <input name="treatmentFacility" type="radio" value="Hospital" style="width:25px" />Hospital
              <input name="treatmentFacility" type="radio" value="Emergency Room" style="width:25px" />Emergency Room
              <input name="treatmentFacility" type="radio" value="First Aid" style="width:25px" />First Aid
              <input name="treatmentFacility" type="radio" value="Urgent Care" style="width:25px" />Urgent Care
          </td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=3>Name Describe any first-aid administered; state
          by whom:</td>
          <td class=xl15342></td>
          <td colspan=3 class=xl75342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=7 rowspan=2 class=xl100342 width=758 style='border-right:.5pt solid black;
          border-bottom:.5pt solid black;width:570pt'>
              <textarea id="treatmentFirstAidDescWhom" cols="20" name="S2" rows="2"></textarea></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=5>Name and Address of Clinic, Hospital, Emergency
          Room or Urgent Care:</td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=7 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='treatmentFacility' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=3>Name, Address &amp; Phone No. of Treating
          Physician:</td>
          <td class=xl15342></td>
          <td colspan=3 class=xl75342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=7 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='treatmentPhysician' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=3>Was employee sent to take a drug test?<input name="employeeDrugTest" style="width:25px" type="radio" value="11" />Yes<input name="employeeDrugTest" style="width:25px" type="radio" value="01" />No</td>
          <td class=xl15342></td>
          <td colspan=3 rowspan=2 class=xl84342 width=356 style='width:268pt'>*If no,
          Manager needs to forward a separate explanation to the insurance Department
          to document reason no test was ordered.</td>
          <td class=xl15342></td>
         </tr>
         <tr height=40 style='mso-height-source:userset;height:30.0pt'>
          <td height=40 class=xl15342 style='height:30.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>Name of drug testing facility:<span
          style='mso-spacerun:yes'> </span></td>
          <td class=xl15342></td>
          <td colspan=5 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='treatmentDrugTestFacility' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=7>Were notices and posted doctor panels explained
          to employee and supporting document signed?<span
          style='mso-spacerun:yes'><input name="documentSigned" type="radio" value="1" style="width:25px" />Yes<input name="documentSigned" type="radio" value="0" style="width:25px" />No</td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=7 class=xl89342>CAUSE</td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=3>Please indicate the cause of the illness or
          incident:</td>
          <td colspan=4 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='causeDesc' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl75342></td>
          <td class=xl75342></td>
          <td class=xl75342></td>
          <td class=xl75342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=3>Was a policy in effect regarding cause?<input name="policyInAffect" type="radio" value="1" style="width:25px" />Yes<input name="policyInAffect" type="radio" value="0" style="width:25px" />No</td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=5>What was the policy in effect? (Either describe
          or attach a copy of the policy)</td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=7 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='causePolicyDesc' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=3>Was employee aware of the policy?<input name="employeeAwareOfPolicy" type="radio" value="1" style="width:25px" />Yes<input name="employeeAwareOfPolicy" type="radio" value="0" style="width:25px" />No</td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342 colspan=3>How was employee notified of the policy?<span
          style='mso-spacerun:yes'> </span></td>
          <td colspan=4 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='causePolicyNotificationType' style='border:none' /></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=7 class=xl89342>EMPLOYEE'S COMMENTS*</td>
          <td class=xl15342></td>
         </tr>
         <tr height=92 style='mso-height-source:userset;height:69.0pt'>
          <td height=92 class=xl15342 style='height:69.0pt'></td>
          <td colspan=7 class=xl104342 width=758 style='border-right:.5pt solid black;
          width:570pt'>
              <textarea id="employeeComments" class="auto-style3" cols="20" name="S3"></textarea></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=7 class=xl74342>*This section must be completed</td>
          <td class=xl15342></td>
         </tr>
         <tr height=10 style='mso-height-source:userset;height:7.5pt'>
          <td height=10 class=xl15342 style='height:7.5pt'></td>
          <td class=xl74342></td>
          <td class=xl74342></td>
          <td class=xl74342></td>
          <td class=xl74342></td>
          <td class=xl74342></td>
          <td class=xl74342></td>
          <td class=xl74342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=3 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='employeeSignature' style='border:none' /></td>
          <td class=xl74342></td>
          <td class=xl107342><input type='date' id='employeeSignatureDate' style='border:none' /></td>
          <td class=xl74342></td>
          <td class=xl74342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>Employee's Signature</td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342>Date</td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=7 class=xl89342>SUPERVISOR'S COMMENTS*</td>
          <td class=xl15342></td>
         </tr>
         <tr height=92 style='mso-height-source:userset;height:69.0pt'>
          <td height=92 class=xl15342 style='height:69.0pt'></td>
          <td colspan=7 class=xl104342 width=758 style='border-right:.5pt solid black;
          width:570pt'>
              <textarea id="supervisorComments" class="auto-style3" cols="20" name="S4" rows="1"></textarea></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=7 class=xl74342>*This section must be completed</td>
          <td class=xl15342></td>
         </tr>
         <tr height=10 style='mso-height-source:userset;height:7.5pt'>
          <td height=10 class=xl15342 style='height:7.5pt'></td>
          <td class=xl74342></td>
          <td class=xl74342></td>
          <td class=xl74342></td>
          <td class=xl74342></td>
          <td class=xl74342></td>
          <td class=xl74342></td>
          <td class=xl74342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td colspan=3 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='supervisorSignature' style='border:none' /></td>
          <td class=xl74342></td>
          <td class=xl107342><input type='date' id='supervisorSignatureDate' style='border:none' /></td>
          <td class=xl74342></td>
          <td class=xl74342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342>Supervisor's Signature</td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342>Date</td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342><input id="save" type="button" value="Save" style="background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl15342></td>
          <td class=xl15342><input id="submit" type="button" value="Submit" style="background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl15342></td>
          <td class=xl15342><input id="printReport" type="button" value="Print Report" style="background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl15342 style='height:15.0pt'></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
          <td class=xl15342></td>
         </tr>
         <![if supportMisalignedColumns]>
         <tr height=0 style='display:none'>
          <td width=18 style='width:14pt'></td>
          <td width=191 style='width:143pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=162 style='width:122pt'></td>
          <td width=18 style='width:14pt'></td>
         </tr>
         <![endif]>
        </table>

        </div>

        <script>
            var InvestigationWitnessInfo = "<table id='Infowitness1' class='witnessSection' border=0 cellpadding=0 cellspacing=0 width=794 style='border-collapse:" +
				"collapse;table-layout:fixed;width:598pt'>" +
				"<col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>" +
				"<col width=191 style='mso-width-source:userset;mso-width-alt:6985;width:143pt'>" +
				"<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
				"<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
				"<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
				"<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
				"<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
				"<col width=162 style='mso-width-source:userset;mso-width-alt:5924;width:122pt'>" +
				"<col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>" +
				"<tr height=20 style='height:15.0pt'>" +
				"<td height=20 class=xl15342 style='height:15.0pt'></td>" +
				"<td class=xl92342>WITNESS NO. 1</td>" +
				"<td class=xl15342></td>" +
				"<td class=xl15342></td>" +
				"<td class=xl15342></td>" +
				"<td class=xl15342></td>" +
				"<td class=xl15342></td>" +
				"<td class=xl15342></td>" +
				"<td class=xl15342></td>" +
				"</tr>" +
				"<tr height=20 style='height:15.0pt'>" +
				"<td height=20 class=xl15342 style='height:15.0pt'></td>" +
				"<td class=xl15342>Witness Name</td>" +
				"<td class=xl15342></td>" +
				"<td colspan=5 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='witness1name' style='border:none' /></td>" +
				"<td class=xl15342></td>" +
				"</tr>" +
				"<tr height=20 style='height:15.0pt'>" +
				"<td height=20 class=xl15342 style='height:15.0pt'></td>" +
				"<td class=xl15342>Street Address</td>" +
				"<td class=xl15342></td>" +
				"<td colspan=5 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='witness1Address' style='border:none' /></td>" +
				"<td class=xl15342></td>" +
				"</tr>" +
				"<tr height=20 style='height:15.0pt'>" +
				"<td height=20 class=xl15342 style='height:15.0pt'></td>" +
				"<td class=xl15342>City<span style='mso-spacerun:yes'> </span></td>" +
				"<td class=xl15342></td>" +
				"<td colspan=5 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='witness1City' style='border:none' /></td>" +
				"<td class=xl15342></td>" +
				"</tr>" +
                "</tr>" +
                "<tr height=20 style='height:15.0pt'>" +
                "<td height=20 class=xl15342 style='height:15.0pt'></td>" +
                "<td class=xl15342>State<span style='mso-spacerun:yes'> </span></td>" +
                "<td class=xl15342></td>" +
                "<td colspan=5 class=xl79342 style='border-right:.5pt solid black'><select id='witness1State' type='text' style='border:none;'></select></td>" +
                "<td class=xl15342></td>" +
                "</tr>" +
				"<tr height=20 style='height:15.0pt'>" +
				"<td height=20 class=xl15342 style='height:15.0pt'></td>" +
				"<td class=xl15342>Zip Code</td>" +
				"<td class=xl15342></td>" +
				"<td colspan=5 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='witness1Zip' style='border:none' /></td>" +
				"<td class=xl15342></td>" +
				"</tr>" +
				"<tr height=20 style='height:15.0pt'>" +
				"<td height=20 class=xl15342 style='height:15.0pt'></td>" +
				"<td class=xl15342>Home Phone #</td>" +
				"<td class=xl15342></td>" +
				"<td colspan=5 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='witness1HomePhone' style='border:none' /></td>" +
				"<td class=xl15342></td>" +
				"</tr>" +
				"<tr height=20 style='height:15.0pt'>" +
				"<td height=20 class=xl15342 style='height:15.0pt'></td>" +
				"<td class=xl15342>Business Phone #</td>" +
				"<td class=xl15342></td>" +
				"<td colspan=5 class=xl79342 style='border-right:.5pt solid black'><input type='text' id='witness1BusinessPhone' style='border:none' /></td>" +
				"<td class=xl15342></td>" +
				"</tr>" +
				"<tr height=20 style='height:15.0pt'>" +
				"<td height=20 class=xl15342 style='height:15.0pt'></td>" +
				"<td class=xl15342></td>" +
				"<td class=xl15342></td>" +
				"<td class=xl15342></td>" +
				"<td class=xl15342></td>" +
				"<td class=xl15342></td>" +
				"<td class=xl15342></td>" +
				"<td class=xl15342></td>" +
				"<td class=xl15342></td>" +
				"</tr>" +
				"</table> ";
        </script>


</asp:Content>

