using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QRCoder;
using System.Drawing;
using System.IO;
public partial class RedemptionDisplay : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string thisQRCode = Request.QueryString["thisQRCode"];
        string thisCertificateID = Request.QueryString["thisCertificateID"];
        string thisRedemptionType = Request.QueryString["thisRedemptionType"];
        string thisFPNumber = Request.QueryString["thisFPNumber"];
        string thisMemberName = Request.QueryString["thisMemberName"];


        GenerateQRCode(thisQRCode);
    }

    private void GenerateQRCode(string cert)
    {
        string code = cert;
        QRCodeGenerator qrGenerator = new QRCodeGenerator();
        QRCodeData qrCodeData = qrGenerator.CreateQrCode(cert, QRCodeGenerator.ECCLevel.Q);
        QRCode qrCode = new QRCode(qrCodeData);

        System.Web.UI.WebControls.Image imgBarCode = new System.Web.UI.WebControls.Image();
        imgBarCode.Height = 200;
        imgBarCode.Width = 200;

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
}