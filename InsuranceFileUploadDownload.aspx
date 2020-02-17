<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="InsuranceFileUploadDownload.aspx.cs" Inherits="InsuranceFileUploadDownload" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script runat="server">

        void Select_ChangeDown(Object sender, EventArgs e)
        {
            if (TreeView2.SelectedNode.ToolTip.Length > 0)
            {
                DownLoadLabel.Text = TreeView2.SelectedNode.ToolTip;

                var thisPath = TreeView2.SelectedNode.ToolTip;
                var thisDownload = thisPath.Split('\\');

                var viewPath = "";

                for (var index = 0; index < thisDownload.Length; index++) {
                    if (index > 3)
                    {
                        viewPath = viewPath + "\\" + thisDownload[index];
                    }
                }

                ViewDownLoadLabel.Text = viewPath;
            }

        }

        void Select_ChangeUp(Object sender, EventArgs e)
        {
            if (TreeView1.SelectedNode.ToolTip.Length > 0)
            {
                UpLoadLabel.Text = TreeView1.SelectedNode.ToolTip;

                var thisPath = TreeView1.SelectedNode.ToolTip;
                var thisUpload = thisPath.Split('\\');

                var viewPath = "";

                for (var index = 0; index < thisUpload.Length; index++) {
                    if (index > 3)
                    {
                        viewPath = viewPath + "\\" + thisUpload[index];
                    }
                }

                ViewUpLoadLabel.Text = viewPath;
            }

        }

    </script>
    <asp:Button ID="refresh" Text="Refresh" runat="server" OnClick="refresh_Click" Width="150px" />
    <br /><br />
    
    <br />
    <table style="padding:10px">
        <tr>
            <td>
                <asp:Label id="Label1" BackColor="White" Text="Pick Location To Upload To:" runat="server" Font-Bold="True"></asp:Label>
            </td>
            <td>
                <asp:Label id="Label2" BackColor="White" Text="Pick File To Download:" runat="server" Font-Bold="True"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label id="UpLoadLabel" BackColor="White" runat="server" Width="350px" style="display:none"></asp:Label>
                <asp:Label id="ViewUpLoadLabel" BackColor="White" runat="server" Width="350px"></asp:Label>
            </td>
            <td>
                <asp:Label id="DownLoadLabel" BackColor="White" runat="server" Width="350px" style="display:none"></asp:Label>
                <asp:Label id="ViewDownLoadLabel" BackColor="White" runat="server" Width="350px"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <div style="overflow:auto;height:230px;width:475px;border-width:.5px;border:solid"><asp:TreeView ID="TreeView1" OnSelectedNodeChanged="Select_ChangeUp" runat="server"></asp:TreeView></div>
            </td>
            <td>
                <div style="overflow:auto;height:230px;width:475px;border-width:.5px;border:solid""><asp:TreeView ID="TreeView2" OnSelectedNodeChanged="Select_ChangeDown" runat="server"></asp:TreeView></div>
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


