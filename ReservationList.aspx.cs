using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using class_Logging;

public partial class ReservationList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [System.Web.Services.WebMethod]
    public static string LogSetComplete(string thisUserName, string thisMemberId, string thisOld, string thisNew)
    {
        try
        {
            clsLogging LogSetComplete = new clsLogging();

            LogSetComplete.logChange(thisUserName, thisMemberId, thisOld, thisNew, "Reservation", "Set Reservation Complete", LogSetComplete.getBatch());
            return "Request Made";
        }
        catch (Exception ex)
        {
            return Convert.ToString(ex);
        }
    }
}