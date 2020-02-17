<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceWCModfiedDuty.aspx.cs" Inherits="InsuranceWCModfiedDuty" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <link rel="stylesheet" href="jqwidgets/styles/jqx.base.css" type="text/css" />
    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>

    <script type="text/javascript" src="jqwidgets/globalization/globalize.js"></script>

    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxgrid.edit.js"></script>    
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
    <script type="text/javascript" src="jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>    
    <script type="text/javascript" src="jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxdata.export.js"></script> 
    <script type="text/javascript" src="jqwidgets/jqxgrid.export.js"></script>

    <script>
        $(document).ready(function () {
            $("#RestrictedDutyFirstDay").jqxDateTimeInput({ width: '175px', height: '25px', formatString: 'd' });
            $("#RestrictedDutyLastDay").jqxDateTimeInput({ width: '175px', height: '25px', formatString: 'd' });
            $("#RestrictedDutyFollowUpFirstDay").jqxDateTimeInput({ width: '175px', height: '25px', formatString: 'd' });
            $("#RestrictedDutyFollowUpLastDay").jqxDateTimeInput({ width: '175px', height: '25px', formatString: 'd' });

            loadLocations();
        });

        function loadLocations() {
            var locationString = $("#userVehicleLocation").val();
            var dropdown = $('#location');

            dropdown.empty();

            dropdown.append('<option selected="true">Location</option>');
            dropdown.prop('selectedIndex', 0);

            //var url = "http://localhost:52839/api/InsuranceLocations/GetUserLocations/" + locationString;
            var url = $("#localApiDomain").val() + "InsuranceLocations/GetUserLocations/" + locationString;

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                beforeSend: function (jqXHR, settings) {
                },
                success: function (data) {
                    for (i = 0; i < data.length; i++) {
                        dropdown.append($("<option style='font-weight: bold;'></option>").attr("value", data[i].LocationId).text(data[i].LocationName));
                    }
                },
                error: function (request, status, error) {
                    swal("There was an issue getting location information.");
                }
            });
        }
    </script>
    <style>
        .xl1515414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl6715414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl6815414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:white;
	        font-size:11.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        background:black;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl6915414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        border:1.0pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7015414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:general;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:.5pt solid windowtext;
	        border-bottom:none;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7115414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7215414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border-top:none;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7315414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        border:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7415414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7515414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7615414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7715414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:none;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7815414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:none;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl7915414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        border-top:none;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8015414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:.5pt solid windowtext;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8115414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:12.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border-top:1.0pt solid windowtext;
	        border-right:none;
	        border-bottom:none;
	        border-left:1.0pt solid windowtext;
	        background:#92D050;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8215414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:12.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border-top:1.0pt solid windowtext;
	        border-right:none;
	        border-bottom:none;
	        border-left:none;
	        background:#92D050;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8315414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:12.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border-top:1.0pt solid windowtext;
	        border-right:1.0pt solid windowtext;
	        border-bottom:none;
	        border-left:none;
	        background:#92D050;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8415414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:12.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border-top:none;
	        border-right:none;
	        border-bottom:1.0pt solid windowtext;
	        border-left:1.0pt solid windowtext;
	        background:#92D050;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8515414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:12.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border-top:none;
	        border-right:none;
	        border-bottom:1.0pt solid windowtext;
	        border-left:none;
	        background:#92D050;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8615414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:12.0pt;
	        font-weight:700;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:center;
	        vertical-align:bottom;
	        border-top:none;
	        border-right:1.0pt solid windowtext;
	        border-bottom:1.0pt solid windowtext;
	        border-left:none;
	        background:#92D050;
	        mso-pattern:black none;
	        white-space:nowrap;}
        .xl8715414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:bottom;
	        border-top:.5pt solid windowtext;
	        border-right:.5pt solid windowtext;
	        border-bottom:none;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:nowrap;}
        .xl8815414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:top;
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:none;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl8915414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:top;
	        border-top:.5pt solid windowtext;
	        border-right:none;
	        border-bottom:none;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl9015414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:top;
	        border-top:.5pt solid windowtext;
	        border-right:.5pt solid windowtext;
	        border-bottom:none;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl9115414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:top;
	        border-top:none;
	        border-right:none;
	        border-bottom:none;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl9215414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:top;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl9315414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:top;
	        border-top:none;
	        border-right:.5pt solid windowtext;
	        border-bottom:none;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl9415414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:top;
	        border-top:none;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:.5pt solid windowtext;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl9515414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:top;
	        border-top:none;
	        border-right:none;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}
        .xl9615414
	        {padding-top:1px;
	        padding-right:1px;
	        padding-left:1px;
	        mso-ignore:padding;
	        color:black;
	        font-size:11.0pt;
	        font-weight:400;
	        font-style:normal;
	        text-decoration:none;
	        font-family:Calibri, sans-serif;
	        mso-font-charset:0;
	        mso-number-format:General;
	        text-align:left;
	        vertical-align:top;
	        border-top:none;
	        border-right:.5pt solid windowtext;
	        border-bottom:.5pt solid windowtext;
	        border-left:none;
	        mso-background-source:auto;
	        mso-pattern:auto;
	        white-space:normal;}

        .auto-style2 {
            height: 56px;
        }
        .auto-style3 {
            height: 55px;
        }

    </style>
        
        <div align=center>

        <table border=0 cellpadding=0 cellspacing=0 width=793 style='border-collapse:
         collapse;table-layout:fixed;width:597pt'>
         <col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>
         <col width=191 style='mso-width-source:userset;mso-width-alt:6985;width:143pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=177 style='mso-width-source:userset;mso-width-alt:6473;width:133pt'>
         <col width=17 style='mso-width-source:userset;mso-width-alt:621;width:13pt'>
         <col width=161 style='mso-width-source:userset;mso-width-alt:5888;width:121pt'>
         <col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1515414 width=18 style='height:15.75pt;width:14pt'><a
          name="RANGE!A1:I48"></a><a name="RANGE!A1"></a></td>
          <td class=xl1515414 width=191 style='width:143pt'></td>
          <td class=xl1515414 width=17 style='width:13pt'></td>
          <td class=xl1515414 width=177 style='width:133pt'></td>
          <td class=xl1515414 width=17 style='width:13pt'></td>
          <td class=xl1515414 width=177 style='width:133pt'></td>
          <td class=xl1515414 width=17 style='width:13pt'></td>
          <td class=xl1515414 width=161 style='width:121pt'></td>
          <td class=xl1515414 width=18 style='width:14pt'></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td colspan=7 class=xl8115414 style='border-right:1.0pt solid black'>PARKING
          COMPANY OF AMERICA, INC.<span style='mso-spacerun:yes'> </span></td>
          <td class=xl6715414></td>
         </tr>
         <tr height=22 style='height:16.5pt'>
          <td height=22 class=xl1515414 style='height:16.5pt'></td>
          <td colspan=7 class=xl8415414 style='border-right:1.0pt solid black'>WORKERS'
          COMPENSATION MODIFIED DUTY SCHEDULE</td>
          <td class=xl6715414></td>
         </tr>
         <tr height=21 style='height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl6715414>PCA WC #</td>
          <td class=xl1515414></td>
          <td class=xl6915414>
              <input id="WCNumber" type="text" style="border:none" /></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl6715414>COMPANION PCA INCIDENT #</td>
          <td class=xl1515414></td>
          <td class=xl6915414 style='border-top:none'>
              <input id="IncidentNumber" type="text" style="border:none" /></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl6715414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl6715414>LOCATION</td>
          <td class=xl1515414></td>
          <td class=xl7015414><select id="location" style="border:none"></select></td>
          <td class=xl1515414></td>
          <td class=xl6715414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414>Employee Name</td>
          <td class=xl1515414></td>
          <td colspan=5 class=xl7515414 style='border-right:.5pt solid black'>
              <input id="EmployeeName" type="text" style="border:none" /></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414>Regular Duties</td>
          <td class=xl1515414></td>
          <td colspan=5 rowspan=3 class=xl8815414 width=549 style='border-right:.5pt solid black;
          border-bottom:.5pt solid black;width:413pt'>
              <textarea id="RegularDuties" class="auto-style2" cols="20" name="S1" style="border:none"></textarea></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414>Regular Department</td>
          <td class=xl1515414></td>
          <td colspan=5 class=xl7515414 style='border-right:.5pt solid black'>
              <input id="RegularDepartment" type="text" style="border:none" /></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414>Regular Work Days</td>
          <td class=xl1515414></td>
          <td colspan=5 class=xl7515414 style='border-right:.5pt solid black'>
            <div>
            <input type="checkbox" id="regWorkDayMonday" value="Monday" style="width:20px">Monday
            <input type="checkbox" id="regWorkDayTuesday" value="Tuesday" style="width:20px">Tuesday
            <input type="checkbox" id="regWorkDayWednesday" value="Wednesday" style="width:20px">Wednesday
            <input type="checkbox" id="regWorkDayThursday" value="Thursday" style="width:20px">Thursday
            <input type="checkbox" id="regWorkDayFriday" value="Friday" style="width:20px">Friday
            <input type="checkbox" id="regWorkDaySaturday" value="Saturday" style="width:20px">Saturday
            <input type="checkbox" id="regWorkDaySunday" value="Sunday" style="width:20px">Sunday
            </div>
          </td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414>Regular Shift</td>
          <td class=xl1515414></td>
          <td colspan=5 class=xl7515414 style='border-right:.5pt solid black'>
              <input id="RegularShift" type="text" style="border:none" /></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414>Regular Supervisor</td>
          <td class=xl1515414></td>
          <td colspan=5 class=xl7515414 style='border-right:.5pt solid black'>
              <input id="RegularSupervisor" type="text" style="border:none" /></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414>Restricted Duties</td>
          <td class=xl1515414></td>
          <td colspan=5 rowspan=3 class=xl8815414 width=549 style='border-right:.5pt solid black;
          border-bottom:.5pt solid black;width:413pt'>
              <textarea id="RestrictedDuties" class="auto-style3" cols="20" name="S2" style="border:none"></textarea></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414>Dates of Restricted Duties</td>
          <td class=xl1515414></td>
          <td class=xl7315414 style='border-top:none'>
            <div id="RestrictedDutyFirstDay" style="border:none"></div>    
          </td>
          <td class=xl7115414>-</td>
          <td class=xl7315414 style='border-top:none'>
              <div id="RestrictedDutyLastDay" style="border:none"></div>
          </td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl7415414>First Day Restricted Duties</td>
          <td class=xl7415414></td>
          <td class=xl7415414>Last Day Restricted Duties</td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414 colspan=2>Follow-up Dates Restricted Dutie<span
          style='display:none'>s</span></td>
          <td class=xl7315414>
            <div id="RestrictedDutyFollowUpFirstDay" style="border:none"></div>    
          </td>
          <td class=xl7115414>-</td>
          <td class=xl7315414>
            <div id="RestrictedDutyFollowUpLastDay" style="border:none"></div>    
          </td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl7415414>First Day Restricted Duties</td>
          <td class=xl7415414></td>
          <td class=xl7415414>Last Day Restricted Duties</td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414>Temporary Duties</td>
          <td class=xl1515414></td>
          <td colspan=5 rowspan=3 class=xl8815414 width=549 style='border-right:.5pt solid black;
          border-bottom:.5pt solid black;width:413pt'>
              <textarea id="TempDuties" class="auto-style2" cols="20" name="S3" style="border:none"></textarea></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414>Temporary Department</td>
          <td class=xl1515414></td>
          <td colspan=5 class=xl7515414 style='border-right:.5pt solid black'>
              <input id="TempDepartment" type="text" style="border:none" /></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414>Temporary Work Days</td>
          <td class=xl1515414></td>
          <td colspan=5 class=xl7515414 style='border-right:.5pt solid black'>
             <div>
            <input type="checkbox" id="tempWorkDayMonday" value="Monday" style="width:20px">Monday
            <input type="checkbox" id="tempWorkDayTuesday" value="Tuesday" style="width:20px">Tuesday
            <input type="checkbox" id="tempWorkDayWednesday" value="Wednesday" style="width:20px">Wednesday
            <input type="checkbox" id="tempWorkDayThursday" value="Thursday" style="width:20px">Thursday
            <input type="checkbox" id="tempWorkDayFriday" value="Friday" style="width:20px">Friday
            <input type="checkbox" id="tempWorkDaySaturday" value="Saturday" style="width:20px">Saturday
            <input type="checkbox" id="tempWorkDaySunday" value="Sunday" style="width:20px">Sunday
            </div>
          </td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414>Temporary Shift</td>
          <td class=xl1515414></td>
          <td colspan=5 class=xl7715414 style='border-right:.5pt solid black'>
              <input id="TempShift" type="text" style="border:none" /></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414>Temporary Supervisor</td>
          <td class=xl1515414></td>
          <td colspan=5 class=xl7315414>
              <input id="TempSupervisor" type="text" style="border:none" /></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515414 style='height:15.0pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515414 style='height:15.0pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl7415414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414>Additional Comments</td>
          <td class=xl1515414></td>
          <td colspan=5 rowspan=3 class=xl8815414 width=549 style='border-right:.5pt solid black;
          border-bottom:.5pt solid black;width:413pt'>
              <textarea id="AdditioinalComments" class="auto-style2" cols="20" name="S4" style="border:none"></textarea></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=21 style='mso-height-source:userset;height:15.75pt'>
          <td height=21 class=xl1515414 style='height:15.75pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515414 style='height:15.0pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515414 style='height:15.0pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515414 style='height:15.0pt'></td>
          <td colspan=3 class=xl7915414>
              <input id="EployeeSignature" type="text" style="border:none" /></td>
          <td class=xl7115414></td>
          <td class=xl7215414>
              <input id="EployeeSignatureDate" type="text" style="border:none" /></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515414 style='height:15.0pt'></td>
          <td class=xl1515414>Employee's Signature</td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414>Date</td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515414 style='height:15.0pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515414 style='height:15.0pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515414 style='height:15.0pt'></td>
          <td colspan=3 class=xl7915414>
              <input id="SupervisorSignature" type="text" style="border:none" /></td>
          <td class=xl7115414></td>
          <td class=xl7215414>
              <input id="SupervisorSignatureDate" type="text" style="border:none" /></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515414 style='height:15.0pt'></td>
          <td class=xl1515414>Supervisor's Signature</td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414>Date</td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515414 style='height:15.0pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515414 style='height:15.0pt'></td>
          <td class=xl6815414>SAVE &amp; SUBMIT</td>
          <td class=xl1515414></td>
          <td class=xl6815414>PRINT</td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <tr height=20 style='height:15.0pt'>
          <td height=20 class=xl1515414 style='height:15.0pt'></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
          <td class=xl1515414></td>
         </tr>
         <![if supportMisalignedColumns]>
         <tr height=0 style='display:none'>
          <td width=18 style='width:14pt'></td>
          <td width=191 style='width:143pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=177 style='width:133pt'></td>
          <td width=17 style='width:13pt'></td>
          <td width=161 style='width:121pt'></td>
          <td width=18 style='width:14pt'></td>
         </tr>
         <![endif]>
        </table>

        </div>
</asp:Content>


