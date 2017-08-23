using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using class_ADO;
using System.Data.SqlClient;
using System.Data;
using System.Collections;
using System.Security.Principal;

public partial class Reports : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Boolean beenToDefault = false;

        if ((string)(Session["IMIN"]) == "true")
        {
            beenToDefault = true;
        }

        if (beenToDefault == false)
        {
            Response.Redirect("./Default.aspx");
        }

        getPortalGroups();

        if (!IsPostBack)
        {
            //try
            //{
            //    ReportViewer1.Visible = false;

            //    clsADO thisADO = new clsADO();
            //    string constr = thisADO.getLocalConnectionString();

            //    using (SqlConnection con = new SqlConnection(constr))
            //    {
            //        using (SqlCommand cmd = new SqlCommand("select ReportName, '/' + ReportSection + '/' + ReportWithExtension as ReportLocation from reportlist order by ReportName"))
            //        {
            //            cmd.CommandType = CommandType.Text;
            //            cmd.Connection = con;
            //            con.Open();
            //            ddlReports.DataSource = cmd.ExecuteReader();
            //            ddlReports.DataTextField = "ReportName";
            //            ddlReports.DataValueField = "ReportLocation";
            //            ddlReports.DataBind();
            //            con.Close();
            //        }
            //    }
            //    ddlReports.Items.Insert(0, new ListItem("--Select Report--", "0"));
            //}
            //catch (Exception ex)
            //{
            //    Console.Write(ex.ToString());
            //}

            var whereClause = getPortalGroups();

            //var strSQL = "select Distinct(ReportSection) as ReportSection, 0 as ReportId from ReportList2 r2 " +
            //             "Inner Join ReportToGroup rtg on r2.ReportId = rtg.ReportId " + whereClause;

            var strSQL = "select Distinct(ReportSection) as ReportSection, 0 as ReportId from ReportList2 order by ReportSection ";

            DataTable dt = this.GetData(strSQL);
            this.PopulateTreeView(dt, 0, null, whereClause);

        }

    }

    private void PopulateTreeView(DataTable dtParent, int parentId, TreeNode treeNode, string whereClause)
    {
        foreach (DataRow row in dtParent.Rows)
        {
            TreeNode child = new TreeNode
            {
                Text = row["ReportSection"].ToString(),
                Value = row["ReportId"].ToString()
            };
            if (parentId == 0)
            {
                TreeView1.Nodes.Add(child);

                //var strSQL = "SELECT '/' + ReportSection + '/' + ReportWithExtension as ReportId, ReportName as ReportSection from ReportList2 r2 " +
                //             "Inner Join ReportToGroup rtg on r2.ReportId = rtg.ReportId " + whereClause + " and ReportSection = '" + child.Text + "'";

                var strSQL = "SELECT '/' + ReportSection + '/' + ReportWithExtension as ReportId, ReportName as ReportSection FROM ReportList2 WHERE ReportSection = '" + child.Text + "'";

                DataTable dtChild = this.GetData(strSQL);
                PopulateTreeView(dtChild, 1, child, whereClause);
            }
            else
            {
                treeNode.ChildNodes.Add(child);
            }
        }

        TreeView1.CollapseAll();
    }

    private DataTable GetData(string query)
    {
        DataTable dt = new DataTable();

        clsADO thisADO = new clsADO();
        string constr = thisADO.getLocalConnectionString();

        using (SqlConnection con = new SqlConnection(constr))
        {
            using (SqlCommand cmd = new SqlCommand(query))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = con;
                    sda.SelectCommand = cmd;
                    sda.Fill(dt);
                }
            }
            return dt;
        }
    }

    protected void TreeView1_SelectedNodeChanged(object sender, EventArgs e)
    {
        ReportViewer1.Visible = true;

        ReportViewer1.ServerReport.ReportServerCredentials = new CustomReportCredentials("sqladmin", "DykwIa?Itmwg2bdyhwtl!", "pca");
        

        ReportViewer1.ProcessingMode = ProcessingMode.Remote;

        ServerReport serverReport = ReportViewer1.ServerReport;
        // Set the report server URL and report path
        serverReport.ReportServerUrl = new Uri("http://pca-sql1:80/ReportServer");

        string reportLocation = Convert.ToString(TreeView1.SelectedValue).Replace(".rdl", "");

        //serverReport.ReportPath = "/NewManager/General/ManagerAudit";
        serverReport.ReportPath = reportLocation;
    }

    private string getPortalGroups()
    {
        var user = Page.User.Identity.Name;

        //Create session variable with members groups
        string groupList = "";
        Boolean first = true;

        ArrayList groups = new ArrayList();

        groups = Groups();

        foreach (string group in groups)
        {
            if (first == true)
            {
                groupList = groupList + group;
                first = false;
            }
            else
            {
                groupList = groupList + ',' + group;
            }

        }

        string[] groupArray = groupList.Split(',');
        first = true;
        var whereClause = "";
        var thisGroup = "";

        foreach (string i in groupArray)
        {
            if (i.StartsWith("PCA\\Portal"))
            {
                if (first == true)
                {
                    thisGroup = i.Replace("PCA\\", "");
                    whereClause = "Where (rtg.ReportGroup = '" + thisGroup + "' ";
                    first = false;
                }
                else
                {
                    thisGroup = i.Replace("PCA\\", "");
                    whereClause = whereClause + "Or rtg.ReportGroup = '" + thisGroup + "' ";
                }
            }
        }

        if (whereClause != "")
        {
            whereClause = whereClause + ")";
        }

        return whereClause;
    }

    public ArrayList Groups()
    {
        ArrayList groups = new ArrayList();

        foreach (IdentityReference group in System.Web.HttpContext.Current.Request.LogonUserIdentity.Groups)
        {
            groups.Add(group.Translate(typeof(NTAccount)).ToString());
        }

        return groups;
    }
}
