using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using class_ADO;
using System.Data.SqlClient;
using System.Data;
using System.IO;

public partial class InsuranceIncidentReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string IncidentID = Request.QueryString["IncidentID"];

        if (IncidentID != null)
        {
            try
            {
                var thisADO = new clsADO();

                string checkFolders = "Select l.LocationName + '-' + l.LocationGLCode as Location, 'PCA ' + i.IncidentNumber as Incident, i.IncidentNumber + '-' + c.ClaimNumber as Claim, 'WC ' + wc.WCClaimNumber as WC, wc.WCClaimNumber + '-01' as WCClaim " +
                                        "from InsurancePCA.dbo.Incident i " +
                                        "Left Outer Join InsurancePCA.dbo.Location l on i.LocationId = l.LocationID " +
                                        "Left Outer Join InsurancePCA.dbo.Claim c on i.IncidentID = c.IncidentID " +
                                        "Left Outer Join InsurancePCA.dbo.WCClaim wc on c.ClaimID = wc.ClaimID " +
                                        "Where i.IncidentID = " + IncidentID;
                string conn = thisADO.getLocalConnectionString();

                using (SqlConnection connection = new SqlConnection(conn))
                {
                    SqlCommand command = new SqlCommand(checkFolders, connection);
                    connection.Open();

                    SqlDataReader reader = command.ExecuteReader();

                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            string SQL = "Select CredUserName, CredPassword from InsurancePCA.dbo.Cred";

                            List<clsADO.sql2DObject> thisPassInfo = new List<clsADO.sql2DObject>();
                            thisPassInfo = thisADO.return2DListLocal(SQL, false);

                            ImpersonationHelper.Impersonate("PCA", clsCrypt.Decrypt(thisPassInfo[0].one.ToString()), clsCrypt.Decrypt(thisPassInfo[0].two.ToString()), delegate
                            {
                                string Dir = @"\\pca-file\PCA Portal Claims\1_New PCA Portal Claims\PCA Liability - Incidents&Claims\" + reader[0];

                                Dir = Dir + "\\" + reader[1];
                                if (!Directory.Exists(Dir))
                                {
                                    Directory.CreateDirectory(Dir);
                                }

                                Dir = Dir + "\\" + reader[2];
                                if (!Directory.Exists(Dir))
                                {
                                    Directory.CreateDirectory(Dir);
                                }

                                if (reader[3].GetType().Name != "DBNull")
                                {
                                    Dir = @"\\pca-file\PCA Portal Claims\1_New PCA Portal Claims\PCA Workers Compensation - Incidents&Claims\" + reader[0];
                                    Dir = Dir + "\\" + reader[3];
                                    if (!Directory.Exists(Dir))
                                    {
                                        Directory.CreateDirectory(Dir);
                                    }

                                    Dir = Dir + "\\" + reader[4];
                                    if (!Directory.Exists(Dir))
                                    {
                                        Directory.CreateDirectory(Dir);
                                    }
                                }
                            });
                        }
                    }
                    else
                    {
                        Console.WriteLine("No rows found.");
                    }
                    reader.Close();
                }
            }
            catch(Exception ex)
            {
                
            }
        }
    }

}