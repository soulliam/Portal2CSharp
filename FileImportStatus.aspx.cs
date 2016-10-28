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

        SqlConnection connection = new SqlConnection(thisADO.getMaxConnectionString());
        SqlDataAdapter adapter = new SqlDataAdapter(strSQL, connection);

        adapter.Fill(ds);

        adapter.Fill(ds, "ParkingPaymentTransactions");
        DataTable dt = ds.Tables[0];


        foreach (DataRow row in dt.Rows)
        {

            switch (Convert.ToInt32(row[1]))
            {
                case 1:
                    ABQLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 2:
                    AUSLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 3:
                    BWI1Last.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 4:
                    BWI2Last.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 5:
                    CVG1Last.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 6:
                    CLEAFPLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 7:
                    CLEPPLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 8:
                    break;
                //Do Nothing
                case 9:
                    CVG2Last.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 10:
                    RDULast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 11:
                    TUCLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 12:
                    MCOLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 13:
                    MKELast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 14:
                    MIALast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 15:
                    MEMLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 16:
                    HWCLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 17:
                    INDLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                case 18:
                    ATLLast.Text = Convert.ToDateTime(row[0]).ToShortDateString();
                    break;
                default:
                    Response.Write("Something's Wrong Here");
                    break;
            }
    
        }
        
    }
}