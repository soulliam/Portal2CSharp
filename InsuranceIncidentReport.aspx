<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceIncidentReport.aspx.cs" Inherits="InsuranceIncidentReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script>
        var group = '<%= Session["groupList"] %>';
        var VehiclePCAArray = [];
        var ThirdPartyVehiclePCAArray = [];

        $(document).ready(function () {

            turnOffAutoComplete();
            
            loadLocations();
            loadStates();

            $("#printReport").on('click', function () {
                $("#printReport").hide();
                $("#saveContinue").hide();
                window.print();
                $(document).one('click', function () {
                    $("#printReport").show();
                    $("#saveContinue").show();
                });
            });

            $("#saveContinue").on('click', function () {

                var PCAVehicles = $("#IncidentNumPCAVehicles").val();
                var thirdPartyVehicles = $("#IncidentNumThirdPartyVehicle").val();
                var numberOfVehiclesInvolved = Number(PCAVehicles) + Number(thirdPartyVehicles);
                var creator = $("#txtLoggedinUsername").val().replace('PCA\\', '');
                var thisCurrentDate = new Date();

                var edit = false;

                if ($("#MainContent_IncidentID").val() == '') {
                    //var url = "http://localhost:52839/api/InsuranceIncidents/PostIncident/";
                    var url = $("#localApiDomain").val() + "InsuranceIncidents/PostIncident/";
                } else {
                    //var url = "http://localhost:52839/api/InsuranceIncidents/PutIncident/";
                    var url = $("#localApiDomain").val() + "InsuranceIncidents/PutIncident/";
                    edit = true;
                }

                $.ajax({
                    type: "POST",
                    url: url,
                    data: {
                        "IncidentID": $("#MainContent_IncidentID").val(),
                        "IncidentNumber": $("#IncidentNumber").val(),
                        "LocationId": $("#location").children("option:selected").val(),
                        "IncidentStreetAddress": $("#IncidentLoationAddress").val(),
                        "IncidentCity": $("#IncidentLoationCity").val(),
                        "IncidentStateID": $("#IncidentLocationState").children("option:selected").val(),
                        "IncidentZip": $("#IncidentLocationZip").val(),
                        "IncidentPhone": $("#IncidentLocationPhone").val(),
                        "IncidentLotRowSpace": $("#IncidentLocationLRS").val(),
                        "OperationTypeID": $("input[name='operationType']:checked").val(),
                        "IncidentDate": $("#IncidentDate").val(),
                        "IncidentTime": $("#IncidentTime").val(),
                        "IncidentStatusID": 1,
                        "StayDuration": $("#IncidentDuration").val(),
                        "IncidentInjuries": $("input[name='anyInjuries']:checked").val(),
                        "PoliceReportNumber": $("#IncidentPoliceReportNumber").val(),
                        "PoliceReportDate": $("#IncidentPoliceReportDate").val(),
                        "OfficerName": $("#IncidentPoliceOfficersName").val(),
                        "NumberOfVehilesInvolved": numberOfVehiclesInvolved,
                        "PhysicalDamage": $("#PCAPhysicalDamage").children("option:selected").val(),
                        "PhysicalDamageDesc": $("#IncidentPCADamagesDesc").val(),
                        "IncidentCreatedBy": creator,
                        "IncidentCustomerSignature": $("#IncidentCustomerSignature").val(),
                        "IncidentEmployeeSignature": $("#IncidentEmployeeSignature").val(),
                        "IncidentManagerSignature": $("#IncidentManagerSignature").val(),
                        "PCAReceiveDate": DateFormat(thisCurrentDate)
                    },
                    dataType: "json",
                    success: function (Response) {
                        success = true;
                    },
                    error: function (request, status, error) {
                        swal("Error Creating Incident");
                    }
                }).then(function (data) {
                    if (edit == false) {
                        $("#MainContent_IncidentID").val(data);
                        saveClaims(false);
                    } else {
                        saveClaims(true);
                        //UpdateVehicles()
                    }
                }).then(function () {
                    swal({
                        title: 'Save',
                        text: "Successful",
                        confirmButtonColor: '#3085d6',
                        confirmButtonText: 'OK'
                    }).then(function () {
                        window.location.replace("./InsuranceManagerInvestigation.aspx?IncidentID=" + IncidentID);
                    });
                });

            });


            $("#IncidentNumPCAVehicles").on('blur', function () {
                if (isNaN($("#IncidentNumPCAVehicles").val()) == false) {
                    var locationId = $("#location").children("option:selected").val();
                    if (locationId == 'Location') {
                        swal("Pick a location");
                        return;
                    }

                    var vehicleNumber = $("#IncidentNumPCAVehicles").val();
                    var vehicleInfoBuild = "";
                    if (vehicleNumber == 0) {
                        VehiclePCAArray.length = 0;
                        $(".pcaVehicleSection").remove();
                    } else if (vehicleNumber > VehiclePCAArray.length && VehiclePCAArray.length != 0) {
                        var thisElement = 0;
                        for (i = vehicleNumber - VehiclePCAArray.length ; i > 0; i--) {
                            vehicleInfoBuild = pcaVehicleInfo;
                            vehicleInfoBuild = vehicleInfoBuild.replace(/VehiclePCA1/g, 'VehiclePCA' + (VehiclePCAArray.length + 1).toString());
                            vehicleInfoBuild = vehicleInfoBuild.replace('NO. 1', 'NO.' + (VehiclePCAArray.length + 1).toString());
                            var placementTable = '#infoVehiclePCA' + (VehiclePCAArray.length).toString();
                            $(placementTable).after(vehicleInfoBuild);
                            var newVehicle = '#infoVehiclePCA' + (VehiclePCAArray.length + 1).toString();
                            VehiclePCAArray.splice(0, 0, newVehicle);
                            var thisFocus = "#VehiclePCA" + (i).toString() + "EmployeeName";
                            $(thisFocus).focus();

                            if (thisElement == 0){
                                thisElement = VehiclePCAArray.length;
                            }else{
                                thisElement = thisElement + 1
                            }
                             

                            if ($("#VehiclePCA" + thisElement + "FleetNumber").val() == null) {
                                loadPCAVehicles(thisElement.toString());
                                loadPCAVehiclesState(thisElement.toString());
                            }
                        }
                    } else if (vehicleNumber < VehiclePCAArray.length) {
                        var arrayLength = VehiclePCAArray.length;
                        for (i = 0; i <= arrayLength - vehicleNumber - 1; i++) {
                            $(VehiclePCAArray[0]).remove();
                            VehiclePCAArray.splice(0, 1);
                        }
                    } else if (VehiclePCAArray.length == 0) {
                        locationId
                        for (i = $("#IncidentNumPCAVehicles").val() ; i > 0; i--) {
                            vehicleInfoBuild = pcaVehicleInfo;
                            vehicleInfoBuild = vehicleInfoBuild.replace(/VehiclePCA1/g, 'VehiclePCA' + (i).toString());
                            vehicleInfoBuild = vehicleInfoBuild.replace('NO. 1', 'NO.' + (i).toString());
                            if (i == 1) {
                                vehicleInfoBuild = vehicleInfoBuild.replace("'~'", "autofocus");
                            }
                            $("#infoVehiclePCA").after(vehicleInfoBuild);
                            var newVehicle = '#infoVehiclePCA' + (i).toString();
                            VehiclePCAArray.push(newVehicle);
                            var thisFocus = "#VehiclePCA" + (i).toString() + "EmployeeName";
                            $(thisFocus).focus();
                            loadPCAVehicles((i).toString());
                            loadPCAVehiclesState((i).toString());
                        }
                    }
                    window.scrollBy(0, 700); // Scroll 100px downwards
                }
                turnOffAutoComplete();
                

            });

            $("#IncidentNumThirdPartyVehicle").on('blur', function () {
                if (isNaN($("#IncidentNumThirdPartyVehicle").val()) == false) {
                    var thirdPartyvehicleNumber = $("#IncidentNumThirdPartyVehicle").val();
                    var vehicleThirdPartyInfoBuild = "";
                    if (thirdPartyvehicleNumber == 0) {
                        ThirdPartyVehiclePCAArray.length = 0;
                        $(".pcaVehicleThirdPartySection").remove();
                    } else if (thirdPartyvehicleNumber > ThirdPartyVehiclePCAArray.length && ThirdPartyVehiclePCAArray.length != 0) {
                        var thisElement = 0;
                        for (i = thirdPartyvehicleNumber - ThirdPartyVehiclePCAArray.length ; i > 0; i--) {
                            vehicleThirdPartyInfoBuild = pcaThirdPersonOrVehicle;
                            vehicleThirdPartyInfoBuild = vehicleThirdPartyInfoBuild.replace(/ThirdPartyVehiclePCA1/g, 'ThirdPartyVehiclePCA' + (ThirdPartyVehiclePCAArray.length + 1).toString());
                            vehicleThirdPartyInfoBuild = vehicleThirdPartyInfoBuild.replace('NO. 1', 'NO.' + (ThirdPartyVehiclePCAArray.length + 1).toString());
                            var placementTable = '#ThirdPartyVehiclePCA' + (ThirdPartyVehiclePCAArray.length).toString();
                            $(placementTable).after(vehicleThirdPartyInfoBuild);
                            var newVehicle = '#ThirdPartyVehiclePCA' + (ThirdPartyVehiclePCAArray.length + 1).toString();
                            ThirdPartyVehiclePCAArray.splice(0, 0, newVehicle);
                            var thisFocus = "#ThirdPartyVehiclePCA" + (i).toString() + "CustomerName";

                            if (thisElement == 0) {
                                thisElement = ThirdPartyVehiclePCAArray.length;
                            } else {
                                thisElement = thisElement + 1
                            }

                            if ($("#ThirdPartyVehiclePCA" + thisElement + "State").val() == null) {
                                loadThirdPartyVehiclesState(thisElement.toString(), '', 'State');
                                loadThirdPartyVehiclesState(thisElement.toString(), '', 'PlateState');
                            }

                            $(thisFocus).focus();
                        }
                    } else if (thirdPartyvehicleNumber < ThirdPartyVehiclePCAArray.length) {
                        var arrayLength = ThirdPartyVehiclePCAArray.length;
                        for (i = 0; i <= arrayLength - thirdPartyvehicleNumber - 1; i++) {
                            $(ThirdPartyVehiclePCAArray[0]).remove();
                            ThirdPartyVehiclePCAArray.splice(0, 1);
                        }
                    } else if (ThirdPartyVehiclePCAArray.length == 0) {
                        for (i = $("#IncidentNumThirdPartyVehicle").val() ; i > 0; i--) {
                            vehicleThirdPartyInfoBuild = pcaThirdPersonOrVehicle;
                            vehicleThirdPartyInfoBuild = vehicleThirdPartyInfoBuild.replace(/ThirdPartyVehiclePCA1/g, 'ThirdPartyVehiclePCA' + (i).toString());
                            vehicleThirdPartyInfoBuild = vehicleThirdPartyInfoBuild.replace('NO. 1', 'NO.' + (i).toString());
                            if (i == 1) {
                                vehicleThirdPartyInfoBuild = vehicleThirdPartyInfoBuild.replace("'~'", "autofocus");
                            }
                            $("#thirdPartyTable").after(vehicleThirdPartyInfoBuild);
                            var newVehicle = '#ThirdPartyVehiclePCA' + (i).toString();
                            ThirdPartyVehiclePCAArray.push(newVehicle);
                            var thisFocus = "#ThirdPartyVehiclePCA" + (i).toString() + "CustomerName";
                            loadThirdPartyVehiclesState((i).toString(), '', 'State');
                            loadThirdPartyVehiclesState((i).toString(), '', 'PlateState');
                            $(thisFocus).focus();
                        }
                    }
                    window.scrollBy(0, 100); // Scroll 100px downwards
                }
                turnOffAutoComplete();
                
            });

            $(document).on('keypress', function (e) {
                if (e.keyCode == 13) {
                    if (document.activeElement.id == 'IncidentNumPCAVehicles') {
                        var locationId = $("#location").children("option:selected").val();
                        if (locationId == 'Location') {
                            swal("Pick a location");
                            return;
                        }

                        if (isNaN($("#IncidentNumPCAVehicles").val()) == false) {
                            var vehicleNumber = $("#IncidentNumPCAVehicles").val();
                            var vehicleInfoBuild = "";
                            if (vehicleNumber == 0) {
                                VehiclePCAArray.length = 0;
                                $(".pcaVehicleSection").remove();
                            } else if (vehicleNumber > VehiclePCAArray.length && VehiclePCAArray.length != 0) {
                                var thisElement = 0;
                                for (i = vehicleNumber - VehiclePCAArray.length ; i > 0; i--) {
                                    vehicleInfoBuild = pcaVehicleInfo;
                                    vehicleInfoBuild = vehicleInfoBuild.replace(/VehiclePCA1/g, 'VehiclePCA' + (VehiclePCAArray.length + 1).toString());
                                    vehicleInfoBuild = vehicleInfoBuild.replace('NO. 1', 'NO.' + (VehiclePCAArray.length + 1).toString());
                                    var placementTable = '#infoVehiclePCA' + (VehiclePCAArray.length).toString();
                                    $(placementTable).after(vehicleInfoBuild);
                                    var newVehicle = '#infoVehiclePCA' + (VehiclePCAArray.length + 1).toString();
                                    VehiclePCAArray.splice(0, 0, newVehicle);

                                    if (thisElement == 0) {
                                        thisElement = VehiclePCAArray.length;
                                    } else {
                                        thisElement = thisElement + 1
                                    }


                                    if ($("#VehiclePCA" + thisElement + "FleetNumber").val() == null) {
                                        loadPCAVehicles(thisElement.toString());
                                        loadPCAVehiclesState(thisElement.toString());
                                    }
                                }
                            } else if (vehicleNumber < VehiclePCAArray.length) {
                                var arrayLength = VehiclePCAArray.length;
                                for (i = 0; i <= arrayLength - vehicleNumber - 1; i++) {
                                    $(VehiclePCAArray[0]).remove();
                                    VehiclePCAArray.splice(0, 1);
                                }
                            } else if (VehiclePCAArray.length == 0) {
                                for (i = $("#IncidentNumPCAVehicles").val() ; i > 0; i--) {
                                    vehicleInfoBuild = pcaVehicleInfo;
                                    vehicleInfoBuild = vehicleInfoBuild.replace(/VehiclePCA1/g, 'VehiclePCA' + (i).toString());
                                    vehicleInfoBuild = vehicleInfoBuild.replace('NO. 1', 'NO.' + (i).toString());
                                    if (i == 1) {
                                        vehicleInfoBuild = vehicleInfoBuild.replace("'~'", "autofocus");
                                    }
                                    $("#infoVehiclePCA").after(vehicleInfoBuild);
                                    var newVehicle = '#infoVehiclePCA' + (i).toString();
                                    VehiclePCAArray.push(newVehicle);
                                    loadPCAVehicles((i).toString());
                                    loadPCAVehiclesState((i).toString());
                                }
                            }
                        }
                    }

                    if (document.activeElement.id == 'IncidentNumThirdPartyVehicle') {
                        if (isNaN($("#IncidentNumThirdPartyVehicle").val()) == false) {
                            var thirdPartyvehicleNumber = $("#IncidentNumThirdPartyVehicle").val();
                            var vehicleThirdPartyInfoBuild = "";
                            if (thirdPartyvehicleNumber == 0) {
                                ThirdPartyVehiclePCAArray.length = 0;
                                $(".pcaVehicleThirdPartySection").remove();
                            } else if (thirdPartyvehicleNumber > ThirdPartyVehiclePCAArray.length && ThirdPartyVehiclePCAArray.length != 0) {
                                var thisElement = 0;
                                for (i = thirdPartyvehicleNumber - ThirdPartyVehiclePCAArray.length ; i > 0; i--) {
                                    vehicleThirdPartyInfoBuild = pcaThirdPersonOrVehicle;
                                    vehicleThirdPartyInfoBuild = vehicleThirdPartyInfoBuild.replace(/ThirdPartyVehiclePCA1/g, 'ThirdPartyVehiclePCA' + (ThirdPartyVehiclePCAArray.length + 1).toString());
                                    vehicleThirdPartyInfoBuild = vehicleThirdPartyInfoBuild.replace('NO. 1', 'NO.' + (ThirdPartyVehiclePCAArray.length + 1).toString());
                                    var placementTable = '#ThirdPartyVehiclePCA' + (ThirdPartyVehiclePCAArray.length).toString();
                                    $(placementTable).after(vehicleThirdPartyInfoBuild);
                                    var newVehicle = '#ThirdPartyVehiclePCA' + (ThirdPartyVehiclePCAArray.length + 1).toString();
                                    ThirdPartyVehiclePCAArray.splice(0, 0, newVehicle);

                                    if (thisElement == 0) {
                                        thisElement = ThirdPartyVehiclePCAArray.length;
                                    } else {
                                        thisElement = thisElement + 1
                                    }

                                    if ($("#ThirdPartyVehiclePCA" + thisElement + "State").val() == null) {
                                        loadThirdPartyVehiclesState(thisElement.toString(), '', 'State');
                                        loadThirdPartyVehiclesState(thisElement.toString(), '', 'PlateState');
                                    }
                                }
                            } else if (thirdPartyvehicleNumber < ThirdPartyVehiclePCAArray.length) {
                                var arrayLength = ThirdPartyVehiclePCAArray.length;
                                for (i = 0; i <= arrayLength - thirdPartyvehicleNumber - 1; i++) {
                                    $(ThirdPartyVehiclePCAArray[0]).remove();
                                    ThirdPartyVehiclePCAArray.splice(0, 1);
                                }
                            } else if (ThirdPartyVehiclePCAArray.length == 0) {
                                for (i = $("#IncidentNumThirdPartyVehicle").val() ; i > 0; i--) {
                                    vehicleThirdPartyInfoBuild = pcaThirdPersonOrVehicle;
                                    vehicleThirdPartyInfoBuild = vehicleThirdPartyInfoBuild.replace(/ThirdPartyVehiclePCA1/g, 'ThirdPartyVehiclePCA' + (i).toString());
                                    vehicleThirdPartyInfoBuild = vehicleThirdPartyInfoBuild.replace('NO. 1', 'NO.' + (i).toString());
                                    if (i == 1) {
                                        vehicleThirdPartyInfoBuild = vehicleThirdPartyInfoBuild.replace("'~'", "autofocus");
                                    }
                                    $("#thirdPartyTable").after(vehicleThirdPartyInfoBuild);
                                    var newVehicle = '#ThirdPartyVehiclePCA' + (i).toString();
                                    ThirdPartyVehiclePCAArray.push(newVehicle);
                                    loadThirdPartyVehiclesState((i).toString(), '', 'State');
                                    loadThirdPartyVehiclesState((i).toString(), '', 'PlateState');
                                }
                            }
                        }
                        window.scrollBy(0, 100); // Scroll 100px downwards
                    }
                }


                turnOffAutoComplete();
                
            });

            const params = new URLSearchParams(window.location.search);
            const IncidentID = params.get("IncidentID");

            if (IncidentID != null) {
                $("#MainContent_IncidentID").val(IncidentID);
                loadIncident(IncidentID);
                loadIncidentPCAVehicles(IncidentID);
                loadIncidentThirdPartyVehicles(IncidentID);
            }

            $("#location").on("change", function () {
                var id = $("#location").children("option:selected").val();
                getLocationInfo(id);
            });

            Security();

            document.body.scrollTop = 0; // For Safari
            document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera

        });

        function turnOffAutoComplete() {
            if (document.getElementsByTagName) {
                var inputElements = document.getElementsByTagName("input");
                for (i = 0; inputElements[i]; i++) {
                    if (!inputElements[i].hasAttribute("autocomplete")) {
                        inputElements[i].setAttribute("autocomplete", "smartystreets");
                    }
                }
            }
        }

        function saveClaims(edit) {
            for (i = 0; i <= VehiclePCAArray.length - 1; i++) {
                PCAVehicleClaims(VehiclePCAArray[i]);
            }

            for (i = 0; i <= ThirdPartyVehiclePCAArray.length - 1; i++) {
                ThirdPartyVehicleClaims(ThirdPartyVehiclePCAArray[i]);
            }

        }

        function PCAVehicleClaims(item) {
            if ($(item).find("input[id*='ClaimID']").val() === undefined  || $(item).find("input[id*='ClaimID']").val() == "") {
                
            } else {
                var claimID = $(item).find("input[id*='ClaimID']").val()
                savePCAVehicle(claimID, item, true);
                return;
            }

            var thisIncidentID = $("#MainContent_IncidentID").val();

            thisIncidentID.replace(/""/g, "\"");

            thisIncidentID = Number(thisIncidentID);

            var creator = $("#txtLoggedinUsername").val().replace('PCA\\', '');
            var today = new Date();

            $.ajax({
                type: "POST",
                async: false,
                //url: "http://localhost:52839/api/InsuranceIncidents/PostInitialIncidentClaim/",
                url: $("#localApiDomain").val() + "InsuranceIncidents/PostInitialIncidentClaim/",

                data: {
                    "IncidentID": thisIncidentID,
                    "ClaimStatusID": 4,
                    "ClaimStatusDate": DateFormat(today)
                },
                dataType: "json",
                success: function (data) {
                    savePCAVehicle(data, item, false);
                },
                error: function (request, status, error) {
                    swal("Error creating initial claim for vehicle");
                },
                complete: function (data) {
                    
                }
            });
        }

        function savePCAVehicle(claimID, item, edit) {
            if (edit == false) {
                var thisClaimID = claimID;
                //var url = "http://localhost:52839/api/InsuranceIncidents/PostPCAVehicle/";
                var url = $("#localApiDomain").val() + "InsuranceIncidents/PostPCAVehicle/";
            } else {
                var thisClaimID = $(item).find("input[id*='ClaimID']").val();
                //var url = "http://localhost:52839/api/InsuranceIncidents/PutPCAVehicle/";
                var url = $("#localApiDomain").val() + "InsuranceIncidents/PutPCAVehicle/";
            }
            
            var DriverName = $(item).find("input[id*='EmployeeName']").val();
            var VehicleID = $(item).find("select[id*='FleetNumber']").val();
            var DriverLicenseNumber = $(item).find("input[id*='DriverLicNumber']").val();
            var Injuries = $(item).find("input[name*='Injuries']:checked").val();
            var TagNumber = $(item).find("input[id*='TagNumber']").val();
            var TagStateID = $(item).find("select[id*='State']").val();
            var PoliceReportNumber = $("#IncidentPoliceReportNumber").val();
            var PCAReceivedClaimDate = $("#IncidentDate").val();
            var LocationID = $("#location").children("option:selected").val();
            var WCIncidentDate = $("#IncidentDate").val();

            $.ajax({
                type: "POST",
                url: url,
                data: {
                    "ClaimID": thisClaimID,
                    "DriverName": DriverName,
                    "VehicleID": VehicleID,
                    "DriverLicenseNumber": DriverLicenseNumber,
                    "Injuries": Injuries,
                    "TagNumber": TagNumber,
                    "TagStateID": TagStateID,
                    "PoliceReportNumber": PoliceReportNumber,
                    "PCAReceivedClaimDate": PCAReceivedClaimDate,
                    "LocationID": LocationID,
                    "WCIncidentDate": WCIncidentDate
                },
                dataType: "json",
                success: function (data) {
                    console.log(data.toString());
                },
                error: function () {
                    swal("Error saving PCA vehicle");
                },
                complete: function (data) {
                    console.log(data.toString());
                }
            });
        }

        function ThirdPartyVehicleClaims(item) {
            if ($(item).find("input[id*='ClaimID']").val() === undefined || $(item).find("input[id*='ClaimID']").val() == "") {

            } else {
                var claimID = $(item).find("input[id*='ClaimID']").val()
                saveThirdPartyVehicle(claimID, item, true);
                return;
            }

            var thisIncidentID = $("#MainContent_IncidentID").val();

            thisIncidentID.replace(/""/g, "\"");

            thisIncidentID = Number(thisIncidentID);

            var creator = $("#txtLoggedinUsername").val().replace('PCA\\', '');
            var today = new Date();

            $.ajax({
                type: "POST",
                async: false,
                //url: "http://localhost:52839/api/InsuranceIncidents/PostInitialIncidentClaim/",
                url: $("#localApiDomain").val() + "InsuranceIncidents/PostInitialIncidentClaim/",

                data: {
                    "IncidentID": thisIncidentID,
                    "ClaimantName": $(item).find("input[id*='CustomerName']").val(),
                    "ClaimStatusID": 4,
                    "ClaimStatusDate": DateFormat(today)
                },
                dataType: "json",
                success: function (data) {
                    saveThirdPartyVehicle(data, item, false);
                },
                error: function (request, status, error) {
                    swal("Error creating third party initial claim");
                },
                complete: function (data) {
                    
                }
            });
        }

        function saveThirdPartyVehicle(claimID, item, edit) {
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
            var CustomerEmailAddress = '';
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
            var InsCompEmailAddress = $(item).find("input[id*='InsuranceEmail']").val();
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

        function getLocationInfo(id) {
            var url = $("#localApiDomain").val() + "InsuranceLocations/GetLocationInfo/" + id;
            //var url = "http://localhost:52839/api/InsuranceLocations/GetLocationInfo/" + id;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        $("#IncidentAddress").val(data[0].LocationAddress);
                        $("#IncidentCity").val(data[0].City);
                        $("#IncidentState").val(data[0].StateAbbreviation);
                        $("#IncidentZip").val(data[0].LocationZip);
                        $("#IncidentPhone").val(data[0].LocationPhone);
                        $("#IncidentFax").val(data[0].LocationFax);
                        $("#IncidentManager").val(data[0].FacilityManager);
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting location information.");
                }
            });
        }

        function loadIncident(id) {
            var url = $("#localApiDomain").val() + "InsuranceIncidents/GetIncidentByID/" + id;
            //var url = "http://localhost:52839/api/InsuranceIncidents/GetIncidentByID/" + id;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        var getLocationOption = '#location option[value=' + data[0].LocationId + ']';
                        $(getLocationOption).prop("selected", true);
                        $("#IncidentNumber").val(data[0].IncidentNumber);
                        $("#IncidentLoationAddress").val(data[0].IncidentStreetAddress);
                        $("#IncidentLoationCity").val(data[0].IncidentCity);
                        $("#IncidentLocationZip").val(data[0].IncidentZip);
                        $("#IncidentLocationPhone").val(data[0].IncidentPhone);
                        var getIncidentLocationOption = '#IncidentLocationState option[value=' + data[0].IncidentStateID + ']';
                        $(getIncidentLocationOption).prop("selected", true);
                        $("#IncidentLocationLRS").val(data[0].IncidentLotRowSpace);
                        $("input[name=operationType][value=" + data[0].OperationTypeID + "]").prop('checked', true);
                        var thisIncidentDate = new Date(data[0].IncidentDate)
                        $("#IncidentDate").val(DateFormatForHTML5(thisIncidentDate));
                        $("#IncidentTime").val(data[0].IncidentTime);
                        $("#IncidentDuration").val(data[0].StayDuration);
                        $("input[name=anyInjuries][value=" + data[0].IncidentInjuries + "]").prop('checked', true);
                        $("#IncidentPoliceReportNumber").val(data[0].PoliceReportNumber);
                        var thisPoliceReportDate = new Date(data[0].PoliceReportDate)
                        $("#IncidentPoliceReportDate").val(DateFormatForHTML5(thisPoliceReportDate));
                        $("#IncidentPoliceOfficersName").val(data[0].OfficerName);
                        $("#PCAPhysicalDamage").val(data[0].PhysicalDamage);
                        $("#IncidentPCADamagesDesc").val(data[0].PhysicalDamageDesc);
                        $("#IncidentCustomerSignature").val(data[0].IncidentCustomerSignature);
                        $("#IncidentEmployeeSignature").val(data[0].IncidentEmployeeSignature);
                        $("#IncidentManagerSignature").val(data[0].IncidentManagerSignature);
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting location information.");
                }
            }).then(function () {
                var id = $("#location").children("option:selected").val();
                getLocationInfo(id);
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
                async: "false",
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

        function loadStates() {
            var dropdown = $('#IncidentLocationState');

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

        function loadPCAVehicles(elementNumber, thisVehicleNumber) {
            var dropdown = $('#VehiclePCA' + elementNumber + 'FleetNumber');
            var location = $("#location").children("option:selected").val();

            dropdown.empty();

            dropdown.append('<option selected="true">Vehicle Number</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/InsuranceVehicles/GetInvuranceVehiclesByLocation/" + location;
            var url = $("#localApiDomain").val() + "InsuranceVehicles/GetInvuranceVehiclesByLocation/" + location;

            return $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append("<option value='" + data[i].VehicleId + "' style='font-weight: bold;'>" + data[i].VehicleNumber + "</option>");
                    }
                    data.push(elementNumber);
                    data.push(thisVehicleNumber);
                },
                error: function (request, status, error) {
                    swal("There was an issue getting location vehicle list information.");
                },
                complete: function () {
                    $(dropdown).on('change', function () {
                        var elementNumber = this.id.toString().match(/\d+/g);
                        var vehicleId = $('#VehiclePCA' + elementNumber[0] + 'FleetNumber').val();
                        var loadData = vehicleId + '~' + elementNumber[0]
                        loadPCAVehicleInfo(loadData)
                    });
                }
            });
        }

        function loadPCAVehicleInfo(id) {

            var loadData = id.split('~');

            //var url = "http://localhost:52839/api/Vehicles/GetVehicleByID/" + loadData[0];
            var url = $("#localApiDomain").val() + "Vehicles/GetVehicleByID/" + loadData[0];

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                async: false,
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    $("#VehiclePCA" + loadData[1] + "Year").val(data[0].Year);
                    $("#VehiclePCA" + loadData[1] + "Make").val(data[0].MakeName);
                    $("#VehiclePCA" + loadData[1] + "VIN").val(data[0].VINNumber);
                    $("#VehiclePCA" + loadData[1] + "Model").val(data[0].ModelName);
                    $("#VehiclePCA" + loadData[1] + "TagNumber").val(data[0].RegistrationNumber);
                },
                error: function (request, status, error) {
                    swal("There was an issue vehicle list information.");
                }
            });
        }

        function loadIncidentPCAVehicles(id) {

            //var url = "http://localhost:52839/api/InsuranceIncidents/GetPCAClaimVehiclesByIncident/" + id;
            var url = $("#localApiDomain").val() + "InsuranceIncidents/GetPCAClaimVehiclesByIncident/" + id;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    $("#IncidentNumPCAVehicles").val(data.length);
                    var thisElementNum = 0;
                    var vehicleInfoBuild = "";

                    for (i = data.length - 1 ; i >= 0; i--) {
                        vehicleInfoBuild = pcaVehicleInfo;
                        vehicleInfoBuild = vehicleInfoBuild.replace(/VehiclePCA1/g, 'VehiclePCA' + (i + 1).toString());
                        vehicleInfoBuild = vehicleInfoBuild.replace('NO. 1', 'NO.' + (i + 1).toString());

                        $("#infoVehiclePCA").after(vehicleInfoBuild);
                        var newVehicle = '#infoVehiclePCA' + (i + 1).toString();
                        VehiclePCAArray.push(newVehicle);

                        $("#VehiclePCA" + (i + 1).toString() + "EmployeeName").val(data[i].DriverName);
                        $("#VehiclePCA" + (i + 1).toString() + "DriverLicNumber").val(data[i].DriverLicenseNumber);

                        if (thisElementNum == 0) {
                            thisElementNum = $("#IncidentNumPCAVehicles").val();
                        } else {
                            thisElementNum = thisElementNum - 1;
                        } 
                        var thisVehicleNumber = data[i].VehicleNumber;
                        var thisState = data[i].StateAbbreviation;

                        $.when(loadPCAVehicles(thisElementNum, thisVehicleNumber).then(function (thisData) {
                                $("#VehiclePCA" + thisData[thisData.length - 2].toString() + "FleetNumber" + " option:contains(" + thisData[thisData.length - 1].toString() + ")").prop('selected', true);
                            }).fail(function (error) {
                                alert("error " + error);
                            })
                        );

                        $.when(loadPCAVehiclesState(thisElementNum, thisState).then(function (thisData) {
                                $("#VehiclePCA" + thisData[thisData.length - 2].toString() + "State" + " option:contains(" + thisData[thisData.length - 1].toString() + ")").prop('selected', true);
                            }).fail(function (error) {
                                alert("error " + error);
                            })
                        );

                        $("#VehiclePCA" + (i + 1).toString() + "ClaimID").val(data[i].ClaimID);
                        $("#VehiclePCA" + (i + 1).toString() + "Year").val(data[i].Year);
                        $("#VehiclePCA" + (i + 1).toString() + "TagNumber").val(data[i].TagNumber);
                        $("#VehiclePCA" + (i + 1).toString() + "Make").val(data[i].MakeName);
                        $("#VehiclePCA" + (i + 1).toString() + "VIN").val(data[i].VINNumber);
                        $("#VehiclePCA" + (i + 1).toString() + "Model").val(data[i].ModelName);
                        $("input[name=VehiclePCA" + (i + 1).toString() + "Injuries][value=" + data[i].Injuries + "]").prop('checked', true);
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting PCA vehicle information information.");
                }
            });
        }

        function loadIncidentThirdPartyVehicles(id) {

            //var url = "http://localhost:52839/api/InsuranceIncidents/GetThirdPartyClaimVehiclesByIncident/" + id;
            var url = $("#localApiDomain").val() + "InsuranceIncidents/GetThirdPartyClaimVehiclesByIncident/" + id;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    $("#IncidentNumThirdPartyVehicle").val(data.length);
                    var thisElementNum = 0;
                    for (i = data.length - 1 ; i >= 0; i--) {
                        vehicleInfoBuild = pcaThirdPersonOrVehicle;
                        vehicleInfoBuild = vehicleInfoBuild.replace(/ThirdPartyVehiclePCA1/g, 'ThirdPartyVehiclePCA' + (i + 1).toString());
                        vehicleInfoBuild = vehicleInfoBuild.replace('NO. 1', 'NO.' + (i + 1).toString());

                        $("#thirdPartyTable").after(vehicleInfoBuild);
                        var newVehicle = '#ThirdPartyVehiclePCA' + (i + 1).toString();
                        ThirdPartyVehiclePCAArray.push(newVehicle);

                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "ClaimID").val(data[i].ClaimID);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "CustomerName").val(data[i].CustomerName);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "CStreetAddress").val(data[i].CustomerStreetAddress);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "City").val(data[i].CustomerCity);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "State").val(data[i].CustomerState);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "Zip").val(data[i].CustomerZip);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "VehicleYear").val(data[i].VehicleYear);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "PhoneMobile").val(data[i].CustomerPhoneMobile);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "Make").val(data[i].VehicleMake);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "PhoneHome").val(data[i].CustomerPhoneHome);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "Model").val(data[i].VehicleModel);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "DriversLicenseNumber").val(data[i].CustomerDriverLicenseNumber);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "Color").val(data[i].VehicleColor);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "InsuranceCompany").val(data[i].InsuranceCompany);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "VIN").val(data[i].VehicleVIN);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "InsuranceAddress").val(data[i].InsCompAddress);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "LicensePlate").val(data[i].VehicleLicensePlate);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "InsurancePhone").val(data[i].InsCompPhone);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "PlateState").val(data[i].VehicleLicensePlateState);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "InsuranceEmail").val(data[i].InsCompEmailAddress);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "AgentName").val(data[i].InsCompAgentName);
                        $("input[name=ThirdPartyVehiclePCA" + (i + 1).toString() + "CInjuries][value=" + data[i].Injuries + "]").prop('checked', true);
                        $("#ThirdPartyVehiclePCA" + (i + 1).toString() + "PolicyNumber").val(data[i].InsCompPolicyNumber);

                        if (thisElementNum == 0) {
                            thisElementNum = $("#IncidentNumThirdPartyVehicle").val();
                        } else {
                            thisElementNum = thisElementNum - 1;
                        }

                        var CustomerState = data[i].CustomerState;
                        var VehicleLicensePlateState = data[i].VehicleLicensePlateState;

                        $.when(loadThirdPartyVehiclesState(thisElementNum, CustomerState, 'State').then(function (thisData) {
                                $("#ThirdPartyVehiclePCA" + thisData[thisData.length - 2].toString() + "State" + " option:contains(" + thisData[thisData.length - 1].toString() + ")").prop('selected', true);
                            }).fail(function (error) {
                                alert("error " + error);
                            })
                        );

                        $.when(loadThirdPartyVehiclesState(thisElementNum, VehicleLicensePlateState, 'PlateState').then(function (thisData) {
                            $("#ThirdPartyVehiclePCA" + thisData[thisData.length - 2].toString() + "PlateState" + " option:contains(" + thisData[thisData.length - 1].toString() + ")").prop('selected', true);
                        }).fail(function (error) {
                            alert("error " + error);
                        })
                        );
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting PCA vehicle information information.");
                }
            });
        }

        function loadPCAVehiclesState(elementNumber, thisState) {
            var dropdown = $('#VehiclePCA' + elementNumber + 'State');
            var location = $("#location").children("option:selected").val();

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
                    swal("There was an issue getting state information.");
                }
            });
        }

        function loadThirdPartyVehiclesState(elementNumber, thisState, thisDropdown) {
            var dropdown = $('#ThirdPartyVehiclePCA' + elementNumber + thisDropdown);
            var location = $("#location").children("option:selected").val();

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
                    swal("There was an issue getting state information.");
                }
            });
        }

    </script>

    <style>
        .xl1527147
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
        .xl6727147
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
        .xl6827147
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
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl6927147
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
        .xl7027147
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
        .xl7127147
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
        .xl7227147
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
	        text-align:general;
	        vertical-align:bottom;
	        background:#D9D9D9;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl7327147
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:windowtext;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        border-top:1.0pt solid windowtext;
	        border-right:none;
	        border-bottom:none;
	        border-left:1.0pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7427147
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:windowtext;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        border-top:none;
	        border-right:none;
	        border-bottom:none;
	        border-left:1.0pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7527147
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:windowtext;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        border-top:none;
	        border-right:none;
	        border-bottom:1.0pt solid windowtext;
	        border-left:1.0pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7627147
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:windowtext;
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
        .xl7727147
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
	        border-top:1.0pt solid windowtext;
	        border-right:none;
	        border-bottom:none;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7827147
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
	        border-top:1.0pt solid windowtext;
	        border-right:1.0pt solid windowtext;
	        border-bottom:none;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7927147
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
	        border-top:none;
	        border-right:1.0pt solid windowtext;
	        border-bottom:none;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8027147
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
	        border-top:none;
	        border-right:none;
	        border-bottom:1.0pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8127147
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
	        border-top:none;
	        border-right:1.0pt solid windowtext;
	        border-bottom:1.0pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8227147
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
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8327147
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
        .xl8427147
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
	        text-align:left;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8527147
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:windowtext;
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
	        background:#92D050;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8627147
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
        .xl8727147
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
        .xl8827147
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
        .xl8927147
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
	        text-align:left;
	        vertical-align:bottom;
	        border-top:none;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl9027147
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
	        border:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl9127147
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
	        border:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl9227147
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
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl9327147
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
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl9427147
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
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:.5pt solid windowtext;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}

        .auto-style1 {
            height: 20px;
        }
        .auto-style2 {
            height: 66px;
        }

    </style>
        

        <div align=center>

        <table id="infoVehiclePCA" border=0 cellpadding=0 cellspacing=0 width=802 style='border-collapse:
         collapse;table-layout:fixed;width:603pt'>
         <col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>
         <col width=182 style='mso-width-source:userset;mso-width-alt:6656;width:137pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1527147 width=19 style='height:15.75pt;width:14pt'><a
          name="RANGE!A1:I101"></a></td>
          <td class=xl1527147 width=182 style='width:137pt'></td>
          <td class=xl1527147 width=17 style='width:13pt'></td>
          <td class=xl1527147 width=177 style='width:133pt'></td>
          <td class=xl1527147 width=17 style='width:13pt'></td>
          <td class=xl1527147 width=177 style='width:133pt'></td>
          <td class=xl1527147 width=17 style='width:13pt'></td>
          <td class=xl1527147 width=177 style='width:133pt'></td>
          <td class=xl1527147 width=19 style='width:14pt'></td>
         </tr>
         <tr height=22 style='height:16.5pt'>
          <td height=22 class=xl1527147 style='height:16.5pt'></td>
          <td colspan=7 class=xl8627147 style='border-right:1.0pt solid black'>PCA
          INCIDENT/ACCIDENT REPORT</td>
          <td class=xl6827147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr>
          <td class=auto-style1 colspan="9" style="text-align:center">
              <img alt="" src="./images/InsuranceIncidentReportHeader.png" /></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl6927147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl8427147>LOCATION</td>
          <td class=xl1527147></td>
          <td class=xl6727147><select id="location" style="border:none"></select></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>Address</td>
          <td class=xl1527147></td>
          <td colspan=3 class=xl9027147><input type='text' id='IncidentAddress' style='border:none' /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>City</td>
          <td class=xl1527147></td>
          <td colspan=3 class=xl9027147><input type='text' id='IncidentCity' style='border:none' /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>State</td>
          <td class=xl1527147></td>
          <td colspan=3 class=xl9027147><input type='text' id='IncidentState' style='border:none' /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>Zip</td>
          <td class=xl1527147></td>
          <td colspan=3 class=xl9027147><input type='text' id='IncidentZip' style='border:none' /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>Phone</td>
          <td class=xl1527147></td>
          <td colspan=3 class=xl9027147><input type='text' id='IncidentPhone' style='border:none' /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>Fax</td>
          <td class=xl1527147></td>
          <td colspan=3 class=xl9027147><input type='text' id='IncidentFax' style='border:none' /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>Facility Manager Name</td>
          <td class=xl1527147></td>
          <td colspan=3 class=xl9027147><input type='text' id='IncidentManager' style='border:none' /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl6827147>LOCATION OF INCIDENT</td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl6827147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>Street Address</td>
          <td class=xl1527147></td>
          <td colspan=3 class=xl9027147><input type='text' id='IncidentLoationAddress' style='border:none' /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>City</td>
          <td class=xl1527147></td>
          <td colspan=3 class=xl9027147><input type='text' id='IncidentLoationCity' style='border:none' /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>State</td>
          <td class=xl1527147></td>
          <td colspan=3 class=xl9027147><select id="IncidentLocationState" style="border:none"></select></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>Zip</td>
          <td class=xl1527147></td>
          <td colspan=3 class=xl9027147><input type='text' id='IncidentLocationZip' style='border:none' /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>Phone</td>
          <td class=xl1527147></td>
          <td colspan=3 class=xl9027147><input type='text' id='IncidentLocationPhone' style='border:none' /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>Lot--Row--Space</td>
          <td class=xl1527147></td>
          <td colspan=3 class=xl9027147><input type='text' id='IncidentLocationLRS' style='border:none' /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>Operation Type</td>
          <td class=xl1527147></td>
          <td class=xl6727147 style='border-top:none'><input name="operationType" type="radio" value="0" style="width:25px" />Self Park<input name="operationType" type="radio" value="1" style="width:25px" />Valet</td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl6827147>INCIDENT DETAILS</td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>Date of Incident</td>
          <td class=xl1527147></td>
          <td class=xl6727147><input type='date' id='IncidentDate' style='border:none' /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>Time of Incident</td>
          <td class=xl1527147></td>
          <td class=xl6727147 style='border-top:none'><input type='time' id='IncidentTime' style='border:none' /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>Duration of stay in Lot</td>
          <td class=xl1527147></td>
          <td class=xl6727147 style='border-top:none'><input type='text' id='IncidentDuration' style='border:none' /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>Any Injuries</td>
          <td class=xl1527147></td>
          <td class=xl6727147 style='border-top:none'><input name="anyInjuries" type="radio" value="1" style="width:25px" />Yes<input name="anyInjuries" type="radio" value="0" style="width:25px" />No</td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147><span style='mso-spacerun:yes'> </span></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>Police Report #</td>
          <td class=xl1527147></td>
          <td class=xl6727147 style='border-top:none'><input type='text' id='IncidentPoliceReportNumber' style='border:none' class="auto-style1" /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>Date of Report</td>
          <td class=xl1527147></td>
          <td class=xl6727147 style='border-top:none'><input type='date' id='IncidentPoliceReportDate' style='border:none' /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147>Officer's Name</td>
          <td class=xl1527147></td>
          <td class=xl6727147 style='border-top:none'><input type='text' id='IncidentPoliceOfficersName' style='border:none' /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl6827147 colspan=3>NUMBER OF PCA VEHICLES INVOLVED</td>
          <td class=xl1527147></td>
          <td class=xl6727147>
              <input id="IncidentNumPCAVehicles" type="text" style="border:none;" /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
        </table>
        <table id="thirdPartyTable" border=0 cellpadding=0 cellspacing=0 width=802 style='border-collapse:
         collapse;table-layout:fixed;width:603pt'>
         <col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>
         <col width=182 style='mso-width-source:userset;mso-width-alt:6656;width:137pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1527147 style='height:15.75pt'></td>
          <td class=xl8027147>&nbsp;</td>
          <td class=xl8027147>&nbsp;</td>
          <td class=xl8027147>&nbsp;</td>
          <td class=xl8027147>&nbsp;</td>
          <td class=xl8027147>&nbsp;</td>
          <td class=xl8027147>&nbsp;</td>
          <td class=xl8027147>&nbsp;</td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl6827147 colspan=3>NUMBER OF THIRD PARTY PERSONS OR VEHICLES
          INVOLVED</td>
          <td class=xl1527147></td>
          <td class=xl6727147>
              <input id="IncidentNumThirdPartyVehicle" type="text" style="border:none;" /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
        </table>
        <table id="bottomTable" border=0 cellpadding=0 cellspacing=0 width=802 style='border-collapse:
         collapse;table-layout:fixed;width:603pt'>
         <col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>
         <col width=182 style='mso-width-source:userset;mso-width-alt:6656;width:137pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1527147 style='height:15.75pt'></td>
          <td class=xl8027147>&nbsp;</td>
          <td class=xl8027147>&nbsp;</td>
          <td class=xl8027147>&nbsp;</td>
          <td class=xl8027147>&nbsp;</td>
          <td class=xl8027147>&nbsp;</td>
          <td class=xl8027147>&nbsp;</td>
          <td class=xl8027147>&nbsp;</td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1511590 style='height:15.0pt'></td>
          <td class=xl1511590></td>
          <td class=xl1511590></td>
          <td class=xl1511590></td>
          <td class=xl1511590></td>
          <td class=xl1511590></td>
          <td class=xl1511590></td>
          <td class=xl1511590></td>
          <td class=xl1511590></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl6827147 colspan=3>PCA PHYSICAL PROPERTY DAMAGE</td>
          <td class=xl1527147></td>
          <td class=xl6727147>
            <select id="PCAPhysicalDamage" style="border:none">
              <option value="1">Yes</option>
              <option value="0" selected>No</option>
              <option value="2">Unknown</option>
            </select>
          </td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl6827147 colspan=3>LIST ALL PCA DAMAGE AND DESCRIPTION OF DAMAGE</td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=80 style='mso-height-source:userset;height:60.0pt'>
          <td height=80 class=xl1527147 style='height:60.0pt'></td>
          <td colspan=7 class=xl9227147 width=764 style='border-right:.5pt solid black;
          width:575pt'>
              <textarea id="IncidentPCADamagesDesc" class="auto-style2" cols="20" name="S1" style="border:none"></textarea></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl6827147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl6827147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td colspan=3 class=xl8927147>
              <input id="IncidentCustomerSignature" type="text" style="border:none;" /></td>
          <td class=xl1527147></td>
          <td colspan=3 class=xl8927147>
              <input id="IncidentEmployeeSignature" type="text" style="border:none;" /></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl6827147>Customer Signature</td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl6827147>Employee/Driver Signature</td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl6827147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1527147 style='height:15.75pt'></td>
          <td colspan=3 class=xl8927147>
              <input id="IncidentManagerSignature" type="text" style="border:none;" /></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147><asp:TextBox ID="IncidentID" runat="server" Style="display:none"></asp:TextBox></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1527147 style='height:15.75pt'></td>
          <td class=xl6827147>Manager Receiving Report</td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl7027147>PCA INCIDENT #</td>
          <td class=xl1527147></td>
          <td class=xl8327147>
              <input id="IncidentNumber" type="text" style="border:none;" /></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1527147 style='height:15.75pt'></td>
          <td class=xl6827147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl7327147 colspan=7 style='border-right:1.0pt solid black'>Thank
          you for completing this form.<span style='mso-spacerun:yes'>  </span>This
          form is used to document reported incidents of damage, injury or complaint.</td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl7427147 colspan=7 style='border-right:1.0pt solid black'>Provision
          or completion of this form in no way affects PCA's liability or absence of
          liability in the reported incident.</td>
          <td class=xl1527147></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1527147 style='height:15.75pt'></td>
          <td class=xl7527147 colspan=5>PCA will evaluate your report and will contact
          you if any further information is needed.</td>
          <td class=xl8027147>&nbsp;</td>
          <td class=xl8127147>&nbsp;</td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl7627147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl7627147><input id="saveContinue" type="button" value="SAVE &amp; CONTINUE" style="background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl1527147></td>
          <td class=xl7627147><input id="printReport" type="button" value="Print Report" style="background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl1527147></td>
          <td class=xl8227147></td>
          <td class=xl1527147></td>
          <td class=xl8527147>PAGE 1 OF 5</td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl7627147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
          <td class=xl1527147></td>
         </tr>
         <![if supportMisalignedColumns]>
         <tr height=0 style='display:none'>
          <td width=19 style='width:14pt'></td>
          <td width=182 style='width:137pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=19 style='width:14pt'></td>
         </tr>
         <![endif]>
        </table>

        </div>


    <script>
        var pcaVehicleInfo = "<table id='infoVehiclePCA1' class='pcaVehicleSection'  border=0 cellpadding=0 cellspacing=0 width=802 style='border-collapse:" +
                                 "collapse;table-layout:fixed;width:603pt'>" +
                                 "<col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>" +
                                 "<col width=182 style='mso-width-source:userset;mso-width-alt:6656;width:137pt'>" +
                                 "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                                 "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                                 "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                                 "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                                 "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                                 "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                                 "<col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>" +
		                         "<tr height=20 style='height:15.0pt'>" +
                                 " <td height=20 class=xl1527147 style='height:15.0pt'></td>" +
                                 " <td class=xl7227147>PCA VEHICLE NO. 1</td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl1527147></td>" +
                                 "</tr>" +
                                 "<tr height=20 style='height:15.0pt'>" +
                                 " <td height=20 class=xl1527147 style='height:15.0pt'></td>" +
                                 " <td class=xl1527147>Employee Name</td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td colspan=3 class=xl9027147>" +
                                 "     <input type='text' id='VehiclePCA1EmployeeName' style='border:none' '~' /><input type='text' id='VehiclePCA1ClaimID' style='display:none' /></td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl1527147></td>" +
                                 "</tr>" +
                                 "<tr height=20 style='height:15.0pt'>" +
                                 " <td height=20 class=xl1527147 style='height:15.0pt'></td>" +
                                 " <td class=xl1527147>Drivers License #</td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl6727147 style='border-top:none'>" +
                                 "     <input type='text' id='VehiclePCA1DriverLicNumber' style='border:none' /></td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl1527147>PCA FLEET #</td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl6727147>" +
                                 "    <select id='VehiclePCA1FleetNumber' style='border:none'></select></td>" +
                                 " <td class=xl1527147></td>" +
                                 "</tr>" +
                                 "<tr height=20 style='height:15.0pt'>" +
                                 " <td height=20 class=xl1527147 style='height:15.0pt'></td>" +
                                 " <td class=xl1527147>Year</td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl6727147 style='border-top:none'>" +
                                 "     <input type='text' id='VehiclePCA1Year' style='border:none' /></td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl1527147>Tag #</td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl6727147 style='border-top:none'>" +
                                 "     <input type='text' id='VehiclePCA1TagNumber' style='border:none' /></td>" +
                                 " <td class=xl1527147></td>" +
                                 "</tr>" +
                                 "<tr height=20 style='height:15.0pt'>" +
                                 " <td height=20 class=xl1527147 style='height:15.0pt'></td>" +
                                 " <td class=xl1527147>Make</td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl6727147 style='border-top:none'>" +
                                 "     <input type='text' id='VehiclePCA1Make' style='border:none' /></td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl1527147>VIN</td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl6727147 style='border-top:none'>" +
                                 "     <input type='text' id='VehiclePCA1VIN' style='border:none' /></td>" +
                                 " <td class=xl1527147></td>" +
                                 "</tr>" +
                                 "<tr height=20 style='height:15.0pt'>" +
                                 " <td height=20 class=xl1527147 style='height:15.0pt'></td>" +
                                 " <td class=xl1527147>Model</td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl6727147 style='border-top:none'>" +
                                 "     <input type='text' id='VehiclePCA1Model' style='border:none' /></td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl1527147>State</td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl6727147 style='border-top:none'>" +
                                 "     <select id='VehiclePCA1State' style='border:none'></select></td>" +
                                 " <td class=xl1527147></td>" +
                                 "</tr>" +
                                 "<tr height=20 style='height:15.0pt'>" +
                                 " <td height=20 class=xl1527147 style='height:15.0pt'></td>" +
                                 " <td class=xl1527147>ANY EMPLOYEE INJURIES</td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl6727147 style='border-top:none'><input name='VehiclePCA1Injuries' type='radio' value='1' style='width:25px' />Yes<input name='VehiclePCA1Injuries' type='radio' value='0' style='width:25px' />No</td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl1527147></td>" +
                                 " <td class=xl1527147></td>" +
                                 "</tr>" +
		                         "</table>";

        var pcaThirdPersonOrVehicle = "<table id='ThirdPartyVehiclePCA1' class='pcaVehicleThirdPartySection'  border=0 cellpadding=0 cellspacing=0 width=802 style='border-collapse:" +
                                        "collapse;table-layout:fixed;width:603pt'>" +
                                        "<col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>" +
                                        "<col width=182 style='mso-width-source:userset;mso-width-alt:6656;width:137pt'>" +
                                        "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                                        "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                                        "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                                        "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                                        "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>" +
                                        "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>" +
                                        "<col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'>" +
                                        "<tr height=20 style='height:15.0pt'>" +
                                        "<td height=20 class=xl1511590 style='height:15.0pt'></td>" +
                                        "<td class=xl7227147>THIRD PARTY INFO NO. 1</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1511590></td>" +
                                        "</tr>" +
                                        "<tr height=20 style='height:15.0pt'>" +
                                        "<td height=20 class=xl1511590 style='height:15.0pt'></td>" +
                                        "<td class=xl1527147>Customer Name</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td colspan=3 class=xl6727147 width=371 style='width:279pt'>" +
                                        "<input id='ThirdPartyVehiclePCA1CustomerName' type='text' style='border:none;' /><input type='text' id='ThirdPartyVehiclePCA1ClaimID' style='display:none' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1511590></td>" +
                                        "</tr>" +
                                        "<tr height=20 style='height:15.0pt'>" +
                                        "<td height=20 class=xl1511590 style='height:15.0pt'></td>" +
                                        "<td class=xl1527147>Street Address</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td colspan=3 class=xl6727147 width=371 style='width:279pt'>" +
                                        "<input id='ThirdPartyVehiclePCA1CStreetAddress' type='text' style='border:none;' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1511590></td>" +
                                        "</tr>" +
                                        "<tr height=20 style='height:15.0pt'>" +
                                        "<td height=20 class=xl1511590 style='height:15.0pt'></td>" +
                                        "<td class=xl1527147>City</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147>" +
                                        "<input id='ThirdPartyVehiclePCA1City' type='text' style='border:none;' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1527147>State</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147>" +
                                        "<select id='ThirdPartyVehiclePCA1State' type='text' style='border:none;'></select></td>" +
                                        "<td class=xl1511590></td>" +
                                        "</tr>" +
                                        "<tr height=20 style='height:15.0pt'>" +
                                        "<td height=20 class=xl1511590 style='height:15.0pt'></td>" +
                                        "<td class=xl1527147>Zip Code</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147>" +
                                        "<input id='ThirdPartyVehiclePCA1Zip' type='text' style='border:none;' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1527147>Vehicle Year</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147 style='border-top:none'>" +
                                        "<input id='ThirdPartyVehiclePCA1VehicleYear' type='text' style='border:none;' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "</tr>" +
                                        "<tr height=20 style='height:15.0pt'>" +
                                        "<td height=20 class=xl1511590 style='height:15.0pt'></td>" +
                                        "<td class=xl1527147>Phone (Mobile)</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147 style='border-top:none'>" +
                                        "<input id='ThirdPartyVehiclePCA1PhoneMobile' type='text' style='border:none;' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1527147>Make<span style='mso-spacerun:yes'> </span></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147 style='border-top:none'>" +
                                        "<input id='ThirdPartyVehiclePCA1Make' type='text' style='border:none;' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "</tr>" +
                                        "<tr height=20 style='height:15.0pt'>" +
                                        "<td height=20 class=xl1511590 style='height:15.0pt'></td>" +
                                        "<td class=xl1527147>Phone (Home)</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147 style='border-top:none'>" +
                                        "<input id='ThirdPartyVehiclePCA1PhoneHome' type='text' style='border:none;' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1527147>Model</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147 style='border-top:none'>" +
                                        "<input id='ThirdPartyVehiclePCA1Model' type='text' style='border:none;' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "</tr>" +
                                        "<tr height=20 style='height:15.0pt'>" +
                                        "<td height=20 class=xl1511590 style='height:15.0pt'></td>" +
                                        "<td class=xl1527147>Drivers License #</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147 style='border-top:none'>" +
                                        "<input id='ThirdPartyVehiclePCA1DriversLicenseNumber' type='text' style='border:none;' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1527147>Color</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147 style='border-top:none'>" +
                                        "<input id='ThirdPartyVehiclePCA1Color' type='text' style='border:none;' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "</tr>" +
                                        "<tr height=20 style='height:15.0pt'>" +
                                        "<td height=20 class=xl1511590 style='height:15.0pt'></td>" +
                                        "<td class=xl1527147>Insurance Company</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147 style='border-top:none'>" +
                                        "<input id='ThirdPartyVehiclePCA1InsuranceCompany' type='text' style='border:none;' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1527147>VIN</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147 style='border-top:none'>" +
                                        "<input id='ThirdPartyVehiclePCA1VIN' type='text' style='border:none' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "</tr>" +
                                        "<tr height=20 style='height:15.0pt'>" +
                                        "<td height=20 class=xl1511590 style='height:15.0pt'></td>" +
                                        "<td class=xl1527147>Address</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147 style='border-top:none'>" +
                                        "<input id='ThirdPartyVehiclePCA1InsuranceAddress' type='text' style='border:none;' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1527147>License Plate</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147 style='border-top:none'>" +
                                        "<input id='ThirdPartyVehiclePCA1LicensePlate' type='text' style='border:none;' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "</tr>" +
                                        "<tr height=20 style='height:15.0pt'>" +
                                        "<td height=20 class=xl1511590 style='height:15.0pt'></td>" +
                                        "<td class=xl1527147>Phone</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147 style='border-top:none'>" +
                                        "<input id='ThirdPartyVehiclePCA1InsurancePhone' type='text' style='border:none;' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1527147>Plate State</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147 style='border-top:none'>" +
                                        "<select id='ThirdPartyVehiclePCA1PlateState' type='text' style='border:none;'></select></td>" +
                                        "<td class=xl1511590></td>" +
                                        "</tr>" +
                                        "<tr height=20 style='height:15.0pt'>" +
                                        "<td height=20 class=xl1511590 style='height:15.0pt'></td>" +
                                        "<td class=xl1527147>Email Address</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147 style='border-top:none'>" +
                                        "<input id='ThirdPartyVehiclePCA1InsuranceEmail' type='text' style='border:none;' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1527147>Agent Name</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147 style='border-top:none'>" +
                                        "<input id='ThirdPartyVehiclePCA1AgentName' type='text' style='border:none;' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "</tr>" +
                                        "<tr height=20 style='height:15.0pt'>" +
                                        "<td height=20 class=xl1511590 style='height:15.0pt'></td>" +
                                        "<td class=xl1527147>ANY INJURIES</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147 style='border-top:none'><input name='ThirdPartyVehiclePCA1CInjuries' type='radio' value='1' style='width:25px' />Yes<input name='ThirdPartyVehiclePCA1CInjuries' type='radio' value='0' style='width:25px' />No</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1527147>Policy #</td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl6727147 style='border-top:none'>" +
                                        "<input id='ThirdPartyVehiclePCA1PolicyNumber' type='text' style='border:none;' /></td>" +
                                        "<td class=xl1511590></td>" +
                                        "</tr>" +
                                        "<tr height=20 style='height:15.0pt'>" +
                                        "<td height=20 class=xl1511590 style='height:15.0pt'></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1511590></td>" +
                                        "<td class=xl1511590></td>" +
                                        "</tr>" +
                                        "</table>";


    </script>


</asp:Content>

