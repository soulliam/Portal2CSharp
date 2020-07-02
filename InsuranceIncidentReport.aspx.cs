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

                string checkFolders = "SELECT l.LocationName + '-' + l.LocationGLCode AS Location, 'PCA ' + i.IncidentNumber AS Incident, i.IncidentNumber + '-' + c.ClaimNumber AS Claim, 'WC ' + wc.WCClaimNumber AS WC, wc.WCClaimNumber + '-01' AS WCClaim " +
                                        "FROM InsurancePCA.dbo.Incident AS i " +
                                        "LEFT OUTER JOIN InsurancePCA.dbo.Location AS l ON i.LocationId = l.LocationID " +
                                        "LEFT OUTER JOIN InsurancePCA.dbo.Claim AS c ON i.IncidentID = c.IncidentID " +
                                        "Left Outer JOIN InsurancePCA.dbo.WCInvestigation AS wci ON c.ClaimID = wci.ClaimID " +
                                        "LEFT OUTER JOIN InsurancePCA.dbo.WCClaim AS wc ON wci.WCInvestigationID = wc.WCInvestigationID " +
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