<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2Empty.master" AutoEventWireup="true" CodeFile="RedemptionDisplay.aspx.cs" Inherits="RedemptionDisplay" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <table background = "Images/Redemption.PNG" style ="width:590px;height:615px;border:solid">
        <tr>
            <td>
                <div id="stayCount" style="text-align:center;font-size:60px;font-weight:bolder;font-family:'Bookman Old Style';color:olivedrab">
                    1 Day
                </div>
                <div id="redemptionNumber" style="text-align:center;font-size:30px;font-weight:lighter;font-family:Calibri;color:grey">
                    56767857896985673462435234
                </div>
                <div style="width:80%;float:left;margin-top:50px;position:absolute;margin-left:30px">
                    <div id="memberName" style="font-size:15px;font-weight:bold;color:grey;">Greg Fritz</div>
                    <div id="memberId" style="font-size:15px;font-weight:bold;color:grey;">818247</div>
                    <div id="preferedLocation" style="font-size:12px;color:olivedrab;margin-top:10px;">Your prefered location: Austin AUS, Austin 512-385-8877</div>
                </div>
                 <div style="font-size:15px;width:19%;margin-left:420px;margin-top:50px;position:absolute">
                    <img src="Images/QR.png" />
                </div>
            </td>
        </tr>
    </table>
</asp:Content>

