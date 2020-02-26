using System;
using System.IO;
using System.Diagnostics;
using System.Web;
using System.Net;
using System.Web.UI.WebControls;
using class_ADO;
using System.Collections.Generic;

public partial class InsuranceFileUploadDownload : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            PopulateTreeView(TreeView1);
            PopulateTreeView(TreeView2);

        }

        string IncidentNumber = Request.QueryString["IncidentNumber"];
        //string IncidentNumber = "TEST"; //Request.QueryString["IncidentNumber"];

        string WCNumber = Request.QueryString["WCNumber"];
        //string IncidentNumber = "TEST"; //Request.QueryString["IncidentNumber"];

        TreeNode itn = SearchTreeView(IncidentNumber, TreeView1.Nodes);
        if (itn == null)
        {
            TreeView1.CollapseAll();
        }
        else
        {
            itn.Select();
            TreeView1.SelectedNodeStyle.BackColor = System.Drawing.Color.LightBlue;
            ExpandSelectedAndParents(itn);
        }

        TreeNode wctn = SearchTreeView(WCNumber, TreeView2.Nodes);
        if (wctn == null)
        {
            TreeView2.CollapseAll();
        }
        else
        {
            wctn.Select();
            TreeView2.SelectedNodeStyle.BackColor = System.Drawing.Color.LightBlue;
            ExpandSelectedAndParents(wctn);
        }


        if ((string)Session["LoginError"] != "" || (string)Session["LoginError"] == "null")
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "scriptkey", "alert('" + Session["LoginError"] + "');");
        }

        Session["LoginError"] = "";

    }
    private void ExpandSelectedAndParents(TreeNode tn)
    {
        tn.Expand();
        if (tn.Parent != null)
        {
            ExpandSelectedAndParents(tn.Parent);
        }

    }

    private TreeNode SearchTreeView(string p_sSearchTerm, TreeNodeCollection p_Nodes)
    {
        foreach (TreeNode node in p_Nodes)
        {
            if (node.Text.Contains(p_sSearchTerm))
            {
                return node;
            }
            
            if (node.ChildNodes.Count > 0)
            {
                TreeNode child = SearchTreeView(p_sSearchTerm, node.ChildNodes);
                if (child != null)
                {
                    return child;
                }
            }
        }

        return null;
    }

    private void PopulateTreeView(TreeView tree)
    {
        try
        {
            clsADO thisADO = new clsADO();
            string SQL = "Select CredUserName, CredPassword from InsurancePCA.dbo.Cred";

            List<clsADO.sql2DObject> thisPassInfo = new List<clsADO.sql2DObject>();
            thisPassInfo = thisADO.return2DListLocal(SQL, false);

            ImpersonationHelper.Impersonate("PCA", clsCrypt.Decrypt(thisPassInfo[0].one.ToString()), clsCrypt.Decrypt(thisPassInfo[0].two.ToString()), delegate
            {
                string Dir = @"\\pca-file\PCA Portal Claims";
                DirectoryInfo di = new DirectoryInfo(Dir);
                TreeNode tds = new TreeNode();
                tds.Text = "<div style='color: red'>" + di.Name + "</div>";
                tree.Nodes.Add(tds);
                tds.Text = di.Name;
                tds.ToolTip = di.FullName;
                LoadFiles(Dir, tds);
                LoadSubDirectories(Dir, tds);
            });
            tree.CollapseAll();
        }
        catch (Exception ex)
        {
            Session["LoginError"] = ex.ToString();
        }
    }

    private void LoadSubDirectories(string dir, TreeNode td)
    {
        // Get all subdirectories  
        string[] subdirectoryEntries = Directory.GetDirectories(dir);
        // Loop through them to see if they have any other subdirectories  
        foreach (string subdirectory in subdirectoryEntries)
        {

            DirectoryInfo di = new DirectoryInfo(subdirectory);
            TreeNode tds = new TreeNode();
            tds.Text = di.FullName;
            td.ChildNodes.Add(tds);
            tds.Text = "<div style='color: red'>" + di.Name + "</div>";
            tds.ToolTip = di.FullName;
            LoadFiles(subdirectory, tds);
            LoadSubDirectories(subdirectory, tds);
        }
    }

    private void LoadFiles(string dir, TreeNode td)
    {
        string[] Files = Directory.GetFiles(dir, "*.*");

        // Loop through them to see files  
        foreach (string file in Files)
        {
            FileInfo fi = new FileInfo(file);
            TreeNode tds = new TreeNode();
            tds.Text = fi.Name;
            tds.ToolTip = fi.FullName;
            td.ChildNodes.Add(tds);
        }
    }

    protected void UploadButton_Click(object sender, EventArgs e)
    {
        if (FileUpload1.HasFile)
        {
            SaveFile(FileUpload1.PostedFile);
        }
        else
        {
            UpLoadLabel.Text = "You did not specify a file to upload.";
        }


    }

    protected void DownloadButton_Click(object sender, EventArgs e)
    {
        if (DownLoadLabel.Text != "")
        {
            TreeView1.CollapseAll();
            TreeView2.CollapseAll();
            SaveDownFile();
        }
        else
        {
            DownLoadLabel.Text = "You did not specify a file to download.";
        }

    }

    void SaveDownFile()
    {
        try
        {
            clsADO thisADO = new clsADO();
            string SQL = "Select CredUserName, CredPassword from InsurancePCA.dbo.Cred";

            List<clsADO.sql2DObject> thisPassInfo = new List<clsADO.sql2DObject>();
            thisPassInfo = thisADO.return2DListLocal(SQL, false);

            string fnPath = DownLoadLabel.Text;
            string[] fnParts = fnPath.Split('\\');
            string fn = fnParts[fnParts.Length - 1];

            string SaveLocation = Server.MapPath(@"~\workingFolder\" + fn);

            ImpersonationHelper.Impersonate("PCA", clsCrypt.Decrypt(thisPassInfo[0].one.ToString()), clsCrypt.Decrypt(thisPassInfo[0].two.ToString()), delegate
            {
                File.Copy(DownLoadLabel.Text, SaveLocation);
            });

            if (SaveLocation != "")
            {
                System.IO.FileInfo file = new System.IO.FileInfo(SaveLocation);
                if (file.Exists)
                {
                    Response.Clear();
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + file.Name);
                    Response.AddHeader("Content-Length", file.Length.ToString());
                    Response.ContentType = "application/octet-stream";
                    Response.WriteFile(file.FullName);
                    Response.Flush();
                    HttpContext.Current.ApplicationInstance.CompleteRequest();
                }
                else
                {
                    Response.Write("This file does not exist.");
                }
            }

            if (File.Exists(SaveLocation))
            {
                System.IO.File.Delete(SaveLocation);
            }

        }
        catch
        {

        }
        

    }

    void SaveFile(HttpPostedFile file)
    {
        try
        {
            string fn = System.IO.Path.GetFileName(FileUpload1.PostedFile.FileName);
            string SaveLocation = Server.MapPath(@"~\workingFolder\" + fn);

            if ((FileUpload1.PostedFile != null) && (FileUpload1.PostedFile.ContentLength > 0))
            {

                try
                {
                    FileUpload1.PostedFile.SaveAs(SaveLocation);
                    TreeView1.Nodes.Clear();
                    TreeView2.Nodes.Clear();
                    PopulateTreeView(TreeView1);
                    PopulateTreeView(TreeView2);
                    Response.Write("The file has been uploaded.");
                }
                catch (Exception ex)
                {
                    Response.Write("Error: " + ex.Message);
                }
            }
            else
            {
                Response.Write("Please select a file to upload.");
            }

            clsADO thisADO = new clsADO();
            string SQL = "Select CredUserName, CredPassword from InsurancePCA.dbo.Cred";

            List<clsADO.sql2DObject> thisPassInfo = new List<clsADO.sql2DObject>();
            thisPassInfo = thisADO.return2DListLocal(SQL, false);

            string[] fileName = FileUpload1.FileName.Split('.');
            var path = Server.MapPath(@"~\workingFolder\" + fileName[0] + '.' + fileName[1]);

            ImpersonationHelper.Impersonate("PCA", clsCrypt.Decrypt(thisPassInfo[0].one.ToString()), clsCrypt.Decrypt(thisPassInfo[0].two.ToString()), delegate
            {
                string[] Directories = Directory.GetFiles(UpLoadLabel.Text);

                if (!File.Exists(UpLoadLabel.Text + "\\" + fileName[0] + '.' + fileName[1]))
                {
                    File.Copy(path, UpLoadLabel.Text + "\\" + fileName[0] + '.' + fileName[1]);
                }
            });


            string strFileFullPath = SaveLocation;

            if (System.IO.File.Exists(strFileFullPath))
            {
                System.IO.File.Delete(strFileFullPath);
            }

            TreeView1.Nodes.Clear();
            TreeView2.Nodes.Clear();
            PopulateTreeView(TreeView1);
            PopulateTreeView(TreeView2);
        }
        catch (Exception ex)
        {
            Console.Write(ex.ToString());
        }
        
    }

    protected void refresh_Click(object sender, EventArgs e)
    {
        TreeView1.Nodes.Clear();
        TreeView2.Nodes.Clear();
        PopulateTreeView(TreeView1);
        PopulateTreeView(TreeView2);
    }

}