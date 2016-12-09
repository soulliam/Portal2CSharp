<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="LocationFeatures.aspx.cs" Inherits="LocationFeatures" %>

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

    <script type="text/javascript">
        var group = '<%= Session["groupList"] %>';

        // ============= Initialize Page ==================== Begin
        $(document).ready(function () {

            loadGrid();

            //#region SetupButtons
            $("#btnNew").jqxLinkButton({ width: '100%', height: '26' });
            $("#Save").jqxButton();
            $("#Cancel").jqxButton();
            //#endregion
            
            $("#Save").click(function () {
                if ($("#FeatureId").val() == "") {

                    var newFeatureName = $("#FeatureName").val();
                    var newImageUrl = $("#ImageUrl").val();
                    var newSubtext = $("#Subtext").val();
                    var newDetail = $("#Detail").val();
                    var newDisplayOnLandingPage = $("#DisplayOnLandingPage").val();
                    var newSortOrder = $("#SortOrder").val();
                    var newIconCSSClass = $("#IconCSSClass").val();

                    
                    
                    $.ajax({
                        headers: {
                            "Accept": "application/json",
                            "Content-Type": "application/json",
                            "AccessToken": $("#userGuid").val(),
                            "ApplicationKey": $("#AK").val()
                        },
                        type: "POST",
                        url: $("#apiDomain").val() + "features",
                        data: JSON.stringify({
                            "FeatureName": newFeatureName,
                            "ImageUrl": newImageUrl,
                            "Subtext": newSubtext,
                            "Detail": newDetail,
                            "DisplayOnLandingPage": newDisplayOnLandingPage,
                            "SortOrder": newSortOrder,
                            "IconCSSClass": newIconCSSClass
                        }),
                        dataType: "json",
                        success: function (response) {
                            alert("Saved!");
                            $('#jqxGrid').jqxGrid('clear');
                            loadGrid();
                        },
                        error: function (request, status, error) {
                            alert(error + " - " + request.responseJSON.message);
                        }
                    })
                  
                    $("#popupWindow").jqxWindow('hide');
                    clearPopUp();

                } else {
                    if (editrow >= 0) {

                        var newFeatureId = $("#FeatureId").val();
                        var newFeatureName = $("#FeatureName").val();
                        var newImageUrl = $("#ImageUrl").val();
                        var newSubtext = $("#Subtext").val();
                        var newDetail = $("#Detail").val();
                        var newDisplayOnLandingPage = $("#DisplayOnLandingPage").val();
                        var newSortOrder = $("#SortOrder").val();
                        var newIconCSSClass = $("#IconCSSClass").val();

                        var putUrl = $("#apiDomain").val() + "features/" + newFeatureId
                        
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
                                "FeatureName": newFeatureName,
                                "ImageUrl": newImageUrl,
                                "Subtext": newSubtext,
                                "Detail": newDetail,
                                "DisplayOnLandingPage": newDisplayOnLandingPage,
                                "SortOrder": newSortOrder,
                                "IconCSSClass": newIconCSSClass
                            }),
                            dataType: "json",
                            success: function (response) {
                                alert("Saved!");
                                loadGrid();
                            },
                            error: function (request, status, error) {
                                alert(error + " - " + request.responseJSON.message);
                            }
                        })

                        $("#popupWindow").jqxWindow('hide');
                        clearPopUp();
                    }
                }
            });

            $("#Cancel").click(function () {
                clearPopUp();
            });

            function clearPopUp() {
                $("#popupWindow").jqxWindow('hide');
                $("#FeatureId").val("");
                $("#FeatureName").val("");
                $("#ImageUrl").val("");
                $("#Subtext").val("");
                $("#Detail").val("");
                $("#SortOrder").val("");
            }

            Security();

        });
        // ============= Initialize Page ================== End

        function loadGrid() {

            var url = $("#apiDomain").val() + "features";

            var source =
            {
                datafields: [
                    { name: 'FeatureId' },
                    { name: 'FeatureName' },
                    { name: 'Subtext' },
                    { name: 'Detail' },
                    { name: 'SortOrder' },
                    { name: 'IconCSSClass' },
                    { name: 'ImageUrl' },
                    { name: 'DisplayOnLandingPage', type: 'bool' }
                ],
                beforeSend: function (jqXHR, settings) {
                    jqXHR.setRequestHeader('ApplicationKey', $("#AK").val());
                },
                id: 'FeatureId',
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
                pageable: true,
                columns: [
                      {
                          text: '', pinned: true, datafield: 'Edit', width: 50, columntype: 'button', cellsrenderer: function () {
                              return "Edit";
                          }, buttonclick: function (row) {
                              // open the popup window when the user clicks a button.
                              editrow = row;
                              
                              // get the clicked row's data and initialize the input fields.
                              var dataRecord = $("#jqxgrid").jqxGrid('getrowdata', editrow);
                             
                              $("#FeatureId").val(dataRecord.FeatureId);
                              $("#FeatureName").val(dataRecord.FeatureName);
                              $("#ImageUrl").val(dataRecord.ImageUrl);
                              $("#Subtext").val(dataRecord.Subtext);
                              $("#Detail").val(dataRecord.Detail);
                              $("#DisplayOnLandingPage").val(dataRecord.DisplayOnLandingPage);
                              $("#SortOrder").val(dataRecord.SortOrder);
                              $("#IconCSSClass").val(dataRecord.IconCSSClass);
                              // show the popup window.
                              $("#popupImage").css('display', 'block');
                              $("#popupImage").css('visibility', 'hidden');

                              var offset = $("#jqxgrid").offset();
                              $("#popupWindow").jqxWindow({ position: { x: '5%', y: '30%' } });
                              $('#popupWindow').jqxWindow({ resizable: false });
                              $('#popupWindow').jqxWindow({ draggable: true });
                              $('#popupWindow').jqxWindow({ isModal: true });
                              $("#popupWindow").css("visibility", "visible");
                              $('#popupWindow').jqxWindow({ height: '320px', width: '90%' });
                              $('#popupWindow').jqxWindow({ minHeight: '320px', minWidth: '90%' });
                              $('#popupWindow').jqxWindow({ maxHeight: '500px', maxWidth: '90%' });
                              $('#popupWindow').jqxWindow({ showCloseButton: true });
                              $('#popupWindow').jqxWindow({ animationType: 'combined' });
                              $('#popupWindow').jqxWindow({ showAnimationDuration: 300 });
                              $('#popupWindow').jqxWindow({ closeAnimationDuration: 500 });
                              $("#popupWindow").jqxWindow('open');
                              

                          }, width: '4%'
                      },
                      { text: 'Feature Id', datafield: 'FeatureId', width: '5%' },
                      { text: 'Feature Name', datafield: 'FeatureName', width: '14%' },
                      { text: 'Detail', datafield: 'Detail', width: '14%' },
                      { text: 'Sort Order', datafield: 'SortOrder', width: '5%' },
                      { text: 'IconCSSClass', datafield: 'IconCSSClass', width: '9%' },
                      { text: 'Image Url', datafield: 'ImageUrl', width: '22%' },
                      { text: 'Sub-Text', datafield: 'Subtext', width: '22%' },
                      { text: 'Display', datafield: 'DisplayOnLandingPage', threestatecheckbox: true, columntype: 'checkbox', width: '5%' }
                ]
            });

        }

        function newFeature() {
            var offset = $("#jqxgrid").offset();$("#popupWindow").jqxWindow({ position: { x: '5%', y: '30%' } });
            $('#popupWindow').jqxWindow({ resizable: false });
            $('#popupWindow').jqxWindow({ draggable: true });
            $('#popupWindow').jqxWindow({ isModal: true });
            $("#popupWindow").css("visibility", "visible");
            $('#popupWindow').jqxWindow({ height: '320px', width: '90%' });
            $('#popupWindow').jqxWindow({ minHeight: '320px', minWidth: '90%' });
            $('#popupWindow').jqxWindow({ maxHeight: '500px', maxWidth: '90%' });
            $('#popupWindow').jqxWindow({ showCloseButton: true });
            $('#popupWindow').jqxWindow({ animationType: 'combined' });
            $('#popupWindow').jqxWindow({ showAnimationDuration: 300 });
            $('#popupWindow').jqxWindow({ closeAnimationDuration: 500 });
            $("#popupWindow").jqxWindow('open');
        }

    </script>
    
    <div id="LocationFeatures" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size FPR_SearchLeft">
                <div class="col-sm-12 col-md-10 col-md-offset-1">
                    <div class="row search-size">
                        <div class="col-sm-3 col-sm-offset-9">
                            <div class="row search-size">
                                <div class="col-sm-8 col-sm-offset-4">
                                    <div class="row search-size">
                                        <div class="col-sm-12">
                                            <a href="javascript:newFeature();" id="btnNew" class="editor">New Feature</a>
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
        <div>Feature Details</div>
        <div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-6">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="FeatureId" class="col-sm-3 col-md-4 control-label">Feature Id:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="FeatureId" disabled />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="FeatureName" class="col-sm-3 col-md-4 control-label">Feature Name:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="FeatureName" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="ImageUrl" class="col-sm-3 col-md-4 control-label">Image Url:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="ImageUrl" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="Subtext" class="col-sm-3 col-md-4 control-label">Sub-Text:</label>
                                <div class="col-sm-9 col-md-8">
                                    <textarea rows="4" class="form-control" id="Subtext" /></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="Detail" class="col-sm-3 col-md-4 control-label">Detail:</label>
                                <div class="col-sm-9 col-md-8">
                                    <textarea rows="4" class="form-control" id="Detail" /></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="SortOrder" class="col-sm-3 col-md-4 control-label">Sort Order:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="SortOrder" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="IconCSSClass" class="col-sm-3 col-md-4 control-label">Icon CSS Class:</label>
                                <div class="col-sm-9 col-md-8">
                                    <input type="text" class="form-control" id="IconCSSClass" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="DisplayOnLandingPage" class="col-sm-3 col-md-4 control-label">Display On Landing Page:</label>
                                <div class="col-sm-9 col-md-8">
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" class="form-control" id="DisplayOnLandingPage" />
                                        </label>
                                    </div>
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
                                <input type="button" id="Save" value="Save" class="editor" />
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


