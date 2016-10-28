<%@ Page Title="" Language="C#" MasterPageFile="Portal2Empty.master" AutoEventWireup="true" CodeFile="RedemptionDisplay.aspx.cs" Inherits="RedemptionDisplay" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <div class="container-fluid receipt-container">
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

</asp:Content>

