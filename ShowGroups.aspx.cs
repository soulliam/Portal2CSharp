using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ShowGroups : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [System.Web.Services.WebMethod]
    public static string SendEmail(string ToAddress, string From, string Subject, string Body, bool IsHtml)
    {
        try
        {
            clsCommon thisEmail = new clsCommon();

            thisEmail.SendEmail(ToAddress, From, Subject, Body, IsHtml);

            return "Email Sent!";
        }
        catch (Exception ex)
        {
            return (Convert.ToString(ex));
        }
    }
}