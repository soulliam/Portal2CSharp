using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using class_Logging;

public partial class Invoices : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [System.Web.Services.WebMethod]
    public static string logLocationChange(string thisUserName, string thisInvoiceId)
    {
        try
        {

            clsLogging logLocationChange = new clsLogging();

            logLocationChange.logChange(thisUserName, "", thisInvoiceId, "", "", "Delete Invoice", logLocationChange.getBatch());

            return "Sucsses";
        }
        catch (Exception ex)
        {
            return Convert.ToString(ex);
        }
    }
}