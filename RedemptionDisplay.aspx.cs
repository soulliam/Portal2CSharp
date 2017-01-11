using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QRCoder;
using System.Drawing;
using System.IO;
using System.Web.Services;

public partial class RedemptionDisplay : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string thisQRCode = Request.QueryString["thisQRCode"];
        string thisCertificateID = Request.QueryString["thisCertificateID"];
        string thisRedemptionType = Request.QueryString["thisRedemptionType"];
        string thisFPNumber = Request.QueryString["thisFPNumber"];
        string thisMemberName = Request.QueryString["thisMemberName"];

        RedemptionType.InnerHtml = "";
        CertificateID.InnerHtml = "";
        FPNumber.InnerHtml = "";
        MemberName.InnerHtml = "";

        RedemptionType.InnerHtml = thisRedemptionType;
        CertificateID.InnerHtml = thisCertificateID;
        FPNumber.InnerHtml = thisFPNumber;
        MemberName.InnerHtml = thisMemberName;

        GenerateQRCode(thisQRCode);
    }

    private void GenerateQRCode(string cert)
    {
        string code = cert;
        QRCodeGenerator qrGenerator = new QRCodeGenerator();
        QRCodeGenerator.QRCode qrCode = qrGenerator.CreateQrCode(code, QRCodeGenerator.ECCLevel.Q);
        System.Web.UI.WebControls.Image imgBarCode = new System.Web.UI.WebControls.Image();
        imgBarCode.Height = 135;
        imgBarCode.Width = 135;
        using (Bitmap bitMap = qrCode.GetGraphic(20))
        {
            using (MemoryStream ms = new MemoryStream())
            {
                bitMap.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
                byte[] byteImage = ms.ToArray();
                imgBarCode.ImageUrl = "data:image/png;base64," + Convert.ToBase64String(byteImage);
            }
            //plBarCode.Controls.Add(imgBarCode)
            MemberBarHolder.Controls.Add(imgBarCode);
        }
    }

    [WebMethod()]
    public static string sendReceipt(string imageData, string thisQRCode, string ToAddress)
    {
        var path = HttpContext.Current.Server.MapPath("~\\EmailImages\\" + thisQRCode + ".png");

        try
        {
            using (FileStream fs = new FileStream(path, FileMode.Create))
            {
                using (BinaryWriter bw = new BinaryWriter(fs))

                {

                    byte[] data = Convert.FromBase64String(imageData);

                    bw.Write(data);

                    bw.Close();

                    clsCommon thisEmail = new clsCommon();

                    //thisEmail.SendEmail("mgoode@thefastpark.com", "RFRTeam@thefastpark.com", "FastPark Redemption", "Attached is your FastPark redemption!", true, path);
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