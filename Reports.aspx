<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Reports.aspx.cs" Inherits="Reports" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="scripts/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="scripts/bootstrap.min.js"></script>
    <script type="text/javascript" src="scripts/common.js"></script>

    <link rel="stylesheet" href="jqwidgets/styles/jqx.base.css" type="text/css" />
    <script type="text/javascript" src="scripts/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxtree.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxsplitter.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxpanel.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxexpander.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxscrollbar.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $("#mainSplitter").jqxSplitter({ width: '100%', height: 750, panels: [{ size: 350 }] });
        });
    </script>

</head>
<body>
    
    <form id="form1" runat="server">
        <div id="mainSplitter"  style="width:800px; height: 800px; background-color: #FFFFAF">
            <div>
                <%--<asp:DropDownList ID="ddlReports" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlReports_SelectedIndexChanged"></asp:DropDownList>--%>
                <asp:TreeView ID="TreeView1" runat="server" OnSelectedNodeChanged="TreeView1_SelectedNodeChanged">
                </asp:TreeView>
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
            </div>
            <div>
                <div>
                    <a href="MemberSearch.aspx" style="float:right;">Return to Portal</a>
                    <rsweb:ReportViewer ID="ReportViewer1" runat="server" Height="632px" Width="100%" AsyncRendering="False" Font-Names="Verdana" Font-Size="8pt" ProcessingMode="Remote" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt">
                        <ServerReport ReportPath="/NewManager/General/ManagerAudit" ReportServerUrl="http://pca-sql1:80/ReportServer" />
                    </rsweb:ReportViewer>
                </div> 
            </div>        
        </div>
    </form>
</body>
</html>
