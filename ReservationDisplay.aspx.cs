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


public partial class ReservationDisplay : System.Web.UI.Page
{
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

        MemberName.InnerHtml = "";
        emailAddress.InnerHtml = "";
        location.InnerHtml = "";
        brand.InnerHtml = "";
        startDate.InnerHtml = "";
        endDate.InnerHtml = "";
        reservationNumber.InnerHtml = "";
        estCost.InnerHtml = "";

        MemberName.InnerHtml = thisMemberName;
        emailAddress.InnerHtml = thisEmailAddress;
        location.InnerHtml = thisLocation;
        brand.InnerHtml = thisBrand;
        startDate.InnerHtml = thisStartDate;
        endDate.InnerHtml = thisEndDate;
        reservationNumber.InnerHtml = thisReservationNumber;
        estCost.InnerHtml = thisEstCost;

        GenerateQRCode(thisReservationNumber);
    }

    private void GenerateQRCode(string reservationNumber)
    {
        QRCodeGenerator qrGenerator = new QRCodeGenerator();
        QRCodeData qrCodeData = qrGenerator.CreateQrCode(reservationNumber, QRCodeGenerator.ECCLevel.Q);
        QRCode qrCode = new QRCode(qrCodeData);

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

                    thisEmail.SendEmail("mgoode@thefastpark.com", "RFRTeam@thefastpark.com", "FastPark Reservation", "Attached is your FastPark Rservation.  Thank you.", true, path);
                    //thisEmail.SendEmail(ToAddress, "RFRTeam@thefastpark.com", "FastPark Reservation", "Attached is your FastPark Rservation.  Thank you.", true, path);
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