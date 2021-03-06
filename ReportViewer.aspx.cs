﻿using Microsoft.Reporting.WebForms;
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


public partial class ReportViewer : System.Web.UI.Page
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

            var whereClause = getPortalGroups();

            if (whereClause != "")
            {
                var strSQL = "select Distinct(ReportSection) as ReportSection, 0 as ReportId from ReportList2 r2 " +
                         "Inner Join ReportToGroup rtg on r2.ReportId = rtg.ReportId " + whereClause;

                //var strSQL = "select Distinct(ReportSection) as ReportSection, 0 as ReportId from ReportList2 order by ReportSection ";

                DataTable dt = this.GetData(strSQL);
                this.PopulateTreeView(dt, 0, null, whereClause);
            }
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

                var strSQL = "SELECT '/' + ReportSection + '/' + ReportWithExtension as ReportId, ReportName as ReportSection from ReportList2 r2 " +
                             "Inner Join ReportToGroup rtg on r2.ReportId = rtg.ReportId " + whereClause + " and ReportSection = '" + child.Text + "' " +
                             "Group by ReportName, ReportWithExtension, ReportSection";

                //var strSQL = "SELECT '/' + ReportSection + '/' + ReportWithExtension as ReportId, ReportName as ReportSection FROM ReportList2 WHERE ReportSection = '" + child.Text + "'";

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
        var selectedNode = TreeView1.SelectedNode;

        var groups = getPortalGroups();

        if (selectedNode.Parent != null)
        {
            ReportViewer1.Visible = true;

            ReportViewer1.ServerReport.ReportServerCredentials = new CustomReportCredentials("sqladmin", "DykwIa?Itmwg2bdyhwtl!", "pca");

            ReportViewer1.ProcessingMode = ProcessingMode.Remote;

            ServerReport serverReport = ReportViewer1.ServerReport;
            // Set the report server URL and report path
            serverReport.ReportServerUrl =
            //new Uri("http://192.168.0.90:80/ReportServer");
            new Uri("http://pca-sql1:80/ReportServer");

            string reportLocation = Convert.ToString(TreeView1.SelectedValue).Replace(".rdl", "");

            if (reportLocation.Contains("Marketing") && !TreeView1.SelectedValue.Contains("Usage YTD_ByCompany")) {
                string ID = getRepID(Convert.ToString(Session["UserName"]));
                
                //string ID = "86";
                string userId = getOldPortalGuid(Convert.ToString(Session["UserName"]));

                TextBox1.Text = Convert.ToString(userId);

                ReportParameter[] parameters = new ReportParameter[2];

                //not sure we need the userloginId param.
                parameters[0] = new ReportParameter("UserLoginId", userId);
                parameters[1] = new ReportParameter("ID", ID);
                serverReport.ReportPath = reportLocation;
                serverReport.SetParameters(parameters);
            }
            else if (reportLocation.Contains("PCA"))
            {
                string group = Session["groupList"].ToString();
                string ID = "";

                string[] thisLocation;
                var thisGroups = group.Split(',');
                Boolean first = true;
                List<string> locationList = new List<string>();

                foreach (string locGroup in thisGroups)
                {
                    if (locGroup.IndexOf("\\PP_LOC_") > -1)
                    {
                        thisLocation = locGroup.Split('_');
                        ID = thisLocation[3];
                        if (first == true)
                        {
                            locationList.Add(ID);
                        }
                    }
                }

                ReportParameter[] parameters = new ReportParameter[2];

                string[] thisLocationArray = locationList.ToArray();

                parameters[0] = new ReportParameter("City", thisLocationArray);
                parameters[1] = new ReportParameter("UserLoginId", "00000000-0000-0000-0000-000000000000");

                serverReport.ReportPath = reportLocation;
                serverReport.SetParameters(parameters);
            }
            else if (reportLocation.Contains("FleetStatus"))
            {
                string group = Session["groupList"].ToString();
                string ID = "";
                string locationList = "";
                Boolean first = true;

                string[] thisLocation;
                var thisGroups = group.Split(',');
                foreach (string locGroup in thisGroups)
                {
                    if (locGroup.IndexOf("\\Vehicles_Loc_") > -1)
                    {
                        thisLocation = locGroup.Split('_');
                        ID = thisLocation[2];
                        if (first == true)
                        {
                            locationList = ID;
                            first = false;
                        }
                        else
                        {
                            locationList = locationList + ',' + ID;
                        }
                    }
                }
                
                string userId = getOldPortalGuid(Convert.ToString(Session["UserName"]));

                ReportParameter[] parameters = new ReportParameter[1];

                parameters[0] = new ReportParameter("LocationList", locationList);
                serverReport.ReportPath = reportLocation;
                serverReport.SetParameters(parameters);
            }
            else if (reportLocation.Contains("Vehicles") && groups.Contains("Portal_Mechanic"))
            {
                string group = Session["groupList"].ToString();
                string ID = "";
                string locationList = "";
                Boolean first = true;

                string[] thisLocation;
                var thisGroups = group.Split(',');
                foreach (string locGroup in thisGroups)
                {
                    if (locGroup.IndexOf("\\Vehicles_Loc_") > -1)
                    {
                        thisLocation = locGroup.Split('_');
                        ID = thisLocation[2];
                        if (first == true)
                        {
                            locationList = ID;
                            first = false;
                        }
                        else
                        {
                            locationList = locationList + ',' + ID;
                        }
                    }
                }

                string userId = getOldPortalGuid(Convert.ToString(Session["UserName"]));

                ReportParameter[] parameters = new ReportParameter[1];

                parameters[0] = new ReportParameter("LocationList", locationList);
                serverReport.ReportPath = reportLocation;
                serverReport.SetParameters(parameters);
            }
            else if (reportLocation.Contains("Manager"))
            {
                string group = Session["groupList"].ToString();
                string ID = "";
                string locationList = "";
                Boolean first = true;

                string[] thisLocation;
                var thisGroups = group.Split(',');
                foreach (string locGroup in thisGroups)
                {
                    if (locGroup.IndexOf("PCA\\\\Loc_") > -1)
                    {
                        thisLocation = locGroup.Split('_');
                        ID = thisLocation[2];
                        if (first == true)
                        {
                            locationList = ID;
                            first = false;
                        }
                        else
                        {
                            locationList = locationList + ',' + ID;
                        }
                    }
                }
               
                serverReport.ReportPath = reportLocation;

                if (reportLocation.Contains("/NewManager/General/InvoiceDateRangeCategory") || 
                    reportLocation.Contains("/NewManager/General/InvoiceProcessDate"))
                {
                    ReportParameter[] parameters = new ReportParameter[1];
                    parameters[0] = new ReportParameter("LocationList", locationList);
                    serverReport.SetParameters(parameters);
                }
            }
            else
            {
                ReportParameter[] parameters = new ReportParameter[1];
                string userId = getOldPortalGuid(Convert.ToString(Session["UserName"]));
                
                //not sure we need the userloginId param.
                parameters[0] = new ReportParameter("UserLoginId", userId);
                if (reportLocation.Contains("PMI"))
                {
                    TextBox1.Text = Convert.ToString(Session["UserName"]);
                }
                serverReport.ReportPath = reportLocation;
                serverReport.SetParameters(parameters);
            }
            
        }
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
                    whereClause = "Where IsViewable = 1 and (rtg.ReportGroup = '" + thisGroup + "' ";
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

    public string getRepID(string username)
    {
        clsADO thisADO = new clsADO();

        username = username.Replace("PCA\\", "");

        string strSQL = "Select ID from aspnetdb.dbo.aspnet_Users au " +
                        "Inner Join MarketingReps mr on au.UserId = mr.UserId " +
                        "Where au.UserName = '" + username + "'";
        //string strSQL = "Select ID from aspnetdb.dbo.aspnet_Users au " +
        //                "Inner Join MarketingReps mr on au.UserId = mr.UserId " +
        //                "Where au.UserName = 'sdissinger'";
        string RepId = Convert.ToString(thisADO.returnSingleValue(strSQL, false));

        return RepId;
    }

    public string getOldPortalGuid(string username)
    {
        clsADO thisADO = new clsADO();

        username = username.Replace("PCA\\", "");

        string strSQL = "Select UserId from aspnetdb.dbo.aspnet_Users au " +
                        "Where au.UserName = '" + username + "'";
        //string strSQL = "Select ID from aspnetdb.dbo.aspnet_Users au " +
        //                "Inner Join MarketingReps mr on au.UserId = mr.UserId " +
        //                "Where au.UserName = 'sdissinger'";
        string UserId = Convert.ToString(thisADO.returnSingleValue(strSQL, false));

        return UserId;
    }
}