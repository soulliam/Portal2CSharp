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
using System.Net.Mail;
using System.Net.Mime;
public partial class CardDisplay : System.Web.UI.Page
{
    string gblQRPath = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        string thisMemberName = Request.QueryString["memberName"];
        string thisCardNumber = Request.QueryString["cardNumber"];
        string thisMemberSinceYear = Request.QueryString["memberSinceYear"];
        string thisMemberEmailAddress = Request.QueryString["memberEmailAddress"];

        memberName.Text = thisMemberName;
        memberSince.Text = thisMemberSinceYear;
        string shortCardNumber = thisCardNumber.Substring(thisCardNumber.Length - 8);
        cardNumber.Text = shortCardNumber;

        GenerateQRCode(thisCardNumber);
    }

    private void GenerateQRCode(string reservationNumber)
    {
        EmailQR.Width = 110;
        EmailQR.Height = 110;

        QRCodeGenerator qrGenerator = new QRCodeGenerator();
        QRCodeData qrCodeData = qrGenerator.CreateQrCode(reservationNumber, QRCodeGenerator.ECCLevel.Q);
        QRCode qrCode = new QRCode(qrCodeData);

        System.Web.UI.WebControls.Image imgBarCode = new System.Web.UI.WebControls.Image();
        imgBarCode.Height = 135;
        imgBarCode.Width = 135;
        byte[] byteImage = null;

        using (Bitmap bitMap = qrCode.GetGraphic(20))
        {
            using (MemoryStream ms = new MemoryStream())
            {
                bitMap.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
                byteImage = ms.ToArray();
                imgBarCode.ImageUrl = "data:image/Jpeg;base64," + Convert.ToBase64String(byteImage);
                gblQRPath = "data:image/Jpeg;base64," + Convert.ToBase64String(byteImage);
            }
            ////plBarCode.Controls.Add(imgBarCode)
            //MemberBarHolder.Controls.Add(imgBarCode);

            try
            {
                using (FileStream fs = new FileStream(HttpContext.Current.Server.MapPath("~\\EmailImages\\" + reservationNumber + ".Jpeg"), FileMode.Create))
                {
                    using (BinaryWriter bw = new BinaryWriter(fs))

                    {

                        byte[] data = byteImage;

                        bw.Write(data);

                        bw.Close();
                    }
                }

            }
            catch (Exception ex)
            {
                Console.Write(ex.ToString());
            }

            var path = HttpContext.Current.Server.MapPath("~\\EmailImages\\" + reservationNumber + ".Jpeg");

            using (System.Drawing.Image original = System.Drawing.Image.FromFile(path))
            {
                int newHeight = original.Height / 4;
                int newWidth = original.Width / 4;

                using (System.Drawing.Bitmap newPic = new System.Drawing.Bitmap(newWidth, newHeight))
                {
                    using (System.Drawing.Graphics gr = System.Drawing.Graphics.FromImage(newPic))
                    {
                        gr.DrawImage(original, 0, 0, (newWidth), (newHeight));
                        string newFilename = HttpContext.Current.Server.MapPath("~\\EmailImages\\" + reservationNumber + "_Send.Jpeg");
                        newPic.Save(newFilename, System.Drawing.Imaging.ImageFormat.Jpeg);
                    }
                }
            }

            EmailQR.Attributes["src"] = "./EmailImages/" + reservationNumber + ".Jpeg";
            EmailCard.Attributes["src"] = "./Images/CardImage.jpg";
            EmailCardBottom.Attributes["src"] = "./Images/CardImageBottom.jpg";
        }
    }

    [WebMethod()]
    public static string sendReceipt(string body, string thisCard, string ToAddress)
    {
        var path = HttpContext.Current.Server.MapPath("~\\EmailImages\\" + thisCard + ".Jpeg");
        var pathSend = HttpContext.Current.Server.MapPath("~\\EmailImages\\" + thisCard + "_Send.Jpeg");
        var CardPath = HttpContext.Current.Server.MapPath("~\\Images\\CardImage.jpg");
        var CardPathBottom = HttpContext.Current.Server.MapPath("~\\Images\\CardImageBottom.jpg");

        MailMessage Mail = new MailMessage();

        Mail.From = new MailAddress("rfrteam@thefastpark.com");
        Mail.To.Add("mgoode@thefastpark.com");
        //Mail.To.Add("mikegoode@gmail.com");
        //Mail.To.Add(ToAddress);
        Mail.Subject = "FastPark Reservation";
        Mail.Body = "";
        LinkedResource LinkedImage = new LinkedResource(@pathSend);
        LinkedResource LinkedImage2 = new LinkedResource(@CardPath);
        LinkedResource LinkedImage3 = new LinkedResource(@CardPathBottom);
        LinkedImage.ContentId = "MyPic";
        LinkedImage2.ContentId = "MyPic2";
        LinkedImage3.ContentId = "MyPic3";
        //Added the patch for Thunderbird as suggested by Jorge
        LinkedImage.ContentType = new ContentType(MediaTypeNames.Image.Jpeg);
        LinkedImage2.ContentType = new ContentType(MediaTypeNames.Image.Jpeg);
        LinkedImage3.ContentType = new ContentType(MediaTypeNames.Image.Jpeg);

        AlternateView htmlView = AlternateView.CreateAlternateViewFromString(
          body,
          null, "text/html");

        htmlView.LinkedResources.Add(LinkedImage);
        htmlView.LinkedResources.Add(LinkedImage2);
        htmlView.LinkedResources.Add(LinkedImage3);
        Mail.AlternateViews.Add(htmlView);
        SmtpClient smtp = new SmtpClient("192.168.0.53", 25);

        if (System.IO.File.Exists(path)) System.IO.File.Delete(path);


        try
        {
            smtp.Send(Mail);
            smtp.Dispose();
            LinkedImage.Dispose();
            if (System.IO.File.Exists(pathSend)) System.IO.File.Delete(pathSend);
            return "Sent!";

        }
        catch (SmtpException ex)
        {
            return ex.ToString();

        }
    }
}