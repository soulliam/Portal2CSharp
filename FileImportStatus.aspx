<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="FileImportStatus.aspx.cs" Inherits="FileStatus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    
    <script type="text/javascript">
        var group = '<%= Session["groupList"] %>';

        $(document).ready(function () {
            var today = new Date();
            var today = (today.getMonth() + 1) + '/' + today.getDate() + '/' + today.getFullYear();
            $("#time").text(today);

            Security();
        });
        
    </script>

    <table style="background-color:white;">
        <tr>
            <td class="formlabels" colspan="4" style="text-align:center;"><div style="width:60%;margin:0px auto;">Today's Date: <span id="time"></span></div></td>
        </tr>
        <tr>
            <td class="formlabels" colspan="4" style="text-align:center;"><div style="width:60%;margin:0px auto;">Location files last imported (*If files transferred, then will be 1 day prior to Today's Date. Files don't normally finish importing until around 10am, although can take a little longer depending on the amount of information being imported*)</div></td>
        </tr>
        <tr>
            <td colspan="4"><hr /></td>
        </tr>
        <tr>
            <td class="formlabels" style="text-align:left;">ABQ :</td>
            <td class="formlabels" style="text-align:left;"><asp:Label runat="server" ID="ABQLast"></asp:Label></td>
            <td class="formLabels" style="text-align:left;">AUS :</td>
            <td class="formlabels" style="text-align:left;"><asp:Label runat="server" ID="AUSLast"></asp:Label></td>
        </tr>
        <tr>
            <td class="formlabels" style="text-align:left;">ATL:</td>
            <td class="formlabels" style="text-align:left;"><asp:Label runat="server" ID="ATLLast"></asp:Label></td>
            <td class="formlabels" style="text-align:left;">BWI FPR :</td>
            <td class="formlabels" style="text-align:left;"><asp:Label runat="server" ID="BWI2Last"></asp:Label></td>=
        </tr>
        <tr>
            <td class="formLabels" style="text-align:left;">BWI FP2 :</td>
            <td class="formlabels" style="text-align:left;"><asp:Label runat="server" ID="BWI1Last"></asp:Label></td>
            <td class="formLabels" style="text-align:left;">CHI MDW :</td>
            <td class="formlabels" style="text-align:left;"><asp:Label runat="server" ID="MDWLast"></asp:Label></td>
        </tr>
        <tr>
            <td class="formLabels" style="text-align:left;">CVG FPR :</td>
            <td class="formlabels" style="text-align:left;"><asp:Label runat="server" ID="CVG2Last"></asp:Label></td>
            <td class="formlabels" style="text-align:left;">CLE AFP :</td>
            <td class="formlabels" style="text-align:left;"><asp:Label runat="server" ID="CLEAFPLast"></asp:Label></td>
        </tr>
        <tr>
            <td class="formLabels" style="text-align:left;">CLE PP :</td>
            <td class="formlabels" style="text-align:left;"><asp:Label runat="server" ID="CLEPPLast"></asp:Label></td>
            <td class="formLabels" style="text-align:left;">HOU :</td>
            <td class="formlabels" style="text-align:left;"><asp:Label runat="server" ID="HOULast"></asp:Label></td>
        </tr>
        <tr>
            <td class="formlabels" style="text-align:left;">HWC :</td>
            <td class="formlabels" style="text-align:left;"><asp:Label runat="server" ID="HWCLast"></asp:Label></td>
            <td class="formLabels" style="text-align:left;">IND :</td>
            <td class="formlabels" style="text-align:left;"><asp:Label runat="server" ID="INDLast"></asp:Label></td>
        </tr>
        <tr>
            <td class="formlabels" style="text-align:left;">MCO :</td>
            <td class="formlabels" style="text-align:left;"><asp:Label runat="server" ID="MCOLast"></asp:Label></td>
            <td class="formLabels" style="text-align:left;">MEM :</td>
            <td class="formlabels" style="text-align:left;"><asp:Label runat="server" ID="MEMLast"></asp:Label></td>
        </tr>
        <tr><td class="formLabels" style="text-align:left;">MKE :</td>
            <td class="formlabels" style="text-align:left;"><asp:Label runat="server" ID="MKELast"></asp:Label></td>
            <td class="formlabels" style="text-align:left;">RDU :</td>
            <td class="formlabels" style="text-align:left;"><asp:Label runat="server" ID="RDULast"></asp:Label></td>
        </tr>
        <tr>
            <td class="formLabels" style="text-align:left;">TUC :</td>
            <td class="formlabels" style="text-align:left;"><asp:Label runat="server" ID="TUCLast"></asp:Label></td>
            <td></td>
            <td></td>
        </tr>
    </table>
</asp:Content>

