<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2Empty.master" AutoEventWireup="true" CodeFile="ReservationDisplay.aspx.cs" Inherits="ReservationDisplay" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <link rel="stylesheet" href="/jqwidgets/styles/jqx.base.css" type="text/css" />

    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>

    <script type="text/javascript">
        
        $(document).ready(function () {
            

            $("#email").jqxButton({ width: 415, height: 25 });

            $("#email").jqxButton({ width: 180, height: 25 });
            
            var thisCertificateID = getUrlParameter('thisCertificateID');
            var thisToAddress = getUrlParameter('EmailAddress');


            $("#email").on("click", function (event) {
                html2canvas($("#redemption"), {
                    onrendered: function (canvas) {
                        theCanvas = canvas;
                        document.body.appendChild(canvas);

                        var image = canvas.toDataURL("image/png");

                        image = image.replace('data:image/png;base64,', '');

                        PageMethods.sendReceipt(image, thisCertificateID, thisToAddress, DisplayPageMethodResults);
                        function onSucess(result) {
                            alert(result);
                        }
                        function onError(result) {
                            alert('Error Emailing Redemption: ' + result);
                        }
                    }
                });
            });
        });

        function getUrlParameter(name) {
            name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
            var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
            var results = regex.exec(location.search);
            return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
        };
    </script>

    <div id="redemption" class="container-fluid receipt-container">
        <div class="row">
            <div class="col-sm-12">
                <div runat="server" id="RedemptionType" class="redeption-style-1">
                    1 Day
                </div>
            </div>
            <div class="col-sm-12">
                <div runat="server" id="CertificateID" class="redeption-style-2">
                    56767857896985673462435234
                </div>
            </div>
            <div class="col-sm-12">
                <div class="redeption-style-3">
                    <div class="redeption-style-6">
                        <asp:PlaceHolder ID="MemberBarHolder" runat="server" />
                    </div>
                    <div runat="server" id="MemberName" class="redeption-style-4">Greg Fritz</div>
                    <div runat="server" id="FPNumber" class="redeption-style-4">818247</div>
                    <div runat="server" id="preferedLocation" class="redeption-style-5"></div>
                </div>
            </div>
        </div>
    </div>
    <div style="margin-left:15px;margin-top:10px"><input id="email" value="Send" /></div>
    <div id="img-out" style="display:none"></div>
</asp:Content>

