<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="MemberReActivate.aspx.cs" Inherits="MemberReActivate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <style>
        #MemberReActivate .FPR_SearchBox{
            width:100%;height:100px;
        }


        #SearchCriteriaButtons {
            width:50%;
            position:absolute;
            margin-left:280px;
            height:150px;
            /*border:1px solid #bbb;*/
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
    <script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>
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


        // ============= Initialize Page ==================== Begin
        $(document).ready(function () {

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


            $("#btnSearch").on("click", function (event) {

                var thisParameters = GetSearchParameters();

                if (thisParameters != "") {
                    $("#jqxgrid").jqxGrid('clear');
                    loadGrid(thisParameters);
                }
                
                
            });

        });
        // ============= Initialize Page ================== End

        //loads main airport grid
        function loadGrid(thisParameters) {

                //var thisLocationID = $('#LocationCombo').jqxComboBox('getSelectedItem').value;

                

                var url = $("#apiDomain").val() + "members/search?" + thisParameters;


                var source =
                {
                    datafields: [
                        { name: 'MemberId' },
                        { name: 'FirstName' },
                        { name: 'LastName' },
                        { name: 'FPNumber' },
                        { name: 'EmailAddress' },
                        { name: 'Company' }
                    ],

                    id: 'MemberId',
                    type: 'Get',
                    datatype: "json",
                    url: url,
                    beforeSend: function (jqXHR, settings) {
                        jqXHR.setRequestHeader('AccessToken', $("#userGuid").val());
                        jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                    },
                    root: "data"
                };

                // creage jqxgrid
                $("#jqxgrid").jqxGrid(
                {
                    pageable: true,
                    pagermode: 'simple',
                    pagesize: 12,
                    width: '100%',
                    height: 500,
                    source: source,
                    rowsheight: 35,
                    sortable: true,
                    altrows: true,
                    filterable: true,
                    columnsresize: true,
                    columns: [
                          { text: 'MemberId', datafield: 'MemberId', hidden: true },
                          { text: 'First Name', datafield: 'FirstName' },
                          { text: 'Last Name', datafield: 'LastName' },
                          { text: 'FPNumber', datafield: 'FPNumber' },
                          { text: 'EmailAddress', datafield: 'EmailAddress' },
                          { text: 'Company', datafield: 'Company' }
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
                width: 200,
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

        function GetSearchParameters() {
            var thisReturn = ""

            if ($("#SearchFirstName").val() != "") {
                thisReturn = thisReturn + "FirstName=" + $("#SearchFirstName").val();
            }
            if ($("#SearchLastName").val() != "") {
                if (thisReturn == "") {
                    thisReturn = thisReturn + "LastName=" + $("#SearchLastName").val();
                } else {
                    thisReturn = thisReturn + "&LastName=" + $("#SearchLastName").val();
                }
            }
            if ($("#SearchFPNumber").val() != "") {
                if (thisReturn == "") {
                    thisReturn = thisReturn + "FPNumber=" + $("#SearchFPNumber").val();
                } else {
                    thisReturn = thisReturn + "&FPNumber=" + $("#SearchFPNumber").val();
                }
            }
            if ($("#SearchPhoneNumber").val() != "") {
                if (thisReturn == "") {
                    thisReturn = thisReturn + "PhoneNumber=" + $("#SearchPhoneNumber").val();
                } else {
                    thisReturn = thisReturn + "&PhoneNumber=" + $("#SearchPhoneNumber").val();
                }
            }
            if ($("#SearchUserName").val() != "") {
                if (thisReturn == "") {
                    thisReturn = thisReturn + "UserName=" + $("#SearchUserName").val();
                } else {
                    thisReturn = thisReturn + "&UserName=" + $("#SearchUserName").val();
                }
            }
            if ($("#SearchCompany").val() != "") {
                if (thisReturn == "") {
                    thisReturn = thisReturn + "Company=" + $("#SearchCompany").val();
                } else {
                    thisReturn = thisReturn + "&Company=" + $("#SearchCompany").val();
                }
            }
            if ($("#SearchMailerCompany").val() != "") {
                if (thisReturn == "") {
                    thisReturn = thisReturn + "MarketingMailerCode=" + $("#SearchMailerCompany").val();
                } else {
                    thisReturn = thisReturn + "&MarketingMailerCode=" + $("#SearchMailerCompany").val();
                }
            }
            if ($("#SearchEmail").val() != "") {
                if (thisReturn == "") {
                    thisReturn = thisReturn + "EmailAddress=" + $("#SearchEmail").val();
                } else {
                    thisReturn = thisReturn + "&EmailAddress=" + $("#SearchEmail").val();
                }
            }
            if ($("#SearchMailerCode").val() != "") {
                if (thisReturn == "") {
                    thisReturn = thisReturn + "MarketingMailerCode=" + $("#SearchMailerCode").val();
                } else {
                    thisReturn = thisReturn + "&MarketingMailerCode=" + $("#SearchMailerCode").val();
                }
            }
            if ($("#SearchSteetAddress").val() != "") {
                if (thisReturn == "") {
                    thisReturn = thisReturn + "SteetAddress=" + $("#SearchSteetAddress").val();
                } else {
                    thisReturn = thisReturn + "&SteetAddress=" + $("#SearchSteetAddress").val();
                }
            }
            if ($('#LocationCombo').jqxComboBox('getSelectedItem').label != "Pick a Location") {
                
                if (thisReturn == "") {
                    thisReturn = thisReturn + "LocationId=" + $('#LocationCombo').jqxComboBox('getSelectedItem').value;
                } else {
                    thisReturn = thisReturn + "&LocationId=" + $('#LocationCombo').jqxComboBox('getSelectedItem').value;
                }
            }

            return thisReturn;
        }
    </script>

    <div id="MemberReActivate">      
        <div class="FPR_SearchBox" style="display:block;">
            <div class="FPR_SearchLeft" style="margin-left:10px">
                <div style ="width:600px;position:absolute;margin-top:0px;">
                    <div id="LocationCombo" style="float:left;"></div>
                </div>
                
                <div id="SearchCriteriaButtons">
                    <input type="text" id="SearchFirstName" placeholder="First Name" />
                    <input type="text" id="SearchLastName" placeholder="Last Name"  />
                    <input type="text" id="SearchFPNumber" placeholder="Card Number" />

                    <input type="text" id="SearchPhoneNumber" placeholder="Phone Number" />
                    <input type="text" id="SearchUserName" placeholder="User Name"  />
                    <input type="text" id="SearchCompany" placeholder="Company" />
                    <input type="text" id="SearchMailerCompany" placeholder="Mailer Company" />

                    <input type="text" id="SearchEmail" placeholder="Email" />
                    <input type="text" id="SearchMailerCode" placeholder="Mailer Code"  />
                    <input type="text" id="SearchPhone" placeholder="Phone" />
                    <input type="text" id="SearchSteetAddress" placeholder="Street Address" />
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

