<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceManagerInvestigation.aspx.cs" Inherits="InsuranceManagerInvestigation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script>
        var witnessArray = [];
        var involvedArray = [];
        var PCAInvolvedArray = [];

        $(document).ready(function () {
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
                        }
                    }
                }
            });

            $("#NumberOfInvolved").on('blur', function () {
                if (isNaN($("#NumberOfInvolved").val()) == false) {
                    var involvedNumber = $("#NumberOfInvolved").val();
                    if (involvedNumber == 0) {
                        involvedArray.length = 0;
                        $(".involvedSection").remove();
                    } else if (involvedNumber > involvedArray.length && involvedArray.length != 0) {
                        for (i = involvedNumber - involvedArray.length ; i > 0; i--) {
                            involvedInfoBuild = involvedInfo;
                            involvedInfoBuild = involvedInfoBuild.replace(/Involved1/g, 'Involved' + (involvedArray.length + 1).toString());
                            involvedInfoBuild = involvedInfoBuild.replace('NO. 1', 'NO.' + (involvedArray.length + 1).toString());
                            var placementTable = '#infoInvolved' + (involvedArray.length).toString();
                            $(placementTable).after(involvedInfoBuild);
                            var newInvolved = '#infoInvolved' + (involvedArray.length + 1).toString();
                            involvedArray.splice(0, 0, newInvolved);
                            var thisFocus = "#involved" + (i).toString() + "name";
                            $(thisFocus).focus();
                        }
                    } else if (involvedNumber < involvedArray.length) {
                        var arrayLength = involvedArray.length;
                        for (i = 0; i <= arrayLength - involvedNumber - 1; i++) {
                            $(involvedArray[0]).remove();
                            involvedArray.splice(0, 1);
                        }
                    } else if (involvedArray.length == 0) {
                        for (i = $("#NumberOfInvolved").val() ; i > 0; i--) {
                            involvedInfoBuild = involvedInfo;
                            involvedInfoBuild = involvedInfoBuild.replace(/involved1/g, 'involved' + (i).toString());
                            involvedInfoBuild = involvedInfoBuild.replace('NO. 1', 'NO.' + (i).toString());
                            if (i == 1) {
                                involvedInfoBuild = involvedInfoBuild.replace("'~'", "autofocus");
                            }
                            $("#infoInvolved").after(involvedInfoBuild);
                            var newInvolved = 'infoInvolved' + (i).toString();
                            involvedArray.push(newInvolved);
                            var thisFocus = "#involved" + (i).toString() + "name";
                            $(thisFocus).focus();
                        }
                    }
                }
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
                                }
                            }
                        }
                    }
                }

                if (document.activeElement.id == 'NumberOfInvolved') {
                    if (isNaN($("#NumberOfInvolved").val()) == false) {
                        var involvedNumber = $("#NumberOfInvolved").val();
                        if (involvedNumber == 0) {
                            involvedArray.length = 0;
                            $(".involvedSection").remove();
                        } else if (involvedNumber > involvedArray.length && involvedArray.length != 0) {
                            for (i = involvedNumber - involvedArray.length ; i > 0; i--) {
                                involvedInfoBuild = involvedInfo;
                                involvedInfoBuild = involvedInfoBuild.replace(/Involved1/g, 'Involved' + (involvedArray.length + 1).toString());
                                involvedInfoBuild = involvedInfoBuild.replace('NO. 1', 'NO.' + (involvedArray.length + 1).toString());
                                var placementTable = '#infoInvolved' + (involvedArray.length).toString();
                                $(placementTable).after(involvedInfoBuild);
                                var newInvolved = '#infoInvolved' + (involvedArray.length + 1).toString();
                                involvedArray.splice(0, 0, newInvolved);
                            }
                        } else if (involvedNumber < involvedArray.length) {
                            var arrayLength = involvedArray.length;
                            for (i = 0; i <= arrayLength - involvedNumber - 1; i++) {
                                $(involvedArray[0]).remove();
                                involvedArray.splice(0, 1);
                            }
                        } else if (involvedArray.length == 0) {
                            for (i = $("#NumberOfInvolved").val() ; i > 0; i--) {
                                involvedInfoBuild = involvedInfo;
                                involvedInfoBuild = involvedInfoBuild.replace(/involved1/g, 'involved' + (i).toString());
                                involvedInfoBuild = involvedInfoBuild.replace('NO. 1', 'NO.' + (i).toString());
                                if (i == 1) {
                                    involvedInfoBuild = involvedInfoBuild.replace("'~'", "autofocus");
                                }
                                $("#infoInvolved").after(involvedInfoBuild);
                                var newInvolved = 'infoInvolved' + (i).toString();
                                involvedArray.push(newInvolved);
                            }
                        }
                    }
                }

                if (document.activeElement.id == 'NumberOfPCAInvolved') {
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
            });

            $("#printReport").on('click', function () {
                $("#printReport").hide();
                $("#saveContinue").hide();
                window.print();
                $(document).one('click', function () {
                    $("#printReport").show();
                    $("#saveContinue").show();
                });
            });

            $("#saveContinue").on("click", function () {
                window.location.href = './InsuranceEmployeeStatement.aspx'
            });

            loadLocations();
        });

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
        -->
        </style>
       

        <div align=center>

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
              <input id="IncidentNumber" type="text" style="border:none" /></td>
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
              <input id="ManagerName" type="text" style="border:none" /></td>
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
              <input id="DateOfIncident" type="text" style="border:none" /></td>
          <td class=xl1519097></td>
          <td class=xl6819097>PCA LOCATION</td>
          <td class=xl1519097></td>
          <td class=xl6719097><select id="location" style="border:none"></select></td>
          <td class=xl1519097></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1519097 style='height:15.0pt'></td>
          <td class=xl6819097>TIME OF INCIDENT</td>
          <td class=xl1519097></td>
          <td class=xl6719097 style='border-top:none'>
              <input id="TimeOfIncident" type="text" style="border:none" /></td>
          <td class=xl1519097></td>
          <td class=xl6819097>LOT--ROW--SPACE</td>
          <td class=xl1519097></td>
          <td class=xl6719097 style='border-top:none'>
              <input id="LotRowSpace" type="text" style="border:none" /></td>
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
          <td class=xl6819097 colspan=5># OF PERSONS INVOLVED (OTHER DRIVERS, CASHIERS,
          PASSENGERS, PEDESTRIANS, ETC.):</td>
          <td class=xl1519097></td>
          <td class=xl7819097>
              <input id="NumberOfInvolved" type="text" style="border:none;border-bottom: .5pt solid windowtext;" /></td>
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
              <input id="ManagerRecomendation" type="text" style="border:none" /></td>
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
              <input id="PCAVehicleEstAmount" type="text" style="border:none" /></td>
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
              <input id="PCAPropertyEstAmount" type="text" style="border:none" /></td>
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
              <input id="CustomerVehicleEstAmount" type="text" style="border:none" /></td>
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
              <input id="ManagersSignature" type="text" style="border:none" /></td>
          <td class=xl1519097></td>
          <td class=xl6919097>
              <input id="SignatureDate" type="text" style="border:none" /></td>
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
          <td id="scCell"><input id="saveContinue" type="button" value="Save & Continue" style="height:26px;background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl1519097></td>
          <td id="printCell"><input id="printReport" type="button" value="Print Report" style="height:26px;background-color:black;color:white;font-weight:bold" /></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl1519097></td>
          <td class=xl8619097>PAGE 2 OF 5</td>
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
                            "<input id='witness1name' type='text' style='border:none' /></td>" +
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
                            "<input id='witnessCity' type='text' style='border:none' /></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097>State</td>" +
                            "<td class=xl1519097></td>" +
                            "<td colspan=5 class=xl9119097 width=565 style='width:425pt'>" +
                            "<input id='witnessState' type='text' style='border:none' /></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097>Zip Code</td>" +
                            "<td class=xl1519097></td>" +
                            "<td colspan=5 class=xl9119097 width=565 style='width:425pt'>" +
                            "<input id='witnessZip' type='text' style='border:none' /></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097>Phone #</td>" +
                            "<td class=xl1519097></td>" +
                            "<td colspan=5 class=xl9119097 width=565 style='width:425pt'>" +
                            "<input id='witnessPhone' type='text' style='border:none' /></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097>Passenger<span style='mso-spacerun:yes'> </span></td>" +
                            "<td class=xl1519097></td>" +
                            "<td colspan=5 class=xl9119097 width=565 style='width:425pt'>" +
                            "<input id='witness1Passenger' type='text' style='border:none' /></td>" +
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

        var involvedInfo = "<table id='infoInvolved1' class='involvedSection' border=0 cellpadding=0 cellspacing=0 width=802 style='border-collapse:" +
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
                            "<input id='involved1name' type='text' style='border:none' /></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097>Phone<span style='mso-spacerun:yes'> </span></td>" +
                            "<td class=xl6819097></td>" +
                            "<td class=xl8219097>" +
                            "<input id='involved1Phone' type='text' style='border:none' /></td>" +
                            "<td class=xl6819097></td>" +
                            "<td class=xl8319097>Role in Incident</td>" +
                            "<td class=xl6819097></td>" +
                            "<td class=xl8219097>" +
                            "<input id='involved1Role' type='text' style='border:none' /></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=20 style='height:15.0pt'>" +
                            "<td height=20 class=xl1519097 style='height:15.0pt'></td>" +
                            "<td class=xl1519097>Describe Damage/Injury</td>" +
                            "<td class=xl1519097></td>" +
                            "<td colspan=5 class=xl9119097 width=565 style='width:425pt'>" +
                            "<input id='involved1damage' type='text' style='border:none' /></td>" +
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
                            "<input id='PCAInvolved1name' type=text style=border:none /></td>" +
                            "<td class=xl1519097></td>" +
                            "</tr>" +
                            "<tr height=19 style='mso-height-source:userset;height:14.45pt'>" +
                            "<td height=19 class=xl1519097 style='height:14.45pt'></td>" +
                            "<td class=xl1519097>DATE OF HIRE</td>" +
                            "<td class=xl1519097></td>" +
                            "<td class=xl7919097>" +
                            "<input id='PCAInvolved1HireDate' type=text style=border:none /></td>" +
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
                            "<td colspan=5 class=xl8419097 width=565 style='width:425pt'>*If no, Manager" +
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

