<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceManagerInvestigation.aspx.cs" Inherits="InsuranceManagerInvestigation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script>
        var group = '<%= Session["groupList"] %>';
        var witnessArray = [];
        var InvolvedArray = [];
        var PCAInvolvedArray = [];
        var ManagerInvestigationID = 0;

        $(document).ready(function () {
            turnOffAutoComplete();

            //++++++++++++++++++++++++++++++++++++++++++++ start witnesses, number of Persons Involved and PCA drivers Involved create UI ++++++++++++++++++++++++++++++++++++++++++++++++++++
            $("#NumberOfWitnesses").on('blur', function () {
                if (isNaN($("#NumberOfWitnesses").val()) == false) {
                    var witnessNumber = $("#NumberOfWitnesses").val();
                    if (witnessNumber == 0) {
                        witnessArray.length = 0;
                        $(".witnessSection").remove();
                    } else if (witnessNumber > witnessArray.length && witnessArray.length != 0) {
                        for (i = witnessNumber - witnessArray.length ; i > 0; i--) {
                            witnessInfoBuild = witnessInfo;
                            witnessInfoBuild = witnessInfoBuild.replace(/witness1/g, 'witness' + (witnessArray.length + 1).toString());
                            witnessInfoBuild = witnessInfoBuild.replace('NO. 1', 'NO.' + (witnessArray.length + 1).toString());
                            var placementTable = '#Infowitness' + (witnessArray.length).toString();
                            $(placementTable).after(witnessInfoBuild);
                            var newWitness = '#Infowitness' + (witnessArray.length + 1).toString();
                            witnessArray.splice(0, 0, newWitness);
                            var thisFocus = "#witness" + (i).toString() + "name";
                            $(thisFocus).focus();

                            loadStates("#witness" + (witnessArray.length).toString() + "StateID");
                        }
                    } else if (witnessNumber < witnessArray.length) {
                        var arrayLength = witnessArray.length;
                        for (i = 0; i <= arrayLength - witnessNumber - 1; i++) {
                            $(witnessArray[0]).remove();
                            witnessArray.splice(0, 1);
                        }
                    } else if (witnessArray.length == 0) {
                        for (i = $("#NumberOfWitnesses").val() ; i > 0; i--) {
                            witnessInfoBuild = witnessInfo;
                            witnessInfoBuild = witnessInfoBuild.replace(/witness1/g, 'witness' + (i).toString());
                            witnessInfoBuild = witnessInfoBuild.replace('NO. 1', 'NO.' + (i).toString());
                            if (i == 1) {
                                witnessInfoBuild = witnessInfoBuild.replace("'~'", "autofocus");
                            }
                            $("#witnessTable").after(witnessInfoBuild);
                            var newWitness = '#Infowitness' + (i).toString();
                            witnessArray.push(newWitness);
                            var thisFocus = "#witness" + (i).toString() + "name";
                            $(thisFocus).focus();

                            loadStates("#witness" + (witnessArray.length).toString() + "StateID");
                        }
                    }
                }
                turnOffAutoComplete();
            });

            $("#NumberOtherInvolved").on('blur', function () {
                if (isNaN($("#NumberOtherInvolved").val()) == false) {
                    var InvolvedNumber = $("#NumberOtherInvolved").val();
                    if (InvolvedNumber == 0) {
                        InvolvedArray.length = 0;
                        $(".InvolvedSection").remove();
                    } else if (InvolvedNumber > InvolvedArray.length && InvolvedArray.length != 0) {
                        for (i = InvolvedNumber - InvolvedArray.length ; i > 0; i--) {
                            InvolvedInfoBuild = InvolvedInfo;
                            InvolvedInfoBuild = InvolvedInfoBuild.replace(/Involved1/g, 'Involved' + (InvolvedArray.length + 1).toString());
                            InvolvedInfoBuild = InvolvedInfoBuild.replace('NO. 1', 'NO.' + (InvolvedArray.length + 1).toString());
                            var placementTable = '#infoInvolved' + (InvolvedArray.length).toString();
                            $(placementTable).after(InvolvedInfoBuild);
                            var newInvolved = '#infoInvolved' + (InvolvedArray.length + 1).toString();
                            InvolvedArray.splice(0, 0, newInvolved);
                            var thisFocus = "#Involved" + (i).toString() + "name";
                            $(thisFocus).focus();
                        }
                    } else if (InvolvedNumber < InvolvedArray.length) {
                        var arrayLength = InvolvedArray.length;
                        for (i = 0; i <= arrayLength - InvolvedNumber - 1; i++) {
                            $(InvolvedArray[0]).remove();
                            InvolvedArray.splice(0, 1);
                        }
                    } else if (InvolvedArray.length == 0) {
                        for (i = $("#NumberOtherInvolved").val() ; i > 0; i--) {
                            InvolvedInfoBuild = InvolvedInfo;
                            InvolvedInfoBuild = InvolvedInfoBuild.replace(/Involved1/g, 'Involved' + (i).toString());
                            InvolvedInfoBuild = InvolvedInfoBuild.replace('NO. 1', 'NO.' + (i).toString());
                            if (i == 1) {
                                InvolvedInfoBuild = InvolvedInfoBuild.replace("'~'", "autofocus");
                            }
                            $("#infoInvolved").after(InvolvedInfoBuild);
                            var newInvolved = 'infoInvolved' + (i).toString();
                            InvolvedArray.push(newInvolved);
                            var thisFocus = "#Involved" + (i).toString() + "name";
                            $(thisFocus).focus();
                        }
                    }
                }
                turnOffAutoComplete();
            });

            $("#NumberOfPCAInvolved").on('blur', function () {
                if (isNaN($("#NumberOfPCAInvolved").val()) == false) {
                    var PCAInvolvedNumber = $("#NumberOfPCAInvolved").val();
                    if (PCAInvolvedNumber == 0) {
                        PCAInvolvedArray.length = 0;
                        $(".PCAInvolvedSection").remove();
                    } else if (PCAInvolvedNumber > PCAInvolvedArray.length && PCAInvolvedArray.length != 0) {
                        for (i = PCAInvolvedNumber - PCAInvolvedArray.length ; i > 0; i--) {
                            PCAInvolvedInfoBuild = PCAInvolvedInfo;
                            PCAInvolvedInfoBuild = PCAInvolvedInfoBuild.replace(/Involved1/g, 'Involved' + (PCAInvolvedArray.length + 1).toString());
                            PCAInvolvedInfoBuild = PCAInvolvedInfoBuild.replace('NO. 1', 'NO.' + (PCAInvolvedArray.length + 1).toString());
                            var placementTable = '#InfoPCAInvolved' + (PCAInvolvedArray.length).toString();
                            $(placementTable).after(PCAInvolvedInfoBuild);
                            var newPCAInvolved = '#InfoPCAInvolved' + (PCAInvolvedArray.length + 1).toString();
                            PCAInvolvedArray.splice(0, 0, newPCAInvolved);
                            var thisFocus = "#PCAInvolved" + (i).toString() + "name";
                            $(thisFocus).focus();
                        }
                    } else if (PCAInvolvedNumber < PCAInvolvedArray.length) {
                        var arrayLength = PCAInvolvedArray.length;
                        for (i = 0; i <= arrayLength - PCAInvolvedNumber - 1; i++) {
                            $(PCAInvolvedArray[0]).remove();
                            PCAInvolvedArray.splice(0, 1);
                        }
                    } else if (PCAInvolvedArray.length == 0) {
                        for (i = $("#NumberOfPCAInvolved").val() ; i > 0; i--) {
                            PCAInvolvedInfoBuild = PCAInvolvedInfo;
                            PCAInvolvedInfoBuild = PCAInvolvedInfoBuild.replace(/Involved1/g, 'Involved' + (i).toString());
                            PCAInvolvedInfoBuild = PCAInvolvedInfoBuild.replace('NO. 1', 'NO.' + (i).toString());
                            if (i == 1) {
                                PCAInvolvedInfoBuild = PCAInvolvedInfoBuild.replace("'~'", "autofocus");
                            }
                            $("#InfoPCAInvolved").after(PCAInvolvedInfoBuild);
                            var newPCAInvolved = '#InfoPCAInvolved' + (i).toString();
                            PCAInvolvedArray.push(newPCAInvolved);
                            var thisFocus = "#PCAInvolved" + (i).toString() + "name";
                            $(thisFocus).focus();
                        }
                    }
                }
                turnOffAutoComplete();
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
                                    witnessInfoBuild = witnessInfo;
                                    witnessInfoBuild = witnessInfoBuild.replace(/witness1/g, 'witness' + (witnessArray.length + 1).toString());
                                    witnessInfoBuild = witnessInfoBuild.replace('NO. 1', 'NO.' + (witnessArray.length + 1).toString());
                                    var placementTable = '#Infowitness' + (witnessArray.length).toString();
                                    $(placementTable).after(witnessInfoBuild);
                                    var newWitness = '#Infowitness' + (witnessArray.length + 1).toString();
                                    witnessArray.splice(0, 0, newWitness);

                                    loadStates("#witness" + (witnessArray.length).toString() + "StateID");
                                }
                            } else if (witnessNumber < witnessArray.length) {
                                var arrayLength = witnessArray.length;
                                for (i = 0; i <= arrayLength - witnessNumber - 1; i++) {
                                    $(witnessArray[0]).remove();
                                    witnessArray.splice(0, 1);
                                }
                            } else if (witnessArray.length == 0) {
                                for (i = $("#NumberOfWitnesses").val() ; i > 0; i--) {
                                    witnessInfoBuild = witnessInfo;
                                    witnessInfoBuild = witnessInfoBuild.replace(/witness1/g, 'witness' + (i).toString());
                                    witnessInfoBuild = witnessInfoBuild.replace('NO. 1', 'NO.' + (i).toString());
                                    if (i == 1) {
                                        witnessInfoBuild = witnessInfoBuild.replace("'~'", "autofocus");
                                    }
                                    $("#witnessTable").after(witnessInfoBuild);
                                    var newWitness = '#Infowitness' + (i).toString();
                                    witnessArray.push(newWitness);

                                    loadStates("#witness" + (witnessArray.length).toString() + "StateID");
                                }
                            }
                        }
                    }
                }

                if (document.activeElement.id == 'NumberOtherInvolved') {
                    if (e.keyCode == 13) {
                        if (isNaN($("#NumberOtherInvolved").val()) == false) {
                            var InvolvedNumber = $("#NumberOtherInvolved").val();
                            if (InvolvedNumber == 0) {
                                InvolvedArray.length = 0;
                                $(".InvolvedSection").remove();
                            } else if (InvolvedNumber > InvolvedArray.length && InvolvedArray.length != 0) {
                                for (i = InvolvedNumber - InvolvedArray.length ; i > 0; i--) {
                                    InvolvedInfoBuild = InvolvedInfo;
                                    InvolvedInfoBuild = InvolvedInfoBuild.replace(/Involved1/g, 'Involved' + (InvolvedArray.length + 1).toString());
                                    InvolvedInfoBuild = InvolvedInfoBuild.replace('NO. 1', 'NO.' + (InvolvedArray.length + 1).toString());
                                    var placementTable = '#infoInvolved' + (InvolvedArray.length).toString();
                                    $(placementTable).after(InvolvedInfoBuild);
                                    var newInvolved = '#infoInvolved' + (InvolvedArray.length + 1).toString();
                                    InvolvedArray.splice(0, 0, newInvolved);
                                }
                            } else if (InvolvedNumber < InvolvedArray.length) {
                                var arrayLength = InvolvedArray.length;
                                for (i = 0; i <= arrayLength - InvolvedNumber - 1; i++) {
                                    $(InvolvedArray[0]).remove();
                                    InvolvedArray.splice(0, 1);
                                }
                            } else if (InvolvedArray.length == 0) {
                                for (i = $("#NumberOtherInvolved").val() ; i > 0; i--) {
                                    InvolvedInfoBuild = InvolvedInfo;
                                    InvolvedInfoBuild = InvolvedInfoBuild.replace(/Involved1/g, 'Involved' + (i).toString());
                                    InvolvedInfoBuild = InvolvedInfoBuild.replace('NO. 1', 'NO.' + (i).toString());
                                    if (i == 1) {
                                        InvolvedInfoBuild = InvolvedInfoBuild.replace("'~'", "autofocus");
                                    }
                                    $("#infoInvolved").after(InvolvedInfoBuild);
                                    var newInvolved = 'infoInvolved' + (i).toString();
                                    InvolvedArray.push(newInvolved);
                                }
                            }
                        }
                    }
                }

                if (document.activeElement.id == 'NumberOfPCAInvolved') {
                    if (e.keyCode == 13) {
                        if (isNaN($("#NumberOfPCAInvolved").val()) == false) {
                            var PCAInvolvedNumber = $("#NumberOfPCAInvolved").val();
                            if (PCAInvolvedNumber == 0) {
                                PCAInvolvedArray.length = 0;
                                $(".PCAInvolvedSection").remove();
                            } else if (PCAInvolvedNumber > PCAInvolvedArray.length && PCAInvolvedArray.length != 0) {
                                for (i = PCAInvolvedNumber - PCAInvolvedArray.length ; i > 0; i--) {
                                    PCAInvolvedInfoBuild = PCAInvolvedInfo;
                                    PCAInvolvedInfoBuild = PCAInvolvedInfoBuild.replace(/Involved1/g, 'Involved' + (PCAInvolvedArray.length + 1).toString());
                                    PCAInvolvedInfoBuild = PCAInvolvedInfoBuild.replace('NO. 1', 'NO.' + (PCAInvolvedArray.length + 1).toString());
                                    var placementTable = '#InfoPCAInvolved' + (PCAInvolvedArray.length).toString();
                                    $(placementTable).after(PCAInvolvedInfoBuild);
                                    var newPCAInvolved = '#InfoPCAInvolved' + (PCAInvolvedArray.length + 1).toString();
                                    PCAInvolvedArray.splice(0, 0, newPCAInvolved);
                                }
                            } else if (PCAInvolvedNumber < PCAInvolvedArray.length) {
                                var arrayLength = PCAInvolvedArray.length;
                                for (i = 0; i <= arrayLength - PCAInvolvedNumber - 1; i++) {
                                    $(PCAInvolvedArray[0]).remove();
                                    PCAInvolvedArray.splice(0, 1);
                                }
                            } else if (PCAInvolvedArray.length == 0) {
                                for (i = $("#NumberOfPCAInvolved").val() ; i > 0; i--) {
                                    PCAInvolvedInfoBuild = PCAInvolvedInfo;
                                    PCAInvolvedInfoBuild = PCAInvolvedInfoBuild.replace(/Involved1/g, 'Involved' + (i).toString());
                                    PCAInvolvedInfoBuild = PCAInvolvedInfoBuild.replace('NO. 1', 'NO.' + (i).toString());
                                    if (i == 1) {
                                        PCAInvolvedInfoBuild = PCAInvolvedInfoBuild.replace("'~'", "autofocus");
                                    }
                                    $("#InfoPCAInvolved").after(PCAInvolvedInfoBuild);
                                    var newPCAInvolved = '#InfoPCAInvolved' + (i).toString();
                                    PCAInvolvedArray.push(newPCAInvolved);
                                }
                            }
                        }
                    }
                }
                turnOffAutoComplete();
            });

            //++++++++++++++++++++++++++++++++++++++++++++ end witnesses, number of Persons Involved and PCA drivers Involved Creat UI++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            $("#Next").on('click', function () {
                window.location.href = './InsuranceEmployeeStatement.aspx?IncidentID=' + thisIncidentID;
            });

            $("#Previous").on('click', function () {
                window.location.replace("./InsuranceIncidentReport.aspx?IncidentID=" + thisIncidentID);
            });

            $("#printReport").on('click', function () {
                $("#printReport").hide();
                $("#saveContinue").hide();
                $("#Next").hide();
                $("#Previous").hide();
                window.print();
                $(document).one('click', function () {
                    $("#printReport").show();
                    $("#saveContinue").show();
                    $("#Next").show();
                    $("#Previous").show();
                });
            });

            $("#saveContinue").on("click", function () {
                saveManagerInvestigation().then(function () {
                    saveIncidentWitness();
                    saveOtherInvolved();
                    updateIncidentPCAVehicles();
                    swal({
                        title: 'Save',
                        text: "Successful",
                        confirmButtonColor: '#3085d6',
                        confirmButtonText: 'OK'
                    }).then(function () {
                        var thisIncidentID = $("#IncidentID").val();
                        window.location.href = './InsuranceEmployeeStatement.aspx?IncidentID=' + thisIncidentID;
                    });
                });
                
            });

            const params = new URLSearchParams(window.location.search);
            $("#IncidentID").val(params.get("IncidentID"));
            
            $.when(loadLocations().then(function (thisData) {
                    thisIncidentID = $("#IncidentID").val();
                    loadIncident(thisIncidentID);
                    loadIncidentPCAVehicles(thisIncidentID);
                    loadIncidentWitness(thisIncidentID);
                    loadOtherInvolved(thisIncidentID);
                }).fail(function (error) {
                    alert("error " + error);
                })
            );

            $.when(loadRecomendation().then(function (thisData) {
                    thisIncidentID = $("#IncidentID").val();
                    loadManagerInvestigation(thisIncidentID);
                }).fail(function (error) {
                    alert("error " + error);
                })
            );

            

            Security();
        });

        function loadLocations() {
            var locationString = $("#userVehicleLocation").val();
            var dropdown = $('#location');

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
                        dropdown.append($("<option style='font-weight: bold;'></option>").attr("value", data[i].LocationID).text(data[i].LocationName));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting location information.");
                }
            });
        }

        function loadRecomendation() {
            var dropdown = $('#ManagerRecomendation');

            dropdown.empty();

            dropdown.append('<option selected="true">Recomendation</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/InsuranceIncidents/getManagerRecomendation/";
            var url = $("#localApiDomain").val() + "InsuranceIncidents/getManagerRecomendation/";

            return $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append($("<option style='font-weight: bold;'></option>").attr("value", data[i].ManagerRecomendationID).text(data[i].ManagerRecomendationDesc));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting manager recomendation information.");
                }
            });
        }

        function loadStates(element, stateID, elementNumber) {
            var dropdown = $(element);

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
                    data.push(stateID);
                    data.push(elementNumber);
                },
                error: function (request, status, error) {
                    swal("There was an issue getting state information.");
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
                        $("#DateOfIncident").val(DateFormat(data[0].IncidentDate));
                        $("#TimeOfIncident").val(data[0].IncidentTime);
                        $("#LotRowSpace").val(data[0].IncidentLotRowSpace);
                        $("#ManagerName").val(data[0].FacilityManagerName);
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting location information.");
                }
            }).then(function () {
                
            });
        }

        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Start manager investigation info ++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        function loadManagerInvestigation(id) {
            var url = $("#localApiDomain").val() + "InsuranceIncidents/GetManagerInvestigationByIncidentID/" + id;
            //var url = "http://localhost:52839/api/InsuranceIncidents/GetManagerInvestigationByIncidentID/" + id;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        ManagerInvestigationID = data[0].ManagerInvestigationID;
                        $("#IncidentDesc").val(data[0].InvestigationIncidentDesc);
                        $("#CutomerInteraction").val(data[0].InvestigationCustomerInteraction);
                        $("#ManagerRecomendation").val(data[0].ManagerRecomendationID);
                        $("#PCAVehicleEstAmount").val(data[0].PCAVehicleAmountDamage);
                        $("#PCAPropertyEstAmount").val(data[0].PCAPropertyDamage);
                        $("#CustomerVehicleEstAmount").val(data[0].CustomerVehicleAmountDamage);
                        $("#SignatureDate").val(DateFormatForHTML5(data[0].InvestigationDate));
                        $("#ManagerSignature").val(data[0].ManagerSignature);
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting Manager Investigation information.");
                }
            }).then(function () {

            });
        }

        function saveManagerInvestigation() {

            var InvestigationIncidentDesc = $("#IncidentDesc").val();
            var InvestigationCustomerInteraction = $("#CutomerInteraction").val();
            var ManagerRecomendationID = $("#ManagerRecomendation").val();
            var PCAVehicleAmountDamage = $("#PCAVehicleEstAmount").val();
            var InvestigationDate = $("#SignatureDate").val();
            var CustomerVehicleAmountDamage = $("#CustomerVehicleEstAmount").val();
            var ManagerSignature = $("#ManagerSignature").val();
            var PCAPropertyDamage = $("#PCAPropertyEstAmount").val();
            var thisIncidentID = $("#IncidentID").val();

            if (ManagerInvestigationID != 0) {
                var url = $("#localApiDomain").val() + "InsuranceIncidents/PutManagerInvestigation/";
                //var url = "http://localhost:52839/api/InsuranceIncidents/PutManagerInvestigation/";
            } else {
                var url = $("#localApiDomain").val() + "InsuranceIncidents/PostManagerInvestigation/";
                //var url = "http://localhost:52839/api/InsuranceIncidents/PostManagerInvestigation/";
            }

            return $.ajax({
                type: "POST",
                url: url,
                data: {
                    "IncidentID": thisIncidentID,
                    "InvestigationIncidentDesc": InvestigationIncidentDesc,
                    "InvestigationCustomerInteraction": InvestigationCustomerInteraction,
                    "ManagerRecomendationID": ManagerRecomendationID,
                    "PCAVehicleAmountDamage": PCAVehicleAmountDamage,
                    "InvestigationDate": InvestigationDate,
                    "CustomerVehicleAmountDamage": CustomerVehicleAmountDamage,
                    "ManagerSignature": ManagerSignature,
                    "PCAPropertyDamage": PCAPropertyDamage,
                    "ManagerInvestigationID": ManagerInvestigationID
                },
                dataType: "json",
                success: function (data) {
                    ManagerInvestigationID = data;
                },
                error: function (request, status, error) {
                    swal("Error saving witness " + i);
                }
            }).then(function () {

            });
        }

        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ End manager investigation info ++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        //++++++++++++++++++++++++++++++++++++++++++++ Start Witness INFO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        function loadIncidentWitness(id) {

            //var url = "http://localhost:52839/api/InsuranceIncidents/GetIncidentWitnessByIncidentID/" + id;
            var url = $("#localApiDomain").val() + "InsuranceIncidents/GetIncidentWitnessByIncidentID/" + id;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    if (data.length == 0) {
                        return;
                    }

                    $("#NumberOfWitnesses").val(data.length);
                    var thisElementNum = 0;
                    var PCAWitnessInfo = "";

                    for (i = data.length - 1 ; i >= 0; i--) {
                        PCAWitnessInfo = witnessInfo;
                        PCAWitnessInfo = PCAWitnessInfo.replace(/witness1/g, 'witness' + (i + 1).toString());
                        PCAWitnessInfo = PCAWitnessInfo.replace('NO. 1', 'NO. ' + (i + 1).toString());

                        $("#witnessTable").after(PCAWitnessInfo);
                        var newWitness = '#Infowitness' + (i + 1).toString();
                        witnessArray.push(newWitness);

                        $("#witness" + (i + 1).toString() + "WitnessID").val(data[i].WitnessID);
                        $("#witness" + (i + 1).toString() + "name").val(data[i].WitnessName);
                        $("#witness" + (i + 1).toString() + "Address").val(data[i].WitnessAddress);
                        $("#witness" + (i + 1).toString() + "City").val(data[i].WitnessCity);
                        $("#witness" + (i + 1).toString() + "Zip").val(data[i].WitnessZip);
                        $("#witness" + (i + 1).toString() + "Phone").val(data[i].WitnessPhone);
                        $("input[name=" + "witness" + (i + 1).toString() + "Passenger" + "][value=" + data[i].Passenger + "]").prop('checked', true);

                        $.when(loadStates("#witness" + (i + 1).toString() + "StateID", data[i].WitnessStateID, i + 1).then(function (thisData) {
                            var WitnessStateElement = "#witness" + thisData[thisData.length - 1] + "StateID option[value='" + thisData[thisData.length - 2] + "']";
                            $(WitnessStateElement).prop("selected", true);

                        }).fail(function (error) {
                            alert("error loading witness states: " + error);
                        })
                        );

                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting PCA witness information.");
                }
            });
        }

        function saveIncidentWitness() {
            var WitnessID = "";
            var Name = "";
            var StreetAddress = "";
            var City = "";
            var StateID = "";
            var Zip = "";
            var Phone = "";
            var Passenger = "";

            for (var i = 1; i <= witnessArray.length; i++) {

                WitnessID = $("#witness" + (i).toString() + "WitnessID").val();
                Name = $("#witness" + (i).toString() + "name").val();
                StreetAddress = $("#witness" + (i).toString() + "Address").val();
                City = $("#witness" + (i).toString() + "City").val();
                StateID = $("#witness" + (i).toString() + "StateID").val();
                Zip = $("#witness" + (i).toString() + "Zip").val();
                Phone = $("#witness" + (i).toString() + "Phone").val();
                Passenger = $("input[name='" + "witness" + (i).toString() + "Passenger" + "']:checked").val();

                if (WitnessID != "") {
                    var url = $("#localApiDomain").val() + "InsuranceIncidents/PutIncidentWitness/";
                    //var url = "http://localhost:52839/api/InsuranceIncidents/PutIncidentWitness/";
                } else {
                    var url = $("#localApiDomain").val() + "InsuranceIncidents/PostIncidentWitness/";
                    //var url = "http://localhost:52839/api/InsuranceIncidents/PostIncidentWitness/";
                }
                

                $.ajax({
                    type: "POST",
                    url: url,
                    data: {
                        "WitnessID": WitnessID,
                        "ManagerInvestigationID": ManagerInvestigationID,
                        "WitnessName": Name,
                        "WitnessAddress": StreetAddress,
                        "WitnessStateID": StateID,
                        "WitnessCity": City,
                        "WitnessZip": Zip,
                        "WitnessPhone": Phone,
                        "Passenger": Passenger
                    },
                    dataType: "json",
                    success: function (data) {

                    },
                    error: function (request, status, error) {
                        swal("Error saving witness " + i);
                    }
                }).then(function () {

                });;
            }
        }

        //+++++++++++++++++++++++++++++++++++++++++++++ End Witness INFO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        //++++++++++++++++++++++++++++++++++++++++++++ Start Other Involved INFO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

        function loadOtherInvolved(id) {

            //var url = "http://localhost:52839/api/InsuranceIncidents/GetIncidentOtherInvolvedByManagerIncidentID/" + id;
            var url = $("#localApiDomain").val() + "InsuranceIncidents/GetIncidentOtherInvolvedByManagerIncidentID/" + id;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    if (data.length == 0) {
                        return;
                    }

                    $("#NumberOtherInvolved").val(data.length);
                    var thisElementNum = 0;
                    var otherInvolvedBuild = "";

                    for (i = data.length - 1 ; i >= 0; i--) {
                        otherInvolvedBuild = InvolvedInfo;
                        otherInvolvedBuild = otherInvolvedBuild.replace(/Involved1/g, 'Involved' + (i + 1).toString());
                        otherInvolvedBuild = otherInvolvedBuild.replace('NO. 1', 'NO. ' + (i + 1).toString());

                        $("#infoInvolved").after(otherInvolvedBuild);
                        var newInvolved = '#InfoPCAInvolved' + (i + 1).toString();
                        InvolvedArray.push(newInvolved);

                        $("#Involved" + (i + 1).toString() + "IncidentOtherInvolvedID").val(data[i].IncidentOtherInvolvedID);
                        $("#Involved" + (i + 1).toString() + "name").val(data[i].OtherInvolvedName);
                        $("#Involved" + (i + 1).toString() + "Phone").val(data[i].OtherInvolvedPhone);
                        $("#Involved" + (i + 1).toString() + "Role").val(data[i].OtherInvolvedRole);
                        $("#Involved" + (i + 1).toString() + "damage").val(data[i].OtherInvolvedDamageInjury);

                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting Other Involved information.");
                }
            });
        }

        function saveOtherInvolved() {
            var IncidentOtherInvolvedID = "";
            var OtherInvolvedName = "";
            var OtherInvolvedPhone = "";
            var OtherInvolvedRole = "";
            var OtherInvolvedDamageInjury = "";

            for (var i = 1; i <= InvolvedArray.length; i++) {

                IncidentOtherInvolvedID = $("#Involved" + (i).toString() + "IncidentOtherInvolvedID").val();
                OtherInvolvedName = $("#Involved" + (i).toString() + "name").val();
                OtherInvolvedPhone = $("#Involved" + (i).toString() + "Phone").val();
                OtherInvolvedRole = $("#Involved" + (i).toString() + "Role").val();
                OtherInvolvedDamageInjury = $("#Involved" + (i).toString() + "damage").val();

                if (IncidentOtherInvolvedID != "") {
                    var url = $("#localApiDomain").val() + "InsuranceIncidents/PutIncidentOtherInvolved/";
                    //var url = "http://localhost:52839/api/InsuranceIncidents/PutIncidentOtherInvolved/";
                } else {
                    var url = $("#localApiDomain").val() + "InsuranceIncidents/PostIncidentOtherInvolved/";
                    //var url = "http://localhost:52839/api/InsuranceIncidents/PostIncidentOtherInvolved/";
                }

                $.ajax({
                    type: "POST",
                    url: url,
                    data: {
                        "IncidentOtherInvolvedID": IncidentOtherInvolvedID,
                        "ManagerInvestigationID": ManagerInvestigationID,
                        "OtherInvolvedName": OtherInvolvedName,
                        "OtherInvolvedPhone": OtherInvolvedPhone,
                        "OtherInvolvedRole": OtherInvolvedRole,
                        "OtherInvolvedDamageInjury": OtherInvolvedDamageInjury
                    },
                    dataType: "json",
                    success: function (data) {

                    },
                    error: function (request, status, error) {
                        swal("Error saving witness " + i);
                    }
                }).then(function () {

                });
            }
        }

        //+++++++++++++++++++++++++++++++++++++++++++++ End OtherInvolved INFO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


        //+++++++++++++++++++++++++++++++++++++++++++++++ START PCA DRIVER INFO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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
                    if (data.length == 0) {
                        return;
                    }

                    $("#NumberOfPCAInvolved").val(data.length);
                    var thisElementNum = 0;
                    var vehicleInfoBuild = "";

                    for (i = data.length - 1 ; i >= 0; i--) {
                        vehicleInfoBuild = PCAInvolvedInfo;
                        vehicleInfoBuild = vehicleInfoBuild.replace(/Involved1/g, 'Involved' + (i + 1).toString());
                        vehicleInfoBuild = vehicleInfoBuild.replace('NO. 1', 'NO. ' + (i + 1).toString());

                        $("#InfoPCAInvolved").after(vehicleInfoBuild);
                        var newVehicle = '#InfoPCAInvolved' + (i + 1).toString();
                        PCAInvolvedArray.push(newVehicle);

                        $("#PCAInvolved" + (i + 1).toString() + "ClaimID").val(data[i].ClaimID);
                        $("#PCAInvolved" + (i + 1).toString() + "name").val(data[i].DriverName);
                        $("#PCAInvolved" + (i + 1).toString() + "DateOfHire").val(DateFormatForHTML5(data[i].DateOfHire));
                        $("input[name=PCAInvolved" + (i + 1).toString() + "DrugTest][value=" + data[i].DrugTest + "]").prop('checked', true);

                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting PCA vehicle information information.");
                }
            });
        }

        function updateIncidentPCAVehicles() {
            var ClaimID = "";
            var DrugTest = "";
            var DateOfHire = "";

            for (var i = 1; i <= PCAInvolvedArray.length; i++) {

                ClaimID = $("#PCAInvolved" + (i).toString() + "ClaimID").val();
                DrugTest = $("input[name='" + "PCAInvolved" + (i).toString() + "DrugTest" + "']:checked").val();
                DateOfHire = $("#PCAInvolved" + (i).toString() + "DateOfHire").val();

                var url = $("#localApiDomain").val() + "InsuranceIncidents/PutPCAVehicleFromInvestigation/";
                //var url = "http://localhost:52839/api/InsuranceIncidents/PutPCAVehicleFromInvestigation/";

                $.ajax({
                    type: "POST",
                    url: url,
                    data: {
                        "DateOfHire": DateOfHire,
                        "DrugTest": DrugTest,
                        "ClaimID": ClaimID
                    },
                    dataType: "json",
                    success: function (data) {

                    },
                    error: function (request, status, error) {
                        swal("Error saving Driver Involved " + i);
                    }
                }).then(function () {

                });;
            }
        }

        //+++++++++++++++++++++++++++++++++++++++++++++++ END PCA DRIVER INFO ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    </script>

    <style>
        
        .font519097
	        {color:black;
	        font-size:8.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:"Segoe UI", sans-serif;
	        mso-font-charset:0;}
        .xl1519097
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
        .xl6719097
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
        .xl6819097
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
        .xl6919097
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
	        border-top:none;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7019097
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
        .xl7119097
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
	        background:#D9D9D9;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl7219097
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
        .xl7319097
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
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7419097
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
	        border-top:none;
	        border-right:none;
	        border-bottom:1.0pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7519097
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
	        border-bottom:1.0pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl7619097
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
	        white-space:normal;}
        .xl7719097
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
        .xl7819097
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
	        border-top:.5pt solid windowtext;
	        border-right:.5pt solid windowtext;
	        border-bottom:none;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7919097
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
	        border-top:none;
	        border-right:.5pt solid windowtext;
	        border-bottom:.5pt solid windowtext;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8019097
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
	        text-align:left;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8119097
	        {padding:0px;
	        mso-ignore:padding;
	        color:black;
	        font-size:8.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:top;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8219097
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
	        border-top:none;
	        border-right:.5pt solid windowtext;
	        border-bottom:.5pt solid windowtext;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8319097
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
	        text-align:right;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8419097
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
        .xl8519097
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
        .xl8619097
	        {padding:0px;
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
        .xl8719097
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
        .xl8819097
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
        .xl8919097
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
        .xl9019097
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
	        border:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl9119097
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
	        border:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl9219097
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
	        border-top:1.0pt solid windowtext;
	        border-right:none;
	        border-bottom:1.0pt solid windowtext;
	        border-left:1.0pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl9319097
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
	        border-top:1.0pt solid windowtext;
	        border-right:none;
	        border-bottom:1.0pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl9419097
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
	        border-top:1.0pt solid windowtext;
	        border-right:1.0pt solid windowtext;
	        border-bottom:1.0pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl9519097
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
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl9619097
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
        .xl9719097
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
        .xl9819097
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
        .auto-style1 {
            height: 62px;
        }
        .auto-style2 {
            table-layout: fixed;
            width: 603pt;
        }
        .auto-style3 {
            height: 26px;
            margin-bottom: 0;
        }
        -->
        </style>
       

        <div align=center>
        <input type="text" id="IncidentID" style="display:none" />
        <table id="witnessTable" border=0 cellpadding=0 cellspacing=0 width=802 style='border-collapse:
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
          <td height=21 class=xl1519097 width=19 style='height:15.75pt;width:14pt'><a
          name="RANGE!A1:I71"></a></td>
          <td class=xl1519097 width=182 style='width:137pt'></td>
          <td class=xl1519097 width=17 style='width:13pt'></td>
          <td class=xl1519097 width=177 style='width:133pt'></td>
          <td class=xl1519097 width=17 style='width:13pt'></td>
          <td class=xl1519097 width=177 style='width:133pt'></td>
          <td class=xl1519097 width=17 style='width:13pt'></td>
          <td class=xl1519097 width=177 style='width:133pt'></td>
          <td class=xl1519097 width=19 style='width:14pt'></td>
         </tr>
         <tr height=22 style='height:16.5pt'>
          <td height=22 class=xl1519097 style='height:16.5pt'></td>
          <td colspan=7 class=xl8719097 style='border-right:1.0pt solid black'>FACILITY
          MANAGER INVESTIGATION OF INCIDENT</td>
          <td class=xl1519097></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1519097 style='height:15.75pt'></td>
          <td class=xl7319097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=60 style='mso-height-source:userset;height:45.0pt'>
          <td height=60 class=xl1519097 style='height:45.0pt'></td>
          <td colspan=7 class=xl9219097 width=764 style='border-right:1.0pt solid black;
          width:575pt;padding:3px;'>Information requested on this form must be accurate and
          complete.<span style='mso-spacerun:yes'>  </span>Each Incident, whether
          serious or minor, should be investigated to prevent recurrence.<span
          style='mso-spacerun:yes'>  </span>Record or take notes of your interviews
          with the injured and witnesses.<span style='mso-spacerun:yes'>  </span>Visit
          the scene of the Incident to record all factual observations.</td>
          <td class=xl1519097></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1519097 style='height:15.75pt'></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1519097 style='height:15.75pt'></td>
          <td class=xl6819097>PCA INCIDENT #</td>
          <td class=xl1519097></td>
          <td class=xl7719097>
              <input id="IncidentNumber" type="text" style="border:none" disabled/></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl6819097>Facility Manager Name</td>
          <td class=xl1519097></td>
          <td colspan=3 class=xl9519097>
              <input id="ManagerName" type="text" style="border:none" disabled/></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl6819097>DATE OF INCIDENT</td>
          <td class=xl1519097></td>
          <td class=xl6719097>
              <input id="DateOfIncident" type="text" style="border:none" disabled/></td>
          <td class=xl1519097></td>
          <td class=xl6819097>PCA LOCATION</td>
          <td class=xl1519097></td>
          <td class=xl6719097><select id="location" style="border:none" disabled></select></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl6819097>TIME OF INCIDENT</td>
          <td class=xl1519097></td>
          <td class=xl6719097 style='border-top:none'>
              <input id="TimeOfIncident" type="text" style="border:none" disabled/></td>
          <td class=xl1519097></td>
          <td class=xl6819097>LOT--ROW--SPACE</td>
          <td class=xl1519097></td>
          <td class=xl6719097 style='border-top:none'>
              <input id="LotRowSpace" type="text" style="border:none" disabled/></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl6819097>NUMBER OF WITNESSES:</td>
          <td class=xl1519097></td>
          <td class=xl6719097>
              <input id="NumberOfWitnesses" type="text" style="border:none" /></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         </table>
        <table id="infoInvolved" border=0 cellpadding=0 cellspacing=0 width=802 style='border-collapse:
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
          <td height=21 class=xl1519097 style='height:15.75pt'></td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl6819097 colspan=5># OF PERSONS Involved (OTHER DRIVERS, CASHIERS,
          PASSENGERS, PEDESTRIANS, ETC.):</td>
          <td class=xl1519097></td>
          <td class=xl7819097>
              <input id="NumberOtherInvolved" type="text" style="border:none;border-bottom: .5pt solid windowtext;" /></td>
          <td class=xl1519097></td>
         </tr>
        </table>
        <table id="InfoPCAInvolved" border=0 cellpadding=0 cellspacing=0 width=802 style='border-collapse:
         collapse;' class="auto-style2">
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
          <td height=21 class=xl1519097 style='height:15.75pt'></td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl6819097># OF PCA Drivers Involved::</td>
          <td class=xl1519097></td>
          <td class=xl6719097>
              <input id="NumberOfPCAInvolved" type="text" style="border:none" /></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
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
          <td height=21 class=xl1519097 style='height:15.75pt'></td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl7419097>&nbsp;</td>
          <td class=xl7519097 width=177 style='width:133pt'>&nbsp;</td>
          <td class=xl7519097 width=17 style='width:13pt'>&nbsp;</td>
          <td class=xl7519097 width=177 style='width:133pt'>&nbsp;</td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl6819097 colspan=3>HOW DID THE INCIDENT OCCUR, WHAT HAPPENED?</td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=75 style='mso-height-source:userset;height:56.25pt'>
          <td height=75 class=xl1519097 style='height:56.25pt'></td>
          <td colspan=7 class=xl9619097 width=764 style='border-right:.5pt solid black;
          width:575pt'>
              <textarea id="IncidentDesc" class="auto-style1" cols="20" name="S1" style="border:none"></textarea></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl6819097 colspan=3>HOW WAS THIS INCIDENT HANDLED WITH THE
          CUSTOMER?</td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=75 style='mso-height-source:userset;height:56.25pt'>
          <td height=75 class=xl1519097 style='height:56.25pt'></td>
          <td colspan=7 class=xl9619097 width=764 style='border-right:.5pt solid black;
          width:575pt'>
              <textarea id="CutomerInteraction" class="auto-style1" cols="20" name="S2" style="border:none" rows="1"></textarea></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl8519097></td>
          <td class=xl8519097></td>
          <td class=xl8519097></td>
          <td class=xl8519097></td>
          <td class=xl8519097></td>
          <td class=xl8519097></td>
          <td class=xl8519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl8019097>Manager Recommendation</td>
          <td class=xl8519097></td>
          <td colspan=5 class=xl9019097>
              <select id="ManagerRecomendation" style="border:none"></select></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl8119097>Select One</td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl7219097 colspan=3>ESTIMATED AMOUNT OF DAMAGE:</td>
          <td class=xl1519097></td>
          <td class=xl1519097><span style='mso-spacerun:yes'> </span></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl6819097>PCA VEHICLE (&gt; $2,500)</td>
          <td class=xl1519097></td>
          <td class=xl6719097>
            <select id="PCAVehicleEstAmount" style="border:none">
                <option value="-1" selected></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">Unknown</option>
            </select>
          </td>
          <td class=xl1519097></td>
          <td class=xl6819097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl6819097>PCA PROPERTY (&gt; $10,000)</td>
          <td class=xl1519097></td>
          <td class=xl6719097 style='border-top:none'>
            <select id="PCAPropertyEstAmount" style="border:none">
                <option value="-1" selected></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">Unknown</option>
            </select>
          </td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl6819097>CUSTOMER VEHICLE (&gt; $500)</td>
          <td class=xl1519097></td>
          <td class=xl6719097 style='border-top:none'>
              <select id="CustomerVehicleEstAmount" style="border:none">
                <option value="-1" selected></option>
                <option value="1">Yes</option>
                <option value="0">No</option>
                <option value="2">Unknown</option>
            </select>
          </td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097><span style='mso-spacerun:yes'> </span></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl6919097 colspan="3">
              <input id="ManagerSignature" type="text" style="border:none" /></td>
          <td class=xl1519097></td>
          <td class=xl6919097>
              <input id="SignatureDate" type="date" style="border:none" /></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl6819097>Manager's Signature</td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl6819097>Date</td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td id="scCell"><input id="saveContinue" type="button" value="Save & Continue" style="background-color:black;color:white;font-weight:bold" class="auto-style3" /></td>
          <td class=xl1519097></td>
          <td id="printCell"><input id="printReport" type="button" value="Print Report" style="height:26px;background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl8619097>SECTION 2 OF 5</td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1527147 style='height:15.0pt'></td>
          <td class=xl6819097><input id="Previous" type="button" value="&larr; Previous" style="background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl1527147></td>
          <td class=xl7627147></td>
          <td class=xl1527147></td>
          <td class=xl8227147></td>
          <td class=xl1527147></td>
          <td class=xl6819097><input id="Next" type="button" value="NEXT &rarr;" style="background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl1527147></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1517237 style='height:15.0pt'></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
          <td class=xl1517237></td>
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
        var witnessInfo = "<table id='Infowitness1' class='witnessSection' border=0 cellpadding=0 cellspacing=0 width=802 style='border-collapse:" +
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
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl7219097>WITNESS NO. 1</td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl6819097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097>Witness Name</td>" +
                            "<td class=xl1519097></td>" +
                            "<td colspan=5 class=xl9119097 width=565 style='width:425pt'>" +
                            "<input id='witness1name' type='text' style='border:none' /><input type='text' id='witness1WitnessID' style='display:none' /></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097>Street Address</td>" +
                            "<td class=xl1519097></td>" +
                            "<td colspan=5 class=xl9119097 width=565 style='width:425pt'>" +
                            "<input id='witness1Address' type='text' style='border:none' /></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097>City</td>" +
                            "<td class=xl1519097></td>" +
                            "<td colspan=5 class=xl9119097 width=565 style='width:425pt'>" +
                            "<input id='witness1City' type='text' style='border:none' /></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097>State</td>" +
                            "<td class=xl1519097></td>" +
                            "<td colspan=5 class=xl9119097 width=565 style='width:425pt'>" +
                            "<select id='witness1StateID' style='border:none'></select></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097>Zip Code</td>" +
                            "<td class=xl1519097></td>" +
                            "<td colspan=5 class=xl9119097 width=565 style='width:425pt'>" +
                            "<input id='witness1Zip' type='text' style='border:none' /></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097>Phone #</td>" +
                            "<td class=xl1519097></td>" +
                            "<td colspan=5 class=xl9119097 width=565 style='width:425pt'>" +
                            "<input id='witness1Phone' type='text' style='border:none' /></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097>Passenger<span style='mso-spacerun:yes'> </span></td>" +
                            "<td class=xl1519097></td>" +
                            "<td colspan=5 class=xl9119097 width=565 style='width:425pt'>" +
                            "<input name='witness1Passenger' type='radio' value='1' style='width:25px' />Yes<input name='witness1Passenger' type='radio' value='0' style='width:25px' />No</td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl6819097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "</table>";

        var InvolvedInfo = "<table id='infoInvolved1' class='InvolvedSection' border=0 cellpadding=0 cellspacing=0 width=802 style='border-collapse:" +
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
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl7219097>Others NO. 1</td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097>Name</td>" +
                            "<td class=xl6819097></td>" +
                            "<td colspan=5 class=xl9119097 width=565 style='width:425pt'>" +
                            "<input id='Involved1name' type='text' style='border:none' /><input type='text' id='Involved1IncidentOtherInvolvedID' style='display:none' /></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097>Phone<span style='mso-spacerun:yes'> </span></td>" +
                            "<td class=xl6819097></td>" +
                            "<td class=xl8219097>" +
                            "<input id='Involved1Phone' type='text' style='border:none' /></td>" +
                            "<td class=xl6819097></td>" +
                            "<td class=xl8319097>Role in Incident</td>" +
                            "<td class=xl6819097></td>" +
                            "<td class=xl8219097>" +
                            "<input id='Involved1Role' type='text' style='border:none' /></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097>Describe Damage/Injury</td>" +
                            "<td class=xl1519097></td>" +
                            "<td colspan=5 class=xl9119097 width=565 style='width:425pt'>" +
                            "<input id='Involved1damage' type='text' style='border:none' /></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=21 style='height:15.75pt'>" +
                            "<td height=21 class=xl1519097 style='height:15.75pt'></td>" +
                            "<td class=xl1519097>&nbsp;</td>" +
                            "<td class=xl1519097>&nbsp;</td>" +
                            "<td class=xl1519097>&nbsp;</td>" +
                            "<td class=xl1519097>&nbsp;</td>" +
                            "<td class=xl1519097>&nbsp;</td>" +
                            "<td class=xl1519097>&nbsp;</td>" +
                            "<td class=xl1519097>&nbsp;</td>" +
                            "<td class=xl1519097></td>" +
                            "</tr> " +
                            "</table>";

        var PCAInvolvedInfo = "<table id='InfoPCAInvolved1' class='PCAInvolvedSection' border=0 cellpadding=0 cellspacing=0 width=802 style='border-collapse: " +
                            "collapse;table-layout:fixed;width:603pt'> " +
                            "<col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'> " +
                            "<col width=182 style='mso-width-source:userset;mso-width-alt:6656;width:137pt'> " +
                            "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'> " +
                            "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'> " +
                            "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'> " +
                            "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'> " +
                            "<col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'> " +
                            "<col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'> " +
                            "<col width=19 style='mso-width-source:userset;mso-width-alt:694;width:14pt'> " +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl7219097>PCA Driver NO. 1</td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097>DRIVERS NAME</td>" +
                            "<td class=xl1519097></td>" +
                            "<td colspan=5 class=xl9019097>" +
                            "<input id='PCAInvolved1name' type=text style=border:none /><input type='text' id='PCAInvolved1ClaimID' style='display:none' /></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=19 style='mso-height-source:userset;height:14.45pt'>" +
                            "<td height=19 class=xl1519097 style='height:14.45pt'></td>" +
                            "<td class=xl1519097>DATE OF HIRE</td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl7919097>" +
                            "<input id='PCAInvolved1DateOfHire' type='date' style='border:none' /></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl7619097 width=17 style='width:13pt'></td>" +
                            "<td class=xl7619097 width=177 style='width:133pt'></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=22 style='mso-height-source:userset;height:16.5pt'>" +
                            "<td height=22 class=xl1519097 style='height:16.5pt'></td>" +
                            "<td class=xl1519097 colspan=2>DRIVER SENT FOR DRUG TEST?</td>" +
                            "<td align=left valign=top></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl7619097 width=177 style='width:133pt'><input name='PCAInvolved1DrugTest' type='radio' value='1' style='width:25px' />Yes&nbsp;<input name='PCAInvolved1DrugTest' type='radio' value='0' style='width:25px' />No</td>" +
                            "<td class=xl7619097 width=17 style='width:13pt'></td>" +
                            "<td class=xl7619097 width=177 style='width:133pt'></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl1519097></td>" +
                            "<td colspan=5 class=xl8419097 width=565 style='width:425pt'>*If no, Manager " +
                            "needs to forward a separate explanation to the insurance Department</td>" +
                            "<td class=xl1519097></td>" +
                            "</tr> " +
                            "<tr height=21 style='height:15.75pt'> " +
                            "<td height=21 class=xl1519097 style='height:15.75pt'></td> " +
                            "<td class=xl7419097>&nbsp;</td> " +
                            "<td class=xl7419097>&nbsp;</td> " +
                            "<td class=xl7419097>&nbsp;</td> " +
                            "<td class=xl7419097>&nbsp;</td> " +
                            "<td class=xl7419097>&nbsp;</td> " +
                            "<td class=xl7419097>&nbsp;</td> " +
                            "<td class=xl7419097>&nbsp;</td> " +
                            "<td class=xl1519097></td> " +
                            "</tr>" +
                            "</table>";


        </script>
</asp:Content>

