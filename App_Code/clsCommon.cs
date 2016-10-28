using QRCoder;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Web;

/// <summary>
/// Summary description for clsCommon
/// </summary>
public class clsCommon
{
    public clsCommon()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public void SendEmail(string ToAddress, string From, string Subject, string Body, bool IsHtml)
    {
        //(1) Create the MailMessage instance
        MailMessage Message = new MailMessage(From, ToAddress);

        //(2) Assign the MailMessage's properties
        Message.Subject = Subject;
        Message.Body = Body;
        Message.IsBodyHtml = IsHtml;

        //(3) Create the SmtpClient object
        SmtpClient smtp = new SmtpClient();

        //(4) Send the MailMessage (will use the Web.config settings)
        smtp.Host = "192.168.0.53";
        smtp.Send(Message);

    }

    public System.Web.UI.WebControls.Image GenerateQRCode(string code)
    {

        QRCodeGenerator qrGenerator = new QRCodeGenerator();
        QRCodeGenerator.QRCode qrCode = qrGenerator.CreateQrCode(code, QRCodeGenerator.ECCLevel.Q);
        System.Web.UI.WebControls.Image imgBarCode = new System.Web.UI.WebControls.Image();
        imgBarCode.Height = 125;
        imgBarCode.Width = 125;
        using (Bitmap bitMap = qrCode.GetGraphic(20))
        {
            using (MemoryStream ms = new MemoryStream())
            {
                bitMap.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
                byte[] byteImage = ms.ToArray();
                imgBarCode.ImageUrl = "data:image/png;base64," + Convert.ToBase64String(byteImage);
            }

            return imgBarCode;
        }
    }

}