using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;



public partial class ReceiptDisplay : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod()]
    public static string sendReceipt(string imageData, string parkingTransactionNumber, string ToAddress)
    {
        string fileName = string.Format("text-{0:yyyy-MM-dd_hh-mm-ss-tt}.bin", DateTime.Now);
        var path = HttpContext.Current.Server.MapPath("~\\EmailImages\\" + parkingTransactionNumber + ".png");

        try
        {
            using (FileStream fs = new FileStream(HttpContext.Current.Server.MapPath("~\\EmailImages\\" + parkingTransactionNumber + ".png"), FileMode.Create))
            {
                using (BinaryWriter bw = new BinaryWriter(fs))

                {

                    byte[] data = Convert.FromBase64String(imageData);

                    bw.Write(data);

                    bw.Close();

                    clsCommon thisEmail = new clsCommon();

                    //thisEmail.SendEmail("mgoode@thefastpark.com", "RFRTeam@thefastpark.com", "FastPark Receipt", "Attached is your FastPark receipt", true, path);
                    thisEmail.SendEmail(ToAddress, "RFRTeam@thefastpark.com", "FastPark Receipt", "Attached is your FastPark receipt", true, path);
                }
            }


            //var fileDel = new FileInfo(path);
            //fileDel.Delete();

            return "Sent!";
            
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }
    }

}