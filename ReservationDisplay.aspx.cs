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


public partial class ReservationDisplay : System.Web.UI.Page
{
    string gblQRPath = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        string thisMemberName = Request.QueryString["thisMemberName"];
        string thisEmailAddress = Request.QueryString["thisEmailAddress"];
        string thisLocation = Request.QueryString["thisLocation"];
        string thisBrand = Request.QueryString["thisBrand"];
        string thisStartDate = Request.QueryString["thisStartDate"];
        string thisEndDate = Request.QueryString["thisEndDate"];
        string thisReservationNumber = Request.QueryString["thisReservationNumber"];
        string thisEstCost = Request.QueryString["thisEstCost"];
        string thisManager = Request.QueryString["thisManager"];
        string thisManagerEmail = Request.QueryString["thisManagerEmail"];
        string thisLocationAddress = Request.QueryString["thisLocationAddress"];
        string thisLocationCity = Request.QueryString["thisLocationCity"];
        string thisLocationZipCode = Request.QueryString["thisLocationZipCode"];
        string thisManagerState = Request.QueryString["thisManagerState"];
        string thisManagerPhone = Request.QueryString["thisManagerPhone"];
        string thisCard = Request.QueryString["thisCard"];

        MemberName.InnerHtml = "";
        emailAddress.InnerHtml = "";
        location.InnerHtml = "";
        brand.InnerHtml = "";
        startDate.InnerHtml = "";
        endDate.InnerHtml = "";
        reservationNumber.InnerHtml = "";
        estCost.InnerHtml = "";

        txtManagerPhone.Text = thisManagerPhone;
        txtManagerState.Text = thisManagerState;
        txtManagerZip.Text = thisLocationZipCode;
        txtManagerCity.Text = thisLocationCity;
        txtManagerAddress.Text = thisLocationAddress;
        txtManagerEmail.Text = thisManagerEmail;
        txtManager.Text = thisManager;
        txtManagerBrand.Text = thisBrand;
        MemberName.InnerHtml = thisMemberName;
        emailAddress.InnerHtml = thisEmailAddress;
        emailAddress.HRef = "mailto:" + thisEmailAddress;
        location.InnerHtml = thisLocation;
        brand.InnerHtml = thisBrand;
        startDate.InnerHtml = thisStartDate;
        endDate.InnerHtml = thisEndDate;
        reservationNumber.InnerHtml = thisReservationNumber;
        estCost.InnerHtml = thisEstCost;

        GenerateQRCode(thisCard);
    }

    private void GenerateQRCode(string reservationNumber)
    {
        EmailQR.Width = 200;
        EmailQR.Height = 200;

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
        }
    }

    [WebMethod()]
    public static string sendReceipt(string body, string thisCard, string ToAddress)
    {
        var path = HttpContext.Current.Server.MapPath("~\\EmailImages\\" + thisCard + ".Jpeg");
        var pathSend = HttpContext.Current.Server.MapPath("~\\EmailImages\\" + thisCard + "_Send.Jpeg");

        MailMessage Mail = new MailMessage();

        Mail.From = new MailAddress("rfrteam@thefastpark.com");
        //Mail.To.Add("mgoode@thefastpark.com");
        Mail.To.Add(ToAddress);
        Mail.Subject = "FastPark Reservation";
        Mail.Body = "";
        LinkedResource LinkedImage = new LinkedResource(@pathSend);
        LinkedImage.ContentId = "MyPic";
        //Added the patch for Thunderbird as suggested by Jorge
        LinkedImage.ContentType = new ContentType(MediaTypeNames.Image.Jpeg);

        AlternateView htmlView = AlternateView.CreateAlternateViewFromString(
          body,
          null, "text/html");

        htmlView.LinkedResources.Add(LinkedImage);
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

        


        //try
        //{
        //    using (FileStream fs = new FileStream(path, FileMode.Create))
        //    {
        //        using (BinaryWriter bw = new BinaryWriter(fs))

        //        {

        //            byte[] data = Convert.FromBase64String(imageData);

        //            bw.Write(data);

        //            bw.Close();

        //            clsCommon thisEmail = new clsCommon();

        //            thisEmail.SendEmail("mgoode@thefastpark.com", "RFRTeam@thefastpark.com", "FastPark Reservation", "Attached is your FastPark Rservation.  Thank you.", true, path);
        //            //thisEmail.SendEmail(ToAddress, "RFRTeam@thefastpark.com", "FastPark Reservation", "Attached is your FastPark Rservation.  Thank you.", true, path);
        //        }
        //    }


        //    //var fileDel = new FileInfo(path);
        //    //fileDel.Delete();

        //    return "Sent!";

        //}
        //catch (Exception ex)
        //{
        //    return ex.ToString();
        //}

    }
}