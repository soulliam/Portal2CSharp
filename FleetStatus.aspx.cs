using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using class_ADO;
using System.Data.SqlClient;

public partial class FleetStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [System.Web.Services.WebMethod]
    public static string SendEmail(string body, Int32 LocationId)
    {
        string Addresses = "";
        try
        {
            clsADO thisADO = new clsADO();

            string strSQL = "Select * from Vehicles.dbo.FleetStatusEmail where FleetStatusEmailLocationId = " + LocationId;

            string conn = thisADO.getLocalConnectionString();

            using (SqlConnection con = new SqlConnection(conn))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = strSQL;
                    cmd.Connection = con;
                    con.Open();
                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        if (sdr.HasRows != false)
                        {
                            Boolean first = true;
                            while (sdr.Read())
                            {
                                if (first == true)
                                {
                                    Addresses = sdr[1].ToString();
                                }
                                else
                                {
                                    Addresses = Addresses +  "," + sdr[1].ToString();
                                }
                                first = false;
                            }
                        }
                    }
                }
            }

            clsCommon thisEmail = new clsCommon();
            //thisEmail.SendEmail("mgoode@thefastpark.com", "mgoode@thefastpark.com", "Fleet Status Changed", body, true);
            thisEmail.SendEmail(Addresses, "pca_reporting@pca-star.com", "Fleet Status Changed", body, true);


            return "Sent!";

        }
        catch (Exception ex)
        {
            return ex.ToString();
        }
    }
}