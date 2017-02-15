<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="MemberCompanyUpdate.aspx.cs" Inherits="MemberCompanyUpdate" %>

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

        $(document).ready(function () {

            loadLocationCombo();
            
            loadCompaniesCombo();

            //#region SetupButtons
            $("#btnSearch").jqxButton({ width: '100%', height: 26 });
            $("#btnSetCompany").jqxButton({ width: '100%', height: 26 });
            //#endregion

            $("#btnSearch").on("click", function (event) {
                loadGrid();
            });

            $("#btnSetCompany").on("click", function (event) {
                var result = confirm("Do you want to set these member companies!");
                if (result != true) {
                    return null;
                }

                var ProcessList = "";
                var first = true;
                var getselectedrowindexes = $('#jqxMembers').jqxGrid('getselectedrowindexes');

                if (getselectedrowindexes.length > 0) {

                    for (var index = 0; index < getselectedrowindexes.length; index++) {
                        var selectedRowData = $('#jqxMembers').jqxGrid('getrowdata', getselectedrowindexes[index]);
                        if (first == true) {
                            ProcessList = ProcessList + selectedRowData.MemberId;
                            first = false;
                        }
                        else {
                            ProcessList = ProcessList + "," + selectedRowData.MemberId;
                        }
                    }

                }
                else {
                    return null;
                }

                var thisUser = $("#txtLoggedinUsername").val();
                var thisCompanyId = $("#CompnayCombo").jqxComboBox('getSelectedItem').value;

                PageMethods.UpdateMemberCompanyID(ProcessList, thisCompanyId, thisUser, DisplayPageMethodResults);
                loadGrid();
            });
        });

        // ============= Initialize Page ================== End

        function loadGrid()
        {
            var parent = $("#jqxMembers").parent();
            $("#jqxMembers").jqxGrid('destroy');
            $("<div id='jqxMembers'></div>").appendTo(parent);

            // loading order histor
            var url = $("#localApiDomain").val() + "Members/SearchByCompanyLocation/";
            //var url = "http://localhost:52839/api/Members/SearchByCompanyLocation/";

            var data = { "FPNumber": null, "FirstName": null, "LastName": null, "EmailAddress": null, "HomePhone": null, "Company": $("#CompanyName").val(), "MailerCompany": null, "MarketingCode": null, "UserName": null, "LocationId": $("#LocationCombo").jqxComboBox('getSelectedItem').value };

            var source =
            {
                datafields: [
                    { name: 'MemberId' },
                    { name: 'FirstName' },
                    { name: 'LastName' },
                    { name: 'FPNumber' },
                    { name: 'Company' },
                    { name: 'CompanyId' },
                    { name: 'EmailAddress' },
                ],
                id: 'RedemptionId',
                type: 'Post',
                datatype: "json",
                data: data,
                url: url,
            };

            // create jqxgrid
            $("#jqxMembers").jqxGrid(
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
                       { text: 'MemberId', datafield: 'MemberId', width: '7%' },
                       { text: 'FirstName', datafield: 'FirstName', width: '10%' },
                       { text: 'LastName', datafield: 'LastName', width: '10%' },
                       { text: 'FPNumber', datafield: 'FPNumber', width: '10%' },
                       { text: 'Company', datafield: 'Company', width: '40%' },
                       { text: 'CompanyId', datafield: 'CompanyId', width: '10%' },
                       { text: 'EmailAddress', datafield: 'EmailAddress', width: '10%' }
                ]
            });
        }

        function loadLocationCombo() {
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
                url: $("#localApiDomain").val() + "Locations/Locations/",

            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#LocationCombo").jqxComboBox(
            {
                theme: 'shinyblack',
                width: '100%',
                height: 24,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });
        }

        function loadCompaniesCombo() {
            //set companies combobox
            var companySource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'id' },
                    { name: 'name' }
                ],
                url: $("#localApiDomain").val() + "CompanyDropDowns/GetCompanies/",

            };
            var companyDataAdapter = new $.jqx.dataAdapter(companySource);
            $("#CompnayCombo").jqxComboBox(
            {
                width: '300px',
                height: 24,
                source: companyDataAdapter,
                selectedIndex: 0,
                displayMember: "name",
                valueMember: "id"
            });
            $('#CompnayCombo input').on('focus', function () {
                $("#CompnayCombo").jqxComboBox('open');
            });

            $("#CompnayCombo").jqxComboBox({ enableBrowserBoundsDetection: true });

            $("#CompnayCombo").on('bindingComplete', function (event) {
                $("#CompnayCombo").jqxComboBox('insertAt', '', 0);
                $("#CompnayCombo").on('change', function (event) {
                    //Do nothing for now
                });
            });
        }

    </script>

    <div id="RedemptionSearch" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-3">
                            <div class="row search-size">
                                <div class="col-sm-12">
                                    <div id="LocationCombo"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="row search-size">
                                <div class="col-sm-12">
                                    <%--<div  id="CompnayCombo"></div>--%>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="row search-size">
                                <div class="col-sm-12">
                                    <input type="text" id="CompanyName" placeholder="Company" />
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="row search-size">
                                <div class="col-sm-8 col-sm-offset-4">
                                    <div class="row search-size">
                                        <div class="col-sm-12">
                                            <input type="button" id="btnSearch" value="Search" />
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
   
    <div class="container-fluid container-970">
        <div class="row ">
            <div class="col-sm-12">
                <div id="jqxMembers"></div>
            </div>
        </div>
        <div class="row ">
            <div class="col-sm-12">
                <div style="margin-top:10px;width:100%;height:60px;background-color:bisque;border-radius:10px;padding:18px;">
                    <div class="col-sm-10">
                        <div  id="CompnayCombo"></div>
                    </div>
                    <div class="col-sm-2">
                        <input type="button" id="btnSetCompany" value="Set Company" />
                    </div>
                </div>
            </div>
        </div>
    </div><!-- /.container-fluid -->
</asp:Content>


