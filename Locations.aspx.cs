using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using class_Logging;

public partial class Locations : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [System.Web.Services.WebMethod]
    public static string logLocationChange(string thisUserName, string thisLocation)
    {
        try
        {

            clsLogging logLocationChange = new clsLogging();

            logLocationChange.logChange(thisUserName, "", thisLocation, "", "", "Location Update", logLocationChange.getBatch());

            return "Sucsses";
        }
        catch (Exception ex)
        {
            return Convert.ToString(ex);
        }
    }
}