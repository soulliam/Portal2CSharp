<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="Cities.aspx.cs" Inherits="Cities" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

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

    <script type="text/javascript">
        // ============= Initialize Page ==================== Begin
        $(document).ready(function () {
            // load main city grid
            loadGrid();

            // load state combobox
            var stateSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'StateName' },
                    { name: 'StateId' }
                ],
                url: $("#apiDomain").val() + "States",
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                }
            };
            var stateDataAdapter = new $.jqx.dataAdapter(stateSource);
            $("#stateCombo").jqxComboBox(
            {
                width: 180,
                height: 25,
                source: stateDataAdapter,
                selectedIndex: 0,
                displayMember: "StateName",
                valueMember: "StateId"
            });
            $("#stateCombo").on('select', function (event) {
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
            
            // saving new or changed city
            $("#Save").click(function () {
                // If Airport is nothing then we are adding a new Airport and we need a post
                if ($("#CityId").val() == "") {
                    var newCityName = $("#CityName").val();
                    var newStateID = $("#stateCombo").jqxComboBox('getSelectedItem').value;
                    
                    $.ajax({
                        headers: {
                            "Accept": "application/json",
                            "Content-Type": "application/json",
                            "AccessToken": $("#userGuid").val(),
                            "ApplicationKey": $("#AK").val()
                        },
                        type: "POST",
                        url: $("#apiDomain").val() + "Cities",
                        data: JSON.stringify({
                            "StateId": newStateID,
                            "CityName": newCityName
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
                    
                } else {
                    if (editrow >= 0) {
                        //saving edits to city
                        var newCityId = $("#CityId").val();
                        var newCityName = $("#CityName").val();
                        var newStateID = $("#stateCombo").jqxComboBox('getSelectedItem').value;

                        var putUrl = $("#apiDomain").val() + "Cities/" + newCityId
                        
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
                                "CityId": newCityId,
                                "StateId": newStateID,
                                "CityName": newCityName
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

            //clears city form for new city
            $("#Cancel").click(function () {
                $("#popupWindow").jqxWindow('hide');
                $("#CityId").val("");
                $("#CityName").val("");
                $("#stateCombo").jqxComboBox('selectItem', 1);
            });


        });
        // ============= Initialize Page ================== End

        //Loads city grid
        function loadGrid() {

            var url = $("#apiDomain").val() + "cities";

            var source =
            {
                datafields: [
                    { name: 'CityId' },
                    { name: 'CityName' },
                    { name: 'StateId', map: 'State>StateId' },
                    { name: 'StateName', map: 'State>StateName' }
                ],
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                id: 'CityID',
                type: 'Get',
                datatype: "json",
                url: url,
                pagesize: 12,
                root: "data"
            };

            // creage jqxgrid
            $("#jqxgrid").jqxGrid(
            {
                width: '100%',
                height: 500,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                pageable: true,
                pagermode: 'simple',
                filterable: true,
                columns: [
                      {
                          //creates edit button for each row in city grid
                          text: '', pinned: true, datafield: 'Edit', width: 50, columntype: 'button', cellsrenderer: function () {
                              return "Edit";
                          }, buttonclick: function (row) {
                              // open the popup window when the user clicks a button.
                              editrow = row;
                              var offset = $("#jqxgrid").offset();
                              $("#popupWindow").jqxWindow({ position: { x: parseInt(offset.left) + 400, y: parseInt(offset.top) + 60 } });
                              $("#popupWindow").css("visibility", "visible");
                              $('#popupWindow').jqxWindow({ width: '325', height: '200' });
                              $('#popupWindow').jqxWindow({ showCloseButton: false });

                              // get the clicked row's data and initialize the input fields.
                              var dataRecord = $("#jqxgrid").jqxGrid('getrowdata', editrow);
                              $("#CityId").val(dataRecord.CityId);
                              $("#CityName").val(dataRecord.CityName);

                              // show the popup window.
                              $("#popupWindow").jqxWindow('open');
                              $("#stateCombo").jqxComboBox('selectItem', dataRecord.StateId);

                          }
                      },
                      //loads rest of columns for city
                      { text: 'City Id', datafield: 'CityId' },
                      { text: 'City Name', datafield: 'CityName' },
                      { text: 'State', datafield: 'StateName' },
                      { text: 'State Id', datafield: 'StateId', hidden: true }
                ]
            });

        }

        //clears city form for new city
        function newCity() {
            var offset = $("#jqxgrid").offset();
            $("#popupWindow").jqxWindow({ position: { x: parseInt(offset.left) + 400, y: parseInt(offset.top) + 60 } });
            $("#popupWindow").css("visibility", "visible");
            $("#popupWindow").jqxWindow('open');
        }

    </script>
    

    <style>

    </style>

    <div id="Cities">      
        <div class="FPR_SearchBox" style="display:block;">
            <div class="FPR_SearchLeft">
            

            </div>
            <div class="FPR_SearchRight">
                <a href="javascript:" onclick="newCity();" id="btnNew">New City</a>     
            </div>
        </div>
        <div style="visibility:hidden">
            <input id="LocationId" type="text" value="0"  />
        </div>
    </div>      
    
    <div id="jqxgrid">
    </div>

    <%-- html for popup edit box --%>
    <div id="popupWindow" style="visibility:hidden">
            <div>Edit</div>
            <div style="overflow: hidden;">
                <table>
                    <tr>
                        <td>CityId:</td>
                        <td><input id="CityId" disabled /></td>
                    </tr>
                    <tr>
                        <td>City Name:</td>
                        <td><input id="CityName"  /></td>
                    </tr>
                    <tr>
                        <td>State:</td>
                        <td><div id="stateCombo"></div></td>
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

