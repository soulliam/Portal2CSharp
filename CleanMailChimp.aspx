<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="CleanMailChimp.aspx.cs" Inherits="CleanMailChimp" %>

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
    <script type="text/javascript" src="jqwidgets/jqxgrid.edit.js"></script>



    <script type="text/javascript">
        var group = '<%= Session["groupList"] %>';
        
        //add home office and warehouse
        if (group.indexOf("Portal_RFR") <= 0 && group.indexOf("Portal_Superadmin") <= 0) {
            window.location = "MemberSearch.aspx";
        }

        $(document).ready(function () {
            loadGrid();
        });

        function loadGrid() {


            // loading order histor
            //var url = $("#localApiDomain").val() + "MailChimps/MailChimpCleanUp/";
            var url = "http://localhost:52839/api/MailChimps/MailChimpCleanUp/";

            var source =
            {
                datafields: [
                    { name: 'MemberId' },
                    { name: 'MCFirstName' },
                    { name: 'MCLastName' },
                    { name: 'MCEmailAddress' },
                    { name: 'MCFPNumber' },
                    { name: 'FirstName' },
                    { name: 'LastName' },
                    { name: 'EmailAddress' }
                ],
                type: 'Get',
                datatype: "json",
                url: url,
            };

            var padCard = function (row, columnfield, value, defaulthtml, columnproperties) {
                var newValue = padNumber(value, 8, '0');
                return '<div style="margin-top: 10px;margin-left: 5px">' + newValue + '</div>';
            }

            // creage jqxgrid
            $("#jqxMailChimpCleanUp").jqxGrid(
            {
                width: '100%',
                height: 500,
                source: source,
                rowsheight: 35,
                sortable: true,
                altrows: true,
                filterable: true,
                selectionmode: 'checkbox',
                editable: true,
                columns: [
                       { text: 'MemberId', datafield: 'MemberId', hidden: true },
                       { text: 'MCFirstName', datafield: 'MCFirstName' },
                       { text: 'MCLastName', datafield: 'MCLastName' },
                       { text: 'MCEmailAddress', datafield: 'MCEmailAddress' },
                       { text: 'MCFPNumber', datafield: 'MCFPNumber' },
                       { text: 'FirstName', datafield: 'FirstName' },
                       { text: 'LastName', datafield: 'LastName', cellsrenderer: padCard },
                       { text: 'EmailAddress', datafield: 'EmailAddress' }
                ]
            });
        }
    </script>

    <div class="container-fluid container-970">
        <div class="row ">
            <div class="col-sm-12">
                <div id="jqxMailChimpCleanUp"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->

</asp:Content>

