<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="ForTestHTML2.aspx.cs" Inherits="ForTestHTML2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta name="viewport" content="width=device-width, initial-scale=1 maximum-scale=1 minimum-scale=1" />

    <meta name="viewport" content="width=device-width, initial-scale=1 maximum-scale=1 minimum-scale=1" />
    <link rel="stylesheet" href="jqwidgets/styles/jqx.base.css" type="text/css" />
    <link rel="stylesheet" href="jqwidgets/styles/jqx.metro.css" type="text/css" />
    <link rel="stylesheet" href="jqwidgets/styles/jqx.metrodark.css" type="text/css" />
    <link rel="stylesheet" href="jqwidgets/styles/jqx.web.css" type="text/css" />

    <script type="text/javascript" src="scripts/jquery-1.11.1.min.js"></script>

    <link href="scripts/bootstrap.min.css" rel="stylesheet" />
    <link href="scripts/bootstrap-theme.min.css" rel="stylesheet" />
    <script src="scripts/bootstrap.min.js"></script>

    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdata.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdraw.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxbargauge.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxchart.core.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxlayout.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxribbon.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdatatable.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxtabs.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxresponse.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxsplitter.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxpanel.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxprogressbar.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.selection.js"></script> 
    <script type="text/javascript" src="jqwidgets/jqxgrid.grouping.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.filter.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxexpander.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxsortable.js"></script>

    <link href="style.css" rel="stylesheet" />
    <div style="visibility:hidden;margin-top:10px;" id="mainSplitter">
        <div style="margin-top:40px;" class="splitter-panel" id="leftPanel">
            <header class="clearfix">
                <div class="container">
                    <div class="freeSpace"></div>
                    <div id="listContainer"> 
                        <label for="open">
                            <span class="hidden-desktop"></span>
                        </label>
                        <input type="checkbox" name="" id="open">   
                        <nav>
                            <a href="#" class="active" id="1"><span class="glyphicon glyphicon-blackboard"></span><p style='position:relative; top: -2px;'>KPI</p></a>
                            <a href="#" id="2"><span class="glyphicon glyphicon-dashboard"></span><p style='position:relative; top: -2px;'>Performance</p></a>
                            <a href="#" id="3"><span class="glyphicon glyphicon-usd"></span><p style='position:relative; top: -2px;'>Reports</p></a>
                            <a href="#" id="4"><span class="glyphicon glyphicon-list-alt"></span><p style='position:relative; top: -2px;'>News</p></a>
                        </nav>
                    </div>
                </div>
            </header>
        </div>

        <div style="margin-top:40px;" class="splitter-panel" id="rightPanel" >

            <div id="overview">
                <div class="data container-fluid">
                    <div id="overviewChart" style="width:100%;height:500px;"></div>
                    <div class="overviewBottomRight">
                        <div>
                            <p></p>
                        </div>
                        <div class="progressBarsContainer">
                            <p class="overviewBottomRightInnerText">Totals for the Week</p>
                            <ul>
                                <li>
                                    <ul class="list-inline">
                                        <li><div style="background-color:#C8C8C8"><p>Entering Lot</p></div></li>
                                        <li><div style='overflow: hidden;' id='jqxProgressBar2'></div></li>
                                    </ul>
                                </li>
                                <li>
                                    <ul class="list-inline">
                                        <li><div style="background-color:#667B82"><p>Leaving Log</p></div></li>
                                        <li><div style='overflow: hidden;' id='jqxProgressBar3'></div></li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>   
           
    </div>

    <script type="text/javascript" src="scripts/dashBoardTest.js"></script>

</asp:Content>

