<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="CreateUser.aspx.cs" Inherits="CreateUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <script type="text/javascript" src="scripts/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="scripts/bootstrap.min.js"></script>
    <script type="text/javascript" src="scripts/common.js"></script>

    
    <link rel="stylesheet" href="scripts/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="style.css">

    <script src="scripts/es6-promise.auto.min.js"></script>
    <script src="scripts/sweetalert2.min.js"></script>
    <link rel="stylesheet" href="scripts/sweetalert2.min.css">

    <link rel="stylesheet" href="jqwidgets/styles/jqx.base.css" type="text/css" />
    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>

    <script type="text/javascript" src="jqwidgets/globalization/globalize.js"></script>

    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxexpander.js"></script>    


    <style>
        .centerText{
           text-align: right;
        }
        .auto-style1 {
            width: 386px;
        }
        .auto-style2 {
            height: 40px;
            width: 386px;
        }
        .auto-style3 {
            height: 22px;
            width: 386px;
        }
        .auto-style4 {
            height: 26px;
            width: 386px;
        }
        .auto-style5 {
            width: 377px;
        }
        .auto-style6 {
            height: 40px;
            width: 377px;
        }
        .auto-style7 {
            height: 22px;
            width: 377px;
        }
        .auto-style8 {
            height: 26px;
            width: 377px;
        }
        .auto-style9 {
            width: 594px;
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

        function deleteLocation() {
            $('html').keyup(function (e) {
                if (e.keyCode == 46) {
                    __doPostBack(this.name, 'deleteLocation')
                }
            });
        }

        function deleteVehicleLocation() {
            $('html').keyup(function (e) {
                if (e.keyCode == 46) {
                    __doPostBack(this.name, 'deleteVehicleLocation')
                }
            });
        }
    </script>
        <div style="width:500px;background-color:transparent;margin-top:25px;margin-left:15px;">
            <div class="container">
                <div class="row">
                    <div class="col-sm-2">
                        <label style="color:white;float:left;font-size:medium;">User Name</label>
                    </div>
                    <div class="col-sm-4">
                        <asp:TextBox ID="userName" runat="server" Style="float:left;"></asp:TextBox>
                        <div>
                            <asp:RequiredFieldValidator ID="userNameFieldValidator" runat="server" ControlToValidate="userName" ErrorMessage="This Field can not be blank." Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <asp:Button ID="findUser" runat="server" Width="100px" Text="Find" Style="float:left;" OnClick="findUser_Click" CausesValidation="false" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-2">
                        <label style="color:white;float:left;font-size:medium;">Email</label>
                    </div>
                    <div class="col-sm-4">
                        <asp:TextBox ID="email" runat="server"></asp:TextBox>
                        <div><asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="email" ErrorMessage="This Field can not be blank." Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:RequiredFieldValidator></div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-2">
                        <label style="color:white;float:left;font-size:medium;">Login Locations</label>
                    </div>
                    <div class="col-sm-10">
                        <asp:DropDownList ID="ddlLoginLocations" runat="server" OnSelectedIndexChanged="ddlLoginLocations_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-2">
                        
                    </div>
                    <div class="col-sm-10">>
                        <asp:ListBox ID="lbLoginLocations" runat="server" SelectionMode="Single" onkeyup="deleteLocation()"></asp:ListBox>
                        <asp:RequiredFieldValidator ID="LocationFieldValidator" runat="server" ControlToValidate="lbLoginLocations" ErrorMessage="This Field can not be blank." Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-2">
                        <label style="color:white;float:left;font-size:medium;">Vehicle Locations</label>
                    </div>
                    <div class="col-sm-10">
                        
                        <asp:DropDownList ID="ddlVehicleLocations" runat="server" OnSelectedIndexChanged="ddlVehicleLocations_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-2">
                        
                    </div>
                    <div class="col-sm-10">
                        <asp:ListBox ID="lbVehicleLocations" runat="server" SelectionMode="Single" onkeyup="deleteVehicleLocation()"></asp:ListBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <label style="color:white;width:225px;font-size:medium;">Include in manager report.</label>
                        <asp:CheckBox ID="AuditReport" runat="server" Width="20px" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-2">
                        <label style="color:white;float:left;font-size:medium;">Password</label>
                    </div>
                    <div class="col-sm-10">
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
                        <div><asp:RequiredFieldValidator ID="PasswordFieldValidator" runat="server" ControlToValidate="txtPassword" ErrorMessage="This Field can not be blank." Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:RequiredFieldValidator></div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-2">
                        <label style="color:white;float:left;font-size:medium;">Confirm Password</label>
                    </div>
                    <div class="col-sm-10">
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"></asp:TextBox>
                        <div>
                            <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="CompareValidator" ControlToValidate="txtPassword" ControlToCompare="txtConfirmPassword" Text="Password mismatch" Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:CompareValidator>
                            <asp:RequiredFieldValidator ID="confirmPasswordFieldValidator" runat="server" ControlToValidate="txtConfirmPassword" ErrorMessage="This Field can not be blank." Font-Size="15px" ForeColor="Red" BackColor="White" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <label style="color:white;float:left;font-size:medium;">Roles</label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <asp:Table ID="Table1" runat="server" Width="100%" BorderColor="Black" BorderStyle="Solid" BorderWidth="1px" CellPadding="1" CellSpacing="1" GridLines="Both"></asp:Table>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div id='jqxWidget' style="margin-top:10px">
                            <div id='jqxExpander'>
                                <div>
                                    Marketing Rep
                                </div>
                                <div>
                                    <table>
                                        <tr>
                                            <td style="padding:10px;" class="auto-style9">
                                                <table>
                                                    <tr>
                                                        <td style="width: 333px" align="right">
                                                            <asp:Label ID="lbeCreateRepRecord" runat="server" Text="Create Rep Record "></asp:Label>
                                                        </td>
                                                        <td class="auto-style5">
                                                            <asp:CheckBox ID="createRepRecord" runat="server" />
                                                        </td>
                                                        <td class="auto-style1">
                                                            <label style="color:red; font-weight:bold;">To create a Rep check this box!</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 333px" align="right">
                                                            <asp:Label ID="lblTerritoryAbbrev" runat="server" Text="Territory Abbreviation: "></asp:Label>
                                                        </td>
                                                        <td class="auto-style5">
                                                            <asp:TextBox ID="txtTerritory" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td class="auto-style1">
                                                            &nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 333px" align="right">
                                                            <asp:Label ID="lblFirstName" runat="server" Text="First Name: "></asp:Label>
                                                        </td>
                                                        <td class="auto-style5">
                                                            <asp:TextBox ID="txtFirstName" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td class="auto-style1">
                                                            &nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                                            <asp:Label ID="lblLastName" runat="server" Text="Last Name: "></asp:Label>
                                                        </td>
                                                        <td class="auto-style5">
                                                            <asp:TextBox ID="txtLastName" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td class="auto-style1">
                                                            &nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                                            <asp:Label ID="lblHireDate" runat="server" Text="Hire Date: "></asp:Label>
                                                        </td>
                                                        <td class="auto-style5">
                                                            <asp:TextBox ID="txtHireDate" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td class="auto-style1">
                                                            &nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="margin-left: 40px; width: 333px; height: 40px;" align="right">
                                                            <asp:Label ID="lblRepId" runat="server" Text="Rep Id (2 digit, Rep Only): "></asp:Label>
                                                        </td>
                                                        <td class="auto-style6">
                                                            <asp:TextBox ID="txtRepId" runat="server" MaxLength="2"></asp:TextBox>
                                                        </td>
                                                        <td class="auto-style2">
                                                            <asp:DropDownList ID="UsedRepId" runat="server" OnSelectedIndexChanged="ddlLoginLocations_SelectedIndexChanged" AutoPostBack="false"></asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                                            Marketing Code First 4:</td>
                                                        <td class="auto-style5">
                                                            <asp:TextBox ID="txtMarketingCode1st4" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td class="auto-style1">
                                                            &nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                                            Street Address:</td>
                                                        <td class="auto-style5">
                                                            <asp:TextBox ID="txtStreetAddress" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td class="auto-style1">
                                                            &nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                                            City:</td>
                                                        <td class="auto-style5">
                                                            <asp:TextBox ID="txtCity" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td class="auto-style1">
                                                            &nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                                            State:</td>
                                                        <td class="auto-style5">
                                                            <asp:TextBox ID="txtState" runat="server" MaxLength="2"></asp:TextBox>
                                                        </td>
                                                        <td class="auto-style1">
                                                            &nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="margin-left: 40px; width: 333px; height: 22px;" align="right">
                                                            Zip:</td>
                                                        <td class="auto-style7">
                                                            <asp:TextBox ID="txtZip" runat="server"></asp:TextBox>
                                                            </td>
                                                        <td class="auto-style3">
                                                            &nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="margin-left: 40px; width: 333px; height: 26px;" align="right">
                                                            Phone:</td>
                                                        <td class="auto-style8">
                                                            <asp:TextBox ID="txtPhone" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td class="auto-style4">
                                                            &nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                                            Title:</td>
                                                        <td class="auto-style5">
                                                            <asp:TextBox ID="txtTitle" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td class="auto-style1">
                                                            &nbsp;</td>
                                                    </tr>
                                                    <tr style="height:50px">
                                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                                            Mailer Id (Manager/Admin = Y):<br />
                                                            Last Assigned was: <asp:Label ID="lblLastAssigned" runat="server"></asp:Label></td>
                                                        <td class="auto-style5">
                                                            <asp:TextBox ID="txtMailerId" runat="server" MaxLength="1"></asp:TextBox>
                                                        </td>
                                                        <td class="auto-style1">
                                                            <asp:DropDownList ID="ddlRepMailerId" runat="server"  AutoPostBack="false"></asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                                            Photo URL</td>
                                                        <td class="auto-style5">
                                                            <asp:TextBox ID="txtPhotoURL" runat="server"></asp:TextBox>
                                                        </td>
                                                        <td class="auto-style1">
                                                            &nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                                            Is Manager</td>
                                                        <td class="auto-style5">
                                                            <asp:CheckBox ID="IsManager" runat="server" />
                                                        </td>
                                                        <td class="auto-style1">
                                                            &nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="margin-left: 40px; width: 333px;" align="right">
                                                            Is Primary</td>
                                                        <td class="auto-style5">
                                                            <asp:CheckBox ID="IsPrimary" runat="server" />
                                                        </td>
                                                        <td class="auto-style1">
                                                            &nbsp;</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row" style="margin-top:5px;">
                    <div class="col-sm-6">
                        <asp:Button ID="Button1" runat="server" Text="Create" OnClick="Button1_Click" style="width:100px;" /><asp:Button ID="Button2" runat="server" Text="Edit" CausesValidation="false" OnClick="Button2_Click" style="width:100px;" />
                    </div>
                    <div class="col-sm-6">
                        <asp:Button ID="Reset" CausesValidation="false" runat="server" Text="Clear" OnClick="Reset_Click" style="width:100px;float:right" />
                    </div>
                </div>
            </div>
        </div>
    <asp:TextBox ID="txtGUID" runat="server" Visible="False"></asp:TextBox>
</asp:Content>

