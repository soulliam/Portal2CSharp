using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ExcelDataReader;
using class_ADO;

public partial class PCATagNumbers : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        alert.Visible = false;
    }

    protected void btnUpload_Click(object sender, EventArgs e)
    {
        int line = 0;

        try
        {
            if (FileUpload1.FileName == "")
            {
                alert.Visible = true;
                alert.Text = "Pick an Excel File!";
                return;
            }

            alert.Text = "";
            alert.Visible = false;

            using (var stream = FileUpload1.PostedFile.InputStream)
            {
                using (var reader = ExcelReaderFactory.CreateReader(stream))
                {
                    do
                    {
                        while (reader.Read())
                        {
                            if (line > 6)
                            {
                                var thisADO = new clsADO();

                                string strSQL = "Update ParkPlaceStageMar2019.dbo.Payment Set PermitTagNumber = '" + reader.GetValue(9) + "' Where PaymentID = " + reader.GetValue(10);

                                //thisADO.updateOrInsert(strSQL, true);

                                strSQL = "Select PermitID From ParkPlaceStageMar2019.dbo.Payment Where PaymentID = " + reader.GetValue(10);

                                string thisPermitID = thisADO.returnSingleValue(strSQL, true).ToString();

                                strSQL = "Update ParkPlaceStageMar2019.dbo.Permit Set PermitNumber = '" + reader.GetValue(8) + "' Where PermitID = " + thisPermitID;

                                //thisADO.updateOrInsert(strSQL, true);
                            }

                            line = line + 1;
                        }
                    } while (reader.NextResult());

                }
            }

            alert.Visible = true;
            alert.Text = "Finished!";
        }
        catch (Exception ex)
        {
            alert.Visible = true;
            alert.Text = ex.ToString();
        }
    }
}