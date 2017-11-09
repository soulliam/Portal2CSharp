<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="Dashboard" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dashboard</title>
    <meta charset="utf-8" />

    

    <meta name="viewport" content="width=device-width, initial-scale=1" />
    
    <script type="text/javascript" src="scripts/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="scripts/bootstrap.min.js"></script>
    <script type="text/javascript" src="scripts/common.js"></script>

    
    <link rel="stylesheet" href="scripts/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="style.css" />

    <script src="scripts/es6-promise.auto.min.js"></script>
    <script src="scripts/sweetalert2.min.js"></script>
    <link rel="stylesheet" href="scripts/sweetalert2.min.css" />


    <link rel="stylesheet" href="/jqwidgets/styles/jqx.base.css" type="text/css" />


    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxpanel.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxtabs.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdragdrop.js"></script>


    <script>
        var nextWeather = 0;
        var nextAlertArray = [1, 18, 2, 3, 4, 9, 6, 7, 16, 20, 17, 15, 13, 12, 10, 11];
        var nextAlertPosistion = 0;
        var nextDelay = 0;
        var thisUser = "";
        var hideTopBar = false;
        

        $(document).ready(function () {

            $(document).click(function (e) {
                if (hideTopBar == false && e.target.className != "menuButton" && e.target.className != "topbar") {
                    $("#topbar").slideUp('slow');
                    hideTopBar = true;
                } else {

                }
            });

            $(document).on("mouseleave", function (e) {
                if (e.offsetY - $(window).scrollTop() < 0) {
                    $("#topbar").slideDown('slow');
                    $('#topbar').css('z-index', "9999");
                    $('.menuButton').css('z-index', "9999");
                    $(".jqx-window").css("z-index", "-1");
                    hideTopBar = false;
                }
            });


            thisUser = $("#thisUser").val();
            
            thisUser = thisUser.replace("PCA\\", "");

            var offset = $("#mainDiv").offset();

            var WeatherInterval = setInterval(function () { GetNextWeather(); }, 7000);

            var AlertInterval = setInterval(function () { GetLocationAlerts(); }, 7000);

            var DelayInterval = setInterval(function () { GetNextDelay(); }, 7000);

            $("#pause").click(function () {

                if ($("#pause").val() == "Pause") {
                    $("#pause").val("Start");
                    clearInterval(WeatherInterval);
                    clearInterval(AlertInterval);
                    clearInterval(DelayInterval);
                }else{
                    $("#pause").val("Pause");
                    WeatherInterval = setInterval(function () { GetNextWeather(); }, 7000);
                    AlertInterval = setInterval(function () { GetLocationAlerts(); }, 7000);
                    DelayInterval = setInterval(function () { GetNextDelay(); }, 7000);
                }
                
            });

            $("#back").click(function () {
                moveBack();
            });

            $("#forward").click(function () {
                moveForward();
            });

            $("#saveWindowSettings").click(function () {
                saveWindows("#carCount", 1);
                saveWindows("#locationAlert", 2);
                saveWindows("#twitter", 3);
                saveWindows("#weather", 4);
                saveWindows("#delay", 5);
            });

            $("#drag").click(function () {
                if ($("#drag").val() == "Hide Drag") {
                    $("#drag").val("Drag");
                    $('.jqx-window-header').css('display', 'none');

                } else {
                    $("#drag").val("Hide Drag");
                    $('.jqx-window-header').css('display', 'block');
                }
            });
            $("#jqxRibbon ul.jqx-widget-header").toggleClass('hiddenClass')
            placeWindows();

        });

        function placeWindows() {
            var placed = false;

            var url = $("#localApiDomain").val() + "DashboardSettings/GetDashboardSettings/" + thisUser;
            //var url = "http://localhost:52839/api/DashboardSettings/GetDashboardSettings/" + thisUser;

            $.ajax({
                type: 'GET',
                url: url,
                headers: {
                },
                success: function (thisData) {
                    

                    for (var i = 0; i < thisData.length; i++) {
                        if (thisData[i].DashboardItem == "CarCount") {
                            $('#carCount').jqxWindow({
                                position: { x: thisData[i].OffsetX, y: thisData[i].OffsetY },
                                draggable: true,
                                resizable: true,
                                showCollapseButton: true, maxHeight: 900, maxWidth: 700, minHeight: 200, minWidth: 200, height: thisData[i].ItemHeight, width: thisData[i].ItemWidth,
                                initContent: function () {
                                }
                            });
                            placed = true;
                        }
                        if (thisData[i].DashboardItem == "twitter") {
                            $('#twitter').jqxWindow({
                                position: { x: thisData[i].OffsetX, y: thisData[i].OffsetY },
                                draggable: true,
                                resizable: true,
                                showCollapseButton: true, maxHeight: 900, maxWidth: 700, minHeight: 200, minWidth: 200, height: thisData[i].ItemHeight, width: thisData[i].ItemWidth,
                                initContent: function () {
                                }
                            });
                            placed = true;
                        }
                        if (thisData[i].DashboardItem == "weather") {
                            $('#weather').jqxWindow({
                                position: { x: thisData[i].OffsetX, y: thisData[i].OffsetY },
                                draggable: true,
                                resizable: true,
                                showCollapseButton: true, maxHeight: 900, maxWidth: 700, minHeight: 200, minWidth: 200, height: thisData[i].ItemHeight, width: thisData[i].ItemWidth,
                                initContent: function () {
                                }
                            });
                            placed = true;
                        }
                        if (thisData[i].DashboardItem == "locationAlert") {
                            $('#locationAlert').jqxWindow({
                                position: { x: thisData[i].OffsetX, y: thisData[i].OffsetY },
                                draggable: true,
                                resizable: true,
                                showCollapseButton: true, maxHeight: 900, maxWidth: 700, minHeight: 200, minWidth: 200, height: thisData[i].ItemHeight, width: thisData[i].ItemWidth,
                                initContent: function () {
                                }
                            });
                            placed = true;
                        }
                        if (thisData[i].DashboardItem == "delay") {
                            $('#delay').jqxWindow({
                                position: { x: thisData[i].OffsetX, y: thisData[i].OffsetY },
                                draggable: true,
                                resizable: true,
                                showCollapseButton: true, maxHeight: 900, maxWidth: 700, minHeight: 200, minWidth: 200, height: thisData[i].ItemHeight, width: thisData[i].ItemWidth,
                                initContent: function () {
                                }
                            });
                            placed = true;
                        }
                    }

                    if (placed == false) {
                        defaultWindowPlace();
                    }
                },
                error: function (request, status, error) {
                    swal(error + " - " + request.responseJSON);
                }
            });
        }

        function defaultWindowPlace() {
            var offset = $("#mainDiv").offset();

            $('#carCount').jqxWindow({
                position: { x: offset.left + 50, y: offset.top + 50 },
                draggable: true,
                resizable: true,
                showCollapseButton: true, maxHeight: 900, maxWidth: 700, minHeight: 200, minWidth: 200, height: 650, width: 500,
                initContent: function () {
                }
            });

            $('#twitter').jqxWindow({
                position: { x: offset.left + 450, y: offset.top + 50 },
                draggable: true,
                resizable: true,
                showCollapseButton: true, maxHeight: 900, maxWidth: 700, minHeight: 200, minWidth: 200, height: 500, width: 350,
                initContent: function () {
                }
            });

            $('#weather').jqxWindow({
                position: { x: offset.left + 750, y: offset.top + 50 },
                draggable: true,
                resizable: true,
                showCollapseButton: true, maxHeight: 900, maxWidth: 700, minHeight: 200, minWidth: 200, height: 200, width: 550,
                initContent: function () {
                }
            });

            $('#locationAlert').jqxWindow({
                position: { x: offset.left + 950, y: offset.top + 50 },
                draggable: true,
                resizable: true,
                showCollapseButton: true, maxHeight: 900, maxWidth: 700, minHeight: 200, minWidth: 200, height: 200, width: 550,
                initContent: function () {
                }
            });

            $('#delay').jqxWindow({
                position: { x: offset.left + 1150, y: offset.top + 50 },
                draggable: true,
                resizable: true,
                showCollapseButton: true, maxHeight: 900, maxWidth: 700, minHeight: 200, minWidth: 200, height: 275, width: 550,
                initContent: function () {
                }
            });
        }

        function saveWindows (window, id) {
            //gets settings
            var DashboardItemId = id;
            var offset = $(window).offset();
            var OffsetX = offset.left;
            var OffsetY = offset.top;
            var ItemHeight = $(window).jqxWindow('height');
            var ItemWidth = $(window).jqxWindow('width');
            var UserName = thisUser;

            var url = $("#localApiDomain").val() + "DashboardSettings/SetDashboardSettings/";
            //var url = "http://localhost:52839/api/DashboardSettings/SetDashboardSettings/";

            //save settings
            $.ajax({
                type: "POST",
                url: url,
                data: {
                    "DashboardItemId": DashboardItemId,
                    "OffsetX": OffsetX,
                    "OffsetY": OffsetY,
                    "ItemHeight": ItemHeight,
                    "ItemWidth": ItemWidth,
                    "UserName": UserName
                },
                dataType: "json",
                success: function (response) {
                   
                },
                error: function (request, status, error) {
                    alert("Error saving window status!")
                }
            })

        }

        function GetNextWeather(way) {
            var ul = document.getElementById("WeatherList");
            var items = ul.getElementsByTagName("li");

            $("#thisWeather").html(items[nextWeather].innerHTML);

            if (nextWeather <= 14) {
                nextWeather = nextWeather + 1;
            } else {
                nextWeather = 0;
            }
        }

        function GetNextDelay() {
            var ul = document.getElementById("delayList");
            var items = ul.getElementsByTagName("li");

            $("#thisDelay").html(items[nextDelay].innerHTML);

            if (nextDelay <= 14) {
                nextDelay = nextDelay + 1;
            } else {
                nextDelay = 0;
            }
        }

        function GetLocationAlerts() {
            var LocationName = "";
            var LocationAlert = "";
            
            if (nextAlertPosistion > nextAlertArray.length - 1) {
                nextAlertPosistion = 0
            }


            var url = $("#localApiDomain").val() + "Locations/GetLocationAlerts/" + nextAlertArray[nextAlertPosistion];
            //var url = "http://localhost:52839/api/Locations/GetLocationAlerts/" + nextAlertArray[nextAlertPosistion];

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                success: function (data) {
                    LocationName = data[0].ShortLocationName;
                    LocationAlert = data[0].Alert;

                    $("#thislocationAlertName").html(LocationName);

                    if (LocationAlert == "") {
                        $("#thislocationAlert").html("No Alert.");
                    } else {
                        $("#thislocationAlert").html(LocationAlert);
                    }
                },
                error: function (request, status, error) {
                    swal(error);
                }
            });

            nextAlertPosistion = nextAlertPosistion + 1;
        }

        function moveBack() {
            var ul = document.getElementById("delayList");
            var items = ul.getElementsByTagName("li");

            if (nextDelay == 0) {
                nextDelay = 15;
            } else {
                nextDelay = nextDelay - 1;
            }

            $("#thisDelay").html(items[nextDelay].innerHTML);

            var ul = document.getElementById("WeatherList");
            var items = ul.getElementsByTagName("li");

            if (nextWeather == 0) {
                nextWeather = 15;
            } else {
                nextWeather = nextWeather - 1;
            }

            $("#thisWeather").html(items[nextWeather].innerHTML);

            var LocationName = "";
            var LocationAlert = "";

            nextAlertPosistion = nextAlertPosistion - 1;

            if (nextAlertPosistion < 0) {
                nextAlertPosistion = nextAlertArray.length - 1;
            }


            var url = $("#localApiDomain").val() + "Locations/GetLocationAlerts/" + nextAlertArray[nextAlertPosistion];
            //var url = "http://localhost:52839/api/Locations/GetLocationAlerts/" + nextAlertArray[nextAlertPosistion];

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                success: function (data) {
                    LocationName = data[0].ShortLocationName;
                    LocationAlert = data[0].Alert;

                    $("#thislocationAlertName").html(LocationName);

                    if (LocationAlert == "") {
                        $("#thislocationAlert").html("No Alert.");
                    } else {
                        $("#thislocationAlert").html(LocationAlert);
                    }
                },
                error: function (request, status, error) {
                    swal(error);
                }
            });

        }

        function moveForward() {
            var ul = document.getElementById("delayList");
            var items = ul.getElementsByTagName("li");

            if (nextDelay > 14) {
                nextDelay = 0;
            } else {
                nextDelay = nextDelay + 1;
            }

            $("#thisDelay").html(items[nextDelay].innerHTML);

            var ul = document.getElementById("WeatherList");
            var items = ul.getElementsByTagName("li");

            if (nextWeather > 14) {
                nextWeather = 0;
            } else {
                nextWeather = nextWeather + 1;
            }

            $("#thisWeather").html(items[nextWeather].innerHTML);

            var LocationName = "";
            var LocationAlert = "";

            nextAlertPosistion = nextAlertPosistion + 1;

            if (nextAlertPosistion > nextAlertArray.length - 1) {
                nextAlertPosistion = 0;
            }


            var url = $("#localApiDomain").val() + "Locations/GetLocationAlerts/" + nextAlertArray[nextAlertPosistion];
            //var url = "http://localhost:52839/api/Locations/GetLocationAlerts/" + nextAlertArray[nextAlertPosistion];

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                success: function (data) {
                    LocationName = data[0].ShortLocationName;
                    LocationAlert = data[0].Alert;

                    $("#thislocationAlertName").html(LocationName);

                    if (LocationAlert == "") {
                        $("#thislocationAlert").html("No Alert.");
                    } else {
                        $("#thislocationAlert").html(LocationAlert);
                    }
                },
                error: function (request, status, error) {
                    swal(error);
                }
            });

        }
    </script>


</head>
<body>
    

    <form id="form1" runat="server">
    
    <div id="mainDiv">
        <div id="topbar" class="container-fluid topbar" style="background-color:white;">
            <div class="row">
                <div class="col-sm-1">
                    <input type="button" id="drag" value="Hide Drag" style="font-size:large;font-weight:bold;" class="menuButton" />
                </div>
                 <div class="col-sm-2">
                    <input type="button" id="saveWindowSettings" value="Save" style="font-size:large;font-weight:bold;" class="menuButton" />
                </div>
                <div class="col-sm-3">
                    <input type="button" id="back" value="Back" style="font-size:large;font-weight:bold;" class="menuButton" />
                </div>
                <div class="col-sm-3">
                    <input type="button" id="pause" value="Pause" style="font-size:large;font-weight:bold;" class="menuButton" />
                </div>
                <div class="col-sm-3">
                    <input type="button" id="forward" value="Forward" style="font-size:large;font-weight:bold;" class="menuButton" />
                </div>
            </div>
        </div>

        <div class="hidden">
            <asp:TextBox runat="server" ID="localApiDomain" style="visibility:hidden">http://portal.thefastpark.com:8181/api/</asp:TextBox>
            <asp:TextBox runat="server" ID="thisUser" style="visibility:hidden"></asp:TextBox>
        </div>
        <div id="widgetContainer">
            <div id="carCount" class="thisWindow">
                <div id="carCountHeader">
                    <span>
                        Car Count
                    </span>
                </div>
                <div style="overflow: hidden;" id="carCountContent">
                    <iframe id="thisFrame" src="http://pca-portal:8080/CarcountWebsite/" background: transparent;border:none;" scrolling="no" style="width:100%;height:615px"></iframe>
                </div>
            </div>
            <div id="twitter" class="thisWindow">
                <div id="twitterHeader">
                    <span>
                        Twitter
                    </span>
                </div>
                <div id="twitterContent">
                    <a class="twitter-timeline" href="https://twitter.com/thefastpark?ref_src=twsrc%5Etfw">Tweets by thefastpark</a> 
                    <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
                </div>
            </div>
            <div id="locationAlert" class="thisWindow" style="background-color:orange;">
                <div id="locationAlertHeader">
                    <span>
                        Location Alert
                    </span>
                </div>
                <div id="locationAlertContent" style="background-color:orange;">
                    <div id="thislocationAlertName" style="font-size:large;font-weight:bold;">Location</div>
                
                    <div id="thislocationAlert" style="margin-top:10px;font-weight:bold;">This is the alert text.  It could be long or short.  This is test text.  If you are seeing this then there was an issue retrieving the actual alert.</div>
                </div>
            </div>
        
            <div id="delay" class="thisWindow">
                <div id="delayHeader">
                    <span>
                        Location Delay Summary
                    </span>
                </div>
                <div id="delayContent">
                    <div id="thisDelay"></div>
                    <ul runat="server" id="delayList" style="display:none;">
                    </ul>
                </div>
            </div>
            <div id="weather" class="thisWindow">
                <div id="weatherHeader">
                    <span>
                        Weather
                    </span>
                </div>
                <div id="weatherContent">
                    <div id="thisWeather"></div>
                    <ul runat="server" id="WeatherList" style="display:none;">
                    </ul>
                </div>
            </div>
        </div>
    </div>
</form>
</body>
</html>
