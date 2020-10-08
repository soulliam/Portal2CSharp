using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;

public partial class Booth_ReservationReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string LocationId = Request.QueryString["LocationId"];

        ReportViewer1.Visible = true;

        ReportViewer1.ServerReport.ReportServerCredentials = new CustomReportCredentials("sqladmin", "DykwIa?Itmwg2bdyhwtl!", "pca");

        ReportViewer1.ProcessingMode = ProcessingMode.Remote;

        ServerReport serverReport = ReportViewer1.ServerReport;
        // Set the report server URL and report path
        serverReport.ReportServerUrl =
        //new Uri("http://192.168.0.90:80/ReportServer");
        new Uri("http://pca-sql1:80/ReportServer");

        string reportLocation = "/Reservations/ReservationByHalfHour";

        ReportParameter[] parameters = new ReportParameter[1];

        //not sure we need the userloginId param.
        parameters[0] = new ReportParameter("LocationId", LocationId);
        serverReport.ReportPath = reportLocation;
        serverReport.SetParameters(parameters);
    }
}