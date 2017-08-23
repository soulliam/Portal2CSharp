<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="CreateUser.aspx.cs" Inherits="CreateUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div style="width:900px;">
        <label style="color:white;float:left;">User Name</label>
        <asp:TextBox ID="userName" runat="server"></asp:TextBox>
        <label style="color:white;float:left;">Email</label>
        <asp:TextBox ID="email" runat="server"></asp:TextBox>
    </div>
    <br />
    <div style="width:900px;">
        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged"></asp:DropDownList><asp:ListBox ID="ListBox1" runat="server" SelectionMode="Multiple"></asp:ListBox>
    </div>
    <div style="width:100px">
        <asp:Button ID="Button1" runat="server" Text="Button" OnClick="Button1_Click" />
    </div>
</asp:Content>

