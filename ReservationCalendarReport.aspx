<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="ReservationCalendarReport.aspx.cs" Inherits="ReservationCalendarReport" %>

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
            background: #eee;
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
    <script type="text/javascript" src="jqwidgets/jqxbargauge.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxchart.core.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdata.js"></script>

    <script type="text/javascript" src="scripts/jquery.jqplot.js"></script>
    <script type="text/javascript" src="scripts/jqplot.barRenderer.js"></script>
    <script type="text/javascript" src="scripts/jqplot.categoryAxisRenderer.js"></script>
    <script type="text/javascript" src="scripts/jqplot.pointLabels.js"></script>
    <script type="text/javascript" src="scripts/jqplot.cursor.js"></script>
    <script type="text/javascript" src="scripts/jqplot.highlighter.js"></script>
    <link rel="stylesheet" type="text/css" href="scripts/jquery.jqplot.css" />
    



    <script>
        var group = '<%= Session["groupList"] %>';

        var d = new Date();
        d = new Date(d.getFullYear(), d.getMonth(), 1);

        $(document).ready(function () { 
            createCalendar(1);

            $("#prev").on("click", function (event) {
                createCalendar(3);
            });

            $("#next").on("click", function (event) {
                createCalendar(2);
            });

            

        });

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

            $("#month").html(n);

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
                var thisOnLot = 0;
                var thisDay = FirstDay.getDate();

                $("#days").append("<li><div style='border: 1px solid black;margin-left:3px;'><label style='font-size:large;font-weight:bold;'>" + thisDay + "</label><div>Entries -<label id='entries" + thisDay + "'></label></div><div>Exits -<label id='exits" + thisDay + "'></label></div><div>On Lot -<label id='onlot" + thisDay + "'></label></div></div></li>");

                var thisEntryLabel = "entries" + thisDay;
                var thisExitLabel = "exits" + thisDay;
                var thisOnLotLabel = "onlot" + thisDay;
                var thisDate = DateFormat(FirstDay);
                thisDate = thisDate.replace(/\//g, '-')

                //var url = "http://localhost:52839/api/ReservationReports/GetReservationReport/" + '2_' + thisDate;
                var url = "http://maxdev:8181/api//ReservationReports/GetReservationReport/" + '2_' + thisDate;

                $.ajax({
                    async:false,
                    type: "GET",
                    url: url,
                    dataType: "json",
                    success: function (data) {
                        thisEntry = data.startsCount;
                        thisExit = data.endsCount;
                        thisOnLot = data.onLot;
                        $("#" + thisEntryLabel).html(thisEntry);
                        $("#" + thisExitLabel).html(thisExit);
                        $("#" + thisOnLotLabel).html(thisOnLot);
                    },
                    error: function (request, status, error) {
                        alert(error);
                    }
                });

                if (FirstDay.getDate() != LastDay.getDate()){
                    FirstDay.setDate(FirstDay.getDate() + 1);
                } else {
                    FirstDay.setDate('1/1/2200');
                }

            } 
        }

        Security();
    </script>


    <div class="month">
        <div><label class="month" id="month"></label></div>
        <div id="prev" class="prev" style="cursor:pointer;color:white;font-size:x-large;font-weight:bold;">&#10094;</div>
        <div id="next" class="next" style="float:right;cursor:pointer;color:white;font-size:x-large;font-weight:bold;">&#10095;</div>
    </div>

    <div style="width:100%">
        <table style="width:98%;text-align:center;">
            <tr>
                <td>
                    Su
                </td>
                <td>
                    Mo
                </td>
                <td>
                    Tu
                </td>
                <td>
                    We
                </td>
                <td>
                    Th
                </td>
                <td>
                    Fr
                </td>
                <td>
                    Sa
                </td>
            </tr>
        </table>
    </div>
        
    <ul id="days" class="days"> 

    </ul>

</asp:Content>


