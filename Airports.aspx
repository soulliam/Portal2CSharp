﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="Airports.aspx.cs" Inherits="Airports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <link rel="stylesheet" href="jqwidgets/styles/jqx.base.css" type="text/css" />
    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>

    <script type="text/javascript" src="jqwidgets/globalization/globalize.js"></script>

    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>

    
    <script type="text/javascript" src="jqwidgets/jqxgrid.js"></script>    
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
    <script type="text/javascript" src="jqwidgets/jqxmaskedinput.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>    
    <script type="text/javascript" src="jqwidgets/jqxwindow.js"></script>

    <style>
        .jqx-chart-tooltip-text
        {
            fill: #333333;
            color: #333333;
            font-size: 14px;
            font-family: Verdana;
        }
    </style>

    <script type="text/javascript">
        // ============= Initialize Page ==================== Begin
        $(document).ready(function () {
            //load main airport grid
            loadGrid();
            
            $("#Save").click(function () {
                // If Airport is nothing then we are adding a new Airport and we need a post
                if ($("#AirportId").val() == "") {
                    //get info from form to add new airport
                    var newAirportAbbreviation = $("#AirportAbbreviation").val();
                    var newAirportName = $("#AirportName").val();
                    var newLocationText = $("#LocationText").val();
                    var newCityCaption = $("#CityCaption").val();
                    var newCityText = $("#CityText").val();
                    var newBannerText = $("#BannerText").val();
                    var newImageUrl = $("#ImageUrl").val();
                    var newCityId = $("#cityCombo").jqxComboBox('getSelectedItem').value

                    $.ajax({
                        headers: {
                            "Accept": "application/json",
                            "Content-Type": "application/json",
                            "AccessToken": $("#userGuid").val(),
                            "ApplicationKey": $("#AK").val()
                        },
                        type: "POST",
                        url: $("#apiDomain").val() + "Airports",
                        data: JSON.stringify({
                            "AirportAbbreviation": newAirportAbbreviation,
                            "AirportName": newAirportName,
                            "LocationText": newLocationText,
                            "CityCaption": newCityCaption,
                            "CityText": newCityText,
                            "BannerText": newBannerText,
                            "ImageUrl": newImageUrl,
                            "CityId": newCityId
                        }),
                        dataType: "json",
                        success: function (response) {
                            alert("Saved!");
                            //update airport grid
                            loadGrid();
                        },
                        error: function (request, status, error) {
                            alert(request.responseText);
                        }
                    })

                    $("#popupWindow").jqxWindow('hide');

                } else {
                    if (editrow >= 0) {
                        //editing existing airport
                        var newAirportId = $("#AirportId").val();
                        var newAirportAbbreviation = $("#AirportAbbreviation").val();
                        var newAirportName = $("#AirportName").val();
                        var newLocationText = $("#LocationText").val();
                        var newCityCaption = $("#CityCaption").val();
                        var newCityText = $("#CityText").val();
                        var newImageUrl = $("#ImageUrl").val();
                        var newBannerText = $("#BannerText").val();
                        var newCityId = $("#cityCombo").jqxComboBox('getSelectedItem').value

                        var putUrl = $("#apiDomain").val() + "Airports/" + newAirportId

                        $.ajax({
                            headers: {
                                "Accept": "application/json",
                                "Content-Type": "application/json",
                                "AccessToken": $("#userGuid").val(),
                                "ApplicationKey": $("#AK").val()
                            },
                            type: "PUT",
                            url: putUrl,
                            data: JSON.stringify({
                                "AirportAbbreviation": newAirportAbbreviation,
                                "AirportName": newAirportName,
                                "LocationText": newLocationText,
                                "CityCaption": newCityCaption,
                                "CityText": newCityText,
                                "ImageUrl": newImageUrl,
                                "BannerText": newBannerText,
                                "CityId": newCityId
                            }),
                            dataType: "json",
                            success: function (response) {
                                alert("Saved!");
                                loadGrid();
                            },
                            error: function (request, status, error) {
                                alert(request.responseText);
                            }
                        })

                        $("#popupWindow").jqxWindow('hide');
                    }
                }
            });
            // clearing airport form so if new airport is clicked it will be empty
            $("#Cancel").click(function () {
                $("#popupWindow").jqxWindow('hide');
                $("#AirportAbbreviation").val('');
                $("#AirportName").val('');
                $("#LocationText").val('');
                $("#CityText").val('');
                $("#CityCaption").val('');
                $("#ImageUrl").val('');
                $("#AirportId").val('');
                $("#BannerText").val('');

            });

            //load cities combobox
            var citySource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'CityName' },
                    { name: 'CityId' }
                ],
                url: $("#apiDomain").val() + "Cities",
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                }
            };
            var cityDataAdapter = new $.jqx.dataAdapter(citySource);
            $("#cityCombo").jqxComboBox(
            {
                width: 180,
                height: 25,
                source: cityDataAdapter,
                selectedIndex: 0,
                displayMember: "CityName",
                valueMember: "CityId"
            });
            $("#cityCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {
                        var valueelement = $("<div></div>");
                        valueelement.text("Value: " + item.value);
                        var labelelement = $("<div></div>");
                        labelelement.text("Label: " + item.label);
                        $("#selectionlog").children().remove();
                        $("#selectionlog").append(labelelement);
                        $("#selectionlog").append(valueelement);
                    }
                }
            });


        });
        // ============= Initialize Page ================== End

        //loads main airport grid
        function loadGrid() {

            var url = $("#apiDomain").val() + "Airports";

            var source =
            {
                datafields: [
                    { name: 'AirportId' },
                    { name: 'CityName', map: 'City>CityName' },
                    { name: 'CityId', map: 'City>CityId' },
                    { name: 'AirportAbbreviation' },
                    { name: 'AirportName' },
                    { name: 'LocationText' },
                    { name: 'CityCaption' },
                    { name: 'CityText' },
                    { name: 'BannerText' },
                    { name: 'ImageUrl' }
                ],

                id: 'AirportId',
                type: 'Get',
                datatype: "json",
                url: url,
                root: "data",
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                }
            };

            // creage jqxgrid
            $("#jqxgrid").jqxGrid(
            {
                pageable: true,
                pagermode: 'advanced',
                pagesize: 50,
                pagesizeoptions: ['10', '20', '50', '100'],
                width: '100%',
                height: 500,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                enabletooltips: true,
                columns: [
                      {
                          //creates edit button in grid for each row
                          text: '', pinned: true, datafield: 'Edit', width: 50, columntype: 'button', cellsrenderer: function () {
                              return "Edit";
                          }, buttonclick: function (row) {
                              // open the popup window when the user clicks a button.
                              editrow = row;
                              

                              // get the clicked row's data and initialize the input fields.
                              var dataRecord = $("#jqxgrid").jqxGrid('getrowdata', editrow);
                              $("#CityId").val(dataRecord.CityId);
                              $("#AirportAbbreviation").val(dataRecord.AirportAbbreviation);
                              $("#AirportName").val(dataRecord.AirportName);
                              $("#LocationText").val(dataRecord.LocationText);
                              $("#CityText").val(dataRecord.CityText);
                              $("#ImageUrl").val(dataRecord.ImageUrl);
                              $("#AirportId").val(dataRecord.AirportId);
                              $("#BannerText").val(dataRecord.BannerText);
                              $("#CityCaption").val(dataRecord.CityCaption);
                              // show the popup window.
                              $("#popupWindow").css('display', 'block');
                              $("#popupWindow").css('visibility', 'hidden');

                              var offset = $("#jqxgrid").offset();
                              $("#popupWindow").jqxWindow({ position: { x: parseInt(offset.left) + 400, y: parseInt(offset.top) + 60 } });
                              $("#popupWindow").css("visibility", "visible");
                              $('#popupWindow').jqxWindow({ width: '600', height: '400' });
                              $('#popupWindow').jqxWindow({ showCloseButton: false });
                              $("#popupWindow").jqxWindow('open');
                              $("#cityCombo").jqxComboBox('selectItem', dataRecord.CityId);
                          }, width: '4%'
                      },
                      //loading the rest of the columns
                      { text: 'City', datafield: 'CityName', hidden: true },
                      { text: 'Abbr', datafield: 'AirportAbbreviation', width: '3%' },
                      { text: 'Airport Name', datafield: 'AirportName', width: '7%' },
                      { text: 'Location Text', datafield: 'LocationText', width: '11%' },
                      { text: 'City Text', datafield: 'CityText', width: '15%' },
                      { text: 'City Caption', datafield: 'CityCaption', width: '15%' },
                      { text: 'Image URL', datafield: 'ImageUrl', width: '25%' },
                      { text: 'Banner Text', datafield: 'BannerText', width: '20%' },
                      { text: 'AirportId', datafield: 'AirportId', hidden: true },
                      { text: 'CityId', datafield: 'CityId', hidden: true }
                ]
            });

        }

        //opens the airport pop out form empty
        function newAirport() {
            $("#popupWindow").css('display', 'block');
            $("#popupWindow").css('visibility', 'hidden');

            var offset = $("#jqxgrid").offset();
            $("#popupWindow").jqxWindow({ position: { x: parseInt(offset.left) + 400, y: parseInt(offset.top) + 60 } });
            $("#popupWindow").css("visibility", "visible");
            $("#popupWindow").jqxWindow('open');
        }

    </script>
    

    <style>

    </style>
    <div id="Airports">      
        <div class="FPR_SearchBox" style="display:block;">
            <div class="FPR_SearchLeft">
            

            </div>
            <div class="FPR_SearchRight">
                <a href="javascript:" onclick="newAirport();" id="btnNew">New Airport</a>     
            </div>
        </div>
        <div style="visibility:hidden">
            <input id="LocationId" type="text" value="0"  />
        </div>
    </div>      
    
    <div id="jqxgrid">
    </div>

    <%-- html for popup edit box --%>
    <div id="popupWindow" style="display: none">
        <div>
            <table width="100%">
                <tr>
                    <td>AirportId:</td>
                    <td><input id="AirportId" disabled /></td>
                </tr>
                <tr>
                    <td>City:</td>
                    <td><div id="cityCombo"></div></td>
                </tr>
                <tr>
                    <td>Abbreviation:</td>
                    <td><input id="AirportAbbreviation" /></td>
                </tr>
                <tr>
                    <td>Airport Name:</td>
                    <td><input id="AirportName" /></td>
                </tr>
                <tr>
                    <td>Location Text:</td>
                    <td><input id="LocationText"  /></td>
                </tr>
                <tr>
                    <td>City Caption:</td>
                    <td><input id="CityCaption" /></td>
                </tr>
                    <tr>
                    <td>City Text:</td>
                    <td><textarea rows="4" cols="55" id="CityText"></textarea></td>
                </tr>
                </tr>
                    <tr>
                    <td>Banner Text:</td>
                    <td><textarea rows="4" cols="55" id="BannerText"></textarea></td>
                </tr>
                <tr>
                    <td>Image Url:</td>
                    <td><input id="ImageUrl" /></td>
                </tr>
                <tr>
                    <td></td>
                    <td style="padding-top: 10px;"><input style="margin-right: 5px;" type="button" id="Save" value="Save" /><input id="Cancel" type="button" value="Cancel" /></td>
                </tr>
            </table>
        </div>
    </div>
    <%-- html for popup edit box END --%>

</asp:Content>

