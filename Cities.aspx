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


        var thisNewCity = false; //determines whether a new City is being made so the feature grid doesn't get set 


        // ============= Initialize Page ==================== Begin
        $(document).ready(function () {
            // load main city grid
            loadGrid();

            //#region SetupButtons
            $("#btnNew").jqxLinkButton({ width: '100%', height: '26' });
            $("#Save").jqxButton();
            $("#Cancel").jqxButton();
            //#endregion

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
                width: '100%',
                height: 24,
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
                // If city is nothing then we are adding a new Airport and we need a post
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
                root: "data"
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
                columns: [
                      {
                          //creates edit button for each row in city grid
                          text: '', pinned: true, datafield: 'Edit', width: 50, columntype: 'button', cellsrenderer: function () {
                              return "Edit";
                          }, buttonclick: function (row) {
                              // open the popup window when the user clicks a button.
                              editrow = row;
                              var offset = $("#jqxgrid").offset();
                              $("#popupWindow").jqxWindow({ position: { x: '25%', y: '30%' } });
                              $('#popupWindow').jqxWindow({ resizable: false });
                              $('#popupWindow').jqxWindow({ draggable: true });
                              $('#popupWindow').jqxWindow({ isModal: true });
                              $("#popupWindow").css("visibility", "visible");
                              $('#popupWindow').jqxWindow({ height: '235px', width: '50%' });
                              $('#popupWindow').jqxWindow({ minHeight: '235px', minWidth: '50%' });
                              $('#popupWindow').jqxWindow({ maxHeight: '500px', maxWidth: '50%' });
                              $('#popupWindow').jqxWindow({ showCloseButton: true });
                              $('#popupWindow').jqxWindow({ animationType: 'combined' });
                              $('#popupWindow').jqxWindow({ showAnimationDuration: 300 });
                              $('#popupWindow').jqxWindow({ closeAnimationDuration: 500 });
                              $("#popupWindow").jqxWindow('open');

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
            //sets the varialbe to true so form doesn't try to load feature grid
            thisnewCity = true;
            $("#popupWindow").jqxWindow({ position: { x: '25%', y: '30%' } });
            $('#popupWindow').jqxWindow({ resizable: false });
            $('#popupWindow').jqxWindow({ draggable: true });
            $('#popupWindow').jqxWindow({ isModal: true });
            $("#popupWindow").css("visibility", "visible");
            $('#popupWindow').jqxWindow({ height: '235px', width: '50%' });
            $('#popupWindow').jqxWindow({ minHeight: '235px', minWidth: '50%' });
            $('#popupWindow').jqxWindow({ maxHeight: '500px', maxWidth: '50%' });
            $('#popupWindow').jqxWindow({ showCloseButton: true });
            $('#popupWindow').jqxWindow({ animationType: 'combined' });
            $('#popupWindow').jqxWindow({ showAnimationDuration: 300 });
            $('#popupWindow').jqxWindow({ closeAnimationDuration: 500 });
            $("#popupWindow").jqxWindow('open');
        }

    </script>    
    
    <div id="Cities" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-3 col-sm-offset-9">
                            <div class="row search-size">
                                <div class="col-sm-8 col-sm-offset-4">
                                    <div class="row search-size">
                                        <div class="col-sm-12">
                                            <a href="javascript:newCity();" id="btnNew">New City</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div><!-- /.container-fluid -->
    
    <div style="display:none;">
        <input id="LocationId" type="text" value="0"  />
    </div>

    <div class="container-fluid container-970">
        <div class="row ">
            <div class="col-sm-12">
                <div id="jqxgrid"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->


    <%-- html for popup Edit box --%>
    <div id="popupWindow" style="display:none">
        <div>City Details</div>
        <div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="CityId" class="col-sm-3 col-md-4 control-label">CityId:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="CityId" disabled />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="CityName" class="col-sm-3 col-md-4 control-label">City Name:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="CityName" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="stateCombo" class="col-sm-3 col-md-4 control-label">State:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div id="stateCombo"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="top-divider">
                            <div class="col-sm-2 col-md-3">
                            </div>
                            <div class="col-sm-4 col-md-3">
                                <input type="button" id="Save" value="Save" />
                            </div>
                            <div class="col-sm-4 col-md-3">
                                <input type="button" id="Cancel" value="Cancel" />
                            </div>
                            <div class="col-sm-2 col-md-3">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- html for popup edit box END --%>

</asp:Content>

