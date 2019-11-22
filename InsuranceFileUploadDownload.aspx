<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceFileUploadDownload.aspx.cs" Inherits="InsuranceFileUploadDownload" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script runat="server">

        void Select_ChangeDown(Object sender, EventArgs e)
        {
            DownLoadLabel.Text = TreeView2.SelectedNode.ToolTip;
        }

        void Select_ChangeUp(Object sender, EventArgs e)
        {
            UpLoadLabel.Text = TreeView1.SelectedNode.ToolTip;
        }

    </script>
    <asp:Button ID="refresh" Text="Refresh" runat="server" OnClick="refresh_Click" Width="150px" />
    <br /><br />
    <table>
        <tr>
            <td>
                Username
            </td>
            <td>
                Password
            </td>
        </tr>
        <tr>
            <td>
                <asp:TextBox ID="UserName" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox ID="Password" runat="server" type="password"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Button ID="Login" runat="server" Text="Lob In" OnClick="Login_Click" />
            </td>
        </tr>
    </table>
    <br />
    <table>
        <tr>
            <td>
                <asp:Label id="Label1" BackColor="White" Text="Pick Location To Upload To"
                    runat="server">
                </asp:Label>
                <br />
                <asp:Label id="UpLoadLabel" BackColor="White" Text=""
                    runat="server">
                </asp:Label>
                <br />
                <asp:TreeView ID="TreeView1" OnSelectedNodeChanged="Select_ChangeUp" runat="server"></asp:TreeView>
                <br />
                <br />
            </td>
            <td>
                <asp:TreeView ID="TreeView2" OnSelectedNodeChanged="Select_ChangeDown" runat="server"></asp:TreeView>
                <br />
                <asp:Label id="DownLoadLabel" BackColor="White" Text="Down Load file"
                    runat="server">
                </asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <br />
                <asp:FileUpload id="FileUpload1" Width="500px"                
                    runat="server" BackColor="White">
                </asp:FileUpload>
            </td>
            <td>

            </td>
        </tr>
        <tr>
            <td>
                <asp:Button id="UploadButton" Width="500px"
                    Text="Upload file"
                    OnClick="UploadButton_Click"
                    runat="server">
                </asp:Button> 
            </td> 
            <td>
                <asp:Button id="DownloadButton" Width="500px"
                    Text="Download file"
                    OnClick="DownloadButton_Click"
                    runat="server">
                </asp:Button>
            </td>
        </tr>
    </table> 
</asp:Content>


