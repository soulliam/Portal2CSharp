<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="CreateUser.aspx.cs" Inherits="CreateUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <link rel="stylesheet" href="jqwidgets/styles/jqx.base.css" type="text/css" />
    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>

    <script type="text/javascript" src="jqwidgets/globalization/globalize.js"></script>

    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxexpander.js"></script>    


    <style>
        .centerText{
           text-align: right;
        }
    </style>

    <script type="text/javascript">
        // ============= Initialize Page ==================== Begin
        var group = '<%= Session["groupList"] %>';

        $(document).ready(function () {
            $("#jqxExpander").jqxExpander({ width: '100%' });
            $('#jqxExpander').jqxExpander({ expanded: false });
            $('#jqxExpander').jqxExpander({ animationType: "fade" });
            Security();
        })

    </script>

    <div style="width:1000px;margin-left:100px;margin-top:20px;">
        <div style="width:150px;float:left">
            <label style="color:white;float:left;font-size:medium;">User Name</label>
        </div>
        <div style="width 275px;float:right">
            <label style="color:white;width:225px;font-size:medium;">Include in manager report.</label>
            <asp:CheckBox ID="AuditReport" runat="server" Width="20px" />
        </div>
        <asp:TextBox ID="userName" runat="server"></asp:TextBox>
        <div><asp:RequiredFieldValidator ID="userNameFieldValidator" runat="server" ControlToValidate="userName" ErrorMessage="This Field can not be blank." Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:RequiredFieldValidator></div>
        <div>
            <label style="color:white;float:left;font-size:medium;">Email</label>
            <asp:TextBox ID="email" runat="server"></asp:TextBox>
        </div>
        <div><asp:RequiredFieldValidator ID="emailFieldValidator" runat="server" ControlToValidate="email" ErrorMessage="This Field can not be blank." Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:RequiredFieldValidator></div>
        <div style="margin-top:10px">
            <label style="color:white;float:left;font-size:medium;">Login Locations (The first one will be the HOME location)</label>
            <asp:DropDownList ID="DropDownList1" runat="server" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
        </div>
        <div style="margin-top:5px">
            <asp:ListBox ID="ListBox1" runat="server" SelectionMode="Multiple"></asp:ListBox>
            <asp:RequiredFieldValidator ID="LocationFieldValidator" runat="server" ControlToValidate="ListBox1" ErrorMessage="This Field can not be blank." Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>
        <label style="color:white;float:left;font-size:medium;">Password</label>
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
        <div><asp:RequiredFieldValidator ID="PasswordFieldValidator" runat="server" ControlToValidate="txtPassword" ErrorMessage="This Field can not be blank." Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:RequiredFieldValidator></div>
        <label style="color:white;float:left;font-size:medium;">Confirm Password</label>
        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"></asp:TextBox>
        <div>
            <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="CompareValidator" ControlToValidate="txtPassword" ControlToCompare="txtConfirmPassword" Text="Password mismatch" Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:CompareValidator>
            <asp:RequiredFieldValidator ID="confirmPasswordFieldValidator" runat="server" ControlToValidate="txtConfirmPassword" ErrorMessage="This Field can not be blank." Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>
        <div style="margin-top:10px">
            <asp:Table ID="Table1" runat="server" Width="100%" BorderColor="Black" BorderStyle="Solid" BorderWidth="1px" CellPadding="1" CellSpacing="1" GridLines="Both"></asp:Table>
        </div>
        <div id='jqxWidget' style="margin-top:10px">
            <div id='jqxExpander'>
                <div>
                    Marketing Rep
                </div>
                <div>
                    <table>
                        <tr>
                            <td style="width: 421px;padding:10px;">
                                <table style="width: 401px">
                                    <tr>
                                        <td style="width: 333px" align="right">
                                            <asp:Label ID="lbeCreateRepRecord" runat="server" Text="Create Rep Record "></asp:Label>
                                        </td>
                                        <td style="width: 162px">
                                            <asp:CheckBox ID="createRepRecord" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 333px" align="right">
                                            <asp:Label ID="lblTerritoryAbbrev" runat="server" Text="Territory Abbreviation: "></asp:Label>
                                        </td>
                                        <td style="width: 162px">
                                            <asp:TextBox ID="txtTerritory" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 333px" align="right">
                                            <asp:Label ID="lblFirstName" runat="server" Text="First Name: "></asp:Label>
                                        </td>
                                        <td style="width: 162px">
                                            <asp:TextBox ID="txtFirstName" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                            <asp:Label ID="lblLastName" runat="server" Text="Last Name: "></asp:Label>
                                        </td>
                                        <td style="width: 162px">
                                            <asp:TextBox ID="txtLastName" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                            <asp:Label ID="lblHireDate" runat="server" Text="Hire Date: "></asp:Label>
                                        </td>
                                        <td style="width: 162px">
                                            <asp:TextBox ID="txtHireDate" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="margin-left: 40px; width: 333px; height: 40px;" align="right">
                                            <asp:Label ID="lblRepId" runat="server" Text="Rep Id (2 digit, Rep Only): "></asp:Label>
                                        </td>
                                        <td style="height: 40px; width: 162px;">
                                            <asp:TextBox ID="txtRepId" runat="server" MaxLength="2"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                            Street Address:</td>
                                        <td style="width: 162px">
                                            <asp:TextBox ID="txtStreetAddress" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                            City:</td>
                                        <td style="width: 162px">
                                            <asp:TextBox ID="txtCity" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                            State:</td>
                                        <td style="width: 162px">
                                            <asp:TextBox ID="txtState" runat="server" MaxLength="2"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="margin-left: 40px; width: 333px; height: 22px;" align="right">
                                            Zip:</td>
                                        <td style="width: 162px; height: 22px">
                                            <asp:TextBox ID="txtZip" runat="server"></asp:TextBox>
                                            </td>
                                    </tr>
                                    <tr>
                                        <td style="margin-left: 40px; width: 333px; height: 26px;" align="right">
                                            Phone:</td>
                                        <td style="width: 162px; height: 26px;">
                                            <asp:TextBox ID="txtPhone" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                            Title:</td>
                                        <td style="width: 162px">
                                            <asp:TextBox ID="txtTitle" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr style="height:50px">
                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                            Mailer Id (Manager/Admin = Y):<br />
                                            Last Assigned was: <asp:Label ID="lblLastAssigned" runat="server"></asp:Label></td>
                                        <td style="width: 162px">
                                            <asp:TextBox ID="txtMailerId" runat="server" MaxLength="1"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                            Photo URL</td>
                                        <td style="width: 162px">
                                            <asp:TextBox ID="txtPhotoURL" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div style="margin-top:10px;margin-bottom:20px">
            <asp:Button ID="Button1" runat="server" Text="Create" OnClick="Button1_Click" style="width:100px;" />
            <asp:Button ID="Reset" CausesValidation="false" runat="server" Text="Clear" OnClick="Reset_Click" style="width:100px;float:right" />
        </div>
    </div>
</asp:Content>

