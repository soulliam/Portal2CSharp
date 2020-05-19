<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="PCATagNumbers.aspx.cs" Inherits="PCATagNumbers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script type="text/javascript">

        // ============= Initialize Page ==================== Begin
        var group = '<%= Session["groupList"] %>';

        $(document).ready(function () {
            Security();
        });

    </script>

    <div style="margin-top:200px">
        <asp:TextBox ID="alert" runat="server" style="width:500px" Visible="False"></asp:TextBox>
        <asp:FileUpload ID="FileUpload1" runat="server" style="width:500px" BackColor="White" />
        <br />
        <asp:Button ID="btnUpload" runat="server" Text="Upload" style="width:500px" OnClick="btnUpload_Click"/>
    </div>
</asp:Content>


