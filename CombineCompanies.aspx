<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="CombineCompanies.aspx.cs" Inherits="CombineCompanies" %>

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
    <script type="text/javascript" src="jqwidgets/jqxinput.js"></script>

    <script type="text/javascript">
        // ============= Initialize Page ==================== Begin
        var loading = true;
        var group = '<%= Session["groupList"] %>';

        $(document).ready(function () {
            $("#Combine1to2").jqxButton();
            $("#Combine2to1").jqxButton();

            var source = {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'id' },
                    { name: 'name' }
                ],
                url: $("#localApiDomain").val() + "CompanyDropDowns/GetCompanies/",
                //url: "http://localhost:52839/api/CompanyDropDowns/GetCompanies/",

            };
            var companies = new Array();
            var dataAdapter = new $.jqx.dataAdapter(source, {
                autoBind: true,
                loadComplete: function (data) {
                    for (var i = 0; i < data.length; i++) {
                        companies.push({
                            label: data[i].name,
                            value: data[i].id
                        });
                    };
                }
            });

            $("#Company1").jqxInput({
                placeHolder: "",
                displayMember: "name",
                valueMember: "id",
                width: '100%',
                height: 25,
                disabled: false,
                items: 20,
                source: function (query, response) {
                    var item = query.split(/,\s*/).pop();
                    // update the search query.
                    $("#Company1").jqxInput({
                        query: item
                    });
                    response(companies);
                },
                renderer: function (itemValue, inputValue) {
                    var terms = inputValue.split(/,\s*/);
                    // remove the current input
                    terms.pop();
                    // add the selected item
                    terms.push(itemValue);
                    // add placeholder to get the comma-and-space at the end
                    terms.push("");
                    var value = terms.join(" ");
                    return value;
                },

            });
            $("#Company1").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {
                        $("#Company1ID").val(item.value);
                        var thisCompanyId = item.value;

                        var url = $("#localApiDomain").val() + "CombineCompanysController/CompanyInfo/" + thisCompanyId;
                        //var url = "http://localhost:52839/api/CombineCompanysController/CompanyInfo/" + thisCompanyId;

                        $.ajax({
                            type: "GET",
                            url: url,
                            dataType: "json",
                            success: function (data) {
                                $("#Company1Id").html('&nbsp;&nbsp;' + data[0].id);
                                $("#Company1Name").html('&nbsp;&nbsp;' + data[0].name);
                                $("#Company1Address").html('&nbsp;&nbsp;' + data[0].address_1);
                                $("#Company1cityStateZip").html('&nbsp;&nbsp;' + data[0].city + ', ' + data[0].state + ' ' + data[0].zip);
                                $("#Company1Domain").html('&nbsp;&nbsp;' + data[0].website);
                                $("#Company1HomeRate").html('&nbsp;&nbsp;' + data[0].home_rate_code);
                                $("#Company1AwayRate").html('&nbsp;&nbsp;' + data[0].away_rate_code);
                            },
                            error: function (request, status, error) {
                                swal(error);
                            }
                        });

                        var url = $("#localApiDomain").val() + "CombineCompanysController/GetActivity/" + thisCompanyId;
                        //var url = "http://localhost:52839/api/CombineCompanysController/GetActivity/" + thisCompanyId;

                        $.ajax({
                            type: "GET",
                            url: url,
                            dataType: "json",
                            success: function (data) {
                                $("#Company1Members").html('&nbsp;&nbsp;' + data.members);
                                $("#Company1Activity").html('&nbsp;&nbsp;' + data.activity);
                                $("#Company1ManualEdits").html('&nbsp;&nbsp;' + data.manual_edits);
                                $("#Company1MailerRates").html('&nbsp;&nbsp;' + data.mailer_rates);
                                $("#Company1Contacts").html('&nbsp;&nbsp;' + data.contacts);
                                $("#Company1Flyers").html('&nbsp;&nbsp;' + data.flyers);
                            },
                            error: function (request, status, error) {
                                swal(error);
                            }
                        });
                    }
                }
            });

            $("#Company2").jqxInput({
                placeHolder: "",
                displayMember: "name",
                valueMember: "id",
                width: '100%',
                height: 25,
                disabled: false,
                items: 20,
                source: function (query, response) {
                    var item = query.split(/,\s*/).pop();
                    // update the search query.
                    $("#Company2").jqxInput({
                        query: item
                    });
                    response(companies);
                },
                renderer: function (itemValue, inputValue) {
                    var terms = inputValue.split(/,\s*/);
                    // remove the current input
                    terms.pop();
                    // add the selected item
                    terms.push(itemValue);
                    // add placeholder to get the comma-and-space at the end
                    terms.push("");
                    var value = terms.join(" ");
                    return value;
                },

            });
            $("#Company2").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item) {
                        $("#Company2ID").val(item.value);
                        var thisCompanyId = item.value;

                        var url = $("#localApiDomain").val() + "CombineCompanysController/CompanyInfo/" + thisCompanyId;
                        //var url = "http://localhost:52839/api/CombineCompanysController/CompanyInfo/" + thisCompanyId;

                        $.ajax({
                            type: "GET",
                            url: url,
                            dataType: "json",
                            success: function (data) {
                                $("#Company2Id").html('&nbsp;&nbsp;' + data[0].id);
                                $("#Company2Name").html('&nbsp;&nbsp;' + data[0].name);
                                $("#Company2Address").html('&nbsp;&nbsp;' + data[0].address_1);
                                $("#Company2cityStateZip").html('&nbsp;&nbsp;' + data[0].city + ', ' + data[0].state + ' ' + data[0].zip);
                                $("#Company2Domain").html('&nbsp;&nbsp;' + data[0].website);
                                $("#Company2HomeRate").html('&nbsp;&nbsp;' + data[0].home_rate_code);
                                $("#Company2AwayRate").html('&nbsp;&nbsp;' + data[0].away_rate_code);
                            },
                            error: function (request, status, error) {
                                swal(error);
                            }
                        });

                        var url = $("#localApiDomain").val() + "CombineCompanysController/GetActivity/" + thisCompanyId;
                        //var url = "http://localhost:52839/api/CombineCompanysController/GetActivity/" + thisCompanyId;

                        $.ajax({
                            type: "GET",
                            url: url,
                            dataType: "json",
                            success: function (data) {
                                $("#Company2Members").html('&nbsp;&nbsp;' + data.members);
                                $("#Company2Activity").html('&nbsp;&nbsp;' + data.activity);
                                $("#Company2ManualEdits").html('&nbsp;&nbsp;' + data.manual_edits);
                                $("#Company2MailerRates").html('&nbsp;&nbsp;' + data.mailer_rates);
                                $("#Company2Contacts").html('&nbsp;&nbsp;' + data.contacts);
                                $("#Company2Flyers").html('&nbsp;&nbsp;' + data.flyers);
                            },
                            error: function (request, status, error) {
                                swal(error);
                            }
                        });
                    }
                }
            });

            $("#Combine2to1").on("click", function (event) {
                swal({
                    title: 'Are you sure?',
                    text: "Do you want to combine Company 2 into Company 1?",
                    type: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, combine them!'
                }).then(function () {
                    var thisCompany1 = $("#Company1ID").val();
                    var thisCompany2 = $("#Company2ID").val();

                    PageMethods.combineCompany(thisCompany2, thisCompany1, DisplayPageMethodResults);
                    return null;
                });

                return null;
            });

            $("#Combine1to2").on("click", function (event) {
                swal({
                    title: 'Are you sure?',
                    text: "Do you want to combine Company 1 into Company 2?",
                    type: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, combine them!'
                }).then(function () {
                    var thisCompany1 = $("#Company1ID").val();
                    var thisCompany2 = $("#Company2ID").val();

                    PageMethods.combineCompany(thisCompany1, thisCompany2, DisplayPageMethodResults);
                    return null;
                });

                return null;
            });

            //$('#Company1').on('open', function (event) {
            //    $('.jqx-menu-vertical').css({
            //        'max-height': '300px',
            //        'overflow-y': 'auto',
            //        'overflow-x': 'hidden',
            //    });
            //});

            Security()
        });
        // ============= Initialize Page ================== End

    </script>
    
    <style>

    </style>

    <div id="CompanyCheck">      
        <div class="FPR_SearchBox" style="display:block;">
            <div class="FPR_SearchLeft" style="margin-left:10px;">
                <div class="row search-size FPR_SearchLeft">
                    <div class="col-sm-2"></div>
                    <div class="col-sm-2"><label style="font-size:large;color:white;">Company 1</label></div>
                    <div class="col-sm-2"></div>
                    <div class="col-sm-2"></div>
                    <div class="col-sm-2"><label style="font-size:large;color:white;">Company 2</label></div>
                    <div class="col-sm-2"></div>
                </div>
            </div>
            <div class="FPR_SearchLeft" style="margin-left:10px;">
                <div class="row search-size FPR_SearchLeft">
                    <div class="col-sm-2"></div>
                    <div class="col-sm-2">
                        <input type="text" id="Company1" class="NoAsstMgr" />
                        <input type="text" id="Company1ID" style="display:none;" />
                    </div>
                    <div class="col-sm-2"></div>
                    <div class="col-sm-2"></div>
                    <div class="col-sm-2">
                        <input type="text" id="Company2" class="NoAsstMgr" />
                        <input type="text" id="Company2ID" style="display:none;" />
                    </div>
                    <div class="col-sm-2"></div>
                </div>
            </div>
        </div>
        <div style="margin-top:10px;margin-left:150px;margin-right:150px;">
            <div style="float:left;background-color:white;width:400px;font-size:medium">
                <div>CompanyId:<label style="font-size:14px;" id="Company1Id"></label></div>
                <div>Name:<label style="font-size:14px;" id="Company1Name"></label></div>
                <div>Address:<label style="font-size:14px;" id="Company1Address"></label></div>
                <div>City, State Zip:<label style="font-size:14px;" id="Company1cityStateZip"></label></div>
                <div>Domain:<label style="font-size:14px;" id="Company1Domain"></label></div>
                <div>Home Rate:<label style="font-size:14px;" id="Company1HomeRate"></label></div>
                <div>Away Rate:<label style="font-size:14px;" id="Company1AwayRate"></label></div>
            </div>
            <div style="float:right;background-color:white;width:400px;font-size:medium">
                <div>CompanyId:<label style="font-size:14px;" id="Company2Id"></label></div>
                <div>Name:<label style="font-size:14px;" id="Company2Name"></label></div>
                <div>Address:<label style="font-size:14px;" id="Company2Address"></label></div>
                <div>City, State Zip:<label style="font-size:14px;" id="Company2cityStateZip"></label></div>
                <div>Domain:<label style="font-size:14px;" id="Company2Domain"></label></div>
                <div>Home Rate:<label style="font-size:14px;" id="Company2HomeRate"></label></div>
                <div>Away Rate:<label style="font-size:14px;" id="Company2AwayRate"></label></div>
            </div>
        </div>
        <div style="position:relative;margin-top:200px;margin-left:150px;margin-right:150px;">
            <div style="float:left;background-color:white;width:400px;font-size:medium">
                <div>Members:<label style="font-size:14px;" id="Company1Members"></label></div>
                <div>Activity:<label style="font-size:14px;" id="Company1Activity"></label></div>
                <div>Manual Edits:<label style="font-size:14px;" id="Company1ManualEdits"></label></div>
                <div>Mailer Rates:<label style="font-size:14px;" id="Company1MailerRates"></label></div>
                <div>Contacts:<label style="font-size:14px;" id="Company1Contacts"></label></div>
                <div>Flyers:<label style="font-size:14px;" id="Company1Flyers"></label></div>
            </div>
            <div style="float:right;background-color:white;width:400px;font-size:medium">
                <div>Members:<label style="font-size:14px;" id="Company2Members"></label></div>
                <div>Activity:<label style="font-size:14px;" id="Company2Activity"></label></div>
                <div>Manual Edits:<label style="font-size:14px;" id="Company2ManualEdits"></label></div>
                <div>Mailer Rates:<label style="font-size:14px;" id="Company2MailerRates"></label></div>
                <div>Contacts:<label style="font-size:14px;" id="Company2Contacts"></label></div>
                <div>Flyers:<label style="font-size:14px;" id="Company2Flyers"></label></div>
            </div>
        </div>
        <div style="position:relative;margin-top:370px;margin-left:150px;margin-right:150px;">
            <div style="float:left;">
                <input type="button" value="Combine 2 into 1" id="Combine2to1" />
            </div>
            <div style="float:right;">
                <input type="button" value="Combine 1 into 2" id="Combine1to2" />
            </div>
        </div>
    </div> 
</asp:Content>

