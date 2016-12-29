using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

public partial class Reports : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //ReportViewer1.ServerReport.ReportServerCredentials = new CustomReportCredentials("sqladmin", "DykwIa?Itmwg2bdyhwtl!", "pca");

        //ReportViewer1.ProcessingMode = ProcessingMode.Remote;

        //ServerReport serverReport = ReportViewer1.ServerReport;

        //// Set the report server URL and report path
        //serverReport.ReportServerUrl =
        //new Uri("http://192.168.0.90:80/ReportServer");



        //serverReport.ReportPath = "/NewManager/General/ReservationEntryExitOnLot";



    }
}