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

        if (!IsPostBack) {
            try
            {
                ReportViewer1.Visible = false;

                clsADO thisADO = new clsADO();
                string constr = thisADO.getLocalConnectionString();

                using (SqlConnection con = new SqlConnection(constr))
                {
                    using (SqlCommand cmd = new SqlCommand("select ReportName, '/' + ReportSection + '/' + ReportWithExtension as ReportLocation from reportlist order by ReportName"))
                    {
                        cmd.CommandType = CommandType.Text;
                        cmd.Connection = con;
                        con.Open();
                        ddlReports.DataSource = cmd.ExecuteReader();
                        ddlReports.DataTextField = "ReportName";
                        ddlReports.DataValueField = "ReportLocation";
                        ddlReports.DataBind();
                        con.Close();
                    }
                }
                ddlReports.Items.Insert(0, new ListItem("--Select Report--", "0"));
            }
            catch (Exception ex)
            {
                Console.Write(ex.ToString());
            }
            
            
        }
        
    }

    protected void ddlReports_SelectedIndexChanged(object sender, EventArgs e)
    {
        ReportViewer1.Visible = true;

        ReportViewer1.ServerReport.ReportServerCredentials = new CustomReportCredentials("sqladmin", "DykwIa?Itmwg2bdyhwtl!", "pca");

        ReportViewer1.ProcessingMode = ProcessingMode.Remote;

        ServerReport serverReport = ReportViewer1.ServerReport;
        // Set the report server URL and report path
        serverReport.ReportServerUrl =
        new Uri("http://192.168.0.90:80/ReportServer");

        string reportLocation = Convert.ToString(ddlReports.SelectedValue).Replace(".rdl", "");

        //serverReport.ReportPath = "/NewManager/General/ManagerAudit";
        serverReport.ReportPath = reportLocation;
    }
}
