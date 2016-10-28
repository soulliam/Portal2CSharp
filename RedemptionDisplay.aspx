<%@ Page Title="" Language="C#" MasterPageFile="Portal2Empty.master" AutoEventWireup="true" CodeFile="RedemptionDisplay.aspx.cs" Inherits="RedemptionDisplay" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <table background = "Images/Redemption.PNG" style ="width:590px;height:615px;border:solid">
        <tr>
            <td>
                <div runat="server" id="RedemptionType" style="text-align:center;font-size:60px;font-weight:bolder;font-family:'Bookman Old Style';color:olivedrab">
                    
                </div>
                <div runat="server" id="CertificateID" style="text-align:center;font-size:30px;font-weight:lighter;font-family:Calibri;color:grey">
                    
                </div>
                <div style="width:80%;float:left;margin-top:50px;position:absolute;margin-left:30px">
                    <div runat="server" id="MemberName" style="font-size:15px;font-weight:bold;color:grey;"></div>
                    <div runat="server" id="FPNumber" style="font-size:15px;font-weight:bold;color:grey;"></div>
                    <div runat="server" id="preferedLocation" style="font-size:12px;color:olivedrab;margin-top:10px;"></div>
                </div>
                 <div style="font-size:15px;width:19%;margin-left:420px;margin-top:25px;position:absolute">
                    <asp:PlaceHolder ID="MemberBarHolder" runat="server" />
                </div>
            </td>
        </tr>
    </table>
</asp:Content>

