<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ForTestHTML.aspx.cs" Inherits="ForTestHTML" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
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
