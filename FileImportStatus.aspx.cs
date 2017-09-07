using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using class_ADO;
using System.Data.SqlClient;
using System.Data;

public partial class FileStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //todaysdate.Text = DateTime.Now.ToShortDateString();
        clsADO thisADO = new clsADO();

        string strSQL = "select Max(dateTimeOfTransaction) as MaxDate, LocationId " +
                    "from ParkingPaymentTransactions " +
                    "Group by Locationid";

        DataSet ds = new DataSet();

        SqlConnection connection = new SqlConnection(thisADO.getLocalConnectionString());
        SqlDataAdapter adapter = new SqlDataAdapter(strSQL, connection);

        adapter.Fill(ds);

        adapter.Fill(ds, "ParkingPaymentTransactions");
        DataTable dt = ds.Tables[0];


        foreach (DataRow row in dt.Rows)
        {

            switch (Convert.ToInt32(row[1]))
            {
                case 1:
                    if (string.Equals(Convert.ToDateTime(row[0]).ToShortDateString(), DateTime.Today.AddDays(-1).ToShortDateString()) != true)
                    {
                        ABQLast.ForeColor = System.Drawing.Color.Red;
                        ABQLast.Font.Bold = true;
                    }
                    ABQLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 2:
                    if (string.Equals(Convert.ToDateTime(row[0]).ToShortDateString(), DateTime.Today.AddDays(-1).ToShortDateString()) != true)
                    {
                        AUSLast.ForeColor = System.Drawing.Color.Red;
                        AUSLast.Font.Bold = true;
                    }
                    AUSLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 3:
                    if (string.Equals(Convert.ToDateTime(row[0]).ToShortDateString(), DateTime.Today.AddDays(-1).ToShortDateString()) != true)
                    {
                        BWI1Last.ForeColor = System.Drawing.Color.Red;
                        BWI1Last.Font.Bold = true;
                    }
                    BWI1Last.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 4:
                    if (string.Equals(Convert.ToDateTime(row[0]).ToShortDateString(), DateTime.Today.AddDays(-1).ToShortDateString()) != true)
                    {
                        BWI2Last.ForeColor = System.Drawing.Color.Red;
                        BWI2Last.Font.Bold = true;
                    }
                    BWI2Last.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 6:
                    if (string.Equals(Convert.ToDateTime(row[0]).ToShortDateString(), DateTime.Today.AddDays(-1).ToShortDateString()) != true)
                    {
                        CLEAFPLast.ForeColor = System.Drawing.Color.Red;
                        CLEAFPLast.Font.Bold = true;
                    }
                    CLEAFPLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 7:
                    if (string.Equals(Convert.ToDateTime(row[0]).ToShortDateString(), DateTime.Today.AddDays(-1).ToShortDateString()) != true)
                    {
                        CLEPPLast.ForeColor = System.Drawing.Color.Red;
                        CLEPPLast.Font.Bold = true;
                    }
                    CLEPPLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 9:
                    if (string.Equals(Convert.ToDateTime(row[0]).ToShortDateString(), DateTime.Today.AddDays(-1).ToShortDateString()) != true)
                    {
                        CVG2Last.ForeColor = System.Drawing.Color.Red;
                        CVG2Last.Font.Bold = true;
                    }
                    CVG2Last.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 10:
                    if (string.Equals(Convert.ToDateTime(row[0]).ToShortDateString(), DateTime.Today.AddDays(-1).ToShortDateString()) != true)
                    {
                        RDULast.ForeColor = System.Drawing.Color.Red;
                        RDULast.Font.Bold = true;
                    }
                    RDULast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 11:
                    if (string.Equals(Convert.ToDateTime(row[0]).ToShortDateString(), DateTime.Today.AddDays(-1).ToShortDateString()) != true)
                    {
                        TUCLast.ForeColor = System.Drawing.Color.Red;
                        TUCLast.Font.Bold = true;
                    }
                    TUCLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 12:
                    if (string.Equals(Convert.ToDateTime(row[0]).ToShortDateString(), DateTime.Today.AddDays(-1).ToShortDateString()) != true)
                    {
                        MCOLast.ForeColor = System.Drawing.Color.Red;
                        MCOLast.Font.Bold = true;
                    }
                    MCOLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 13:
                    if (string.Equals(Convert.ToDateTime(row[0]).ToShortDateString(), DateTime.Today.AddDays(-1).ToShortDateString()) != true)
                    {
                        MKELast.ForeColor = System.Drawing.Color.Red;
                        MKELast.Font.Bold = true;
                    }
                    MKELast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 15:
                    if (string.Equals(Convert.ToDateTime(row[0]).ToShortDateString(), DateTime.Today.AddDays(-1).ToShortDateString()) != true)
                    {
                        MEMLast.ForeColor = System.Drawing.Color.Red;
                        MEMLast.Font.Bold = true;
                    }
                    MEMLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 16:
                    if (string.Equals(Convert.ToDateTime(row[0]).ToShortDateString(), DateTime.Today.AddDays(-1).ToShortDateString()) != true)
                    {
                        HWCLast.ForeColor = System.Drawing.Color.Red;
                        HWCLast.Font.Bold = true;
                    }
                    HWCLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 17:
                    if (string.Equals(Convert.ToDateTime(row[0]).ToShortDateString(), DateTime.Today.AddDays(-1).ToShortDateString()) != true)
                    {
                        INDLast.ForeColor = System.Drawing.Color.Red;
                        INDLast.Font.Bold = true;
                    }
                    INDLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 18:
                    if (string.Equals(Convert.ToDateTime(row[0]).ToShortDateString(), DateTime.Today.AddDays(-1).ToShortDateString()) != true)
                    {
                        ATLLast.ForeColor = System.Drawing.Color.Red;
                        ATLLast.Font.Bold = true;
                    }
                    ATLLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 20:
                    if (string.Equals(Convert.ToDateTime(row[0]).ToShortDateString(), DateTime.Today.AddDays(-1).ToShortDateString()) != true)
                    {
                        HOULast.ForeColor = System.Drawing.Color.Red;
                        HOULast.Font.Bold = true;
                    }
                    HOULast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                default:
                    Response.Write("Something's Wrong Here");
                    break;
            }

        }

    }
}