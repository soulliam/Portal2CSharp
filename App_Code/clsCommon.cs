﻿using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Net.Mime;
using System.Web;
using QRCoder;
using class_Logging;


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

    public void SendEmail(string ToAddress, string From, string Subject, string Body, bool IsHtml, string file = "")
    {
        //(1) Create the MailMessage instance

        string[] Addresses = ToAddress.Split(',');

        MailMessage Message = new MailMessage(From, Addresses[0]);

        bool firstAddress = true;

        foreach (string thisAddress in Addresses)
        {
            if (firstAddress == true)
            {
                firstAddress = false;
            }
            else
            {
                Message.CC.Add(thisAddress);
            }
        }


        //(2) Assign the MailMessage's properties
        Message.Subject = Subject;
        Message.Body = Body;
        Message.IsBodyHtml = IsHtml;

        if (file != "")
        {
            Attachment data = new Attachment(file, MediaTypeNames.Application.Octet);
            Message.Attachments.Add(data);
        }


        //(3) Create the SmtpClient object
        SmtpClient smtp = new SmtpClient();

        //(4) Send the MailMessage (will use the Web.config settings)
        smtp.Host = "192.168.0.53";
        smtp.Send(Message);

        if (file != "")
        {
            Message.Attachments.Dispose();
        }
    }

    public System.Web.UI.WebControls.Image GenerateQRCode(string code)
    {

        QRCodeGenerator qrGenerator = new QRCodeGenerator();
        QRCodeData qrCodeData = qrGenerator.CreateQrCode(code, QRCodeGenerator.ECCLevel.Q);
        QRCode qrCode = new QRCode(qrCodeData);

        System.Web.UI.WebControls.Image imgBarCode = new System.Web.UI.WebControls.Image();
        imgBarCode.Height = 120;
        imgBarCode.Width = 120;

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

    public void sendEmailEmbedImage(string ToAddress, string From, string Subject, string Body, bool IsHtml, string file = "")
    {
        MailMessage Mail = new MailMessage();

        Mail.From = new MailAddress(From);
        Mail.To.Add(ToAddress);
        Mail.Subject = "FastPark Reservation.";
        Mail.Body = "Attached is your FastPark reservation.  Thank you.";
        LinkedResource LinkedImage = new LinkedResource(@file);
        LinkedImage.ContentId = "QRCode";
        //Added the patch for Thunderbird
        LinkedImage.ContentType = new ContentType(MediaTypeNames.Image.Jpeg);

        AlternateView htmlView = AlternateView.CreateAlternateViewFromString(
          Body,
          null, "text/html");

        htmlView.LinkedResources.Add(LinkedImage);
        Mail.AlternateViews.Add(htmlView);
        SmtpClient smtp = new SmtpClient("192.168.0.53", 25);
        try
        {
            smtp.Send(Mail);
        }
        catch (SmtpException ex)
        {
            
        }
    }

}