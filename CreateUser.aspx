<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="CreateUser.aspx.cs" Inherits="CreateUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <style>
        .centerText{
           text-align: right;
        }
    </style>

    <div style="width:1000px;margin-left:100px;">
        <label style="color:white;float:left;font-size:medium;">User Name</label>
        <asp:TextBox ID="userName" runat="server"></asp:TextBox>
        <div><asp:RequiredFieldValidator ID="userNameFieldValidator" runat="server" ControlToValidate="userName" ErrorMessage="This Field can not be blank." Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:RequiredFieldValidator></div>
        <label style="color:white;float:left;font-size:medium;">Email</label>
        <asp:TextBox ID="email" runat="server"></asp:TextBox>
        <div><asp:RequiredFieldValidator ID="emailFieldValidator" runat="server" ControlToValidate="email" ErrorMessage="This Field can not be blank." Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:RequiredFieldValidator></div>
        <label style="color:white;float:left;font-size:medium;">Password</label>
        <asp:TextBox ID="txtPassword" runat="server"></asp:TextBox>
        <div><asp:RequiredFieldValidator ID="PasswordFieldValidator" runat="server" ControlToValidate="txtPassword" ErrorMessage="This Field can not be blank." Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:RequiredFieldValidator></div>
        <label style="color:white;float:left;font-size:medium;">Confirm Password</label>
        <asp:TextBox ID="txtConfirmPassword" runat="server"></asp:TextBox>
        <div>
            <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="CompareValidator" ControlToValidate="txtPassword" ControlToCompare="txtConfirmPassword" Text="Password mismatch" Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:CompareValidator>
            <asp:RequiredFieldValidator ID="confirmPasswordFieldValidator" runat="server" ControlToValidate="txtConfirmPassword" ErrorMessage="This Field can not be blank." Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>
        <br />
        <div>
            <label style="color:white;float:left;font-size:medium;">Login Locations</label>
            <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged"></asp:DropDownList>
            <asp:ListBox ID="ListBox1" runat="server" SelectionMode="Multiple"></asp:ListBox>
            <asp:RequiredFieldValidator ID="LocationFieldValidator" runat="server" ControlToValidate="ListBox1" ErrorMessage="This Field can not be blank." Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>
        <div style="margin-top:10px">
            <asp:Table ID="Table1" runat="server" Width="100%" BorderColor="Black" BorderStyle="None" BorderWidth="1px" CellPadding="1" CellSpacing="1" GridLines="Both"></asp:Table>
        </div>
        <div style="margin-top:10px">
            <asp:Button ID="Button1" runat="server" Text="Create" OnClick="Button1_Click" style="width:100px;" />
            <asp:Button ID="Reset" CausesValidation="false" runat="server" Text="Clear" OnClick="Reset_Click" style="width:100px;float:right" />
        </div>
    </div>
    
</asp:Content>

