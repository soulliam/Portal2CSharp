<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ForTestHTML.aspx.cs" Inherits="ForTestHTML" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        var data = generatedata(500);
        var source =
        {
            localdata: data,
            datafields:
            [
                { name: 'available', type: 'bool' },
                { name: 'date', type: 'date' },
                { name: 'range', map: 'date', type: 'date' },

            ],
            datatype: "array"
        };
        var addDefaultfilter = function () {
            var datefiltergroup = new $.jqx.filter();
            var operator = 0;
            var today = new Date();

            var weekago = new Date();

            weekago.setDate((today.getDate() - 10));

            var filtervalue = weekago;
            var filtercondition = 'GREATER_THAN_OR_EQUAL';
            var filter4 = datefiltergroup.createfilter('datefilter', filtervalue, filtercondition);

            filtervalue = today;
            filtercondition = 'LESS_THAN_OR_EQUAL';
            var filter5 = datefiltergroup.createfilter('datefilter', filtervalue, filtercondition);

            datefiltergroup.addfilter(operator, filter4);
            datefiltergroup.addfilter(operator, filter5);

            //$("#jqxProgress").jqxGrid('addfilter', 'Status', statusfiltergroup);
            $("#jqxgrid").jqxGrid('addfilter', 'range', datefiltergroup);
            $("#jqxgrid").jqxGrid('applyfilters');
        }
        var dataAdapter = new $.jqx.dataAdapter(source);
        $("#jqxgrid").jqxGrid(
        {
            width: 850,
            source: dataAdapter,
            showfilterrow: true,
            filterable: true,
            selectionmode: 'multiplecellsextended',
            ready: function () {
                addDefaultfilter();
            },
            columns: [
              { text: 'Range', datafield: 'range', filtertype: 'range', cellsalign: 'right', width: '35%', cellsformat: 'd' }
            ]
        });
        $('#clearfilteringbutton').jqxButton({ height: 25 });
        $('#clearfilteringbutton').click(function () {
            $("#jqxgrid").jqxGrid('clearfilters');
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
                 <table>
                    <tr>
                        <td colspan="4">
                            <div id="jqxFeatureGrid"></div>
                        </td>
                    </tr>
                     <tr>
                        <td colspan="4">
                            
                        </td>
                    </tr>
                      <tr>
                        <td colspan="4">
                            <div id="featureCombo"></div>
                        </td>
                    </tr>
                     <tr>
                        <td colspan="4">
                           
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Sort Order:
                        </td>
                        <td>
                            <input type="text" id="FeatureSortOrder" />
                        </td>
                        <td>
                            Charge Amount:
                        </td>
                        <td>
                            <input type="text" id="FeatureChargeAmount" />
                        </td>
                    </tr>
                     <tr>
                        <td>
                            Charge Note:
                        </td>
                        <td>
                            <input type="text" id="FeatureChargeNote" />
                        </td>
                        <td>
                            Effective Date:
                        </td>
                        <td>
                            <input type="text" id="FeatureEffectiveDate" />
                        </td>
                    </tr>
                     <tr>
                        <td>
                            Optional Extras Name:
                        </td>
                        <td>
                            <input type="text" id="FeatureOptionalExtrasName" />
                        </td>
                        <td>
                            Optional Extras Description:
                        </td>
                        <td>
                            <input type="text" id="FeatureOptionalExtrasDescription" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Max Available:
                        </td>
                        <td>
                            <input type="text" id="MaxAvailable" />
                        </td>
                        <td>
                            Date Available:
                        </td>
                        <td>
                            <input type="text" id="FeatureAvailableDatetime" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Reservation Text?:
                        </td>
                        <td>
                            <input id="AddToReservationText" type="checkbox" />
                        </td>
                        <td>
                            Display?:
                        </td>
                        <td>
                            <input type="checkbox" id="IsDisplayed" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input id="addFeature" type="button" value="Add" />
                        </td>
                        <td colspan="2" align="right">
                            <input id="cancelFeature" type="button" value="Cancel" />
                        </td>
                    </tr>
                </table>
            </div>
    </form>
</body>
</html>
