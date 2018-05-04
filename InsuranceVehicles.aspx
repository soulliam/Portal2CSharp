<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceVehicles.aspx.cs" Inherits="InsuranceVehicles" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <link rel="stylesheet" href="/jqwidgets/styles/jqx.base.css" type="text/css" />


    <script type="text/javascript" src="scripts/Member/UpdateMember.js"></script>
    <script type="text/javascript" src="scripts/Member/MemberReservation.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.js"></script>
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
    <script type="text/javascript" src="jqwidgets/jqxgrid.selection.js"></script> c
    <script type="text/javascript" src="jqwidgets/jqxgrid.sort.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>    
    <script type="text/javascript" src="jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxtabs.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxloader.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxradiobutton.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.edit.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdropdownbutton.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdata.export.js"></script> 
    <script type="text/javascript" src="jqwidgets/jqxgrid.export.js"></script> 

    <script type="text/javascript">
        var calendarChanged = false;
        var group = '<%= Session["groupList"] %>';
        var gblCheckedLocations = "";
        var gblCheckedStatus = "";
        var gblCheckedCoverage = "";
        var updateRows = [];

        $(document).ready(function () {
            $("#btnSearch").jqxButton({ width: 120, height: 30 });
            $("#export").jqxButton({ width: 120, height: 30 });
            $("#selectAll").jqxButton({ width: 200, height: 30 });
            $("#unSelectAll").jqxButton({ width: 200, height: 30 });
            $("#update").jqxButton({ width: 120, height: 30 });

            $("#btnSearch").on("click", function (event) {
                var items = $("#LocationCombo").jqxDropDownList('getCheckedItems');
                var checkedItems = "";
                var first = true;
                $.each(items, function (index) {
                    if (first == true) {
                        checkedItems = this.value;
                        first = false;
                    } else {
                        checkedItems = checkedItems + "_" + this.value;
                    }
                });
                gblCheckedLocations = checkedItems;

                var items = $("#StatusCombo").jqxDropDownList('getCheckedItems');
                var checkedItems = "";
                var first = true;
                $.each(items, function (index) {
                    if (first == true) {
                        checkedItems = this.value;
                        first = false;
                    } else {
                        checkedItems = checkedItems + "_" + this.value;
                    }
                });
                gblCheckedStatus = checkedItems;

                var items = $("#CoverageCombo").jqxDropDownList('getCheckedItems');
                var checkedItems = "";
                var first = true;
                $.each(items, function (index) {
                    if (first == true) {
                        checkedItems = this.value;
                        first = false;
                    } else {
                        checkedItems = checkedItems + "_" + this.value;
                    }
                });
                gblCheckedCoverage = checkedItems;

                loadSearchResults(gblCheckedLocations + '~' + gblCheckedStatus + '~' + gblCheckedCoverage);
            });

            $("#export").on("click", function (event) {
                //$("#jqxSearchGrid").jqxGrid('exportdata', 'xls', 'jqxGrid');

                var rows = $('#jqxSearchGrid').jqxGrid('getrows');
                var thisLength = rows.length - 1;

                for (i = 0; i <= thisLength; i++) {
                    if (rows[i].CoverageAdded != null) {
                        rows[i].CoverageAdded = DateFormat(rows[i].CoverageAdded);
                    }
                    if (rows[i].CoverageRemoved != null) {
                        rows[i].CoverageRemoved = DateFormat(rows[i].CoverageRemoved);
                    }
                }

                $('#jqxSearchGrid').jqxGrid('exportdata', 'xls', 'Grid Export', true, rows, false, null, 'utf-8');
            });

            $("#unSelectAll").on("click", function (event) {
                $("#LocationCombo").jqxDropDownList('uncheckAll');
            });

            $("#selectAll").on("click", function (event) {
                $("#LocationCombo").jqxDropDownList('checkAll');
            });

            $("#update").on("click", function (event) {
                saveChanges();
            });

            LoadLocation();
            LoadStatus();
            LoadCoverage();


            Security();
        });

        function LoadLocation() {
            var url = $("#localApiDomain").val() + "Vehicles/GetLocations/";
            //var url = "http://localhost:52839/api/Vehicles/GetLocations/";

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
                url: url
            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#LocationCombo").jqxDropDownList(
            {
                checkboxes: true,
                itemHeight: 50,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "NameOfLocation",
                valueMember: "LocationId",
                placeHolder: "Pick a Location"
            });
        }

        function LoadStatus() {
            var url = $("#localApiDomain").val() + "Vehicles/GetVehiclesStatusList";
            //var url = "http://localhost:52839/api/Vehicles/GetVehiclesStatusList";

            //set up the location combobox
            var locationSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'StatusDescription' },
                    { name: 'StatusId' }
                ],
                url: url
            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#StatusCombo").jqxDropDownList(
            {
                checkboxes: true,
                itemHeight: 50,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "StatusDescription",
                valueMember: "StatusId",
                placeHolder: "Pick a Status"
            });
        }

        function LoadCoverage() {
            var url = $("#localApiDomain").val() + "InsuranceVehicles/GetCoverageTypes/";
            //var url = "http://localhost:52839/api/InsuranceVehicles/GetCoverageTypes/";

            //set up the location combobox
            var locationSource =
            {
                datatype: "json",
                type: "Get",
                root: "data",
                datafields: [
                    { name: 'VehicleCoveragename' },
                    { name: 'VehicleCoverageId' }
                ],
                url: url
            };
            var locationDataAdapter = new $.jqx.dataAdapter(locationSource);
            $("#CoverageCombo").jqxDropDownList(
            {
                checkboxes: true,
                itemHeight: 50,
                source: locationDataAdapter,
                selectedIndex: 0,
                displayMember: "VehicleCoveragename",
                valueMember: "VehicleCoverageId",
                placeHolder: "Pick a Coverage"
            });
        }

        function loadSearchResults(params) {

            var parent = $("#jqxSearchGrid").parent();
            $("#jqxSearchGrid").jqxGrid('destroy');
            $("<div id='jqxSearchGrid'></div>").appendTo(parent);

            var coverageSource =
             {
                 datatype: "json",
                 datafields: [
                     { name: 'VehicleCoverageId' },
                     { name: 'VehicleCoveragename' }
                 ],
                 url: $("#localApiDomain").val() + "InsuranceVehicles/GetCoverageTypes/",
                 //url: "http://localhost:52839/api/InsuranceVehicles/GetCoverageTypes/"
             };

            var coverageAdapter = new $.jqx.dataAdapter(coverageSource, {
                autoBind: true
            });

            var insuranceValues = [
                { value: "1", label: "Active" },
                { value: "0", label: "In-Active" }
            ];

            var insuranceSource =
            {
                datatype: "array",
                datafields: [
                    { name: 'label', type: 'string' },
                    { name: 'value', type: 'string' }
                ],
                localdata: insuranceValues
            };

            var insuranceValuesAdapter = new $.jqx.dataAdapter(insuranceSource, {
                autoBind: true
            });

            

            var url = $("#localApiDomain").val() + "InsuranceVehicles/GetInsuranceVehicles/" + params;
            //var url = "http://localhost:52839/api/InsuranceVehicles/GetInsuranceVehicles/" + params;
            
            var source =
            {
                datafields: [
                    { name: 'VehicleId' },
                    { name: 'VehicleNumber', type: 'string' },
                    { name: 'StatusDescription' },
                    { name: 'Year' },
                    { name: 'MakeName' },
                    { name: 'ModelName' },
                    { name: 'VINNumber' },
                    { name: 'Garaged' },
                    { name: 'OriginalCost' },
                    { name: 'Class' },
                    { name: 'Coverage', value: 'CoverageCode', values: { source: coverageAdapter.records, value: 'VehicleCoverageId', name: 'VehicleCoveragename' } },
                    { name: 'CoverageCode' },
                    { name: 'DriverName' },
                    { name: 'AddDate', type: 'date' },
                    { name: 'DeleteDate', type: 'date' },
                    { name: 'Insurance', value: 'InsuranceCode', values: { source: insuranceValuesAdapter.records, value: 'value', name: 'label' } },
                    { name: 'InsuranceCode' },
                    { name: 'CoverageAdded' },
                    { name: 'CoverageRemoved' },
                    { name: 'State' }
                ],
                type: 'GET',
                datatype: "json",
                url: url
            };

            // create Searchlist Grid
            $("#jqxSearchGrid").jqxGrid(
            {
                width: '100%',
                autoheight: true,
                source: source,
                columnsresize: true,
                sortable: true,
                altrows: true,
                selectionmode: 'singlerow',
                editmode: 'selectedrow',
                editable: true,
                editmode: 'click',
                filterable: true,
                columnsheight: 40,
                columns: [
                      { text: 'VehicleId', datafield: 'VehicleId', hidden: true },
                      {
                          text: 'Vehicle Number', datafield: 'VehicleNumber', width: '7%',
                          renderer: function (defaultText, alignment, height) {
                            return '<div style="margin: 3px 0 0 3px;">Vehicle<br>Number</div>';
                          },
  			  cellbeginedit: function (row) {
       				return false;
  			  } 
                      },
                      {
                          text: 'StatusDescription', datafield: 'StatusDescription', width: '7%',
                          renderer: function (defaultText, alignment, height) {
                              return '<div style="margin: 3px 0 0 3px;">Status<br>Description</div>';
                          },
  			  cellbeginedit: function (row) {
       				return false;
  			  } 
                      },
                      { text: 'Year', datafield: 'Year', width: '3%',
  			cellbeginedit: function (row) {
       				return false;
  			} 
		      },
                      { text: 'Make', datafield: 'MakeName', width: '5%',
  			cellbeginedit: function (row) {
       				return false;
  			} 
		      },
                      { text: 'Model', datafield: 'ModelName', width: '5%',
  			cellbeginedit: function (row) {
       				return false;
  			} 
		      },
                      { text: 'VIN Number', datafield: 'VINNumber', width: '12%',
  			cellbeginedit: function (row) {
       				return false;
  			} 
		      },
                      { text: 'Garaged', datafield: 'Garaged', width: '11%',
  			cellbeginedit: function (row) {
       				return false;
  			} 
		      },
                      { text: 'OriginalCost', datafield: 'OriginalCost', width: '5%', cellsformat: 'c',
  			cellbeginedit: function (row) {
       				return false;
  			} 
		      },
                      { text: 'Class', datafield: 'Class', width: '5%',
  			cellbeginedit: function (row) {
       				return false;
  			} 
		      },
                      {
                          text: 'Coverage', datafield: 'CoverageCode', displayfield: 'Coverage', width: '5%', columntype: 'dropdownlist',
                          createeditor: function (row, value, editor) {
                              editor.jqxDropDownList({ source: coverageAdapter, displayMember: 'VehicleCoveragename', valueMember: 'VehicleCoverageId', autoDropDownHeight: true });
                          }
                      },
                      { text: 'DriverName', datafield: 'DriverName', hidden: true },
                      { text: 'Add Date', datafield: 'AddDate', width: '9%', cellsformat: 'MM/dd/yyyy',
  			cellbeginedit: function (row) {
       				return false;
  			} 
		      },
                      { text: 'Delete Date', datafield: 'DeleteDate', width: '6%', cellsformat: 'MM/dd/yyyy',
  			cellbeginedit: function (row) {
       				return false;
  			} 
		      },
                      {
                          text: 'Insurance', datafield: 'InsuranceCode', displayfield: 'Insurance', width: '5%', columntype: 'dropdownlist',
                          createeditor: function (row, value, editor) {
                              editor.jqxDropDownList({ source: insuranceValuesAdapter, displayMember: 'label', valueMember: 'value', autoDropDownHeight: true });
                          }
                      },
                      {
                          text: 'Coverage Added', datafield: 'CoverageAdded', width: '6%', cellsrenderer: DateRender, columntype: 'datetimeinput', cellsformat: 'MM/dd/yyyy',
                          validation: function (cell, value) {
                              if (value == "")
                                  return true;
                              //var year = value.getFullYear();
                              //if (year >= 2020) {
                              //    return { result: false, message: "Date should be before 1/1/2020" };
                              //}
                              return true;
                          },
                          renderer: function (defaultText, alignment, height) {
                              return '<div style="margin: 3px 0 0 3px;">Coverage<br>Added</div>';
                          }
                      },
                      {
                          text: 'Coverage Removed', datafield: 'CoverageRemoved', width: '6%', cellsrenderer: DateRender, columntype: 'datetimeinput', cellsformat: 'MM/dd/yyyy',
                          validation: function (cell, value) {
                              if (value == "")
                                  return true;
                              //var year = value.getFullYear();
                              //if (year >= 2020) {
                              //    return { result: false, message: "Date should be before 1/1/2020" };
                              //}
                              return true;
                          },
                          renderer: function (defaultText, alignment, height) {
                              return '<div style="margin: 3px 0 0 3px;">Coverage<br>Removed</div>';
                          }
                      },
                      { text: 'State', datafield: 'State', width: '3%' }
                ]
            });

            $("#jqxSearchGrid").on('cellvaluechanged', function (event) {
                // event arguments.
                var args = event.args;
                // column data field.
                var datafield = event.args.datafield;
                // row's bound index.
                var rowBoundIndex = args.rowindex;
                // new cell value.
                var value = args.newvalue;
                // old cell value.
                var oldvalue = args.oldvalue;


                var arrayLength = updateRows.length;

                if (updateRows.length == 0) {
                    updateRows.push(rowBoundIndex);
                } else {
                    for (var i = 0; i < arrayLength; i++) {
                        if (updateRows.indexOf(rowBoundIndex) == -1) {
                            updateRows.push(rowBoundIndex);
                        }
                    }
                }
            });

        }

        function saveChanges() {

            for (var i = 0; i < updateRows.length; i++) {
                var data = $('#jqxSearchGrid').jqxGrid('getrowdatabyid', updateRows[i]);

                if (data["CoverageAdded"] == "0001-01-01T00:00:00" || data["CoverageAdded"] == null)
                {
                    var thisCoverageAddedDate = null;
                } else {
                    var thisCoverageAddedDate = DateFormat(data["CoverageAdded"]);
                }

                if (data["CoverageRemoved"] == "0001-01-01T00:00:00" || data["CoverageRemoved"] == null) {
                    var thisCoverageRemovedDate = null;
                } else {
                    var thisCoverageRemovedDate = DateFormat(data["CoverageRemoved"]);
                }

                //var url = "http://localhost:52839/api/InsuranceVehicles/UpdateInsuranceVehicleStatus/";
                var url = $("#localApiDomain").val() + "InsuranceVehicles/UpdateInsuranceVehicleStatus/";

                var postData = { 'VehicleId': data["VehicleId"], 'Coverage': data["CoverageCode"], 'Insurance': data["InsuranceCode"], 'CoverageAdded': thisCoverageAddedDate, 'CoverageRemoved': thisCoverageRemovedDate }

                postInsuranceChange(url, postData).done(function (data) {
                    console.log();
                }).fail(function (error) {
                    alert("error " + error);
                });
            }

            loadSearchResults(gblCheckedLocations + '~' + gblCheckedStatus + '~' + gblCheckedCoverage);
        }

        function postInsuranceChange(url, postData) {

            return $.ajax({
                async: true,
                type: "POST",
                data: postData,
                url: url,
                dataType: "json",
                success: function (data) {

                },
                error: function (request, status, error) {
                    alert(error);
                }
            });
        }

    </script>
    <div id="MemberSearch" class="container-fluid container-970 wrap-search-options">
        <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;">
            <div class="row search-size">
                <div class="row">
                    <div class="col-sm-3">
                        <input type="button"  id="export" value="Export" /><br /><input type="button"  id="update" value="Update" />
                    </div>
                    <div class="col-sm-3">
                        <div id="LocationCombo"></div><div id="StatusCombo"></div><div id="CoverageCombo"></div>
                    </div>
                    <div class="col-sm-3">
                        <input type="button"  id="selectAll" value="Select All Locations" /><br /><input type="button"  id="unSelectAll" value="Un-Select All Locations" />
                    </div>  
                    <div class="col-sm-3">
                        <input type="button" id="btnSearch" value="Search" />
                    </div> 
                </div>
            </div>
        </div>
    </div>

    <div class="container-fluid container-970">
        <div class="row ">
            <div class="col-sm-12">
                <div id="jqxSearchGrid"></div>
            </div>
        </div>
    </div>
</asp:Content>
