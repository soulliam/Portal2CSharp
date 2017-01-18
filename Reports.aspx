<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Reports.aspx.cs" Inherits="Reports" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:DropDownList ID="ddlReports" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlReports_SelectedIndexChanged"></asp:DropDownList>
        <a href="MemberSearch.aspx" style="float:right;">Return to Portal</a>
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Height="632px" Width="1100px" AsyncRendering="False" Font-Names="Verdana" Font-Size="8pt" ProcessingMode="Remote" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt">
            <ServerReport ReportPath="/NewManager/General/ManagerAudit" ReportServerUrl="http://192.168.0.90:80/ReportServer" />
        </rsweb:ReportViewer>
    </div>
    </form>
</body>
</html>
