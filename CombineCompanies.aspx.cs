using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class CombineCompanies : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [System.Web.Services.WebMethod]
    public static string combineCompany(string OriginCompanyId, string IntoCompanyId)
    {
        try
        {

            class_ADO.clsADO thisADO = new class_ADO.clsADO();

            SqlConnection cn = new SqlConnection();
            SqlCommand cmd = new SqlCommand();

            cn = new SqlConnection(thisADO.getLocalConnectionString());
            cn.Open();
            cmd = new SqlCommand("dbo.CombineCompaniesLocal");
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Connection = cn;
           
            
            SqlParameter thisOriginCompanyId = cmd.Parameters.Add(new SqlParameter("@OriginCompanyId", SqlDbType.NVarChar));
            SqlParameter thisIntoCompanyId = cmd.Parameters.Add(new SqlParameter("@IntoCompanyId", SqlDbType.NVarChar));

            thisOriginCompanyId.Value = OriginCompanyId;
            thisIntoCompanyId.Value = IntoCompanyId;

            using (SqlDataReader sdr = cmd.ExecuteReader())
            {
                while (sdr.Read())
                {
                    
                }
            }

            cn = new SqlConnection(thisADO.getMaxConnectionString());
            cn.Open();
            cmd = new SqlCommand("dbo.CombineCompanies");
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Connection = cn;


            thisOriginCompanyId = cmd.Parameters.Add(new SqlParameter("@OriginCompanyId", SqlDbType.NVarChar));
            thisIntoCompanyId = cmd.Parameters.Add(new SqlParameter("@IntoCompanyId", SqlDbType.NVarChar));

            thisOriginCompanyId.Value = OriginCompanyId;
            thisIntoCompanyId.Value = IntoCompanyId;

            using (SqlDataReader sdr = cmd.ExecuteReader())
            {
                while (sdr.Read())
                {
                    
                }
            }

            cn.Close();

            return "Complete";
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }
    }
}

