function PrintWorkOrder () {
    var gridContent = $("#partsGrid").jqxGrid('exportdata', 'html');
    gridContent = gridContent.replace(/undefined/g, "");
    gridContent = gridContent.replace("<table", "<table id='partTable'");
    gridContent = gridContent.replace(/&nbsp;/g, "$0.00");
    var newWindow = window.open('', '', 'width=' + screen.width + ',height=' + screen.height),
    document = newWindow.document.open(),
    pageContent =
        '<html xmlns="http://www.w3.org/1999/xhtml"> ' +
        '<head> ' +
	    '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> ' +
	    '<title>Work Order</title> ' +
	    '<link rel="stylesheet" type="text/css" href="CSSReport/css/style.css" /> ' +
	    '<link rel="stylesheet" type="text/css" href="CSSReport/css/print.css" media="print" /> ' +
	    '<script type="text/javascript" src="CSSReport/js/jquery-1.3.2.min.js"></script> ' +
	    '<script type="text/javascript" src="CSSReport/js/example.js"></script> ' +
        '<script type="text/javascript" src="scripts/common.js"></script> ' +
        '<script type="text/javascript"> ' +
        '$(document).ready(function () { ' +
        '$("#txtWorkOrder").val("' + $("#txtWorkOrder").val() + '"); ' +
        '$("#txtMechanic").val("' + $("#mechanicCombo").jqxDropDownList('getSelectedItem').label + '"); ' +
        '$("#txtYear").val("' + $("#txtYear").val() + '"); ' +
        '$("#txtMake").val("' + $("#txtMake").val() + '"); ' +
        '$("#txtModel").val("' + $("#txtModel").val() + '"); ' +
        '$("#txtBusNumber").val("' + $("#txtBusNumber").val() + '"); ' +
        '$("#txtMileage").val("' + $("#txtMileage").val() + '"); ' +
        '$("#txtDate").val("' + DateFormat($('#workOrderDate').jqxDateTimeInput('getDate')) + '"); ' +
        '$("#txtVin").val("' + $("#txtVINNumber").val() + '"); ' +
        '$("#txtComplaint").val("' + $("#complaint").val().replace(/"/g, '"').replace(/"/g, '\\"') + '"); ' +
        '$("#txtResolution").val("' + $("#resolution").val().replace(/"/g, '"').replace(/"/g, '\\"') + '"); ' +
        '$("#txtHours").val("' + $("#txtHours").val() + '"); ' +
        '}); ' +
        'function PrintWorkOrder () { ' +
        'window.print(); ' +
        '} ' +
        '</script> ' +
        '<style> ' +
        'table.VehicleInfo td{ ' +
        'border-width: 0px; ' +
        '} ' +
        'input { ' +
        'border: none; ' +
        'background: transparent; ' +
        '} ' +
        '</style> ' +
        '</head> ' +
        '<body> ' +
        '<div id="page-wrap"> ' +
        '<table class="VehicleInfo" style="width:100%"> ' +
        '<tr>  ' +
        '<td align="center" style="background-color:black"> ' +
        '<h2><a style="color:white" onclick="PrintWorkOrder()">Work Order</a></h2> ' +
        '</td> ' +
        '</tr> ' +
        '</table> ' +
        '<table class="VehicleInfo"> ' +
        '<tr>  ' +
        '<td> ' +
        '<label for="txtWorkOrder">Work Order #:</label> ' +
        '<input id="txtWorkOrder" type="text" /> ' +
        '</td> ' +
        '<td> ' +
        '<label for="txtMechanic">Mechanic:</label> ' +
        '<input id="txtMechanic" type="text" /> ' +
        '</td> ' +
        '<td> ' +
        '</td> ' +
        '<td> ' +
        '</td> ' +
        '</tr> ' +
        '<tr>  ' +
        '<td> ' +
        '<label for="txtYear">Year:</label> ' +
        '<input id="txtYear" type="text" /> ' +
        '</td> ' +
        '<td> ' +
        '<label for="txtMake">Make:</label> ' +
        '<input id="txtMake" type="text" /> ' +
        '</td> ' +
        '<td> ' +
        '<label for="txtModel">Model:</label> ' +
        '<input id="txtModel" type="text" /> ' +
        '</td> ' +
        '<td> ' +
        '<label for="txtBusNumber">Bus Number:</label> ' +
        '<input id="txtBusNumber" type="text" /> ' +
        '</td> ' +
        '</tr> ' +
        '<tr>  ' +
        '<td> ' +
        '<label for="txtMileage">Mileage:</label> ' +
        '<input id="txtMileage" type="text" /> ' +
        '</td> ' +
        '<td> ' +
        '<label for="txtHours">Hours:</label> ' +
        '<input id="txtHours" type="text" /> ' +
        '</td> ' +
        '<td> ' +
        '<label for="txtDate">Date:</label> ' +
        '<input id="txtDate" type="text" /> ' +
        '</td> ' +
        '<td> ' +
        '<label for="txtVin">VIN:</label> ' +
        '<input id="txtVin" type="text" /> ' +
        '</td> ' +
        '</tr> ' +
        '<tr>  ' +
        '<td colspan="2"> ' +
        '<label for="txtComplaint">Complaint:</label> ' +
        '<textarea id="txtComplaint" rows="4" style="width:100%"></textarea> ' +
        '</td> ' +
        '<td colspan="2"> ' +
        '<label for="txtResolution">Resolution:</label> ' +
        '<textarea id="txtResolution" rows="4" style="width:100%"></textarea> ' +
        '</td> ' +
        '</tr> ' +
        '</table> ' +
        '<table id="items"> ' +
        '<tr class="item-row"> ' +
        gridContent +
        '</tr> ' +
        '</table> ' +
        '<col width="130"> ' +
        '<col width="80"> ' +
        '<col width="80"> ' +
        '<col width="80"> ' +
        '<col width="80"> ' +
        '<col width="80"> ' +
        '<col width="80"> ' +
        '<col width="50"> ' +
        '<col width="50"> ' +
        '<col width="50"> ' +
        '<col width="50"> ' +
        '<table class="VehicleInfo" style="width:100%"><tr><td style="width:116"></td><td style="width:66"></td><td style="width:57"></td><td style="width:50"></td><td style="width:78"></td><td style="width:62"></td><td style="width:73"></td> ' +
        '<td style="width:50;font: 13px/1.4 normal;"> ' +
        '$' + $("#partsGrid").jqxGrid('getcolumnaggregateddata', 'PartCost', ['sum']).sum.toFixed(2) +
        '</td> ' +
        '<td style="width:43;font: 13px/1.4 normal;"> ' +
        '$' + $("#partsGrid").jqxGrid('getcolumnaggregateddata', 'Labor', ['sum']).sum.toFixed(2) +
        '</td> ' +
        '<td style="width:45;font: 13px/1.4 normal;"> ' +
        '$' + $("#partsGrid").jqxGrid('getcolumnaggregateddata', 'Tax', ['sum']).sum.toFixed(2) +
        '</td> ' +
        '<td style="width:45;font: 13px/1.4 normal;"> ' +
        '$' + $("#partsGrid").jqxGrid('getcolumnaggregateddata', 'Total', ['sum']).sum.toFixed(2) +
        '</td> ' +
        '</tr> ' +
        '</table> ' +
        '<div id="terms"> ' +
        '<h5>Notes</h5> ' +
        '<textarea>Place any extra notes for the work order here.</textarea> ' +
        '</div> ' +
        '</div> ' +
        '</body> ' +
        '</html>';
    document.write(pageContent);
    document.close();
};