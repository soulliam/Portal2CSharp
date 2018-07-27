<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="RateAmounts.aspx.cs" Inherits="RateAmounts" %>

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
    <script type="text/javascript" src="jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxmaskedinput.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>    
    <script type="text/javascript" src="jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.edit.js"></script>


    <script type="text/javascript">
        //Mike
        // ============= Initialize Page ==================== Begin
        var group = '<%= Session["groupList"] %>';

        if (group.indexOf("Portal_Superadmin") <= 0) {
            $(location).attr("href", "http://www.thefastpark.com");
        }

        $(document).ready(function () {

            //set up the to location combobox
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
                //url: "http://localhost:52839/api/Locations/Locations/",
            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#LocationCombo").jqxComboBox(
            {
                width: 200,
                height: 21,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId"
            });


            $("#LocationCombo").on('bindingComplete', function (event) {
                $("#LocationCombo").jqxComboBox('insertAt', 'Pick a Location', 0);
            });

            $("#LocationCombo").on('select', function (event) {
                if (event.args) {
                    var item = event.args.item;
                    if (item.index <= 0) {
                        return null;
                    }
                    if (item) {
                        loadGrid($("#LocationCombo").jqxComboBox('getSelectedItem').value);
                    }
                }
            });

            Security();

        });



        // ============= Initialize Page ================== End

        function loadGrid(locationResult)
        {
            var parent = $("#RateAmountsGrid").parent();
            $("#RateAmountsGrid").jqxComboBox('destroy');
            $("<div id='RateAmountsGrid'></div>").appendTo(parent);

            var url = $("#localApiDomain").val() + "RateAmountObjects/GetRateAmounts/" + locationResult;
            //var url = "http://localhost:52839/api/RateAmountObjects/GetRateAmounts/" + locationResult;

            var source =
            {
                datafields: [
                    { name: 'RateAmountId' },
                    { name: 'RateCode' },
                    { name: 'RateAmount' },
                    { name: 'EffectiveDatetime', type: 'date' },
                    { name: 'AdvertisedRate' },
                    { name: 'HourlyRate' },
                    { name: 'DailyRateThreshold' },
                    { name: 'UpdateDatetime' },
                    { name: 'UpdateExternalUserData' }
                ],
                id: 'ManualEditId',
                type: 'Get',
                datatype: "json",
                url: url,
            };

            // creage jqxgrid
            $("#RateAmountsGrid").jqxGrid(
            {
                width: '100%',
                height: 500,
                source: source,
                rowsheight: 35,
                showeverpresentrow: true,
                everpresentrowposition: "bottom",
                everpresentrowactions: "add",
                columns: [
                       { text: 'RateAmountId', datafield: 'RateAmountId', hidden: true },
                       { text: 'RateCode', datafield: 'RateCode' },
                       { text: 'RateAmount', datafield: 'RateAmount' },
                       { text: 'EffectiveDatetime', datafield: 'EffectiveDatetime', cellsformat: 'd',
                           createEverPresentRowWidget: function (datafield, htmlElement, popup, addCallback) {
                               var inputTag = $("<div style='border: none;'></div>").appendTo(htmlElement);
                               inputTag.jqxDateTimeInput({ value: null, popupZIndex: 99999999, placeHolder: "Enter Date: ", width: '100%', height: 30, formatString: 'd' });
                               $(document).on('keydown.date', function (event) {
                                   if (event.keyCode == 13) {
                                       if (event.target === inputTag[0]) {
                                           addCallback();
                                       }
                                       else if ($(event.target).ischildof(inputTag)) {
                                           addCallback();
                                       }
                                   }
                               });
                               return inputTag;
                           },
                           initEverPresentRowWidget: function (datafield, htmlElement) {
                           },
                           getEverPresentRowWidgetValue: function (datafield, htmlElement, validate) {
                               var value = htmlElement.val();
                               return value;
                           },
                           resetEverPresentRowWidgetValue: function (datafield, htmlElement) {
                               htmlElement.val(null);
                           }
                       },
                       { text: 'AdvertisedRate', datafield: 'AdvertisedRate' },
                       { text: 'HourlyRate', datafield: 'HourlyRate' },
                       { text: 'DailyRateThreshold', datafield: 'DailyRateThreshold' },
                       { text: 'UpdateDatetime', datafield: 'UpdateDatetime', cellsrenderer: DateRender,
                            createEverPresentRowWidget: function (datafield, htmlElement, popup, addCallback) {
                                var inputTag = $("<div style='border: none;'></div>").appendTo(htmlElement);
                                return inputTag;
                            },
                            initEverPresentRowWidget: function (datafield, htmlElement) {
                            },
                            getEverPresentRowWidgetValue: function (datafield, htmlElement, validate) {
                                var value = htmlElement.val();
                                return value;
                            },
                            resetEverPresentRowWidgetValue: function (datafield, htmlElement) {
                                htmlElement.val(null);
                            }
                       },
                       {   text: 'UpdateExternalUserData', datafield: 'UpdateExternalUserData',
                           createEverPresentRowWidget: function (datafield, htmlElement, popup, addCallback) {
                               var inputTag = $("<div style='border: none;'></div>").appendTo(htmlElement);
                               return inputTag;
                           },
                           initEverPresentRowWidget: function (datafield, htmlElement) {
                           },
                           getEverPresentRowWidgetValue: function (datafield, htmlElement, validate) {
                               var value = htmlElement.val();
                               return value;
                           },
                           resetEverPresentRowWidgetValue: function (datafield, htmlElement) {
                               htmlElement.val(null);
                           }
                       },
                       {
                           text: 'Save', dataField: 'Save', width: 160, cellsalign: 'right',
                                createEverPresentRowWidget: function (datafield, htmlElement, popup, addCallback) {
                                    var inputTag = $("<div style='border: none;'></div>").appendTo(htmlElement);
                                    return inputTag;
                                },
                                initEverPresentRowWidget: function (datafield, htmlElement) {
                                },
                                getEverPresentRowWidgetValue: function (datafield, htmlElement, validate) {
                                    var value = htmlElement.val();
                                    return value;
                                },
                                resetEverPresentRowWidgetValue: function (datafield, htmlElement) {
                                    htmlElement.val(null);
                                },
                                cellsrenderer: function (row, column, value) {
                                editrow = row;
                                var dataRecord = $("#RateAmountsGrid").jqxGrid('getrowdata', editrow);

                                if (dataRecord.RateAmountId > 0) {
                                    return '';
                                }
                                else if (dataRecord.RateAmountId == -1)
                                {
                                    return '<input id="button' + row + '" onClick="buttonClick(' + row + ')"  type="button" value="Saved" style="margin-top:6px;margin-right:5px;width:70px;"  disabled /><input id="deleteButton' + row + '" onClick="deleteButtonClick(' + row + ')"  type="button" value="Delete" style="margin-top:6px;width:70px;display:none;"/>';
                                }
                                else
                                {
                                    return '<input id="button' + row + '" onClick="buttonClick(' + row + ')"  type="button" value="Save" style="margin-top:6px;margin-right:5px;width:70px;"/><input id="deleteButton' + row + '" onClick="deleteButtonClick(' + row + ')"  type="button" value="Delete" style="margin-top:6px;width:70px;"/>';
                                }
                            }
                       }
                ]
            });
        }

        function deleteButtonClick(rowIndex) {
            var id = $('#RateAmountsGrid').jqxGrid('getrowid', rowIndex);
            $('#RateAmountsGrid').jqxGrid('deleterow', id);
        }

        function buttonClick(rowIndex) {
            var data = $('#RateAmountsGrid').jqxGrid('getrowdata', rowIndex);
            
            var postData = { "RateCode": data.RateCode, "RateAmount": data.RateAmount, "EffectiveDatetime": data.EffectiveDatetime, "LocationId": $("#LocationCombo").jqxComboBox('getSelectedItem').value, "AdvertisedRate": data.AdvertisedRate, "HourlyRate": data.HourlyRate, "DailyRateThreshold": data.DailyRateThreshold, "UpdateExternalUserData": $("#loginLabel").html() };

            $.ajax({
                async: true,
                type: "POST",
                url: $("#localApiDomain").val() + "RateAmountObjects/PostRateAmounts/",
                //url: "http://localhost:52839/api/RateAmountObjects/PostRateAmounts/",

                data: postData,
                dataType: "json",
                success: function (thisData) {
                    $("#button" + rowIndex).attr("disabled", "disabled");
                    $("#button" + rowIndex).val("Saved");
                    $("#deleteButton" + rowIndex).hide();
                    var id = $('#RateAmountsGrid').jqxGrid('getrowid', rowIndex);
                    $("#RateAmountsGrid").jqxGrid('setcellvaluebyid', id, "RateAmountId", "-1");
                    //loadGrid($("#LocationCombo").jqxComboBox('getSelectedItem').value);
                },
                error: function (request, status, error) {
                    alert(error);
                }
            });
            
            
        }

    </script>
    
    <div id="CardInventoryShipping" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-12" style="text-align:center">
                            
                        </div>
                    </div>
                    <div class="row search-size">
                        <div class="col-sm-7">
                            <div class="row search-size">
                                <div>
                                    <div id="LocationCombo"></div>
                                </div>
                                <div class="col-sm-15">
                                    
                                </div>
                                <div id="regShip" class="swapfields">
                                    
                                </div>
                                <div id="specShip" class="swapfields">
                                    <div class="col-sm-15">
                                        
                                    </div>
                                    <div class="col-sm-15">
                                        
                                    </div>
                                    <div class="col-sm-15">
                                        
                                    </div>
                                </div>
                                <div id="cardDesign"></div>
                            </div>
                        </div>
                        <div class="col-sm-5">
                           
                           
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div><!-- /.container-fluid -->
    
    <div class="container-fluid container-970">
        <div class="row ">
            <div class="col-sm-12">
                <div id="RateAmountsGrid"></div>
            </div>
        </div>
    </div><!-- /.container-fluid -->
    
</asp:Content>


