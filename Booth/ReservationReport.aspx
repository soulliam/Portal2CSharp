<%@ Page Title="" Language="C#" MasterPageFile="~/Booth/Portal2Empty.master" AutoEventWireup="true" CodeFile="ReservationReport.aspx.cs" Inherits="Booth_ReservationReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div>
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Height="1500px" Width="100%" AsyncRendering="False" Font-Names="Verdana" Font-Size="8pt" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt">
            <ServerReport ReportServerUrl="" />
        </rsweb:ReportViewer>
    </div> 
</asp:Content>

