<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="MemberResend.aspx.cs" Inherits="MemberResend" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <style>
        .FPR_SearchBox{
            width:100%;height:115px;
        }
    </style>


    <link rel="stylesheet" href="/jqwidgets/styles/jqx.base.css" type="text/css" />

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
    <script type="text/javascript" src="jqwidgets/jqxtabs.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxloader.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxradiobutton.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdatetimeinput.js"></script>


    <script type="text/javascript">
        var loading = true;

        // ============= Initialize Page ==================== Begin
        $(document).ready(function () {
            //create Beginning Date calendar
            $("#jqxBeginningDateCalendar").jqxDateTimeInput({ formatString: 'MM-dd-yyyy', width: '270px', height: '25px' });
            $("#jqxEndingDateCalendar").jqxDateTimeInput({ formatString: 'MM-dd-yyyy', width: '270px', height: '25px' });

            loadLocationCombo();
            $("#LocationCombo").on('bindingComplete', function (event) {
                $("#LocationCombo").jqxComboBox('insertAt', 'Pick a Location', 0);
                $("#LocationCombo").on('change', function (event) {
                    //Do nothing for now
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


            //Place holder grid
            var source = {};
            $("#jqxgrid").jqxGrid(
            {
                width: '100%',
                height: 500,
                source: source,
                columns: [
                        { text: 'ManualEditId', datafield: 'ManualEditId', hidden: true },
                        { text: 'FPNumber', datafield: 'FPNumber' },
                        { text: 'Full Name', datafield: 'FullName' },
                        { text: 'Points', datafield: 'Points' },
                        { text: 'DateOfRequest', datafield: 'DateOfRequest' },
                        { text: 'Certificate #', datafield: 'CertificateNumber' },
                        { text: 'Explanation', datafield: 'Explanation' }
                ]
            });

        });
        // ============= Initialize Page ================== End

        //loads main airport grid
        function loadGrid() {
            if (loading == false) {
                var thisLocationID = $('#LocationCombo').jqxComboBox('getSelectedItem').value;

                var url = $("#localApiDomain").val() + "PendingManualEdits/PendingManualEditsByLocation/" + thisLocationID;

                var source =
                {
                    datafields: [
                        { name: 'ManualEditID' },
                        { name: 'FPNumber' },
                        { name: 'FullName' },
                        { name: 'Points' },
                        { name: 'DateOfRequest' },
                        { name: 'CertificateNumber' },
                        { name: 'Explanation' }
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
                          { text: 'ManualEditId', datafield: 'ManualEditId', hidden: true },
                          { text: 'FPNumber', datafield: 'FPNumber' },
                          { text: 'Full Name', datafield: 'FullName' },
                          { text: 'Points', datafield: 'Points' },
                          { text: 'DateOfRequest', datafield: 'DateOfRequest' },
                          { text: 'Certificate #', datafield: 'CertificateNumber' },
                          { text: 'Explanation', datafield: 'Explanation' }
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

    <div id="MemberResend">      
        <div class="FPR_SearchBox" style="display:block;">
            <div class="FPR_SearchLeft" style="margin-left:10px">
                <div style ="width:600px;position:absolute;margin-top:0px;">
                    <div id="LocationCombo" style="float:left;"></div>
                    <input type="text" placeholder="FPNumber" style="float:right;height:25px;width:270px;" />
                </div>
                
                <div style ="width:600px;position:absolute;margin-top:40px;">
                    <div style="float:left;"><p style="color:white;">Member Since Beginng Date:</p> <div id="jqxBeginningDateCalendar"></div></div>
                    <div style="float:right;"><p style="color:white;">Ending Date:</p> <div id="jqxEndingDateCalendar"></div></div>
                </div>
                
            </div>
            <div class="FPR_SearchRight">
                  <a href="javascript:" id="btnSearch">Search</a>   
            </div>
        </div>
        
    </div> 
   
    
    <div id="jqxgrid"></div>
    <div id="actionButtons"><input id="btnSubmit" value="Submit" type="button" style="margin-top:15px;" /><input id="btnDelete" value="Delete" type="button" style="margin-left:75px; margin-top:15px;" /></div>
    

</asp:Content>

