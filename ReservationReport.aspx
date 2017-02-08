<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="ReservationReport.aspx.cs" Inherits="ReservationReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script type="text/javascript" src="scripts/Member/UpdateMember.js"></script>
    <script type="text/javascript" src="scripts/Member/MemberReservation.js"></script>

    <link rel="stylesheet" href="/jqwidgets/styles/jqx.base.css" type="text/css" />

    <script type="text/javascript" src="/jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="/jqwidgets/jqxdraw.js"></script>
    <script type="text/javascript" src="/jqwidgets/jqxchart.core.js"></script>
    <script type="text/javascript" src="/jqwidgets/jqxdata.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            // prepare chart data as an array   
            //var url = $("#localApiDomain").val() + "Members/SearchByCompanyLocation/";
            var url = "http://localhost:52839/api/ReservationReports/GetReservationReport/" + 18;

            var source =
            {
                datatype: "json",
                datafields: [
                    { name: 'StartDate' },
                    { name: 'CountNumber' },
                    { name: 'startsCount' },
                    { name: 'endsCount' }
                ],
                url: url
            };

            var date = new Date('1/1/2017');
            var firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
            var lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);

            var dataAdapter = new $.jqx.dataAdapter(source, { async: false, autoBind: true, loadError: function (xhr, status, error) { alert('Error loading "' + source.url + '" : ' + error); } });
            // prepare jqxChart settings
            var settings = {
                title: "What",
                description: "Nah",
                showLegend: true,
                enableAnimations: true,
                padding: { left: 5, top: 5, right: 5, bottom: 5 },
                titlePadding: { left: 90, top: 0, right: 0, bottom: 10 },
                source: dataAdapter,
                xAxis:
                    {
                        dataField: 'StartDate',
                        type: 'date',
                        baseUnit: 'day',
                        valuesOnTicks: true,
                        minValue: firstDay,
                        maxValue: lastDay,
                        gridLines: { 
                            visible: true,
                            step: 1,
                            color: '#888888'
                        },
                        tickMarks: {
                            visible: true,
                            interval: 1,
                            color: '#BCBCBC'
                        },
                        labels: {
                            angle: -45,
                            rotationPoint: 'topright',
                            offset: { x: 0, y: -25 }
                        }

                    },
                colorScheme: 'scheme01',
                columnSeriesOverlap: true,
                seriesGroups:
                    [
                        {
                            type: 'column',
                            valueAxis:
                            {
                                visible: true,
                                unitInterval: 1,
                                title: { text: 'Number of Starts/Ends' }
                            },
                            series: [
                                    { dataField: 'startsCount', displayText: 'Start Count' },
                                    { dataField: 'endsCount', displayText: 'End Count' }
                                ]
                        }
                    ]
            };
            // setup the chart
            $('#chartContainer').jqxChart(settings);
        });
    </script>

	<div id='chartContainer' style="width:100%; height:600px;">
	</div>




</asp:Content>

