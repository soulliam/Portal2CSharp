<%@ Page Title="" Language="C#" MasterPageFile="~/Booth/Portal2Empty.master" AutoEventWireup="true" CodeFile="CardDisplay.aspx.cs" Inherits="CardDisplay" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <link rel="stylesheet" href="/jqwidgets/styles/jqx.base.css" type="text/css" />

    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $("#email").jqxButton({ width: 180, height: 25 });
            
            var thisCard = getUrlParameter('cardNumber');
            var thisToAddress = getUrlParameter('memberEmailAddress');

            $("#email").on("click", function (event) {
                var body = $("#card").html();
                var resBody = body.replace(/"\.\/EmailImages\/.*Jpeg"/, "cid:MyPic");
                resBody = resBody.replace(/"\.\/Images\/.*jpg"/, "cid:MyPic2");

                $('#card').get(0).outerHTML;
                PageMethods.sendReceipt(resBody, thisCard, thisToAddress, DisplayPageMethodResults);
            });
        });
    </script>

    

    <div id="card">
        <asp:Image ID="EmailCard" runat="server" src=cid:MyPic2 />
        <asp:Table ID="BottomCard" style="width: 538px;" runat="server">
            <asp:TableHeaderRow>
                <asp:TableCell style="width: 72%;">
                    <div style="position: absolute; top:235px; left: 5px; color: #719932; font: 700 25px/29px 'Bitter', serif; padding: 10px; font-family: Arial, Helvetica, sans-serif;"><asp:Label ID="memberName" runat="server" Text="Label"></asp:Label></div>
                    <div style="position: absolute; top:275px; color: #040503; font: 700 20px/25px 'Bitter', serif; left: 17px; font-family: Arial, Helvetica, sans-serif;">Card Number <asp:Label ID="cardNumber" runat="server" Text="Label"></asp:Label></div>
                    <div style="position: absolute; top:300px; color: #040503; font: 400 17px/22px 'Bitter', serif; left: 17px; font-family: Arial, Helvetica, sans-serif;">Member Since <asp:Label ID="memberSince" runat="server" Text="Label"></asp:Label></div>
                </asp:TableCell>
                <asp:TableCell style="width: 28%;">
                    <asp:Image ID="EmailQR" style="position: absolute; top:225px; left: 390px" src=cid:MyPic runat="server" />
                </asp:TableCell>
            </asp:TableHeaderRow>
        </asp:Table>
        <asp:Image ID="EmailCardBottom" runat="server" src=cid:MyPic3 />
    </div>
    <div style="margin-left:15px;margin-top:10px"><input id="email" value="Send" /></div>
</asp:Content>

