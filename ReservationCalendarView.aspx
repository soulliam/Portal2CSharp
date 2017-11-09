<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="ReservationCalendarView.aspx.cs" Inherits="ReservationCalendarReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <style>
        td {
            width: 14%;
            font-weight:bold;
        }

        ul {list-style-type: none;}
        body {font-family: Verdana, sans-serif;}

        /* Month header */
        .month {
            padding: 5px 25px;
        }

        /* Month list */
        .month ul {
            margin: 0;
            padding: 0;
        }

        .month label {
            color: white;
            font-size: 20px;
            text-transform: uppercase;
            letter-spacing: 3px;
        }

        .month div {
            color: white;
            font-size: 20px;
            text-transform: uppercase;
            letter-spacing: 3px;
        }

        .month ul li {
            color: white;
            font-size: 20px;
            text-transform: uppercase;
            letter-spacing: 3px;
        }

        /* Previous button inside month header */
        .month .prev {
            float: left;
            padding-top: 0px;
        }

        /* Next button */
        .month .next {
            float: right;
            padding-top: 0px;
        }

        /* Weekdays (Mon-Sun) */
        .weekdays {
            margin: 0;
            padding: 5px 0;
            background-color:#ddd;
        }

        .weekdays li {
            width: 100%;
            color: #666;
            text-align: center;
            font-weight: bold;
        }

        /* Days (1-31) */
        .days {
            padding: 7px 0;
            margin: 0;
        }

        .days li {
            list-style-type: none;
            display: inline-block;
            width: 14%;
            text-align: center;
            margin-bottom: 5px;
            font-size:12px;
            color:#777;
	    background: #eee;
        }

        /* Highlight the "current" day */
        .days li .active {
            padding: 3px;
            background: #1abc9c;
            color: white !important
        }
    </style>

    <script type="text/javascript" src="scripts/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="scripts/bootstrap.min.js"></script>
    <script type="text/javascript" src="scripts/common.js"></script>

    <link rel="stylesheet" href="jqwidgets/styles/jqx.base.css" type="text/css" />
    <script type="text/javascript" src="scripts/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdraw.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdata.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxloader.js"></script>

    <script type="text/javascript" src="scripts/jquery.jqplot.js"></script>
    <script type="text/javascript" src="scripts/jqplot.barRenderer.js"></script>
    <script type="text/javascript" src="scripts/jqplot.categoryAxisRenderer.js"></script>
    <script type="text/javascript" src="scripts/jqplot.pointLabels.js"></script>
    <script type="text/javascript" src="scripts/jqplot.cursor.js"></script>
    <script type="text/javascript" src="scripts/jqplot.highlighter.js"></script>
    <link rel="stylesheet" type="text/css" href="scripts/jquery.jqplot.css" />
    



    <script>
        var group = '<%= Session["groupList"] %>';
        var thisLocation = 0;

        var d = new Date();
        d = new Date(d.getFullYear(), d.getMonth(), 1);

        $(document).ready(function () {
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
            LoadLocationPopup(thisLocationString);
           

            $("#prev").on("click", function (event) {
                createCalendar(3);
            });

            $("#next").on("click", function (event) {
                createCalendar(2);
            });

            $('#jqxLoader').jqxLoader('open');

        });

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
                url: $("#localApiDomain").val() + "Locations/LocationByLocationIds/" + thisLocationString

            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#LocationCombo").jqxDropDownList(
            {
                width: 300,
                height: 30,
                itemHeight: 30,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });

            $("#LocationCombo").on('bindingComplete', function (event) {
                $("#LocationCombo").jqxDropDownList('insertAt', 'Pick a Location', 0);
                $("#LocationCombo").jqxDropDownList('selectIndex', 0);
            });

            $("#LocationCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {
                        
                        thisLocation = item.value;
                        //$("#popupLocation").jqxWindow('hide');
                        createCalendar(1);
                    }
                }
            });
        }

        function createCalendar(direction) {
            
            var list = document.getElementById("days");
            list.innerHTML = '';


            switch(direction) {
                case 1:
                    break;
                case 2:
                    d = new Date(d.getFullYear(), d.getMonth() + 1, 1);
                    break;
                case 3:
                    d = new Date(d.getFullYear(), d.getMonth() - 1, 1);
                    break;
                default:
                    break;
            }

            
            var month = new Array();
            month[0] = "January";
            month[1] = "February";
            month[2] = "March";
            month[3] = "April";
            month[4] = "May";
            month[5] = "June";
            month[6] = "July";
            month[7] = "August";
            month[8] = "September";
            month[9] = "October";
            month[10] = "November";
            month[11] = "December";
            var n = month[d.getMonth()];

            $("#month").html(n + " Reservation Count");

            var month = d.getMonth();
            var year = d.getFullYear();

            var FirstDay = new Date(year, month, 1);
            var LastDay = new Date(year, month + 1, 0);

            var firstDayOfWeek = 0;

            while (firstDayOfWeek < FirstDay.getDay()){
                var node = document.createElement("li"); 
                var textnode = document.createTextNode(''); 
                node.appendChild(textnode); 
                document.getElementById("days").appendChild(node);
                firstDayOfWeek = firstDayOfWeek + 1;
            }
	    
	    
            while (FirstDay <= LastDay) {
                var thisEntry = 0;
                var thisExit = 0;
                var thisAvailable = 0;
                var thisReserved = 0;
                var thisDay = FirstDay.getDate();

                //$("#days").append("<li><div style='border: 1px solid black;margin-left:3px;'><label style='font-size:large;font-weight:bold;'>" + thisDay + "</label><table><tr><td><div>Entries: <label id='entries" + thisDay + "'></label></div><div>Exits: <label id='exits" + thisDay + "'></label></div><div>Available: <label id='available" + thisDay + "'></label></div><div>Reserved: <label id='reserved" + thisDay + "'></label></div></td><td><div>TEST: <label id=''>1000</label></div><div>TEST: <label id=''>1000</label></div><div>TEST: <label id=''>1000</label></div><div>TEST: <label id=''>1000</label></div></td></tr></table></div></li>");
                $("#days").append("<li><div style='border: 1px solid black;margin-left:3px;'><label style='font-size:large;font-weight:bold;'>" + thisDay + "</label><div>Entries: <label id='entries" + thisDay + "'></label></div><div>Exits: <label id='exits" + thisDay + "'></label></div><div>Available: <label id='available" + thisDay + "'></label></div><div>Reserved: <label id='reserved" + thisDay + "'></label></div></div></li>");

                var thisEntryLabel = "entries" + thisDay;
                var thisExitLabel = "exits" + thisDay;
                var thisAvailableLabel = "available" + thisDay;
                var thisReservedLabel = "reserved" + thisDay;
                var thisDate = DateFormat(FirstDay);
                thisDate = thisDate.replace(/\//g, '-')

                //var url = "http://localhost:52839/api/ReservationReports/GetReservationReport/" + thisLocation + '_' + thisDate;
                var url = $("#localApiDomain").val() + "ReservationReports/GetReservationReport/" + thisLocation + '_' + thisDate;


                getDay(url, thisEntry, thisExit, thisAvailable, thisReserved, thisEntryLabel, thisExitLabel, thisAvailableLabel, thisReservedLabel).done(function (data) {
                    console.log(); //filled!
                }).fail(function(error){
                    alert("error " + error);
                });

                if (FirstDay.getDate() != LastDay.getDate()){
                    FirstDay.setDate(FirstDay.getDate() + 1);
                } else {
                    FirstDay.setDate('1/1/2200');
                }

            } 
            
        }

        function getDay(url, thisEntry, thisExit, thisAvailable, thisReserved, thisEntryLabel, thisExitLabel, thisAvailableLabel, thisReservedLabel) {
            return $.ajax({
                async: true,
                type: "GET",
                url: url,
                dataType: "json",
                success: function (data) {
                    thisEntry = data.startsCount;
                    thisExit = data.endsCount;
                    thisAvailable = data.available;
                    thisReserved = data.reserved;
                    $("#" + thisEntryLabel).html(thisEntry);
                    $("#" + thisExitLabel).html(thisExit);
                    $("#" + thisAvailableLabel).html(thisAvailable);
                    $("#" + thisReservedLabel).html(thisReserved);
                    $('#jqxLoader').jqxLoader('close');
                },
                error: function (request, status, error) {
                    alert(error);
                }
            });
        }

        Security();
    </script>

<div>
    <div>
        <table style="background-color: rgba(0, 0, 0, 0);">
            <tr>
                <td style="padding-left:20px;padding-top:5px;padding-bottom:5px;">
                    <label style="color: white;font-size: 20px;letter-spacing: 3px;" id="month">Month</label>
                </td>
                <td style="padding-right:20px;padding-top:5px;padding-bottom:5px;">
                    <div id="LocationCombo" style="float:right;margin-top:2px;"></div>
                </td>
            </tr>
            <tr>
                <td style="padding-left:20px;padding-top:5px;padding-bottom:5px;">
                    <div id="prev" class="prev" style="cursor:pointer;color:white;font-size:x-large;font-weight:bold;">&#10094;</div>
                </td>
                <td style="padding-right:20px;padding-top:5px;padding-bottom:5px;">
                    <div id="next" class="next" style="float:right;cursor:pointer;color:white;font-size:x-large;font-weight:bold;">&#10095;</div>
                </td>
            </tr>
        </table>
    </div>


    <div style="width:100%;margin-left:15px;">
        <table id="CalTable" style="width:98%;">
            <tr>
                <td style="text-align:center;">
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Su
                </td>
                <td style="text-align:center;">
                    &nbsp;&nbsp;&nbsp;&nbsp;Mo
                </td>
                <td style="text-align:center;">
                    Tu
                </td>
                <td style="text-align:center;">
                    We
                </td>
                <td style="text-align:center;">
                    Th&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </td>
                <td style="text-align:center;">
                    Fr&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </td>
                <td style="text-align:center;">
                    Sa&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </td>
            </tr>
        </table>
    </div>
    <div style="background: #eee;;margin-left:15px;width:98%;">
        <ul id="days" class="days" style="margin-left:15px;"> 
        </ul>
    </div>
</div>

<div id="jqxLoader"></div>

</asp:Content>


