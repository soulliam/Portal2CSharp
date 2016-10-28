<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="CompanyCheck.aspx.cs" Inherits="CompanyCheck" %>

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
    <script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>

    <script type="text/javascript">
        // ============= Initialize Page ==================== Begin
        var loading = true;

        $(document).ready(function () {
            loadLocationCombo();
            $("#LocationCombo").on('bindingComplete', function (event) {
                $("#LocationCombo").jqxComboBox('insertAt', 'Pick a Location', 0);
                $("#LocationCombo").on('change', function (event) {
                    loadGrid();
                });
            });
            $("#jqxgrid").bind('cellendedit', function (event) {
                if (event.args.value) {
                    $("#jqxgrid").jqxGrid('selectrow', event.args.rowindex);
                }
                else {
                    $("#jqxgrid").jqxGrid('unselectrow', event.args.rowindex);
                }
            });
            loading = false;

            
            $("#btnSubmit").on('click', function () {
                var ProcessList = "";
                var first = true;
                var getselectedrowindexes = $('#jqxgrid').jqxGrid('getselectedrowindexes');
                if (getselectedrowindexes.length > 0) {
                    for (var index = 0; index < getselectedrowindexes.length; index++)
                    {
                        var selectedRowData = $('#jqxgrid').jqxGrid('getrowdata', getselectedrowindexes[index]);
                        if (first == true)
                        {
                            ProcessList = ProcessList + selectedRowData.ManualEditID;
                            first = false;
                        }
                        else
                        {
                            ProcessList = ProcessList + "," + selectedRowData.ManualEditID;
                        }
                    }


                    var processingList = {
                        "ProcessList": ProcessList 
                    };
                    
                    var jsonText = JSON.stringify(processingList);

                    $.ajax({
                        url: $("#localApiDomain").val() + "ProcessPendingManualEditsController/SubmitManualEdits",
                        type: 'POST',
                        data: processingList,
                        success: function (response) {
                            alert("Saved!");
                            loadGrid();
                        },
                        error: function (jqXHR, textStatus, errorThrown, data) {
                            alert(textStatus); alert(errorThrown);
                        }
                    });
                }
            });

            $("#btnDelete").on('click', function () {
                var ProcessList = "";
                var first = true;
                var getselectedrowindexes = $('#jqxgrid').jqxGrid('getselectedrowindexes');
                if (getselectedrowindexes.length > 0) {
                    for (var index = 0; index < getselectedrowindexes.length; index++) {
                        var selectedRowData = $('#jqxgrid').jqxGrid('getrowdata', getselectedrowindexes[index]);
                        if (first == true) {
                            ProcessList = ProcessList + selectedRowData.ManualEditID;
                            first = false;
                        }
                        else {
                            ProcessList = ProcessList + "," + selectedRowData.ManualEditID;
                        }
                    }


                    var processingList = {
                        "ProcessList": ProcessList
                    };

                    var jsonText = JSON.stringify(processingList);

                    $.ajax({
                        url: $("#localApiDomain").val() + "ProcessPendingManualEditsController/DeleteManualEdits",
                        type: 'POST',
                        data: processingList,
                        success: function (response) {
                            alert("Deleted!");
                            loadGrid();
                        },
                        error: function (jqXHR, textStatus, errorThrown, data) {
                            alert(textStatus); alert(errorThrown);
                        }
                    });
                }
            });

            //Place holder grid
            var source = {};
            $("#jqxgrid").jqxGrid(
                {
                    width: '100%',
                    height: 500,
                    source: source,
                    selectionmode: 'checkbox',
                    rowsheight: 35,
                    sortable: true,
                    altrows: true,
                    filterable: true,
                    columns: [
                            { text: 'ArticleCheckId', datafield: 'ArticleCheckId', hidden: true },
                            { text: 'ArticleNumber', datafield: 'ArticleNumber' },
                            { text: 'LocationId', datafield: 'LocationId', hidden: true },
                            { text: 'Location', datafield: 'NameOfLocation' },
                            { text: 'CompanyId', datafield: 'CompanyId', hidden: true },
                            { text: 'Company', datafield: 'CompanyName' },
                            { text: 'EnteredByUserId', datafield: 'EnteredByUserId' },
                            { text: 'DateEntered', datafield: 'DateEntered' }
                    ]
                });


        });
        // ============= Initialize Page ================== End

        //loads main airport grid
        function loadGrid() {
            if (loading == false) {
                var thisLocationID = $('#LocationCombo').jqxComboBox('getSelectedItem').value;

                var url = $("#localApiDomain").val() + "CompanyChecks/CompanyCheckByLocationId/" + thisLocationID;
                var source =
                {

                    datafields: [
                        { name: 'ArticleCheckId' },
                        { name: 'ArticleNumber' },
                        { name: 'LocationId' },
                        { name: 'NameOfLocation' },
                        { name: 'CompanyId' },
                        { name: 'CompanyName' },
                        { name: 'EnteredByUserId' },
                        { name: 'DateEntered' }
                    ],

                    id: 'ManualEditId',
                    type: 'Get',
                    datatype: "json",
                    url: url,
                };

                // creage jqxgrid
                $("#jqxgrid").jqxGrid(
                {
                    width: '100%',
                    height: 500,
                    source: source,
                    selectionmode: 'checkbox',
                    rowsheight: 35,
                    sortable: true,
                    altrows: true,
                    filterable: true,
                    columns: [
                           { text: 'ArticleCheckId', datafield: 'ArticleCheckId', hidden: true },
                           { text: 'ArticleNumber', datafield: 'ArticleNumber' },
                           { text: 'LocationId', datafield: 'LocationId', hidden: true },
                           { text: 'Location', datafield: 'NameOfLocation' },
                           { text: 'CompanyId', datafield: 'CompanyId', hidden: true },
                           { text: 'Company', datafield: 'CompanyName' },
                           { text: 'EnteredByUserId', datafield: 'EnteredByUserId' },
                           { text: 'DateEntered', datafield: 'DateEntered' }
                    ]
                });
            }
        }


        function loadLocationCombo(loading) {
            //set up the location combobox
            var locationSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'DisplayName' },
                    { name: 'LocationId' }
                ],
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                url: $("#apiDomain").val() + "locations",

            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#LocationCombo").jqxComboBox(
            {
                theme: 'shinyblack',
                width: 270,
                height: 25,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "DisplayName",
                valueMember: "LocationId"
            });
            $("#LocationCombo").on('select', function (event) {
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
            
           
        }

    </script>
    
    <style>

    </style>

    <div id="CompanyCheck">      
        <div class="FPR_SearchBox" style="display:block;">
            <div class="FPR_SearchLeft" style="margin-left:10px;">
                <div id="LocationCombo"></div>
            </div>
            <div class="FPR_SearchRight">
                     
            </div>
        </div>
        
    </div> 
   
    
    <div id="jqxgrid"></div>
    <div id="actionButtons"><input id="btnSubmit" value="Submit" type="button" style="margin-top:15px;" /><input id="btnDelete" value="Delete" type="button" style="margin-left:75px; margin-top:15px;" /></div>
    
</asp:Content>

